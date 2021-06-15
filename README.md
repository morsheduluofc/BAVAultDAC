# DACBAVAult
We implemented and evaluated our proposed BAVault using DAC data and named it as DACBAVault.

## BAVault
A BAVault is similary to the fuzzy vault (see link to know about the fuzzy vault:https://ieeexplore.ieee.org/abstract/document/4378259?casa_token=Uxv388LUZr8AAAAA:D1wGXNbUwOwbWTBmk9BDr7OfN1dsoyvGlJtfGEY-mtNHC2UVj9x7XPzsed6glTiocXme4m12hw) and uses behavioral profile X of a BA system rather to lock the vault. The BAVault will open only by using the another behavioral profile Y of the BA system of same user. Here, a BA profile is seen as a collection of sample sets of d features where every feature has its data distribution.

To unlock a BAVault a feature-based matching algorithm employs a similarity function to decide if two sets of samples have same underlying distribution and output a confidence value. A larger output value corresponds to the higher confidence about the 'sameness' of the distributions of two sets. Follow the link (https://link.springer.com/chapter/10.1007/978-3-030-58201-2_20) to know more about BAVault and its unlocking process. 

## DAC
DAC is a challenge-response based behavioral authentication system. It constructs a profile for each user based on their circle drawing activity in an app, and stores it at the server. During an authentication session, the collected user data is compared against stored profile to make an authentication decision. DAC is implemented as an Anroid app and we collected DAC data from 199 Amazon Mechanical Turks (AMT).
