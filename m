From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: Re: [PATCH v3 0/3] STM32 CRYP crypto driver
Date: Mon, 18 Sep 2017 09:40:02 +0000
Message-ID: <7be8c468-2e95-c781-3af3-d411acc80598@st.com>
References: <1503047946-27799-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Benjamin GAIGNARD <benjamin.gaignard@st.com>,
        Lionel DEBIEVE <lionel.debieve@st.com>,
        Ludovic BARRE <ludovic.barre@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503047946-27799-1-git-send-email-fabien.dessenne@st.com>
Content-Language: en-US
Content-ID: <8BDBEBD1600EBF48A5C5DAF1F4620718@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

SnVzdCBhIGdlbnRsZSBwaW5nIC4uLiBvciBoYXZlIEkgbWlzc2VkIG91dCBvbiBhIHJlcGx5Pw0K
DQoNCk9uIDE4LzA4LzE3IDExOjE5LCBGYWJpZW4gRGVzc2VubmUgd3JvdGU6DQo+IFRoaXMgc2V0
IG9mIHBhdGNoZXMgYWRkcyBhIG5ldyBjcnlwdG8gZHJpdmVyIGZvciBTVE1pY3JvZWxlY3Ryb25p
Y3Mgc3RtMzIgSFcuDQo+IFRoaXMgZHJpdmVycyB1c2VzIHRoZSBjcnlwdG8gQVBJIGFuZCBwcm92
aWRlcyB3aXRoIEhXLWVuYWJsZWQgQUVBRCBhbmQgYmxvY2sNCj4gY2lwaGVyIGFsZ29yaXRobXMu
DQo+IEl0IG1ha2VzIHVzZSBvZiB0aGUgY3J5cHRvIGVuZ2luZSB3aGljaCBpcyB1cGdyYWRlZCBp
biBvcmRlciB0byBzdXBwb3J0IEFFQUQNCj4gcmVxdWVzdHMuDQo+DQo+IFRoaXMgZHJpdmVyIHdh
cyBzdWNjZXNzZnVsbHkgdGVzdGVkIHdpdGggdGNyeXB0IC8gdGVzdG1nci4NCj4NCj4gQ2hhbmdl
cyBzaW5jZSB2MzoNCj4gLSB1cGRhdGUgZHQtYmluZGluZ3Mgd2l0aCBSb2IgSGVycmluZyByZW1h
cmtzDQo+DQo+IENoYW5nZXMgc2luY2UgdjI6DQo+IC0gdXBkYXRlIGR0LWJpbmRpbmdzIChpbnRl
cnJ1cHRzIGRlc2NyaXB0aW9uKQ0KPiAtIHJlYmFzZSBvbiBTVE0zMiBjcnlwdG8gcGF0Y2hlcyAo
TC4gRGViaWV2ZSA6IHVwZGF0ZSBDUkMzMiArIGFkZCBIQVNIKQ0KPg0KPiBGYWJpZW4gRGVzc2Vu
bmUgKDMpOg0KPiAgICBjcnlwdG86IGVuZ2luZSAtIHBlcm1pdCB0byBlbnF1ZXVlIGFlYWRfcmVx
dWVzdA0KPiAgICBkdC1iaW5kaW5nczogRG9jdW1lbnQgU1RNMzIgQ1JZUCBiaW5kaW5ncw0KPiAg
ICBjcnlwdG86IHN0bTMyIC0gU3VwcG9ydCBmb3IgU1RNMzIgQ1JZUCBjcnlwdG8gbW9kdWxlDQo+
DQo+ICAgLi4uL2RldmljZXRyZWUvYmluZGluZ3MvY3J5cHRvL3N0LHN0bTMyLWNyeXAudHh0ICAg
fCAgIDE5ICsNCj4gICBjcnlwdG8vY3J5cHRvX2VuZ2luZS5jICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8ICAxMDEgKw0KPiAgIGRyaXZlcnMvY3J5cHRvL3N0bTMyL0tjb25maWcgICAgICAg
ICAgICAgICAgICAgICAgIHwgICAgOSArDQo+ICAgZHJpdmVycy9jcnlwdG8vc3RtMzIvTWFrZWZp
bGUgICAgICAgICAgICAgICAgICAgICAgfCAgICAzICstDQo+ICAgZHJpdmVycy9jcnlwdG8vc3Rt
MzIvc3RtMzItY3J5cC5jICAgICAgICAgICAgICAgICAgfCAxOTYyICsrKysrKysrKysrKysrKysr
KysrDQo+ICAgaW5jbHVkZS9jcnlwdG8vZW5naW5lLmggICAgICAgICAgICAgICAgICAgICAgICAg
ICAgfCAgIDE2ICsNCj4gICA2IGZpbGVzIGNoYW5nZWQsIDIxMDkgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQ0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvY3J5cHRvL3N0LHN0bTMyLWNyeXAudHh0DQo+ICAgY3JlYXRlIG1vZGUgMTAw
NjQ0IGRyaXZlcnMvY3J5cHRvL3N0bTMyL3N0bTMyLWNyeXAuYw0KPg0K
