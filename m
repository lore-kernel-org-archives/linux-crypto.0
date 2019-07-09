Return-Path: <SRS0=mwGE=VG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE886C73C50
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 15:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8867F2166E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 15:07:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="a7ttBXYG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfGIPHi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:07:38 -0400
Received: from mail-eopbgr700050.outbound.protection.outlook.com ([40.107.70.50]:55939
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726449AbfGIPHi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 11:07:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=flcR9k/CKYe4IqlifvKtt8FJX2sdaZaP1IYlJHm3Y3M=;
 b=a7ttBXYGWot5GjmbJgVbUSb4qIcIRDYZ+cBiZoAEqTop7jXOFfc1g+R/vR7BWRZQF5CBvVlSnpNNH890mjh3qVfzo0tXmoXbh65c7TWbPD5Kkh2L86IJ/Gt8Dg6+SVo66OK3Q86JPyfhriIXe2COIRgd7iw+4KZAhe3cT3MHNVI=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1420.namprd12.prod.outlook.com (10.168.239.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Tue, 9 Jul 2019 15:07:29 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.019; Tue, 9 Jul 2019
 15:07:29 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH v2 3/4] crypto: ccp - module parameter to limit the number of
 enabled CCPs
Thread-Topic: [PATCH v2 3/4] crypto: ccp - module parameter to limit the
 number of enabled CCPs
Thread-Index: AQHVNmgGqyaYmNVJjkGy1XaVvAqPAA==
Date:   Tue, 9 Jul 2019 15:07:29 +0000
Message-ID: <156268484768.18577.10380026447674114699.stgit@sosrh3.amd.com>
References: <156268468861.18577.13211913750250195885.stgit@sosrh3.amd.com>
In-Reply-To: <156268468861.18577.13211913750250195885.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:4:39::15) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 751a7792-5cef-4840-ceb2-08d7047f28da
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1420;
x-ms-traffictypediagnostic: DM5PR12MB1420:
x-microsoft-antispam-prvs: <DM5PR12MB14203214EFAA2FB9D7E53B22FDF10@DM5PR12MB1420.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(199004)(189003)(71200400001)(66066001)(76176011)(8936002)(102836004)(81156014)(26005)(8676002)(7736002)(71190400001)(256004)(81166006)(6512007)(186003)(72206003)(99286004)(305945005)(86362001)(386003)(52116002)(53936002)(6506007)(2351001)(6436002)(66476007)(66556008)(64756008)(66446008)(446003)(316002)(11346002)(6916009)(25786009)(68736007)(478600001)(6486002)(6116002)(3846002)(5660300002)(4326008)(66946007)(5640700003)(2906002)(2501003)(103116003)(476003)(486006)(14444005)(14454004)(73956011)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1420;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: B9LCQebk1XBoLcmzLLt7fhYAJxaMyTwI8H0mPG/onHVd2U5bUScfo9uFcShg9O4X462EDAUKEYr1E2/WN8ep5UqWdu2I0T2pLVfXtgcumI1SwkqPGKeFYdi22VH2k3CQZOCmJzKp+fcIqYjyT2YpxMnSKU3dDWwF1JPDfcjAwr+srCzL/PMVQnPkbLdQRaBdTpK4Kp60EjHI/vC3DjE5PyvgTAGNhnzA5ZCbzpf5BHSWHEfgyhB76NGnGKUvsuxTiCgvE/v51A6xdY2OyxD4Ws5ftVzRE4R0I4NoSs5P70jiBsFldT+scb9pUAQnNz4EeuwrGkgyl3D5N/OgCiq9xs88jiEOiauxMmF9grKvDOYUi0DKQkPrhz/jvBzNwNTeG+oZiWGKKJKa2RZAOwydHirzC3mH8oD2aguZKEeuqbI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2834582148F62847BF8F133899509CCD@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 751a7792-5cef-4840-ceb2-08d7047f28da
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 15:07:29.1262
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

