Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84B0C4646C
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 22:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2FC720663
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 22:11:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="0hDHdi6n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfFXWLv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 18:11:51 -0400
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:30709
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfFXWLv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 18:11:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xctVnCy8zb10p2BaRqh3+mzywDMnU1k7+FAZ/b2rKQk=;
 b=0hDHdi6n5hqtnwfTpdpv57YvDz5qYHn5QnQq70dvOjPzA3/W7ypVb6VU8zrKYui8NIFe1JG9LsaS9zYAb8fbMutWbgdPccL8rF1Eg8eU1mpF1CbkToJsoTkCipUdqj5yYN7GZSNzk7pGbx0X1Jcze0QH1Gi4ofW4tSNxe/9c5VM=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB3132.namprd12.prod.outlook.com (20.178.31.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 22:11:48 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 22:11:48 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 04/11] crypto: ccp - module parameter to limit the number
 of enabled CCPs
Thread-Topic: [PATCH 04/11] crypto: ccp - module parameter to limit the number
 of enabled CCPs
Thread-Index: AQHVKsMSrsQozUDjtU6Imzpo6GFCDqarXhkA
Date:   Mon, 24 Jun 2019 22:11:48 +0000
Message-ID: <68ecc0ff-2746-fc7d-5ed1-856b49f09d22@amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
 <156140453629.116890.465562924738110016.stgit@sosrh3.amd.com>
