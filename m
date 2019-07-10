Return-Path: <SRS0=+pKF=VH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DEC1C74A35
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 22:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10EF121019
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 22:07:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="RYT4F5sq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfGJWHd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jul 2019 18:07:33 -0400
Received: from mail-eopbgr680057.outbound.protection.outlook.com ([40.107.68.57]:29315
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726245AbfGJWHd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jul 2019 18:07:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WjwjxQTOv7AjpxiMQ3HyP7fA23k6/PutTnFscE/MKs=;
 b=RYT4F5sqwM9UBetPFxjyDHk5kXIWJkrVwohbYsMA9M85Zi+8JR/vFG/WZ4kmyidRMwqAXS2HVdGob/WG7U5uTC4WyruLIdLz1f0f5EMDs/I9foIRPzXeMHd/+cHt3aDmnfcClDVR8fft8SuhXusKC2rz+vtxR3+LoAtfmFTibtU=
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.104.150) by
 DM6PR12MB2729.namprd12.prod.outlook.com (20.176.118.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Wed, 10 Jul 2019 22:06:50 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a168:666e:f33c:d1e4]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a168:666e:f33c:d1e4%5]) with mapi id 15.20.2052.020; Wed, 10 Jul 2019
 22:06:50 +0000
From:   "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
To:     David Rientjes <rientjes@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Cfir Cohen <cfir@google.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] crypto: ccp - Fix SEV_VERSION_GREATER_OR_EQUAL
Thread-Topic: [patch] crypto: ccp - Fix SEV_VERSION_GREATER_OR_EQUAL
Thread-Index: AQHVN2ZeS0JJ5CPAY0aBwr+/sdpIw6bEaLuA
Date:   Wed, 10 Jul 2019 22:06:49 +0000
Message-ID: <e30eae0f-415b-842e-39c4-801227126367@amd.com>
References: <alpine.DEB.2.21.1907101426290.2777@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.21.1907101426290.2777@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR1401CA0001.namprd14.prod.outlook.com
 (2603:10b6:4:4a::11) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:182::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84c03177-2c37-4607-1b58-08d70582e79c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2729;
