Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A668C48BEA
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7000720657
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:29:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="y5QSAtJW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbfFXT3A (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:29:00 -0400
Received: from mail-eopbgr820087.outbound.protection.outlook.com ([40.107.82.87]:47712
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfFXT3A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:29:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=efx/xUiM/1hgUh19isBGC1UtJppMtEmIVDZqY1CYe8Q=;
 b=y5QSAtJWDafld7cYwkuIhcbH/Gikegaq5E4qjH6BzzTXLi8Lr0lYpQRx6zHWt2lmSZKv6qmuCH6C58w+P6nUOMLcFJs3YkLLC3xVRzqHRUqF0/xYmgrYZxLSvy/U4oz6fL6E8TkweD1SZFh/oVeGk+HRCpZgl5YIb9QJzF5/WH4=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2358.namprd12.prod.outlook.com (52.132.141.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 19:28:58 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 19:28:58 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 04/11] crypto: ccp - module parameter to limit the number of
 enabled CCPs
Thread-Topic: [PATCH 04/11] crypto: ccp - module parameter to limit the number
 of enabled CCPs
Thread-Index: AQHVKsMRXMi2BrYQekO9z9cQ78M/Tw==
Date:   Mon, 24 Jun 2019 19:28:57 +0000
Message-ID: <156140453629.116890.465562924738110016.stgit@sosrh3.amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
In-Reply-To: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0078.namprd12.prod.outlook.com
 (2603:10b6:802:20::49) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25e97f08-fec5-4a05-27e7-08d6f8da33ea
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2358;
x-ms-traffictypediagnostic: DM5PR12MB2358:
x-microsoft-antispam-prvs: <DM5PR12MB2358B94983DB49C2DD9A6CCAFDE00@DM5PR12MB2358.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(39860400002)(366004)(199004)(189003)(7736002)(5660300002)(26005)(2906002)(68736007)(8936002)(305945005)(186003)(386003)(66476007)(76176011)(8676002)(6506007)(64756008)(102836004)(81156014)(53936002)(52116002)(4326008)(66556008)(6486002)(66446008)(66946007)(73956011)(316002)(5640700003)(6916009)(25786009)(6436002)(81166006)(2501003)(6512007)(3846002)(2351001)(71200400001)(71190400001)(99286004)(103116003)(54906003)(14444005)(6116002)(256004)(476003)(72206003)(66066001)(14454004)(446003)(478600001)(486006)(11346002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2358;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 46Pw/PsxXOWXbk5QRE5tEyALZpS1vfZH69hRRRmfgSUMtVvXRnrJVrkMQ6TCMvixMLW5k7SHRDcP4GPDaRKjWf+4MR3KEEL3L/+xpMjlCuGn+6Ev5/yTN+Knrt1SQFGf6/s9d5lSfwxmF4NqvNNKICpEdFf3AML5W6v5Mn/41Zj/fIVcjuR2XfUJpHJUj2CJu2qbllxAmV4w4kRRXtlTPyik/INzXtAmLzlNXJ5XV7c1+j3urRlGCJkCOW6/ypA+MU02AeeaBKiYZO1CbUVBa273RJx+LQkWHCY97bGrGPgsH5jjIsCocHuZREeXOcbBaCcaozTQU/7vgf0q05+p2A9jKDCK1B5THLgXBPr+HYmYru+69+zEv1/0UcVNgKUZ7/Zf/bANEe39NC0qCD962xNi5morvgf2d0Aja4XjGlQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B21789544F296545B95282C5DA1612D4@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e97f08-fec5-4a05-27e7-08d6f8da33ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:28:57.9898
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

UHJvdmlkZSB0aGUgYWJpbGl0eSB0byBjb25zdHJhaW4gdGhlIHRvdGFsIG51bWJlciBvZiBlbmFi
bGVkIGRldmljZXMgaW4NCnRoZSBzeXN0ZW0uIE9uY2UgbWF4ZGV2IGRldmljZXMgaGF2ZSBiZWVu
IGNvbmZpZ3VyZWQsIGFkZGl0aW9uYWwNCmRldmljZXMgYXJlIGlnbm9yZWQuDQoNClNpZ25lZC1v
ZmYtYnk6IEdhcnkgUiBIb29rIDxnYXJ5Lmhvb2tAYW1kLmNvbT4NCi0tLQ0KIGRyaXZlcnMvY3J5
cHRvL2NjcC9zcC1wY2kuYyB8ICAgMTYgKysrKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2Vk
LCAxNiBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3Avc3At
cGNpLmMgYi9kcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMNCmluZGV4IGMxNjdjNDY3MWY0NS4u
YjgxNDkzODEwNjg5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jDQor
KysgYi9kcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMNCkBAIC0zNiw2ICszNiwxMyBAQA0KIC8q
DQogICogTGltaXQgQ0NQIHVzZSB0byBhIHNwZWNpZmVkIG51bWJlciBvZiBxdWV1ZXMgcGVyIGRl
dmljZS4NCiAgKi8NCisNCitzdGF0aWMgc3RydWN0IG11dGV4IGRldmNvdW50X211dGV4IF9fX19j
YWNoZWxpbmVfYWxpZ25lZDsNCitzdGF0aWMgdW5zaWduZWQgaW50IGRldmNvdW50ID0gMDsNCitz
dGF0aWMgdW5zaWduZWQgaW50IG1heGRldiA9IDA7DQorbW9kdWxlX3BhcmFtKG1heGRldiwgdWlu
dCwgMDQ0NCk7DQorTU9EVUxFX1BBUk1fREVTQyhtYXhkZXYsICJUb3RhbCBudW1iZXIgb2YgZGV2
aWNlcyB0byByZWdpc3RlciIpOw0KKw0KIHN0YXRpYyB1bnNpZ25lZCBpbnQgbnF1ZXVlcyA9IE1B
WF9IV19RVUVVRVM7DQogbW9kdWxlX3BhcmFtKG5xdWV1ZXMsIHVpbnQsIDA0NDQpOw0KIE1PRFVM
RV9QQVJNX0RFU0MobnF1ZXVlcywgIk51bWJlciBvZiBxdWV1ZXMgcGVyIENDUCAoZGVmYXVsdDog
NSkiKTsNCkBAIC0xOTMsNiArMjAwLDkgQEAgc3RhdGljIGludCBzcF9wY2lfcHJvYmUoc3RydWN0
IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICppZCkNCiAJaW50IGJh
cl9tYXNrOw0KIAlpbnQgcmV0Ow0KIA0KKwlpZiAobWF4ZGV2ICYmIChkZXZjb3VudCA+PSBtYXhk
ZXYpKSAvKiBUb28gbWFueSBkZXZpY2VzPyAqLw0KKwkJcmV0dXJuIDA7DQorDQogCXJldCA9IC1F
Tk9NRU07DQogCXNwID0gc3BfYWxsb2Nfc3RydWN0KGRldik7DQogCWlmICghc3ApDQpAQCAtMjYx
LDYgKzI3MSwxMSBAQCBzdGF0aWMgaW50IHNwX3BjaV9wcm9iZShzdHJ1Y3QgcGNpX2RldiAqcGRl
diwgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgKmlkKQ0KIAlpZiAocmV0KQ0KIAkJZ290byBl
X2VycjsNCiANCisJLyogSW5jcmVhc2UgY291bnQgb2YgZGV2aWNlcyAqLw0KKwltdXRleF9sb2Nr
KCZkZXZjb3VudF9tdXRleCk7DQorCWRldmNvdW50Kys7DQorCW11dGV4X3VubG9jaygmZGV2Y291
bnRfbXV0ZXgpOw0KKw0KIAlyZXR1cm4gMDsNCiANCiBlX2VycjoNCkBAIC0zNzQsNiArMzg5LDcg
QEAgc3RhdGljIHN0cnVjdCBwY2lfZHJpdmVyIHNwX3BjaV9kcml2ZXIgPSB7DQogDQogaW50IHNw
X3BjaV9pbml0KHZvaWQpDQogew0KKyAgICAgICAgbXV0ZXhfaW5pdCgmZGV2Y291bnRfbXV0ZXgp
Ow0KIAlyZXR1cm4gcGNpX3JlZ2lzdGVyX2RyaXZlcigmc3BfcGNpX2RyaXZlcik7DQogfQ0KIA0K
DQo=
