Return-Path: <SRS0=SXL7=D3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01446C4363D
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 14:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B371D21741
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 14:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgJTOzx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Oct 2020 10:55:53 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:42355 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393570AbgJTOzw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Oct 2020 10:55:52 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-57-xS59UY4nNimTtYgwsOO0kw-1; Tue, 20 Oct 2020 15:55:48 +0100
X-MC-Unique: xS59UY4nNimTtYgwsOO0kw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 20 Oct 2020 15:55:47 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 20 Oct 2020 15:55:47 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arvind Sankar' <nivedita@alum.mit.edu>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/5] crypto: lib/sha256 - Unroll SHA256 loop 8 times
 intead of 64
Thread-Topic: [PATCH 4/5] crypto: lib/sha256 - Unroll SHA256 loop 8 times
 intead of 64
Thread-Index: AQHWpizLtR2ktKloi0KILMfFeYMjdqmgGc8ggABdwQCAABu2AA==
Date:   Tue, 20 Oct 2020 14:55:47 +0000
Message-ID: <6ee12f8fa3914fbcb5e4a1388e430acd@AcuMS.aculab.com>
References: <20201019153016.2698303-1-nivedita@alum.mit.edu>
 <20201019153016.2698303-5-nivedita@alum.mit.edu>
 <1324eb3519d54ddd9469d30a94c11823@AcuMS.aculab.com>
 <20201020140726.GB2996696@rani.riverdale.lan>
