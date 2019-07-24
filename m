Return-Path: <SRS0=LUcm=VV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEE8C7618B
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jul 2019 16:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCFF62173B
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jul 2019 16:10:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="soiozqFK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfGXQKa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Jul 2019 12:10:30 -0400
Received: from mail-eopbgr740045.outbound.protection.outlook.com ([40.107.74.45]:62176
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726099AbfGXQK3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jul 2019 12:10:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6Rv3J1ODBr4t0mmZ10GG1BlsAHzxBEzHqiGMItgXc1njXY6LhbNnX7KXhWnlASeN2ExUzyAKA+UmKEAePGqo2AYY5FIsyO4dqjdwdQ0oKFmT/n5IOM8MTKsZyJKyW/OuTcV6d2dz0xtaCja5nDhWHOPYNklIUTo3ToEE7A6xUbuWKDGHKpCMI+naUlrnKivHmhk9grTZ/5PYK0Acqt1G4bLiLeYwPD+KCmgZbzZFKmex5qAYDkO64/UmA2lNzCF2LHD9SvM80QA/uKegw4ZyuMD4rGgWpVS9b/Zs1/mxyg5y6tgeREwGqgeOVzSONFH7dZiyJY9HNt3D8s3br3TxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iyPbbE/lNonk5eelra1+lcc24cVyWX4+yaNelD8QPs=;
 b=lyRL3w2bYFY8XgVqfQkD3Wzsfr6szdfek+3YN49/PVbdDzAITg7YZooWApogfrvTUXF1Gl9rMj9lDRBZQWRUkKYQEfYBH4EH9COuRHF3OXryAff1O5E393gOsCnVozt4W27es3lQJ+UUHy8MTAAUsPC/yq77DOQwgDoLVoGeG8+WHxCHfAXI5Ky9WvxrZjiXkG4gnAaBnYNRgOI7wUm9uuPpzCR8g0xMwyQAVAPjyEFAlmMOp1WikGQ1hqBxV+OHe8PjqX4PC6KLFd0YVXGsl6N++c+xo9fd5oGU26qvNwIa7hlGsh9sMdpD6kTLXX4oi5lDRronV1gHe+Gdl9rucQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iyPbbE/lNonk5eelra1+lcc24cVyWX4+yaNelD8QPs=;
 b=soiozqFKO2cL4ErqOz07foUWsavyWYZt5Fxpb8NNa9Yo68DVrHo0LDieSGFWCCFFWjXh+CnTrGlszvLhTJjMcv2D5BeJWAsRx2m1jbmrR+7Hq9qNCCIp/OI/n1OLAwuQGXM9A4m/0OiqobRiUlCSBQS/7zsZ9YB525XwdQhRQ/8=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2733.namprd20.prod.outlook.com (20.178.253.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Wed, 24 Jul 2019 16:10:24 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Wed, 24 Jul 2019
 16:10:24 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Milan Broz <gmazyland@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>
Subject: RE: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Topic: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbPEhUAgAALMYCAANVxgIAABoCAgAABwICAAAUbgIAAFRTAgAAoQICAAtuUgIAACm4AgAG39ACAAYCLgIAAhUWAgAMXB/A=
Date:   Wed, 24 Jul 2019 16:10:23 +0000
Message-ID: <MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190716221639.GA44406@gmail.com>
 <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com>
 <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
 <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
 <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <b042649c-db98-9710-b063-242bdf520252@gmail.com>
 <20190720065807.GA711@sol.localdomain>
 <0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com>
 <CAKv+Gu9UF+a1UhVU19g1XcLaEqEaAwwkSm3-2wTHEAdD-q4mLQ@mail.gmail.com>
 <MN2PR20MB2973B9C2DDC508A81AF4A207CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
In-Reply-To: <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b346b46-5715-4d53-cfc5-08d710516f3d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2733;
x-ms-traffictypediagnostic: MN2PR20MB2733:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2733488D48AC78D480E9134BCAC60@MN2PR20MB2733.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(366004)(136003)(396003)(376002)(346002)(189003)(199004)(13464003)(966005)(478600001)(71200400001)(476003)(52536014)(486006)(71190400001)(25786009)(5660300002)(3846002)(446003)(15974865002)(6116002)(14454004)(4326008)(229853002)(68736007)(55016002)(33656002)(2906002)(11346002)(6916009)(26005)(186003)(8676002)(6306002)(6246003)(9686003)(7696005)(76176011)(102836004)(66946007)(66556008)(86362001)(7736002)(76116006)(99286004)(81156014)(81166006)(53936002)(54906003)(316002)(66066001)(256004)(6436002)(66446008)(305945005)(74316002)(64756008)(66476007)(6506007)(53546011)(14444005)(8936002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2733;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NbPDMU3tPpzqME6t2I1LOYyLF2XkwLXo28PsinlqNNWat8ARvDVNCBbNIb/UFR3DeapZ6naZgFTVCBCb4oqzay2mD8UR1JGE9aadz/KD/6JWg5I8n3LpHKYg0iSVMegrDogYGE3OkFF+mzFAzAWHs5ewEGr9DASEVI2USfHJ73wverv+bnm6fPIZ504uBh+qtQzdqQAuvbPDKe0DvA1mWWjhbYWPkHBs6ICpAD+gN5188HKv1uch2ZbpsTSjQ3vGfgRiw9pyWPfGOljO+vw6pLCXL9laDU0/lSkd6l+abg/BEMZ2g/Qn8gOH9bLawUvn95wYaFelf/Wu77RkzykVHVc58y5Zb3xbykYz9DsK+KwXFRTIm95wP7ofCP+vqB0j9lXjsmhAfRuOUyLjy86K5yJ4fShbdx6v6/Dx7IxW8N0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b346b46-5715-4d53-cfc5-08d710516f3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 16:10:23.9132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2733
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

QXJkLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFyZCBCaWVzaGV1
dmVsIDxhcmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPg0KPiBTZW50OiBNb25kYXksIEp1bHkgMjIs
IDIwMTkgNjo0MyBQTQ0KPiBUbzogUGFzY2FsIFZhbiBMZWV1d2VuIDxwdmFubGVldXdlbkB2ZXJp
bWF0cml4LmNvbT4NCj4gQ2M6IE1pbGFuIEJyb3ogPGdtYXp5bGFuZEBnbWFpbC5jb20+OyBIZXJi
ZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBkbS1kZXZlbEByZWRoYXQuY29t
OyBsaW51eC0NCj4gY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgSG9yaWEgR2VhbnRhIDxob3JpYS5n
ZWFudGFAbnhwLmNvbT4NCj4gU3ViamVjdDogUmU6IFtkbS1kZXZlbF0geHRzIGZ1enogdGVzdGlu
ZyBhbmQgbGFjayBvZiBjaXBoZXJ0ZXh0IHN0ZWFsaW5nIHN1cHBvcnQNCj4gDQo+IE9uIE1vbiwg
MjIgSnVsIDIwMTkgYXQgMTI6NDQsIFBhc2NhbCBWYW4gTGVldXdlbg0KPiA8cHZhbmxlZXV3ZW5A
dmVyaW1hdHJpeC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+ID4gRnJvbTogQXJkIEJpZXNoZXV2ZWwgPGFyZC5iaWVzaGV1dmVsQGxpbmFyby5v
cmc+DQo+ID4gPiBTZW50OiBTdW5kYXksIEp1bHkgMjEsIDIwMTkgMTE6NTAgQU0NCj4gPiA+IFRv
OiBNaWxhbiBCcm96IDxnbWF6eWxhbmRAZ21haWwuY29tPg0KPiA+ID4gQ2M6IFBhc2NhbCBWYW4g
TGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJpeC5jb20+OyBIZXJiZXJ0IFh1IDxoZXJiZXJ0
QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBkbS1kZXZlbEByZWRoYXQuY29tOyBsaW51eC0NCj4gPiA+
IGNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IEhvcmlhIEdlYW50YSA8aG9yaWEuZ2VhbnRhQG54cC5j
b20+DQo+ID4gPiBTdWJqZWN0OiBSZTogW2RtLWRldmVsXSB4dHMgZnV6eiB0ZXN0aW5nIGFuZCBs
YWNrIG9mIGNpcGhlcnRleHQgc3RlYWxpbmcgc3VwcG9ydA0KPiA+ID4NCj4gPiA+IE9uIFNhdCwg
MjAgSnVsIDIwMTkgYXQgMTA6MzUsIE1pbGFuIEJyb3ogPGdtYXp5bGFuZEBnbWFpbC5jb20+IHdy
b3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBPbiAyMC8wNy8yMDE5IDA4OjU4LCBFcmljIEJpZ2dlcnMg
d3JvdGU6DQo+ID4gPiA+ID4gT24gVGh1LCBKdWwgMTgsIDIwMTkgYXQgMDE6MTk6NDFQTSArMDIw
MCwgTWlsYW4gQnJveiB3cm90ZToNCj4gPiA+ID4gPj4gQWxzbywgSSB3b3VsZCBsaWtlIHRvIGF2
b2lkIGFub3RoZXIgImp1c3QgYmVjYXVzZSBpdCBpcyBuaWNlciIgbW9kdWxlIGRlcGVuZGVuY2Ug
KFhUUy0+WEVYLT5FQ0IpLg0KPiA+ID4gPiA+PiBMYXN0IHRpbWUgKHdoZW4gWFRTIHdhcyByZWlt
cGxlbWVudGVkIHVzaW5nIEVDQikgd2UgaGF2ZSBtYW55IHJlcG9ydHMgd2l0aCBpbml0cmFtZnMN
Cj4gPiA+ID4gPj4gbWlzc2luZyBFQ0IgbW9kdWxlIHByZXZlbnRpbmcgYm9vdCBmcm9tIEFFUy1Y
VFMgZW5jcnlwdGVkIHJvb3QgYWZ0ZXIga2VybmVsIHVwZ3JhZGUuLi4NCj4gPiA+ID4gPj4gSnVz
dCBzYXlpbmcuIChEZXNwaXRlIHRoZSBsYXN0IHRpbWUgaXQgd2FzIGtleXJpbmcgd2hhdCBicm9r
ZSBlbmNyeXB0ZWQgYm9vdCA7LSkNCj4gPiA+ID4gPj4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IENh
bid0IHRoZSAibWlzc2luZyBtb2R1bGVzIGluIGluaXRyYW1mcyIgaXNzdWUgYmUgc29sdmVkIGJ5
IHVzaW5nIGENCj4gPiA+ID4gPiBNT0RVTEVfU09GVERFUCgpPyAgQWN0dWFsbHksIHdoeSBpc24n
dCB0aGF0IGJlaW5nIHVzZWQgZm9yIHh0cyAtPiBlY2IgYWxyZWFkeT8NCj4gPiA+ID4gPg0KPiA+
ID4gPiA+IChUaGVyZSB3YXMgYWxzbyBhIGJ1ZyB3aGVyZSBDT05GSUdfQ1JZUFRPX1hUUyBkaWRu
J3Qgc2VsZWN0IENPTkZJR19DUllQVE9fRUNCLA0KPiA+ID4gPiA+IGJ1dCB0aGF0IHdhcyBzaW1w
bHkgYSBidWcsIHdoaWNoIHdhcyBmaXhlZC4pDQo+ID4gPiA+DQo+ID4gPiA+IFN1cmUsIGFuZCBp
dCBpcyBzb2x2ZWQgbm93LiAoU29tZSBzeXN0ZW1zIHdpdGggYSBoYXJkY29kZWQgbGlzdCBvZiBt
b2R1bGVzDQo+ID4gPiA+IGhhdmUgdG8gYmUgbWFudWFsbHkgdXBkYXRlZCBldGMuLCBidXQgdGhh
dCBpcyBqdXN0IGJhZCBkZXNpZ24pLg0KPiA+ID4gPiBJdCBjYW4gYmUgZG9uZSBwcm9wZXJseSBm
cm9tIHRoZSBiZWdpbm5pbmcuDQo+ID4gPiA+DQo+ID4gPiA+IEkganVzdCB3YW50IHRvIHNheSB0
aGF0IHRoYXQgc3dpdGNoaW5nIHRvIFhFWCBsb29rcyBsaWtlIHdhc3RpbmcgdGltZSB0byBtZQ0K
PiA+ID4gPiBmb3Igbm8gYWRkaXRpb25hbCBiZW5lZml0Lg0KPiA+ID4gPg0KPiA+ID4gPiBGdWxs
eSBpbXBsZW1lbnRpbmcgWFRTIGRvZXMgbWFrZSBtdWNoIG1vcmUgc2Vuc2UgZm9yIG1lLCBldmVu
IHRob3VnaCBpdCBpcyBsb25nLXRlcm0NCj4gPiA+ID4gdGhlIGVmZm9ydCBhbmQgdGhlIG9ubHkg
dXNlciwgZm9yIG5vdywgd291bGQgYmUgdGVzdG1nci4NCj4gPiA+ID4NCj4gPiA+ID4gU28sIHRo
ZXJlIGFyZSBubyB1c2VycyBiZWNhdXNlIGl0IGRvZXMgbm90IHdvcmsuIEl0IG1ha2VzIG5vIHNl
bnNlDQo+ID4gPiA+IHRvIGltcGxlbWVudCBpdCwgYmVjYXVzZSB0aGVyZSBhcmUgbm8gdXNlcnMu
Li4gKHNvcnJ5LCBzb3VuZHMgbGlrZSBjYXRjaCAyMiA6KQ0KPiA+ID4gPg0KPiA+ID4gPiAoTWF5
YmUgc29tZW9uZSBjYW4gdXNlIGl0IGZvciBrZXlzbG90IGVuY3J5cHRpb24gZm9yIGtleXMgbm90
IGFsaWduZWQgdG8NCj4gPiA+ID4gYmxvY2sgc2l6ZSwgZHVubm8uIEFjdHVhbGx5LCBzb21lIGZp
bGVzeXN0ZW0gZW5jcnlwdGlvbiBjb3VsZCBoYXZlIHVzZSBmb3IgaXQuKQ0KPiA+ID4gPg0KPiA+
ID4gPiA+IE9yICJ4dHMiIGFuZCAieGV4IiBjb3VsZCBnbyBpbiB0aGUgc2FtZSBrZXJuZWwgbW9k
dWxlIHh0cy5rbywgd2hpY2ggd291bGQgbWFrZQ0KPiA+ID4gPiA+IHRoaXMgYSBub24taXNzdWUu
DQo+ID4gPiA+DQo+ID4gPiA+IElmIGl0IGlzIG5vdCBhdmFpbGFibGUgZm9yIHVzZXJzLCBJIHJl
YWxseSBzZWUgbm8gcmVhc29uIHRvIGludHJvZHVjZSBYRVggd2hlbg0KPiA+ID4gPiBpdCBpcyBq
dXN0IFhUUyB3aXRoIGZ1bGwgYmxvY2tzLg0KPiA+ID4gPg0KPiA+ID4gPiBJZiBpdCBpcyB2aXNp
YmxlIHRvIHVzZXJzLCBpdCBuZWVkcyBzb21lIHdvcmsgaW4gdXNlcnNwYWNlIC0gWEVYIChhcyBY
VFMpIG5lZWQgdHdvIGtleXMsDQo+ID4gPiA+IHBlb3BsZSBhcmUgYWxyZWFkeSBjb25mdXNlZCBl
bm91Z2ggdGhhdCAyNTZiaXQga2V5IGluIEFFUy1YVFMgbWVhbnMgQUVTLTEyOC4uLg0KPiA+ID4g
PiBTbyB0aGUgZXhhbXBsZXMsIGhpbnRzLCBtYW4gcGFnZXMgbmVlZCB0byBiZSB1cGRhdGVkLCBh
dCBsZWFzdC4NCj4gPiA+ID4NCj4gPiA+DQo+ID4gPiBPSywgY29uc2lkZXIgbWUgcGVyc3VhZGVk
LiBXZSBhcmUgYWxyZWFkeSBleHBvc2luZyB4dHMoLi4uKSB0bw0KPiA+ID4gdXNlcmxhbmQsIGFu
ZCBzaW5jZSB3ZSBhbHJlYWR5IGltcGxlbWVudCBhIHByb3BlciBzdWJzZXQgb2YgdHJ1ZSBYVFMs
DQo+ID4gPiBpdCB3aWxsIGJlIHNpbXBseSBhIG1hdHRlciBvZiBtYWtpbmcgc3VyZSB0aGF0IHRo
ZSBleGlzdGluZyBYVFMNCj4gPiA+IGltcGxlbWVudGF0aW9ucyBkb24ndCByZWdyZXNzIGluIHBl
cmZvcm1hbmNlIG9uIHRoZSBub24tQ1RTIGNvZGUNCj4gPiA+IHBhdGhzLg0KPiA+ID4NCj4gPiA+
IEl0IHdvdWxkIGJlIHVzZWZ1bCwgdGhvdWdoLCB0byBoYXZlIHNvbWUgZ2VuZXJpYyBoZWxwZXIg
ZnVuY3Rpb25zLA0KPiA+ID4gZS5nLiwgbGlrZSB0aGUgb25lIHdlIGhhdmUgZm9yIENCQywgb3Ig
dGhlIG9uZSBJIHJlY2VudGx5IHByb3Bvc2VkIGZvcg0KPiA+ID4gQ1RTLCBzbyB0aGF0IGV4aXN0
aW5nIGltcGxlbWVudGF0aW9ucyAoc3VjaCBhcyB0aGUgYml0IHNsaWNlZCBBRVMpIGNhbg0KPiA+
ID4gZWFzaWx5IGJlIGF1Z21lbnRlZCB3aXRoIGEgQ1RTIGNvZGUgcGF0aCAoYnV0IHBlcmZvcm1h
bmNlIG1heSBub3QgYmUNCj4gPiA+IG9wdGltYWwgaW4gdGhvc2UgY2FzZXMpLiBGb3IgdGhlIEFS
TSBpbXBsZW1lbnRhdGlvbnMgYmFzZWQgb24gQUVTDQo+ID4gPiBpbnN0cnVjdGlvbnMsIGl0IHNo
b3VsZCBiZSByZWFzb25hYmx5IHN0cmFpZ2h0IGZvcndhcmQgdG8gaW1wbGVtZW50IGl0DQo+ID4g
PiBjbG9zZSB0byBvcHRpbWFsbHkgYnkgcmV1c2luZyBzb21lIG9mIHRoZSBjb2RlIEkgYWRkZWQg
Zm9yIENCQy1DVFMNCj4gPiA+IChidXQgSSB3b24ndCBnZXQgYXJvdW5kIHRvIGRvaW5nIHRoYXQg
Zm9yIGEgd2hpbGUpLiBJZiB0aGVyZSBhcmUgYW55DQo+ID4gPiB2b2x1bnRlZXJzIGZvciBsb29r
aW5nIGludG8gdGhlIGdlbmVyaWMgb3IgeDg2L0FFUy1OSSBpbXBsZW1lbnRhdGlvbnMsDQo+ID4g
PiBwbGVhc2UgY29tZSBmb3J3YXJkIDotKSBBbHNvLCBpZiBhbnkgb2YgdGhlIHB1YmxpY2F0aW9u
cyB0aGF0IHdlcmUNCj4gPiA+IHF1b3RlZCBpbiB0aGlzIHRocmVhZCBoYXZlIHN1aXRhYmxlIHRl
c3QgdmVjdG9ycywgdGhhdCB3b3VsZCBiZSBnb29kDQo+ID4gPiB0byBrbm93Lg0KPiA+DQo+ID4g
VW5mb3J0dW5hdGVseSwgdGhlc2UgYWxnb3JpdGhtICYgcHJvdG9jb2wgc3BlY2lmaWNhdGlvbnMg
dGVuZCB0byBiZSB2ZXJ5IGZydWdhbCB3aGVuIGl0DQo+ID4gY29tZXMgdG8gcHJvdmlkaW5nIHRl
c3QgdmVjdG9ycywgYmFyZWx5IHNjcmF0Y2hpbmcgdGhlIHN1cmZhY2Ugb2YgYW55IGNvcm5lciBj
YXNlcywgYnV0DQo+ID4gYXQgbGVhc3QgdGhlcmUgaXMgb25lIG5vbi1tdWx0aXBsZS1vZi0xNiB2
ZWN0b3IgaW4gdGhlIG9yaWdpbmFsIElFRUUgUDE2MTkgLyBEMTYNCj4gPiBzcGVjaWZpY2F0aW9u
IGluIEFubmV4IEIgVGVzdCBWZWN0b3JzIChsYXN0IHZlY3RvciwgIlhUUy1BRVMtMTI4IGFwcGxp
ZWQgZm9yIGEgZGF0YSB1bml0DQo+ID4gdGhhdCBpcyBub3QgYSBtdWx0aXBsZSBvZiAxNiBieXRl
cyIpDQo+ID4NCj4gDQo+IEFjdHVhbGx5LCB0aGF0IHNwZWMgaGFzIGEgY291cGxlIG9mIHRlc3Qg
dmVjdG9ycy4gVW5mb3J0dW5hdGVseSwgdGhleQ0KPiBhcmUgYWxsIHJhdGhlciBzaG9ydCAoZXhj
ZXB0IHRoZSBsYXN0IG9uZSBpbiB0aGUgJ25vIG11bHRpcGxlIG9mIDE2DQo+IGJ5dGVzJyBwYXJh
Z3JhcGgsIGJ1dCB1bmZvcnR1bmF0ZWx5LCB0aGF0IG9uZSBpcyBpbiBmYWN0IGEgbXVsdGlwbGUg
b2YNCj4gMTYgYnl0ZXMpDQo+IA0KPiBJIGFkZGVkIHRoZW0gaGVyZSBbMF0gYWxvbmcgd2l0aCBh
biBhcm02NCBpbXBsZW1lbnRhdGlvbiBmb3IgdGhlIEFFUw0KPiBpbnN0cnVjdGlvbiBiYXNlZCBk
cml2ZXIuIENvdWxkIHlvdSBwbGVhc2UgZG91YmxlIGNoZWNrIHRoYXQgdGhlc2UNCj4gd29yayBh
Z2FpbnN0IHlvdXIgZHJpdmVyPyANCj4NCkkgZ290IFhUUyB3b3JraW5nIHdpdGggdGhlIGluc2lk
ZS1zZWN1cmUgZHJpdmVyIGFuZCB0aGVzZSAoYW5kIGFsbCBvdGhlcikgdmVjdG9ycyBwYXNzIDot
KQ0KDQo+IFRoYXQgd291bGQgZXN0YWJsaXNoIGEgZ3JvdW5kIHRydXRoIGFnYWluc3QNCj4gd2hp
Y2ggd2UgY2FuIGltcGxlbWVudCB0aGUgZ2VuZXJpYyB2ZXJzaW9uIGFzIHdlbGwuDQo+IA0KPiBb
MF0gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYXJkYi9s
aW51eC5naXQvbG9nLz9oPXh0cy1jdHMNCj4gDQo+ID4gQmVzaWRlcyB0aGF0LCBJJ2QgYmUgaGFw
cHkgdG8gZ2VuZXJhdGUgc29tZSB0ZXN0dmVjdG9ycyBmcm9tIG91ciBkZWZhY3RvLXN0YW5kYXJk
DQo+ID4gaW1wbGVtZW50YXRpb24gOy0pDQo+ID4NCj4gDQo+IE9uZSBvciB0d28gbGFyZ2VyIG9u
ZXMgd291bGQgYmUgdXNlZnVsLCB5ZXMuDQo+DQpJJ2xsIHNlZSBpZiBJIGNhbiBleHRyYWN0IHNv
bWUgc3VpdGFibGUgdmVjdG9ycyBmcm9tIG91ciB2ZXJpZmljYXRpb24gc3VpdGUgLi4uDQoNClJl
Z2FyZHMsDQpQYXNjYWwgdmFuIExlZXV3ZW4NClNpbGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Q
cm90b2NvbCBFbmdpbmVzIEAgVmVyaW1hdHJpeA0Kd3d3Lmluc2lkZXNlY3VyZS5jb20NCg==
