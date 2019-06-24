Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE69C4646B
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 21:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC4D92083D
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 21:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="xiaCTDH5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfFXV7v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 17:59:51 -0400
Received: from mail-eopbgr790072.outbound.protection.outlook.com ([40.107.79.72]:7003
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732878AbfFXV7u (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 17:59:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6v/JYAc1HVQJdvCePcb0h9nMwm19Uwx119u2xPLjEPA=;
 b=xiaCTDH56A9vN9fDtmGI5+9fHKThtMH9pwS2NQ2aq2CwVPeGUkHaCP9VEM1VzaGY3imxQ3gMaaWMfJJtUJAiiScdQGbBeGp+n9bI2JGr7d/TdSTJdyYDHvhd7GOKt72w1KEWK9M8TESqJQY5tCN3UbgsvzIgDYlYU/RTAh6++uQ=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB2620.namprd12.prod.outlook.com (20.176.116.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 21:59:47 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 21:59:47 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 03/11] crypto: ccp - Expose the value of nqueues in
 DebugFS
Thread-Topic: [PATCH 03/11] crypto: ccp - Expose the value of nqueues in
 DebugFS
Thread-Index: AQHVKsMOXx20QTK8DEaU1Zek4FpSEKarWr6A
Date:   Mon, 24 Jun 2019 21:59:47 +0000
Message-ID: <6867970b-265b-1273-90a6-5a94ecdd445c@amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
 <156140452950.116890.8616947153652273997.stgit@sosrh3.amd.com>
In-Reply-To: <156140452950.116890.8616947153652273997.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR12CA0058.namprd12.prod.outlook.com
 (2603:10b6:3:103::20) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7e0266e-942d-449b-6b24-08d6f8ef4598
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2620;
x-ms-traffictypediagnostic: DM6PR12MB2620:
x-microsoft-antispam-prvs: <DM6PR12MB2620EE8BD40889D493E02ED4ECE00@DM6PR12MB2620.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(366004)(136003)(39860400002)(189003)(199004)(305945005)(64756008)(14444005)(73956011)(14454004)(7736002)(66446008)(6436002)(66946007)(186003)(66476007)(26005)(6512007)(72206003)(66066001)(66556008)(5660300002)(8936002)(8676002)(256004)(71190400001)(71200400001)(81156014)(81166006)(86362001)(229853002)(6486002)(36756003)(31696002)(31686004)(53936002)(6116002)(110136005)(316002)(99286004)(476003)(54906003)(4326008)(3846002)(2616005)(53546011)(52116002)(6506007)(386003)(11346002)(6246003)(446003)(102836004)(2906002)(68736007)(25786009)(76176011)(478600001)(2501003)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2620;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wr6zwrkLe3teow88rcXEpU4aS4qSkwz0ZOyaR1WWYwQllRaCLwg/3PNHOGOl17ufddTO0ZD2w/B8UcIi3Bm0fNMeSm6V69xPZFiYUsyRfdYtT3xMkqeDf+f/mCaHS5ln8XmvwkEIFcsHnYXfsm1CSvksYfaCTWQ5q3XFSxwjhjS4APJ6662fCJuBq23e64z5PYCNMMjZWvcKpJU0KXce42WdsqBToMsiuM484q4s4yvkPzpByP9jHN6l2WeHtAe+2JuIEFhv8rLLhGcS2k2RD3B6IRnSTmHnveWqJkU7ohy+nHqV2czBlHMb3FjhZ4MFrwkgZpUfkqcE5X1FsrmX4ybkyuq79hDRtrhsA6DQ4MyuEiupsyS6guPGt3kFOoOdl01V1eAhC9/28omILTMd03FvH8g5U1JJd6IIaVGsPr4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A137717A808C04E91F3C4021AE44392@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7e0266e-942d-449b-6b24-08d6f8ef4598
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 21:59:47.1630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2620
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNi8yNC8xOSAyOjI4IFBNLCBIb29rLCBHYXJ5IHdyb3RlOg0KPiBNYWtlIG1vZHVsZSBwYXJh
bWV0ZXJzIHJlYWRhYmxlIGluIERlYnVnRlMuDQoNCk5vdCBzdXJlIHdoeSB5b3UgaGF2ZSB0aGlz
Li4uICB5b3UgY2FuIGFjY2VzcyB0aGUgbW9kdWxlIHBhcmFtZXRlcnMgaW4NCi9zeXMvbW9kdWxl
L2NjcC9wYXJhbWV0ZXJzLiBZb3UgY2FuIHRoZW4gZ2V0L3NldCB0aGVtIGJhc2VkIG9uIHRoZQ0K
dmFsdWUgaW4gdGhlIG1vZHVsZV9wYXJhbSgpIGRlZmluaXRpb24uDQoNClRoYW5rcywNClRvbQ0K
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBHYXJ5IFIgSG9vayA8Z2FyeS5ob29rQGFtZC5jb20+DQo+
IC0tLQ0KPiAgZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZWJ1Z2ZzLmMgfCAgICAyICsrDQo+ICBk
cml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMgICAgICB8ICAgMjIgKysrKysrKysrKysrKysrKysr
KysrKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZWJ1Z2ZzLmMgYi9kcml2ZXJzL2NyeXB0by9j
Y3AvY2NwLWRlYnVnZnMuYw0KPiBpbmRleCA0YmQyNmFmNzA5OGQuLmM0Y2MwZTYwZmQ1MCAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZWJ1Z2ZzLmMNCj4gKysrIGIvZHJp
dmVycy9jcnlwdG8vY2NwL2NjcC1kZWJ1Z2ZzLmMNCj4gQEAgLTMxNyw2ICszMTcsOCBAQCB2b2lk
IGNjcDVfZGVidWdmc19zZXR1cChzdHJ1Y3QgY2NwX2RldmljZSAqY2NwKQ0KPiAgCQkJCSAgICAm
Y2NwX2RlYnVnZnNfcXVldWVfb3BzKTsNCj4gIAl9DQo+ICANCj4gKwljY3BfZGVidWdmc19yZWdp
c3Rlcl9tb2RwYXJhbXMoY2NwX2RlYnVnZnNfZGlyKTsNCj4gKw0KPiAgCXJldHVybjsNCj4gIH0N
Cj4gIA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jIGIvZHJpdmVy
cy9jcnlwdG8vY2NwL3NwLXBjaS5jDQo+IGluZGV4IDNmYWI3OTU4NWY3Mi4uYzE2N2M0NjcxZjQ1
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMNCj4gKysrIGIvZHJp
dmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jDQo+IEBAIC0yNiw2ICsyNiwxMCBAQA0KPiAgI2luY2x1
ZGUgPGxpbnV4L2RlbGF5Lmg+DQo+ICAjaW5jbHVkZSA8bGludXgvY2NwLmg+DQo+ICANCj4gKyNp
ZmRlZiBDT05GSUdfQ1JZUFRPX0RFVl9DQ1BfREVCVUdGUw0KPiArI2luY2x1ZGUgPGxpbnV4L2Rl
YnVnZnMuaD4NCj4gKyNlbmRpZg0KPiArDQo+ICAjaW5jbHVkZSAiY2NwLWRldi5oIg0KPiAgI2lu
Y2x1ZGUgInBzcC1kZXYuaCINCj4gIA0KPiBAQCAtMzYsNiArNDAsMjQgQEAgc3RhdGljIHVuc2ln
bmVkIGludCBucXVldWVzID0gTUFYX0hXX1FVRVVFUzsNCj4gIG1vZHVsZV9wYXJhbShucXVldWVz
LCB1aW50LCAwNDQ0KTsNCj4gIE1PRFVMRV9QQVJNX0RFU0MobnF1ZXVlcywgIk51bWJlciBvZiBx
dWV1ZXMgcGVyIENDUCAoZGVmYXVsdDogNSkiKTsNCj4gIA0KPiArI2lmZGVmIENPTkZJR19DUllQ
VE9fREVWX0NDUF9ERUJVR0ZTDQo+ICttb2RwYXJhbV90ICAgICAgbW9kdWxlcGFyYW1ldGVyc1td
ID0gew0KPiArCXsibnF1ZXVlcyIsICZucXVldWVzLCBTX0lSVVNSfSwNCj4gKwl7TlVMTCwgTlVM
TCwgMH0sDQo+ICt9Ow0KPiArDQo+ICt2b2lkIGNjcF9kZWJ1Z2ZzX3JlZ2lzdGVyX21vZHBhcmFt
cyhzdHJ1Y3QgZGVudHJ5ICpwYXJlbnRkaXIpDQo+ICt7DQo+ICsJaW50IGo7DQo+ICsNCj4gKwlm
b3IgKGogPSAwOyBtb2R1bGVwYXJhbWV0ZXJzW2pdLnBhcmFtbmFtZTsgaisrKQ0KPiArCQlkZWJ1
Z2ZzX2NyZWF0ZV91MzIobW9kdWxlcGFyYW1ldGVyc1tqXS5wYXJhbW5hbWUsDQo+ICsJCQkJICAg
bW9kdWxlcGFyYW1ldGVyc1tqXS5wYXJhbW1vZGUsIHBhcmVudGRpciwNCj4gKwkJCQkgICBtb2R1
bGVwYXJhbWV0ZXJzW2pdLnBhcmFtKTsNCj4gK30NCj4gKw0KPiArI2VuZGlmDQo+ICsNCj4gIHVu
c2lnbmVkIGludCBjY3BfZ2V0X25xdWV1ZXNfcGFyYW0odm9pZCkgew0KPiAgCXJldHVybiBucXVl
dWVzOw0KPiAgfQ0KPiANCg==
