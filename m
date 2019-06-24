Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0A0C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7ADC20657
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:28:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="rXAUcmIE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbfFXT2x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:28:53 -0400
Received: from mail-eopbgr740074.outbound.protection.outlook.com ([40.107.74.74]:16214
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfFXT2x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkwxvmJcKvN0AA80kP839T0aEixA3lBDzAmhQne4s78=;
 b=rXAUcmIE7NaG12z5yZDSJQ0AtYbLQJn2qCzWuIPvDpoRMUXu1Lc1azvmstm6y3qyuq5+uKQDA4ePHllQ4UzslBN6G2XMy88IlER++QLk4L95Nl7of/L1Hi1rTsxTMrI6ExNFKE4Pj68BykZUpgUMu20fQeR8aNLG+Vb9ImxGqbA=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2358.namprd12.prod.outlook.com (52.132.141.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 19:28:51 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 19:28:51 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 03/11] crypto: ccp - Expose the value of nqueues in DebugFS
Thread-Topic: [PATCH 03/11] crypto: ccp - Expose the value of nqueues in
 DebugFS
Thread-Index: AQHVKsMNjbQp7GUaYUqZRM2Nz4oxPA==
Date:   Mon, 24 Jun 2019 19:28:51 +0000
Message-ID: <156140452950.116890.8616947153652273997.stgit@sosrh3.amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
In-Reply-To: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0067.namprd12.prod.outlook.com
 (2603:10b6:802:20::38) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d64b69e-6df2-42c3-0d10-08d6f8da2fc9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2358;
x-ms-traffictypediagnostic: DM5PR12MB2358:
x-microsoft-antispam-prvs: <DM5PR12MB23588BB622A0C09F0D286837FDE00@DM5PR12MB2358.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(39860400002)(366004)(199004)(189003)(7736002)(5660300002)(26005)(2906002)(68736007)(8936002)(305945005)(186003)(386003)(66476007)(76176011)(8676002)(6506007)(64756008)(102836004)(81156014)(53936002)(52116002)(4326008)(66556008)(6486002)(66446008)(66946007)(73956011)(316002)(5640700003)(6916009)(25786009)(6436002)(81166006)(2501003)(6512007)(3846002)(2351001)(71200400001)(71190400001)(99286004)(103116003)(54906003)(6116002)(256004)(476003)(72206003)(66066001)(14454004)(446003)(478600001)(486006)(11346002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2358;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PQHpHbzyKKa48JSUK6bHR3+r0WU/cV7b8j3u1/a7YDsNaP11aL08+FZMpQslDH5P4TOi2cHlKUQJ2Fge2gEymJwzUjjXsmwhFs5/FmAKFMNrXOHvkmDX33tqivmCAFmqTBq/wZ9snkE9JZr3N/NCOFsOUId1SstwaaWxfvlPi0SI2k5vJqsS6fnmD9qcSydqmXFLIuHRvBmJFxIjDtyOH4Zi5kx6bjvkCs3C4XOv9JqcP9vvpoxVEFzbUqGLdRH59WvZkzj3C9C/imd7U2kkxjnFHd07ZlVctfCn556OC1gd4NEGcZTTwF6QsNh50RQu9ic/EFg2Bk5b7kG4uvk2hfc8EKuZ+R+ReHZvoCWk4akAzGM4vap49zq6fDW1Acggd+4/GUP6kk866Apz7vfjMQTuK4fFdCqlunbzeKOpZaU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D121CF32D674D54CBD75AE741FE47A08@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d64b69e-6df2-42c3-0d10-08d6f8da2fc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:28:51.0770
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

TWFrZSBtb2R1bGUgcGFyYW1ldGVycyByZWFkYWJsZSBpbiBEZWJ1Z0ZTLg0KDQpTaWduZWQtb2Zm
LWJ5OiBHYXJ5IFIgSG9vayA8Z2FyeS5ob29rQGFtZC5jb20+DQotLS0NCiBkcml2ZXJzL2NyeXB0
by9jY3AvY2NwLWRlYnVnZnMuYyB8ICAgIDIgKysNCiBkcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNp
LmMgICAgICB8ICAgMjIgKysrKysrKysrKysrKysrKysrKysrKw0KIDIgZmlsZXMgY2hhbmdlZCwg
MjQgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1k
ZWJ1Z2ZzLmMgYi9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRlYnVnZnMuYw0KaW5kZXggNGJkMjZh
ZjcwOThkLi5jNGNjMGU2MGZkNTAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvY2Nw
LWRlYnVnZnMuYw0KKysrIGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZWJ1Z2ZzLmMNCkBAIC0z
MTcsNiArMzE3LDggQEAgdm9pZCBjY3A1X2RlYnVnZnNfc2V0dXAoc3RydWN0IGNjcF9kZXZpY2Ug
KmNjcCkNCiAJCQkJICAgICZjY3BfZGVidWdmc19xdWV1ZV9vcHMpOw0KIAl9DQogDQorCWNjcF9k
ZWJ1Z2ZzX3JlZ2lzdGVyX21vZHBhcmFtcyhjY3BfZGVidWdmc19kaXIpOw0KKw0KIAlyZXR1cm47
DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9zcC1wY2kuYyBiL2RyaXZl
cnMvY3J5cHRvL2NjcC9zcC1wY2kuYw0KaW5kZXggM2ZhYjc5NTg1ZjcyLi5jMTY3YzQ2NzFmNDUg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMNCisrKyBiL2RyaXZlcnMv
Y3J5cHRvL2NjcC9zcC1wY2kuYw0KQEAgLTI2LDYgKzI2LDEwIEBADQogI2luY2x1ZGUgPGxpbnV4
L2RlbGF5Lmg+DQogI2luY2x1ZGUgPGxpbnV4L2NjcC5oPg0KIA0KKyNpZmRlZiBDT05GSUdfQ1JZ
UFRPX0RFVl9DQ1BfREVCVUdGUw0KKyNpbmNsdWRlIDxsaW51eC9kZWJ1Z2ZzLmg+DQorI2VuZGlm
DQorDQogI2luY2x1ZGUgImNjcC1kZXYuaCINCiAjaW5jbHVkZSAicHNwLWRldi5oIg0KIA0KQEAg
LTM2LDYgKzQwLDI0IEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgbnF1ZXVlcyA9IE1BWF9IV19RVUVV
RVM7DQogbW9kdWxlX3BhcmFtKG5xdWV1ZXMsIHVpbnQsIDA0NDQpOw0KIE1PRFVMRV9QQVJNX0RF
U0MobnF1ZXVlcywgIk51bWJlciBvZiBxdWV1ZXMgcGVyIENDUCAoZGVmYXVsdDogNSkiKTsNCiAN
CisjaWZkZWYgQ09ORklHX0NSWVBUT19ERVZfQ0NQX0RFQlVHRlMNCittb2RwYXJhbV90ICAgICAg
bW9kdWxlcGFyYW1ldGVyc1tdID0gew0KKwl7Im5xdWV1ZXMiLCAmbnF1ZXVlcywgU19JUlVTUn0s
DQorCXtOVUxMLCBOVUxMLCAwfSwNCit9Ow0KKw0KK3ZvaWQgY2NwX2RlYnVnZnNfcmVnaXN0ZXJf
bW9kcGFyYW1zKHN0cnVjdCBkZW50cnkgKnBhcmVudGRpcikNCit7DQorCWludCBqOw0KKw0KKwlm
b3IgKGogPSAwOyBtb2R1bGVwYXJhbWV0ZXJzW2pdLnBhcmFtbmFtZTsgaisrKQ0KKwkJZGVidWdm
c19jcmVhdGVfdTMyKG1vZHVsZXBhcmFtZXRlcnNbal0ucGFyYW1uYW1lLA0KKwkJCQkgICBtb2R1
bGVwYXJhbWV0ZXJzW2pdLnBhcmFtbW9kZSwgcGFyZW50ZGlyLA0KKwkJCQkgICBtb2R1bGVwYXJh
bWV0ZXJzW2pdLnBhcmFtKTsNCit9DQorDQorI2VuZGlmDQorDQogdW5zaWduZWQgaW50IGNjcF9n
ZXRfbnF1ZXVlc19wYXJhbSh2b2lkKSB7DQogCXJldHVybiBucXVldWVzOw0KIH0NCg0K
