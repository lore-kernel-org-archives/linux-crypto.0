Return-Path: <SRS0=+pKF=VH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96516C74A35
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 22:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EA1A20665
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 22:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="pk7GzeJX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfGJWug (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jul 2019 18:50:36 -0400
Received: from mail-eopbgr690084.outbound.protection.outlook.com ([40.107.69.84]:60064
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726708AbfGJWug (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jul 2019 18:50:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+BIyC15jy9UJ2bAu2gdF1oizLsp1HM/2X9VK1ulPMFE=;
 b=pk7GzeJXx4694/FEmc5M/kJAWoFBGE/ytsR8EvfXFX2CxHiTWSBHApA33Qdm0VdoxF+B+OdyeICc/D0ZF56ZM5K9X4gjnwDlT4IO9coHq9PD0mQOJvRIm+bIFw6dO6L1O7/dGwqBuph+HD7j2q699kGy2vvKZZlBaFVYwvJ3nww=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1673.namprd12.prod.outlook.com (10.172.39.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Wed, 10 Jul 2019 22:50:31 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::a894:b1d5:a126:adce%6]) with mapi id 15.20.2052.020; Wed, 10 Jul 2019
 22:50:31 +0000
From:   Gary R Hook <ghook@amd.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: Re: [PATCH v2] crypto: ccp - memset structure fields to zero before
 reuse
Thread-Topic: [PATCH v2] crypto: ccp - memset structure fields to zero before
 reuse
Thread-Index: AQHVNrO6m+NQJFdJik6RYa0T/lhkoKbDGDyAgACXVICAAKDHgIAAJf+A
Date:   Wed, 10 Jul 2019 22:50:31 +0000
Message-ID: <d4b8006c-0243-b4a4-c695-a67041acc82f@amd.com>
References: <20190710000849.3131-1-gary.hook@amd.com>
 <20190710015725.GA746@sol.localdomain>
 <2875285f-d438-667e-52d9-801124ffba88@amd.com>
 <20190710203428.GC83443@gmail.com>
In-Reply-To: <20190710203428.GC83443@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR02CA0141.namprd02.prod.outlook.com
 (2603:10b6:208:35::46) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.84.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9815a61-9d3d-45a3-94ac-08d7058902eb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1673;
x-ms-traffictypediagnostic: DM5PR12MB1673:
x-microsoft-antispam-prvs: <DM5PR12MB16736B25B68735E897D9D81DFDF00@DM5PR12MB1673.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(189003)(199004)(53936002)(11346002)(6436002)(446003)(316002)(71190400001)(71200400001)(76176011)(6512007)(52116002)(66066001)(476003)(2201001)(2616005)(31686004)(5660300002)(110136005)(486006)(8676002)(7736002)(25786009)(2906002)(478600001)(6486002)(14454004)(6636002)(81166006)(81156014)(229853002)(3846002)(6116002)(99286004)(305945005)(102836004)(186003)(68736007)(26005)(6246003)(66946007)(53546011)(8936002)(256004)(2501003)(64756008)(66446008)(386003)(6506007)(31696002)(66556008)(66476007)(36756003)(14444005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1673;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S391LamfNjeKgncDc+vjDkdevrKdcorViM0QdST9Lndzaxb9ibn/SJ6ba7zfa40YPnbDn07BbjYD/Mq9xoWUbjkbVzEMDfSMCawcDUYoXcWn4eecTUXXWTanLWIqPzaRDEcCNuocPOZnybCrfBgeEIc8NnX5+rGZYV1O1LfoSPP0Jkpd6NnAaxQPwDdstybByFS25Cp2qQPqLZn1tMstW5OyIzijOTe0Ofac7ddRsO+F54hqLE6FWDk8CdXPk809zUXTvlMKAYhE2PyV4A3YsXEO1THyzJxTBgCovw2WxlvoCEHpi9mjP2WcowSmadF3cr8PIFzi/OVc6JKygO1umznNVsHpChBDiSTyASh+JO8I/mA3SjruiqT+c3qNUF9vC9Rdg5lbxNiSFLZ3sDNMaSGHYqQYf6Tg8FqGmLHheiI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58F9A23FE2B64B41A40EB7355A2A1990@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9815a61-9d3d-45a3-94ac-08d7058902eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 22:50:31.5567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1673
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy8xMC8xOSAzOjM0IFBNLCBFcmljIEJpZ2dlcnMgd3JvdGU6DQo+IE9uIFdlZCwgSnVsIDEw
LCAyMDE5IGF0IDAzOjU5OjA1UE0gKzAwMDAsIEdhcnkgUiBIb29rIHdyb3RlOg0KPj4gT24gNy85
LzE5IDg6NTcgUE0sIEVyaWMgQmlnZ2VycyB3cm90ZToNCj4+PiBPbiBXZWQsIEp1bCAxMCwgMjAx
OSBhdCAxMjowOToyMkFNICswMDAwLCBIb29rLCBHYXJ5IHdyb3RlOg0KPj4+PiBUaGUgQUVTIEdD
TSBmdW5jdGlvbiByZXVzZXMgYW4gJ29wJyBkYXRhIHN0cnVjdHVyZSwgd2hpY2ggbWVtYmVycw0K
Pj4+PiBjb250YWluIHZhbHVlcyB0aGF0IG11c3QgYmUgY2xlYXJlZCBmb3IgZWFjaCAocmUpdXNl
Lg0KPj4+Pg0KPj4+PiBUaGlzIGZpeCByZXNvbHZlcyBhIGNyeXB0byBzZWxmLXRlc3QgZmFpbHVy
ZToNCj4+Pj4gYWxnOiBhZWFkOiBnY20tYWVzLWNjcCBlbmNyeXB0aW9uIHRlc3QgZmFpbGVkICh3
cm9uZyByZXN1bHQpIG9uIHRlc3QgdmVjdG9yIDIsIGNmZz0idHdvIGV2ZW4gYWxpZ25lZCBzcGxp
dHMiDQo+Pj4+DQo+Pj4+IEZpeGVzOiAzNmNmNTE1YjliYmUgKCJjcnlwdG86IGNjcCAtIEVuYWJs
ZSBzdXBwb3J0IGZvciBBRVMgR0NNIG9uIHY1IENDUHMiKQ0KPj4+Pg0KPj4+PiBTaWduZWQtb2Zm
LWJ5OiBHYXJ5IFIgSG9vayA8Z2FyeS5ob29rQGFtZC5jb20+DQo+Pj4NCj4+PiBGWUksIHdpdGgg
dGhpcyBwYXRjaCBhcHBsaWVkIEknbSBzdGlsbCBzZWVpbmcgYW5vdGhlciB0ZXN0IGZhaWx1cmU6
DQo+Pj4NCj4+PiBbICAgIDIuMTQwMjI3XSBhbGc6IGFlYWQ6IGdjbS1hZXMtY2NwIHNldGF1dGhz
aXplIHVuZXhwZWN0ZWRseSBzdWNjZWVkZWQgb24gdGVzdCB2ZWN0b3IgInJhbmRvbTogYWxlbj0y
NjQgcGxlbj0xNjEgYXV0aHNpemU9NiBrbGVuPTMyIjsgZXhwZWN0ZWRfZXJyb3I9LTIyDQo+Pj4N
Cj4+PiBBcmUgeW91IGF3YXJlIG9mIHRoYXQgb25lIHRvbywgYW5kIGFyZSB5b3UgcGxhbm5pbmcg
dG8gZml4IGl0Pw0KPj4+DQo+Pj4gLSBFcmljDQo+Pj4NCj4+DQo+PiBJIGp1c3QgcHVsbGVkIHRo
ZSBsYXRlc3Qgb24gdGhlIG1hc3RlciBicmFuY2ggb2YgY3J5cHRvZGV2LTIuNiwgYnVpbHQsDQo+
PiBib290ZWQsIGFuZCBsb2FkZWQgb3VyIG1vZHVsZS4gQW5kIEkgZG9uJ3Qgc2VlIHRoYXQgZXJy
b3IuIEl0IG11c3QgYmUgbmV3Pw0KPiANCj4gRGlkIHlvdSBoYXZlIENPTkZJR19DUllQVE9fTUFO
QUdFUl9FWFRSQV9URVNUUyBlbmFibGVkPyAgVGhpcyBmYWlsdXJlIHdhcyB3aXRoIGENCj4gdGVz
dCB2ZWN0b3IgdGhhdCB3YXMgZ2VuZXJhdGVkIHJhbmRvbWx5IGJ5IHRoZSBmdXp6IHRlc3RzLCBz
bw0KPiBDT05GSUdfQ1JZUFRPX01BTkFHRVJfRVhUUkFfVEVTVFM9eSBpcyBuZWVkZWQgdG8gcmVw
cm9kdWNlIGl0Lg0KPiANCj4gWW91IHByb2JhYmx5IGp1c3QgbmVlZCB0byB1cGRhdGUgY2NwX2Fl
c19nY21fc2V0YXV0aHNpemUoKSB0byB2YWxpZGF0ZSB0aGUNCj4gYXV0aGVudGljYXRpb24gdGFn
IHNpemUuDQoNCk5vdyBJJ20gY29uZnVzZWQuIEkgZGlkIG5lZWQgdG8gZml4IHRoYXQgZnVuY3Rp
b24sIGFuZCBBRkFJSyB0aGUgdGFnIGZvciANCkdDTSBpcyBhbHdheXMgZ29pbmcgdG8gYmUgMTYg
Ynl0ZXMgKG91ciBBRVNfQkxPQ0tfU0laRSkuDQoNClNvLCBhZnRlciBtYWtpbmcgdGhlIHNtYWxs
IGNoYW5nZSwgdGhlIGFib3ZlIHRlc3QgcGFzc2VzLCBidXQgbm93IEkgDQpwcm9ncmVzcyBhbmQg
Z2V0IHRoaXMgZXJyb3I6DQoNClsgMTY0MC44MjA3ODFdIGFsZzogYWVhZDogZ2NtLWFlcy1jY3Ag
c2V0YXV0aHNpemUgZmFpbGVkIG9uIHRlc3QgdmVjdG9yIA0KInJhbmRvbTogYWxlbj0yOSBwbGVu
PTI5IGF1dGhzaXplPTEyIGtsZW49MzIiOyBleHBlY3RlZF9lcnJvcj0wLCANCmFjdHVhbF9lcnJv
cj0xDQoNCldoaWNoIGlzIHdob2xseSB1bmNsZWFyLiBXaHkgd291bGQgYW4gYXV0aHNpemUgb2Yg
MTIgYmUgb2theSBmb3IgdGhpcyANCnRyYW5zZm9ybWF0aW9uPyBUaGUgR0NNIHRhZyBpcyBhIGZp
eGVkIHNpemUuDQoNCk5vdGhpbmcgaW4gdGhlIEFFQUQgZG9jdW1lbnRhdGlvbiBqdW1wcyBvdXQg
YXQgbWUuIEFzIEkgZG9uJ3QgcHJvZmVzcyB0byANCmJlIGEgY3J5cHRvIGV4cGVydCwgSSdkIGFw
cHJlY2lhdGUgYW55IGd1aWRhbmNlIG9uIHRoaXMgc3VidGxlIGlzc3VlIA0KdGhhdCBpcyBlbHVk
aW5nIG1lLi4uDQoNClRoYW5rcw0KZ3JoDQo=
