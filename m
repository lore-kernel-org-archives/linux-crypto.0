From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH 1/2] Fix static checker warning
Date: Wed, 19 Sep 2018 13:40:53 +0000
Message-ID: <8dfca0f4-6639-3444-148f-eb0b0817fec6@amd.com>
References: <cover.1536959537.git.Janakarajan.Natarajan@amd.com>
 <31c49295223e51f5c1c4e36e7a09fe100dab1711.1536959537.git.Janakarajan.Natarajan@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Dan Carpenter <Dan.Carpenter@oracle.com>
To: "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <31c49295223e51f5c1c4e36e7a09fe100dab1711.1536959537.git.Janakarajan.Natarajan@amd.com>
Content-Language: en-US
Content-ID: <B459037630B75D43A2C089B6DDD7A5F5@namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

T24gMDkvMTQvMjAxOCAwNTozMiBQTSwgSmFuYWthcmFqYW4gTmF0YXJhamFuIHdyb3RlOg0KPiBV
bmRlciBjZXJ0YWluIGNvbmZpZ3VyYXRpb24gU0VWIGZ1bmN0aW9ucyBjYW4gYmUgZGVmaW5lZCBh
cyBuby1vcC4NCj4gSW4gc3VjaCBhIGNhc2UgZXJyb3IgY2FuIGJlIHVuaW5pdGlhbGl6ZWQuDQo+
IA0KPiBJbml0aWFsaXplIHRoZSB2YXJpYWJsZSB0byAwLg0KPiANCj4gQ2M6IERhbiBDYXJwZW50
ZXIgPERhbi5DYXJwZW50ZXJAb3JhY2xlLmNvbT4NCj4gUmVwb3J0ZWQtYnk6IERhbiBDYXJwZW50
ZXIgPERhbi5DYXJwZW50ZXJAb3JhY2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogSmFuYWthcmFq
YW4gTmF0YXJhamFuIDxKYW5ha2FyYWphbi5OYXRhcmFqYW5AYW1kLmNvbT4NCg0KQWNrZWQtYnk6
IEdhcnkgUiBIb29rIDxnYXJ5Lmhvb2tAYW1kLmNvbT4NCg0KPiAtLS0NCj4gICBkcml2ZXJzL2Ny
eXB0by9jY3AvcHNwLWRldi5jIHwgMiArLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2Nj
cC9wc3AtZGV2LmMgYi9kcml2ZXJzL2NyeXB0by9jY3AvcHNwLWRldi5jDQo+IGluZGV4IDcyNzkw
ZDguLmY1NDFlNjAgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2NjcC9wc3AtZGV2LmMN
Cj4gKysrIGIvZHJpdmVycy9jcnlwdG8vY2NwL3BzcC1kZXYuYw0KPiBAQCAtNDIzLDcgKzQyMyw3
IEBAIEVYUE9SVF9TWU1CT0xfR1BMKHBzcF9jb3B5X3VzZXJfYmxvYik7DQo+ICAgc3RhdGljIGlu
dCBzZXZfZ2V0X2FwaV92ZXJzaW9uKHZvaWQpDQo+ICAgew0KPiAgIAlzdHJ1Y3Qgc2V2X3VzZXJf
ZGF0YV9zdGF0dXMgKnN0YXR1czsNCj4gLQlpbnQgZXJyb3IsIHJldDsNCj4gKwlpbnQgZXJyb3Ig
PSAwLCByZXQ7DQo+ICAgDQo+ICAgCXN0YXR1cyA9ICZwc3BfbWFzdGVyLT5zdGF0dXNfY21kX2J1
ZjsNCj4gICAJcmV0ID0gc2V2X3BsYXRmb3JtX3N0YXR1cyhzdGF0dXMsICZlcnJvcik7DQo+IA0K
DQo=
