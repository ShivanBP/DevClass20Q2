public class OpportunityTriggerHelper {
    public static void checkStageRules(List<Opportunity> triggerNew){
        Map<String, StageRules__c> mapStageRules = StageRules__c.getAll();	
        Set<Id> idList = new Set<Id>();
        
        for(Opportunity opp : triggerNew){        	
            if(mapStageRules.containsKey(opp.StageName)){
                idList.add(opp.Id);
            }        
        }
        
        List<OpportunityContactRole> oppContactRoleList = [SELECT Opportunity.Id, Role 
                                                           FROM OpportunityContactRole 
                                                           WHERE Opportunity.Id IN :idList];
        
        Map<Id,List<OpportunityContactRole>> opportunityWithContactRoleMap = new Map<Id,List<OpportunityContactRole>>();
        
        for(OpportunityContactRole opc : oppContactRoleList){
            if(opportunityWithContactRoleMap.containsKey(opc.OpportunityId)){
                List<OpportunityContactRole> opcList = opportunityWithContactRoleMap.get(opc.OpportunityId);
                opcList.add(opc);
            }else{
                List<OpportunityContactRole> opcList = new List<OpportunityContactRole>();
                opcList.add(opc);
                opportunityWithContactRoleMap.put(opc.OpportunityId, opcList);
            }
        }
        
        Integer numberOfCriterias = 0;
        Integer numberOfFulfilledCriterias = 0;
        
        for(Opportunity opp : triggerNew){
            if(mapStageRules.containsKey(opp.StageName)){
                numberOfCriterias = 1 + mapStageRules.get(opp.StageName).Mandatory_Roles__c.countMatches(';');
                if(opportunityWithContactRoleMap.containsKey(opp.Id)){
                    for(OpportunityContactRole opc : opportunityWithContactRoleMap.get(opp.Id)){
                        if(mapStageRules.get(opp.StageName).Mandatory_Roles__c.contains(opc.Role)){	
                            numberOfFulfilledCriterias++;
                        }
                    }
                }
            }
            if(numberOfCriterias != numberOfFulfilledCriterias){
                opp.addError(mapStageRules.get(opp.StageName).Mandatory_Roles__c.replaceAll(';', ' and ') + ' role requirement for this stage is not fulfilled.');
            }
            numberOfFulfilledCriterias = 0;
            numberOfCriterias = 0;
        }
    }
}