UHJvdmlkZSB0aGUgYWJpbGl0eSB0byBjb25zdHJhaW4gdGhlIHRvdGFsIG51bWJlciBvZiBlbmFi
bGVkIGRldmljZXMgaW4NCnRoZSBzeXN0ZW0uIE9uY2UgbWF4X2RldnMgZGV2aWNlcyBoYXZlIGJl
ZW4gY29uZmlndXJlZCwgc3Vic2VxdWVudGx5DQpwcm9iZWQgZGV2aWNlcyBhcmUgaWdub3JlZC4N
Cg0KVGhlIG1heF9kZXZzIHBhcmFtZXRlciBtYXkgYmUgemVybywgaW4gd2hpY2ggY2FzZSBhbGwg
Q0NQcyBhcmUgZGlzYWJsZWQuDQpQU1BzIGFyZSBhbHdheXMgZW5hYmxlZCBhbmQgYWN0aXZlLg0K
DQpEaXNhYmxpbmcgdGhlIENDUHMgYWxzbyBkaXNhYmxlcyBETUEgYW5kIFJORyByZWdpc3RyYXRp
b24uDQoNClNpZ25lZC1vZmYtYnk6IEdhcnkgUiBIb29rIDxnYXJ5Lmhvb2tAYW1kLmNvbT4NCi0t
LQ0KIGRyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZGV2LmMgfCAgIDE4ICsrKysrKysrKysrKysrKysr
LQ0KIDEgZmlsZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5jIGIvZHJpdmVycy9jcnlwdG8v
Y2NwL2NjcC1kZXYuYw0KaW5kZXggMjNjZWY4N2MwOTUwLi5jYmE5NjE2OWVlMzYgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5jDQorKysgYi9kcml2ZXJzL2NyeXB0by9j
Y3AvY2NwLWRldi5jDQpAQCAtMiw3ICsyLDcgQEANCiAvKg0KICAqIEFNRCBDcnlwdG9ncmFwaGlj
IENvcHJvY2Vzc29yIChDQ1ApIGRyaXZlcg0KICAqDQotICogQ29weXJpZ2h0IChDKSAyMDEzLDIw
MTcgQWR2YW5jZWQgTWljcm8gRGV2aWNlcywgSW5jLg0KKyAqIENvcHlyaWdodCAoQykgMjAxMywy
MDE5IEFkdmFuY2VkIE1pY3JvIERldmljZXMsIEluYy4NCiAgKg0KICAqIEF1dGhvcjogVG9tIExl
bmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1kLmNvbT4NCiAgKiBBdXRob3I6IEdhcnkgUiBIb29r
IDxnYXJ5Lmhvb2tAYW1kLmNvbT4NCkBAIC0yMCw2ICsyMCw3IEBADQogI2luY2x1ZGUgPGxpbnV4
L2RlbGF5Lmg+DQogI2luY2x1ZGUgPGxpbnV4L2h3X3JhbmRvbS5oPg0KICNpbmNsdWRlIDxsaW51
eC9jcHUuaD4NCisjaW5jbHVkZSA8bGludXgvYXRvbWljLmg+DQogI2lmZGVmIENPTkZJR19YODYN
CiAjaW5jbHVkZSA8YXNtL2NwdV9kZXZpY2VfaWQuaD4NCiAjZW5kaWYNCkBAIC0yNywxMSArMjgs
MTkgQEANCiANCiAjaW5jbHVkZSAiY2NwLWRldi5oIg0KIA0KKyNkZWZpbmUgTUFYX0NDUFMgMzIN
CisNCiAvKiBMaW1pdCBDQ1AgdXNlIHRvIGEgc3BlY2lmZWQgbnVtYmVyIG9mIHF1ZXVlcyBwZXIg
ZGV2aWNlICovDQogc3RhdGljIHVuc2lnbmVkIGludCBucXVldWVzID0gMDsNCiBtb2R1bGVfcGFy
YW0obnF1ZXVlcywgdWludCwgMDQ0NCk7DQogTU9EVUxFX1BBUk1fREVTQyhucXVldWVzLCAiTnVt
YmVyIG9mIHF1ZXVlcyBwZXIgQ0NQIChtaW5pbXVtIDE7IGRlZmF1bHQ6IGFsbCBhdmFpbGFibGUp
Iik7DQogDQorLyogTGltaXQgdGhlIG1heGltdW0gbnVtYmVyIG9mIGNvbmZpZ3VyZWQgQ0NQcyAq
Lw0KK3N0YXRpYyBhdG9taWNfdCBkZXZfY291bnQgPSBBVE9NSUNfSU5JVCgwKTsNCitzdGF0aWMg
dW5zaWduZWQgaW50IG1heF9kZXZzID0gTUFYX0NDUFM7DQorbW9kdWxlX3BhcmFtKG1heF9kZXZz
LCB1aW50LCAwNDQ0KTsNCitNT0RVTEVfUEFSTV9ERVNDKG1heF9kZXZzLCAiTWF4aW11bSBudW1i
ZXIgb2YgQ0NQcyB0byBlbmFibGUgKGRlZmF1bHQ6IGFsbDsgMCBkaXNhYmxlcyBhbGwgQ0NQcyki
KTsNCisNCiBzdHJ1Y3QgY2NwX3Rhc2tsZXRfZGF0YSB7DQogCXN0cnVjdCBjb21wbGV0aW9uIGNv
bXBsZXRpb247DQogCXN0cnVjdCBjY3BfY21kICpjbWQ7DQpAQCAtNTkyLDYgKzYwMSwxMyBAQCBp
bnQgY2NwX2Rldl9pbml0KHN0cnVjdCBzcF9kZXZpY2UgKnNwKQ0KIAlzdHJ1Y3QgY2NwX2Rldmlj
ZSAqY2NwOw0KIAlpbnQgcmV0Ow0KIA0KKwkvKg0KKwkgKiBDaGVjayBob3cgbWFueSB3ZSBoYXZl
IHNvIGZhciwgYW5kIHN0b3AgYWZ0ZXIgcmVhY2hpbmcNCisJICogdGhhdCBudW1iZXINCisJICov
DQorCWlmIChhdG9taWNfaW5jX3JldHVybigmZGV2X2NvdW50KSA+IG1heF9kZXZzKQ0KKwkJcmV0
dXJuIDA7IC8qIGRvbid0IGZhaWwgdGhlIGxvYWQgKi8NCisNCiAJcmV0ID0gLUVOT01FTTsNCiAJ
Y2NwID0gY2NwX2FsbG9jX3N0cnVjdChzcCk7DQogCWlmICghY2NwKQ0KDQo=
