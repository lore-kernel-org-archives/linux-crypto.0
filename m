From: Alison Wang <alison.wang@nxp.com>
Subject: RE: [PATCH] crypto: caam - fix pointer size for AArch64 boot loader,
 AArch32 kernel
Date: Tue, 6 Dec 2016 03:29:24 +0000
Message-ID: <DB5PR04MB2152DC522CF7DD8B63BABEC1F4820@DB5PR04MB2152.eurprd04.prod.outlook.com>
References: <1480928818-8166-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>
To: =?utf-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0074.outbound.protection.outlook.com ([104.47.1.74]:14304
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751085AbcLFG5s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Dec 2016 01:57:48 -0500
In-Reply-To: <1480928818-8166-1-git-send-email-horia.geanta@nxp.com>
Content-Language: zh-CN
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIb3JpYSBHZWFudMSDIFttYWls
dG86aG9yaWEuZ2VhbnRhQG54cC5jb21dDQo+IFNlbnQ6IE1vbmRheSwgRGVjZW1iZXIgMDUsIDIw
MTYgNTowNyBQTQ0KPiBUbzogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1
Pg0KPiBDYzogRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgbGludXgtY3J5
cHRvQHZnZXIua2VybmVsLm9yZzsNCj4gRGFuIERvdWdsYXNzIDxkYW4uZG91Z2xhc3NAbnhwLmNv
bT47IEFsaXNvbiBXYW5nIDxhbGlzb24ud2FuZ0BueHAuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0hd
IGNyeXB0bzogY2FhbSAtIGZpeCBwb2ludGVyIHNpemUgZm9yIEFBcmNoNjQgYm9vdA0KPiBsb2Fk
ZXIsIEFBcmNoMzIga2VybmVsDQo+IA0KPiBTdGFydCB3aXRoIGEgY2xlYW4gc2xhdGUgYmVmb3Jl
IGRlYWxpbmcgd2l0aCBiaXQgMTYgKHBvaW50ZXIgc2l6ZSkgb2YNCj4gTWFzdGVyIENvbmZpZ3Vy
YXRpb24gUmVnaXN0ZXIuDQo+IFRoaXMgZml4ZXMgdGhlIGNhc2Ugb2YgQUFyY2g2NCBib290IGxv
YWRlciArIEFBcmNoMzIga2VybmVsLCB3aGVuIHRoZQ0KPiBib290IGxvYWRlciBtaWdodCBzZXQg
TUNGR1JbUFNdIGFuZCBrZXJuZWwgd291bGQgZmFpbCB0byBjbGVhciBpdC4NCj4gDQo+IENjOiA8
c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCj4gUmVwb3J0ZWQtYnk6IEFsaXNvbiBXYW5nIDxhbGlz
b24ud2FuZ0BueHAuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBIb3JpYSBHZWFudMSDIDxob3JpYS5n
ZWFudGFAbnhwLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL2N0cmwuYyB8IDUg
KysrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vY2FhbS9jdHJsLmMgYi9kcml2ZXJz
L2NyeXB0by9jYWFtL2N0cmwuYw0KPiBpbmRleCBiZTYyYTdmNDgyYWMuLjBhNmNhMzkxOTI3MCAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vY2FhbS9jdHJsLmMNCj4gKysrIGIvZHJpdmVy
cy9jcnlwdG8vY2FhbS9jdHJsLmMNCj4gQEAgLTU1Niw4ICs1NTYsOSBAQCBzdGF0aWMgaW50IGNh
YW1fcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIAkgKiBFbmFibGUgREVD
TyB3YXRjaGRvZ3MgYW5kLCBpZiB0aGlzIGlzIGEgUEhZU19BRERSX1RfNjRCSVQNCj4ga2VybmVs
LA0KPiAgCSAqIGxvbmcgcG9pbnRlcnMgaW4gbWFzdGVyIGNvbmZpZ3VyYXRpb24gcmVnaXN0ZXIN
Cj4gIAkgKi8NCj4gLQljbHJzZXRiaXRzXzMyKCZjdHJsLT5tY3IsIE1DRkdSX0FXQ0FDSEVfTUFT
SywgTUNGR1JfQVdDQUNIRV9DQUNIDQo+IHwNCj4gLQkJICAgICAgTUNGR1JfQVdDQUNIRV9CVUZG
IHwgTUNGR1JfV0RFTkFCTEUgfA0KPiBNQ0ZHUl9MQVJHRV9CVVJTVCB8DQo+ICsJY2xyc2V0Yml0
c18zMigmY3RybC0+bWNyLCBNQ0ZHUl9BV0NBQ0hFX01BU0sgfCBNQ0ZHUl9MT05HX1BUUiwNCj4g
KwkJICAgICAgTUNGR1JfQVdDQUNIRV9DQUNIIHwgTUNGR1JfQVdDQUNIRV9CVUZGIHwNCj4gKwkJ
ICAgICAgTUNGR1JfV0RFTkFCTEUgfCBNQ0ZHUl9MQVJHRV9CVVJTVCB8DQo+ICAJCSAgICAgIChz
aXplb2YoZG1hX2FkZHJfdCkgPT0gc2l6ZW9mKHU2NCkgPyBNQ0ZHUl9MT05HX1BUUiA6DQo+IDAp
KTsNCj4gDQo+ICAJLyoNCj4gDQpSZXZpZXdlZC1CeTogQWxpc29uIFdhbmcgPEFsaXNvbi53YW5n
QG54cC5jb20+DQoNCg0KQmVzdCBSZWdhcmRzLA0KQWxpc29uIFdhbmcNCg==
