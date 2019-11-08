Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A00DC5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00D1B21882
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:53:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="wz/Xq+hW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfKHIxY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:53:24 -0500
Received: from mail-eopbgr770078.outbound.protection.outlook.com ([40.107.77.78]:53754
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726072AbfKHIxY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 03:53:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjor+aCwQz1/iiuUCHTmReUezIFG5A5I6jzYenF//Lt9MEJW+PBYJ+bSRTeNaoB979mLFhKdyD//kTCW03swTVKiZY401RW/pQcvYEKbCIiRuVAwam3d664N2WgOoeY8rX3uEy4u4hEdcvqz4Hy2JILs22KtLpRsFxXejF2vJPw/GdkVtVpD9i4AT1gIjfOaGCscJBP1lKiLda/aPhIDa0FNsFDh9kRqYPSoVaDThm24UoJt8QskbA8UKDtFS/xnPLR1eVYerDMkuRc/YWDLfgwShyXu87AZ+XHiEvPkJbkDZaUojFG6g4YYbxGIj2tIa71NreRUVUBgWWWxNmdFeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjritXvQpQE/9/fco8rG4bZNmnKRHZyMbrdc15o4HzM=;
 b=Q00r4vOzFT2xq+R5HrATn33X5gUlJ0/s2YlbSPmBbtTlrOmhKiOttU0DM5ie3JL94CbCN/v1E4wdBlC4mYGAHSjdRyUDtcBlIAYNJeHWeXCI1cfpdizexctVWJbXif/L6VCXp460lyjp3wO5zHAX7Y3NLRVZiM+dLdhV+QYU6CCnhsDDKGX/+mOrRSie9d+yfcxKD+nCwSlYtJZhLrV5ebqSa8mRpzyoB+HMWFMntVNdRsK8pN38yhuyzIVa0H6ekCALp30Bb5ug6WwjGOQr4Thttd07pBDinSkovPlghGdzjOUSyG/yyinAQBAJZbMjuh0TS8o60qqEMr4ccK6qDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjritXvQpQE/9/fco8rG4bZNmnKRHZyMbrdc15o4HzM=;
 b=wz/Xq+hWYOUg6Tr/jR9D3ovqXIC6Zccg790g3w+Nx7iajd0xxgaTd/7qvZCjLS08nbPJCQFQWj1AviMlHOLKkXSReqjRgAtMvXuNx1yoQO7TJS6rMngi01XUbN5t4g9jGfKaZpE//9e8rYUB5QyMSBvVdfDWLeLgR0Y/4Yanbc4=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.86) by
 MN2PR20MB2526.namprd20.prod.outlook.com (20.179.146.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 08:53:21 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::18b4:f48a:593b:eac9]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::18b4:f48a:593b:eac9%3]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 08:53:21 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCHv2] crypto: inside-secure - Fixed authenc w/ (3)DES fails
 on Macchiatobin
Thread-Topic: [PATCHv2] crypto: inside-secure - Fixed authenc w/ (3)DES fails
 on Macchiatobin
Thread-Index: AQHVlhGWHKZ5/9YotkeSJM0MtAN2HKeA90uAgAAALLA=
Date:   Fri, 8 Nov 2019 08:53:21 +0000
Message-ID: <MN2PR20MB2973D2E3328F8DC32C64F059CA7B0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1573202847-8292-1-git-send-email-pvanleeuwen@verimatrix.com>
 <CAKv+Gu-eefG-=g2v4g8fF+2unL6tyceN0S6JGkJnq4tuuPAgUw@mail.gmail.com>
