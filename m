Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0155C4646B
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 21:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6917720665
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 21:55:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="PGO2edmK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfFXVzA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 17:55:00 -0400
Received: from mail-eopbgr750075.outbound.protection.outlook.com ([40.107.75.75]:65197
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726301AbfFXVzA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 17:55:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8PSeT81obbDVdqnIoX8PpaVOvL6CX8+5JI2jeJo/Tz8=;
 b=PGO2edmKneyYBVn3wllIJok62pEiFY1vbUZhZoYSBh4diTyz4SJdY5a1pUczFncmj8vA2r+BgWexeJdR462Z+ZJU5RI/40xm4tXHbVuiPZQW3Q7Cg8t9WVQoeRcYmb0kd7kxHr4NLegcAByYAr2VPDXYuEQdsmQQe2IKJrJmd3Y=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB2620.namprd12.prod.outlook.com (20.176.116.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 21:54:53 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::1ddd:450:1798:1782%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 21:54:53 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 02/11] crypto: ccp - Add a module parameter to specify a
 queue count
Thread-Topic: [PATCH 02/11] crypto: ccp - Add a module parameter to specify a
 queue count
Thread-Index: AQHVKsMLoFuNWViXyUm8S5zn5q9N4KarWV+A
Date:   Mon, 24 Jun 2019 21:54:52 +0000
Message-ID: <d372b527-63ba-3dbc-71e6-6836f1b410bf@amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
 <156140452269.116890.16300533767199946313.stgit@sosrh3.amd.com>
In-Reply-To: <156140452269.116890.16300533767199946313.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36)
 To DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57e6efda-80d3-41b5-bf2f-08d6f8ee964a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2620;
x-ms-traffictypediagnostic: DM6PR12MB2620:
x-microsoft-antispam-prvs: <DM6PR12MB262035309FA8CE9745A965FFECE00@DM6PR12MB2620.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(366004)(136003)(39860400002)(189003)(199004)(305945005)(64756008)(14444005)(73956011)(14454004)(7736002)(66446008)(6436002)(66946007)(186003)(66476007)(26005)(6512007)(72206003)(66066001)(66556008)(5660300002)(8936002)(8676002)(256004)(71190400001)(71200400001)(81156014)(81166006)(86362001)(229853002)(6486002)(36756003)(31696002)(31686004)(53936002)(6116002)(110136005)(316002)(99286004)(476003)(54906003)(4326008)(3846002)(2616005)(53546011)(52116002)(6506007)(386003)(11346002)(6246003)(446003)(102836004)(2906002)(68736007)(25786009)(76176011)(478600001)(2501003)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2620;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: afTURmGzMlW4fRZLG3aZEf1UnqOdCYHB3W5bCx0Y/fpWida494OBB2pIut5mZqVL4Br8clF1Nqya7QlSR+VOpJr3cVlY9QZT23Vs3JKxZcGkgXuQZr+C1twmFRfL7iTwclcf6r8Dzw/6suhADqFWnVX7drLkFwympRvpZDhadzPjWLIg10eSDJxLDJXPQeXsqX8bxCuTHFQ6eMzJ+qsYiqpocsPWzNkaLLoi1/4j9KHmzknKu/xRhXp4WPjyrf0kovz1ao7f33wD98yErcFMMmOxTBM27NFc/3P64APm9J1tJakgWuvdZ0TTpJfNQTUA7f2AQ1DBbnOD29XbdOIf70DFsJ4Iy18vrJ5yIUCsHxOFgHK/+BWILWEW42aFqDKVZmRQolCLHj46LIJNPWp5Jwu0OCribdbei+dvkHjOu8Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35D780C5CFF2A348B27124B519406998@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57e6efda-80d3-41b5-bf2f-08d6f8ee964a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 21:54:53.0207
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

