Return-Path: <SRS0=H1lS=EA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4C6C4363A
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 23:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13EDD223BD
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 23:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1420543AbgJYXX5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 25 Oct 2020 19:23:57 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:47475 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731177AbgJYXX4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Oct 2020 19:23:56 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-63-lT5RP1WqMKS6mc77jdOVTw-1; Sun, 25 Oct 2020 23:23:52 +0000
X-MC-Unique: lT5RP1WqMKS6mc77jdOVTw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 25 Oct 2020 23:23:52 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 25 Oct 2020 23:23:52 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arvind Sankar' <nivedita@alum.mit.edu>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
Subject: RE: [PATCH v4 6/6] crypto: lib/sha256 - Unroll LOAD and BLEND loops
Thread-Topic: [PATCH v4 6/6] crypto: lib/sha256 - Unroll LOAD and BLEND loops
Thread-Index: AQHWqtuIw2smrl1NBkSqLe7bNPuvsKmonqLggAAjnQCAADBjsA==
Date:   Sun, 25 Oct 2020 23:23:52 +0000
Message-ID: <5d8f86fcfe84441fa5c9877959069ff1@AcuMS.aculab.com>
References: <20201025143119.1054168-1-nivedita@alum.mit.edu>
 <20201025143119.1054168-7-nivedita@alum.mit.edu>
 <05150bdb3a4c4b2682ab9cb8fb2ed411@AcuMS.aculab.com>
 <20201025201820.GA1237388@rani.riverdale.lan>
In-Reply-To: <20201025201820.GA1237388@rani.riverdale.lan>
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

