Return-Path: <SRS0=mwGE=VG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E564FC73C46
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 15:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEBBB21670
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jul 2019 15:07:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="YQNPL/B2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfGIPHj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:07:39 -0400
Received: from mail-eopbgr730073.outbound.protection.outlook.com ([40.107.73.73]:20116
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbfGIPHi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 11:07:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lDcnsp4t0MJ6g0HNVDWXTwnOyM6HwDD0EW7UZvAuiE=;
 b=YQNPL/B2bed3B6+QkX31EZotfFAssArK8OvmXDkIMKZaos1eYwm8eoRQPa+2gJwHKqUowBeH4/3dqzEq5ow9ZLuuqq7IyXSxiIMtHQQ1TV8rDti71Tl+EkKPyHoFMymYCYxbBkZaILUxgPWTGN5Rmu0FzyhYIJ3ft1tgpvKtJXE=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1212.namprd12.prod.outlook.com (10.168.237.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.16; Tue, 9 Jul 2019 15:07:35 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.019; Tue, 9 Jul 2019
 15:07:35 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH v2 4/4] crypto: ccp - Add a module parameter to control
 registration for DMA
Thread-Topic: [PATCH v2 4/4] crypto: ccp - Add a module parameter to control
 registration for DMA
Thread-Index: AQHVNmgKey7b946Jlkm92y8/UEus7w==
Date:   Tue, 9 Jul 2019 15:07:35 +0000
Message-ID: <156268485440.18577.14074359387776078938.stgit@sosrh3.amd.com>
References: <156268468861.18577.13211913750250195885.stgit@sosrh3.amd.com>
In-Reply-To: <156268468861.18577.13211913750250195885.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:4:39::49) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 052e541f-970b-48ba-aa60-08d7047f2ccb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1212;
x-ms-traffictypediagnostic: DM5PR12MB1212:
x-microsoft-antispam-prvs: <DM5PR12MB1212C5B96A684366B3FE4D4DFDF10@DM5PR12MB1212.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(199004)(189003)(3846002)(6116002)(6436002)(6512007)(5660300002)(103116003)(72206003)(99286004)(446003)(11346002)(81166006)(76176011)(81156014)(8676002)(66946007)(73956011)(66446008)(64756008)(66556008)(66476007)(68736007)(86362001)(5640700003)(25786009)(6486002)(14444005)(256004)(53936002)(102836004)(2906002)(2351001)(14454004)(7736002)(305945005)(26005)(54906003)(2501003)(71190400001)(71200400001)(316002)(186003)(66066001)(4326008)(478600001)(8936002)(486006)(52116002)(476003)(6506007)(386003)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1212;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 53oPflBfkW5TKFY4LrVBx4z3Yi7FEb8uh35mBeiLcYVg2dtagCDnAZLuXGPKEgDMCamzIjAbwhsgU7/e46YpsS/GvixVNf6/4yvBdaqMxYFi5aPV3CxI76yNn6iUfOlrinyjR9yDcLk47XcZ0uQWUz1fUQITmMt5Gl18DozlxVBa4N0NZ/MjHqlNJrWnkXPfrrd7tQ9JUnP9NSkos4su0IyfPkorObz0jvXkj03YmS2QH6BruKQ3s9cPnZ91/QKcXGYauFxHvqdrUWoSpj6SufnKqyUC/IvXJe6ILHYSig0lBd04FfC06Ksgk+YSRZV+g9xEnOjQB5etZP9h2UTjEzxP6tNS5T9KnK4tGbJS4qF5VeC7lwJesnEhu8wYQ6dQ5vUCkEjedt0nGdD0r68mL9XlH9bzK607msH/QG2fey8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D15F94647E5CBB4C8C22A30E4B8E49FC@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 052e541f-970b-48ba-aa60-08d7047f2ccb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 15:07:35.7128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1212
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VGhlIENDUCBkcml2ZXIgaXMgYWJsZSB0byBhY3QgYXMgYSBETUEgZW5naW5lLiBBZGQgYSBtb2R1
bGUgcGFyYW1ldGVyIHRoYXQNCmFsbG93cyB0aGlzIGZlYXR1cmUgdG8gYmUgZW5hYmxlZC9kaXNh
YmxlZC4NCg0KU2lnbmVkLW9mZi1ieTogR2FyeSBSIEhvb2sgPGdhcnkuaG9va0BhbWQuY29tPg0K
LS0tDQogZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kbWFlbmdpbmUuYyB8ICAgMTIgKysrKysrKysr
KystDQogMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZG1hZW5naW5lLmMgYi9kcml2ZXJz
L2NyeXB0by9jY3AvY2NwLWRtYWVuZ2luZS5jDQppbmRleCA5YWVlNjE5ZGI2ZTQuLjNmOTBjZTM1
YmVlNSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZG1hZW5naW5lLmMNCisr
KyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3AtZG1hZW5naW5lLmMNCkBAIC0yLDcgKzIsNyBAQA0K
IC8qDQogICogQU1EIENyeXB0b2dyYXBoaWMgQ29wcm9jZXNzb3IgKENDUCkgZHJpdmVyDQogICoN
Ci0gKiBDb3B5cmlnaHQgKEMpIDIwMTYsMjAxNyBBZHZhbmNlZCBNaWNybyBEZXZpY2VzLCBJbmMu
DQorICogQ29weXJpZ2h0IChDKSAyMDE2LDIwMTkgQWR2YW5jZWQgTWljcm8gRGV2aWNlcywgSW5j
Lg0KICAqDQogICogQXV0aG9yOiBHYXJ5IFIgSG9vayA8Z2FyeS5ob29rQGFtZC5jb20+DQogICov
DQpAQCAtMzUsNiArMzUsMTAgQEAgc3RhdGljIHVuc2lnbmVkIGludCBkbWFfY2hhbl9hdHRyID0g
Q0NQX0RNQV9ERkxUOw0KIG1vZHVsZV9wYXJhbShkbWFfY2hhbl9hdHRyLCB1aW50LCAwNDQ0KTsN
CiBNT0RVTEVfUEFSTV9ERVNDKGRtYV9jaGFuX2F0dHIsICJTZXQgRE1BIGNoYW5uZWwgdmlzaWJp
bGl0eTogMCAoZGVmYXVsdCkgPSBkZXZpY2UgZGVmYXVsdHMsIDEgPSBtYWtlIHByaXZhdGUsIDIg
PSBtYWtlIHB1YmxpYyIpOw0KIA0KK3N0YXRpYyB1bnNpZ25lZCBpbnQgZG1hZW5naW5lID0gMTsN
Cittb2R1bGVfcGFyYW0oZG1hZW5naW5lLCB1aW50LCAwNDQ0KTsNCitNT0RVTEVfUEFSTV9ERVND
KGRtYWVuZ2luZSwgIlJlZ2lzdGVyIHNlcnZpY2VzIHdpdGggdGhlIERNQSBzdWJzeXN0ZW0gKGFu
eSBub24temVybyB2YWx1ZSwgZGVmYXVsdDogMSkiKTsNCisNCiBzdGF0aWMgdW5zaWduZWQgaW50
IGNjcF9nZXRfZG1hX2NoYW5fYXR0cihzdHJ1Y3QgY2NwX2RldmljZSAqY2NwKQ0KIHsNCiAJc3dp
dGNoIChkbWFfY2hhbl9hdHRyKSB7DQpAQCAtNjM3LDYgKzY0MSw5IEBAIGludCBjY3BfZG1hZW5n
aW5lX3JlZ2lzdGVyKHN0cnVjdCBjY3BfZGV2aWNlICpjY3ApDQogCXVuc2lnbmVkIGludCBpOw0K
IAlpbnQgcmV0Ow0KIA0KKwlpZiAoIWRtYWVuZ2luZSkNCisJCXJldHVybiAwOw0KKw0KIAljY3At
PmNjcF9kbWFfY2hhbiA9IGRldm1fa2NhbGxvYyhjY3AtPmRldiwgY2NwLT5jbWRfcV9jb3VudCwN
CiAJCQkJCSBzaXplb2YoKihjY3AtPmNjcF9kbWFfY2hhbikpLA0KIAkJCQkJIEdGUF9LRVJORUwp
Ow0KQEAgLTc0MCw2ICs3NDcsOSBAQCB2b2lkIGNjcF9kbWFlbmdpbmVfdW5yZWdpc3RlcihzdHJ1
Y3QgY2NwX2RldmljZSAqY2NwKQ0KIHsNCiAJc3RydWN0IGRtYV9kZXZpY2UgKmRtYV9kZXYgPSAm
Y2NwLT5kbWFfZGV2Ow0KIA0KKwlpZiAoIWRtYWVuZ2luZSkNCisJCXJldHVybjsNCisNCiAJZG1h
X2FzeW5jX2RldmljZV91bnJlZ2lzdGVyKGRtYV9kZXYpOw0KIA0KIAlrbWVtX2NhY2hlX2Rlc3Ry
b3koY2NwLT5kbWFfZGVzY19jYWNoZSk7DQoNCg==
