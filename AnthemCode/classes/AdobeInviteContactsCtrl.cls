public class AdobeInviteContactsCtrl {
    private ApexPages.StandardSetController standardController;

    public AdobeInviteContactsCtrl(ApexPages.StandardSetController controller) {
        this.standardController = standardController;

    }
    
     public PageReference checkSelectedContacts()
    {
        List<Contact> selectedContacts = (List<Contact>) standardController.getSelected();
        return null;
    }
    

}