Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 915A9CA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50893205C9
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:22:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="F2RX0QI1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfJUMWe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 08:22:34 -0400
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:14705
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727256AbfJUMWe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 08:22:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gdh/JljSPwnoF/1r7MkQ9tB6PuJWSB7E2P6nfhXPBX0BMfRVq1BzCQlOVhrlrdnW+rh9ZfNGFwI/GXPW2KpdTBeiFVZiLTCaFFz4wcNqcNMKu4d4MlI7rKSMEMUYwVYk+QGzXm6rnhEDPgHmZMSSK3EIEuLbaLuDN6PJBH9jm+ALh8nHrCLw2TbNgKYPamg4/XvH9FygJj0+w8g9wKT4GdWES2t+0Dr4z1luZjtoJMrHOtVlYtxSSjs8Ias9eRU9ddFeIGikBS8SJaOSN3DAAFVC9/WwQtZzdm6+9Q/bt6w+5Q78AZfnjWToSid3kGG+9guCvVgxxFRmlvJU57egcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vT5kQJaut9xmwliOb9/8sZTJw4154Qk9bcq613/PAk=;
 b=ex7LsEsJw79F9xxHGnIWMJlpc3fPm1DOxmjv8WsHruWU3nqSZPAfhD0SU29RL/OcR//y04ZqoqoZxV/Qp+27XUb/2TnipPsKIaT2SQMhvOOSWTRhFmUQXGcP5Bv16/hC8VgO+lQZInrsJZzcahx4K615348mbXwkslHwkhBMOezgvRaDJ1fVfewZnMztIig4T7X31GRkQpzQ9iyvHV9MB0PRmqOEsoeZhjmYYW/cbdlCdGJphFa/jbRSj6y71u2vbqAjjdy/VTA+6Ri2DqwW2HwFBFkfl4MequQOKAF+8flo/e5SsxTA2fr9CHPh1Vx1JeGi3G23yEZc04puG85CBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vT5kQJaut9xmwliOb9/8sZTJw4154Qk9bcq613/PAk=;
 b=F2RX0QI13ocKqhndLi4hn4Ll94pgLdAtKu1Ei8imsnljhUY63qvDLevtxtnR4B8ikOZl6ked1hjbRy6+qASg6GnNpOZzDXRlGWseiwOlDrgHyrBJmyTXwcOJYZCpKGSwGHqg9znmWS+Qh6tAUbyWnKyGQvTyfINtcqCrrRwJ+Dg=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2240.namprd20.prod.outlook.com (20.179.145.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Mon, 21 Oct 2019 12:20:50 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::b986:4f02:3206:31e4%7]) with mapi id 15.20.2347.029; Mon, 21 Oct 2019
 12:20:50 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Subject: RE: Key endianness?
