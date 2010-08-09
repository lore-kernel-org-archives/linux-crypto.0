From: David Miller <davem@davemloft.net>
Subject: n2 RNG driver bogus cast removal
Date: Mon, 09 Aug 2010 00:45:14 -0700 (PDT)
Message-ID: <20100809.004514.73697921.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: segooon@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53228
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab0HIHoz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Aug 2010 03:44:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

DQpLdWxpa292LCBjYW4geW91IGF0IGxlYXN0IGJ1aWxkIHRlc3QgeW91ciBwYXRjaGVzPyAgQ2Fz
dHMgYXJlIG5vdA0KYWx3YXlzIGluY29ycmVjdCwgcGFydGljdWxhcmx5IHdoZW4gcHJpdmF0ZSBj
b29raWVzIGFyZSAidW5zaWduZWQNCmxvbmciIGFzIGlzIHRoZSBjYXNlIGhlcmU6DQoNCmRyaXZl
cnMvY2hhci9od19yYW5kb20vbjItZHJ2LmM6IEluIGZ1bmN0aW9uIKFuMnJuZ19kYXRhX3JlYWSi
Og0KZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9uMi1kcnYuYzozOTA6IHdhcm5pbmc6IGluaXRpYWxp
emF0aW9uIG1ha2VzIHBvaW50ZXIgZnJvbSBpbnRlZ2VyIHdpdGhvdXQgYSBjYXN0DQoNCkhlcmJl
cnQsIHBsZWFzZSByZXZlcnQgdGhpcyBjaGFuZ2UsIHRoYW5rcy4gIEFuZCBJIHN1c3BlY3QgdGhl
cmUNCm1pZ2h0IGJlIG1vcmUgb2YgdGhlc2UgaHdybmcgZHJpdmVyIGR1ZHMgdGhhdCB3ZW50IGlu
dG8gdGhlIHRyZWUsDQppdCdzIHdvcnRoIGNoZWNraW5nIG91dC4gOi0pDQoNClRoYW5rcy4NCg0K
Y29tbWl0IDhiOWNmZGNhOWM1MmY3ZDM5YzNjY2ZhYzE2NjhlMzFjMjBjOWY0MmUNCkF1dGhvcjog
S3VsaWtvdiBWYXNpbGl5IDxzZWdvb29uQGdtYWlsLmNvbT4NCkRhdGU6ICAgTW9uIEp1bCA1IDIx
OjI1OjA2IDIwMTAgKzA4MDANCg0KICAgIGh3cm5nOiBuMi1kcnYgLSByZW1vdmUgY2FzdHMgZnJv
bSB2b2lkKg0KICAgIA0KICAgIFJlbW92ZSB1bm5lc2Vzc2FyeSBjYXN0cyBmcm9tIHZvaWQqLg0K
ICAgIA0KICAgIFNpZ25lZC1vZmYtYnk6IEt1bGlrb3YgVmFzaWxpeSA8c2Vnb29vbkBnbWFpbC5j
b20+DQogICAgU2lnbmVkLW9mZi1ieTogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEu
b3JnLmF1Pg0KDQo=
