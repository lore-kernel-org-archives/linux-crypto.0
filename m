Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E9FC43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2356E20657
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:30:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="ZNBoOJEF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbfFXTaH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:30:07 -0400
Received: from mail-eopbgr810052.outbound.protection.outlook.com ([40.107.81.52]:22917
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfFXTaH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKcj2IKIIjU+ccVjJIlLbgOw5E3wmdTDZxFXXvZFs3I=;
 b=ZNBoOJEFBO0yEzPiEe3DMJkseSB+bzIYY49GbL2JrUYtM6gJjC0+Prbra2Pn6LP+d11Q3vDcrVxlr8Km0h3oZMef8+Laf+tD3vSuAgoBCBwj43HdB4Nea1d5W7tUoYUqrHzeqnGdiKQuiegMrGmRfHLSuheQad7rN+bjpXMBkR8=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2358.namprd12.prod.outlook.com (52.132.141.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 19:29:25 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 19:29:25 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 08/11] crypto: ccp - module parameter to allow CCP selection
 by PCI bus
Thread-Topic: [PATCH 08/11] crypto: ccp - module parameter to allow CCP
 selection by PCI bus
Thread-Index: AQHVKsMiRjUqad71kU20lJcmfIXikw==
Date:   Mon, 24 Jun 2019 19:29:25 +0000
Message-ID: <156140456385.116890.10589968291918678953.stgit@sosrh3.amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
In-Reply-To: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0701CA0044.namprd07.prod.outlook.com
 (2603:10b6:803:2d::17) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d40ed30-3531-4b5a-c496-08d6f8da4473
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2358;
x-ms-traffictypediagnostic: DM5PR12MB2358:
x-microsoft-antispam-prvs: <DM5PR12MB235894935564942BE9AAE142FDE00@DM5PR12MB2358.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:586;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(39860400002)(366004)(199004)(189003)(7736002)(5660300002)(26005)(2906002)(68736007)(8936002)(305945005)(186003)(386003)(66476007)(76176011)(8676002)(6506007)(64756008)(102836004)(81156014)(53936002)(52116002)(4326008)(66556008)(6486002)(66446008)(66946007)(73956011)(316002)(5640700003)(6916009)(25786009)(6436002)(81166006)(2501003)(6512007)(3846002)(2351001)(71200400001)(71190400001)(99286004)(103116003)(54906003)(14444005)(6116002)(256004)(476003)(72206003)(66066001)(14454004)(446003)(478600001)(486006)(11346002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2358;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oY+Tu32dpk9fGvIm0HL1UQCVoqsN9x/KapgPDs+4qrjMmMDJwntNguDQk3nLeA2B3bXC3GjZkd9haSnQt8swmBWYCh/1QtiNW+tMXZErxmrqarAn+NoaQ3r+CuAvlIFb1n5L2UOQz3fxAEZv1G2CHPRnisB+c9n0y3G5CSMzOL2WEwRrR412nE/aGoaFicX3i+egFPrlJUN2ONZixDJlTD5ihKpOex+MnJgazBIYmeMmyFM/fFXPS+AytlVlxsjg7CBcPHWEz5sJZ3tkdci7eFofm4RPenuYvSxIQ2B471bIg7Tr42d25n32QkBY7zq8THrD2YviHhWEwyquw2bsnGrzgnEibeRzDFm1Ig8328zWwQuy6vCe07+0811r5BAlyQ+mb2eWystr/C4/VEouhFrkJwM4YmXXPTx5hRrU2YU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E0FB5E0F59D234885F4B92A0E762378@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d40ed30-3531-4b5a-c496-08d6f8da4473
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:29:25.7392
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

QWRkIGEgbW9kdWxlIHBhcmFtZXRlciB0aGF0IGFsbG93cyBzcGVjaWZpY2F0aW9uIG9mIG9uZSBv
ciBtb3JlIENDUHMNCmJhc2VkIG9uIFBDSSBidXMgaWRlbnRpZmllcnMuIFRoZSB2YWx1ZSBvZiB0
aGUgcGFyYW1ldGVyIGlzIGEgY29tbWEtDQpzZXBhcmF0ZWQgbGlzdCBvZiBidXMgbnVtYmVycywg
aW4gbm8gcGFydGljdWxhciBvcmRlci4NCg0KU2lnbmVkLW9mZi1ieTogR2FyeSBSIEhvb2sgPGdh
cnkuaG9va0BhbWQuY29tPg0KLS0tDQogZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jIHwgICA1
OCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQogMSBmaWxlIGNo
YW5nZWQsIDU4IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2Nj
cC9zcC1wY2kuYyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1wY2kuYw0KaW5kZXggYmNkMWUyMzNk
Y2U3Li5hNTYzZDg1YjI0MmUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNp
LmMNCisrKyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1wY2kuYw0KQEAgLTQwLDYgKzQwLDEzIEBA
IHN0YXRpYyB1bnNpZ25lZCBpbnQgcGNpZGV2Ow0KIG1vZHVsZV9wYXJhbShwY2lkZXYsIHVpbnQs
IDA0NDQpOw0KIE1PRFVMRV9QQVJNX0RFU0MocGNpZGV2LCAiRGV2aWNlIG51bWJlciBmb3IgYSBz
cGVjaWZpYyBDQ1AiKTsNCiANCisjZGVmaW5lIE1BWENDUFMgMzINCitzdGF0aWMgY2hhciAqYnVz
ZXM7DQorc3RhdGljIHVuc2lnbmVkIGludCBuX3BjaWJ1cyA9IDA7DQorc3RhdGljIHVuc2lnbmVk
IGludCBwY2lidXNbTUFYQ0NQU107DQorbW9kdWxlX3BhcmFtKGJ1c2VzLCBjaGFycCwgMDQ0NCk7
DQorTU9EVUxFX1BBUk1fREVTQyhidXNlcywgIlBDSSBCdXMgbnVtYmVyKHMpLCBjb21tYS1zZXBh
cmF0ZWQuIExpc3QgQ0NQcyB3aXRoICdsc3BjaSB8Z3JlcCBFbmMnIik7DQorDQogc3RhdGljIHN0
cnVjdCBtdXRleCBkZXZjb3VudF9tdXRleCBfX19fY2FjaGVsaW5lX2FsaWduZWQ7DQogc3RhdGlj
IHVuc2lnbmVkIGludCBkZXZjb3VudCA9IDA7DQogc3RhdGljIHVuc2lnbmVkIGludCBtYXhkZXYg
PSAwOw0KQEAgLTUwLDYgKzU3LDM3IEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgbnF1ZXVlcyA9IE1B
WF9IV19RVUVVRVM7DQogbW9kdWxlX3BhcmFtKG5xdWV1ZXMsIHVpbnQsIDA0NDQpOw0KIE1PRFVM
RV9QQVJNX0RFU0MobnF1ZXVlcywgIk51bWJlciBvZiBxdWV1ZXMgcGVyIENDUCAoZGVmYXVsdDog
NSkiKTsNCiANCisjZGVmaW5lIENPTU1BICAgJywnDQorc3RhdGljIHZvaWQgY2NwX3BhcnNlX3Bj
aV9idXNlcyh2b2lkKQ0KK3sNCisJdW5zaWduZWQgaW50IGJ1c25vOw0KKwl1bnNpZ25lZCBpbnQg
ZW9zID0gMDsNCisJaW50IHJldDsNCisJY2hhciAqY29tbWE7DQorCWNoYXIgKnRvazsNCisNCisJ
LyogTm90aGluZyBvbiB0aGUgY29tbWFuZCBsaW5lPyAqLw0KKwlpZiAoIWJ1c2VzKQ0KKwkJcmV0
dXJuOw0KKw0KKwljb21tYSA9IHRvayA9IGJ1c2VzOw0KKwl3aGlsZSAoIWVvcyAmJiAqdG9rICYm
IChuX3BjaWJ1cyA8IE1BWENDUFMpKSB7DQorCQl3aGlsZSAoKmNvbW1hICYmICpjb21tYSAhPSBD
T01NQSkNCisJCQljb21tYSsrOw0KKwkJaWYgKCpjb21tYSA9PSBDT01NQSkNCisJCQkqY29tbWEg
PSAnXDAnOw0KKwkJZWxzZQ0KKwkJCWVvcyA9IDE7DQorCQlyZXQgPSBrc3RydG91aW50KHRvaywg
MCwgJmJ1c25vKTsNCisJCWlmIChyZXQpIHsNCisJCQlwcl9pbmZvKCIlczogUGFyc2luZyBlcnJv
ciAoJWQpICclcydcbiIsIF9fZnVuY19fLCByZXQsIGJ1c2VzKTsNCisJCQlyZXR1cm47DQorCQl9
DQorCQlwY2lidXNbbl9wY2lidXMrK10gPSBidXNubzsNCisJCXRvayA9ICsrY29tbWE7DQorCX0N
Cit9DQorDQogI2lmZGVmIENPTkZJR19DUllQVE9fREVWX0NDUF9ERUJVR0ZTDQogbW9kcGFyYW1f
dCAgICAgIG1vZHVsZXBhcmFtZXRlcnNbXSA9IHsNCiAJeyJtYXhkZXYiLCAmbWF4ZGV2LCBTX0lS
VVNSfSwNCkBAIC0yMDQsNiArMjQyLDcgQEAgc3RhdGljIGludCBzcF9wY2lfcHJvYmUoc3RydWN0
IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICppZCkNCiAJdm9pZCBf
X2lvbWVtICogY29uc3QgKmlvbWFwX3RhYmxlOw0KIAlpbnQgYmFyX21hc2s7DQogCWludCByZXQ7
DQorCWludCBqOw0KIA0KIAlpZiAobWF4ZGV2ICYmIChkZXZjb3VudCA+PSBtYXhkZXYpKSAvKiBU
b28gbWFueSBkZXZpY2VzPyAqLw0KIAkJcmV0dXJuIDA7DQpAQCAtMjEyLDYgKzI1MSwyNSBAQCBz
dGF0aWMgaW50IHNwX3BjaV9wcm9iZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgY29uc3Qgc3RydWN0
IHBjaV9kZXZpY2VfaWQgKmlkKQ0KICAgICAgICAgaWYgKHBjaWRldiAmJiAocGRldi0+ZGV2aWNl
ICE9IHBjaWRldikpDQogICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIDA7DQogDQorCS8q
DQorCSogTG9vayBmb3IgKDEpIGEgc3BlY2lmaWMgZGV2aWNlLCAoMikgZGV2aWNlcyBvbiBhIGNl
cnRhaW4NCisJKiBidXMsIG9yICgzKSBhIHNwZWNpZmljIGRldmljZSBudW1iZXIuIElmIGJvdGgg
cGFyYW1ldGVycw0KKwkqIGFyZSB6ZXJvIGFjY2VwdCBhbnkgZGV2aWNlLg0KKwkqLw0KKwljY3Bf
cGFyc2VfcGNpX2J1c2VzKCk7DQorCWlmIChuX3BjaWJ1cykgew0KKwkJaW50IG1hdGNoID0gMDsN
CisNCisJCS8qIFNjYW4gdGhlIGxpc3Qgb2YgYnVzZXMgZm9yIGEgbWF0Y2ggKi8NCisJCWZvciAo
aiA9IDAgOyBqIDwgbl9wY2lidXMgOyBqKyspDQorCQkJaWYgKHBjaWJ1c1tqXSA9PSBwZGV2LT5i
dXMtPm51bWJlcikgew0KKwkJCQltYXRjaCA9IDE7DQorCQkJCWJyZWFrOw0KKwkJCX0NCisJCWlm
ICghbWF0Y2gpDQorCQkJcmV0dXJuIDA7DQorCX0NCisNCiAJcmV0ID0gLUVOT01FTTsNCiAJc3Ag
PSBzcF9hbGxvY19zdHJ1Y3QoZGV2KTsNCiAJaWYgKCFzcCkNCg0K
