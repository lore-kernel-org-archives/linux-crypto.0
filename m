From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH v2 6/8] crypto: caam - handle core endianness != caam
 endianness
Date: Mon, 16 May 2016 14:52:50 +0000
Message-ID: <VI1PR04MB13118EA25CF114C4D638AE39B8770@VI1PR04MB1311.eurprd04.prod.outlook.com>
References: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
 <1462462589-27873-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Scott Wood <scott.wood@nxp.com>,
	"Alexandru Porosanu" <alexandru.porosanu@nxp.com>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	Fabio Estevam <fabio.estevam@nxp.com>,
	"Steven Cornelius" <steve.cornelius@nxp.com>
To: Horia Ioan Geanta Neag <horia.geanta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0076.outbound.protection.outlook.com ([157.55.234.76]:16292
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754362AbcEPQZb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 May 2016 12:25:31 -0400
In-Reply-To: <1462462589-27873-1-git-send-email-horia.geanta@nxp.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

PiBUaGVyZSBhcmUgU29DcyBsaWtlIExTMTA0M0Egd2hlcmUgQ0FBTSBlbmRpYW5uZXNzIChCRSkg
ZG9lcyBub3QgbWF0Y2gNCj4gdGhlIGRlZmF1bHQgZW5kaWFubmVzcyBvZiB0aGUgY29yZSAoTEUp
Lg0KPiBNb3Jlb3ZlciwgdGhlcmUgYXJlIHJlcXVpcmVtZW50cyBmb3IgdGhlIGRyaXZlciB0byBo
YW5kbGUgY2FzZXMgbGlrZQ0KPiBDUFVfQklHX0VORElBTj15IG9uIEFSTS1iYXNlZCBTb0NzLg0K
PiBUaGlzIHJlcXVpcmVzIGZvciBhIGNvbXBsZXRlIHJld3JpdGUgb2YgdGhlIEkvTyBhY2Nlc3Nv
cnMuDQo+IA0KPiBQUEMtc3BlY2lmaWMgYWNjZXNzb3JzIC0ge2luLG91dH1fe2xlLGJlfVhYIC0g
YXJlIHJlcGxhY2VkIHdpdGgNCj4gZ2VuZXJpYyBvbmVzIC0gaW97cmVhZCx3cml0ZX1bYmVdWFgu
DQo+IA0KPiBFbmRpYW5uZXNzIGlzIGRldGVjdGVkIGR5bmFtaWNhbGx5IChhdCBydW50aW1lKSB0
byBhbGxvdyBmb3INCj4gbXVsdGlwbGF0Zm9ybSBrZXJuZWxzLCBmb3IgZS5nLiBydW5uaW5nIHRo
ZSBzYW1lIGtlcm5lbCBpbWFnZQ0KPiBvbiBMUzEwNDNBIChCRSBDQUFNKSBhbmQgTFMyMDgwQSAo
TEUgQ0FBTSkgYXJtdjgtYmFzZWQgU29Dcy4NCj4gDQo+IFdoaWxlIGhlcmU6IGRlYnVnZnMgZW50
cmllcyBuZWVkIHRvIHRha2UgaW50byBjb25zaWRlcmF0aW9uIHRoZQ0KPiBlbmRpYW5uZXNzIG9m
IHRoZSBjb3JlIHdoZW4gZGlzcGxheWluZyBkYXRhLiBBZGQgdGhlIG5lY2Vzc2FyeQ0KPiBnbHVl
IGNvZGUgc28gdGhlIGVudHJpZXMgcmVtYWluIHRoZSBzYW1lLCBidXQgdGhleSBhcmUgcHJvcGVy
bHkNCj4gcmVhZCwgcmVnYXJkbGVzcyBvZiB0aGUgY29yZSBhbmQvb3IgU0VDIGVuZGlhbm5lc3Mu
DQo+IA0KPiBOb3RlOiBwZGIuaCBmaXhlcyBvbmx5IHdoYXQgaXMgY3VycmVudGx5IGJlaW5nIHVz
ZWQgKElQc2VjKS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEhvcmlhIEdlYW50xIMgPGhvcmlhLmdl
YW50YUBueHAuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGV4IFBvcm9zYW51IDxhbGV4YW5kcnUu
cG9yb3NhbnVAbnhwLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL0tjb25maWcg
ICAgICAgfCAgIDQgLQ0KPiAgZHJpdmVycy9jcnlwdG8vY2FhbS9jYWFtaGFzaC5jICAgIHwgICA1
ICstDQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL2N0cmwuYyAgICAgICAgfCAxMjUgKysrKysrKysr
KysrKysrKysrKy0tLS0tLS0tLS0tLQ0KPiAgZHJpdmVycy9jcnlwdG8vY2FhbS9kZXNjLmggICAg
ICAgIHwgICA3ICstDQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL2Rlc2NfY29uc3RyLmggfCAgNDQg
KysrKysrKy0tLS0NCj4gIGRyaXZlcnMvY3J5cHRvL2NhYW0vanIuYyAgICAgICAgICB8ICAyMiAr
KystLS0NCj4gIGRyaXZlcnMvY3J5cHRvL2NhYW0vcGRiLmggICAgICAgICB8IDEzNyArKysrKysr
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL3JlZ3Mu
aCAgICAgICAgfCAxNTEgKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLQ0KPiAtLS0t
DQo+ICBkcml2ZXJzL2NyeXB0by9jYWFtL3NnX3N3X3NlYzQuaCAgfCAgMTEgKy0tDQo+ICA5IGZp
bGVzIGNoYW5nZWQsIDM0MCBpbnNlcnRpb25zKCspLCAxNjYgZGVsZXRpb25zKC0pDQoNClJldmll
d2VkLWJ5OiBUdWRvciBBbWJhcnVzIDx0dWRvci1kYW4uYW1iYXJ1c0BueHAuY29tPg0K
