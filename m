From: Radu Solea <radu.solea@nxp.com>
Subject: Re: [RFC PATCH] gcm - fix setkey cache coherence issues
Date: Fri, 23 Jun 2017 07:33:20 +0000
Message-ID: <1498203199.26231.21.camel@nxp.com>
References: <1498055361-12493-1-git-send-email-radu.solea@nxp.com>
         <20170622024051.GA24529@gondor.apana.org.au>
         <DB6PR04MB317607AE27DD1AC235D0103C8BDB0@DB6PR04MB3176.eurprd04.prod.outlook.com>
         <20170622075338.GA25314@gondor.apana.org.au>
         <1498139799.26231.10.camel@nxp.com>
         <20170623063154.GA29002@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        =?utf-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@nxp.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr40066.outbound.protection.outlook.com ([40.107.4.66]:13418
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753374AbdFWHdZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 03:33:25 -0400
In-Reply-To: <20170623063154.GA29002@gondor.apana.org.au>
Content-Language: en-US
Content-ID: <7519C25382CFBC4892568D980E8D4225@eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

T24gVmksIDIwMTctMDYtMjMgYXQgMTQ6MzEgKzA4MDAsIEhlcmJlcnQgWHUgd3JvdGU6DQo+IA0K
PiBUaGUgY3J5cHRvIEFQSSBjYW5ub3QgcmVseSBvbiB1c2VycyBwcm92aWRpbmcgYWxpZ25lZCBi
dWZmZXJzLsKgwqBTbw0KPiBpZiB5b3VyIGRyaXZlciBoYXMgYW4gYWxpZ25tZW50IHJlcXVpcmVt
ZW50LCBpdCBlaXRoZXIgaGFzIHRvIHVzZQ0KPiB0aGUgZXhpc3RpbmcgY3J5cHRvIEFQSSBhbGln
bm1hc2sgc2V0dGluZyB3aGljaCBjYW4gY29wZSB3aXRoIHNvbWUNCj4gdW5hbGlnbmVkIGlucHV0
cywgZS5nLiwgdGhlIElWIGlmIHlvdSB1c2UgdGhlIHNrY2lwaGVyIHdhbGsNCj4gbWVjaGFuaXNt
LA0KPiBvciB5b3UgbXVzdCBjb3B5IHVuYWxpZ25lZCBkYXRhIHlvdXJzZWxmIGJlZm9yZSBwZXJm
b3JtaW5nIERNQSBvbg0KPiB0aGVtLg0KPiANCj4gQ2hlZXJzLA0KDQpOb3JtYWxseSBJIHdvdWxk
IGFncmVlIHdpdGggeW91LCBpZiBpdCdzIGEgd2VpcmQgcmVxdWlyZW1lbnQgY29taW5nDQpmcm9t
IGhhcmR3YXJlIG9yIGRyaXZlci4gSW4gdGhpcyBjYXNlIEkgdGhpbmsgaXQncyBkaWZmZXJlbnQu
IFRoaXMgaXMNCm5vdCBhIGxpbWl0YXRpb24gY29taW5nIGZyb20gb25lIGRyaXZlciBvciBvbmUg
cGFydGljdWxhciBoYXJkd2FyZQ0KdmFyaWV0eS4gSXQgYXBwbGllcyB0byBhbGwgcGxhdGZvcm1z
IHRoYXQgZG8gbm90IGhhdmUgaHcgY2FjaGUNCmNvaGVyZW5jZSBhbmQgYSBsYXJnZSBlbm91Z2gg
Y2FjaGVsaW5lLg0KwqANCkEgY291cGxlIG9mIGxpbmVzIGJlbG93IHRoZSBhbGxvY2F0aW9uIGhh
c2ggaXMgbGlua2VkIGludG8gYQ0Kc2NhdHRlcmxpc3QsIGEgZGF0YSBzdHJ1Y3R1cmUgd2l0aCBy
ZW1hcmthYmx5IGhpZ2ggY2hhbmNlcyBvZiBlbmRpbmcgdXANCmluIGEgRE1BIGVuZHBvaW50LCB5
ZXQgd2UgY2hvb3NlIHRvIGlnbm9yZSBhbGwgb3RoZXIgRE1BIHJlcXVpcmVtZW50cz8NCg0KQ2hl
ZXJzLA0KUmFkdS4=