Thread-Topic: Key endianness?
Thread-Index: AdWH7WiyGB6aVNy7SJOkTaAoiPGHOgADxdEgAAIVQ1AAAPlDAAAAEx0g
Date:   Mon, 21 Oct 2019 12:20:50 +0000
Message-ID: <MN2PR20MB2973FFB65DBFAC4C0AF76E59CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB29734588383A8699E6B700F3CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB29730B2489C1A416BE8B7864CA690@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8xVE+QwU39McGPsGRfx9PuoiHyHFY3fie4rDidhcSfYg@mail.gmail.com>
In-Reply-To: <CAKv+Gu8xVE+QwU39McGPsGRfx9PuoiHyHFY3fie4rDidhcSfYg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89a958ec-7fbe-45df-cbb8-08d756211c1f
x-ms-traffictypediagnostic: MN2PR20MB2240:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB22406769E95CB87776BD89BFCA690@MN2PR20MB2240.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(39850400004)(366004)(376002)(13464003)(199004)(189003)(6436002)(3846002)(6116002)(5660300002)(7696005)(229853002)(6246003)(256004)(14444005)(6916009)(99286004)(15974865002)(4326008)(55016002)(86362001)(25786009)(52536014)(9686003)(8676002)(8936002)(81166006)(81156014)(7736002)(305945005)(7116003)(74316002)(66066001)(54906003)(11346002)(71200400001)(71190400001)(3480700005)(316002)(66476007)(66946007)(14454004)(66556008)(64756008)(66446008)(76116006)(33656002)(102836004)(476003)(76176011)(26005)(486006)(2906002)(478600001)(53546011)(446003)(186003)(6506007)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2240;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MJL2j2fBYGyBlH+5oWqfnzzH0j0cjrPI0P6O9BSDOSLooAX5rLG9bISHAfAO2ISXTnVEg0aazhI8BHfNtpfz+xSs8KQG7aGjuiT9e9C3TAX7uyEXyjCfMTfwWl3fVdMG2OHx8FYKtisRyzSwLAA6r7M5Kffbs6x1b+ry/aay5EGwApL1Z4qEly9P4XKuddxuyMhPs/FRAT93cOito+wxe7n6nOB6y1XMwbLayU1roaiT2Ro3tnaL1pYbThZve1jnKWn9uekYgAajXQgi/tIQTK+61sFyMjaz0lj+PAVNcjE31sgog8UZyLOv60opXMBc/PUHsQpIW06Z4GQAiy/Syqbl6i3fH0maeYDPQ/cdrCPLuAn9IhhGKkOo5RCy4S6BIw9OKcdpgV4vw81QnWodMD1vU4AGqPbyJvCOwK7qKI6kXoSxiam65aPDI9wFp8Vl
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a958ec-7fbe-45df-cbb8-08d756211c1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 12:20:50.1580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uQFRF8XmuHn1wrFH2DFieUwFxoM7nWA2YL7zP/HDsdk7Kqch6SBFbpqLuMN+BmmAT3pn44mWiOhNyloQ3cJFvZo+nexCpdnN01Wya0OLHbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2240
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
LmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4NCj4gU2VudDogTW9uZGF5LCBPY3RvYmVyIDIxLCAyMDE5
IDI6MTIgUE0NCj4gVG86IFBhc2NhbCBWYW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJp
eC5jb20+DQo+IENjOiBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBoZXJiZXJ0QGdvbmRv
ci5hcGFuYS5vcmcuYXUNCj4gU3ViamVjdDogUmU6IEtleSBlbmRpYW5uZXNzPw0KPiANCj4gT24g
TW9uLCAyMSBPY3QgMjAxOSBhdCAxNDowOCwgUGFzY2FsIFZhbiBMZWV1d2VuDQo+IDxwdmFubGVl
dXdlbkB2ZXJpbWF0cml4LmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBBbmQgbm93IHRoYXQgd2UndmUg
b3BlbmVkIFBhbmRvcmEncyBib3ggb2YgImVsbGVuZGlhbm5lc3MiIChhcyB3ZQ0KPiA+IHNheSBo
ZXJlIC0gYSBjb21iaW5hdGlvbiBvZiB0aGUgRHV0Y2ggd29yZCAiZWxsZW5kZSIsIGZvciBtaXNl
cnksDQo+ID4gYW5kIGVuZGlhbm5lc3MgOy0pOg0KPiA+DQo+ID4gVGhlIGluc2lkZS1zZWN1cmUg
ZHJpdmVyIHVzZXMgc2V2ZXJhbCBwYWNrZWQgYml0ZmllbGQgc3RydWN0dXJlcw0KPiA+ICh0aGF0
IGFyZSBhY3R1YWxseSB1c2VkIGRpcmVjdGx5IGJ5IHRoZSBsaXR0bGUtZW5kaWFuIGhhcmR3YXJl
KQ0KPiA+IFdoYXQgaGFwcGVucyB0byB0aGVzZSBvbiBhIGJpZy1lbmRpYW4gbWFjaGluZT8NCj4g
DQo+IFRoZSBDIHNwZWMgZG9lcyBub3QgZGVmaW5lIGhvdyBwYWNrZWQgYml0ZmllbGRzIGFyZSBw
cm9qZWN0ZWQgb250bw0KPiBtZW1vcnksDQo+DQpZZXMsIEkga25vdyB0aGF0LiBCdXQgR0NDIG1h
eSBzdGlsbCBwcm92aWRlIGd1YXJhbnRlZXMsIEkgZG9uJ3Qga25vdy4NCkl0J3Mgbm90IG15IGNv
ZGUsIGl0J3MgbGVnYWN5IGNvZGUgdGhhdCB3YXMgYWxyZWFkeSB0aGVyZSwgd2hpY2ggSQ0KdHJ5
IHRvIHRvdWNoIGFzIGxpdHRsZSBhcyBwb3NzaWJsZS4NCihJIGFscmVhZHkgZGVjaWRlZCBJIGRp
ZG4ndCBsaWtlIGl0IGp1c3QgYmFzZWQgb24gdGhlIHJlc3VsdHMgb2YgDQpydW5uaW5nIGl0IHRo
cm91Z2ggQ29tcGlsZXIgRXhwbG9yZXIgLSBub3QgdmVyeSBlZmZpY2llbnQgLi4uKQ0KDQo+IHNv
IHJlbHlpbmcgb24gdGhhdCBpcyBhIG1pc3Rha2UuIFlvdXIgY29kZSBzaG91bGQgZG8gdGhlDQo+
IGJpdHdpc2UgYXJpdGhtZXRpYyBleHBsaWNpdGx5IHRvIGJlIHBvcnRhYmxlLg0KPiANClllYWgs
IHByb2JhYmx5LiBQcm9ibGVtIGlzIHRoZXNlIGRhdGEgc3RydWN0dXJlcyBhcmUgdXNlZCBldmVy
eXdoZXJlLg0KU28gZ2V0dGluZyB0aGUgY2hhbmdlcyB0aHJvdWdoIHRoZSB3aG9sZSByZXZpZXcg
cHJvY2VzcyB3b3VsZCBqdXN0DQpiZSB0b28gcGFpbmZ1bC4gSXQncyBiZWVuIGxpa2UgdGhpcyBm
b3IgeWVhcnMgYW5kIHNvIGZhciBpdCB3b3JrZWQNCmp1c3QgZmluZSAoSSBndWVzcykuDQoNClNv
IEknZCBwcmVmZXIgYSBzb2x1dGlvbiB0aGF0IHJlcXVpcmVzIG1pbmltYWwgY2hhbmdlcyB0byBl
eGlzdGluZw0KY29kZSBidXQgd291bGQgc3RpbGwgYmUgZ3VhcmFudGVlZCB0byB3b3JrIG9uIGJv
dGggYmlnIGFuZCBsaXR0bGUNCmVuZGlhbiBtYWNoaW5lcywgYXNzdW1pbmcgeW91IHVzZSBHQ0Mg
KG9yIENsYW5nPykgYXMgdGhlIGNvbXBpbGVyLg0KDQo+ID4gSSd2ZSBzZWVuIGV4YW1wbGVzIHRo
YXQgaGludCBhdCBoYXZpbmcgdG8gZGVmaW5lIHRoZSBiaXRzIGluDQo+ID4gcmV2ZXJzZSBvcmRl
ciBvbiBiaWctZW5kaWFuIG1hY2hpbmVzLCB3aGljaCB3b3VsZCByZXF1aXJlIGEgYmlnDQo+ID4g
IiNpZmRlZiBMSVRUTEVfRU5ESUFOIC8gI2Vsc2UiIGFyb3VuZCB0aGUgd2hvbGUgc3RydWN0IGRl
ZmluaXRpb24uDQo+ID4NCj4gPiBBbmQgdGhlbiBvbiB0b3Agb2YgdGhhdCBJJ2xsIHByb2JhYmx5
IHN0aWxsIGhhdmUgdG8gc3dhcCB0aGUgYnl0ZXMNCj4gPiB3aXRoaW4gd29yZHMgdG8gZ2V0IHRo
b3NlIGludG8gdGhlIGNvcnJlY3Qgb3JkZXIgdG93YXJkcyB0aGUgSFcuDQo+ID4gV2hpY2ggaXMg
bm90IHZlcnkgY29udmVuaWVudCBmb3IgZmllbGRzIGNyb3NzaW5nIGJ5dGUgYm91bmRhcmllcy4N
Cj4gPiAoSSdkIHByb2JhYmx5IHdhbnQgdG8gdXNlIHRoZSBieXRlIHN3YXBwaW5nIGZhY2lsaXRp
ZXMgb2YgbXkgSFcNCj4gPiBmb3IgdGhhdCBhbmQgbm90IHRoZSBDUFUpDQo+ID4NCj4gPiBSZWdh
cmRzLA0KPiA+IFBhc2NhbCB2YW4gTGVldXdlbg0KPiA+IFNpbGljb24gSVAgQXJjaGl0ZWN0LCBN
dWx0aS1Qcm90b2NvbCBFbmdpbmVzIEAgVmVyaW1hdHJpeA0KPiA+IHd3dy5pbnNpZGVzZWN1cmUu
Y29tDQo+ID4NCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBs
aW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdl
ci5rZXJuZWwub3JnPiBPbiBCZWhhbGYgT2YNCj4gPiA+IFBhc2NhbCBWYW4gTGVldXdlbg0KPiA+
ID4gU2VudDogTW9uZGF5LCBPY3RvYmVyIDIxLCAyMDE5IDEyOjU2IFBNDQo+ID4gPiBUbzogbGlu
dXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgaGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1DQo+
ID4gPiBTdWJqZWN0OiBSRTogS2V5IGVuZGlhbm5lc3M/DQo+ID4gPg0KPiA+ID4gQW5vdGhlciBl
bmRpYW5uZXNzIHF1ZXN0aW9uOg0KPiA+ID4NCj4gPiA+IEkgaGF2ZSBzb21lIGRhdGEgc3RydWN0
dXJlIHRoYXQgY2FuIGJlIGVpdGhlciBsaXR0bGUgb3IgYmlnIGVuZGlhbiwNCj4gPiA+IGRlcGVu
ZGluZyBvbiB0aGUgZXhhY3QgdXNlIGNhc2UuIEN1cnJlbnRseSwgSSBoYXZlIGl0IGRlZmluZWQg
YXMgdTMyLg0KPiA+ID4gVGhpcyBjYXVzZXMgc3BhcnNlIGVycm9ycyB3aGVuIGFjY2Vzc2luZyBp
dCB1c2luZyBjcHVfdG9fWGUzMigpIGFuZA0KPiA+ID4gWGUzMl90b19jcHUoKS4NCj4gPiA+DQo+
ID4gPiBOb3csIGZvciB0aGUgYmlnIGVuZGlhbiBjYXNlLCBJIGNvdWxkIHVzZSBodG9ubCgpL250
b2hsKCkgaW5zdGVhZCwNCj4gPiA+IGJ1dCB0aGlzIGlzIGluY29uc2lzdGVudCB3aXRoIGFsbCBv
dGhlciBlbmRpYW4gY29udmVyc2lvbnMgaW4gdGhlDQo+ID4gPiBkcml2ZXIgLi4uIGFuZCB0aGVy
ZSdzIG5vIGxpdHRsZSBlbmRpYW4gYWx0ZXJuYXRpdmUgSSdtIGF3YXJlIG9mLg0KPiA+ID4gU28g
SSBkb24ndCByZWFsbHkgbGlrZSB0aGF0IGFwcHJvYWNoLg0KPiA+ID4NCj4gPiA+IEFsdGVybmF0
aXZlbHksIEkgY291bGQgZGVmaW5lIGEgdW5pb24gb2YgYm90aCBhIGJpZyBhbmQgbGl0dGxlDQo+
ID4gPiBlbmRpYW4gdmVyc2lvbiBvZiB0aGUgZGF0YSBidXQgdGhhdCB3b3VsZCByZXF1aXJlIHRv
dWNoaW5nIGEgbG90DQo+ID4gPiBvZiBsZWdhY3kgY29kZSAodW5sZXNzIEkgdXNlIGEgQzExIGFu
b255bW91cyB1bmlvbiAuLi4gbm90IHN1cmUNCj4gPiA+IGlmIHRoYXQgd291bGQgYmUgYWxsb3dl
ZD8pIGFuZCBJTUhPIGlzIGEgYml0IHNpbGx5Lg0KPiA+ID4NCj4gPiA+IElzIHRoZXJlIHNvbWUg
d2F5IG9mIHRlbGxpbmcgc3BhcnNlIHRvIF9ub3RfIGNoZWNrIGZvciAiY29ycmVjdCINCj4gPiA+
IHVzZSBvZiB0aGVzZSBmdW5jdGlvbnMgZm9yIGEgY2VydGFpbiB2YXJpYWJsZT8NCj4gPiA+DQo+
ID4gPiBSZWdhcmRzLA0KPiA+ID4gUGFzY2FsIHZhbiBMZWV1d2VuDQo+ID4gPiBTaWxpY29uIElQ
IEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5lcyBAIFZlcmltYXRyaXgNCj4gPiA+IHd3
dy5pbnNpZGVzZWN1cmUuY29tDQo+ID4gPg0KPiA+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+ID4gPiBGcm9tOiBQYXNjYWwgVmFuIExlZXV3ZW4NCj4gPiA+ID4gU2VudDogTW9u
ZGF5LCBPY3RvYmVyIDIxLCAyMDE5IDExOjA0IEFNDQo+ID4gPiA+IFRvOiBsaW51eC1jcnlwdG9A
dmdlci5rZXJuZWwub3JnOyBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXUNCj4gPiA+ID4gU3Vi
amVjdDogS2V5IGVuZGlhbm5lc3M/DQo+ID4gPiA+DQo+ID4gPiA+IEhlcmJlcnQsDQo+ID4gPiA+
DQo+ID4gPiA+IEknbSBjdXJyZW50bHkgYnVzeSBmaXhpbmcgc29tZSBlbmRpYW5uZXNzIHJlbGF0
ZWQgc3BhcnNlIGVycm9ycyByZXBvcnRlZA0KPiA+ID4gPiBieSB0aGlzIGtidWlsZCB0ZXN0IHJv
Ym90IGFuZCB0aGlzIHRyaWdnZXJlZCBteSB0byByZXRoaW5rIHNvbWUgZW5kaWFuDQo+ID4gPiA+
IGNvbnZlcnNpb24gYmVpbmcgZG9uZSBpbiB0aGUgaW5zaWRlLXNlY3VyZSBkcml2ZXIuDQo+ID4g
PiA+DQo+ID4gPiA+IEkgYWN0dWFsbHkgd29uZGVyIHdoYXQgdGhlIGVuZGlhbm5lc3MgaXMgb2Yg
dGhlIGlucHV0IGtleSBkYXRhLCBlLmcuIHRoZQ0KPiA+ID4gPiAidTggKmtleSIgcGFyYW1ldGVy
IHRvIHRoZSBzZXRrZXkgZnVuY3Rpb24uDQo+ID4gPiA+DQo+ID4gPiA+IEkgYWxzbyB3b25kZXIg
d2hhdCB0aGUgZW5kaWFubmVzcyBpcyBvZiB0aGUga2V5IGRhdGEgaW4gYSBzdHJ1Y3R1cmUNCj4g
PiA+ID4gbGlrZSAiY3J5cHRvX2Flc19jdHgiLCBhcyBmaWxsZWQgaW4gYnkgdGhlIGFlc19leHBh
bmRrZXkgZnVuY3Rpb24uDQo+ID4gPiA+DQo+ID4gPiA+IFNpbmNlIEkga25vdyBteSBjdXJyZW50
IGVuZGlhbm5lc3MgY29udmVyc2lvbnMgd29yayBvbiBhIGxpdHRsZSBlbmRpYW4NCj4gPiA+ID4g
Q1BVLCBJIGd1ZXNzIHRoZSBiaWcgcXVlc3Rpb24gaXMgd2hldGhlciB0aGUgYnl0ZSBvcmRlciBv
ZiB0aGlzIGtleQ0KPiA+ID4gPiBkYXRhIGlzIF9DUFUgYnl0ZSBvcmRlcl8gb3IgYWx3YXlzIHNv
bWUgX2ZpeGVkIGJ5dGUgb3JkZXJfIChlLmcuIGFzIHBlcg0KPiA+ID4gPiBhbGdvcml0aG0gc3Bl
Y2lmaWNhdGlvbikuDQo+ID4gPiA+DQo+ID4gPiA+IEkga25vdyBJIGhhdmUgc29tZSBjdXN0b21l
cnMgdXNpbmcgYmlnLWVuZGlhbiBDUFUncywgc28gSSBkbyBjYXJlLCBidXQNCj4gPiA+ID4gSSB1
bmZvcnR1bmF0ZWx5IGRvbid0IGhhdmUgYW55IHBsYXRmb3JtIGF2YWlsYWJsZSB0byB0ZXN0IHRo
aXMgd2l0aC4NCj4gPiA+ID4NCj4gPiA+ID4gUmVnYXJkcywNCj4gPiA+ID4gUGFzY2FsIHZhbiBM
ZWV1d2VuDQo+ID4gPiA+IFNpbGljb24gSVAgQXJjaGl0ZWN0LCBNdWx0aS1Qcm90b2NvbCBFbmdp
bmVzIEAgVmVyaW1hdHJpeA0KPiA+ID4gPiB3d3cuaW5zaWRlc2VjdXJlLmNvbQ0KPiA+DQoNCg0K
UmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2lsaWNvbiBJUCBBcmNoaXRlY3QsIE11bHRp
LVByb3RvY29sIEVuZ2luZXMgQCBWZXJpbWF0cml4DQp3d3cuaW5zaWRlc2VjdXJlLmNvbQ0K
