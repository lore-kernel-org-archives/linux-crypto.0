From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: Re: [PATCH v5 2/2] crypto: stm32 - Support for STM32 CRYP crypto
 module
Date: Tue, 7 Nov 2017 14:40:46 +0000
Message-ID: <d924a278-90d0-969e-f1ae-a12f92e8972d@st.com>
References: <1508425830-13565-1-git-send-email-fabien.dessenne@st.com>
 <1508425830-13565-3-git-send-email-fabien.dessenne@st.com>
 <20171022072659.GB8489@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lionel DEBIEVE <lionel.debieve@st.com>,
        Benjamin GAIGNARD <benjamin.gaignard@st.com>,
        Ludovic BARRE <ludovic.barre@st.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171022072659.GB8489@Red>
Content-Language: en-US
Content-ID: <DA14ADA01B16A247BE4EC025CD29C198@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

DQoNCk9uIDIyLzEwLzE3IDA5OjI2LCBDb3JlbnRpbiBMYWJiZSB3cm90ZToNCj4gT24gVGh1LCBP
Y3QgMTksIDIwMTcgYXQgMDU6MTA6MzBQTSArMDIwMCwgRmFiaWVuIERlc3Nlbm5lIHdyb3RlOg0K
Pj4gVGhpcyBtb2R1bGUgcmVnaXN0ZXJzIGJsb2NrIGNpcGhlciBhbGdvcml0aG1zIHRoYXQgbWFr
ZSB1c2Ugb2YgdGhlDQo+PiBTVE1pY3JvZWxlY3Ryb25pY3MgU1RNMzIgY3J5cHRvICJDUllQMSIg
aGFyZHdhcmUuDQo+PiBUaGUgZm9sbG93aW5nIGFsZ29yaXRobXMgYXJlIHN1cHBvcnRlZDoNCj4+
IC0gYWVzOiBlY2IsIGNiYywgY3RyDQo+PiAtIGRlczogZWNiLCBjYmMNCj4+IC0gdGRlczogZWNi
LCBjYmMNCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBGYWJpZW4gRGVzc2VubmUgPGZhYmllbi5kZXNz
ZW5uZUBzdC5jb20+DQo+PiAtLS0NCj4+ICAgZHJpdmVycy9jcnlwdG8vc3RtMzIvS2NvbmZpZyAg
ICAgIHwgICAgOSArDQo+PiAgIGRyaXZlcnMvY3J5cHRvL3N0bTMyL01ha2VmaWxlICAgICB8ICAg
IDMgKy0NCj4+ICAgZHJpdmVycy9jcnlwdG8vc3RtMzIvc3RtMzItY3J5cC5jIHwgMTE3MiArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+PiAgIDMgZmlsZXMgY2hhbmdlZCwg
MTE4MyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+PiAgIGNyZWF0ZSBtb2RlIDEwMDY0
NCBkcml2ZXJzL2NyeXB0by9zdG0zMi9zdG0zMi1jcnlwLmMNCj4+DQo+PiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9jcnlwdG8vc3RtMzIvS2NvbmZpZyBiL2RyaXZlcnMvY3J5cHRvL3N0bTMyL0tjb25m
aWcNCj4+ICtzdGF0aWMgdm9pZCBzdG0zMl9jcnlwX2lycV93cml0ZV9ibG9jayhzdHJ1Y3Qgc3Rt
MzJfY3J5cCAqY3J5cCkNCj4+ICt7DQo+PiArCXVuc2lnbmVkIGludCBpLCBqOw0KPj4gKwl1MzIg
KnNyYzsNCj4+ICsJdTggZDhbNF07DQo+PiArDQo+PiArCXNyYyA9IHNnX3ZpcnQoY3J5cC0+aW5f
c2cpICsgX3dhbGtlZF9pbjsNCj4+ICsNCj4+ICsJZm9yIChpID0gMDsgaSA8IGNyeXAtPmh3X2Js
b2Nrc2l6ZSAvIHNpemVvZih1MzIpOyBpKyspIHsNCj4+ICsJCWlmIChsaWtlbHkoY3J5cC0+dG90
YWxfaW4gPj0gc2l6ZW9mKHUzMikpKSB7DQo+PiArCQkJLyogV3JpdGUgYSBmdWxsIHUzMiAqLw0K
Pj4gKwkJCXN0bTMyX2NyeXBfd3JpdGUoY3J5cCwgQ1JZUF9ESU4sICpzcmMpOw0KPiBIZWxsbw0K
Pg0KPiBUcnkgYWxzbyB0byB0ZXN0IHlvdXIgZHJpdmVyIHdpdGggdXNlcnNwYWNlIHZpYSBBRl9B
TEcgKGxpYmtjYXBpIGlzIGEgZ29vZCBzdGFydCkuDQo+IEl0IHNob3VsZCBwcm9iYWJseSBjcmFz
aCBoZXJlLg0KPiBJIGhhdmUgZG8gdGhlIHNhbWUgb24gbXkgZmlyc3Qgc3VueGktc3MgZHJpdmVy
IGFuZCB5b3Ugc2hvdWxkIHVzZSBrbWFwKCkuDQo+DQo+IFJlZ2FyZHMNCkhpIENvcmVudGluLA0K
DQpUaGFuayB5b3UgZm9yIHN1Z2dlc3RpbmcgdG8gdGVzdCBmcm9tIHVzZXJzcGFjZSB0aHJvdWdo
IHRoZSBBRl9BTEcgDQpzb2NrZXQgd2l0aCBsaWJrY2FwaS4NClRoaXMgaW5jcmVhc2VzIG15IHRl
c3QgY292ZXJhZ2UuDQoNCkkgcmFuIHRoZSBtaXNjZWxsYW5lb3VzIHRlc3RzIChrY2FwaS1lbmMt
dGVzdChsYXJnZSkuc2ggKyB0ZXN0LnNoKSBhbmQgDQpjb3VsZCBub3Qgb2JzZXJ2ZSBhbnkgY3Jh
c2guDQpOb3RlIHRoYXQgSSBoYWQgYWxyZWFkeSBmaXhlZCBzb21lICdtZW1vcnkgY3Jhc2hlcycg
d2hpbGUgdGVzdGluZyB3aXRoIA0KdGVzdG1nciAvIHRjcnlwdCB3aGlsZSB0ZXN0aW5nIGZyb20g
dGhlIGtlcm5lbC4NCg0KU28gaXQgbG9va3MgbGlrZSB0aGUgcHJvcG9zZWQgaW1wbGVtZW50YXRp
b24gaXMgZmluZS4NCg0KQlINCg0KRmFiaWVu
