From: "Auer, Lukas" <lukas.auer@aisec.fraunhofer.de>
Subject: Re: [RESEND PATCH 3/6] ARM: dts: imx7s: add CAAM device node
Date: Wed, 24 Jan 2018 18:12:46 +0000
Message-ID: <1516817565.29323.74.camel@aisec.fraunhofer.de>
References: <1516805435-15034-1-git-send-email-pure.logic@nexus-software.ie>
         <1516805435-15034-4-git-send-email-pure.logic@nexus-software.ie>
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
Received: from mail-edgeka24.fraunhofer.de ([153.96.1.24]:62789 "EHLO
        mail-edgeKA24.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964850AbeAXSWt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jan 2018 13:22:49 -0500
In-Reply-To: <1516805435-15034-4-git-send-email-pure.logic@nexus-software.ie>
Content-Language: en-US
Content-ID: <8656C3E1D17BA84C8658E91BD9397841@xch.fraunhofer.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

T24gV2VkLCAyMDE4LTAxLTI0IGF0IDE0OjUwICswMDAwLCBCcnlhbiBPJ0Rvbm9naHVlIHdyb3Rl
Og0KPiBGcm9tOiBSdWkgTWlndWVsIFNpbHZhIDxydWkuc2lsdmFAbGluYXJvLm9yZz4NCj4gDQo+
IEFkZCBDQUFNIGRldmljZSBub2RlIHRvIHRoZSBpLk1YN3MgZGV2aWNlIHRyZWUuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBSdWkgTWlndWVsIFNpbHZhIDxydWkuc2lsdmFAbGluYXJvLm9yZz4NCj4g
Q2M6ICJIb3JpYSBHZWFudMSDIiA8aG9yaWEuZ2VhbnRhQG54cC5jb20+DQo+IENjOiBBeW1lbiBT
Z2hhaWVyIDxheW1lbi5zZ2hhaWVyQG54cC5jb20+DQo+IENjOiBGYWJpbyBFc3RldmFtIDxmYWJp
by5lc3RldmFtQG54cC5jb20+DQo+IENjOiBQZW5nIEZhbiA8cGVuZy5mYW5AbnhwLmNvbT4NCj4g
Q2M6IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4gQ2M6ICJEYXZp
ZCBTLiBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBDYzogTHVrYXMgQXVlciA8bHVr
YXMuYXVlckBhaXNlYy5mcmF1bmhvZmVyLmRlPg0KPiBTaWduZWQtb2ZmLWJ5OiBCcnlhbiBPJ0Rv
bm9naHVlIDxwdXJlLmxvZ2ljQG5leHVzLXNvZnR3YXJlLmllPg0KPiAtLS0NCj4gIGFyY2gvYXJt
L2Jvb3QvZHRzL2lteDdzLmR0c2kgfCAyNiArKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAg
MSBmaWxlIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNo
L2FybS9ib290L2R0cy9pbXg3cy5kdHNpDQo+IGIvYXJjaC9hcm0vYm9vdC9kdHMvaW14N3MuZHRz
aQ0KPiBpbmRleCA4MmFkMjZlLi4wZGExNDZlIDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FybS9ib290
L2R0cy9pbXg3cy5kdHNpDQo+ICsrKyBiL2FyY2gvYXJtL2Jvb3QvZHRzL2lteDdzLmR0c2kNCj4g
QEAgLTgwNSw2ICs4MDUsMzIgQEANCj4gIAkJCQlzdGF0dXMgPSAiZGlzYWJsZWQiOw0KPiAgCQkJ
fTsNCj4gIA0KPiArCQkJY3J5cHRvOiBjYWFtQDMwOTAwMDAwIHsNCj4gKwkJCQljb21wYXRpYmxl
ID0gImZzbCxzZWMtdjQuMCI7DQo+ICsJCQkJZnNsLHNlYy1lcmEgPSA8ND47DQo+ICsJCQkJI2Fk
ZHJlc3MtY2VsbHMgPSA8MT47DQo+ICsJCQkJI3NpemUtY2VsbHMgPSA8MT47DQo+ICsJCQkJcmVn
ID0gPDB4MzA5MDAwMDAgMHgxMDAwMD47DQo+ICsJCQkJcmFuZ2VzID0gPDAgMHgzMDkwMDAwMCAw
eDEwMDAwPjsNCj4gKwkJCQljbG9ja3MgPSA8JmNsa3MgSU1YN0RfQ0FBTV9NRU1fQ0xLPiwNCj4g
KwkJCQkJIDwmY2xrcw0KPiBJTVg3RF9DQUFNX0FDTEtfQ0xLPiwNCj4gKwkJCQkJIDwmY2xrcyBJ
TVg3RF9DQUFNX0lQR19DTEs+LA0KPiArCQkJCQkgPCZjbGtzIElNWDdEX0VJTV9ST09UX0NMSz47
DQo+ICsJCQkJY2xvY2stbmFtZXMgPSAibWVtIiwgImFjbGsiLCAiaXBnIiwNCj4gImVtaV9zbG93
IjsNCj4gKw0KPiArCQkJCXNlY19qcjA6IGpyMEAxMDAwIHsNCj4gKwkJCQkJY29tcGF0aWJsZSA9
ICJmc2wsc2VjLXY0LjAtDQo+IGpvYi1yaW5nIjsNCj4gKwkJCQkJcmVnID0gPDB4MTAwMCAweDEw
MDA+Ow0KPiArCQkJCQlpbnRlcnJ1cHRzID0gPEdJQ19TUEkgMTA1DQo+IElSUV9UWVBFX0xFVkVM
X0hJR0g+Ow0KPiArCQkJCX07DQo+ICsNCj4gKwkJCQlzZWNfanIxOiBqcjFAMjAwMCB7DQo+ICsJ
CQkJCWNvbXBhdGlibGUgPSAiZnNsLHNlYy12NC4wLQ0KPiBqb2ItcmluZyI7DQo+ICsJCQkJCXJl
ZyA9IDwweDIwMDAgMHgxMDAwPjsNCj4gKwkJCQkJaW50ZXJydXB0cyA9IDxHSUNfU1BJIDEwNg0K
PiBJUlFfVFlQRV9MRVZFTF9ISUdIPjsNCj4gKwkJCQl9Ow0KPiArCQkJfTsNCj4gKw0KPiAgCQkJ
ZmxleGNhbjE6IGNhbkAzMGEwMDAwMCB7DQo+ICAJCQkJY29tcGF0aWJsZSA9ICJmc2wsaW14N2Qt
ZmxleGNhbiIsDQo+ICJmc2wsaW14NnEtZmxleGNhbiI7DQo+ICAJCQkJcmVnID0gPDB4MzBhMDAw
MDAgMHgxMDAwMD47DQoNCkxvb2tpbmcgYXQgdGhlIGRldmljZSB0cmVlIGZyb20gdGhlIE5YUCBr
ZXJuZWwgWzFdLCB0aGUgam9iIHJpbmcgYW5kDQpjbG9jayBjb25maWd1cmF0aW9ucyBzaG91bGQg
YmUgc2xpZ2h0bHkgZGlmZmVyZW50Lg0KDQpUaGUgam9iIHJpbmcgY29uZmlndXJhdGlvbiBoYXMg
b25lIGFkZGl0aW9uYWwgam9iIHJpbmcgYXQgb2Zmc2V0IDMwMDANCmFuZCBpbnRlcnJ1cHQgMTE0
Lg0KDQpUaGUgY2xvY2sgY29uZmlndXJhdGlvbiBoYXMgY2hhbmdlZCB0byBqdXN0IG9uZSBDQUFN
LXNwZWNpZmljIGNsb2NrIGluDQphZGRpdGlvbiB0byB0aGUgYWhiIGNsb2NrLiBUaGlzIGFsc28g
bWVhbnMgdGhhdCBhZGRpdGlvbmFsDQptb2RpZmljYXRpb25zIHRvIHRoZSBDQUFNIGRyaXZlciBh
cmUgbmVjZXNzYXJ5IG9yIGl0IHdpbGwgY29tcGxhaW4gdGhhdA0KaXQgZG9lc24ndCBmaW5kIGFs
bCBjbG9ja3MuIA0KDQpUaGFua3MsDQpMdWthcw0KDQoNClsxXSBodHRwczovL2dpdGh1Yi5jb20v
RnJlZXNjYWxlL2xpbnV4LWZzbGMvYmxvYi80LjEtMi4wLngtaW14L2FyY2gvYXJtDQovYm9vdC9k
dHMvaW14N2QuZHRzaQ==
