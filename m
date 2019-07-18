Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E03C76195
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 10:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF20A217F4
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 10:41:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="RaFx4FB1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfGRKk7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 06:40:59 -0400
Received: from mail-eopbgr680081.outbound.protection.outlook.com ([40.107.68.81]:14759
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726423AbfGRKk7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 06:40:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ph5A5Fq/BgtOr2N+V6280tC7BSPmvJnAXqciZh8ufgrTh2/dxy/f5kwjayRatMQ650tHAP8Xh7qIW77GhPzH8fmKe5wejm4qwjnBa+pKG4C+zRFB5cSng25VCthm+SWuoj8bkqTza9EllO7N6GEVwX3pKTAMio4y5owUxqVczHPsKxZpChfIbwyy2+jG1DOY6mJZ/fHoOtyisupr3WSvpvww7KNxxnTb3wRhwxUfyiR/+GUk5Zg8gF4TsQnS6+kSC7HBxmaj127goZgnqBpBvtsmUIk/BXAUJad4hw9RYon1PfMbKkaKirXM/TPbbYTu7xXnbw4jJf87eZHEHM9xvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJuuE2az/sA2H8lCTfSWjQ5zJSH14ec1euBgmdyHBlk=;
 b=ED86uKO72jGlWBtVfyzEO6xzVK8Dl9mDQ/DAnmgdetqY53DxIwJFWUqlM/EUK7cmDuL6PpB0pZ0g1Oo9oWV3uYSq2Yd9+9pziY53cxcNyzxdgH39eE40VQfKCaNntQ4llqIxwpuUsPbrhjuSZDkDp1oHacXlGydJgc8XJvqoCcoNUYWhUSDh7f8aW3bGh0aNNQQ1CR4IrGXrAZ8CHVskHSB7zMhpU+oWBSBfZ//UYw1epgEj8Q/USqyqNGZHJ05G2ZRCpnbfP1KrPBeRm9F4EtMGG38Ec9ChlpW/TqbABwqM4kLInWOfaQSLC9MdrfgspT80CA/Vj9SkB+mfkD15uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJuuE2az/sA2H8lCTfSWjQ5zJSH14ec1euBgmdyHBlk=;
 b=RaFx4FB1DOhnued2sO0b9DErYH4ASFZyPFcw/BtPa6q4fCWXVQ/trb2SnyzZn7P/CigOiXtzHBEo+Pa3JgE7nWarPmGKFyn7EmntJJkD13J/oS/PPlu7I5bfkW/+mt9xxGe+YRFzije1rDOmOR+OcRLaFGnGpyfCy7j247+cg6s=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3229.namprd20.prod.outlook.com (52.132.175.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Thu, 18 Jul 2019 10:40:55 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2073.012; Thu, 18 Jul 2019
 10:40:55 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Milan Broz <gmazyland@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: RE: xts fuzz testing and lack of ciphertext stealing support
Thread-Topic: xts fuzz testing and lack of ciphertext stealing support
Thread-Index: AQHVO/5l0aVU4O6KC0WgPIqEsMQCDqbPEhUAgAALMYCAANVxgIAABoCAgAABwICAAAUbgIAAFRTA
Date:   Thu, 18 Jul 2019 10:40:54 +0000
Message-ID: <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190716221639.GA44406@gmail.com>
 <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com>
 <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
 <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
 <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
In-Reply-To: <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 182c228b-eb2d-41e2-f56a-08d70b6c6988
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB3229;
x-ms-traffictypediagnostic: MN2PR20MB3229:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB322934345CE9792E7EE4ABE0CAC80@MN2PR20MB3229.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(346002)(136003)(396003)(366004)(376002)(199004)(189003)(13464003)(86362001)(7696005)(186003)(6246003)(53936002)(107886003)(64756008)(66556008)(9686003)(71190400001)(5660300002)(14444005)(256004)(71200400001)(15974865002)(316002)(54906003)(110136005)(76176011)(486006)(52536014)(476003)(99286004)(6506007)(6436002)(66946007)(66446008)(74316002)(478600001)(229853002)(66476007)(68736007)(26005)(305945005)(14454004)(6116002)(76116006)(7736002)(11346002)(8936002)(446003)(55016002)(53546011)(3846002)(2906002)(81166006)(25786009)(33656002)(66066001)(8676002)(81156014)(102836004)(4326008)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3229;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tsWi9BKIV+UrJjdO338RcNeYDLPGxI0vmXgOIi8/gx+c0tlQzn3TssYehU9CpFM8E+Nu5oa8A9JJH875fhGtiJTpoyX7YgAwaUeMFoY42MfQinNpaQKIWN0AwgQ2Fqa44q1Lbe+8WBsQMFZgC//MNDk/Mum6laNoNCu4Q2tgHOIpk4bdj12Mij0QEDuDQGfYhwQpfvEc/qG7oaSf+IYOB6Z97BFVmE2hA+pWIfn9EVU2fEJsVVU/n2+B0SuAbMPT/k3mROBEWHW5ni97LRRtgsKLwFEXIgeI9YFd5GIYgm4ZQ6lEhqdz7eirv+mT5KFH765Jl+NWJYQl4pwLhihKPAt6y9qQS2TJBmO8M3ffRZlLJLxHMOvxkLqAtOUcrABraK0jNgRg2UXWv7ql1iY0mZm2vdrMoxwxgUaxvxueLto=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 182c228b-eb2d-41e2-f56a-08d70b6c6988
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 10:40:54.9722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3229
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJA
dmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBC
ZWhhbGYgT2YgTWlsYW4gQnJveg0KPiBTZW50OiBUaHVyc2RheSwgSnVseSAxOCwgMjAxOSA5OjQw
IEFNDQo+IFRvOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBBcmQg
Qmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4NCj4gQ2M6IEhvcmlhIEdlYW50
YSA8aG9yaWEuZ2VhbnRhQG54cC5jb20+OyBsaW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOyBk
bS1kZXZlbEByZWRoYXQuY29tDQo+IFN1YmplY3Q6IFJlOiB4dHMgZnV6eiB0ZXN0aW5nIGFuZCBs
YWNrIG9mIGNpcGhlcnRleHQgc3RlYWxpbmcgc3VwcG9ydA0KPiANCj4gT24gMTgvMDcvMjAxOSAw
OToyMSwgSGVyYmVydCBYdSB3cm90ZToNCj4gPiBPbiBUaHUsIEp1bCAxOCwgMjAxOSBhdCAwOTox
NTozOUFNICswMjAwLCBBcmQgQmllc2hldXZlbCB3cm90ZToNCj4gPj4NCj4gPj4gTm90IGp1c3Qg
dGhlIGdlbmVyaWMgaW1wbGVtZW50YXRpb246IHRoZXJlIGFyZSBudW1lcm91cyBzeW5jaHJvbm91
cw0KPiA+PiBhbmQgYXN5bmNocm9ub3VzIGltcGxlbWVudGF0aW9ucyBvZiB4dHMoYWVzKSBpbiB0
aGUga2VybmVsIHRoYXQgd291bGQNCj4gPj4gaGF2ZSB0byBiZSBmaXhlZCwgd2hpbGUgdGhlcmUg
YXJlIG5vIGluLWtlcm5lbCB1c2VycyB0aGF0IGFjdHVhbGx5DQo+ID4+IHJlbHkgb24gQ1RTLiBB
bHNvLCBpbiB0aGUgY2JjIGNhc2UsIHdlIHN1cHBvcnQgQ1RTIGJ5IHdyYXBwaW5nIGl0IGludG8N
Cj4gPj4gYW5vdGhlciB0ZW1wbGF0ZSwgaS5lLiwgY3RzKGNiYyhhZXMpKS4NCj4gPj4NCj4gPj4g
U28gcmV0cm9hY3RpdmVseSByZWRlZmluaW5nIHdoYXQgeHRzKC4uLikgbWVhbnMgc2VlbXMgbGlr
ZSBhIGJhZCBpZGVhDQo+ID4+IHRvIG1lLiBJZiB3ZSB3YW50IHRvIHN1cHBvcnQgWFRTIGNpcGhl
cnRleHQgc3RlYWxpbmcgZm9yIHRoZSBiZW5lZml0DQo+ID4+IG9mIHVzZXJsYW5kLCBsZXQncyBk
byBzbyB2aWEgdGhlIGV4aXN0aW5nIGN0cyB0ZW1wbGF0ZSwgYW5kIGFkZA0KPiA+PiBzdXBwb3J0
IGZvciB3cmFwcGluZyBYVFMgdG8gaXQuDQo+ID4NCj4gPiBYVFMgd2l0aG91dCBzdGVhbGluZyBz
aG91bGQgYmUgcmVuYW1lZCBhcyBYRVguICBTdXJlIHlvdSBjYW4gdGhlbg0KPiA+IHdyYXAgaXQg
aW5zaWRlIGN0cyB0byBmb3JtIHh0cyBidXQgdGhlIGVuZCByZXN1bHQgbmVlZHMgdG8gYmUgY2Fs
bGVkDQo+ID4geHRzLg0KPiANCj4gV2hpbGUgSSBmdWxseSBhZ3JlZSBoZXJlIGZyb20gdGhlIHRl
Y2huaWNhbCBwb2ludCBvZiB2aWV3LA0KPiBhY2FkZW1pY2FsbHkgWEVYLCBYRVgqIGlzIGEgZGlm
ZmVyZW50IG1vZGUuDQo+IEl0IHdvdWxkIGNyZWF0ZSBldmVuIG1vcmUgY29uZnVzaW9uLg0KPiAN
Cj4gQ291bGRuJ3QgcmVzaXN0LCBidXQgdGhpcyBpcyBhIG5pY2UgZXhhbXBsZSBvZiB3aGF0IGhh
cHBlbnMgd2hlbiBhY2FkZW1pYywNCj4gc3RhbmRhcmRpemF0aW9uLCBhbmQgcmVhbGl0eSBtZWV0
cyBpbiBvbmUgcGxhY2UgOikNCj4gDQo+IFhUUyBpcyBhbHJlYWR5IGltcGxlbWVudGVkIGluIGdj
cnlwdCBhbmQgT3BlblNTTC4NCj4gSU1PIGFsbCB0aGUgaW1wbGVtZW50YXRpb24gc2hvdWxkIGJl
IGV4YWN0bHkgdGhlIHNhbWUuDQo+IA0KPiBJIGFncmVlIHdpdGggSGVyYmVydCB0aGF0IHRoZSBw
cm9wZXIgd2F5IGlzIHRvIGltcGxlbWVudCBjaXBoZXJ0ZXh0IHN0ZWFsaW5nLg0KPiBPdGhlcndp
c2UsIGl0IGlzIGp1c3QgaW5jb21wbGV0ZSBpbXBsZW1lbnRhdGlvbiwgbm90IGEgcmVkZWZpbmlu
ZyBYVFMgbW9kZSENCj4gDQo+IFNlZSB0aGUgcmVmZXJlbmNlIGluIGdlbmVyaWMgY29kZSAtIHRo
ZSAzcmQgbGluZSAtIGxpbmsgdG8gdGhlIElFRUUgc3RhbmRhcmQuDQo+IFdlIGRvIG5vdCBpbXBs
ZW1lbnQgaXQgcHJvcGVybHkgLSBmb3IgbW9yZSB0aGFuIDEyIHllYXJzIQ0KPiANCg0KRnVsbCBY
VFMgaXMgWEVYLVRDQi1DVFMgc28gdGhlIHByb3BlciB0ZXJtaW5vbG9neSBmb3IgIlhUUyB3aXRo
b3V0IENUUyIgd291bGQgYmUgWEVYLVRDQi4NCkJ1dCB0aGUgcHJvYmxlbSB0aGVyZSBpcyB0aGF0
IFRDQiBhbmQgQ1RTIGFyZSBnZW5lcmljIHRlcm1zIHRoYXQgZG8gbm90IGltcGx5IGEgc3BlY2lm
aWMgDQppbXBsZW1lbnRhdGlvbiBmb3IgZ2VuZXJhdGluZyB0aGUgdHdlYWsgLW9yLSBwZXJmb3Jt
aW5nIHRoZSBjaXBoZXJ0ZXh0IHN0ZWFsaW5nLg0KT25seSB0aGUgKmZ1bGwqIFhUUyBvcGVyYXRp
b24gaXMgc3RhbmRhcmRpemVkIChhcyBJRUVFIFN0ZCBQMTYxOSkuDQoNCkluIGZhY3QsIHVzaW5n
IHRoZSBjdXJyZW50IGN0cyB0ZW1wbGF0ZSBhcm91bmQgdGhlIGN1cnJlbnQgeHRzIHRlbXBsYXRl
IGFjdHVhbGx5IGRvZXMgTk9UDQppbXBsZW1lbnQgc3RhbmRhcmRzIGNvbXBsaWFudCBYVFMgYXQg
YWxsLCBhcyB0aGUgQ1RTICppbXBsZW1lbnRhdGlvbiogZm9yIFhUUyBpcyANCmRpZmZlcmVudCBm
cm9tIHRoZSBvbmUgZm9yIENCQyBhcyBpbXBsZW1lbnRlZCBieSB0aGUgY3VycmVudCBDVFMgdGVt
cGxhdGUuDQpUaGUgYWN0dWFsIGltcGxlbWVudGF0aW9uIG9mIHRoZSBjaXBoZXJ0ZXh0IHN0ZWFs
aW5nIGhhcyAob3IgbWF5IGhhdmUpIGEgc2VjdXJpdHkgaW1wYWN0LA0Kc28gdGhlICpjb21iaW5l
ZCogb3BlcmF0aW9uIG11c3QgYmUgY3J5cHRhbmFseXplZCBhbmQgYWRkaW5nIHNvbWUgcmFuZG9t
IENUUyBzY2hlbWUNCnRvIHNvbWUgcmFuZG9tIGJsb2NrIGNpcGhlciBtb2RlIHdvdWxkIGJlIGEg
Y2FzZSBvZiAicm9sbCB5b3VyIG93biBjcnlwdG8iIChpLmUuIGJhZCkuDQoNCkZyb20gdGhhdCBw
ZXJzcGVjdGl2ZSAtIHRvIHByZXZlbnQgcGVvcGxlIGZyb20gZG9pbmcgY3J5cHRvZ3JhcGhpY2Fs
bHkgc3R1cGlkIHRoaW5ncyAtDQpJTUhPIGl0IHdvdWxkIGJlIGJldHRlciB0byBqdXN0IHB1bGwg
dGhlIENUUyBpbnRvIHRoZSBYVFMgaW1wbGVtZW50YXRpb24gaS5lLiBtYWtlDQp4dHMgbmF0aXZl
bHkgc3VwcG9ydCBibG9ja3MgdGhhdCBhcmUgbm90IGEgbXVsdGlwbGUgb2YgKGJ1dCA+PSkgdGhl
IGNpcGhlciBibG9ja3NpemUgLi4uDQoNCj4gUmVhbGl0eSBjaGVjayAtIG5vYm9keSBpbiBibG9j
ayBsYXllciBuZWVkcyBjaXBoZXJ0ZXh0IHN0ZWFsaW5nLCB3ZSBhcmUgYWx3YXlzDQo+IGFsaWdu
ZWQgdG8gYmxvY2suIEFGX0FMRyBpcyBhIGRpZmZlcmVudCBzdG9yeSwgdGhvdWdoLg0KDQpTbyB5
b3UgZG9uJ3Qgc3VwcG9ydCBvZGQgc2VjdG9yIHNpemVzIGxpa2UgNTIwICwgNTI4LCA0MTEyLCA0
MTYwIG9yIDQyMjQgYnl0ZXM/DQo+IA0KPiBNaWxhbg0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBM
ZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGktUHJvdG9jb2wgRW5naW5lcyBAIFZl
cmltYXRyaXgNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQo=
