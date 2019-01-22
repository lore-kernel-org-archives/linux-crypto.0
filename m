Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BBBC282C5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 22:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCAC1217D6
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 22:07:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="CjG+x8Je"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfAVWHA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 17:07:00 -0500
Received: from mail-eopbgr750079.outbound.protection.outlook.com ([40.107.75.79]:23200
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725925AbfAVWHA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 17:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+Nlgq6C21GXLV0RjpFDaKgVgBWRZRdfiBLXmlbe7WQ=;
 b=CjG+x8JeZTnfs8EYlyW9udeImRCN2pQewnCyl5bOut5OH2Gu8BvS2NSqOcA1otGKn9FiK8nd5YanALnt9ng1czehZWEfDhvZw3z4F/EuYu5LQ1thddNAoCL439MtVhUoJh2QeDsHvrxz2Mh2XHn9BlH41tzl7F/qEch9AC8gV8Y=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.38.138) by
 DM5PR12MB1241.namprd12.prod.outlook.com (10.168.237.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.28; Tue, 22 Jan 2019 22:06:55 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::f1ae:e660:a84b:3ed7]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::f1ae:e660:a84b:3ed7%9]) with mapi id 15.20.1537.031; Tue, 22 Jan 2019
 22:06:55 +0000
From:   Gary R Hook <ghook@amd.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: Re: [PATCH 6/7] crypto: ccp: no need to check return value of
 debugfs_create functions
Thread-Topic: [PATCH 6/7] crypto: ccp: no need to check return value of
 debugfs_create functions
Thread-Index: AQHUsmU55+qtBP6vRkSSSYlJ4h/boKW72MQA
Date:   Tue, 22 Jan 2019 22:06:54 +0000
Message-ID: <1330d284-560a-5e09-6d15-50da354d0da2@amd.com>
References: <20190122151422.14204-1-gregkh@linuxfoundation.org>
 <20190122151422.14204-7-gregkh@linuxfoundation.org>
In-Reply-To: <20190122151422.14204-7-gregkh@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0025.namprd05.prod.outlook.com
 (2603:10b6:803:40::38) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM5PR12MB1241;20:TOu1DddSpOGaDKApUahfS79xQJmhxvedbgkOLGy+BOcYxqmCyhL0do/S2hP0XGnl/0qEcquvBr69e3V8P1M7l2lH3AeGJFidimQs5sql6xN07WsDunW0tP7K3+T8KL+zugezbwoT/czr8z+nFSnepcJwJPAMtv70cxcwYE8MANYzo+iDwNWSyRrfNBJke/hOJzbWBD3pNSjTIFPSsHGeFwTCP6d5Ak77oxQRMNSHn7/mQdvccgtET17R+jP298nC
