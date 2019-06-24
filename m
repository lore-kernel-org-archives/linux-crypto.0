Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 441D7C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C61120657
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:28:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="ScRMtxHS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbfFXT2k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:28:40 -0400
Received: from mail-eopbgr760080.outbound.protection.outlook.com ([40.107.76.80]:15593
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfFXT2k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:28:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTvVxcC/HX/+KWMoA83lphgOxFcU6a/vTCmbOr2fpn4=;
 b=ScRMtxHSKSAEpSSbFZqyZfbtWY94o0LeeXV17JsveYHl+9VC2PJCs6wZjnAiEYY2eJDrZhjoCqpsusibIkZChgvz/qSTiV1oVCWxha91Q+JsWIw+G/fOqhdCYfjqwKKKOk93oxDrkD/K21IBvKkGIFZ6LeBxgcIT0J1ty8tgTsA=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1786.namprd12.prod.outlook.com (10.175.91.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 19:28:37 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 19:28:37 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 01/11] crypto: ccp - Make CCP debugfs support optional
Thread-Topic: [PATCH 01/11] crypto: ccp - Make CCP debugfs support optional
Thread-Index: AQHVKsMF6pSyl4ZSUEasMQctnMWnyA==
Date:   Mon, 24 Jun 2019 19:28:37 +0000
Message-ID: <156140451586.116890.10264836198229403397.stgit@sosrh3.amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
In-Reply-To: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0059.namprd12.prod.outlook.com
 (2603:10b6:802:20::30) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 476c49fb-9f1f-4a21-e847-08d6f8da27b1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1786;
x-ms-traffictypediagnostic: DM5PR12MB1786:
x-microsoft-antispam-prvs: <DM5PR12MB17864D8C2CDDB4B6A2182771FDE00@DM5PR12MB1786.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39860400002)(346002)(136003)(376002)(189003)(199004)(2906002)(103116003)(7736002)(26005)(6506007)(6916009)(53936002)(86362001)(6512007)(316002)(256004)(76176011)(73956011)(2351001)(5660300002)(64756008)(66476007)(66556008)(66066001)(6436002)(66446008)(102836004)(4326008)(66946007)(25786009)(6486002)(186003)(305945005)(5640700003)(52116002)(386003)(8936002)(68736007)(478600001)(2501003)(3846002)(71190400001)(446003)(6116002)(476003)(81166006)(54906003)(72206003)(81156014)(71200400001)(11346002)(8676002)(99286004)(486006)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1786;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +RlO3XbblMPh7wKSFE28Iw5gy5VWUKEhxDzOe4tkFOSqmGw9ECMLpwMDMCypkWIX4CtNJTWAgh0319jE7gCDiPPcHTGiz8mfoIzptIGxboMXfBwT6rQgt2QK9qYRnj06V0eOeXwVJOThdA6u9YXAITOvMyb5z88YcB2J+qXK2mmqc3Dw9f7+j688jmOikGS/ULJtNp6LNZ74AvsrogxCQ6YbtNYnG44b8LAMfXetAqX3OJ+y5vhIoorN58P6q4/vwRskhuzJuz/rLFbfBy1ylLqvkeImcZUnpxD73wMcGoWjSyXw9rCQ0T4hGB4WMo/5eonGfoh7EvSl3AHtE41CV4211d1JnYXUjQ2Y9ILmK+Gr876SWywqbEaSldGDaDRSa2nsvuQg5YWeKh3lCwJjdo6U3dBYoB9H9uSD9uypZNM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC2616933A1E904E9B49632909E68493@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 476c49fb-9f1f-4a21-e847-08d6f8da27b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:28:37.4896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1786
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