In-Reply-To: <20201020140726.GB2996696@rani.riverdale.lan>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RnJvbTogQXJ2aW5kIFNhbmthcg0KPiBTZW50OiAyMCBPY3RvYmVyIDIwMjAgMTU6MDcNCj4gVG86
IERhdmlkIExhaWdodCA8RGF2aWQuTGFpZ2h0QEFDVUxBQi5DT00+DQo+IA0KPiBPbiBUdWUsIE9j
dCAyMCwgMjAyMCBhdCAwNzo0MTozM0FNICswMDAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4g
RnJvbTogQXJ2aW5kIFNhbmthcj4gU2VudDogMTkgT2N0b2JlciAyMDIwIDE2OjMwDQo+ID4gPiBU
bzogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1PjsgRGF2aWQgUy4gTWls
bGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgbGludXgtDQo+ID4gPiBjcnlwdG9Admdlci5rZXJu
ZWwub3JnDQo+ID4gPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gU3Vi
amVjdDogW1BBVENIIDQvNV0gY3J5cHRvOiBsaWIvc2hhMjU2IC0gVW5yb2xsIFNIQTI1NiBsb29w
IDggdGltZXMgaW50ZWFkIG9mIDY0DQo+ID4gPg0KPiA+ID4gVGhpcyByZWR1Y2VzIGNvZGUgc2l6
ZSBzdWJzdGFudGlhbGx5IChvbiB4ODZfNjQgd2l0aCBnY2MtMTAgdGhlIHNpemUgb2YNCj4gPiA+
IHNoYTI1Nl91cGRhdGUoKSBnb2VzIGZyb20gNzU5MyBieXRlcyB0byAxOTUyIGJ5dGVzIGluY2x1
ZGluZyB0aGUgbmV3DQo+ID4gPiBTSEEyNTZfSyBhcnJheSksIGFuZCBvbiB4ODYgaXMgc2xpZ2h0
bHkgZmFzdGVyIHRoYW4gdGhlIGZ1bGwgdW5yb2xsLg0KPiA+DQo+ID4gVGhlIHNwZWVkIHdpbGwg
ZGVwZW5kIG9uIGV4YWN0bHkgd2hpY2ggY3B1IHR5cGUgaXMgdXNlZC4NCj4gPiBJdCBpcyBldmVu
IHBvc3NpYmxlIHRoYXQgdGhlICdub3QgdW5yb2xsZWQgYXQgYWxsJyBsb29wDQo+ID4gKHdpdGgg
dGhlIGFsbCB0aGUgZXh0cmEgcmVnaXN0ZXIgbW92ZXMpIGlzIGZhc3RlciBvbiBzb21lIHg4Ni02
NCBjcHUuDQo+IA0KPiBZZXMsIEkgc2hvdWxkIGhhdmUgbWVudGlvbmVkIHRoaXMgd2FzIHRlc3Rl
ZCBvbiBhIEJyb2Fkd2VsbCBYZW9uLCBhdA0KPiBsZWFzdCBvbiB0aGF0IHByb2Nlc3Nvciwgbm8g
dW5yb2xsaW5nIGlzIGEgbWVhc3VyYWJsZSBwZXJmb3JtYW5jZSBsb3NzLg0KPiBCdXQgdGhlIGhv
cGUgaXMgdGhhdCA4eCB1bnJvbGwgc2hvdWxkIGJlIGdlbmVyYWxseSBlbm91Z2ggdW5yb2xsaW5n
IHRoYXQNCj4gNjR4IGlzIHVubGlrZWx5IHRvIHNwZWVkIGl0IHVwIG1vcmUsIGFuZCBzbyBoYXMg
bm8gYWR2YW50YWdlIG92ZXIgOHguDQoNCihJJ3ZlIGp1c3QgbG9va2VkIGF0IHRoZSBhY3R1YWwg
Y29kZSwgbm90IGp1c3QgdGhlIHBhdGNoLikNCg0KWWVzIEkgZG91YnQgdGhlIDY0eCB1bnJvbGwg
d2FzIGV2ZXIgYSBzaWduaWZpY2FudCBnYWluLg0KVW5yb2xsaW5nIGNvbXBsZXRlbHkgcmVxdWly
ZXMgYSBsb2FkIG9mIHJlZ2lzdGVyIG1vdmVzL3JlbmFtZXM7DQpwcm9iYWJseSB0b28gbWFueSB0
byBiZSAnemVybyBjb3N0Jy4NCg0KV2l0aCBtb2Rlcm4gY3B1IHlvdSBjYW4gb2Z0ZW4gZ2V0IHRo
ZSBsb29wIGNvbnRyb2wgaW5zdHJ1Y3Rpb25zDQonZm9yIGZyZWUnIHNvIHVucm9sbGluZyBqdXN0
IGtpbGxzIHRoZSBJLWNhY2hlLg0KU29tZSBvZiB0aGUgY3B1IGhhdmUgbG9vcCBidWZmZXJzIGZv
ciBkZWNvZGVkIGluc3RydWN0aW9ucywNCnVucm9sbCBiZXlvbmQgdGhhdCBzaXplIGFuZCB5b3Ug
c3VkZGVubHkgZ2V0IHRoZSBkZWNvZGVyIGNvc3RzDQpoaXR0aW5nIHlvdSBhZ2Fpbi4NCg0KLi4u
DQo+ID4gSWYgeW91IGNhbiBwdXQgU0hBMjU2X0tbXSBhbmQgV1tdIGludG8gYSBzdHJ1Y3QgdGhl
biB0aGUNCj4gPiBjb21waWxlciBjYW4gdXNlIHRoZSBzYW1lIHJlZ2lzdGVyIHRvIGFkZHJlc3Mg
aW50byBib3RoDQo+ID4gYXJyYXlzICh1c2luZyBhbiBvZmZzZXQgb2YgNjQqNCBmb3IgdGhlIHNl
Y29uZCBvbmUpLg0KPiA+IChpZSBrZWVwIHRoZSB0d28gYXJyYXlzLCBub3QgYW4gYXJyYXkgb2Yg
c3RydWN0KS4NCj4gPiBUaGlzIHNob3VsZCByZWR1Y2UgdGhlIHJlZ2lzdGVyIHByZXNzdXJlIHNs
aWdodGx5Lg0KPiANCj4gSSBjYW4gdHJ5IHRoYXQsIGNvdWxkIGNvcHkgdGhlIGRhdGEgaW4gc2hh
MjU2X3VwZGF0ZSgpIHNvIGl0J3MgYW1vcnRpemVkDQo+IG92ZXIgdGhlIHdob2xlIGlucHV0Lg0K
DQpIYXZpbmcgbG9va2VkIG1vcmUgY2xvc2VseSB0aGUgZXh0cmEgY29weSBuZWVkZWQgaXMgcHJv
YmFibHkNCmJpZ2dlciB0aGFuIGFueSBzYXZpbmcuDQoNCldoYXQgdGhhdCBjb2RlIG5lZWRzIGlz
IHNvbWUgc3BlY2lhbCAzLWlucHV0IGluc3RydWN0aW9ucyA6LSkNCkl0IHdvdWxkIHdvcmsgYSBs
b3QgYmV0dGVyIHdyaXR0ZW4gaW4gVkhETCBmb3IgYW4gZnBnYS4NCg0KCURhdmlkDQoNCi0NClJl
Z2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0
b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykN
Cg==

