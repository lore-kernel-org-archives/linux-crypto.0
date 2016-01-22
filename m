From: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH 0/2] crypto: caam - performance fixes/improvements
Date: Fri, 22 Jan 2016 16:52:36 +0000
Message-ID: <56A25E3F.8070004@nxp.com>
References: <1452611650-15803-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Scott Wood <scott.wood@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0058.outbound.protection.outlook.com ([157.56.112.58]:55472
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751908AbcAVR0a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jan 2016 12:26:30 -0500
In-Reply-To: <1452611650-15803-1-git-send-email-horia.geanta@nxp.com>
Content-Language: en-US
Content-ID: <96452F2985D3894994A920F748186758@eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

T24gMS8xMi8yMDE2IDU6MTQgUE0sIEhvcmlhIEdlYW50xIMgd3JvdGU6DQo+IFRoZSBmb2xsb3dp
bmcgcGF0Y2hlcyBpbmNyZWFzZS9maXggQ0FBTSBwZXJmb3JtYW5jZSBieSBtb2RpZnlpbmcNCj4g
dGhlIGNvbmZpZ3VyYXRpb24gb2YgTUNGR1IgKE1hc3RlciBDb25maWd1cmF0aW9uIFJlZ2lzdGVy
KToNCj4gLTFzdCBwYXRjaCBmaXhlcyBhIH4gNSUgcGVyZm9ybWFuY2UgZHJvcCBvbiBQUEMgcGxh
dGZvcm1zDQo+IC0ybmQgcGF0Y2ggaW1wcm92ZXMgcGVyZm9ybWFuY2UgaW4gc29tZSB1c2UgY2Fz
ZXMsIHNpbmNlIENBQU0gRE1BDQo+IHRyYW5zZmVycyBhcmUgb3B0aW1pemVkDQo+IA0KPiANCj4g
Tm90ZTogQVdDQUNIRVswXSAoQVhJMyAiYnVmZmVyYWJsZSIpIGFuZCBBV0NBQ0hFWzFdIChBWEkz
ICJjYWNoZWFibGUiKQ0KPiBhcmUgc2V0IGlycmVzcGVjdGl2ZSBvZiBwbGF0Zm9ybSwgc2luY2U6
DQo+IC1mb3IgQVJNLWJhc2VkIFNvQ3M6IHRoZSBpbnRlcmNvbm5lY3QgSVAgaWdub3JlcyBBV0NB
Q0hFWzBdDQo+IC1mb3IgUFBDLWJhc2VkIFNvQ3M6IFBBTVUgaGFuZGxlcyBjb2hlcmVuY3kgY29u
dHJvbCwgbm90IEFXQ0FDSEVbMV0NCj4gDQo+IEhvcmlhIEdlYW50xIMgKDIpOg0KPiAgIGNyeXB0
bzogY2FhbSAtIG1ha2Ugd3JpdGUgdHJhbnNhY3Rpb25zIGJ1ZmZlcmFibGUgb24gUFBDIHBsYXRm
b3Jtcw0KPiAgIGNyeXB0bzogY2FhbSAtIGVuYWJsZSBMQVJHRV9CVVJTVCBmb3IgZW5oYW5jaW5n
IERNQSB0cmFuc2FjdGlvbnMgc2l6ZQ0KDQpIZXJiZXJ0LCBJIHNlZSB0aGF0IHlvdSd2ZSBzZW50
IHRoZSBjcnlwdG8gZml4ZXMgZm9yIDQuNSBwdWxsIHJlcXVlc3QuDQpBbnkgcmVhc29uIHdoeSB0
aGVzZSBwYXRjaGVzIHdlcmUgbm90IGluY2x1ZGVkPw0KSSB3YXMgZXhwZWN0aW5nIGF0IGxlYXN0
IHRoZSBmaXJzdCBvbmUgdG8gZ2V0IGl0LCBpdCdzIGV2ZW4gQ2MtaW5nIHN0YWJsZS4NCg0KVGhh
bmtzLA0KSG9yaWENCg==