QWRkIGEgY29uZmlnIG9wdGlvbiB0byBleGNsdWRlIERlYnVnRlMgc3VwcG9ydCBpbiB0aGUgQ0NQ
IGRyaXZlci4NCg0KU2lnbmVkLW9mZi1ieTogR2FyeSBSIEhvb2sgPGdhcnkuaG9va0BhbWQuY29t
Pg0KLS0tDQogZHJpdmVycy9jcnlwdG8vY2NwL0tjb25maWcgICAgICB8ICAgIDkgKysrKysrKysr
DQogZHJpdmVycy9jcnlwdG8vY2NwL01ha2VmaWxlICAgICB8ICAgIDQgKystLQ0KIGRyaXZlcnMv
Y3J5cHRvL2NjcC9jY3AtZGV2LXY1LmMgfCAgICA0ICsrKysNCiAzIGZpbGVzIGNoYW5nZWQsIDE1
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Ny
eXB0by9jY3AvS2NvbmZpZyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9LY29uZmlnDQppbmRleCBiOWRm
YWU0N2FlZmQuLjZmY2VkZDdiMGQ0MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9L
Y29uZmlnDQorKysgYi9kcml2ZXJzL2NyeXB0by9jY3AvS2NvbmZpZw0KQEAgLTQ0LDMgKzQ0LDEy
IEBAIGNvbmZpZyBDUllQVE9fREVWX1NQX1BTUA0KIAkgbWFuYWdlbWVudCBjb21tYW5kcyBpbiBT
ZWN1cmUgRW5jcnlwdGVkIFZpcnR1YWxpemF0aW9uIChTRVYpIG1vZGUsDQogCSBhbG9uZyB3aXRo
IHNvZnR3YXJlLWJhc2VkIFRydXN0ZWQgRXhlY3V0aW9uIEVudmlyb25tZW50IChURUUpIHRvDQog
CSBlbmFibGUgdGhpcmQtcGFydHkgdHJ1c3RlZCBhcHBsaWNhdGlvbnMuDQorDQorY29uZmlnIENS
WVBUT19ERVZfQ0NQX0RFQlVHRlMNCisJYm9vbCAiRW5hYmxlIENDUCBJbnRlcm5hbHMgaW4gRGVi
dWdGUyINCisJZGVmYXVsdCBuDQorCWRlcGVuZHMgb24gQ1JZUFRPX0RFVl9TUF9DQ1ANCisJaGVs
cA0KKwkgIEV4cG9zZSBDQ1AgZGV2aWNlIGluZm9ybWF0aW9uIHN1Y2ggYXMgb3BlcmF0aW9uIHN0
YXRpc3RpY3MsIGZlYXR1cmUNCisJICBpbmZvcm1hdGlvbiwgZGVzY3JpcHRvciBxdWV1ZSBjb250
ZW50cywgYW5kIG1vZHVsZSBwYXJhbWV0ZXIgdmFsdWVzIHNldA0KKwkgIGF0IGxvYWQgdGltZS4N
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvTWFrZWZpbGUgYi9kcml2ZXJzL2NyeXB0
by9jY3AvTWFrZWZpbGUNCmluZGV4IDUxZDFjMGNmNjZjNy4uNmI4NmYxZTZkNjM0IDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL01ha2VmaWxlDQorKysgYi9kcml2ZXJzL2NyeXB0by9j
Y3AvTWFrZWZpbGUNCkBAIC01LDggKzUsOCBAQCBjY3AtJChDT05GSUdfQ1JZUFRPX0RFVl9TUF9D
Q1ApICs9IGNjcC1kZXYubyBcDQogCSAgICBjY3Atb3BzLm8gXA0KIAkgICAgY2NwLWRldi12My5v
IFwNCiAJICAgIGNjcC1kZXYtdjUubyBcDQotCSAgICBjY3AtZG1hZW5naW5lLm8gXA0KLQkgICAg
Y2NwLWRlYnVnZnMubw0KKwkgICAgY2NwLWRtYWVuZ2luZS5vDQorY2NwLSQoQ09ORklHX0NSWVBU
T19ERVZfQ0NQX0RFQlVHRlMpICs9IGNjcC1kZWJ1Z2ZzLm8NCiBjY3AtJChDT05GSUdfUENJKSAr
PSBzcC1wY2kubw0KIGNjcC0kKENPTkZJR19DUllQVE9fREVWX1NQX1BTUCkgKz0gcHNwLWRldi5v
DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYyBiL2RyaXZl
cnMvY3J5cHRvL2NjcC9jY3AtZGV2LXY1LmMNCmluZGV4IGM5YmZkNGY0MzljZS4uYTViZDExODMx
YjgwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYw0KKysrIGIv
ZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYw0KQEAgLTk3Myw4ICs5NzMsMTAgQEAgc3Rh
dGljIGludCBjY3A1X2luaXQoc3RydWN0IGNjcF9kZXZpY2UgKmNjcCkNCiAJaWYgKHJldCkNCiAJ
CWdvdG8gZV9od3JuZzsNCiANCisjaWZkZWYgQ09ORklHX0NSWVBUT19ERVZfQ0NQX0RFQlVHRlMN
CiAJLyogU2V0IHVwIGRlYnVnZnMgZW50cmllcyAqLw0KIAljY3A1X2RlYnVnZnNfc2V0dXAoY2Nw
KTsNCisjZW5kaWYNCiANCiAJcmV0dXJuIDA7DQogDQpAQCAtMTAxMiwxMSArMTAxNCwxMyBAQCBz
dGF0aWMgdm9pZCBjY3A1X2Rlc3Ryb3koc3RydWN0IGNjcF9kZXZpY2UgKmNjcCkNCiAJLyogUmVt
b3ZlIHRoaXMgZGV2aWNlIGZyb20gdGhlIGxpc3Qgb2YgYXZhaWxhYmxlIHVuaXRzIGZpcnN0ICov
DQogCWNjcF9kZWxfZGV2aWNlKGNjcCk7DQogDQorI2lmZGVmIENPTkZJR19DUllQVE9fREVWX0ND
UF9ERUJVR0ZTDQogCS8qIFdlJ3JlIGluIHRoZSBwcm9jZXNzIG9mIHRlYXJpbmcgZG93biB0aGUg
ZW50aXJlIGRyaXZlcjsNCiAJICogd2hlbiBhbGwgdGhlIGRldmljZXMgYXJlIGdvbmUgY2xlYW4g
dXAgZGVidWdmcw0KIAkgKi8NCiAJaWYgKGNjcF9wcmVzZW50KCkpDQogCQljY3A1X2RlYnVnZnNf
ZGVzdHJveSgpOw0KKyNlbmRpZg0KIA0KIAkvKiBEaXNhYmxlIGFuZCBjbGVhciBpbnRlcnJ1cHRz
ICovDQogCWNjcDVfZGlzYWJsZV9xdWV1ZV9pbnRlcnJ1cHRzKGNjcCk7DQoNCg==
