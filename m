From: "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: RE: [PATCH 0/7] crypto: SHA256 multibuffer implementation
Date: Mon, 4 Apr 2016 23:06:50 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205DF860B8@ORSMSX106.amr.corp.intel.com>
References: <1458851163-3448-1-git-send-email-megha.dey@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>
To: "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:59345 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbcDDXGx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Apr 2016 19:06:53 -0400
In-Reply-To: <1458851163-3448-1-git-send-email-megha.dey@linux.intel.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

PiBGcm9tOiBtZWdoYS5kZXlAbGludXguaW50ZWwuY29tIFttYWlsdG86bWVnaGEuZGV5QGxpbnV4
LmludGVsLmNvbV0NCj4gU2VudDogVGh1cnNkYXksIE1hcmNoIDI0LCAyMDE2IDE6MjYgUE0NCj4g
VG86IGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldA0KPiBD
YzogbGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZzsNCj4gdGltLmMuY2hlbkBsaW51eC5pbnRlbC5jb207IFl1LCBGZW5naHVhIDxmZW5naHVh
Lnl1QGludGVsLmNvbT47IE1lZ2hhDQo+IERleSA8bWVnaGEuZGV5QGxpbnV4LmludGVsLmNvbT4N
Cj4gU3ViamVjdDogW1BBVENIIDAvN10gY3J5cHRvOiBTSEEyNTYgbXVsdGlidWZmZXIgaW1wbGVt
ZW50YXRpb24NCj4gDQo+IEZyb206IE1lZ2hhIERleSA8bWVnaGEuZGV5QGxpbnV4LmludGVsLmNv
bT4NCj4gDQo+IEluIHRoaXMgcGF0Y2ggc2VyaWVzLCB3ZSBpbnRyb2R1Y2UgdGhlIG11bHRpLWJ1
ZmZlciBjcnlwdG8gYWxnb3JpdGhtIG9uDQo+IHg4Nl82NCBhbmQgYXBwbHkgaXQgdG8gU0hBMjU2
IGhhc2ggY29tcHV0YXRpb24uICBUaGUgbXVsdGktYnVmZmVyIHRlY2huaXF1ZQ0KPiB0YWtlcyBh
ZHZhbnRhZ2Ugb2YgdGhlIDggZGF0YSBsYW5lcyBpbiB0aGUgQVZYMiByZWdpc3RlcnMgYW5kIGFs
bG93cw0KPiBjb21wdXRhdGlvbiB0byBiZSBwZXJmb3JtZWQgb24gZGF0YSBmcm9tIG11bHRpcGxl
IGpvYnMgaW4gcGFyYWxsZWwuDQo+IFRoaXMgYWxsb3dzIHVzIHRvIHBhcmFsbGVsaXplIGNvbXB1
dGF0aW9ucyB3aGVuIGRhdGEgaW50ZXItZGVwZW5kZW5jeSBpbiBhDQo+IHNpbmdsZSBjcnlwdG8g
am9iIHByZXZlbnRzIHVzIHRvIGZ1bGx5IHBhcmFsbGVsaXplIG91ciBjb21wdXRhdGlvbnMuDQo+
IFRoZSBhbGdvcml0aG0gY2FuIGJlIGV4dGVuZGVkIHRvIG90aGVyIGhhc2hpbmcgYW5kIGVuY3J5
cHRpb24gc2NoZW1lcyBpbg0KPiB0aGUgZnV0dXJlLg0KDQpIaSwgSGVyYmVydCBhbmQgRGF2ZSwN
Cg0KQW55IGNvbW1lbnQgb24gdGhlIHBhdGNoIHNldCBhbmQgdGhlIFNIQTUxMiBwYXRjaCBzZXQ/
DQoNCkFyZSB5b3UgcGxhbm5pbmcgb24gbWVyZ2luZyB0aGUgcGF0Y2ggc2V0cyBpbnRvIGNyeXB0
byB0cmVlIGFuZCB1cHN0cmVhbT8NCg0KVGhhbmtzLg0KDQotRmVuZ2h1YQ0K
