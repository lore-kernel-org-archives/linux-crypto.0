Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4553C4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 10:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ACDE222EC
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 10:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769059AbgJZKHb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 06:07:31 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:57778 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1769062AbgJZKGZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 06:06:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-123-FRXv3T00OYCnRUjgXufYdQ-1; Mon, 26 Oct 2020 10:06:22 +0000
X-MC-Unique: FRXv3T00OYCnRUjgXufYdQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 26 Oct 2020 10:06:21 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 26 Oct 2020 10:06:21 +0000
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
Thread-Index: AQHWqtuIw2smrl1NBkSqLe7bNPuvsKmonqLggAAjnQCAADBjsIAAC9GAgAClsAA=
Date:   Mon, 26 Oct 2020 10:06:21 +0000
Message-ID: <0f039c0c94a64b329d09ae4a18261ba4@AcuMS.aculab.com>
References: <20201025143119.1054168-1-nivedita@alum.mit.edu>
 <20201025143119.1054168-7-nivedita@alum.mit.edu>
 <05150bdb3a4c4b2682ab9cb8fb2ed411@AcuMS.aculab.com>
 <20201025201820.GA1237388@rani.riverdale.lan>
 <5d8f86fcfe84441fa5c9877959069ff1@AcuMS.aculab.com>
 <20201025235349.GA1281192@rani.riverdale.lan>
In-Reply-To: <20201025235349.GA1281192@rani.riverdale.lan>
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

RnJvbTogQXJ2aW5kIFNhbmthcg0KPiBTZW50OiAyNSBPY3RvYmVyIDIwMjAgMjM6NTQNCi4uLg0K
PiA+IFRoYXQncyBvZGQsIHRoZSBCTEVORCBsb29wIGlzIGFib3V0IDIwIGluc3RydWN0aW9ucy4N
Cj4gPiBJIHdvdWxkbid0IGV4cGVjdCB1bnJvbGxpbmcgdG8gaGVscCAtIHVubGVzcyB5b3UgbWFu
YWdlDQo+ID4gdG8gdXNlIDE2IHJlZ2lzdGVycyBmb3IgdGhlIGFjdGl2ZSBXW10gdmFsdWVzLg0K
PiA+DQo+IA0KPiBJIGFtIG5vdCBzdXJlIGFib3V0IHdoYXQncyBnb2luZyBvbiBpbnNpZGUgdGhl
IGhhcmR3YXJlLCBidXQgZXZlbiB3aXRoDQo+IGEgc3RyYWlnaHRmb3J3YXJkIGFzc2VtYmx5IHZl
cnNpb24gdGhhdCBqdXN0IHJlYWRzIG91dCBvZiBtZW1vcnkgdGhlIHdheQ0KPiB0aGUgY2FsY3Vs
YXRpb24gaXMgc3BlY2lmaWVkLCB1bnJvbGxpbmcgdGhlIEJMRU5EIGxvb3AgOHggc3BlZWRzIHVw
IHRoZQ0KPiBwZXJmb3JtYW5jZSBieSA3LTglLg0KPiANCj4gVGhlIGNvbXBpbGVyIGlzIGFjdHVh
bGx5IHByZXR0eSBiYWQgaGVyZSwganVzdCB0cmFuc2xhdGluZyBldmVyeXRoaW5nDQo+IGludG8g
YXNzZW1ibGVyIHdpdGggbm8gYXR0ZW1wdCB0byBvcHRpbWl6ZSBhbnl0aGluZyBnZXRzIGEgMTAt
MTIlDQo+IHNwZWVkdXAgb3ZlciB0aGUgQyB2ZXJzaW9uLg0KDQpJJ20gbm90IHNlZWluZyBhbnl0
aGluZyBwYXJ0aWN1bGFybHkgc3R1cGlkLg0KVGhlIGxvb3AgYm9keSAoZXhjbHVkaW5nIGxvb3Ag
Y29udHJvbCkgaXMgMjMgaW5zdHJ1Y3Rpb25zLg0KRG91YmxlcyB0byA0NiBpZiBJIHVucm9sbCBv
bmNlLg0KVW5yb2xsaW5nIDQgdGltZXMgZG9lcyBzYXZlIGEgY291cGxlIG9mIGluc3RydWN0aW9u
cyBwZXIgaXRlcmF0aW9uLg0KDQpUaGUgb25seSBob3JyaWQgcGFydCBvZiB0aGUgY29kZSBpcyB0
aGUgbG9uZyBkZXBlbmRlbmN5DQpjaGFpbiBhdCB0aGUgZW5kIHdoZW4gdGhlIHZhbHVlcyBnZXQg
eG9yJ2VkIHRvZ2V0aGVyLg0KZ2NjIGlzIHZlcnkgYmFkIGF0IHRoYXQsIGl0IGNvbnZlcnRzIChh
ICsgYikgKyAoYyArIGQpDQp0byAoKChhICsgYikgKyBjKSArIGQpIHdoaWNoIHRha2VzIGFuIGV4
dHJhIGNsb2NrLg0KDQpVbnJvbGxpbmcgNCB0aW1lcyBnaXZlcyBhbG1vc3QgYWxsIHRoZSBnYWlu
Lg0KQnV0IGl0IHJlYWxseSBzaG91bGRuJ3QgYmUgbmVlZGVkIGF0IGFsbC4NCg0KCURhdmlkDQoN
Ci0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJt
LCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChX
YWxlcykNCg==