x-ms-traffictypediagnostic: DM6PR12MB2729:
x-microsoft-antispam-prvs: <DM6PR12MB2729AF97A76A5F0B9746AA7DECF00@DM6PR12MB2729.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(199004)(189003)(71190400001)(66066001)(229853002)(66476007)(86362001)(31686004)(4326008)(36756003)(110136005)(2616005)(486006)(476003)(54906003)(14454004)(64756008)(446003)(68736007)(3846002)(66556008)(6116002)(11346002)(316002)(256004)(25786009)(7736002)(186003)(76176011)(8936002)(53546011)(26005)(81156014)(102836004)(6506007)(305945005)(6436002)(71200400001)(478600001)(6512007)(6486002)(53936002)(52116002)(66946007)(99286004)(2906002)(5660300002)(81166006)(386003)(8676002)(6246003)(14444005)(66446008)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2729;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P24Iy1dUdmhUzpEAF+97j9Lp+zTRbsg7gkU0e3Bhsr/DMlHL4mZ1n3iBywWC2s2JjVdHnQYNYLnZaxHFRHk/pGl/Kru2/UphsLGbHCH4qjTKzRlP/rhHJ0sEgR7iExKX8Sr17DIppsNybiRW4XkGAZfnHMAvZZYVPDaN9GkkvB47SolmuQYKh7cZEztfDPX94J6MDghFUIGS7UCUJrTN4UsFb50cA/4ISqAUwgGwfSB3q4gWEK7xp98SOFcQ9e0rQR/J4PHsQcDMqjGIbFDX1LztduNQRGEReYpcAXEb5mo1afAigZTq46pC6NuzIZhmqlPOzBvpCsIzgTXtpUDndVXVBfR/35Yi/lBFYdEju5g+Ssh8cgEYLt/vd3gzGoG8LkdfLsliLVlAvMJghRinl+k4DNL0RGdGNkxkbaVAo2M=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7A133349C95F44294F28A3178E234CD@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c03177-2c37-4607-1b58-08d70582e79c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 22:06:49.8922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2729
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy8xMC8xOSA0OjI4IFBNLCBEYXZpZCBSaWVudGplcyB3cm90ZToNCj4gU0VWX1ZFUlNJT05f
R1JFQVRFUl9PUl9FUVVBTCgpIHdpbGwgZmFpbCBpZiB1cGdyYWRpbmcgZnJvbSAyLjIgdG8gMy4x
LCBmb3INCj4gZXhhbXBsZSwgYmVjYXVzZSB0aGUgbWlub3IgdmVyc2lvbiBpcyBub3QgZXF1YWwg
dG8gb3IgZ3JlYXRlciB0aGFuIHRoZQ0KPiBtYWpvci4NCj4gDQo+IEZpeCB0aGlzIGFuZCBtb3Zl
IHRvIGEgc3RhdGljIGlubGluZSBmdW5jdGlvbiBmb3IgYXBwcm9wcmlhdGUgdHlwZQ0KPiBjaGVj
a2luZy4NCj4gDQo+IEZpeGVzOiBlZGQzMDNmZjBlOWUgKCJjcnlwdG86IGNjcCAtIEFkZCBET1dO
TE9BRF9GSVJNV0FSRSBTRVYgY29tbWFuZCIpDQo+IFJlcG9ydGVkLWJ5OiBDZmlyIENvaGVuIDxj
ZmlyQGdvb2dsZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IERhdmlkIFJpZW50amVzIDxyaWVudGpl
c0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvY3J5cHRvL2NjcC9wc3AtZGV2LmMgfCAx
OSArKysrKysrKysrKystLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygr
KSwgNyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3Av
cHNwLWRldi5jIGIvZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuYw0KPiAtLS0gYS9kcml2ZXJz
L2NyeXB0by9jY3AvcHNwLWRldi5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9wc3AtZGV2
LmMNCj4gQEAgLTI0LDEwICsyNCw2IEBADQo+ICAjaW5jbHVkZSAic3AtZGV2LmgiDQo+ICAjaW5j
bHVkZSAicHNwLWRldi5oIg0KPiAgDQo+IC0jZGVmaW5lIFNFVl9WRVJTSU9OX0dSRUFURVJfT1Jf
RVFVQUwoX21haiwgX21pbikJXA0KPiAtCQkoKHBzcF9tYXN0ZXItPmFwaV9tYWpvcikgPj0gX21h
aiAmJglcDQo+IC0JCSAocHNwX21hc3Rlci0+YXBpX21pbm9yKSA+PSBfbWluKQ0KPiAtDQo+ICAj
ZGVmaW5lIERFVklDRV9OQU1FCQkic2V2Ig0KPiAgI2RlZmluZSBTRVZfRldfRklMRQkJImFtZC9z
ZXYuZnciDQo+ICAjZGVmaW5lIFNFVl9GV19OQU1FX1NJWkUJNjQNCj4gQEAgLTQ3LDYgKzQzLDE1
IEBAIE1PRFVMRV9QQVJNX0RFU0MocHNwX3Byb2JlX3RpbWVvdXQsICIgZGVmYXVsdCB0aW1lb3V0
IHZhbHVlLCBpbiBzZWNvbmRzLCBkdXJpbmcNCj4gIHN0YXRpYyBib29sIHBzcF9kZWFkOw0KPiAg
c3RhdGljIGludCBwc3BfdGltZW91dDsNCj4gIA0KPiArc3RhdGljIGlubGluZSBib29sIHNldl92
ZXJzaW9uX2dyZWF0ZXJfb3JfZXF1YWwodTggbWFqLCB1OCBtaW4pDQo+ICt7DQo+ICsJaWYgKHBz
cF9tYXN0ZXItPmFwaV9tYWpvciA+IG1haikNCj4gKwkJcmV0dXJuIHRydWU7DQo+ICsJaWYgKHBz
cF9tYXN0ZXItPmFwaV9tYWpvciA+PSBtYWogJiYgcHNwX21hc3Rlci0+YXBpX21pbm9yID49IG1p
bikNCg0KSnVzdCBhIG5pdCwgYnV0IGl0IHJlYWRzIGEgbGl0dGxlIGNsZWFyZXIgdG8gbWUgYXM6
DQoNCglpZiAocHNwX21hc3Rlci0+YXBpX21ham9yID09IG1haiAmJiBwc3BfbWFzdGVyLT5hcGlf
bWlub3IgPj0gbWluKQ0KDQpzaW5jZSB5b3UgdGVzdGVkIGZvciBtYWpvciA+IGFib3ZlLg0KDQpU
aGFua3MsDQpUb20NCg0KPiArCQlyZXR1cm4gdHJ1ZTsNCj4gKwlyZXR1cm4gZmFsc2U7DQo+ICt9
DQo+ICsNCj4gIHN0YXRpYyBzdHJ1Y3QgcHNwX2RldmljZSAqcHNwX2FsbG9jX3N0cnVjdChzdHJ1
Y3Qgc3BfZGV2aWNlICpzcCkNCj4gIHsNCj4gIAlzdHJ1Y3QgZGV2aWNlICpkZXYgPSBzcC0+ZGV2
Ow0KPiBAQCAtNTg4LDcgKzU5Myw3IEBAIHN0YXRpYyBpbnQgc2V2X2lvY3RsX2RvX2dldF9pZDIo
c3RydWN0IHNldl9pc3N1ZV9jbWQgKmFyZ3ApDQo+ICAJaW50IHJldDsNCj4gIA0KPiAgCS8qIFNF
ViBHRVRfSUQgaXMgYXZhaWxhYmxlIGZyb20gU0VWIEFQSSB2MC4xNiBhbmQgdXAgKi8NCj4gLQlp
ZiAoIVNFVl9WRVJTSU9OX0dSRUFURVJfT1JfRVFVQUwoMCwgMTYpKQ0KPiArCWlmICghc2V2X3Zl
cnNpb25fZ3JlYXRlcl9vcl9lcXVhbCgwLCAxNikpDQo+ICAJCXJldHVybiAtRU5PVFNVUFA7DQo+
ICANCj4gIAlpZiAoY29weV9mcm9tX3VzZXIoJmlucHV0LCAodm9pZCBfX3VzZXIgKilhcmdwLT5k
YXRhLCBzaXplb2YoaW5wdXQpKSkNCj4gQEAgLTY1MSw3ICs2NTYsNyBAQCBzdGF0aWMgaW50IHNl
dl9pb2N0bF9kb19nZXRfaWQoc3RydWN0IHNldl9pc3N1ZV9jbWQgKmFyZ3ApDQo+ICAJaW50IHJl
dDsNCj4gIA0KPiAgCS8qIFNFViBHRVRfSUQgYXZhaWxhYmxlIGZyb20gU0VWIEFQSSB2MC4xNiBh
bmQgdXAgKi8NCj4gLQlpZiAoIVNFVl9WRVJTSU9OX0dSRUFURVJfT1JfRVFVQUwoMCwgMTYpKQ0K
PiArCWlmICghc2V2X3ZlcnNpb25fZ3JlYXRlcl9vcl9lcXVhbCgwLCAxNikpDQo+ICAJCXJldHVy
biAtRU5PVFNVUFA7DQo+ICANCj4gIAkvKiBTRVYgRlcgZXhwZWN0cyB0aGUgYnVmZmVyIGl0IGZp
bGxzIHdpdGggdGhlIElEIHRvIGJlDQo+IEBAIC0xMDUzLDcgKzEwNTgsNyBAQCB2b2lkIHBzcF9w
Y2lfaW5pdCh2b2lkKQ0KPiAgCQlwc3BfbWFzdGVyLT5zZXZfc3RhdGUgPSBTRVZfU1RBVEVfVU5J
TklUOw0KPiAgCX0NCj4gIA0KPiAtCWlmIChTRVZfVkVSU0lPTl9HUkVBVEVSX09SX0VRVUFMKDAs
IDE1KSAmJg0KPiArCWlmIChzZXZfdmVyc2lvbl9ncmVhdGVyX29yX2VxdWFsKDAsIDE1KSAmJg0K
PiAgCSAgICBzZXZfdXBkYXRlX2Zpcm13YXJlKHBzcF9tYXN0ZXItPmRldikgPT0gMCkNCj4gIAkJ
c2V2X2dldF9hcGlfdmVyc2lvbigpOw0KPiAgDQo+IA0K