x-ms-office365-filtering-correlation-id: 55e13bf2-365e-417d-ea47-08d680b5eb6f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM5PR12MB1241;
x-ms-traffictypediagnostic: DM5PR12MB1241:
x-microsoft-antispam-prvs: <DM5PR12MB1241BFB44A18A4BB0061336DFD980@DM5PR12MB1241.namprd12.prod.outlook.com>
x-forefront-prvs: 0925081676
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(2616005)(478600001)(11346002)(476003)(6246003)(446003)(6436002)(14454004)(25786009)(4326008)(66066001)(486006)(53936002)(316002)(52116002)(6116002)(229853002)(81156014)(81166006)(2906002)(72206003)(3846002)(8936002)(76176011)(8676002)(54906003)(110136005)(256004)(14444005)(36756003)(26005)(7736002)(97736004)(31686004)(305945005)(99286004)(6486002)(106356001)(71190400001)(6512007)(102836004)(186003)(68736007)(71200400001)(386003)(6506007)(53546011)(105586002)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1241;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NrY4Kp+jC2eS4mQG8UdBLotFneQ/q1yJvZsXu+AIp87nWpiE2m5tpX3skUIAynmrMFWhhKGpBLu3uAVurUD/qrQxnMCUfHxEdsP+PUCrUP5oyrijitMybnv2m+XDjVCdwh7J6lXMZWVH1CJMesF2hvG6XEIJu9R+pkap9yV2pjvdKAvixPWNY1K/NBJzdpQTFs6CU18RvYstgS//gpy8ZI+evyLk6X4/f5ZZ77hJlYm5dcfCaNCaZq0BQ6jFBQSiBdj2O67F07FhN/r65u7biZ+QWEJT59oI0ZSc26MTzah60iiLcp+rz5EbpDot8CkZB7LNPLySuiO5/7FTir0CCtrhkxy06VYN8hDTxWlkSj4TlGmU59Q8Ph1VtTfCUraeGwC4lspRjNe5oQAGDjwlLXPxVwekHoFCXgsF+GvmZm8=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <83AAD56A7FBBDF4E93559CA2C4952BBB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55e13bf2-365e-417d-ea47-08d680b5eb6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2019 22:06:54.2146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1241
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMS8yMi8xOSA5OjE0IEFNLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+IFdoZW4gY2Fs
bGluZyBkZWJ1Z2ZzIGZ1bmN0aW9ucywgdGhlcmUgaXMgbm8gbmVlZCB0byBldmVyIGNoZWNrIHRo
ZQ0KPiByZXR1cm4gdmFsdWUuICBUaGUgZnVuY3Rpb24gY2FuIHdvcmsgb3Igbm90LCBidXQgdGhl
IGNvZGUgbG9naWMgc2hvdWxkDQo+IG5ldmVyIGRvIHNvbWV0aGluZyBkaWZmZXJlbnQgYmFzZWQg
b24gdGhpcy4NCg0KU3R1cGlkIHF1ZXN0aW9uKHMpIHRpbWUuDQoNCklmIHdlIGRvbid0IGNhcmUg
YWJvdXQgZmFpbHVyZXMgKGJlY2F1c2UgdGhlIHN1YnN5c3RlbSBoYW5kbGVzIHRoZW0gDQp3aXRo
b3V0IG91ciBpbnZvbHZlbWVudCkgd2h5IGRvIHRoZXNlIGZ1bmN0aW9ucyBldmVuIGhhdmUgcmV0
dXJuIHZhbHVlcz8gDQpXaHkgaGF2ZW4ndCB0aGV5IGJlZW4gY2hhbmdlZCB0byB2b2lkIHNvIHRo
YXQgdGhleSByZWZsZWN0IHRoZSBjdXJyZW50IA0Kc3R5bGUgb2YgaW50ZW5kZWQgdXNlPw0KDQpJ
IHJlYWxpemUgSSdtIG9sZCBmYXNoaW9uZWQsIGJ1dCBpZiBhIGZhaWx1cmUgb2NjdXJzLCBJJ3Zl
IGFsd2F5cyBiZWVuIA0Kb2YgYSBtaW5kIHRvIGtpY2sgb3V0IGFuZCBub3QgdHJ5IHRvIGRvIGFu
eSBmdXJ0aGVyIHdvcmsuIEJ1dCBkZWJ1Z2ZzIGlzIA0KdG8gYmUgdHJlYXRlZCBhcyBhbiBleGNl
cHRpb24gdG8gdGhhdCBwYXJhZGlnbT8gQ2Fycnkgb24sIGlnbm9yZSBlcnJvcnMsIA0KZG9uJ3Qg
d29ycnkgYWJvdXQgaXQ/DQoNClRoYXQgc2FpZCwNCg0KQWNrZWQtYnk6IEdhcnkgUiBIb29rIDxn
YXJ5Lmhvb2tAYW1kLmNvbT4NCg0KPiANCj4gQ2M6IFRvbSBMZW5kYWNreSA8dGhvbWFzLmxlbmRh
Y2t5QGFtZC5jb20+DQo+IENjOiBHYXJ5IEhvb2sgPGdhcnkuaG9va0BhbWQuY29tPg0KPiBDYzog
SGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KPiBDYzogIkRhdmlkIFMu
IE1pbGxlciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+IENjOiBsaW51eC1jcnlwdG9Admdlci5r
ZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxp
bnV4Zm91bmRhdGlvbi5vcmc+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGVi
dWdmcy5jIHwgMzYgKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gICAxIGZpbGUg
Y2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAyOSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRlYnVnZnMuYyBiL2RyaXZlcnMvY3J5cHRvL2Nj
cC9jY3AtZGVidWdmcy5jDQo+IGluZGV4IDFhNzM0YmQyMDcwYS4uNGJkMjZhZjcwOThkIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRlYnVnZnMuYw0KPiArKysgYi9kcml2
ZXJzL2NyeXB0by9jY3AvY2NwLWRlYnVnZnMuYw0KPiBAQCAtMjg2LDEwICsyODYsNyBAQCB2b2lk
IGNjcDVfZGVidWdmc19zZXR1cChzdHJ1Y3QgY2NwX2RldmljZSAqY2NwKQ0KPiAgIHsNCj4gICAJ
c3RydWN0IGNjcF9jbWRfcXVldWUgKmNtZF9xOw0KPiAgIAljaGFyIG5hbWVbTUFYX05BTUVfTEVO
ICsgMV07DQo+IC0Jc3RydWN0IGRlbnRyeSAqZGVidWdmc19pbmZvOw0KPiAtCXN0cnVjdCBkZW50
cnkgKmRlYnVnZnNfc3RhdHM7DQo+ICAgCXN0cnVjdCBkZW50cnkgKmRlYnVnZnNfcV9pbnN0YW5j
ZTsNCj4gLQlzdHJ1Y3QgZGVudHJ5ICpkZWJ1Z2ZzX3Ffc3RhdHM7DQo+ICAgCWludCBpOw0KPiAg
IA0KPiAgIAlpZiAoIWRlYnVnZnNfaW5pdGlhbGl6ZWQoKSkNCj4gQEAgLTI5OSwyNCArMjk2LDE0
IEBAIHZvaWQgY2NwNV9kZWJ1Z2ZzX3NldHVwKHN0cnVjdCBjY3BfZGV2aWNlICpjY3ApDQo+ICAg
CWlmICghY2NwX2RlYnVnZnNfZGlyKQ0KPiAgIAkJY2NwX2RlYnVnZnNfZGlyID0gZGVidWdmc19j
cmVhdGVfZGlyKEtCVUlMRF9NT0ROQU1FLCBOVUxMKTsNCj4gICAJbXV0ZXhfdW5sb2NrKCZjY3Bf
ZGVidWdmc19sb2NrKTsNCj4gLQlpZiAoIWNjcF9kZWJ1Z2ZzX2RpcikNCj4gLQkJcmV0dXJuOw0K
PiAgIA0KPiAgIAljY3AtPmRlYnVnZnNfaW5zdGFuY2UgPSBkZWJ1Z2ZzX2NyZWF0ZV9kaXIoY2Nw
LT5uYW1lLCBjY3BfZGVidWdmc19kaXIpOw0KPiAtCWlmICghY2NwLT5kZWJ1Z2ZzX2luc3RhbmNl
KQ0KPiAtCQlnb3RvIGVycjsNCj4gICANCj4gLQlkZWJ1Z2ZzX2luZm8gPSBkZWJ1Z2ZzX2NyZWF0
ZV9maWxlKCJpbmZvIiwgMDQwMCwNCj4gLQkJCQkJICAgY2NwLT5kZWJ1Z2ZzX2luc3RhbmNlLCBj
Y3AsDQo+IC0JCQkJCSAgICZjY3BfZGVidWdmc19pbmZvX29wcyk7DQo+IC0JaWYgKCFkZWJ1Z2Zz
X2luZm8pDQo+IC0JCWdvdG8gZXJyOw0KPiArCWRlYnVnZnNfY3JlYXRlX2ZpbGUoImluZm8iLCAw
NDAwLCBjY3AtPmRlYnVnZnNfaW5zdGFuY2UsIGNjcCwNCj4gKwkJCSAgICAmY2NwX2RlYnVnZnNf
aW5mb19vcHMpOw0KPiAgIA0KPiAtCWRlYnVnZnNfc3RhdHMgPSBkZWJ1Z2ZzX2NyZWF0ZV9maWxl
KCJzdGF0cyIsIDA2MDAsDQo+IC0JCQkJCSAgICBjY3AtPmRlYnVnZnNfaW5zdGFuY2UsIGNjcCwN
Cj4gLQkJCQkJICAgICZjY3BfZGVidWdmc19zdGF0c19vcHMpOw0KPiAtCWlmICghZGVidWdmc19z
dGF0cykNCj4gLQkJZ290byBlcnI7DQo+ICsJZGVidWdmc19jcmVhdGVfZmlsZSgic3RhdHMiLCAw
NjAwLCBjY3AtPmRlYnVnZnNfaW5zdGFuY2UsIGNjcCwNCj4gKwkJCSAgICAmY2NwX2RlYnVnZnNf
c3RhdHNfb3BzKTsNCj4gICANCj4gICAJZm9yIChpID0gMDsgaSA8IGNjcC0+Y21kX3FfY291bnQ7
IGkrKykgew0KPiAgIAkJY21kX3EgPSAmY2NwLT5jbWRfcVtpXTsNCj4gQEAgLTMyNSwyMSArMzEy
LDEyIEBAIHZvaWQgY2NwNV9kZWJ1Z2ZzX3NldHVwKHN0cnVjdCBjY3BfZGV2aWNlICpjY3ApDQo+
ICAgDQo+ICAgCQlkZWJ1Z2ZzX3FfaW5zdGFuY2UgPQ0KPiAgIAkJCWRlYnVnZnNfY3JlYXRlX2Rp
cihuYW1lLCBjY3AtPmRlYnVnZnNfaW5zdGFuY2UpOw0KPiAtCQlpZiAoIWRlYnVnZnNfcV9pbnN0
YW5jZSkNCj4gLQkJCWdvdG8gZXJyOw0KPiAtDQo+IC0JCWRlYnVnZnNfcV9zdGF0cyA9DQo+IC0J
CQlkZWJ1Z2ZzX2NyZWF0ZV9maWxlKCJzdGF0cyIsIDA2MDAsDQo+IC0JCQkJCSAgICBkZWJ1Z2Zz
X3FfaW5zdGFuY2UsIGNtZF9xLA0KPiAtCQkJCQkgICAgJmNjcF9kZWJ1Z2ZzX3F1ZXVlX29wcyk7
DQo+IC0JCWlmICghZGVidWdmc19xX3N0YXRzKQ0KPiAtCQkJZ290byBlcnI7DQo+ICsNCj4gKwkJ
ZGVidWdmc19jcmVhdGVfZmlsZSgic3RhdHMiLCAwNjAwLCBkZWJ1Z2ZzX3FfaW5zdGFuY2UsIGNt
ZF9xLA0KPiArCQkJCSAgICAmY2NwX2RlYnVnZnNfcXVldWVfb3BzKTsNCj4gICAJfQ0KPiAgIA0K
PiAgIAlyZXR1cm47DQo+IC0NCj4gLWVycjoNCj4gLQlkZWJ1Z2ZzX3JlbW92ZV9yZWN1cnNpdmUo
Y2NwLT5kZWJ1Z2ZzX2luc3RhbmNlKTsNCj4gICB9DQo+ICAgDQo+ICAgdm9pZCBjY3A1X2RlYnVn
ZnNfZGVzdHJveSh2b2lkKQ0KPiANCg0K
