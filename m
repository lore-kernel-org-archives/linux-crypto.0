From: "Wang, Shane" <shane.wang@intel.com>
Subject: RE: [PATCH] to fix vmac test fails on s390
Date: Tue, 16 Mar 2010 13:25:54 +0800
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A1D4B5168@shsmsx501.ccr.corp.intel.com>
References: <1263477930.5880.22.camel@bender>
 <20100117110546.GA32690@gondor.apana.org.au>
 <6CADD16F56BC954D8E28F3836FA7ED71282AC1E357@shzsmsx501.ccr.corp.intel.com>
 <20100221182722.GB11951@Chamillionaire.breakpoint.cc>
 <6CADD16F56BC954D8E28F3836FA7ED71282AC1E58F@shzsmsx501.ccr.corp.intel.com>
 <20100302135706.GA3522@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Cc: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	Jan Glauber <jang@linux.vnet.ibm.com>,
	"Cihula, Joseph" <joseph.cihula@intel.com>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58269 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab0CPF0N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Mar 2010 01:26:13 -0400
In-Reply-To: <20100302135706.GA3522@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

VGhhdCBzaG91bGQgYmUgc2ltcGxlciBhbmQgYmV0dGVyLg0KDQpUaGFua3MuDQpTaGFuZQ0KDQot
LS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSGVyYmVydCBYdSBbbWFpbHRvOmhlcmJl
cnRAZ29uZG9yLmFwYW5hLm9yZy5hdV0gDQpTZW50OiAyMDEwxOoz1MIyyNUgMjE6NTcNClRvOiBX
YW5nLCBTaGFuZQ0KQ2M6IFNlYmFzdGlhbiBBbmRyemVqIFNpZXdpb3I7IEphbiBHbGF1YmVyOyBD
aWh1bGEsIEpvc2VwaDsgbGludXgtY3J5cHRvDQpTdWJqZWN0OiBSZTogW1BBVENIXSB0byBmaXgg
dm1hYyB0ZXN0IGZhaWxzIG9uIHMzOTANCg0KT24gTW9uLCBGZWIgMjIsIDIwMTAgYXQgMTE6MjE6
MDRBTSArMDgwMCwgV2FuZywgU2hhbmUgd3JvdGU6DQo+DQo+IEBAIC00NzQsNyArNDc1LDEwIEBA
IHN0YXRpYyB1NjQgdm1hYyh1bnNpZ25lZCBjaGFyIG1bXSwgdW5zaWcNCj4gIAl9DQo+ICAJcCA9
IGJlNjRfdG9fY3B1cChvdXRfcCArIGkpOw0KPiAgCWggPSB2aGFzaChtLCBtYnl0ZXMsICh1NjQg
KikwLCAmY3R4LT5fX3ZtYWNfY3R4KTsNCj4gLQlyZXR1cm4gcCArIGg7DQo+ICsJciA9IHAgKyBo
Ow0KPiArCXIgPSBsZTY0X3RvX2NwdXAoJnIpOw0KPiArDQo+ICsJcmV0dXJuIHI7DQoNCklzIHRo
ZXJlIGFueSByZWFzb24gd2h5IHdlIGRvbid0IHNpbXBseSBkbw0KDQoJcmV0dXJuIGxlNjRfdG9f
Y3B1KHAgKyBoKTsNCg0KQ2hlZXJzLA0KLS0gDQpWaXNpdCBPcGVuc3dhbiBhdCBodHRwOi8vd3d3
Lm9wZW5zd2FuLm9yZy8NCkVtYWlsOiBIZXJiZXJ0IFh1IH57UG1WPkhJfn0gPGhlcmJlcnRAZ29u
ZG9yLmFwYW5hLm9yZy5hdT4NCkhvbWUgUGFnZTogaHR0cDovL2dvbmRvci5hcGFuYS5vcmcuYXUv
fmhlcmJlcnQvDQpQR1AgS2V5OiBodHRwOi8vZ29uZG9yLmFwYW5hLm9yZy5hdS9+aGVyYmVydC9w
dWJrZXkudHh0DQo=