T24gNi8yNC8xOSAyOjI4IFBNLCBIb29rLCBHYXJ5IHdyb3RlOg0KPiBBZGQgYSBtb2R1bGUgcGFy
YW1ldGVyIHRvIGxpbWl0IHRoZSBudW1iZXIgb2YgcXVldWVzIHBlciBDQ1AuIFRoZSBkZWZhdWx0
DQo+IChucXVldWVzPTApIGlzIHRvIHNldCB1cCBldmVyeSBhdmFpbGFibGUgcXVldWUgb24gZWFj
aCBkZXZpY2UuDQoNClRoaXMgZG9lc24ndCBtYXRjaCB0aGUgY29kZS4uLiAgbnF1ZXVlcyBkZWZh
dWx0cyB0byBNQVhfSFdfUVVFVUVTIGJlbG93Lg0KVGhlIHdheSBpdCBpcyBjb2RlZCBucXVldWVz
PTAgYW5kIG5xdWV1ZXM9MSBhcmUgZXhhY3RseSB0aGUgc2FtZS4NCg0KPiANCj4gVGhlIGNvdW50
IG9mIHF1ZXVlcyBzdGFydHMgZnJvbSB0aGUgZmlyc3Qgb25lIGZvdW5kIG9uIHRoZSBkZXZpY2Ug
KHdoaWNoDQo+IGlzIGJhc2VkIG9uIHRoZSBkZXZpY2UgSUQpLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogR2FyeSBSIEhvb2sgPGdhcnkuaG9va0BhbWQuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvY3J5
cHRvL2NjcC9jY3AtZGV2LXY1LmMgfCAgICA5ICsrKysrKysrLQ0KPiAgZHJpdmVycy9jcnlwdG8v
Y2NwL2NjcC1kZXYuaCAgICB8ICAgMTUgKysrKysrKysrKysrKysrDQo+ICBkcml2ZXJzL2NyeXB0
by9jY3Avc3AtcGNpLmMgICAgIHwgICAxNSArKysrKysrKysrKysrKy0NCj4gIDMgZmlsZXMgY2hh
bmdlZCwgMzcgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi12NS5jIGIvZHJpdmVycy9jcnlwdG8vY2NwL2Nj
cC1kZXYtdjUuYw0KPiBpbmRleCBhNWJkMTE4MzFiODAuLmZmZDU0NmI5NTFiNiAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYw0KPiArKysgYi9kcml2ZXJzL2Ny
eXB0by9jY3AvY2NwLWRldi12NS5jDQo+IEBAIC0xNCwxMiArMTQsMTUgQEANCj4gICNpbmNsdWRl
IDxsaW51eC9rZXJuZWwuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9wY2kuaD4NCj4gICNpbmNsdWRl
IDxsaW51eC9rdGhyZWFkLmg+DQo+IC0jaW5jbHVkZSA8bGludXgvZGVidWdmcy5oPg0KPiAgI2lu
Y2x1ZGUgPGxpbnV4L2RtYS1tYXBwaW5nLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvaW50ZXJydXB0
Lmg+DQo+ICAjaW5jbHVkZSA8bGludXgvY29tcGlsZXIuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9j
Y3AuaD4NCj4gIA0KPiArI2lmZGVmIENPTkZJR19DUllQVE9fREVWX0NDUF9ERUJVR0ZTDQo+ICsj
aW5jbHVkZSA8bGludXgvZGVidWdmcy5oPg0KPiArI2VuZGlmDQo+ICsNCg0KVGhpcyBiZWxvbmdz
IGluIHRoZSBmaXJzdCBwYXRjaC4NCg0KPiAgI2luY2x1ZGUgImNjcC1kZXYuaCINCj4gIA0KPiAg
LyogQWxsb2NhdGUgdGhlIHJlcXVlc3RlZCBudW1iZXIgb2YgY29udGlndW91cyBMU0Igc2xvdHMN
Cj4gQEAgLTc4NCw2ICs3ODcsNyBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgY2NwNV9pcnFfaGFuZGxl
cihpbnQgaXJxLCB2b2lkICpkYXRhKQ0KPiAgDQo+ICBzdGF0aWMgaW50IGNjcDVfaW5pdChzdHJ1
Y3QgY2NwX2RldmljZSAqY2NwKQ0KPiAgew0KPiArCXVuc2lnbmVkIGludCBucXVldWVzID0gY2Nw
X2dldF9ucXVldWVzX3BhcmFtKCk7DQo+ICAJc3RydWN0IGRldmljZSAqZGV2ID0gY2NwLT5kZXY7
DQo+ICAJc3RydWN0IGNjcF9jbWRfcXVldWUgKmNtZF9xOw0KPiAgCXN0cnVjdCBkbWFfcG9vbCAq
ZG1hX3Bvb2w7DQo+IEBAIC04NTYsNiArODYwLDkgQEAgc3RhdGljIGludCBjY3A1X2luaXQoc3Ry
dWN0IGNjcF9kZXZpY2UgKmNjcCkNCj4gIAkJaW5pdF93YWl0cXVldWVfaGVhZCgmY21kX3EtPmlu
dF9xdWV1ZSk7DQo+ICANCj4gIAkJZGV2X2RiZyhkZXYsICJxdWV1ZSAjJXUgYXZhaWxhYmxlXG4i
LCBpKTsNCj4gKw0KPiArCQlpZiAoY2NwLT5jbWRfcV9jb3VudCA+PSBucXVldWVzKQ0KPiArCQkJ
YnJlYWs7DQoNCkluIHJlZmVyZW5jZSB0byBteSBjb21tZW50IGFib3ZlLCB0aGlzIGlzIHdoZXJl
IG5xdWV1ZXM9MCBvciAxIHJlc3VsdHMNCmluIHRoZSBzYW1lIHRoaW5nIGhhcHBlbmluZy4NCg0K
PiAgCX0NCj4gIA0KPiAgCWlmIChjY3AtPmNtZF9xX2NvdW50ID09IDApIHsNCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LmggYi9kcml2ZXJzL2NyeXB0by9jY3AvY2Nw
LWRldi5oDQo+IGluZGV4IDY4MTBiNjVjMTkzOS4uZDgxMjQ0NjIxM2VlIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2Nj
cC9jY3AtZGV2LmgNCj4gQEAgLTYzMiw2ICs2MzIsOCBAQCBzdHJ1Y3QgY2NwNV9kZXNjIHsNCj4g
IHZvaWQgY2NwX2FkZF9kZXZpY2Uoc3RydWN0IGNjcF9kZXZpY2UgKmNjcCk7DQo+ICB2b2lkIGNj
cF9kZWxfZGV2aWNlKHN0cnVjdCBjY3BfZGV2aWNlICpjY3ApOw0KPiAgDQo+ICt1bnNpZ25lZCBp
bnQgY2NwX2dldF9ucXVldWVzX3BhcmFtKHZvaWQpOw0KPiArDQo+ICBleHRlcm4gdm9pZCBjY3Bf
bG9nX2Vycm9yKHN0cnVjdCBjY3BfZGV2aWNlICosIGludCk7DQo+ICANCj4gIHN0cnVjdCBjY3Bf
ZGV2aWNlICpjY3BfYWxsb2Nfc3RydWN0KHN0cnVjdCBzcF9kZXZpY2UgKnNwKTsNCj4gQEAgLTY3
MSw0ICs2NzMsMTcgQEAgZXh0ZXJuIGNvbnN0IHN0cnVjdCBjY3BfdmRhdGEgY2NwdjM7DQo+ICBl
eHRlcm4gY29uc3Qgc3RydWN0IGNjcF92ZGF0YSBjY3B2NWE7DQo+ICBleHRlcm4gY29uc3Qgc3Ry
dWN0IGNjcF92ZGF0YSBjY3B2NWI7DQo+ICANCj4gKw0KPiArI2lmZGVmIENPTkZJR19DUllQVE9f
REVWX0NDUF9ERUJVR0ZTDQo+ICsNCj4gKy8qIERlYnVnRlMgc3R1ZmYgKi8NCj4gK3R5cGVkZWYg
c3RydWN0IF9tb2RwYXJhbSB7DQo+ICsgICAgICAgICAgICAgICAgY2hhciAqcGFyYW1uYW1lOw0K
PiArICAgICAgICAgICAgICAgIHZvaWQgKnBhcmFtOw0KPiArICAgICAgICAgICAgICAgIHVtb2Rl
X3QgcGFyYW1tb2RlOw0KPiArICAgICAgICB9IG1vZHBhcmFtX3Q7DQo+ICtleHRlcm4gdm9pZCBj
Y3BfZGVidWdmc19yZWdpc3Rlcl9tb2RwYXJhbXMoc3RydWN0IGRlbnRyeSAqcGFyZW50ZGlyKTsN
Cj4gKw0KPiArI2VuZGlmDQo+ICsNCg0KWW91J3ZlIGNyZWF0ZWQgdGhpcyB0eXBlZGVmL3N0cnVj
dCAod2hpY2ggc2hvdWxkIGJlIGp1c3QgYSBzdHJ1Y3QsIG5vdA0KYSB0eXBlZGVmKSB3aGljaCBp
c24ndCB1c2VkIGFuZCByZWZlcmVuY2UgdG8gYSBmdW5jdGlvbiB0aGF0IGRvZXNuJ3QgZXhpc3QN
CnlldC4NCg0KPiAgI2VuZGlmDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3Avc3At
cGNpLmMgYi9kcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMNCj4gaW5kZXggNDFiY2UwYTNmNGJi
Li4zZmFiNzk1ODVmNzIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1wY2ku
Yw0KPiArKysgYi9kcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMNCj4gQEAgLTEsNyArMSw5IEBA
DQo+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiArDQo+ICAvKg0KPiAg
ICogQU1EIFNlY3VyZSBQcm9jZXNzb3IgZGV2aWNlIGRyaXZlcg0KPiAgICoNCj4gLSAqIENvcHly
aWdodCAoQykgMjAxMywyMDE4IEFkdmFuY2VkIE1pY3JvIERldmljZXMsIEluYy4NCj4gKyAqIENv
cHlyaWdodCAoQykgMjAxMywyMDE5IEFkdmFuY2VkIE1pY3JvIERldmljZXMsIEluYy4NCj4gICAq
DQo+ICAgKiBBdXRob3I6IFRvbSBMZW5kYWNreSA8dGhvbWFzLmxlbmRhY2t5QGFtZC5jb20+DQo+
ICAgKiBBdXRob3I6IEdhcnkgUiBIb29rIDxnYXJ5Lmhvb2tAYW1kLmNvbT4NCj4gQEAgLTI3LDYg
KzI5LDE3IEBADQo+ICAjaW5jbHVkZSAiY2NwLWRldi5oIg0KPiAgI2luY2x1ZGUgInBzcC1kZXYu
aCINCj4gIA0KPiArLyoNCj4gKyAqIExpbWl0IENDUCB1c2UgdG8gYSBzcGVjaWZlZCBudW1iZXIg
b2YgcXVldWVzIHBlciBkZXZpY2UuDQo+ICsgKi8NCj4gK3N0YXRpYyB1bnNpZ25lZCBpbnQgbnF1
ZXVlcyA9IE1BWF9IV19RVUVVRVM7DQo+ICttb2R1bGVfcGFyYW0obnF1ZXVlcywgdWludCwgMDQ0
NCk7DQo+ICtNT0RVTEVfUEFSTV9ERVNDKG5xdWV1ZXMsICJOdW1iZXIgb2YgcXVldWVzIHBlciBD
Q1AgKGRlZmF1bHQ6IDUpIik7DQo+ICsNCj4gK3Vuc2lnbmVkIGludCBjY3BfZ2V0X25xdWV1ZXNf
cGFyYW0odm9pZCkgew0KPiArCXJldHVybiBucXVldWVzOw0KPiArfQ0KPiArDQoNCllvdSBzaG91
bGQgZGVmaW5lIHRoaXMgbW9kdWxlIHBhcmFtZXRlciBpbiB0aGUgZmlsZSB3aGVyZSBpdCBpcyB1
c2VkIGFuZA0KdGhlbiB5b3Ugd29uJ3QgbmVlZCB0aGUgZnVuY3Rpb24uDQoNClRoYW5rcywNClRv
bQ0KDQo+ICAjZGVmaW5lIE1TSVhfVkVDVE9SUwkJCTINCj4gIA0KPiAgc3RydWN0IHNwX3BjaSB7
DQo+IA0K