In-Reply-To: <CAKv+Gu-eefG-=g2v4g8fF+2unL6tyceN0S6JGkJnq4tuuPAgUw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9450f4a-d46b-48c3-262c-08d764291b7c
x-ms-traffictypediagnostic: MN2PR20MB2526:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2526DEFA2F5E77547B3AB0ADCA7B0@MN2PR20MB2526.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:792;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(136003)(39850400004)(366004)(199004)(189003)(13464003)(54534003)(486006)(478600001)(15974865002)(476003)(86362001)(66476007)(81166006)(229853002)(8676002)(81156014)(14444005)(5660300002)(33656002)(66556008)(11346002)(64756008)(7736002)(446003)(8936002)(66446008)(66946007)(66066001)(14454004)(256004)(54906003)(76116006)(74316002)(305945005)(2906002)(6436002)(6246003)(186003)(9686003)(76176011)(7696005)(6116002)(25786009)(26005)(52536014)(99286004)(110136005)(6306002)(71190400001)(316002)(55016002)(3846002)(4326008)(102836004)(6506007)(53546011)(71200400001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2526;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gU3WoCPayr21XPcJOYJ4bzLnP7uf6BVMDhIm/HGNw9URk7EgJDYX0YQwNwrShuTnMSHA+m0FmbxWWZAc8hHQLn46/jwm6QCPoVz41JMPSmEV3Hnj9E0t0oVki8Xzf+JYpYa2mDF3ZSN5qJTeMlmE+05EvYLMIDEY9bpNlqPcCSP2Nb6LNBn9IK0c7u5+YNxI8nI01B0GV5ZCLzwoZWGzIivD208nAIj8n8tbABDPQNWP+jp2L/DD7DMk+7bs6S5p9U2iVbiAYFm9/9XVuIPfy124fVotgnDHJ/OfjJzpzs7Lsjtc2teet3dB6EYWqleWRtMXagsJPw2/6bs6MNmMakHxmodxxzCWl9XUb4NCNodonXQ7SOHOszHYO4ZTNGVzqtNeVVAKH8hJluSPVpCr1/iJ/pOwMUJlZIQtGvEHuqwOjyDh3WGfu4+U1kQZf7MeVLADIL9S9re9yRwPU5yvCJdOO9atBLJj37U9ATO18qo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9450f4a-d46b-48c3-262c-08d764291b7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 08:53:21.1853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q3gnFOL+fo1GAvvnTVKeavzIbkU4F8sXwNKZGZ4Nn4tfz/jsrB3RZ1KZAdoJ4D/MAamENhD5D0Vadu/8uLIp/4LvYDCjmwbZPhJay9VyWqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2526
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJk
LmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4NCj4gU2VudDogRnJpZGF5LCBOb3ZlbWJlciA4LCAyMDE5
IDk6NTIgQU0NCj4gVG86IFBhc2NhbCB2YW4gTGVldXdlbiA8cGFzY2FsdmFubEBnbWFpbC5jb20+
DQo+IENjOiBvcGVuIGxpc3Q6SEFSRFdBUkUgUkFORE9NIE5VTUJFUiBHRU5FUkFUT1IgQ09SRSA8
bGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZz47DQo+IEFudG9pbmUgVGVuYXJ0IDxhbnRvaW5l
LnRlbmFydEBib290bGluLmNvbT47IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9y
Zy5hdT47DQo+IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IFBhc2NhbCBW
YW4gTGVldXdlbiA8cHZhbmxlZXV3ZW5AdmVyaW1hdHJpeC5jb20+DQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0h2Ml0gY3J5cHRvOiBpbnNpZGUtc2VjdXJlIC0gRml4ZWQgYXV0aGVuYyB3LyAoMylERVMg
ZmFpbHMgb24NCj4gTWFjY2hpYXRvYmluDQo+IA0KPiBPbiBGcmksIDggTm92IDIwMTkgYXQgMDk6
NTAsIFBhc2NhbCB2YW4gTGVldXdlbiA8cGFzY2FsdmFubEBnbWFpbC5jb20+IHdyb3RlOg0KPiA+
DQo+ID4gRml4ZXM6IDEzYTFiYjkzZjdiMWM5ICgiY3J5cHRvOiBpbnNpZGUtc2VjdXJlIC0gRml4
ZWQgd2FybmluZ3Mgb24NCj4gPiBpbmNvbnNpc3RlbnQgYnl0ZSBvcmRlciBoYW5kbGluZyIpDQo+
ID4NCj4gDQo+IFBsZWFzZSBwdXQgdGhlIGZpeGVzIHRhZyB3aXRoIHRoZSB0YWdzIChTLW8tYiBl
dGMpDQo+IA0KVGhhdCdzIHdoeSBJIGFza2VkIC0gSSBkaWQgbm90IG1hbmFnZSB0byBleHRyYWN0
IHRoYXQgcmVxdWlyZW1lbnQgZnJvbQ0KdGhlIGRvY3VtZW50YXRpb24gSSBjb3VsZCBmaW5kIC4u
Lg0KKGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9jL2h0bWwvdjQuMTcvcHJvY2Vzcy9zdWJtaXR0
aW5nLXBhdGNoZXMuaHRtbCkNCg0KSSB3aWxsIG1vdmUgaXQgdGhlbi4NCg0KPiA+IEZpeGVkIDIg
Y29weS1wYXN0ZSBtaXN0YWtlcyBpbiB0aGUgYWJvdmVtZW50aW9uZWQgY29tbWl0IHRoYXQgY2F1
c2VkDQo+ID4gYXV0aGVuYyB3LyAoMylERVMgdG8gY29uc2lzdGVudGx5IGZhaWwgb24gTWFjY2hp
YXRvYmluIChidXQgc3RyYW5nZWx5DQo+ID4gd29yayBmaW5lIG9uIHg4NitGUEdBPz8pLg0KPiA+
IE5vdyBmdWxseSB0ZXN0ZWQgb24gYm90aCBwbGF0Zm9ybXMuDQo+ID4NCj4gPiBjaGFuZ2VzIHNp
bmNlIHYxOg0KPiA+IC0gYWRkZWQgRml4ZXM6IHRhZw0KPiA+DQo+IA0KPiBQbGVhc2UgcHV0IHlv
dXIgY2hhbmdlbG9nIGJlbG93IHRoZSAtLS0NCj4gDQo+ID4gU2lnbmVkLW9mZi1ieTogUGFzY2Fs
IHZhbiBMZWV1d2VuIDxwdmFubGVldXdlbkB2ZXJpbWF0cml4LmNvbT4NCj4gPiAtLS0NCj4gPiAg
ZHJpdmVycy9jcnlwdG8vaW5zaWRlLXNlY3VyZS9zYWZleGNlbF9jaXBoZXIuYyB8IDUgKysrLS0N
Cj4gPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4g
Pg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9pbnNpZGUtc2VjdXJlL3NhZmV4Y2Vs
X2NpcGhlci5jIGIvZHJpdmVycy9jcnlwdG8vaW5zaWRlLQ0KPiBzZWN1cmUvc2FmZXhjZWxfY2lw
aGVyLmMNCj4gPiBpbmRleCA5OGY5ZmM2Li5jMDI5OTU2IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZl
cnMvY3J5cHRvL2luc2lkZS1zZWN1cmUvc2FmZXhjZWxfY2lwaGVyLmMNCj4gPiArKysgYi9kcml2
ZXJzL2NyeXB0by9pbnNpZGUtc2VjdXJlL3NhZmV4Y2VsX2NpcGhlci5jDQo+ID4gQEAgLTQwNSw3
ICs0MDUsOCBAQCBzdGF0aWMgaW50IHNhZmV4Y2VsX2FlYWRfc2V0a2V5KHN0cnVjdCBjcnlwdG9f
YWVhZCAqY3RmbSwgY29uc3QgdTgNCj4gKmtleSwNCj4gPg0KPiA+ICAgICAgICAgaWYgKHByaXYt
PmZsYWdzICYgRUlQMTk3X1RSQ19DQUNIRSAmJiBjdHgtPmJhc2UuY3R4cl9kbWEpIHsNCj4gPiAg
ICAgICAgICAgICAgICAgZm9yIChpID0gMDsgaSA8IGtleXMuZW5ja2V5bGVuIC8gc2l6ZW9mKHUz
Mik7IGkrKykgew0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIGlmIChsZTMyX3RvX2NwdShj
dHgtPmtleVtpXSkgIT0gYWVzLmtleV9lbmNbaV0pIHsNCj4gPiArICAgICAgICAgICAgICAgICAg
ICAgICBpZiAobGUzMl90b19jcHUoY3R4LT5rZXlbaV0pICE9DQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICgodTMyICopa2V5cy5lbmNrZXkpW2ldKSB7DQo+ID4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBjdHgtPmJhc2UubmVlZHNfaW52ID0gdHJ1ZTsNCj4gPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgIH0NCj4gPiBAQCAtNDU5LDcgKzQ2MCw3IEBAIHN0YXRpYyBpbnQgc2FmZXhjZWxfYWVh
ZF9zZXRrZXkoc3RydWN0IGNyeXB0b19hZWFkICpjdGZtLCBjb25zdCB1OA0KPiAqa2V5LA0KPiA+
DQo+ID4gICAgICAgICAvKiBOb3cgY29weSB0aGUga2V5cyBpbnRvIHRoZSBjb250ZXh0ICovDQo+
ID4gICAgICAgICBmb3IgKGkgPSAwOyBpIDwga2V5cy5lbmNrZXlsZW4gLyBzaXplb2YodTMyKTsg
aSsrKQ0KPiA+IC0gICAgICAgICAgICAgICBjdHgtPmtleVtpXSA9IGNwdV90b19sZTMyKGFlcy5r
ZXlfZW5jW2ldKTsNCj4gPiArICAgICAgICAgICAgICAgY3R4LT5rZXlbaV0gPSBjcHVfdG9fbGUz
MigoKHUzMiAqKWtleXMuZW5ja2V5KVtpXSk7DQo+ID4gICAgICAgICBjdHgtPmtleV9sZW4gPSBr
ZXlzLmVuY2tleWxlbjsNCj4gPg0KPiA+ICAgICAgICAgbWVtY3B5KGN0eC0+aXBhZCwgJmlzdGF0
ZS5zdGF0ZSwgY3R4LT5zdGF0ZV9zeik7DQo+ID4gLS0NCj4gPiAxLjguMy4xDQo+ID4NCg0KDQpS
ZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCwgTXVsdGkt
UHJvdG9jb2wgRW5naW5lcyBAIFZlcmltYXRyaXgNCnd3dy5pbnNpZGVzZWN1cmUuY29tDQoNCg==
