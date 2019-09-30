Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BAE4C32792
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 21:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 381C1205C9
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 21:09:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="bf3WamBn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731305AbfI3VJR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 17:09:17 -0400
Received: from mail-eopbgr790048.outbound.protection.outlook.com ([40.107.79.48]:57055
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729740AbfI3VJR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 17:09:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKLJmUyJ0drRWYnDUsDdQrWt7JxmZ9iWsJ8t5AuxgKrzaoNCzxRjUAG3Pcwqtxrb8OvkMN1ToeaJlZqY07qfo53nSM2+sOe6cIG/iK65mqARGAGrcIsTrxxKCJpyEPzn9qQGp6PfCEf9L8RfBe47OnbBVVQWGnDaXJbHZfaXANI8mY1khpCt/SI5mX8vJgf3BXmeocrg4mqJ7iCCrbUt/TC4kX+ZimK2SCUY0hEJzoSWnxPt8bzo3VJdU/uLOOl4BKVAVCnJmaVe+3sTer3NKW1xVvuw7cxDRhFHI9O83txzCrHfYgZUZiAtCg7Y6nqwmqcTE95BOI85eTXKGAumuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+y9M0jU1NXQ3R4z7pId1oCPF70lJfJXoFsLro4kDx+Y=;
 b=A7apoVSCOD9rBgOXfSt130+9yiNXSF//wgFzs7v03qrToZYm61qFdUAp5WKL/NZdri8l3+PslLIcP9nNqpS9TyNMa8bY1aNKKSKMZHgjPMz48bzpe8VnI+83NpX0dc2H7ajFn0M7Vgrkd7p8umLO/D5v07ExGxV3nMtTPYwz7r9UMgPnbfr0OuGNNDFpAWkSX4+j097Obqn61T3dnVKTypEFA1LdFvYBsBq8oID2vDiWwon+nOfeYak7P8oriCpuQke1uOMWnWg4Sx6gHUsi90VRpfPpBEq4EKl0sUfaSlwDAAsb5PY8kt5DG61tD5xfYyNcIpP9YEEPV90bH4zslA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+y9M0jU1NXQ3R4z7pId1oCPF70lJfJXoFsLro4kDx+Y=;
 b=bf3WamBn1Ct+wy8VwOYzMY9J1mlAFYFGX+9Cyrw+IIWjk3bmGce0srhDZp+04gEzqjGvOQGm1/OA9vd+5zob+S/EB9uGjvpEU8UjO8QB2KBDuh+DcB9XhO5qjz1lTwGQ2PEOGn1OF7o2/VCEP/fsds5aCQdQV/kpnpoBqllwryU=
Received: from CH2PR20MB2968.namprd20.prod.outlook.com (10.255.156.33) by
 CH2PR20MB3143.namprd20.prod.outlook.com (52.132.230.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.22; Mon, 30 Sep 2019 21:09:10 +0000
Received: from CH2PR20MB2968.namprd20.prod.outlook.com
 ([fe80::e8b0:cb5f:268e:e3ae]) by CH2PR20MB2968.namprd20.prod.outlook.com
 ([fe80::e8b0:cb5f:268e:e3ae%5]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 21:09:10 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] crypto: inside-secure - Reduce stack usage
Thread-Topic: [PATCH 2/3] crypto: inside-secure - Reduce stack usage
Thread-Index: AQHVd4jLpZQEIOemw0ukUdKdGUz6fqdEp4sQgAAJNCA=
Date:   Mon, 30 Sep 2019 21:09:10 +0000
Message-ID: <CH2PR20MB29682E2C514733F290CFA3CECA820@CH2PR20MB2968.namprd20.prod.outlook.com>
References: <20190930121520.1388317-1-arnd@arndb.de>
 <20190930121520.1388317-2-arnd@arndb.de>
 <CH2PR20MB2968B7855D241C747BEB68B9CA820@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAK8P3a0PeocENP6c=ENVrq2X8x-vinM6qhPRDDi_WEf6y73AOQ@mail.gmail.com>
In-Reply-To: <CAK8P3a0PeocENP6c=ENVrq2X8x-vinM6qhPRDDi_WEf6y73AOQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8193124b-c623-48d5-1060-08d745ea703f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CH2PR20MB3143;
x-ms-traffictypediagnostic: CH2PR20MB3143:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CH2PR20MB3143B94EA50FEC5C2D1B8B90CA820@CH2PR20MB3143.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(366004)(376002)(136003)(346002)(52314003)(51444003)(13464003)(199004)(189003)(7736002)(5660300002)(256004)(55016002)(9686003)(33656002)(14444005)(7696005)(6116002)(76176011)(25786009)(99286004)(6436002)(2906002)(66476007)(66946007)(8936002)(14454004)(71190400001)(3846002)(66066001)(8676002)(81156014)(76116006)(81166006)(316002)(6916009)(71200400001)(15974865002)(478600001)(54906003)(305945005)(74316002)(4326008)(229853002)(86362001)(476003)(486006)(446003)(6246003)(52536014)(26005)(66446008)(64756008)(66556008)(6506007)(11346002)(186003)(102836004)(53546011)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR20MB3143;H:CH2PR20MB2968.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9z+InvQ8lCN3oZyshQ2PhAUn8F+eIPHlYxGuo8LYCbLy8agS70129SwCEmAPJrsHsm9zn9o2aTQDjbieqNEzUUmjX+EEA3pFdwTT1WbRJfGL7LK9Sz/cwMiH+LloyVilv/mOIMec6MWO9FIui77DY9khGmoRcO5OvGJ1bBJ1R/a7sD6zbp1NnfdGbIcp678uNdDu7E3nCJgdYES43Ojr1MVZmiX5OhZrdS+fHxaOrw2wso/L8AppiGSp2d8emhku7KI43t3zAPWrvu3N6ukI7jMk5+GEnwutKidpDNxB12+H5mOPSKE72uTeebuSK5mKTIYLIQeDomocMRkKg1L3uiu3+8M8p2pd/l76i4IbIyEARN9x52onGlb/2ET4paYITcqHQAzL1nq93iQOoHmlTyqQl0LLiMwWFO7O4lalmWE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8193124b-c623-48d5-1060-08d745ea703f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 21:09:10.3489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bex8wGR454iLhzcCCFVFOc3BXhyAE/q7EEGDniyd94LNHmnC84v4SpkYblrKsGxtnEkRvhaJMzqSMhdjj2Lw43u4Z2can/oGX2M0O1CvZQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR20MB3143
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBcm5kIEJlcmdtYW5uIDxhcm5k
QGFybmRiLmRlPg0KPiBTZW50OiBNb25kYXksIFNlcHRlbWJlciAzMCwgMjAxOSAxMDoxMiBQTQ0K
PiBUbzogUGFzY2FsIFZhbiBMZWV1d2VuIDxwdmFubGVldXdlbkB2ZXJpbWF0cml4LmNvbT4NCj4g
Q2M6IEFudG9pbmUgVGVuYXJ0IDxhbnRvaW5lLnRlbmFydEBib290bGluLmNvbT47IEhlcmJlcnQg
WHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47DQo+IERhdmlkIFMuIE1pbGxlciA8ZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldD47IFBhc2NhbCB2YW4gTGVldXdlbiA8cGFzY2FsdmFubEBnbWFpbC5j
b20+OyBBcmQNCj4gQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJvLm9yZz47IEVyaWMg
QmlnZ2VycyA8ZWJpZ2dlcnNAZ29vZ2xlLmNvbT47IGxpbnV4LQ0KPiBjcnlwdG9Admdlci5rZXJu
ZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggMi8zXSBjcnlwdG86IGluc2lkZS1zZWN1cmUgLSBSZWR1Y2Ugc3RhY2sgdXNhZ2UNCj4gDQo+
IE9uIE1vbiwgU2VwIDMwLCAyMDE5IGF0IDk6MDQgUE0gUGFzY2FsIFZhbiBMZWV1d2VuDQo+IDxw
dmFubGVldXdlbkB2ZXJpbWF0cml4LmNvbT4gd3JvdGU6DQo+IA0KPiA+ID4gQWx0ZXJuYXRpdmVs
eSwgaXQgc2hvdWxkIGJlIHBvc3NpYmxlIHRvIHNocmluayB0aGVzZSBhbGxvY2F0aW9ucw0KPiA+
ID4gYXMgdGhlIGV4dHJhIGJ1ZmZlcnMgYXBwZWFyIHRvIGJlIGxhcmdlbHkgdW5uZWNlc3Nhcnks
IGJ1dCBkb2luZw0KPiA+ID4gdGhpcyB3b3VsZCBiZSBhIG11Y2ggbW9yZSBpbnZhc2l2ZSBjaGFu
Z2UuDQo+ID4gPg0KPiA+IEFjdHVhbGx5LCBmb3IgSE1BQy1TSEE1MTIgeW91IERPIG5lZWQgYWxs
IHRoYXQgYnVmZmVyIHNwYWNlLg0KPiA+IFlvdSBjb3VsZCBzaHJpbmsgaXQgdG8gMiAqIGN0eC0+
c3RhdGVfc3ogYnV0IHRoZW4geW91ciBzaW1wbGUgaW5kZXhpbmcNCj4gPiBpcyBubyBsb25nZXIg
Z29pbmcgdG8gZmx5LiBOb3Qgc3VyZSBpZiB0aGF0IHdvdWxkIGJlIHdvcnRoIHRoZSBlZmZvcnQu
DQo+IA0KPiBTdGFjayBhbGxvY2F0aW9ucyBjYW4gbm8gbG9uZ2VyIGJlIGR5bmFtaWNhbGx5IHNp
emVkIGluIHRoZSBrZXJuZWwsDQo+IHNvIHRoYXQgd291bGQgbm90IHdvcmsuDQo+IA0KSSB3YXMg
YWN0dWFsbHkgcmVmZXJyaW5nIHRvIHlvdXIga3phbGxvYywgbm90IHRvIHRoZSBvcmlnaW5hbCBz
dGFjaw0KYmFzZWQgaW1wbGVtZW50YXRpb24gLi4uDQoNCj4gV2hhdCBJIG5vdGljZWQgdGhvdWdo
IGlzIHRoYXQgdGhlIGxhcmdlc3QgcGFydCBvZiBzYWZleGNlbF9haGFzaF9leHBvcnRfc3RhdGUN
Cj4gaXMgdXNlZCBpbiB0aGUgJ2NhY2hlJyBtZW1iZXIsIGFuZCB0aGlzIGlzIGFwcGFyZW50bHkg
b25seSByZWZlcmVuY2VkIGluc2lkZSBvZg0KPiBzYWZleGNlbF9obWFjX2luaXRfaXYsIHdoaWNo
IHlvdSBjYWxsIHR3aWNlLiBJZiB0aGF0IGNhY2hlIGNhbiBiZSBhbGxvY2F0ZWQNCj4gb25seSBv
bmNlLCB5b3Ugc2F2ZSBTSEE1MTJfQkxPQ0tfU0laRSBieXRlcyBpbiBvbmUgb2YgdGhlIHR3byBw
YXRocy4NCj4gDQpXZWxsIC4uLiBobW1tIC4uLiAibXkiLi4uIFRoaXMgaXMgbm90IG9yaWdpbmFs
bHkgIm15IiBjb2RlLiBBbmQgdW50aWwgeW91DQpicm91Z2h0IHRoaXMgdXAsIEkgZGlkIG5vdCBm
dWxseSByZWFsaXNlIGl0IHdhcyB1c2luZyB0aGlzIGV4cG9ydF9zdGF0ZQ0Kc3RydWN0IHRvIHN0
b3JlIHRob3NlIGRpZ2VzdHMuIFNlZW1zIHRvIGhhdmUgc29tZXRoaW5nIHRvIGRvIHdpdGggZGly
ZWN0bHkNCnRha2luZyB0aGUgY3J5cHRvX2FoYXNoX2V4cG9ydCBzdGF0ZSBvdXRwdXQsIHdoaWNo
IGlzIG11Y2ggbW9yZSB0aGFuIHRoYXQsDQppbiBjYXNlIHlvdSBuZWVkIHRvIGNvbnRpbnVlIHRo
ZSBoYXNoICh3aGljaCB5b3UgZG9uJ3QgaGVyZSkuDQoNCkkgZ3Vlc3MgeW91IG5lZWQgdG8gImNh
dGNoIiB0aGF0IG91dHB1dCBzb21ld2hlcmUsIHNvIHByb2JhYmx5IHlvdSBjb3VsZA0Kc2F2ZSBh
IGJpdCBvZiBtZW1vcnkgYnV0IEkgZG91YnQgaXQgd291bGQgYmUgYSBzaWduaWZpY2FudCBpbXBy
b3ZlbWVudC4NCg0KPiA+IEkgZG9uJ3QgbGlrZSB0aGUgcGFydCB3aGVyZSB5b3UgZHluYW1pY2Fs
bHkgYWxsb2NhdGUgdGhlIGNyeXRvX2Flc19jdHgNCj4gPiB0aG91Z2gsIEkgdGhpbmsgdGhhdCB3
YXMgbm90IG5lY2Vzc2FyeSBjb25zaWRlcmluZyBpdHMgYSBsb3Qgc21hbGxlci4NCj4gDQo+IEkg
Y291bnQgNDg0IGJ5dGVzIGZvciBpdCwgd2hpY2ggaXMgcmVhbGx5IGxhcmdlLg0KPiANCk1heWJl
IEkgc2hvdWxkJ3ZlIGNvdW50ZWQgbXlzZWxmIC4uLiB0b3RhbGx5IHVuZXhwZWN0ZWRseSBodWdl
LiBXaHk/Pw0KQW55d2F5LCBnbGFkIEkgZ290IHJpZCBvZiBpdCBhbHJlYWR5IHRoZW4uDQoNCj4g
PiBBbmQgaXQgY29uZmxpY3RzIHdpdGggYW5vdGhlciBjaGFuZ2UgSSBoYXZlIHdhaXRpbmcgdGhh
dCBnZXRzIHJpZCBvZg0KPiA+IGFlc19leHBhbmRrZXkgYW5kIHRoYXQgc3RydWN0IGFsbHRvZ2V0
aGVyIChzaW5jZSBpdCB3YXMgcmVhbGx5IGp1c3QNCj4gPiBhYnVzZWQgdG8gZG8gYSBrZXkgc2l6
ZSBjaGVjaywgd2hpY2ggd2FzIHZlcnkgd2FzdGVmdWwgc2luY2UgdGhlDQo+ID4gZnVuY3Rpb24g
YWN0dWFsbHkgZ2VuZXJhdGVzIGFsbCByb3VuZGtleXMgd2UgZG9uJ3QgbmVlZCBhdCBhbGwgLi4u
KQ0KPiANCj4gUmlnaHQsIHRoaXMgaXMgd2hhdCBJIG5vdGljZWQgdGhlcmUuIFdpdGggNDgwIG9m
IHRoZSA0ODQgYnl0ZXMgZ29uZSwNCj4geW91IGFyZSB3ZWxsIGJlbG93IHRoZSB3YXJuaW5nIGxp
bWl0IGV2ZW4gd2l0aG91dCB0aGUgb3RoZXIgY2hhbmdlLg0KPiANCkFuZCBieSAib3RoZXIgY2hh
bmdlIiB5b3UgbWVhbiB0aGUgc2FmZXhjZWxfYWhhc2hfZXhwb3J0X3N0YXRlPw0KT2ssIGdvb2Qg
dG8ga25vd24sIGFsdGhvdWdoIEkgZG8gbGlrZSB0byBpbXByb3ZlIHRoYXQgb25lIGFzIHdlbGws
DQpidXQgcHJlZmVyYWJseSBieSBub3QgZXhwb3J0aW5nIHRoZSBjYWNoZSBzbyBJIGRvbid0IG5l
ZWQgdGhlIGZ1bGwNCnN0cnVjdC4NCg0KUmVnYXJkcywNClBhc2NhbCB2YW4gTGVldXdlbg0KU2ls
aWNvbiBJUCBBcmNoaXRlY3QsIE11bHRpLVByb3RvY29sIEVuZ2luZXMgQCBWZXJpbWF0cml4DQp3
d3cuaW5zaWRlc2VjdXJlLmNvbQ0KDQo=
