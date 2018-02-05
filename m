From: "Auer, Lukas" <lukas.auer@aisec.fraunhofer.de>
Subject: Re: [PATCH v3 2/5] crypto: caam: Fix endless loop when RNG is
 already initialized
Date: Mon, 5 Feb 2018 13:54:43 +0000
Message-ID: <1517838882.2601.12.camel@aisec.fraunhofer.de>
References: <1517364040-27607-1-git-send-email-pure.logic@nexus-software.ie>
         <1517364040-27607-3-git-send-email-pure.logic@nexus-software.ie>
         <VI1PR0402MB334297558BB1984131546B1D98FA0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
         <78ad6a62-190c-e4fe-dd23-e1d058f9bbb2@nexus-software.ie>
         <1517576063.2002.19.camel@aisec.fraunhofer.de>
         <VI1PR0402MB3342899B009D1A6CC0569CFE98FE0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
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
Received: from mail-edgeDD24.fraunhofer.de ([192.102.167.24]:57903 "EHLO
        mail-edgeDD24.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752607AbeBEOFp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Feb 2018 09:05:45 -0500
In-Reply-To: <VI1PR0402MB3342899B009D1A6CC0569CFE98FE0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Content-Language: en-US
Content-ID: <77ED0A1B7A0D954C88D393EDE2337E77@xch.fraunhofer.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

T24gTW9uLCAyMDE4LTAyLTA1IGF0IDA4OjQ1ICswMDAwLCBIb3JpYSBHZWFudMSDIHdyb3RlOg0K
PiBPbiAyLzIvMjAxOCAyOjU0IFBNLCBBdWVyLCBMdWthcyB3cm90ZToNCj4gPiBPbiBGcmksIDIw
MTgtMDItMDIgYXQgMTE6MjAgKzAwMDAsIEJyeWFuIE8nRG9ub2dodWUgd3JvdGU6DQo+ID4gPiBP
biAwMS8wMi8xOCAxMjoxNiwgSG9yaWEgR2VhbnTEgyB3cm90ZToNCj4gPiA+ID4gSWYgdGhlIGxv
b3AgY2Fubm90IGV4aXQgYmFzZWQgb24gdmFsdWUgb2YgInJldCIgIT0gLUVBR0FJTiwNCj4gPiA+
ID4gdGhlbiBpdA0KPiA+ID4gPiBtZWFucw0KPiA+ID4gPiBjYWFtX3Byb2JlKCkgd2lsbCBldmVu
dHVhbGx5IGZhaWwgZHVlIHRvIHJldCA9PSAtRUFHQUlOOg0KPiA+ID4gPiAJaWYgKHJldCkgew0K
PiA+ID4gPiAJCWRldl9lcnIoZGV2LCAiZmFpbGVkIHRvIGluc3RhbnRpYXRlIFJORyIpOw0KPiA+
ID4gPiAJCWdvdG8gY2FhbV9yZW1vdmU7DQo+ID4gPiA+IAl9DQo+ID4gPiANCj4gPiA+IEZvciBt
ZSBpdCdzIGFuIGVuZGxlc3MgbG9vcCBhcHBseWluZyB0aGUgZmlyc3QgdHdvDQo+ID4gPiANCj4g
PiA+IGh0dHBzOi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcGF0Y2gvODY2NDYwLw0KPiA+ID4gaHR0
cHM6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9wYXRjaC84NjY0NjIvDQo+ID4gPiANCj4gPiA+IGJ1
dCBub3QgdGhpcyBvbmUNCj4gPiA+IA0KPiA+ID4gaHR0cHM6Ly9wYXRjaHdvcmsub3psYWJzLm9y
Zy9wYXRjaC84NjU4OTAvDQo+ID4gPiANCj4gDQo+IFtzbmlwXQ0KPiA+IA0KPiA+IEkgdGhpbmsg
dGhlIHByb2JsZW0gbGllcyBpbiB0aGUgaW5zdGFudGlhdGVfcm5nKCkgZnVuY3Rpb24uIElmIHRo
ZQ0KPiA+IGRyaXZlciBpcyB1bmFibGUgdG8gYWNxdWlyZSBERUMwIGl0J2xsIHJldHVybiAtRU5P
REVWLiBUaGlzIHNob3VsZA0KPiA+IHRlcm1pbmF0ZSB0aGUgd2hpbGUgbG9vcCBpbiB0aGUgcHJv
YmUgZnVuY3Rpb24uIEhvd2V2ZXIsIHRoZSByZXR1cm4NCj4gPiB2YWx1ZSBpcyBuZXZlciBjaGVj
a2VkIGFuZCBpcyBpbnN0ZWFkIG92ZXJ3cml0dGVuIHdpdGggLUVBR0FJTiwNCj4gPiBjYXVzaW5n
DQo+ID4gdGhlIGVuZGxlc3MgbG9vcC4NCj4gPiANCj4gPiBUaGlzIHByb2JsZW0gb25seSBvY2N1
cnMgaWYgdS1ib290IGluc3RhbnRpYXRlcyBvbmx5IG9uZSBvZiB0aGUNCj4gPiBzdGF0ZQ0KPiA+
IGhhbmRsZXMgKGVudF9kZWxheSBkb2Vzbid0IGdldCBpbmNyZW1lbnRlZCkgYW5kIHRoZSBrZXJu
ZWwgcnVucyBpbg0KPiA+IG5vbi0NCj4gPiBzZWN1cmUgbW9kZSAoREVDMCBjYW4ndCBnZXQgYWNx
dWlyZWQpLiBJbnN0YW50aWF0aW5nIGFsbCBzdGF0ZQ0KPiA+IGhhbmRsZXMNCj4gPiBpbiB1LWJv
b3QgdGhlcmVmb3JlIGZpeGVzIHRoaXMgcHJvYmxlbS4gSW4gYWRkaXRpb24sIHRoZSByZXR1cm4N
Cj4gPiB2YWx1ZQ0KPiA+IGluIGluc3RhbnRpYXRlX3JuZygpIHNob3VsZCBiZSBoYW5kbGVkIGNv
cnJlY3RseSBieSBpbmNsdWRpbmcNCj4gPiANCj4gPiBpZiAocmV0KQ0KPiA+IAlicmVhazsNCj4g
PiANCj4gPiByaWdodCBhZnRlciAicmV0ID0gcnVuX2Rlc2NyaXB0b3JfZGVjbzAoY3RybGRldiwg
ZGVzYywgJnN0YXR1cyk7Ii4NCj4gPiANCj4gDQo+IEluZGVlZCwgdGhlIGVycm9yIHBhdGggaXMg
aW5jb3JyZWN0IGFuZCBzaG91bGQgYmUgZml4ZWQgYXMgeW91DQo+IG1lbnRpb25lZC4NCj4gSSB3
aWxsIHNlbmQgYSBwYXRjaCByZXBsYWNpbmcgdGhpcyBvbmUuDQo+IE5vdGUgdGhhdCB0aGlzIGZp
eGVzIG9ubHkgdGhlIGVycm9yIHBhdGgsIG1lYW5pbmcgY2FhbV9wcm9iZSgpIHdvbid0DQo+IGdv
IGludG8gYW4NCj4gZW5kbGVzcyBsb29wIGFuZCBpbnN0ZWFkIHdpbGwgcmV0dXJuIC1FTk9ERVYs
IGR1ZSB0byBiZWluZyB1bmFibGUgdG8NCj4gYWNxdWlyZQ0KPiBjb250cm9sIG9mIERFQ08wLg0K
PiANCj4gVGhlcmUgYXJlIHN0aWxsIGEgZmV3IGh1cmRsZXMgdG8gY3Jvc3MgZm9yIENBQU0gdG8g
d29yayBpbiBhIFRaDQo+IGVudmlyb25tZW50Lg0KPiANCj4gRm9yIGUuZy4gY291bGQgeW91IHBs
ZWFzZSBjaGVjayAvIGNvbmZpcm0gd2hldGhlciBERUNPME1JRFIgKERFQ08wDQo+IE1JRCByZWdp
c3RlcnMNCj4gQDB4QTAsIEAweEE0KSBhcmUgc2V0IHN1Y2ggdGhhdCBMaW51eCBrZXJuZWwgaXMg
YWxsb3dlZCB0byByL3cgREVDTzAtDQo+IHJlbGF0ZWQNCj4gcmVnaXN0ZXJzPw0KPiANCj4gVGhh
bmtzLA0KPiBIb3JpYQ0KDQpPbiBteSBib2FyZCBERUNPMCBNSUQgbXMgaXMgc2V0IHRvIDB4ODAw
MSwgd2hpY2ggSSBiZWxpZXZlIChnb2luZyBieQ0KdGhlIHN0cnVjdHVyZSBvZiB0aGUgb3RoZXIg
TUlEIHJlZ2lzdGVycywgc2luY2Ugc29tZSBvZiB0aGUgYml0cyBhcmUNCm9ubHkgbWFya2VkIGFz
IHJlc2VydmVkKSBpcyBhIE1JRCBvZiAxIChBNyBjb3JlcykgaW4gc2VjdXJlIG1vZGUuDQpDaGFu
Z2luZyB0aGlzIHRvIDB4OSBmb3IgYSBNSUQgb2YgMSBpbiBub24tc2VjdXJlIG1vZGUgc3RpbGwg
ZmFpbHMgdGhlDQpERUMwIGFjcXVpc2l0aW9uIHN0ZXAgaW4gdGhlIHByb2JlIGNhbGwuDQoNClNv
IHVuZm9ydHVuYXRlbHkgSSBhbSBub3Qgc3VyZSB3aGF0IC8gaWYgb3RoZXIgc3RlcHMgYXJlIHJl
cXVpcmVkIHRvDQp1c2UgdGhlIENBQU0gaW4gbm9uLXNlY3VyZSBtb2RlLiBSdW5uaW5nIGEgcXVp
Y2sgdGVzdCB3aXRoIG9wZW5zc2wNCnNwZWVkICh1c2luZyBDQUFNIHdpdGggY3J5cHRvZGV2KSwg
aXQgYXQgbGVhc3Qgc2VlbXMgdG8gYmUgd29ya2luZy4NCg0KVGhhbmtzLA0KTHVrYXM=
