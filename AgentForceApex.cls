public class AgentForceApex {
    
    public static String createRecord(String description) {
        
        ConnectApi.EinsteinPromptTemplateGenerationsInput promptGenerationsInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        Map<String, ConnectApi.WrappedValue> valueMap = new Map<String, ConnectApi.WrappedValue>();
       
        // Serialize the map to JSON
        ConnectApi.WrappedValue inputWrappedValue = new ConnectApi.WrappedValue();
        inputWrappedValue.value = description;
        
        // Add to inputParams with correct key
        valueMap.put('Input:Description', inputWrappedValue); 
                
        promptGenerationsInput.inputParams = valueMap;
        promptGenerationsInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
        promptGenerationsInput.additionalConfig.applicationName = 'PromptBuilderPreview';
        promptGenerationsInput.isPreview = false;
        
        ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
            'Insert_Record',
            promptGenerationsInput
        );
        String jsonString = generationsOutput.generations[0].text;

        RecordDetails recordDetails = (RecordDetails) JSON.deserialize(jsonString, RecordDetails.class);
        
      	//Create Custom Object 
	Test_AI__c ai = new test_AI__c();
        ai.name = recordDetails.name;
        ai.Phone__c = recordDetails.phone;
        ai.Email__c = recordDetails.email;
        insert ai;
        
        return generationsOutput.generations[0].text; 
    }
    
    public class RecordDetails {
        public String name { get; set; }
        public String phone { get; set; }
        public String email { get; set; }
    }

}
