From: "Auer, Lukas" <lukas.auer@aisec.fraunhofer.de>
Subject: Re: [PATCH v3 2/5] crypto: caam: Fix endless loop when RNG is
 already initialized
Date: Fri, 2 Feb 2018 12:54:24 +0000
Message-ID: <1517576063.2002.19.camel@aisec.fraunhofer.de>
References: <1517364040-27607-1-git-send-email-pure.logic@nexus-software.ie>
         <1517364040-27607-3-git-send-email-pure.logic@nexus-software.ie>
         <VI1PR0402MB334297558BB1984131546B1D98FA0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
         <78ad6a62-190c-e4fe-dd23-e1d058f9bbb2@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "peng.fan@nxp.com" <peng.fan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ryan.harkin@linaro.org" <ryan.harkin@linaro.org>,
        "fabio.estevam@nxp.com" <fabio.estevam@nxp.com>,
        "rui.silva@linaro.org" <rui.silva@linaro.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aymen.sghaier@nxp.com" <aymen.sghaier@nxp.com>,
        "horia.geanta@nxp.com" <horia.geanta@nxp.com>,
        "pure.logic@nexus-software.ie" <pure.logic@nexus-software.ie>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-edgeka24.fraunhofer.de ([153.96.1.24]:43233 "EHLO
        mail-edgeKA24.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751848AbeBBMya (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Feb 2018 07:54:30 -0500
In-Reply-To: <78ad6a62-190c-e4fe-dd23-e1d058f9bbb2@nexus-software.ie>
Content-Language: en-US
Content-ID: <319A159D028DB7489AE7EEE5F58C047B@xch.fraunhofer.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

T24gRnJpLCAyMDE4LTAyLTAyIGF0IDExOjIwICswMDAwLCBCcnlhbiBPJ0Rvbm9naHVlIHdyb3Rl
Og0KPiBPbiAwMS8wMi8xOCAxMjoxNiwgSG9yaWEgR2VhbnTEgyB3cm90ZToNCj4gPiBJZiB0aGUg
bG9vcCBjYW5ub3QgZXhpdCBiYXNlZCBvbiB2YWx1ZSBvZiAicmV0IiAhPSAtRUFHQUlOLCB0aGVu
IGl0DQo+ID4gbWVhbnMNCj4gPiBjYWFtX3Byb2JlKCkgd2lsbCBldmVudHVhbGx5IGZhaWwgZHVl
IHRvIHJldCA9PSAtRUFHQUlOOg0KPiA+IAlpZiAocmV0KSB7DQo+ID4gCQlkZXZfZXJyKGRldiwg
ImZhaWxlZCB0byBpbnN0YW50aWF0ZSBSTkciKTsNCj4gPiAJCWdvdG8gY2FhbV9yZW1vdmU7DQo+
ID4gCX0NCj4gDQo+IEZvciBtZSBpdCdzIGFuIGVuZGxlc3MgbG9vcCBhcHBseWluZyB0aGUgZmly
c3QgdHdvDQo+IA0KPiBodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3BhdGNoLzg2NjQ2MC8N
Cj4gaHR0cHM6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9wYXRjaC84NjY0NjIvDQo+IA0KPiBidXQg
bm90IHRoaXMgb25lDQo+IA0KPiBodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3BhdGNoLzg2
NTg5MC8NCj4gDQo+ID4gUGxlYXNlIHByb3ZpZGUgbW9yZSBkZXRhaWxzLCBzbyB0aGF0IHRoZSBy
b290IGNhdXNlIGlzIGZvdW5kIGFuZA0KPiA+IGZpeGVkLg0KPiANCj4gbnANCj4gDQo+IC0tLQ0K
PiBib2QNCg0KSSB0aGluayB0aGUgcHJvYmxlbSBsaWVzIGluIHRoZSBpbnN0YW50aWF0ZV9ybmco
KSBmdW5jdGlvbi4gSWYgdGhlDQpkcml2ZXIgaXMgdW5hYmxlIHRvIGFjcXVpcmUgREVDMCBpdCds
bCByZXR1cm4gLUVOT0RFVi4gVGhpcyBzaG91bGQNCnRlcm1pbmF0ZSB0aGUgd2hpbGUgbG9vcCBp
biB0aGUgcHJvYmUgZnVuY3Rpb24uIEhvd2V2ZXIsIHRoZSByZXR1cm4NCnZhbHVlIGlzIG5ldmVy
IGNoZWNrZWQgYW5kIGlzIGluc3RlYWQgb3ZlcndyaXR0ZW4gd2l0aCAtRUFHQUlOLCBjYXVzaW5n
DQp0aGUgZW5kbGVzcyBsb29wLg0KDQpUaGlzIHByb2JsZW0gb25seSBvY2N1cnMgaWYgdS1ib290
IGluc3RhbnRpYXRlcyBvbmx5IG9uZSBvZiB0aGUgc3RhdGUNCmhhbmRsZXMgKGVudF9kZWxheSBk
b2Vzbid0IGdldCBpbmNyZW1lbnRlZCkgYW5kIHRoZSBrZXJuZWwgcnVucyBpbiBub24tDQpzZWN1
cmUgbW9kZSAoREVDMCBjYW4ndCBnZXQgYWNxdWlyZWQpLiBJbnN0YW50aWF0aW5nIGFsbCBzdGF0
ZSBoYW5kbGVzDQppbiB1LWJvb3QgdGhlcmVmb3JlIGZpeGVzIHRoaXMgcHJvYmxlbS4gSW4gYWRk
aXRpb24sIHRoZSByZXR1cm4gdmFsdWUNCmluIGluc3RhbnRpYXRlX3JuZygpIHNob3VsZCBiZSBo
YW5kbGVkIGNvcnJlY3RseSBieSBpbmNsdWRpbmcNCg0KaWYgKHJldCkNCglicmVhazsNCg0Kcmln
aHQgYWZ0ZXIgInJldCA9IHJ1bl9kZXNjcmlwdG9yX2RlY28wKGN0cmxkZXYsIGRlc2MsICZzdGF0
dXMpOyIuDQoNClRoYW5rcywNCkx1a2Fz
