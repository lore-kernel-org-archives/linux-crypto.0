Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D952C0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 19:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6C9E218A4
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 19:21:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="S9PK/QNp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfGCTVa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 15:21:30 -0400
Received: from mail-eopbgr780087.outbound.protection.outlook.com ([40.107.78.87]:52947
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726574AbfGCTV3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 15:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRLCO77h1cMvQNM5tbxFm5MfbWmMMqQ1NtARSUbhGfs=;
 b=S9PK/QNp8T47QP2udO9t8lOevusgYhfY+mLVACRSakF21AGXUVfUhEtKWy0vsUW/IJp7MVHyDBU817U0LQAugeuCbyWQfIs5pnOk6Mh83L1ELaoKJEWRKLjjEpdBscTyJoPu6qK9iWihyOK8pe7HGc/bpRZTpxyct2j/NQc1Dqo=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2533.namprd12.prod.outlook.com (52.132.141.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.16; Wed, 3 Jul 2019 19:21:26 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 19:21:26 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH] crypto: ccp - memset structure fields to zero before reuse
Thread-Topic: [PATCH] crypto: ccp - memset structure fields to zero before
 reuse
Thread-Index: AQHVMdSCRv0gts48Gk+YiLK37j85MA==
Date:   Wed, 3 Jul 2019 19:21:26 +0000
Message-ID: <156218168473.3184.15319927087462863547.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0201CA0065.namprd02.prod.outlook.com
 (2603:10b6:803:20::27) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52dc8ab7-6068-446e-dcba-08d6ffeba46f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2533;
x-ms-traffictypediagnostic: DM5PR12MB2533:
x-microsoft-antispam-prvs: <DM5PR12MB2533EB0AD213551A35BF2F3FFDFB0@DM5PR12MB2533.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:397;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(376002)(39860400002)(366004)(189003)(199004)(25786009)(66066001)(14444005)(256004)(4326008)(86362001)(305945005)(7736002)(26005)(68736007)(8936002)(2351001)(71200400001)(71190400001)(6916009)(6506007)(386003)(81156014)(81166006)(8676002)(52116002)(102836004)(99286004)(2906002)(72206003)(5640700003)(6512007)(6436002)(73956011)(2501003)(53936002)(6486002)(54906003)(6116002)(3846002)(103116003)(316002)(478600001)(66476007)(66556008)(64756008)(66946007)(66446008)(5660300002)(14454004)(476003)(486006)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2533;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qmZave1VPnYI9bV/CqHXYJx/tnxyB6ebTJmMVgRqnYmOdCGbEK1mBY4O92VRxpYPfEtH0csiCdJRjpEaW5ljkHJ01+fq6dwZWO0cktkTM2NdB3nkom/dpltT7rjtZV5+Dl2IQ6WGtSrU4HpCbntLAe+JS8bCV+AazgzSzSnsGWVWoBGBVmYDTI9A4appW2rbXIedoiJvRlyA1T0KMBeqq9v5XuoprUClmP0iHwMu1O2dNoi2dTtJpC0dkkVc8RvXI0MmSUVynj6zMrtlNnOJGD0MeUql2SRgqH8TdKWh/adjYDcllFq8qaqrJjmkGlZf6bZeFQO+xWAFfixml/pk/h88dtnH9giD8CEXzlDRNMiLfCVtwZJTN2gQNM4h5u2JpEDwY4XInLeHRxee6hOc8b+PJjXv2hmPCBH0vXCBGQQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5A730E3D85DBC4ABF1FC93A48C2EC4A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52dc8ab7-6068-446e-dcba-08d6ffeba46f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 19:21:26.4959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2533
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VGhlIEFFUyBHQ00gZnVuY3Rpb24gcmV1c2VzIGFuICdvcCcgZGF0YSBzdHJ1Y3R1cmUsIHdoaWNo
IG1lbWJlcnMNCmNvbnRhaW4gdmFsdWVzIHRoYXQgbXVzdCBiZSBjbGVhcmVkIGZvciBlYWNoIChy
ZSl1c2UuDQoNCkZpeGVzOiAzNmNmNTE1YjliYmUgKCJjcnlwdG86IGNjcCAtIEVuYWJsZSBzdXBw
b3J0IGZvciBBRVMgR0NNIG9uIHY1IENDUHMiKQ0KDQpTaWduZWQtb2ZmLWJ5OiBHYXJ5IFIgSG9v
ayA8Z2FyeS5ob29rQGFtZC5jb20+DQotLS0NCiBkcml2ZXJzL2NyeXB0by9jY3AvY2NwLW9wcy5j
IHwgICAxMiArKysrKysrKysrKy0NCiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1vcHMu
YyBiL2RyaXZlcnMvY3J5cHRvL2NjcC9jY3Atb3BzLmMNCmluZGV4IGIxMTZkNjI5OTFjNi4uNjk1
NTIyYjJiYTdmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1vcHMuYw0KKysr
IGIvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1vcHMuYw0KQEAgLTYyNiw2ICs2MjYsNyBAQCBzdGF0
aWMgaW50IGNjcF9ydW5fYWVzX2djbV9jbWQoc3RydWN0IGNjcF9jbWRfcXVldWUgKmNtZF9xLA0K
IA0KIAl1bnNpZ25lZCBsb25nIGxvbmcgKmZpbmFsOw0KIAl1bnNpZ25lZCBpbnQgZG1fb2Zmc2V0
Ow0KKwl1bnNpZ25lZCBpbnQgam9iaWQ7DQogCXVuc2lnbmVkIGludCBpbGVuOw0KIAlib29sIGlu
X3BsYWNlID0gdHJ1ZTsgLyogRGVmYXVsdCB2YWx1ZSAqLw0KIAlpbnQgcmV0Ow0KQEAgLTY2NCw5
ICs2NjUsMTEgQEAgc3RhdGljIGludCBjY3BfcnVuX2Flc19nY21fY21kKHN0cnVjdCBjY3BfY21k
X3F1ZXVlICpjbWRfcSwNCiAJCXBfdGFnID0gc2NhdHRlcndhbGtfZmZ3ZChzZ190YWcsIHBfaW5w
LCBpbGVuKTsNCiAJfQ0KIA0KKwlqb2JpZCA9IENDUF9ORVdfSk9CSUQoY21kX3EtPmNjcCk7DQor
DQogCW1lbXNldCgmb3AsIDAsIHNpemVvZihvcCkpOw0KIAlvcC5jbWRfcSA9IGNtZF9xOw0KLQlv
cC5qb2JpZCA9IENDUF9ORVdfSk9CSUQoY21kX3EtPmNjcCk7DQorCW9wLmpvYmlkID0gam9iaWQ7
DQogCW9wLnNiX2tleSA9IGNtZF9xLT5zYl9rZXk7IC8qIFByZS1hbGxvY2F0ZWQgKi8NCiAJb3Au
c2JfY3R4ID0gY21kX3EtPnNiX2N0eDsgLyogUHJlLWFsbG9jYXRlZCAqLw0KIAlvcC5pbml0ID0g
MTsNCkBAIC04MTcsNiArODIwLDEzIEBAIHN0YXRpYyBpbnQgY2NwX3J1bl9hZXNfZ2NtX2NtZChz
dHJ1Y3QgY2NwX2NtZF9xdWV1ZSAqY21kX3EsDQogCWZpbmFsWzBdID0gY3B1X3RvX2JlNjQoYWVz
LT5hYWRfbGVuICogOCk7DQogCWZpbmFsWzFdID0gY3B1X3RvX2JlNjQoaWxlbiAqIDgpOw0KIA0K
KwltZW1zZXQoJm9wLCAwLCBzaXplb2Yob3ApKTsNCisJb3AuY21kX3EgPSBjbWRfcTsNCisJb3Au
am9iaWQgPSBqb2JpZDsNCisJb3Auc2Jfa2V5ID0gY21kX3EtPnNiX2tleTsgLyogUHJlLWFsbG9j
YXRlZCAqLw0KKwlvcC5zYl9jdHggPSBjbWRfcS0+c2JfY3R4OyAvKiBQcmUtYWxsb2NhdGVkICov
DQorCW9wLmluaXQgPSAxOw0KKwlvcC51LmFlcy50eXBlID0gYWVzLT50eXBlOw0KIAlvcC51LmFl
cy5tb2RlID0gQ0NQX0FFU19NT0RFX0dIQVNIOw0KIAlvcC51LmFlcy5hY3Rpb24gPSBDQ1BfQUVT
X0dIQVNIRklOQUw7DQogCW9wLnNyYy50eXBlID0gQ0NQX01FTVRZUEVfU1lTVEVNOw0KDQo=
