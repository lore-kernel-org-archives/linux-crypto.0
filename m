Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5951BC31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 20:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DB142086D
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 20:57:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="u/oH5GAq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfHIU50 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 16:57:26 -0400
Received: from mail-eopbgr800080.outbound.protection.outlook.com ([40.107.80.80]:31376
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725985AbfHIU50 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 16:57:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=THbRLh0MKDjfa13qr9z7zjqwMGVGk30huAjNI6pysZ+CJfJ2HlQstWyjAEdktDCY4m7unVrIzfksev1udukWiXHSbWa64tJWDEv5/ioSTxiPALvxThdIhqPgl2SPKstb2PdpF0T/wgs//3DSll+0VnO+S/ZGxvszYWysbxL94YOIkbPSTQfKW5qVx0o5yFfQaOt1n+9GXjAVZbEb30G5SCSmJxIZWcoukH5vJ87MkPTwEuxz90JRvV9iL8joasf0VToyEHIkggpynkIWeHny3uivIVYUaGpuWWOVmU0F0vzr2sbHis2E/j+6ruAXMbJf6YXyH8x/grCb3Ub+LbofpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PndnbczVvdXmWKopS1Mz0xcr5vlZ2VCr/4tGbPkOpbA=;
 b=FZnwPIv4vlGEtFF57S7B67WRGyO5gfyQghEF5UM8zBUad3GtmIimdf7px6KHdTqsmvDfYZyKAQCCdq2MJgoawM1sEs5hc/CmckyroMMe+FZWhFDAqfnqqpJqKOnQn7NqJXH6LHv+BEn0AsYcyLmhGauch6VIFrAFXRfeeeGeCdCxVc8Rk3wo5fxonOgBRKjqnjI9Xud442/Mo9+aQHejRPK3j24AgUIm6m4GaaY/QvAc7aKNrVdDamvdukAEuKjSrCjj6hZzD5eaetOQX9u1GCrvPqjuAm/pvtk/tB7hlwoUgBTltEOTV8znZ0JcICvynNTYfsIn+m/qIDDV0q0hyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PndnbczVvdXmWKopS1Mz0xcr5vlZ2VCr/4tGbPkOpbA=;
 b=u/oH5GAqNGl/7rW8barxfDwI4RJuOSPUiNEbjEEBiuLOswspdEr3dMQDDz2zdvvsDLL8WN9q1J8fhq2T8MJNfXZL1FfyezJC4bLgVK8/bGoFzS3j6bSmdrlTSJgsxghxyBqWYbBXdZ8berVRp+9perl+jOCUvO7scSeu4dpUrOQ=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3279.namprd20.prod.outlook.com (52.132.175.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Fri, 9 Aug 2019 20:57:21 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 20:57:21 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Horia Geanta <horia.geanta@nxp.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Topic: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbzPYWAgAAwjTA=
Date:   Fri, 9 Aug 2019 20:57:21 +0000
Message-ID: <MN2PR20MB297361CA3C29C236D6D8F6F4CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
 <MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
 <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
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
In-Reply-To: <CAKv+Gu-_WObNm+ySXDWjhqe2YPzajX83MofuF-WKPSdLg5t4Ew@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d918c4b-958e-4b78-7ed6-08d71d0c2c46
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3279;
x-ms-traffictypediagnostic: MN2PR20MB3279:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB32794243B57210F576DC6C33CAD60@MN2PR20MB3279.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:288;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(39830400003)(396003)(346002)(199004)(189003)(13464003)(52314003)(110136005)(54906003)(14444005)(99286004)(256004)(7736002)(15974865002)(305945005)(229853002)(478600001)(4326008)(71190400001)(66066001)(6246003)(3846002)(5660300002)(2906002)(81156014)(33656002)(316002)(8676002)(6116002)(9686003)(71200400001)(8936002)(25786009)(52536014)(476003)(11346002)(53936002)(446003)(81166006)(486006)(7696005)(55016002)(6436002)(86362001)(74316002)(26005)(6506007)(66556008)(66476007)(102836004)(76116006)(186003)(66446008)(64756008)(53546011)(76176011)(66946007)(14454004)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3279;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: g/jHBopESuZUWEpSm8RLH0M5PsWvuv9am7PhcvYGd53mN79GeJTJsUXnpyJp3Ti4YmA57GZ48vTVyzHfpIGn0CNeUy7a8wAcDkq+wvDD41/adC0KabqhfRlDv6x8QcXl1fyiulE5W/8ff+h1YXsY1JrIqg4Kv64N2uMn4kp5gyIauz4FqWKALcnYTITMnFzakZ7ZtP1xoHM7aiBI6zqcEV/7lVYh5ZIPt5/Lr5CcF5IiQxSd08saTX8bcrWDibOUEo6HTLhBEbpfBKH9cvPEOIJuOgdMRvKWQLMZzxpWgKYdBNSWtLsPjQ3HAr09V0iTzZMS7K/QSklbVvLwy0hFqPcdv8YnCrxHtzFNSR8QS4M5cVXYfsZk9PAKmYhAd8kjBJGyUJpCZxgEirAxECFXB50CJVSemMAGqw4d0VwXa6E=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d918c4b-958e-4b78-7ed6-08d71d0c2c46
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 20:57:21.4625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: amSuELv2A5ZtXa7oV6V/Hk6vZtv8ek1jjfW6BxudKTv3ITJTFeYlHyGJxnpVfhupMZvCen+esGcqT6Qi5geZTvJz1Kaaj0Jz2K979iiCOnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3279
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
LmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4NCj4gU2VudDogRnJpZGF5LCBBdWd1c3QgOSwgMjAxOSA3
OjQ5IFBNDQo+IFRvOiBIb3JpYSBHZWFudGEgPGhvcmlhLmdlYW50YUBueHAuY29tPg0KPiBDYzog
SGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1PjsgUGFzY2FsIFZhbiBMZWV1
d2VuDQo+IDxwdmFubGVldXdlbkB2ZXJpbWF0cml4LmNvbT47IE1pbGFuIEJyb3ogPGdtYXp5bGFu
ZEBnbWFpbC5jb20+OyBkbS1kZXZlbEByZWRoYXQuY29tOyBsaW51eC0NCj4gY3J5cHRvQHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW2RtLWRldmVsXSB4dHMgZnV6eiB0ZXN0aW5nIGFu
ZCBsYWNrIG9mIGNpcGhlcnRleHQgc3RlYWxpbmcgc3VwcG9ydA0KPiANCj4gT24gRnJpLCA5IEF1
ZyAyMDE5IGF0IDEwOjQ0LCBIb3JpYSBHZWFudGEgPGhvcmlhLmdlYW50YUBueHAuY29tPiB3cm90
ZToNCj4gPg0KPiA+IE9uIDgvOS8yMDE5IDk6NDUgQU0sIEFyZCBCaWVzaGV1dmVsIHdyb3RlOg0K
PiA+ID4gT24gRnJpLCA5IEF1ZyAyMDE5IGF0IDA1OjQ4LCBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdv
bmRvci5hcGFuYS5vcmcuYXU+IHdyb3RlOg0KPiA+ID4+DQo+ID4gPj4gT24gVGh1LCBBdWcgMDgs
IDIwMTkgYXQgMDY6MDE6NDlQTSArMDAwMCwgSG9yaWEgR2VhbnRhIHdyb3RlOg0KPiA+ID4+Pg0K
PiA+ID4+PiAtLSA+OCAtLQ0KPiA+ID4+Pg0KPiA+ID4+PiBTdWJqZWN0OiBbUEFUQ0hdIGNyeXB0
bzogdGVzdG1nciAtIEFkZCBhZGRpdGlvbmFsIEFFUy1YVFMgdmVjdG9ycyBmb3IgY292ZXJpbmcN
Cj4gPiA+Pj4gIENUUyAocGFydCBJSSkNCj4gPiA+Pg0KPiA+ID4+IFBhdGNod29yayBkb2Vzbid0
IGxpa2UgaXQgd2hlbiB5b3UgZG8gdGhpcyBhbmQgaXQnbGwgZGlzY2FyZA0KPiA+ID4+IHlvdXIg
cGF0Y2guICBUbyBtYWtlIGl0IGludG8gcGF0Y2h3b3JrIHlvdSBuZWVkIHRvIHB1dCB0aGUgbmV3
DQo+ID4gPj4gU3ViamVjdCBpbiB0aGUgZW1haWwgaGVhZGVycy4NCj4gPiA+Pg0KPiA+ID4NCj4g
PiA+IElNTywgcHJldGVuZGluZyB0aGF0IHlvdXIgWFRTIGltcGxlbWVudGF0aW9uIGlzIGNvbXBs
aWFudCBieSBvbmx5DQo+ID4gSSd2ZSBuZXZlciBzYWlkIHRoYXQuDQo+ID4gU29tZSBwYXJ0cyBh
cmUgY29tcGxpYW50LCBzb21lIGFyZSBub3QuDQo+ID4NCj4gPiA+IHByb3ZpZGluZyB0ZXN0IHZl
Y3RvcnMgd2l0aCB0aGUgbGFzdCA4IGJ5dGVzIG9mIElWIGNsZWFyZWQgaXMgbm90IHRoZQ0KPiA+
ID4gcmlnaHQgZml4IGZvciB0aGlzIGlzc3VlLiBJZiB5b3Ugd2FudCB0byBiZSBjb21wbGlhbnQs
IHlvdSB3aWxsIG5lZWQNCj4gPiBJdCdzIG5vdCBhIGZpeC4NCj4gPiBJdCdzIGFkZGluZyB0ZXN0
IHZlY3RvcnMgd2hpY2ggYXJlIG5vdCBwcm92aWRlZCBpbiB0aGUgUDE2MTkgc3RhbmRhcmQsDQo+
ID4gd2hlcmUgImRhdGEgdW5pdCBzZXF1ZW5jZSBudW1iZXIiIGlzIGF0IG1vc3QgNUIuDQo+ID4N
Cj4gDQo+IEluZGVlZC4gQnV0IEkgd291bGQgcHJlZmVyIG5vdCB0byBsaW1pdCBvdXJzZWx2ZXMg
dG8gNSBieXRlcyBvZiBzZWN0b3INCj4gbnVtYmVycyBpbiB0aGUgdGVzdCB2ZWN0b3JzLiBIb3dl
dmVyLCB3ZSBzaG91bGQgb2J2aW91c2x5IG5vdCBhZGQgdGVzdA0KPiB2ZWN0b3JzIHRoYXQgYXJl
IGtub3duIHRvIGNhdXNlIGJyZWFrYWdlcyBvbiBoYXJkd2FyZSB0aGF0IHdvcmtzIGZpbmUNCj4g
aW4gcHJhY3RpY2UuDQo+IA0KV2VsbCwgb2J2aW91c2x5LCB0aGUgZnVsbCAxNiBieXRlIHNlY3Rv
ciBudW1iZXIgdmVjdG9ycyBmYWlsIG9uIGV4aXN0aW5nDQpDQUFNIGhhcmR3YXJlLCB3aGljaCBJ
IGRvIGFzc3VtZSB0byB3b3JrIGZpbmUgaW4gcHJhY3RpY2UuIEFuZCB5b3Uga25vdw0KSSdtIG5v
dCBpbiBmYXZvciBvZiBidWlsZGluZyBhbGwga2luZHMgb2Ygd29ya2Fyb3VuZHMgaW50byB0aGUg
ZHJpdmVycy4NCg0KRmFjdCBpcywgd2Uga25vdyB0aGVyZSBhcmUgbm8gY3VycmVudCB1c2VycyB0
aGF0IG5lZWQgbW9yZSB0aGFuIDY0IGJpdHMNCm9mIElWLiBGYWN0IGlzIGFsc28gdGhhdCBoYXZp
bmcgNjQgYml0cyBvZiBJViBpbiB0aGUgdmVjdG9ycyBpcyBhbHJlYWR5DQphbiBpbXByb3ZlbWVu
dCBvdmVyIHRoZSA0MCBiaXRzIGluIHRoZSBvcmlnaW5hbCB2ZWN0b3JzLiBBbmQgdW5saWtlIENU
UywgDQpJIGFtIG5vdCBhd2FyZSBvZiBhbnkgcmVhbCB1c2UgY2FzZSBmb3IgbW9yZSB0aGFuIDY0
IGJpdHMuDQpGaW5hbGx5LCBhbm90aGVyIGZhY3QgaXMgdGhhdCBsaW1pdGluZyB0aGUgKnZlY3Rv
cnMqIHRvIDY0IGJpdHMgb2YgSVYNCmRvZXMgbm90IHByb2hpYml0IGFueW9uZSBmcm9tICp1c2lu
ZyogYSBmdWxsIDEyOCBiaXQgSVYgb24gYW4gDQppbXBsZW1lbnRhdGlvbiB0aGF0ICpkb2VzKiBz
dXBwb3J0IHRoaXMuIEkgd291bGQgdGhpbmsgbW9zdCB1c2VycyBvZiANClhUUywgbGlrZSBkbWNy
eXB0LCB3b3VsZCBhbGxvdyB5b3UgdG8gc3BlY2lmeSB0aGUgY3JhX2RyaXZlcm5hbWUNCmV4cGxp
Y3RseSBhbnl3YXksIHNvIGp1c3QgZG9uJ3Qgc2VsZWN0IGxlZ2FjeSBDQUFNIGlmIHlvdSBuZWVk
IHRoYXQuDQooaGVjaywgaWYgaXQgd291bGQgYmUgcmVhZGluZyBhbmQgd3JpdGluZyBpdHMgb3du
IGRhdGEsIGFuZCBub3QgbmVlZA0KY29tcGF0aWJpbGl0eSB3aXRoIG90aGVyIGltcGxlbWVudGF0
aW9ucywgaXQgd291bGRuJ3QgZXZlbiBtYXR0ZXIpDQoNClNvIHllcywgdGhlIHNwZWNzIGFyZSBx
dWl0ZSBjbGVhciBvbiB0aGUgc2VjdG9yIG51bWJlciBiZWluZyBhIGZ1bGwNCjEyOCBiaXRzLiBC
dXQgdGhhdCBkb2Vzbid0IHByZXZlbnQgdXMgZnJvbSBzcGVjaWZ5aW5nIHRoYXQgdGhlIA0KY3J5
cHRvIEFQSSBpbXBsZW1lbnRhdGlvbiBjdXJyZW50bHkgb25seSBzdXBwb3J0cyA2NCBiaXRzLCB3
aXRoIHRoZQ0KcmVtYWluaW5nIGJpdHMgYmVpbmcgZm9yY2VkIHRvIDAuIFdlIGNhbiBhbHdheXMg
cmV2aXNpdCB0aGF0IHdoZW4NCmFuIGFjdHVhbCB1c2UgY2FzZSBmb3IgbW9yZSB0aGFuIDY0IGJp
dHMgYXJpc2VzIC4uLg0KDQo+ID4gPiB0byBwcm92aWRlIGEgcy93IGZhbGxiYWNrIGZvciB0aGVz
ZSBjYXNlcy4NCj4gPiA+DQo+ID4gWWVzLCB0aGUgcGxhbiBpcyB0bzoNCj4gPg0KPiA+IC1hZGQg
MTZCIElWIHN1cHBvcnQgZm9yIGNhYW0gdmVyc2lvbnMgc3VwcG9ydGluZyBpdCAtIGNhYW0gRXJh
IDkrLA0KPiA+IGN1cnJlbnRseSBkZXBsb3llZCBpbiBseDIxNjBhIGFuZCBsczEwOGENCj4gPg0K
PiA+IC1yZW1vdmUgY3VycmVudCA4QiBJViBzdXBwb3J0IGFuZCBhZGQgcy93IGZhbGxiYWNrIGZv
ciBhZmZlY3RlZCBjYWFtIHZlcnNpb25zDQo+ID4gSSdkIGFzc3VtZSB0aGlzIGNvdWxkIGJlIGRv
bmUgZHluYW1pY2FsbHksIGkuZS4gZGVwZW5kaW5nIG9uIElWIHByb3ZpZGVkDQo+ID4gaW4gdGhl
IGNyeXB0byByZXF1ZXN0IHRvIHVzZSBlaXRoZXIgdGhlIGNhYW0gZW5naW5lIG9yIHMvdyBmYWxs
YmFjay4NCj4gPg0KPiANCj4gWWVzLiBJZiB0aGUgSVYgcmVjZWl2ZWQgZnJvbSB0aGUgY2FsbGVy
IGhhcyBieXRlcyA4Li4xNSBjbGVhcmVkLCB5b3UNCj4gdXNlIHRoZSBsaW1pdGVkIFhUUyBoL3cg
aW1wbGVtZW50YXRpb24sIG90aGVyd2lzZSB5b3UgZmFsbCBiYWNrIHRvDQo+IHh0cyhlY2ItYWVz
LWNhYW0uLikuDQoNClJlZ2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24gSVAgQXJj
aGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAgVmVyaW1hdHJpeA0Kd3d3Lmluc2lkZXNl
Y3VyZS5jb20NCg0K
