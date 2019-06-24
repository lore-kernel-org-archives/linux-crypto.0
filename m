Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DBAC43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30D8020657
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:30:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="1sTiRAnO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfFXTaJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:30:09 -0400
Received: from mail-eopbgr810052.outbound.protection.outlook.com ([40.107.81.52]:22917
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728413AbfFXTaJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:30:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ruTpwtkmEkVWXcIoZRJ30eLH+aCcboXyA4NEc9X204=;
 b=1sTiRAnO5NHG7bwApsK8cuVvK1jYfdnvf2xdS4zM+RzEzB75IdHolkkFXyeltiRDtOeevyLrkMCP4IsJyp6PhvF8OplWcuhvdpIAreB/1799Dfv0cHJn1br1b7broxkAGbVdLXHGCbMCE41RBvV++eUK923g7NuYJukflF+YiIc=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2358.namprd12.prod.outlook.com (52.132.141.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 19:29:40 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 19:29:40 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 10/11] crypto: ccp - Add a module parameter to control
 registration for DMA
Thread-Topic: [PATCH 10/11] crypto: ccp - Add a module parameter to control
 registration for DMA
Thread-Index: AQHVKsMq0yf3hKsaOUaFOuVjVcnvPw==
Date:   Mon, 24 Jun 2019 19:29:40 +0000
Message-ID: <156140457814.116890.11773936937983757340.stgit@sosrh3.amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
In-Reply-To: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0701CA0040.namprd07.prod.outlook.com
 (2603:10b6:803:2d::18) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bef6d004-a155-4155-d1b1-08d6f8da4d09
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2358;
x-ms-traffictypediagnostic: DM5PR12MB2358:
x-microsoft-antispam-prvs: <DM5PR12MB23587BBB0C962A6C5C910DF4FDE00@DM5PR12MB2358.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:751;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(39860400002)(366004)(199004)(189003)(7736002)(5660300002)(26005)(2906002)(68736007)(8936002)(305945005)(186003)(386003)(66476007)(76176011)(8676002)(6506007)(64756008)(102836004)(81156014)(53936002)(52116002)(4326008)(66556008)(6486002)(66446008)(66946007)(73956011)(316002)(5640700003)(6916009)(25786009)(6436002)(81166006)(2501003)(6512007)(3846002)(2351001)(71200400001)(71190400001)(99286004)(103116003)(54906003)(14444005)(6116002)(256004)(476003)(72206003)(66066001)(14454004)(446003)(478600001)(486006)(11346002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2358;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mosGT0dGUzPMvU47lPH8xt8mmEaVDpLU9e1qIaMxAXKen8IT79hvfv26WM2+KnPva2lY0QEt/RT2ztEAzkPc7tUrOg3P3yt01Tid7aIEBE6oAUt6GbnK7W9rPDOjCj/5GLhePyPN0rbSVhNaZ0YtP9EVRdWdfobVD3Yy43husL201GjZp06K9WAWYOSl67hukLEhnwcApybW2BWdtENyxEbI4CpwdJ5CCTak/yknmbn6VGS2xqvRSHLVa/RdCI/p9K6BjJR66/kwDmRZKzBRU722jwyCSC3HCyEusxdmYL4cVmlViQcKeMo9FpGb4RHFrQiKzqQHmFhKiJwWzO8FBTkwlAPxP5s8OLB66dJlU2+th6a6SzP4xc14+a36d9JNbUdEEDu2tno8gUS3d/3g2PMNfnO1rTtbsTWDalCnnWU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3C151357D58F74EB89C443DE129C519@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef6d004-a155-4155-d1b1-08d6f8da4d09
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:29:40.1284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2358
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VGhlIENDUCBkcml2ZXIgaXMgYWJsZSB0byBhY3QgYXMgYSBETUEgZW5naW5lLiBBZGQgYSBtb2R1
bGUgcGFyYW1ldGVyIHRoYXQNCmFsbG93cyB0aGlzIGZlYXR1cmUgdG8gYmUgZW5hYmxlZC9kaXNh
YmxlZC4NCg0KU2lnbmVkLW9mZi1ieTogR2FyeSBSIEhvb2sgPGdhcnkuaG9va0BhbWQuY29tPg0K
LS0tDQogZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYyB8ICAgMTEgKysrKysrKy0tLS0N
CiBkcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oICAgIHwgICAgMSArDQogZHJpdmVycy9jcnlw
dG8vY2NwL3NwLXBjaS5jICAgICB8ICAgIDggKysrKysrKysNCiAzIGZpbGVzIGNoYW5nZWQsIDE2
IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Ny
eXB0by9jY3AvY2NwLWRldi12NS5jIGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYw0K
aW5kZXggZmZkNTQ2Yjk1MWI2Li5kZmQ4MDNmNmZiNTUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2Ny
eXB0by9jY3AvY2NwLWRldi12NS5jDQorKysgYi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi12
NS5jDQpAQCAtOTc2LDkgKzk3NiwxMSBAQCBzdGF0aWMgaW50IGNjcDVfaW5pdChzdHJ1Y3QgY2Nw
X2RldmljZSAqY2NwKQ0KIAkJZ290byBlX2t0aHJlYWQ7DQogDQogCS8qIFJlZ2lzdGVyIHRoZSBE
TUEgZW5naW5lIHN1cHBvcnQgKi8NCi0JcmV0ID0gY2NwX2RtYWVuZ2luZV9yZWdpc3RlcihjY3Ap
Ow0KLQlpZiAocmV0KQ0KLQkJZ290byBlX2h3cm5nOw0KKwlpZiAoY2NwX3JlZ2lzdGVyX2RtYSgp
KSB7DQorCQlyZXQgPSBjY3BfZG1hZW5naW5lX3JlZ2lzdGVyKGNjcCk7DQorCQlpZiAocmV0KQ0K
KwkJCWdvdG8gZV9od3JuZzsNCisJfQ0KIA0KICNpZmRlZiBDT05GSUdfQ1JZUFRPX0RFVl9DQ1Bf
REVCVUdGUw0KIAkvKiBTZXQgdXAgZGVidWdmcyBlbnRyaWVzICovDQpAQCAtMTAxMyw3ICsxMDE1
LDggQEAgc3RhdGljIHZvaWQgY2NwNV9kZXN0cm95KHN0cnVjdCBjY3BfZGV2aWNlICpjY3ApDQog
CXVuc2lnbmVkIGludCBpOw0KIA0KIAkvKiBVbnJlZ2lzdGVyIHRoZSBETUEgZW5naW5lICovDQot
CWNjcF9kbWFlbmdpbmVfdW5yZWdpc3RlcihjY3ApOw0KKwlpZiAoY2NwX3JlZ2lzdGVyX2RtYSgp
KQ0KKwkJY2NwX2RtYWVuZ2luZV91bnJlZ2lzdGVyKGNjcCk7DQogDQogCS8qIFVucmVnaXN0ZXIg
dGhlIFJORyAqLw0KIAljY3BfdW5yZWdpc3Rlcl9ybmcoY2NwKTsNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oIGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYuaA0K
aW5kZXggY2QxYmQ3OGQ5NWNjLi4zMjNmN2Q4Y2U0NTQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2Ny
eXB0by9jY3AvY2NwLWRldi5oDQorKysgYi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oDQpA
QCAtNjQ3LDYgKzY0Nyw3IEBAIGludCBjY3BfcmVnaXN0ZXJfcm5nKHN0cnVjdCBjY3BfZGV2aWNl
ICpjY3ApOw0KIHZvaWQgY2NwX3VucmVnaXN0ZXJfcm5nKHN0cnVjdCBjY3BfZGV2aWNlICpjY3Ap
Ow0KIGludCBjY3BfZG1hZW5naW5lX3JlZ2lzdGVyKHN0cnVjdCBjY3BfZGV2aWNlICpjY3ApOw0K
IHZvaWQgY2NwX2RtYWVuZ2luZV91bnJlZ2lzdGVyKHN0cnVjdCBjY3BfZGV2aWNlICpjY3ApOw0K
K3Vuc2lnbmVkIGludCBjY3BfcmVnaXN0ZXJfZG1hKHZvaWQpOw0KIA0KIHZvaWQgY2NwNV9kZWJ1
Z2ZzX3NldHVwKHN0cnVjdCBjY3BfZGV2aWNlICpjY3ApOw0KIHZvaWQgY2NwNV9kZWJ1Z2ZzX2Rl
c3Ryb3kodm9pZCk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jIGIv
ZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jDQppbmRleCA4NmRlZTJhNjZmMDAuLjViMGE5YzE0
NWM1YSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1wY2kuYw0KKysrIGIvZHJp
dmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jDQpAQCAtNTcsNiArNTcsMTAgQEAgc3RhdGljIHVuc2ln
bmVkIGludCBucXVldWVzID0gTUFYX0hXX1FVRVVFUzsNCiBtb2R1bGVfcGFyYW0obnF1ZXVlcywg
dWludCwgMDQ0NCk7DQogTU9EVUxFX1BBUk1fREVTQyhucXVldWVzLCAiTnVtYmVyIG9mIHF1ZXVl
cyBwZXIgQ0NQIChkZWZhdWx0OiA1KSIpOw0KIA0KK3N0YXRpYyB1bnNpZ25lZCBpbnQgcmVnaXN0
ZXJkbWEgPSAxOw0KK21vZHVsZV9wYXJhbShyZWdpc3RlcmRtYSwgdWludCwgMDQ0NCk7DQorTU9E
VUxFX1BBUk1fREVTQyhyZWdpc3RlcmRtYSwgIlJlZ2lzdGVyIHNlcnZpY2VzIHdpdGggdGhlIERN
QSBlbmdpbmUgKGRlZmF1bHQ6IDEpIik7DQorDQogI2RlZmluZSBDT01NQSAgICcsJw0KIHN0YXRp
YyB2b2lkIGNjcF9wYXJzZV9wY2lfYnVzZXModm9pZCkNCiB7DQpAQCAtMTU0LDYgKzE1OCwxMCBA
QCB1bnNpZ25lZCBpbnQgY2NwX2dldF9ucXVldWVzX3BhcmFtKHZvaWQpIHsNCiAJcmV0dXJuIG5x
dWV1ZXM7DQogfQ0KIA0KK3Vuc2lnbmVkIGludCBjY3BfcmVnaXN0ZXJfZG1hKHZvaWQpIHsNCisJ
cmV0dXJuIHJlZ2lzdGVyZG1hOw0KK30NCisNCiAjZGVmaW5lIE1TSVhfVkVDVE9SUwkJCTINCiAN
CiBzdHJ1Y3Qgc3BfcGNpIHsNCg0K
