Return-Path: <SRS0=+H67=WH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E5EC0650F
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 21:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 197D52084D
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 21:29:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="ktEYLvag"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfHKV3o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Aug 2019 17:29:44 -0400
Received: from mail-eopbgr800070.outbound.protection.outlook.com ([40.107.80.70]:8747
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725847AbfHKV3n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Aug 2019 17:29:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZ1ezL6E7KliUHrFVzxoplx/B81S+w75El47P6BfeXw1e29Z7rKDNtg4MrG+qjW2fGPMCIkdHjJP4RqV2IPvfun4ety3+EZ0hyD0w10DySJpBJp2AQGEdoTYgq09eJmuFe475a7aid3BsyRHZwZrCsshWRsLm+wMa9F5ms9CKx/u4z/fUyqSPJsyvyBoHk7QfjzuzQdpJehPgNrFt7HF21jXwaoPP6e66IDR/NoFUjEG8jhZX9sPvtHymMl6MxvlKKMbuke3rmmPuBKnPz5Uf5ASIyNZmf/A1Ga/S59it/4WBdG3wOLAWIRqIAvzsGIm6ApppkSe1ub9BC7Vx5yvEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VyyUribb+MSdo1ou9AtTNShY3qHVzEdzYcy/H9bJgKQ=;
 b=PdSxmnjFLs88PUikQdcG3+HRTusMNaPuFXZs5nlkILmCk4BTPdIDmfXgvCfKKD8Gd/8YwrOuPrungmpTaoxgOYLMaYohHRUKmaO4mS5FlT4UzDpOn51ZxJ8VTkQUGMZhPfMsVmpC0fe5k7XEEfxCTm0SMGIW6xNKNFtQeAsQFkYQ05aFFNaH5mkEUFRWcCfawJM4nLZrzEKkxzeJTyppfA4ZFHVyGpiFz23Ps58KeV+KDnzstXwol1XWLbxk5OKJEM8sY1aNezMFYSUWUq9yfcczVq5YvP6oZ04wqubwUfXmUQPktcLQBkLit9ILsUo/xJobja25NmmljYgbjXiWcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VyyUribb+MSdo1ou9AtTNShY3qHVzEdzYcy/H9bJgKQ=;
 b=ktEYLvagFGUKpeJJHZ3J9T05B0OKekz4tDXfkhsJNnZFu8bZ+KBXk3t7ipCCsUxt0NUbsczXKuRuG5roUFMkA/+06W14ldAG5c6ZPgDVNW/G8SLVg9DCI6Ze5Xg5LZB0eC/fMctMqmaHX2zg7uiR3D1rw2P18uXwTstPQ0iAju8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2414.namprd20.prod.outlook.com (20.179.147.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Sun, 11 Aug 2019 21:29:38 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.022; Sun, 11 Aug 2019
 21:29:38 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Milan Broz <gmazyland@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Topic: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbzPYWAgAAwjTCAAIUtAIACADgAgACpimA=
Date:   Sun, 11 Aug 2019 21:29:38 +0000
Message-ID: <MN2PR20MB2973D499FDBC5652CC3FEE6BCAD00@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
 <CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
 <MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20f4832e-e3af-e3c2-d946-13bf8c367a60@nxp.com>
 <VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <MN2PR20MB2973127E4C159A8F5CFDD0C9CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <VI1PR0402MB3485689B4B65C879BC1D137398D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190809024821.GA7186@gondor.apana.org.au>
 <CAKv+Gu9hk=PGpsAWWOU61VrA3mVQd10LudA1qg0LbiX7DG9RjA@mail.gmail.com>
 <VI1PR0402MB3485F94AECC495F133F6B3D798D60@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu-_WObNm+ySXDWjhqe2YPzajX83MofuF-WKPSdLg5t4Ew@mail.gmail.com>
 <MN2PR20MB297361CA3C29C236D6D8F6F4CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-xWxZ58tzyYoH_jDKfJoM+KzOWWpzCeHEmOXQ39Bv15g@mail.gmail.com>
 <d6d0b155-476b-d495-3418-4b171003cdd7@gmail.com>
In-Reply-To: <d6d0b155-476b-d495-3418-4b171003cdd7@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f70f72c-ced9-4972-9312-08d71ea3036f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2414;
x-ms-traffictypediagnostic: MN2PR20MB2414:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB241414FFB30A76998E58C38DCAD00@MN2PR20MB2414.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0126A32F74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(346002)(39840400004)(366004)(13464003)(189003)(199004)(256004)(476003)(66066001)(74316002)(7736002)(6116002)(2906002)(305945005)(25786009)(186003)(446003)(14444005)(15974865002)(53936002)(6246003)(3846002)(229853002)(76116006)(71200400001)(71190400001)(52536014)(66946007)(66556008)(64756008)(66446008)(66476007)(6436002)(478600001)(8676002)(14454004)(33656002)(5660300002)(102836004)(55016002)(8936002)(99286004)(76176011)(26005)(316002)(81166006)(11346002)(486006)(81156014)(86362001)(54906003)(110136005)(9686003)(53546011)(6506007)(4326008)(7696005)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2414;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ft7+OE4c2LS1i1FTTX4sL4rI6QWwbEF+DYLqjE9TReQgAhm4+3FsJ7V0sk5PUQk57qcmLCmAxkS6G9CjG5mSuADLkWAfTHhPsWzGbdj5UEpLGtlziNZYHgf55jU2ZsLjYStZrULvfdsMsQzO3aqGdo0zB5wlNxIZ5xd5psKuvP2R2jY0t9sOAK9O7XaSnlVgmadsxOOvcAfXC03rmgB8z5nSSFHptoR6J+AHNcjtE6r+a16eX/zYJJkEtemcKKpKuM/gP1kiEVYnd/YOgjUkRGfjNzUQNM7L1ups0CbAJRVdxQXto8MmEis/aYbVpLNsz09pOOsqd1F93S5qCXbX7JR8caZN6kbwOuNfLBDaLQHaULOIoF3NpN5b6TEH8IjzxugwgbUhAblvFLksunh3FGsH4nySngRP7O0aVo9ttEY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f70f72c-ced9-4972-9312-08d71ea3036f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2019 21:29:38.0591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BGcbzZnOKm7BynYl1JasLPS0c1A/6prVS94wJi8O2doL8uDZs5DvS24f1zSDGQjIcLGzUvblH17FZfRoOv6OnlHDO4GFSqNRaqo95U2UxMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2414
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaWxhbiBCcm96IDxnbWF6eWxh
bmRAZ21haWwuY29tPg0KPiBTZW50OiBTdW5kYXksIEF1Z3VzdCAxMSwgMjAxOSAxOjEzIFBNDQo+
IFRvOiBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJvLm9yZz47IFBhc2NhbCBW
YW4gTGVldXdlbg0KPiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJpeC5jb20+DQo+IENjOiBIb3JpYSBH
ZWFudGEgPGhvcmlhLmdlYW50YUBueHAuY29tPjsgSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3Iu
YXBhbmEub3JnLmF1PjsgZG0tDQo+IGRldmVsQHJlZGhhdC5jb207IGxpbnV4LWNyeXB0b0B2Z2Vy
Lmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtkbS1kZXZlbF0geHRzIGZ1enogdGVzdGluZyBh
bmQgbGFjayBvZiBjaXBoZXJ0ZXh0IHN0ZWFsaW5nIHN1cHBvcnQNCj4gDQo+IE9uIDEwLzA4LzIw
MTkgMDY6MzksIEFyZCBCaWVzaGV1dmVsIHdyb3RlOg0KPiA+IFRydW5jYXRlZCBJVnMgYXJlIGEg
aHVnZSBpc3N1ZSwgc2luY2Ugd2UgYWxyZWFkeSBleHBvc2UgdGhlIGNvcnJlY3QNCj4gPiBBUEkg
dmlhIEFGX0FMRyAod2l0aG91dCBhbnkgcmVzdHJpY3Rpb25zIG9uIGhvdyBtYW55IG9mIHRoZSBJ
ViBiaXRzDQo+ID4gYXJlIHBvcHVsYXRlZCksIGFuZCBhcHBhcmVudGx5LCBpZiB5b3VyIEFGX0FM
RyByZXF1ZXN0IGZvciB4dHMoYWVzKQ0KPiA+IGhhcHBlbnMgdG8gYmUgZnVsZmlsbGVkIGJ5IHRo
ZSBDQUFNIGRyaXZlciBhbmQgeW91ciBpbXBsZW1lbnRhdGlvbg0KPiA+IHVzZXMgbW9yZSB0aGFu
IDY0IGJpdHMgZm9yIHRoZSBJViwgdGhlIHRvcCBiaXRzIGdldCB0cnVuY2F0ZWQgc2lsZW50bHkN
Cj4gPiBhbmQgeW91ciBkYXRhIG1pZ2h0IGdldCBlYXRlbi4NCj4gDQo+IEFjdHVhbGx5LCBJIHRo
aW5rIHdlIGhhdmUgYWxyZWFkeSBzZXJpb3VzIHByb2JsZW0gd2l0aCBpbiBpbiBrZXJuZWwgKG5v
IEFGX0FMRyBuZWVkZWQpLg0KPiANCj4gSSBkbyBub3QgaGF2ZSB0aGUgaGFyZHdhcmUsIGJ1dCBw
bGVhc2UgY291bGQgeW91IGNoZWNrIHRoYXQgZG0tY3J5cHQgYmlnLWVuZGlhbiBJVg0KPiAocGxh
aW42NGJlKSBwcm9kdWNlcyB0aGUgc2FtZSBvdXRwdXQgb24gQ0FBTT8NCj4gDQo+IEl0IGlzIDY0
Yml0IElWLCBidXQgYmlnLWVuZGlhbiBhbmQgd2UgdXNlIHNpemUgb2YgY2lwaGVyIGJsb2NrICgx
NmJ5dGVzKSBoZXJlLA0KPiBzbyB0aGUgZmlyc3QgOCBieXRlcyBhcmUgemVybyBpbiB0aGlzIGNh
c2UuDQo+IA0KPiBJIHdvdWxkIGV4cGVjdCBkYXRhIGNvcnJ1cHRpb24gaW4gY29tcGFyaXNvbiB0
byBnZW5lcmljIGltcGxlbWVudGF0aW9uLA0KPiBpZiBpdCBzdXBwb3J0cyBvbmx5IHRoZSBmaXJz
dCA2NGJpdC4uLg0KPiANCj4gVHJ5IHRoaXM6DQo+IA0KPiAjIGNyZWF0ZSBzbWFsbCBudWxsIGRl
dmljZSBvZiA4IHNlY3RvcnMsICB3ZSB1c2UgemVyb2VzIGFzIGZpeGVkIGNpcGhlcnRleHQNCj4g
ZG1zZXR1cCBjcmVhdGUgemVybyAtLXRhYmxlICIwIDggemVybyINCj4gDQo+ICMgY3JlYXRlIGNy
eXB0IGRldmljZSBvbiB0b3Agb2YgaXQgKHdpdGggc29tZSBrZXkpLCB1c2luZyBwbGFpbjY0YmUg
SVYNCj4gZG1zZXR1cCBjcmVhdGUgY3J5cHQgLS10YWJsZSAiMCA4IGNyeXB0IGFlcy14dHMtcGxh
aW42NGJlDQo+IGU4Y2ZhM2RiZmUzNzNiNTM2YmU0M2M1NjM3Mzg3Nzg2YzAxYmUwMGJhNWY3MzBh
YWNiMDM5ZTg2ZjNlYjcyZjMgMCAvZGV2L21hcHBlci96ZXJvIDAiDQo+IA0KPiAjIGFuZCBjb21w
YXJlIGl0IHdpdGggYW5kIHdpdGhvdXQgeW91ciBkcml2ZXIsIHRoaXMgaXMgd2hhdCBJIGdldCBo
ZXJlOg0KPiAjIHNoYTI1NnN1bSAvZGV2L21hcHBlci9jcnlwdA0KPiA1MzJmNzExOThkMGQ4NGQ4
MjNiOGU0MTA3MzhjNmY0M2JjM2UxNDlkODQ0ZGQ2ZDM3ZmE1YjM2ZDE1MDUwMWUxICAvZGV2L21h
cHBlci9jcnlwdA0KPiAjIGRtc2V0dXAgcmVtb3ZlIGNyeXB0DQo+IA0KPiBZb3UgY2FuIHRyeSBs
aXR0bGUtZW5kaWFuIHZlcnNpb24gKHBsYWluNjQpLCB0aGlzIHNob3VsZCBhbHdheXMgd29yayBl
dmVuIHdpdGggQ0FBTQ0KPiBkbXNldHVwIGNyZWF0ZSBjcnlwdCAtLXRhYmxlICIwIDggY3J5cHQg
YWVzLXh0cy1wbGFpbjY0DQo+IGU4Y2ZhM2RiZmUzNzNiNTM2YmU0M2M1NjM3Mzg3Nzg2YzAxYmUw
MGJhNWY3MzBhYWNiMDM5ZTg2ZjNlYjcyZjMgMCAvZGV2L21hcHBlci96ZXJvIDAiDQo+IA0KPiAj
IHNoYTI1NnN1bSAvZGV2L21hcHBlci9jcnlwdA0KPiBmMTdhYmQyN2RlZGVlNGU1Mzk3NThlYWJk
YjZjMTVmYTYxOTQ2NGI1MDljZjU1ZjE2NDMzZTZhMjVkYTQyODU3ICAvZGV2L21hcHBlci9jcnlw
dA0KPiAjIGRtc2V0dXAgcmVtb3ZlIGNyeXB0DQo+IA0KPiAjIGRtc2V0dXAgcmVtb3ZlIHplcm8N
Cj4gDQo+IA0KPiBJZiB5b3UgZ2V0IGRpZmZlcmVudCBwbGFpbnRleHQgaW4gdGhlIGZpcnN0IGNh
c2UsIHlvdXIgZHJpdmVyIGlzIGFjdHVhbGx5IGNyZWF0aW5nDQo+IGRhdGEgY29ycnVwdGlvbiBp
biB0aGlzIGNvbmZpZ3VyYXRpb24gYW5kIGl0IHNob3VsZCBiZSBmaXhlZCENCj4gKE9ubHkgdGhl
IGZpcnN0IHNlY3RvciBtdXN0IGJlIHRoZSBzYW1lLCBiZWNhdXNlIGl0IGhhcyBJViA9PSAwLikN
Cj4gDQpJdCB3aWxsIHZlcnkgbGlrZWx5IGZhaWwgd2l0aCB0aGF0IENBQU0gaC93LCBidXQgdGhh
dCBvbmx5IHByb3ZlcyB0aGF0IHlvdQ0Kc2hvdWxkIG5vdCB1c2UgcGxhaW42NGJlIElWJ3MgdG9n
ZXRoZXIgd2l0aCBDQUFNIGgvdy4gV2hpY2ggc2hvdWxkIGJlDQplbnRpcmVseSBhdm9pZGFibGUg
aW4gcmVhbCBsaWZlIHVubGVzcyB5b3UgaGF2ZSBzb21lIHVubGlrZWx5IHJlcXVpcmVtZW50DQp0
byBtb3ZlIHBoeXNpY2FsIGVuY3J5cHRlZCBkaWtzIGZyb20gb25lIHN5c3RlbSAod2l0aG91dCBD
QUFNIGgvdyBhbmQgbmVlZGluZw0KdGhlc2UgcGxhaW42NGJlIElWJ3MgZm9yIHNvbWUgcmVhc29u
KSB0byBhbm90aGVyIHN5c3RlbSAod2l0aCBDQUFNIGgvdykgYW5kIGJlIA0KYWJsZSB0byBkZWNy
eXB0IHRoZW0gdGhlcmUuDQoNCkZvcm1hbGx5LCB0aGVzZSBwbGFpbjY0YmUgSVYncyBhcmUgYWN0
dWFsbHkgV1JPTkcsIHNpbmNlIHRoZSBYVFMgc3BlY2lmaWNhdGlvbiBpcw0KdmVyeSBjbGVhciBv
biB0aGUgYnl0ZSBvcmRlciBvZiB0aGUgc2VjdG9yIG51bWJlciAoImxpdHRsZSBlbmRpYW4gYnl0
ZSBhcnJheSIpLg0KDQoNCj4gTWlsYW4NCj4gDQo+IHAucy4NCj4gSWYgeW91IGFzayB3aHkgd2Ug
aGF2ZSB0aGlzIElWLCBpdCB3YXMgYWRkZWQgcGVyIHJlcXVlc3QgdG8gYWxsb3cgbWFwIHNvbWUg
Y2hpcHNldC1iYXNlZA0KPiBlbmNyeXB0ZWQgZHJpdmVzIGRpcmVjdGx5LiBJIGd1ZXNzIGl0IGlz
IHVzZWQgZm9yIHNvbWUgZGF0YSBmb3JlbnNpYyB0aGluZ3MuDQo+DQpTb3VuZHMgbGlrZSBzb21l
b25lIGdvdCB0aGUgZW5kaWFubmVzcyB3cm9uZyA7LSkgDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFu
IExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAg
VmVyaW1hdHJpeA0Kd3d3Lmluc2lkZXNlY3VyZS5jb20NCg==
