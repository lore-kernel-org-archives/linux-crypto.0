Return-Path: <SRS0=mwGE=VG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C31DC73C46
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 15:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5707C20844
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 15:07:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="YZmO2lUl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfGIPHZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:07:25 -0400
Received: from mail-eopbgr700060.outbound.protection.outlook.com ([40.107.70.60]:17505
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbfGIPHZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 11:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzTdP/Fid+/ZqmYSKKdNc1RjTD/ctKk/UrpltO+g2Cg=;
 b=YZmO2lUli8/Ie+wRlieAmvgtzWgIMZzr8XF7KSDf1ogjQmhtBXGm4lAimf0gAiWUQddjajIwB2a/X/FW8XTxzSPc9NFIQlcRqF9CEckxFwhmjNL85n8dcfPHol8wBoXo4saMc4EN02DocdzRqFXT5ImE+MendhaLeQgKn3q/vcw=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1420.namprd12.prod.outlook.com (10.168.239.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Tue, 9 Jul 2019 15:07:15 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.019; Tue, 9 Jul 2019
 15:07:15 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH v2 1/4] crypto: ccp - Make CCP debugfs support optional
Thread-Topic: [PATCH v2 1/4] crypto: ccp - Make CCP debugfs support optional
Thread-Index: AQHVNmf+mK8mF4MUK0+hgVrOVkCqAw==
Date:   Tue, 9 Jul 2019 15:07:15 +0000
Message-ID: <156268483388.18577.6667223543519094804.stgit@sosrh3.amd.com>
References: <156268468861.18577.13211913750250195885.stgit@sosrh3.amd.com>
In-Reply-To: <156268468861.18577.13211913750250195885.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN2PR01CA0007.prod.exchangelabs.com (2603:10b6:804:2::17)
 To DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c3bd158-51d5-4af0-b940-08d7047f20c2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1420;
x-ms-traffictypediagnostic: DM5PR12MB1420:
x-microsoft-antispam-prvs: <DM5PR12MB14205E5B0D29D3C89B5800ACFDF10@DM5PR12MB1420.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(199004)(189003)(71200400001)(66066001)(76176011)(8936002)(102836004)(81156014)(26005)(8676002)(7736002)(71190400001)(256004)(81166006)(6512007)(186003)(72206003)(99286004)(305945005)(86362001)(386003)(52116002)(53936002)(6506007)(2351001)(6436002)(66476007)(66556008)(64756008)(66446008)(446003)(316002)(11346002)(6916009)(25786009)(68736007)(478600001)(6486002)(6116002)(3846002)(5660300002)(4326008)(66946007)(5640700003)(2906002)(2501003)(103116003)(476003)(486006)(14454004)(73956011)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1420;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MpXZXwIoHmCrIDEO4Lz32LAachoP3oBnECW/yt0tWIFFUWQakhY4fwvpzS31Ru34V83TNfP5GbUEt4UK0UYPzMNeU93Hfld8yrK21wihsk1BnPfsdG23jQguQvjgI+KIoq4LWHcCHWKl6gk1rOp4BNRdPv2G7GE04nevOxqlOgU20BIgZgffGpaL0r9KOuu2IzjcGgXTzoqgKdcqxLHv1XjXT0Y13ZF3tU045sqBLCi5ZZq3S3e9RKyasvdOhJu8OxlBNQ3aDg5OoQbC0PJSTVaY2aO8FScF4oGocgVlVQpE9t3Jj3KR3mUe1endtLDmfPREclqQK63B/EesNWqYkBQG6wHH1Rs6jBdbje2APBA0wK2RoVg+RGC6zYe1vUfOZ4SKB3/dT90C/atSiMgCfuBGsKbnXe3lj5KLeiDqgD8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CE4BF3FDF44B24C8659D5F67F609F80@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3bd158-51d5-4af0-b940-08d7047f20c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 15:07:15.5576
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

QWRkIGEgY29uZmlnIG9wdGlvbiB0byBleGNsdWRlIERlYnVnRlMgc3VwcG9ydCBpbiB0aGUgQ0NQ
IGRyaXZlci4NCg0KU2lnbmVkLW9mZi1ieTogR2FyeSBSIEhvb2sgPGdhcnkuaG9va0BhbWQuY29t
Pg0KLS0tDQogZHJpdmVycy9jcnlwdG8vY2NwL0tjb25maWcgICAgICB8ICAgIDggKysrKysrKysN
CiBkcml2ZXJzL2NyeXB0by9jY3AvTWFrZWZpbGUgICAgIHwgICAgNCArKy0tDQogZHJpdmVycy9j
cnlwdG8vY2NwL2NjcC1kZXYtdjUuYyB8ICAgIDQgKysrKw0KIDMgZmlsZXMgY2hhbmdlZCwgMTQg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5
cHRvL2NjcC9LY29uZmlnIGIvZHJpdmVycy9jcnlwdG8vY2NwL0tjb25maWcNCmluZGV4IGI5ZGZh
ZTQ3YWVmZC4uNTFlNDZiNTdhZDhlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL0tj
b25maWcNCisrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9LY29uZmlnDQpAQCAtNDQsMyArNDQsMTEg
QEAgY29uZmlnIENSWVBUT19ERVZfU1BfUFNQDQogCSBtYW5hZ2VtZW50IGNvbW1hbmRzIGluIFNl
Y3VyZSBFbmNyeXB0ZWQgVmlydHVhbGl6YXRpb24gKFNFVikgbW9kZSwNCiAJIGFsb25nIHdpdGgg
c29mdHdhcmUtYmFzZWQgVHJ1c3RlZCBFeGVjdXRpb24gRW52aXJvbm1lbnQgKFRFRSkgdG8NCiAJ
IGVuYWJsZSB0aGlyZC1wYXJ0eSB0cnVzdGVkIGFwcGxpY2F0aW9ucy4NCisNCitjb25maWcgQ1JZ
UFRPX0RFVl9DQ1BfREVCVUdGUw0KKwlib29sICJFbmFibGUgQ0NQIEludGVybmFscyBpbiBEZWJ1
Z0ZTIg0KKwlkZWZhdWx0IG4NCisJZGVwZW5kcyBvbiBDUllQVE9fREVWX1NQX0NDUA0KKwloZWxw
DQorCSAgRXhwb3NlIENDUCBkZXZpY2UgaW5mb3JtYXRpb24gc3VjaCBhcyBvcGVyYXRpb24gc3Rh
dGlzdGljcywgZmVhdHVyZQ0KKwkgIGluZm9ybWF0aW9uLCBhbmQgZGVzY3JpcHRvciBxdWV1ZSBj
b250ZW50cy4NCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvTWFrZWZpbGUgYi9kcml2
ZXJzL2NyeXB0by9jY3AvTWFrZWZpbGUNCmluZGV4IDUxZDFjMGNmNjZjNy4uNmI4NmYxZTZkNjM0
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL01ha2VmaWxlDQorKysgYi9kcml2ZXJz
L2NyeXB0by9jY3AvTWFrZWZpbGUNCkBAIC01LDggKzUsOCBAQCBjY3AtJChDT05GSUdfQ1JZUFRP
X0RFVl9TUF9DQ1ApICs9IGNjcC1kZXYubyBcDQogCSAgICBjY3Atb3BzLm8gXA0KIAkgICAgY2Nw
LWRldi12My5vIFwNCiAJICAgIGNjcC1kZXYtdjUubyBcDQotCSAgICBjY3AtZG1hZW5naW5lLm8g
XA0KLQkgICAgY2NwLWRlYnVnZnMubw0KKwkgICAgY2NwLWRtYWVuZ2luZS5vDQorY2NwLSQoQ09O
RklHX0NSWVBUT19ERVZfQ0NQX0RFQlVHRlMpICs9IGNjcC1kZWJ1Z2ZzLm8NCiBjY3AtJChDT05G
SUdfUENJKSArPSBzcC1wY2kubw0KIGNjcC0kKENPTkZJR19DUllQVE9fREVWX1NQX1BTUCkgKz0g
cHNwLWRldi5vDQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUu
YyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LXY1LmMNCmluZGV4IGM3NmE5ZmExMTViOC4u
MzQwZDA5ODRmOGQ3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUu
Yw0KKysrIGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYw0KQEAgLTk3MCw4ICs5NzAs
MTAgQEAgc3RhdGljIGludCBjY3A1X2luaXQoc3RydWN0IGNjcF9kZXZpY2UgKmNjcCkNCiAJaWYg
KHJldCkNCiAJCWdvdG8gZV9od3JuZzsNCiANCisjaWZkZWYgQ09ORklHX0NSWVBUT19ERVZfQ0NQ
X0RFQlVHRlMNCiAJLyogU2V0IHVwIGRlYnVnZnMgZW50cmllcyAqLw0KIAljY3A1X2RlYnVnZnNf
c2V0dXAoY2NwKTsNCisjZW5kaWYNCiANCiAJcmV0dXJuIDA7DQogDQpAQCAtMTAwOSwxMSArMTAx
MSwxMyBAQCBzdGF0aWMgdm9pZCBjY3A1X2Rlc3Ryb3koc3RydWN0IGNjcF9kZXZpY2UgKmNjcCkN
CiAJLyogUmVtb3ZlIHRoaXMgZGV2aWNlIGZyb20gdGhlIGxpc3Qgb2YgYXZhaWxhYmxlIHVuaXRz
IGZpcnN0ICovDQogCWNjcF9kZWxfZGV2aWNlKGNjcCk7DQogDQorI2lmZGVmIENPTkZJR19DUllQ
VE9fREVWX0NDUF9ERUJVR0ZTDQogCS8qIFdlJ3JlIGluIHRoZSBwcm9jZXNzIG9mIHRlYXJpbmcg
ZG93biB0aGUgZW50aXJlIGRyaXZlcjsNCiAJICogd2hlbiBhbGwgdGhlIGRldmljZXMgYXJlIGdv
bmUgY2xlYW4gdXAgZGVidWdmcw0KIAkgKi8NCiAJaWYgKGNjcF9wcmVzZW50KCkpDQogCQljY3A1
X2RlYnVnZnNfZGVzdHJveSgpOw0KKyNlbmRpZg0KIA0KIAkvKiBEaXNhYmxlIGFuZCBjbGVhciBp
bnRlcnJ1cHRzICovDQogCWNjcDVfZGlzYWJsZV9xdWV1ZV9pbnRlcnJ1cHRzKGNjcCk7DQoNCg==
