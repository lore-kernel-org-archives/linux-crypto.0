Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F594C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 385BC20657
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:28:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="LDI6EDPl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbfFXT2s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:28:48 -0400
Received: from mail-eopbgr810041.outbound.protection.outlook.com ([40.107.81.41]:59808
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfFXT2s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:28:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8VVe02L1lLOvaRcjTMtjn02aIMTccv9B0YrszkRioo=;
 b=LDI6EDPlCukHqnH0xe1luykCnjTUx9wB1tb/FCne8SvUJbfQORMDZ48Zw1zOEO4inD+MRA66FuodTmlTKvn2sLnZwyYZd2AYHrcoqMd6a7IwjLnm/n5O0r8LZU7mak1f0o+fX5y/N1GrBtUdQ0OfiZKRowmD+z+JrcfkivXTydc=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2358.namprd12.prod.outlook.com (52.132.141.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 19:28:44 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 19:28:44 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 02/11] crypto: ccp - Add a module parameter to specify a queue
 count
Thread-Topic: [PATCH 02/11] crypto: ccp - Add a module parameter to specify a
 queue count
Thread-Index: AQHVKsMJOIGfGw03z0Wl0jZnI/jaNw==
Date:   Mon, 24 Jun 2019 19:28:44 +0000
Message-ID: <156140452269.116890.16300533767199946313.stgit@sosrh3.amd.com>
References: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
In-Reply-To: <156140365456.116890.15736288493305066708.stgit@sosrh3.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0056.namprd12.prod.outlook.com
 (2603:10b6:802:20::27) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ded4e5ed-6e98-4a88-68fc-08d6f8da2bbc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2358;
x-ms-traffictypediagnostic: DM5PR12MB2358:
x-microsoft-antispam-prvs: <DM5PR12MB23586161E2C55A444F6049CAFDE00@DM5PR12MB2358.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:483;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(39860400002)(366004)(199004)(189003)(7736002)(5660300002)(26005)(2906002)(68736007)(8936002)(305945005)(186003)(386003)(66476007)(76176011)(8676002)(6506007)(64756008)(102836004)(81156014)(53936002)(52116002)(4326008)(66556008)(6486002)(66446008)(66946007)(73956011)(316002)(5640700003)(6916009)(25786009)(6436002)(81166006)(2501003)(6512007)(3846002)(2351001)(71200400001)(71190400001)(99286004)(103116003)(54906003)(14444005)(6116002)(256004)(476003)(72206003)(66066001)(14454004)(446003)(478600001)(486006)(11346002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2358;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WleDRCNVDMmYYrGth5gAB/mFYMSPI/UVe+exODSVNLPtWCFbg3xKojUGKN3qdHHtbOuJ8wBaPZmSDzFFmVMdz2gIRGVlMU0uGJxDWDz69+p35XJ+x9AUq6tzH6C0e6GKwp1fCLDB/ewpgkYKqKF9jaKZnhV0vQkWewrnBydmOf6sXb2IjGty1bfZWO1aXdZ9LNDniYks41VLFqekMVeRRDUOe0xZDf6DwyPnzReIul2IjGKH8sAaWw9z1096ogOTS7c9dHK1/49LVutkkfiUnXEu3XN286mBddymAyDkKzwIELZE/6d7NitlofnOb48xKwtl31tDihnHf1Npz+sm8vf2tgYnvhAt4joKNC0LP+7orQ0hTRH85FL4lhpKkthnNaFub7sSUj+qSEYIfP1KVzWGIFYbSAPN4mqf9R41tXQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B4D21BEE45A9645804252015528D499@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ded4e5ed-6e98-4a88-68fc-08d6f8da2bbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:28:44.2953
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

QWRkIGEgbW9kdWxlIHBhcmFtZXRlciB0byBsaW1pdCB0aGUgbnVtYmVyIG9mIHF1ZXVlcyBwZXIg
Q0NQLiBUaGUgZGVmYXVsdA0KKG5xdWV1ZXM9MCkgaXMgdG8gc2V0IHVwIGV2ZXJ5IGF2YWlsYWJs
ZSBxdWV1ZSBvbiBlYWNoIGRldmljZS4NCg0KVGhlIGNvdW50IG9mIHF1ZXVlcyBzdGFydHMgZnJv
bSB0aGUgZmlyc3Qgb25lIGZvdW5kIG9uIHRoZSBkZXZpY2UgKHdoaWNoDQppcyBiYXNlZCBvbiB0
aGUgZGV2aWNlIElEKS4NCg0KU2lnbmVkLW9mZi1ieTogR2FyeSBSIEhvb2sgPGdhcnkuaG9va0Bh
bWQuY29tPg0KLS0tDQogZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYyB8ICAgIDkgKysr
KysrKystDQogZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYuaCAgICB8ICAgMTUgKysrKysrKysr
KysrKysrDQogZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jICAgICB8ICAgMTUgKysrKysrKysr
KysrKystDQogMyBmaWxlcyBjaGFuZ2VkLCAzNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYyBiL2RyaXZl
cnMvY3J5cHRvL2NjcC9jY3AtZGV2LXY1LmMNCmluZGV4IGE1YmQxMTgzMWI4MC4uZmZkNTQ2Yjk1
MWI2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYw0KKysrIGIv
ZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYtdjUuYw0KQEAgLTE0LDEyICsxNCwxNSBAQA0KICNp
bmNsdWRlIDxsaW51eC9rZXJuZWwuaD4NCiAjaW5jbHVkZSA8bGludXgvcGNpLmg+DQogI2luY2x1
ZGUgPGxpbnV4L2t0aHJlYWQuaD4NCi0jaW5jbHVkZSA8bGludXgvZGVidWdmcy5oPg0KICNpbmNs
dWRlIDxsaW51eC9kbWEtbWFwcGluZy5oPg0KICNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4N
CiAjaW5jbHVkZSA8bGludXgvY29tcGlsZXIuaD4NCiAjaW5jbHVkZSA8bGludXgvY2NwLmg+DQog
DQorI2lmZGVmIENPTkZJR19DUllQVE9fREVWX0NDUF9ERUJVR0ZTDQorI2luY2x1ZGUgPGxpbnV4
L2RlYnVnZnMuaD4NCisjZW5kaWYNCisNCiAjaW5jbHVkZSAiY2NwLWRldi5oIg0KIA0KIC8qIEFs
bG9jYXRlIHRoZSByZXF1ZXN0ZWQgbnVtYmVyIG9mIGNvbnRpZ3VvdXMgTFNCIHNsb3RzDQpAQCAt
Nzg0LDYgKzc4Nyw3IEBAIHN0YXRpYyBpcnFyZXR1cm5fdCBjY3A1X2lycV9oYW5kbGVyKGludCBp
cnEsIHZvaWQgKmRhdGEpDQogDQogc3RhdGljIGludCBjY3A1X2luaXQoc3RydWN0IGNjcF9kZXZp
Y2UgKmNjcCkNCiB7DQorCXVuc2lnbmVkIGludCBucXVldWVzID0gY2NwX2dldF9ucXVldWVzX3Bh
cmFtKCk7DQogCXN0cnVjdCBkZXZpY2UgKmRldiA9IGNjcC0+ZGV2Ow0KIAlzdHJ1Y3QgY2NwX2Nt
ZF9xdWV1ZSAqY21kX3E7DQogCXN0cnVjdCBkbWFfcG9vbCAqZG1hX3Bvb2w7DQpAQCAtODU2LDYg
Kzg2MCw5IEBAIHN0YXRpYyBpbnQgY2NwNV9pbml0KHN0cnVjdCBjY3BfZGV2aWNlICpjY3ApDQog
CQlpbml0X3dhaXRxdWV1ZV9oZWFkKCZjbWRfcS0+aW50X3F1ZXVlKTsNCiANCiAJCWRldl9kYmco
ZGV2LCAicXVldWUgIyV1IGF2YWlsYWJsZVxuIiwgaSk7DQorDQorCQlpZiAoY2NwLT5jbWRfcV9j
b3VudCA+PSBucXVldWVzKQ0KKwkJCWJyZWFrOw0KIAl9DQogDQogCWlmIChjY3AtPmNtZF9xX2Nv
dW50ID09IDApIHsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oIGIv
ZHJpdmVycy9jcnlwdG8vY2NwL2NjcC1kZXYuaA0KaW5kZXggNjgxMGI2NWMxOTM5Li5kODEyNDQ2
MjEzZWUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oDQorKysgYi9k
cml2ZXJzL2NyeXB0by9jY3AvY2NwLWRldi5oDQpAQCAtNjMyLDYgKzYzMiw4IEBAIHN0cnVjdCBj
Y3A1X2Rlc2Mgew0KIHZvaWQgY2NwX2FkZF9kZXZpY2Uoc3RydWN0IGNjcF9kZXZpY2UgKmNjcCk7
DQogdm9pZCBjY3BfZGVsX2RldmljZShzdHJ1Y3QgY2NwX2RldmljZSAqY2NwKTsNCiANCit1bnNp
Z25lZCBpbnQgY2NwX2dldF9ucXVldWVzX3BhcmFtKHZvaWQpOw0KKw0KIGV4dGVybiB2b2lkIGNj
cF9sb2dfZXJyb3Ioc3RydWN0IGNjcF9kZXZpY2UgKiwgaW50KTsNCiANCiBzdHJ1Y3QgY2NwX2Rl
dmljZSAqY2NwX2FsbG9jX3N0cnVjdChzdHJ1Y3Qgc3BfZGV2aWNlICpzcCk7DQpAQCAtNjcxLDQg
KzY3MywxNyBAQCBleHRlcm4gY29uc3Qgc3RydWN0IGNjcF92ZGF0YSBjY3B2MzsNCiBleHRlcm4g
Y29uc3Qgc3RydWN0IGNjcF92ZGF0YSBjY3B2NWE7DQogZXh0ZXJuIGNvbnN0IHN0cnVjdCBjY3Bf
dmRhdGEgY2NwdjViOw0KIA0KKw0KKyNpZmRlZiBDT05GSUdfQ1JZUFRPX0RFVl9DQ1BfREVCVUdG
Uw0KKw0KKy8qIERlYnVnRlMgc3R1ZmYgKi8NCit0eXBlZGVmIHN0cnVjdCBfbW9kcGFyYW0gew0K
KyAgICAgICAgICAgICAgICBjaGFyICpwYXJhbW5hbWU7DQorICAgICAgICAgICAgICAgIHZvaWQg
KnBhcmFtOw0KKyAgICAgICAgICAgICAgICB1bW9kZV90IHBhcmFtbW9kZTsNCisgICAgICAgIH0g
bW9kcGFyYW1fdDsNCitleHRlcm4gdm9pZCBjY3BfZGVidWdmc19yZWdpc3Rlcl9tb2RwYXJhbXMo
c3RydWN0IGRlbnRyeSAqcGFyZW50ZGlyKTsNCisNCisjZW5kaWYNCisNCiAjZW5kaWYNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2NyeXB0by9jY3Avc3AtcGNpLmMgYi9kcml2ZXJzL2NyeXB0by9jY3Av
c3AtcGNpLmMNCmluZGV4IDQxYmNlMGEzZjRiYi4uM2ZhYjc5NTg1ZjcyIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9jcnlwdG8vY2NwL3NwLXBjaS5jDQorKysgYi9kcml2ZXJzL2NyeXB0by9jY3Avc3At
cGNpLmMNCkBAIC0xLDcgKzEsOSBAQA0KKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwt
Mi4wDQorDQogLyoNCiAgKiBBTUQgU2VjdXJlIFByb2Nlc3NvciBkZXZpY2UgZHJpdmVyDQogICoN
Ci0gKiBDb3B5cmlnaHQgKEMpIDIwMTMsMjAxOCBBZHZhbmNlZCBNaWNybyBEZXZpY2VzLCBJbmMu
DQorICogQ29weXJpZ2h0IChDKSAyMDEzLDIwMTkgQWR2YW5jZWQgTWljcm8gRGV2aWNlcywgSW5j
Lg0KICAqDQogICogQXV0aG9yOiBUb20gTGVuZGFja3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29t
Pg0KICAqIEF1dGhvcjogR2FyeSBSIEhvb2sgPGdhcnkuaG9va0BhbWQuY29tPg0KQEAgLTI3LDYg
KzI5LDE3IEBADQogI2luY2x1ZGUgImNjcC1kZXYuaCINCiAjaW5jbHVkZSAicHNwLWRldi5oIg0K
IA0KKy8qDQorICogTGltaXQgQ0NQIHVzZSB0byBhIHNwZWNpZmVkIG51bWJlciBvZiBxdWV1ZXMg
cGVyIGRldmljZS4NCisgKi8NCitzdGF0aWMgdW5zaWduZWQgaW50IG5xdWV1ZXMgPSBNQVhfSFdf
UVVFVUVTOw0KK21vZHVsZV9wYXJhbShucXVldWVzLCB1aW50LCAwNDQ0KTsNCitNT0RVTEVfUEFS
TV9ERVNDKG5xdWV1ZXMsICJOdW1iZXIgb2YgcXVldWVzIHBlciBDQ1AgKGRlZmF1bHQ6IDUpIik7
DQorDQordW5zaWduZWQgaW50IGNjcF9nZXRfbnF1ZXVlc19wYXJhbSh2b2lkKSB7DQorCXJldHVy
biBucXVldWVzOw0KK30NCisNCiAjZGVmaW5lIE1TSVhfVkVDVE9SUwkJCTINCiANCiBzdHJ1Y3Qg
c3BfcGNpIHsNCg0K
