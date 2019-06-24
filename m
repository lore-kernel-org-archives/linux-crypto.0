Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FA8C4646B
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 22:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 219F320665
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 22:43:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="ghGcQxzs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfFXWnS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 18:43:18 -0400
Received: from mail-eopbgr740071.outbound.protection.outlook.com ([40.107.74.71]:18784
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726397AbfFXWnS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 18:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkEucYze5SGI1SBHhPxC8wSgX+qxCysJBwBka2Enzh8=;
 b=ghGcQxzs+WqcoWmsyZWBeSa7N5UsLCvXALatc0die0grNDTEHsAdk5ddGNSfXc1IG8+b3RvJqMmONmR4QPweap31n6vNE+GP95SPTVjIJRxr3VDfRagZhwjg2LYflKLHxAp9Y06cqBB3R0eZMt/Glg9NSp/oH2kp05qLgG6iXwM=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3547.namprd12.prod.outlook.com (20.179.106.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 22:42:35 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 22:42:35 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 08/11] crypto: ccp - module parameter to allow CCP
 selection by PCI bus
Thread-Topic: [PATCH 08/11] crypto: ccp - module parameter to allow CCP
 selection by PCI bus
Thread-Index: AQHVKsMj3YNLUIdYfEG2yn2ZEXfqKaarZrOA
Date:   Mon, 24 Jun 2019 22:42:34 +0000
Message-ID: <2f1af9c8-1136-efd2-986b-244e9b4a4277@amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
 <156140456385.116890.10589968291918678953.stgit@sosrh3.amd.com>
In-Reply-To: <156140456385.116890.10589968291918678953.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0122.namprd05.prod.outlook.com
 (2603:10b6:803:42::39) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8745273-d617-44fa-0428-08d6f8f54035
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3547;
x-ms-traffictypediagnostic: DM6PR12MB3547:
x-microsoft-antispam-prvs: <DM6PR12MB3547E80CAF13C79031E39A74ECE00@DM6PR12MB3547.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(376002)(396003)(346002)(136003)(199004)(189003)(6246003)(4326008)(256004)(14444005)(99286004)(25786009)(31696002)(86362001)(2501003)(3846002)(71200400001)(71190400001)(26005)(53936002)(14454004)(2906002)(76176011)(52116002)(36756003)(6116002)(72206003)(53546011)(102836004)(386003)(6506007)(446003)(476003)(5660300002)(478600001)(11346002)(2616005)(486006)(54906003)(229853002)(316002)(110136005)(73956011)(305945005)(8936002)(7736002)(6512007)(68736007)(66446008)(8676002)(81166006)(81156014)(6436002)(66066001)(66476007)(66946007)(186003)(31686004)(64756008)(6486002)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3547;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: chcyaOA47J9ZhZmSYbzR0mD6AKtLZV9eZapocx+HpcocSRnyjYGCYLa7sHGkORvKDy+/FPxtGFdDOyf2XmoUq1HVhnYZjqkqIobPQwCCZ2gL+lQMSPY8kiaH9lKZjiQO+bSy7bAF5KBulyXZjrs8VNC4G7BbMPIyPdN0YOKh0LgDtVWrbKbPB3zdRF6QnhKnUGvwPbG66tUkzFDNB7EPcUhfmsdWwqNvCV4woAF1scTT72vf60SAI1x1PBpSoBtchc/xF6yVajIPiQe5d7ZIW+yYynYlFwuQSZ4H5jhKtfmlrESuS+RBIcvhhggGtKXPmdoII1yk3AKrudhT3fRJscsoEzjbs38U8wsxfSb1oNIV1rMwpTSIWIGoaYaDP7y0KxMdP4gIr4V2RJnpdktIJkOiL9pj7qZobdsJYynEdm4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66C9E5AC9CF82B4CA299BFD360B9000D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8745273-d617-44fa-0428-08d6f8f54035
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 22:42:34.9804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3547
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNi8yNC8xOSAyOjI5IFBNLCBIb29rLCBHYXJ5IHdyb3RlOg0KPiBBZGQgYSBtb2R1bGUgcGFy
YW1ldGVyIHRoYXQgYWxsb3dzIHNwZWNpZmljYXRpb24gb2Ygb25lIG9yIG1vcmUgQ0NQcw0KPiBi
YXNlZCBvbiBQQ0kgYnVzIGlkZW50aWZpZXJzLiBUaGUgdmFsdWUgb2YgdGhlIHBhcmFtZXRlciBp
cyBhIGNvbW1hLQ0KPiBzZXBhcmF0ZWQgbGlzdCBvZiBidXMgbnVtYmVycywgaW4gbm8gcGFydGlj
dWxhciBvcmRlci4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEdhcnkgUiBIb29rIDxnYXJ5Lmhvb2tA
YW1kLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMgfCAgIDU4ICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIDEgZmlsZSBjaGFu
Z2VkLCA1OCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8v
Y2NwL3NwLXBjaS5jIGIvZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jDQo+IGluZGV4IGJjZDFl
MjMzZGNlNy4uYTU2M2Q4NWIyNDJlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jY3Av
c3AtcGNpLmMNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jDQo+IEBAIC00MCw2
ICs0MCwxMyBAQCBzdGF0aWMgdW5zaWduZWQgaW50IHBjaWRldjsNCj4gIG1vZHVsZV9wYXJhbShw
Y2lkZXYsIHVpbnQsIDA0NDQpOw0KPiAgTU9EVUxFX1BBUk1fREVTQyhwY2lkZXYsICJEZXZpY2Ug
bnVtYmVyIGZvciBhIHNwZWNpZmljIENDUCIpOw0KPiAgDQo+ICsjZGVmaW5lIE1BWENDUFMgMzIN
Cj4gK3N0YXRpYyBjaGFyICpidXNlczsNCj4gK3N0YXRpYyB1bnNpZ25lZCBpbnQgbl9wY2lidXMg
PSAwOw0KPiArc3RhdGljIHVuc2lnbmVkIGludCBwY2lidXNbTUFYQ0NQU107DQo+ICttb2R1bGVf
cGFyYW0oYnVzZXMsIGNoYXJwLCAwNDQ0KTsNCj4gK01PRFVMRV9QQVJNX0RFU0MoYnVzZXMsICJQ
Q0kgQnVzIG51bWJlcihzKSwgY29tbWEtc2VwYXJhdGVkLiBMaXN0IENDUHMgd2l0aCAnbHNwY2kg
fGdyZXAgRW5jJyIpOw0KPiArDQo+ICBzdGF0aWMgc3RydWN0IG11dGV4IGRldmNvdW50X211dGV4
IF9fX19jYWNoZWxpbmVfYWxpZ25lZDsNCj4gIHN0YXRpYyB1bnNpZ25lZCBpbnQgZGV2Y291bnQg
PSAwOw0KPiAgc3RhdGljIHVuc2lnbmVkIGludCBtYXhkZXYgPSAwOw0KPiBAQCAtNTAsNiArNTcs
MzcgQEAgc3RhdGljIHVuc2lnbmVkIGludCBucXVldWVzID0gTUFYX0hXX1FVRVVFUzsNCj4gIG1v
ZHVsZV9wYXJhbShucXVldWVzLCB1aW50LCAwNDQ0KTsNCj4gIE1PRFVMRV9QQVJNX0RFU0MobnF1
ZXVlcywgIk51bWJlciBvZiBxdWV1ZXMgcGVyIENDUCAoZGVmYXVsdDogNSkiKTsNCj4gIA0KPiAr
I2RlZmluZSBDT01NQSAgICcsJw0KPiArc3RhdGljIHZvaWQgY2NwX3BhcnNlX3BjaV9idXNlcyh2
b2lkKQ0KPiArew0KPiArCXVuc2lnbmVkIGludCBidXNubzsNCj4gKwl1bnNpZ25lZCBpbnQgZW9z
ID0gMDsNCj4gKwlpbnQgcmV0Ow0KPiArCWNoYXIgKmNvbW1hOw0KPiArCWNoYXIgKnRvazsNCj4g
Kw0KPiArCS8qIE5vdGhpbmcgb24gdGhlIGNvbW1hbmQgbGluZT8gKi8NCj4gKwlpZiAoIWJ1c2Vz
KQ0KPiArCQlyZXR1cm47DQo+ICsNCj4gKwljb21tYSA9IHRvayA9IGJ1c2VzOw0KPiArCXdoaWxl
ICghZW9zICYmICp0b2sgJiYgKG5fcGNpYnVzIDwgTUFYQ0NQUykpIHsNCj4gKwkJd2hpbGUgKCpj
b21tYSAmJiAqY29tbWEgIT0gQ09NTUEpDQo+ICsJCQljb21tYSsrOw0KPiArCQlpZiAoKmNvbW1h
ID09IENPTU1BKQ0KPiArCQkJKmNvbW1hID0gJ1wwJzsNCj4gKwkJZWxzZQ0KPiArCQkJZW9zID0g
MTsNCj4gKwkJcmV0ID0ga3N0cnRvdWludCh0b2ssIDAsICZidXNubyk7DQo+ICsJCWlmIChyZXQp
IHsNCj4gKwkJCXByX2luZm8oIiVzOiBQYXJzaW5nIGVycm9yICglZCkgJyVzJ1xuIiwgX19mdW5j
X18sIHJldCwgYnVzZXMpOw0KPiArCQkJcmV0dXJuOw0KPiArCQl9DQo+ICsJCXBjaWJ1c1tuX3Bj
aWJ1cysrXSA9IGJ1c25vOw0KPiArCQl0b2sgPSArK2NvbW1hOw0KPiArCX0NCj4gK30NCj4gKw0K
PiAgI2lmZGVmIENPTkZJR19DUllQVE9fREVWX0NDUF9ERUJVR0ZTDQo+ICBtb2RwYXJhbV90ICAg
ICAgbW9kdWxlcGFyYW1ldGVyc1tdID0gew0KPiAgCXsibWF4ZGV2IiwgJm1heGRldiwgU19JUlVT
Un0sDQo+IEBAIC0yMDQsNiArMjQyLDcgQEAgc3RhdGljIGludCBzcF9wY2lfcHJvYmUoc3RydWN0
IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICppZCkNCj4gIAl2b2lk
IF9faW9tZW0gKiBjb25zdCAqaW9tYXBfdGFibGU7DQo+ICAJaW50IGJhcl9tYXNrOw0KPiAgCWlu
dCByZXQ7DQo+ICsJaW50IGo7DQo+ICANCj4gIAlpZiAobWF4ZGV2ICYmIChkZXZjb3VudCA+PSBt
YXhkZXYpKSAvKiBUb28gbWFueSBkZXZpY2VzPyAqLw0KPiAgCQlyZXR1cm4gMDsNCj4gQEAgLTIx
Miw2ICsyNTEsMjUgQEAgc3RhdGljIGludCBzcF9wY2lfcHJvYmUoc3RydWN0IHBjaV9kZXYgKnBk
ZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICppZCkNCj4gICAgICAgICAgaWYgKHBjaWRl
diAmJiAocGRldi0+ZGV2aWNlICE9IHBjaWRldikpDQo+ICAgICAgICAgICAgICAgICAgICAgICAg
ICByZXR1cm4gMDsNCj4gIA0KPiArCS8qDQo+ICsJKiBMb29rIGZvciAoMSkgYSBzcGVjaWZpYyBk
ZXZpY2UsICgyKSBkZXZpY2VzIG9uIGEgY2VydGFpbg0KPiArCSogYnVzLCBvciAoMykgYSBzcGVj
aWZpYyBkZXZpY2UgbnVtYmVyLiBJZiBib3RoIHBhcmFtZXRlcnMNCj4gKwkqIGFyZSB6ZXJvIGFj
Y2VwdCBhbnkgZGV2aWNlLg0KPiArCSovDQo+ICsJY2NwX3BhcnNlX3BjaV9idXNlcygpOw0KPiAr
CWlmIChuX3BjaWJ1cykgew0KPiArCQlpbnQgbWF0Y2ggPSAwOw0KPiArDQo+ICsJCS8qIFNjYW4g
dGhlIGxpc3Qgb2YgYnVzZXMgZm9yIGEgbWF0Y2ggKi8NCj4gKwkJZm9yIChqID0gMCA7IGogPCBu
X3BjaWJ1cyA7IGorKykNCj4gKwkJCWlmIChwY2lidXNbal0gPT0gcGRldi0+YnVzLT5udW1iZXIp
IHsNCj4gKwkJCQltYXRjaCA9IDE7DQo+ICsJCQkJYnJlYWs7DQo+ICsJCQl9DQo+ICsJCWlmICgh
bWF0Y2gpDQo+ICsJCQlyZXR1cm4gMDsNCj4gKwl9DQoNClNhbWUgY29tbWVudCBhcyBiZWZvcmUg
aW4gcmVnYXJkcyB0byBDQ1AgYW5kIFBTUCBpbnRlcmFjdGlvbi4NCg0KVGhhbmtzLA0KVG9tDQoN
Cj4gKw0KPiAgCXJldCA9IC1FTk9NRU07DQo+ICAJc3AgPSBzcF9hbGxvY19zdHJ1Y3QoZGV2KTsN
Cj4gIAlpZiAoIXNwKQ0KPiANCg==