In-Reply-To: <156140453629.116890.465562924738110016.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:805:a2::46) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bb1d6e2-cd8e-4779-112c-08d6f8f0f3a2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3132;
x-ms-traffictypediagnostic: DM6PR12MB3132:
x-microsoft-antispam-prvs: <DM6PR12MB3132930B32CBDCCFDD3CD2B4ECE00@DM6PR12MB3132.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(396003)(136003)(39860400002)(189003)(199004)(81166006)(36756003)(6246003)(53546011)(11346002)(8936002)(6506007)(81156014)(66946007)(2616005)(386003)(14454004)(68736007)(76176011)(99286004)(73956011)(31686004)(72206003)(4326008)(25786009)(476003)(486006)(52116002)(14444005)(256004)(5660300002)(478600001)(305945005)(3846002)(6116002)(7736002)(26005)(66476007)(64756008)(66446008)(53936002)(110136005)(2501003)(2906002)(66556008)(8676002)(316002)(31696002)(186003)(54906003)(6436002)(71190400001)(71200400001)(229853002)(86362001)(66066001)(446003)(6512007)(102836004)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3132;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nTBXljpzeVLCaWzf08frLdYTKR/0N3bl4PN9XsBJHHD0WySjYVb84rPw4iR926Q70Z2BtAG9npNk1eRPwa0aR0IN7xMkyTwhZhwgsK02b+mRd655B9lSAG49cnFZFZaWj/SYVc1zVZT6sP3wYqPs6E2MJYl7OewGz2N9Pngmt/tsSqMTQXWKUR4JdOisuSBBl4gG015z1U5pyS8SC9tsTZM8+3JSolEZ/PJS7chBLfBbW8eJyLicW0pHoTRYbR2Ta4tFUCBYsjCiSNjCCj6Byaua5dH8jAYguUGP2hJnzv8+U4B3g/yIWrjk2wcm3sI62FaACSLzu5qW5tWmpdt38glh5KqusmgPMd/bD+fruwnLYcCKK/BBxQwlm54EY01owtoec/SAFB9RIMULaA2JknLqDNWPunNppClwS79KmAs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DA0FE5FFD08E747A4849E81932B5FA8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb1d6e2-cd8e-4779-112c-08d6f8f0f3a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 22:11:48.4846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3132
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNi8yNC8xOSAyOjI4IFBNLCBIb29rLCBHYXJ5IHdyb3RlOg0KPiBQcm92aWRlIHRoZSBhYmls
aXR5IHRvIGNvbnN0cmFpbiB0aGUgdG90YWwgbnVtYmVyIG9mIGVuYWJsZWQgZGV2aWNlcyBpbg0K
PiB0aGUgc3lzdGVtLiBPbmNlIG1heGRldiBkZXZpY2VzIGhhdmUgYmVlbiBjb25maWd1cmVkLCBh
ZGRpdGlvbmFsDQo+IGRldmljZXMgYXJlIGlnbm9yZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBH
YXJ5IFIgSG9vayA8Z2FyeS5ob29rQGFtZC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9jcnlwdG8v
Y2NwL3NwLXBjaS5jIHwgICAxNiArKysrKysrKysrKysrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwg
MTYgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9z
cC1wY2kuYyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1wY2kuYw0KPiBpbmRleCBjMTY3YzQ2NzFm
NDUuLmI4MTQ5MzgxMDY4OSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBj
aS5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1wY2kuYw0KPiBAQCAtMzYsNiArMzYs
MTMgQEANCj4gIC8qDQo+ICAgKiBMaW1pdCBDQ1AgdXNlIHRvIGEgc3BlY2lmZWQgbnVtYmVyIG9m
IHF1ZXVlcyBwZXIgZGV2aWNlLg0KPiAgICovDQo+ICsNCj4gK3N0YXRpYyBzdHJ1Y3QgbXV0ZXgg
ZGV2Y291bnRfbXV0ZXggX19fX2NhY2hlbGluZV9hbGlnbmVkOw0KDQpJIGRvbid0IHRoaW5rIEkn
ZCB3b3JyeSBhYm91dCB0aGUgY2FjaGUgYWxpZ25tZW50IHNpbmNlIHRoaXMgaXMgb25seQ0KdXNl
ZCBhdCBtb2R1bGUgbG9hZC4NCg0KPiArc3RhdGljIHVuc2lnbmVkIGludCBkZXZjb3VudCA9IDA7
DQo+ICtzdGF0aWMgdW5zaWduZWQgaW50IG1heGRldiA9IDA7DQo+ICttb2R1bGVfcGFyYW0obWF4
ZGV2LCB1aW50LCAwNDQ0KTsNCj4gK01PRFVMRV9QQVJNX0RFU0MobWF4ZGV2LCAiVG90YWwgbnVt
YmVyIG9mIGRldmljZXMgdG8gcmVnaXN0ZXIiKTsNCj4gKw0KPiAgc3RhdGljIHVuc2lnbmVkIGlu
dCBucXVldWVzID0gTUFYX0hXX1FVRVVFUzsNCj4gIG1vZHVsZV9wYXJhbShucXVldWVzLCB1aW50
LCAwNDQ0KTsNCj4gIE1PRFVMRV9QQVJNX0RFU0MobnF1ZXVlcywgIk51bWJlciBvZiBxdWV1ZXMg
cGVyIENDUCAoZGVmYXVsdDogNSkiKTsNCj4gQEAgLTE5Myw2ICsyMDAsOSBAQCBzdGF0aWMgaW50
IHNwX3BjaV9wcm9iZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgY29uc3Qgc3RydWN0IHBjaV9kZXZp
Y2VfaWQgKmlkKQ0KPiAgCWludCBiYXJfbWFzazsNCj4gIAlpbnQgcmV0Ow0KPiAgDQo+ICsJaWYg
KG1heGRldiAmJiAoZGV2Y291bnQgPj0gbWF4ZGV2KSkgLyogVG9vIG1hbnkgZGV2aWNlcz8gKi8N
Cj4gKwkJcmV0dXJuIDA7DQo+ICsNCg0KWW91IG5lZWQgdGhlIG11dGV4IHRvIHByb3RlY3QgdGhl
IHVzZSBvZiBkZXZjb3VudC4gWW91IGNvdWxkIHVzZSBhbg0KYXRvbWljIGluc3RlYWQgb2YgdGhl
IGludC9tdXRleCBjb21iaW5hdGlvbi4NCg0KQW5kIHRoaXMgd2lsbCBtZXNzIHdpdGggdGhlIFBT
UCBzdXBwb3J0LiBJdCBzaG91bGQgYmUgaW4gdGhlIENDUA0Kc3BlY2lmaWMgZmlsZXMsIG5vdCBo
ZXJlLg0KDQo+ICAJcmV0ID0gLUVOT01FTTsNCj4gIAlzcCA9IHNwX2FsbG9jX3N0cnVjdChkZXYp
Ow0KPiAgCWlmICghc3ApDQo+IEBAIC0yNjEsNiArMjcxLDExIEBAIHN0YXRpYyBpbnQgc3BfcGNp
X3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAq
aWQpDQo+ICAJaWYgKHJldCkNCj4gIAkJZ290byBlX2VycjsNCj4gIA0KPiArCS8qIEluY3JlYXNl
IGNvdW50IG9mIGRldmljZXMgKi8NCj4gKwltdXRleF9sb2NrKCZkZXZjb3VudF9tdXRleCk7DQo+
ICsJZGV2Y291bnQrKzsNCj4gKwltdXRleF91bmxvY2soJmRldmNvdW50X211dGV4KTsNCj4gKw0K
PiAgCXJldHVybiAwOw0KPiAgDQo+ICBlX2VycjoNCj4gQEAgLTM3NCw2ICszODksNyBAQCBzdGF0
aWMgc3RydWN0IHBjaV9kcml2ZXIgc3BfcGNpX2RyaXZlciA9IHsNCj4gIA0KPiAgaW50IHNwX3Bj
aV9pbml0KHZvaWQpDQo+ICB7DQo+ICsgICAgICAgIG11dGV4X2luaXQoJmRldmNvdW50X211dGV4
KTsNCg0KVGFiIGluc3RlYWQgb2Ygc3BhY2VzLg0KDQpUaGFua3MsDQpUb20NCg0KPiAgCXJldHVy
biBwY2lfcmVnaXN0ZXJfZHJpdmVyKCZzcF9wY2lfZHJpdmVyKTsNCj4gIH0NCj4gIA0KPiANCg==
