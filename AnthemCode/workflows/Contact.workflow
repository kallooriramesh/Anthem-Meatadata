<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Contact_has_been_created</fullName>
        <description>FON-CONTACT-New Contact Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>membernation.traininglatestorg@fonteva.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Worflow_Emails/FON_New_Contact_Registration</template>
    </alerts>
    <rules>
        <fullName>FON-CONTACT-New Contact Email Alert</fullName>
        <actions>
            <name>New_Contact_has_been_created</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Workflow fires an email alert whenever a new Contact is created by the site guest user.</description>
        <formula>ISPICKVAL($Profile.UserType,&apos;Guest&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
