Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA8CC7618B
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 07:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 344282081B
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 07:49:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="fYiuilfM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388262AbfGYHtj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 03:49:39 -0400
Received: from mail-eopbgr730058.outbound.protection.outlook.com ([40.107.73.58]:63772
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387988AbfGYHti (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 03:49:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dpj694u2AMk8GEYeAKYilBzFmTzfz0TLT+sf3t+TZOcglLKggHa0oS9AANNJPcJmv8VB6xZJC9CtI6bJyhJykUeS0oD3+1dZxY5eB2BLJoxhR7lbn08oITSxK+3QQYszA2i9BhY7n3APRuUGL7zgKNE9KOCQzgqaNmKAeWPZ04IHYwZwSRp8MnPdVfBXEHJGzyK/vfFeFe2nBFJlYK+661YHVXBnvbD/OlWcoux52UgwPLjqFeBl4um25aLPrsRtYLNGx8i9caXNBeMDL0WvkNSSzXykYAnKe+ZhPS+ZVWByajSot2oSxt7Z9eHsfmy/P40Y2PKO6DrO6uaBgzfzew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Amk0B1Q1fZv+NS+JIqPyqgc3OmRMNjd/n3u3G/oVUjI=;
 b=dvdAJXqEX8DI+k1jfPdnr7/n7i8DlWzjcSI1l/xvfILLi5ErvK7qpGqjARxRc4CinJmCpFV9hmaHiV8Cvp7ImDRec9DQVi8aW5M3PIcFHPqrNKpH7/JqXvyULdvJBCoHRwTUrU3oE/YZLofSxDOQOwt6rRpdrL2daYmepXKtCxxqON1/QtMMmeoL0sHs87e0+Y4zQ2w7G5C+bhehHYn9FhhRmDK3VCgjldwb0qbQz56IvcmyJpPKo1yOUoLcIDmZfqyKeH/lzbK+nu7sWYSSm2mOm0m4i9VeNQjoxS2DrqTGZBn+sIG+jWBv3CRC1oA8mqvESvpSGHoVpl8oE1qJ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Amk0B1Q1fZv+NS+JIqPyqgc3OmRMNjd/n3u3G/oVUjI=;
 b=fYiuilfM4Mw0hpf9Ol1Uc7XV5IBt3W62RF8koYDaObF6ZMREw1B7cZxjK9urAW9PhuU0enpQuD2hQBGyBHfW+Y7vGiF0Cef3EWUrL260nBANu7p8Edn7vmZhkIIx2lEKDi4Ksxxww2RJkU7ukZ6N6JJMw1lEogf0TalSMs+APFc=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2335.namprd20.prod.outlook.com (20.179.148.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Thu, 25 Jul 2019 07:49:34 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Thu, 25 Jul 2019
 07:49:34 +0000
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
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbPEhUAgAALMYCAANVxgIAABoCAgAABwICAAAUbgIAAFRTAgAAoQICAAtuUgIAACm4AgAG39ACAAYCLgIAAhUWAgAMXB/CAAPJ1AIAAFx2g
Date:   Thu, 25 Jul 2019 07:49:34 +0000
Message-ID: <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
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
 <MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
In-Reply-To: <CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9fdb71e-3063-4b33-5ec1-08d710d4a2d7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2335;
x-ms-traffictypediagnostic: MN2PR20MB2335:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB233587DCD7457E88510781CFCAC10@MN2PR20MB2335.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(39850400004)(396003)(136003)(189003)(199004)(13464003)(51914003)(74316002)(6246003)(66946007)(76116006)(66476007)(66556008)(64756008)(316002)(86362001)(53936002)(2906002)(66446008)(6916009)(71190400001)(71200400001)(25786009)(4326008)(81156014)(81166006)(8676002)(7696005)(33656002)(53546011)(6506007)(6436002)(76176011)(68736007)(99286004)(54906003)(8936002)(3846002)(6116002)(229853002)(15974865002)(102836004)(14444005)(305945005)(52536014)(66066001)(966005)(478600001)(5660300002)(256004)(7736002)(26005)(446003)(186003)(476003)(11346002)(6306002)(486006)(55016002)(14454004)(9686003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2335;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vVb7wqE1ikYCCK8S43uSxEMuffJngOPmC9b2HxVasszH9vd61DhbHcruzOQeZPbdHoCPwNxfBijeTczx+iCARJRJ4L7KP5n5iDX9orlKPko925hrhi6GEN6OzJjbAnW1xym4vmK/FlFdM8p5aXbxPuTnJAxyNr1W72tXltR2fFamcG5HKsAta5gkJ5btVg0ZFbC4xp/H1guefJWePE5Wvrkk/1DO4ceIx94wUPqkaAfhPZbtaYzTnN/W7IqML9BchyT373Ov//3SfGrQaGi5qtGDwu+PeurKn2afd7aiGv0oLGdyZhQlPjDrlEu0XUUgN6MfnlPsff+80UFHyZ5oxupCEyYrLjxkDV8HMeba1YAxCn7u3YtSBuR3E3RNCWOv7l+lAm6OExgsRsosluH7DOxwAHVYsFaN2tbBegrPdgc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9fdb71e-3063-4b33-5ec1-08d710d4a2d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 07:49:34.3651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2335
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFyZCBCaWVzaGV1dmVsIDxh
cmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPg0KPiBTZW50OiBUaHVyc2RheSwgSnVseSAyNSwgMjAx
OSA4OjIyIEFNDQo+IFRvOiBQYXNjYWwgVmFuIExlZXV3ZW4gPHB2YW5sZWV1d2VuQHZlcmltYXRy
aXguY29tPg0KPiBDYzogTWlsYW4gQnJveiA8Z21henlsYW5kQGdtYWlsLmNvbT47IEhlcmJlcnQg
WHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IGRtLWRldmVsQHJlZGhhdC5jb207IGxp
bnV4LQ0KPiBjcnlwdG9Admdlci5rZXJuZWwub3JnOyBIb3JpYSBHZWFudGEgPGhvcmlhLmdlYW50
YUBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW2RtLWRldmVsXSB4dHMgZnV6eiB0ZXN0aW5nIGFu
ZCBsYWNrIG9mIGNpcGhlcnRleHQgc3RlYWxpbmcgc3VwcG9ydA0KPiANCj4gPiA+DQo+ID4gPiBB
Y3R1YWxseSwgdGhhdCBzcGVjIGhhcyBhIGNvdXBsZSBvZiB0ZXN0IHZlY3RvcnMuIFVuZm9ydHVu
YXRlbHksIHRoZXkNCj4gPiA+IGFyZSBhbGwgcmF0aGVyIHNob3J0IChleGNlcHQgdGhlIGxhc3Qg
b25lIGluIHRoZSAnbm8gbXVsdGlwbGUgb2YgMTYNCj4gPiA+IGJ5dGVzJyBwYXJhZ3JhcGgsIGJ1
dCB1bmZvcnR1bmF0ZWx5LCB0aGF0IG9uZSBpcyBpbiBmYWN0IGEgbXVsdGlwbGUgb2YNCj4gPiA+
IDE2IGJ5dGVzKQ0KPiA+ID4NCj4gPiA+IEkgYWRkZWQgdGhlbSBoZXJlIFswXSBhbG9uZyB3aXRo
IGFuIGFybTY0IGltcGxlbWVudGF0aW9uIGZvciB0aGUgQUVTDQo+ID4gPiBpbnN0cnVjdGlvbiBi
YXNlZCBkcml2ZXIuIENvdWxkIHlvdSBwbGVhc2UgZG91YmxlIGNoZWNrIHRoYXQgdGhlc2UNCj4g
PiA+IHdvcmsgYWdhaW5zdCB5b3VyIGRyaXZlcj8NCj4gPiA+DQo+ID4gSSBnb3QgWFRTIHdvcmtp
bmcgd2l0aCB0aGUgaW5zaWRlLXNlY3VyZSBkcml2ZXIgYW5kIHRoZXNlIChhbmQgYWxsIG90aGVy
KSB2ZWN0b3JzIHBhc3MgOi0pDQo+ID4NCj4gDQo+IEV4Y2VsbGVudCwgdGhhbmtzIGZvciB0aGUg
cmVwb3J0LiBNYXkgSSBhZGQgeW91ciBUZXN0ZWQtYnkgd2hlbiBJIHBvc3QNCj4gdGhlIHBhdGNo
PyAoanVzdCB0aGUgb25lIHRoYXQgYWRkcyB0aGUgdGVzdCB2ZWN0b3JzKQ0KPiANClN1cmUsIGZl
ZWwgZnJlZQ0KDQo+ID4gPiBUaGF0IHdvdWxkIGVzdGFibGlzaCBhIGdyb3VuZCB0cnV0aCBhZ2Fp
bnN0DQo+ID4gPiB3aGljaCB3ZSBjYW4gaW1wbGVtZW50IHRoZSBnZW5lcmljIHZlcnNpb24gYXMg
d2VsbC4NCj4gPiA+DQo+ID4gPiBbMF0gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvYXJkYi9saW51eC5naXQvbG9nLz9oPXh0cy1jdHMNCj4gPiA+DQo+ID4g
PiA+IEJlc2lkZXMgdGhhdCwgSSdkIGJlIGhhcHB5IHRvIGdlbmVyYXRlIHNvbWUgdGVzdHZlY3Rv
cnMgZnJvbSBvdXIgZGVmYWN0by1zdGFuZGFyZA0KPiA+ID4gPiBpbXBsZW1lbnRhdGlvbiA7LSkN
Cj4gPiA+ID4NCj4gPiA+DQo+ID4gPiBPbmUgb3IgdHdvIGxhcmdlciBvbmVzIHdvdWxkIGJlIHVz
ZWZ1bCwgeWVzLg0KPiA+ID4NCj4gPiBJJ2xsIHNlZSBpZiBJIGNhbiBleHRyYWN0IHNvbWUgc3Vp
dGFibGUgdmVjdG9ycyBmcm9tIG91ciB2ZXJpZmljYXRpb24gc3VpdGUgLi4uDQo+ID4NCj4gDQo+
IEdyZWF0LiBPbmNlIGF2YWlsYWJsZSwgSSdsbCBydW4gdGhlbSBhZ2FpbnN0IG15IGltcGxlbWVu
dGF0aW9ucyBhbmQgcmVwb3J0IGJhY2suDQo+DQpKdXN0IHdvbmRlcmluZyAuLi4gZG8geW91IGhh
dmUgYW55IHBhcnRpY3VsYXIgcmVxdWlyZW1lbnRzIG9uIHRoZSBzaXplcz8NCkZyb20gbXkgaW1w
bGVtZW50YXRpb24ncyBwZXJzcGVjdGl2ZSwgaXQgZG9lc24ndCBtYWtlIGEgd2hvbGUgbG90IG9m
IHNlbnNlIHRvIHRlc3QgdmVjdG9ycyANCm9mIG1vcmUgdGhhbiAzIHRpbWVzIHRoZSBjaXBoZXIg
YmxvY2sgc2l6ZSwgYnV0IHRoZW4gSSByZWFsaXplZCB0aGF0IHlvdSBwcm9iYWJseSBuZWVkDQps
YXJnZXIgdmVjdG9ycyBkdWUgdG8gdGhlIGxvb3AgdW5yb2xsaW5nIHlvdSBkbyBmb3IgdGhlIHZl
Y3RvciBpbXBsZW1lbnRhdGlvbnM/DQpZb3UgYWxzbyBkb24ndCB3YW50IHRoZW0gdG8gYmUgdG9v
IGJpZyBhcyB0aGV5IHRha2UgdXAgc3BhY2UgaW4gdGhlIGtlcm5lbCBpbWFnZSAuLi4NCg0KUmVn
YXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVBy
b3RvY29sIEVuZ2luZXMgQCBWZXJpbWF0cml4DQp3d3cuaW5zaWRlc2VjdXJlLmNvbQ0K
