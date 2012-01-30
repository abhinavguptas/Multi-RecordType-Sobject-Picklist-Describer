# Intro 
This tiny project is for solving an interesting problem with describing picklist values in Sobjects. One can usually do the normal describe calls to get the required picklist values, but when an Sobject is configured for different record types and each record-type is having a different set of picklist values, then usual Apex describe system doesn't helps.
We are trying to solve the same problem here, by providing describe() API for such multi record-type sobjects.

# How to use API ?
Using API is very simple, here are the few steps:

### 1. Copy metadata
Please copy all 2 Apex classes and 1 VF page available in this repository. 
Don't hate me for not writing the test cases :), this is done intentionally as writing such test cases would require me to either change existing Standard objects or create a new Custom sobject, porting any of these approaches wouldn't be feasible for your org. So please write your own test cases, god bless :)

### 2. Use PicklistDescriber.describe(...) calls

API learning curve is almost 0.001 % (calculated based on black magic), you just need to call describe(..) method and it will handle back you a List<String> having required picklist values. So, one needs to call one of the three describe() methods as shown below:

1). When you have the record id

```java
// Query or Load the Account as required
Id accountId = [Select Id from Account Where Name = 'Most Paying Customer'];
// Here is the Describe call, the resultant List<String> is all picklist values
List<String> options = PicklistDescriber.describe(accountId, 'Industry');
```

2). When you know the sobjectType and recordType name 

```java
// 'Record_Type_1' is a sample record type name on Account
List<String> options = PicklistDescriber.describe('Account', 'Record_Type_1', 'Industry'));
```

3). When you know the sobjectType and recordTypeId

```java
// 'Record_Type_2' is a sample record type name on Account
Id recType2Id = [Select Id from RecordType Where SobjectType = 'Account' 
                                            AND DeveloperName like 'Record_Type_2'].Id;
List<String> options = PicklistDescriber.describe('Account', recType2Id, 'Industry');
```

# Internals - How it works ?
Please relate the repository source with this diagram
![How it works] (https://docs.google.com/drawings/pub?id=1IUDkz6ug1lxX3AjTVrarwhr1oJg9HVjJ6IL63ABCpSQ&w=1431&h=770)