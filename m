Return-Path: <SRS0=mwGE=VG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3851C73C50
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 15:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DDB82166E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 15:07:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="XgbjWvcb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfGIPHc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:07:32 -0400
Received: from mail-eopbgr780071.outbound.protection.outlook.com ([40.107.78.71]:26571
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbfGIPHb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 11:07:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfnC2/m/MFg9EHjDjHxud/UiI6lOjjezdB8NnZ1IpJw=;
 b=XgbjWvcb+2tDUbJmYen7rwzmogMW9dHwvTeN0gjNd+hWPPyKzOApsjtKyc0GefL1mraKC2VJx3CQS8vVaDFx/GOdb/IHVoqrdkaEU3jXLok/6hYCf7PRu+4/KC8AfWp6F2owrmADqcdTcExCAFRU5KzHW2PjHvZY42ANjP6cyGM=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1420.namprd12.prod.outlook.com (10.168.239.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Tue, 9 Jul 2019 15:07:22 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.019; Tue, 9 Jul 2019
 15:07:22 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH v2 2/4] crypto: ccp - Add a module parameter to specify a
 queue count
Thread-Topic: [PATCH v2 2/4] crypto: ccp - Add a module parameter to specify a
 queue count
Thread-Index: AQHVNmgClYXDRarhE0GjTEUyKf6VXw==
Date:   Tue, 9 Jul 2019 15:07:22 +0000
Message-ID: <156268484090.18577.16731799957627038546.stgit@sosrh3.amd.com>
References: <156268468861.18577.13211913750250195885.stgit@sosrh3.amd.com>
In-Reply-To: <156268468861.18577.13211913750250195885.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN2PR01CA0015.prod.exchangelabs.com (2603:10b6:804:2::25)
 To DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b28cbed0-417b-4448-5f3f-08d7047f24da
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1420;
x-ms-traffictypediagnostic: DM5PR12MB1420:
x-microsoft-antispam-prvs: <DM5PR12MB14203A102DD4CF666046BFD2FDF10@DM5PR12MB1420.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(199004)(189003)(71200400001)(66066001)(76176011)(8936002)(102836004)(81156014)(26005)(8676002)(7736002)(71190400001)(256004)(81166006)(6512007)(186003)(72206003)(99286004)(305945005)(86362001)(386003)(52116002)(53936002)(6506007)(2351001)(6436002)(66476007)(66556008)(64756008)(66446008)(446003)(316002)(11346002)(6916009)(25786009)(68736007)(478600001)(6486002)(6116002)(3846002)(5660300002)(4326008)(66946007)(5640700003)(2906002)(2501003)(103116003)(476003)(486006)(14444005)(14454004)(73956011)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1420;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rV3Bs7h9JHKrjStbdqLr1AZ2EVu0kefaOn329kWi+PsghEKT/2A1vfhGXlKY71HrSN/V1j7Buz1QZW6AZIAzpeVg6u+A46tW7Ur50mNn27ttXKd/jnO3gJin4GjGOtqMlTUTVaf/ufiDP+dAO/gfqTDFv23asIf/n+PDyo1xrTfqNNurHj1ZGqUg6h1XlPouZW0dlD2ZISyImcdoTT+3+ZQrGdeSLyU+8Z/3n1OCLZMMurPWcz0LOJHQgxpOlJ5pdk5HtoZsm1keMlUiCARInLiNMOdAZtNuVMsgLDvBRtA4wpAd8IrcJbVIyY3vdxv8jPrNLFKn1BiffmKZ9gPGM5WGMysaMI1dZojGTbEpsT9KmJ7ydxdVMwSbdCWIGaIoN6qTjgRd3Akbzdv4eqp5H0l5uvkl65X3n7jpfqupIGk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D6DFEE2CAB25544924B9A775B126CC7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b28cbed0-417b-4448-5f3f-08d7047f24da
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 15:07:22.3794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1420
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

QWRkIGEgbW9kdWxlIHBhcmFtZXRlciB0byBsaW1pdCB0aGUgbnVtYmVyIG9mIHF1ZXVlcyBwZXIg
Q0NQLiBUaGUgZGVmYXVsdA0KdmFsdWUgKG5xdWV1ZXM9MCkgaXMgdG8gc2V0IHVwIGV2ZXJ5IGF2
YWlsYWJsZSBxdWV1ZSBvbiBlYWNoIGRldmljZS4NCg0KVGhlIGNvdW50IG9mIHF1ZXVlcyBzdGFy
dHMgZnJvbSB0aGUgZmlyc3Qgb25lIGZvdW5kIG9uIHRoZSBkZXZpY2UgKHdoaWNoDQp2YXJpZXMg
YmFzZWQgb24gdGhlIGRldmljZSBJRCkuDQoNClNpZ25lZC1vZmYtYnk6IEdhcnkgUiBIb29rIDxn
YXJ5Lmhvb2tAYW1kLmNvbT4NCi0tLQ0KIGRyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LXYzLmMg
fCAgICAyICstDQogZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYyB8ICAgIDcgKystLS0t
LQ0KIGRyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LmMgICAgfCAgIDExICsrKysrKysrKysrDQog
ZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYuaCAgICB8ICAgIDEgKw0KIDQgZmlsZXMgY2hhbmdl
ZCwgMTUgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvY3J5cHRvL2NjcC9jY3AtZGV2LXYzLmMgYi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi12
My5jDQppbmRleCAyMzM5YTgxMDFhNTIuLjE2YmM0NTcxNzE5OCAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvY3J5cHRvL2NjcC9jY3AtZGV2LXYzLmMNCisrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3At
ZGV2LXYzLmMNCkBAIC0zNzksNyArMzc5LDcgQEAgc3RhdGljIGludCBjY3BfaW5pdChzdHJ1Y3Qg
Y2NwX2RldmljZSAqY2NwKQ0KIAkvKiBGaW5kIGF2YWlsYWJsZSBxdWV1ZXMgKi8NCiAJY2NwLT5x
aW0gPSAwOw0KIAlxbXIgPSBpb3JlYWQzMihjY3AtPmlvX3JlZ3MgKyBRX01BU0tfUkVHKTsNCi0J
Zm9yIChpID0gMDsgaSA8IE1BWF9IV19RVUVVRVM7IGkrKykgew0KKwlmb3IgKGkgPSAwOyAoaSA8
IE1BWF9IV19RVUVVRVMpICYmIChjY3AtPmNtZF9xX2NvdW50IDwgY2NwLT5tYXhfcV9jb3VudCk7
IGkrKykgew0KIAkJaWYgKCEocW1yICYgKDEgPDwgaSkpKQ0KIAkJCWNvbnRpbnVlOw0KIA0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LXY1LmMgYi9kcml2ZXJzL2NyeXB0
by9jY3AvY2NwLWRldi12NS5jDQppbmRleCAzNDBkMDk4NGY4ZDcuLmNkNGM2YjFiNWM5YyAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LXY1LmMNCisrKyBiL2RyaXZlcnMv
Y3J5cHRvL2NjcC9jY3AtZGV2LXY1LmMNCkBAIC0yLDE2ICsyLDE0IEBADQogLyoNCiAgKiBBTUQg
Q3J5cHRvZ3JhcGhpYyBDb3Byb2Nlc3NvciAoQ0NQKSBkcml2ZXINCiAgKg0KLSAqIENvcHlyaWdo
dCAoQykgMjAxNiwyMDE3IEFkdmFuY2VkIE1pY3JvIERldmljZXMsIEluYy4NCisgKiBDb3B5cmln
aHQgKEMpIDIwMTYsMjAxOSBBZHZhbmNlZCBNaWNybyBEZXZpY2VzLCBJbmMuDQogICoNCiAgKiBB
dXRob3I6IEdhcnkgUiBIb29rIDxnYXJ5Lmhvb2tAYW1kLmNvbT4NCiAgKi8NCiANCi0jaW5jbHVk
ZSA8bGludXgvbW9kdWxlLmg+DQogI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPg0KICNpbmNsdWRl
IDxsaW51eC9wY2kuaD4NCiAjaW5jbHVkZSA8bGludXgva3RocmVhZC5oPg0KLSNpbmNsdWRlIDxs
aW51eC9kZWJ1Z2ZzLmg+DQogI2luY2x1ZGUgPGxpbnV4L2RtYS1tYXBwaW5nLmg+DQogI2luY2x1
ZGUgPGxpbnV4L2ludGVycnVwdC5oPg0KICNpbmNsdWRlIDxsaW51eC9jb21waWxlci5oPg0KQEAg
LTc5Miw4ICs3OTAsNyBAQCBzdGF0aWMgaW50IGNjcDVfaW5pdChzdHJ1Y3QgY2NwX2RldmljZSAq
Y2NwKQ0KIA0KIAkvKiBGaW5kIGF2YWlsYWJsZSBxdWV1ZXMgKi8NCiAJcW1yID0gaW9yZWFkMzIo
Y2NwLT5pb19yZWdzICsgUV9NQVNLX1JFRyk7DQotCWZvciAoaSA9IDA7IGkgPCBNQVhfSFdfUVVF
VUVTOyBpKyspIHsNCi0NCisJZm9yIChpID0gMDsgKGkgPCBNQVhfSFdfUVVFVUVTKSAmJiAoY2Nw
LT5jbWRfcV9jb3VudCA8IGNjcC0+bWF4X3FfY291bnQpOyBpKyspIHsNCiAJCWlmICghKHFtciAm
ICgxIDw8IGkpKSkNCiAJCQljb250aW51ZTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0
by9jY3AvY2NwLWRldi5jIGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYuYw0KaW5kZXggZjNm
ZjM2ZjkzMjA3Li4yM2NlZjg3YzA5NTAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NyeXB0by9jY3Av
Y2NwLWRldi5jDQorKysgYi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5jDQpAQCAtOCw2ICs4
LDcgQEANCiAgKiBBdXRob3I6IEdhcnkgUiBIb29rIDxnYXJ5Lmhvb2tAYW1kLmNvbT4NCiAgKi8N
CiANCisjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQogI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5o
Pg0KICNpbmNsdWRlIDxsaW51eC9rdGhyZWFkLmg+DQogI2luY2x1ZGUgPGxpbnV4L3NjaGVkLmg+
DQpAQCAtMjYsNiArMjcsMTEgQEANCiANCiAjaW5jbHVkZSAiY2NwLWRldi5oIg0KIA0KKy8qIExp
bWl0IENDUCB1c2UgdG8gYSBzcGVjaWZlZCBudW1iZXIgb2YgcXVldWVzIHBlciBkZXZpY2UgKi8N
CitzdGF0aWMgdW5zaWduZWQgaW50IG5xdWV1ZXMgPSAwOw0KK21vZHVsZV9wYXJhbShucXVldWVz
LCB1aW50LCAwNDQ0KTsNCitNT0RVTEVfUEFSTV9ERVNDKG5xdWV1ZXMsICJOdW1iZXIgb2YgcXVl
dWVzIHBlciBDQ1AgKG1pbmltdW0gMTsgZGVmYXVsdDogYWxsIGF2YWlsYWJsZSkiKTsNCisNCiBz
dHJ1Y3QgY2NwX3Rhc2tsZXRfZGF0YSB7DQogCXN0cnVjdCBjb21wbGV0aW9uIGNvbXBsZXRpb247
DQogCXN0cnVjdCBjY3BfY21kICpjbWQ7DQpAQCAtNTkyLDYgKzU5OCwxMSBAQCBpbnQgY2NwX2Rl
dl9pbml0KHN0cnVjdCBzcF9kZXZpY2UgKnNwKQ0KIAkJZ290byBlX2VycjsNCiAJc3AtPmNjcF9k
YXRhID0gY2NwOw0KIA0KKwlpZiAoIW5xdWV1ZXMgfHwgKG5xdWV1ZXMgPiBNQVhfSFdfUVVFVUVT
KSkNCisJCWNjcC0+bWF4X3FfY291bnQgPSBNQVhfSFdfUVVFVUVTOw0KKwllbHNlDQorCQljY3At
Pm1heF9xX2NvdW50ID0gbnF1ZXVlczsNCisNCiAJY2NwLT52ZGF0YSA9IChzdHJ1Y3QgY2NwX3Zk
YXRhICopc3AtPmRldl92ZGF0YS0+Y2NwX3ZkYXRhOw0KIAlpZiAoIWNjcC0+dmRhdGEgfHwgIWNj
cC0+dmRhdGEtPnZlcnNpb24pIHsNCiAJCXJldCA9IC1FTk9ERVY7DQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9jcnlwdG8vY2NwL2NjcC1kZXYuaCBiL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LmgN
CmluZGV4IDRhNTRlNzMxZjgzNi4uNWM5NmQzNDhlYzA5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9j
cnlwdG8vY2NwL2NjcC1kZXYuaA0KKysrIGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYuaA0K
QEAgLTM3OSw2ICszNzksNyBAQCBzdHJ1Y3QgY2NwX2RldmljZSB7DQogCSAqLw0KIAlzdHJ1Y3Qg
Y2NwX2NtZF9xdWV1ZSBjbWRfcVtNQVhfSFdfUVVFVUVTXTsNCiAJdW5zaWduZWQgaW50IGNtZF9x
X2NvdW50Ow0KKwl1bnNpZ25lZCBpbnQgbWF4X3FfY291bnQ7DQogDQogCS8qIFN1cHBvcnQgZm9y
IHRoZSBDQ1AgVHJ1ZSBSTkcNCiAJICovDQoNCg==
