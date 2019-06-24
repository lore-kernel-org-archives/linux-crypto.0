Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271C8C48BEA
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E702720657
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:30:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="NgJh0y2Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbfFXTar (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:30:47 -0400
Received: from mail-eopbgr810058.outbound.protection.outlook.com ([40.107.81.58]:14990
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727947AbfFXTaq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EnuV2vSdaLTFayGZ51p7Bh9Eh07YERVYXzq4dP7z16A=;
 b=NgJh0y2Qz14Soehh4EEHBt9vXWFEJa0E7NVaQI/F/Y9sarnhfyC//52UZbimmYIsTkV7rr64a58AGd+uAVINmwT4twU4J8uaW+UZZSKi+QxNl/TYYEppc2RZnMvI/tqabpXqbfyHF39km3rU5JuSKOqRfc0QKvxagl3+oLG95cQ=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2358.namprd12.prod.outlook.com (52.132.141.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 19:29:32 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 19:29:32 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 09/11] crypto: ccp - expose pcibus module parameter in debugfs
Thread-Topic: [PATCH 09/11] crypto: ccp - expose pcibus module parameter in
 debugfs
Thread-Index: AQHVKsMmqgCCjBTLREqK0KzRDmMnqA==
Date:   Mon, 24 Jun 2019 19:29:32 +0000
Message-ID: <156140457094.116890.3963045455964868732.stgit@sosrh3.amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
In-Reply-To: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0701CA0046.namprd07.prod.outlook.com
 (2603:10b6:803:2d::33) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5679583c-5ec0-40a5-9801-08d6f8da48ba
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2358;
x-ms-traffictypediagnostic: DM5PR12MB2358:
x-microsoft-antispam-prvs: <DM5PR12MB2358B6E1AFB57B32827542C4FDE00@DM5PR12MB2358.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:261;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(39860400002)(366004)(199004)(189003)(7736002)(5660300002)(26005)(2906002)(68736007)(8936002)(305945005)(186003)(386003)(66476007)(76176011)(8676002)(6506007)(64756008)(102836004)(81156014)(53936002)(52116002)(4326008)(66556008)(6486002)(66446008)(66946007)(73956011)(316002)(5640700003)(6916009)(25786009)(6436002)(81166006)(2501003)(6512007)(3846002)(2351001)(71200400001)(71190400001)(99286004)(103116003)(54906003)(6116002)(256004)(476003)(72206003)(66066001)(14454004)(446003)(478600001)(486006)(11346002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2358;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CwulD/VXiHCyzQCzyNzZuAMkNacJewSoY8T7bx08MQ8UNYLVbxtl+0YVMY/jAnAAMXkTK9W5XN1VF4uWEX8JGoW3wtQX2Uv82AqVWAQZT9plQBwH9uRIpbGTiu3zPrdkabJVRFt2c8q5mbbQhYKVfN58AApF9IUVanqd9GzjL9ClvaHkyqeiKIfBvVL6x1ynxy0ksC33uyIO0eg9KtJSDUDMG7bkDWKq8MZIM5ySI65CucZGRBfLHkeeDT4SnkoZ0bosFSif3ZmonaW4bMjWSQZ5HOxdjVFoSt/v3Nc2BCqTVjEH8vxLAtWl73lILNjPU8MIQ2Zu24H/hsxIOtTwOHKCXGH0mJYSV7Sz061xOGQ6/ax76fwhAWy4f3p31WYVLZbmnziZd7eFRR4SLSqxuM+qu4du25cbCp138fLBoWU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5FA4BA70DF58CA468406DAF50FF041CE@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5679583c-5ec0-40a5-9801-08d6f8da48ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:29:32.9113
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

QWRkIG1vZHVsZSBwYXJhbWV0ZXIgcGNpYnVzIGFzIGEgcmVhZC1vbmx5IHZhcmlhYmxlIHRvIHRo
ZSBDQ1Ancw0KZGVidWdmcyBpbmZvLg0KDQpTaWduZWQtb2ZmLWJ5OiBHYXJ5IFIgSG9vayA8Z2Fy
eS5ob29rQGFtZC5jb20+DQotLS0NCiBkcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRlYnVnZnMuYyB8
ICAgIDEgKw0KIGRyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LmggICAgIHwgICAgMSArDQogZHJp
dmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jICAgICAgfCAgIDQ3ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKy0tDQogMyBmaWxlcyBjaGFuZ2VkLCA0NyBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZWJ1
Z2ZzLmMgYi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRlYnVnZnMuYw0KaW5kZXggYzRjYzBlNjBm
ZDUwLi43YTIyM2I3MWVlZTggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRl
YnVnZnMuYw0KKysrIGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZWJ1Z2ZzLmMNCkBAIC0zMTgs
NiArMzE4LDcgQEAgdm9pZCBjY3A1X2RlYnVnZnNfc2V0dXAoc3RydWN0IGNjcF9kZXZpY2UgKmNj
cCkNCiAJfQ0KIA0KIAljY3BfZGVidWdmc19yZWdpc3Rlcl9tb2RwYXJhbXMoY2NwX2RlYnVnZnNf
ZGlyKTsNCisJY2NwX2RlYnVnZnNfcmVnaXN0ZXJfYnVzZXMoY2NwX2RlYnVnZnNfZGlyKTsNCiAN
CiAJcmV0dXJuOw0KIH0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5o
IGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYuaA0KaW5kZXggZDgxMjQ0NjIxM2VlLi5jZDFi
ZDc4ZDk1Y2MgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oDQorKysg
Yi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oDQpAQCAtNjgzLDYgKzY4Myw3IEBAIHR5cGVk
ZWYgc3RydWN0IF9tb2RwYXJhbSB7DQogICAgICAgICAgICAgICAgIHVtb2RlX3QgcGFyYW1tb2Rl
Ow0KICAgICAgICAgfSBtb2RwYXJhbV90Ow0KIGV4dGVybiB2b2lkIGNjcF9kZWJ1Z2ZzX3JlZ2lz
dGVyX21vZHBhcmFtcyhzdHJ1Y3QgZGVudHJ5ICpwYXJlbnRkaXIpOw0KK2V4dGVybiB2b2lkIGNj
cF9kZWJ1Z2ZzX3JlZ2lzdGVyX2J1c2VzKHN0cnVjdCBkZW50cnkgKnBhcmVudGRpcik7DQogDQog
I2VuZGlmDQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jIGIvZHJp
dmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jDQppbmRleCBhNTYzZDg1YjI0MmUuLjg2ZGVlMmE2NmYw
MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1wY2kuYw0KKysrIGIvZHJpdmVy
cy9jcnlwdG8vY2NwL3NwLXBjaS5jDQpAQCAtNjIsNiArNjIsNyBAQCBzdGF0aWMgdm9pZCBjY3Bf
cGFyc2VfcGNpX2J1c2VzKHZvaWQpDQogew0KIAl1bnNpZ25lZCBpbnQgYnVzbm87DQogCXVuc2ln
bmVkIGludCBlb3MgPSAwOw0KKwljaGFyICpidXNhcmc7DQogCWludCByZXQ7DQogCWNoYXIgKmNv
bW1hOw0KIAljaGFyICp0b2s7DQpAQCAtNzAsNyArNzEsOSBAQCBzdGF0aWMgdm9pZCBjY3BfcGFy
c2VfcGNpX2J1c2VzKHZvaWQpDQogCWlmICghYnVzZXMpDQogCQlyZXR1cm47DQogDQotCWNvbW1h
ID0gdG9rID0gYnVzZXM7DQorCWJ1c2FyZyA9IGtzdHJkdXAoYnVzZXMsIEdGUF9LRVJORUwpOw0K
Kw0KKwljb21tYSA9IHRvayA9IGJ1c2FyZzsNCiAJd2hpbGUgKCFlb3MgJiYgKnRvayAmJiAobl9w
Y2lidXMgPCBNQVhDQ1BTKSkgew0KIAkJd2hpbGUgKCpjb21tYSAmJiAqY29tbWEgIT0gQ09NTUEp
DQogCQkJY29tbWErKzsNCkBAIC04MSwxMSArODQsMTUgQEAgc3RhdGljIHZvaWQgY2NwX3BhcnNl
X3BjaV9idXNlcyh2b2lkKQ0KIAkJcmV0ID0ga3N0cnRvdWludCh0b2ssIDAsICZidXNubyk7DQog
CQlpZiAocmV0KSB7DQogCQkJcHJfaW5mbygiJXM6IFBhcnNpbmcgZXJyb3IgKCVkKSAnJXMnXG4i
LCBfX2Z1bmNfXywgcmV0LCBidXNlcyk7DQotCQkJcmV0dXJuOw0KKwkJCW5fcGNpYnVzID0gMDsg
LyogcHJldGVuZCB0aGVyZSB3YXMgbm8gcGFyYW1ldGVyICovDQorCQkJZ290byBlcnI7DQogCQl9
DQogCQlwY2lidXNbbl9wY2lidXMrK10gPSBidXNubzsNCiAJCXRvayA9ICsrY29tbWE7DQogCX0N
CisNCitlcnI6DQorCWtmcmVlKGJ1c2FyZyk7DQogfQ0KIA0KICNpZmRlZiBDT05GSUdfQ1JZUFRP
X0RFVl9DQ1BfREVCVUdGUw0KQEAgLTEwNiw2ICsxMTMsNDEgQEAgdm9pZCBjY3BfZGVidWdmc19y
ZWdpc3Rlcl9tb2RwYXJhbXMoc3RydWN0IGRlbnRyeSAqcGFyZW50ZGlyKQ0KIAkJCQkgICBtb2R1
bGVwYXJhbWV0ZXJzW2pdLnBhcmFtKTsNCiB9DQogDQorc3RhdGljIHNzaXplX3QgY2NwX2RlYnVn
ZnNfYnVzZXNfcmVhZChzdHJ1Y3QgZmlsZSAqZmlscCwgY2hhciBfX3VzZXIgKnVidWYsDQorCQkJ
CSAgICAgIHNpemVfdCBjb3VudCwgbG9mZl90ICpvZmZwKQ0KK3sNCisJY2hhciAqc3RyaW5nID0g
ZmlscC0+cHJpdmF0ZV9kYXRhOw0KKwl1bnNpZ25lZCBpbnQgb2JvZmYgPSAwOw0KKwl1bnNpZ25l
ZCBwbGVuID0gMTAyMzsNCisJc3NpemVfdCByZXQ7DQorCWNoYXIgKm9idWY7DQorDQorCWlmICgh
c3RyaW5nKQ0KKwkJc3RyaW5nID0gIihBTEwpIjsNCisJb2J1ZiA9IGttYWxsb2MocGxlbiArIDEs
IEdGUF9LRVJORUwpOw0KKwlpZiAoIW9idWYpDQorCQlyZXR1cm4gLUVOT01FTTsNCisNCisJb2Jv
ZmYgKz0gc25wcmludGYob2J1ZiwgcGxlbiwgIiVzXG4iLCBzdHJpbmcpOw0KKw0KKwlyZXQgPSBz
aW1wbGVfcmVhZF9mcm9tX2J1ZmZlcih1YnVmLCBjb3VudCwgb2ZmcCwgb2J1Ziwgb2JvZmYpOw0K
KwlrZnJlZShvYnVmKTsNCisNCisJcmV0dXJuIHJldDsNCit9DQorDQorc3RhdGljIGNvbnN0IHN0
cnVjdCBmaWxlX29wZXJhdGlvbnMgY2NwX2RlYnVnZnNfY2hhcl9vcHMgPSB7DQorCS5vd25lciA9
IFRISVNfTU9EVUxFLA0KKwkub3BlbiA9IHNpbXBsZV9vcGVuLA0KKwkucmVhZCA9IGNjcF9kZWJ1
Z2ZzX2J1c2VzX3JlYWQsDQorCS53cml0ZSA9IE5VTEwsDQorfTsNCisNCit2b2lkIGNjcF9kZWJ1
Z2ZzX3JlZ2lzdGVyX2J1c2VzKHN0cnVjdCBkZW50cnkgKnBhcmVudGRpcikNCit7DQorICAgICAg
ICBkZWJ1Z2ZzX2NyZWF0ZV9maWxlKCJidXNlcyIsIFNfSVJVU1IsIHBhcmVudGRpciwgYnVzZXMs
ICZjY3BfZGVidWdmc19jaGFyX29wcyk7DQorfQ0KKw0KICNlbmRpZg0KIA0KIHVuc2lnbmVkIGlu
dCBjY3BfZ2V0X25xdWV1ZXNfcGFyYW0odm9pZCkgew0KQEAgLTQ1Nyw2ICs0OTksNyBAQCBzdGF0
aWMgc3RydWN0IHBjaV9kcml2ZXIgc3BfcGNpX2RyaXZlciA9IHsNCiBpbnQgc3BfcGNpX2luaXQo
dm9pZCkNCiB7DQogICAgICAgICBtdXRleF9pbml0KCZkZXZjb3VudF9tdXRleCk7DQorCWNjcF9w
YXJzZV9wY2lfYnVzZXMoKTsNCiAJcmV0dXJuIHBjaV9yZWdpc3Rlcl9kcml2ZXIoJnNwX3BjaV9k
cml2ZXIpOw0KIH0NCiANCg0K