RnJvbTogQXJ2aW5kIFNhbmthcg0KPiBTZW50OiAyNSBPY3RvYmVyIDIwMjAgMjA6MTgNCj4gDQo+
IE9uIFN1biwgT2N0IDI1LCAyMDIwIGF0IDA2OjUxOjE4UE0gKzAwMDAsIERhdmlkIExhaWdodCB3
cm90ZToNCj4gPiBGcm9tOiBBcnZpbmQgU2Fua2FyDQo+ID4gPiBTZW50OiAyNSBPY3RvYmVyIDIw
MjAgMTQ6MzENCj4gPiA+DQo+ID4gPiBVbnJvbGxpbmcgdGhlIExPQUQgYW5kIEJMRU5EIGxvb3Bz
IGltcHJvdmVzIHBlcmZvcm1hbmNlIGJ5IH44JSBvbiB4ODZfNjQNCj4gPiA+ICh0ZXN0ZWQgb24g
QnJvYWR3ZWxsIFhlb24pIHdoaWxlIG5vdCBpbmNyZWFzaW5nIGNvZGUgc2l6ZSB0b28gbXVjaC4N
Cj4gPg0KPiA+IEkgY2FuJ3QgYmVsaWV2ZSB1bnJvbGxpbmcgdGhlIEJMRU5EIGxvb3AgbWFrZXMg
YW55IGRpZmZlcmVuY2UuDQo+IA0KPiBJdCdzIGFjdHVhbGx5IHRoZSBCTEVORCBsb29wIHRoYXQg
YWNjb3VudHMgZm9yIGFsbW9zdCBhbGwgb2YgdGhlDQo+IGRpZmZlcmVuY2UuIFRoZSBMT0FEIGxv
b3AgZG9lc24ndCBtYXR0ZXIgbXVjaCBpbiBnZW5lcmFsOiBldmVuIHJlcGxhY2luZw0KPiBpdCB3
aXRoIGEgcGxhaW4gbWVtY3B5KCkgb25seSBpbmNyZWFzZXMgcGVyZm9ybWFuY2UgYnkgMy00JS4g
QnV0DQo+IHVucm9sbGluZyBpdCBpcyBsb3cgY29zdCBpbiBjb2RlIHNpemUgdGVybXMsIGFuZCBj
bGFuZyBhY3R1YWxseSBkb2VzIGl0DQo+IHdpdGhvdXQgYmVpbmcgYXNrZWQuDQoNCihtZW1jcHkg
aXMgd3JvbmcgLSBtaXNzZXMgdGhlIGJ5dGUgc3dhcHMpLg0KDQpUaGF0J3Mgb2RkLCB0aGUgQkxF
TkQgbG9vcCBpcyBhYm91dCAyMCBpbnN0cnVjdGlvbnMuDQpJIHdvdWxkbid0IGV4cGVjdCB1bnJv
bGxpbmcgdG8gaGVscCAtIHVubGVzcyB5b3UgbWFuYWdlDQp0byB1c2UgMTYgcmVnaXN0ZXJzIGZv
ciB0aGUgYWN0aXZlIFdbXSB2YWx1ZXMuDQoNCj4gPiBXUlQgcGF0Y2ggNS4NCj4gPiBPbiB0aGUg
QzI3NTggdGhlIG9yaWdpbmFsIHVucm9sbGVkIGNvZGUgaXMgc2xpZ2h0bHkgZmFzdGVyLg0KPiA+
IE9uIHRoZSBpNy03NzAwIHRoZSA4IHVucm9sbCBpcyBhIGJpdCBmYXN0ZXIgJ2hvdCBjYWNoZScs
DQo+ID4gYnV0IHNsb3dlciAnY29sZCBjYWNoZScgLSBwcm9iYWJseSBiZWNhdXNlIG9mIHRoZSBk
LWNhY2hlDQo+ID4gbG9hZHMgZm9yIEtbXS4NCj4gPg0KPiA+IE5vbi14ODYgYXJjaGl0ZWN0dXJl
cyBtaWdodCBuZWVkIHRvIHVzZSBkLWNhY2hlIHJlYWRzIGZvcg0KPiA+IHRoZSAzMmJpdCAnSycg
Y29uc3RhbnRzIGV2ZW4gaW4gdGhlIHVucm9sbGVkIGxvb3AuDQo+ID4gWDg2IGNhbiB1c2UgJ2xl
YScgd2l0aCBhIDMyYml0IG9mZnNldCB0byBhdm9pZCBkYXRhIHJlYWRzLg0KPiA+IFNvIHRoZSBj
b2xkLWNhY2hlIGNhc2UgZm9yIHRoZSBvbGQgY29kZSBtYXkgYmUgc2ltaWxhci4NCj4gDQo+IE5v
dCBzdXJlIEkgZm9sbG93OiBpbiB0aGUgb2xkIGNvZGUsIHRoZSBLJ3MgYXJlIDMyLWJpdCBpbW1l
ZGlhdGVzLCBzbw0KPiB0aGV5IHNob3VsZCBjb21lIGZyb20gdGhlIGktY2FjaGUgd2hldGhlciBh
biBhZGQgb3IgYW4gbGVhIGlzIHVzZWQ/DQoNCkkgd2FzIHRoaW5raW5nIG9mIG90aGVyIGluc3Ry
dWN0aW9uIHNldHMgdGhhdCBlbmQgdXAgdXNpbmcgcGMtcmVsYXRpdmUNCmFkZHJlc3NpbmcgZm9y
IGNvbnN0YW50cy4NCk1pZ2h0IG9ubHkgaGFwcGVuIGZvciA2NGJpbnQgb25lcyB0aG91Z2guDQoN
Cj4gV2h5IGlzIHRoZSBjb2xkLWNhY2hlIGNhc2UgcmVsZXZhbnQgYW55d2F5PyBJZiB0aGUgY29k
ZSBpcyBvbmx5IGJlaW5nDQo+IGV4ZWN1dGVkIGEgY291cGxlIG9mIHRpbWVzIG9yIHNvLCBpLmUu
IHlvdSdyZSBoYXNoaW5nIGEgc2luZ2xlIHNheQ0KPiA2NC0xMjggYnl0ZSBpbnB1dCBvbmNlIGlu
IGEgYmx1ZSBtb29uLCB0aGUgcGVyZm9ybWFuY2Ugb2YgdGhlIGhhc2gNCj4gZG9lc24ndCByZWFs
bHkgbWF0dGVyLCBubz8NCg0KSSB3YXMgbWVhc3VyaW5nIHRoZSBjb2xkIGNhY2hlIG9uZSBiZWNh
dXNlIEkgY291bGQuDQpJIGRpZG4ndCBub3RlIHRoZSBhY3R1YWwgZmlndXJlcyBidXQgaXQgd2Fz
IDgtMTAgdGltZXMgc2xvd2VyDQp0aGF0IHRoZSBob3QtY2FjaGUgY2FzZS4NCldoaWxlIHNoYTI1
NiBpcyBsaWtlbHkgdG8gYmUgcnVuIGhvdC1jYWNoZSAob24gYSBiaWcgYnVmZmVyKQ0KdGhlIGNv
bGQtY2FjaGUgdGltaW5nIGFyZSBwcm9iYWJseSByZWxldmFudCBmb3IgdGhpbmdzIGxpa2UgbWVt
Y3B5KCkuDQpJIHJlbWVtYmVyIHNlZWluZyBhIHZlcnkgbG9uZyBkaXZpZGUgZnVuY3Rpb24gZm9y
IHNwYXJjMzIgdGhhdA0Kd2FzIHByb2JhYmx5IG9ubHkgYSBnYWluIGluIGEgYmVuY2htYXJrIGxv
b3AgLSBpdCB3b3VsZCBoYXZlDQpkaXNwbGFjZWQgYSBsb3Qgb2YgdGhlIHdvcmtpbmcgc2V0IGZy
b20gdGhlIGktY2FjaGUhDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNp
ZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsN
ClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

