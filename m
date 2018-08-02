From: "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RFC PATCH 1/7] vfio/spimdev: Add documents for WarpDrive
 framework
Date: Thu, 2 Aug 2018 04:41:32 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D191291097@SHSMSX101.ccr.corp.intel.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
 <20180801102221.5308-2-nek.in.cn@gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D191290F04@SHSMSX101.ccr.corp.intel.com>
 <20180802042235.GN160746@Turing-Arch-b>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Kenneth Lee <nek.in.cn@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Fang <fanghao11@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
To: Kenneth Lee <liguozhu@hisilicon.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802042235.GN160746@Turing-Arch-b>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

PiBGcm9tOiBLZW5uZXRoIExlZQ0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDIsIDIwMTggMTI6
MjMgUE0NCj4gDQo+IE9uIFRodSwgQXVnIDAyLCAyMDE4IGF0IDAzOjE0OjM4QU0gKzAwMDAsIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+DQo+ID4gPiBGcm9tOiBLZW5uZXRoIExlZQ0KPiA+ID4gU2Vu
dDogV2VkbmVzZGF5LCBBdWd1c3QgMSwgMjAxOCA2OjIyIFBNDQo+ID4gPg0KPiA+ID4gRnJvbTog
S2VubmV0aCBMZWUgPGxpZ3Vvemh1QGhpc2lsaWNvbi5jb20+DQo+ID4gPg0KPiA+ID4gV2FycERy
aXZlIGlzIGEgY29tbW9uIHVzZXIgc3BhY2UgYWNjZWxlcmF0b3IgZnJhbWV3b3JrLiAgSXRzIG1h
aW4NCj4gPiA+IGNvbXBvbmVudA0KPiA+ID4gaW4gS2VybmVsIGlzIGNhbGxlZCBzcGltZGV2LCBT
aGFyZSBQYXJlbnQgSU9NTVUgTWVkaWF0ZWQgRGV2aWNlLiBJdA0KPiA+DQo+ID4gTm90IHN1cmUg
d2hldGhlciAic2hhcmUgcGFyZW50IElPTU1VIiBpcyBhIGdvb2QgdGVybSBoZXJlLiBiZXR0ZXIN
Cj4gPiBzdGljayB0byB3aGF0IGNhcGFiaXR5IHlvdSBicmluZyB0byB1c2VyIHNwYWNlLCBpbnN0
ZWFkIG9mIGRlc2NyaWJpbmcNCj4gPiBpbnRlcm5hbCB0cmljay4uLg0KPiBBZ3JlZS4gVGhlICJT
UEkiIGlzIGFsc28gc3Ryb25nbHkgaGludCB0byAiU2hhcmUgUGVyaXBoZXJhbCBJbnRlcnJ1cHQi
IG9yDQo+ICJTZXJpYWwNCj4gUGVyaXBoZXJhbCBJbnRlcmZhY2UiLiBQZXJzb25hbGx5IEkgaGF0
ZSB0aGlzIG5hbWUuIEJ1dCBJIGNhbm5vdCBmaW5kIGEgYmV0dGVyDQo+IG9uZS4gSW4gdGhlIHVz
ZXIgc3BhY2UsIHdlIGNhbiB1c2UgYSBpbXBhc3NpYmxlIG5hbWUgKFdhcnBEcml2ZSkuIEJ1dA0K
PiBrZXJuZWwNCj4gcmVxdWlyZSBhIG5hbWUgcG9pbnQgdG8gaXRzIGZlYXR1cmUuLi4gbWF5YmUg
SSBzaG91bGQgdXNlICJQcm9jZXNzLVNoYXJlZA0KPiBNZGV2Ig0KPiBpbiBuZXh0IHZlcnNpb24/
DQoNCm9yIG1heWJlIG5vIG5ldyBuYW1lLiBKdXN0IHN0aWNrIHRvIG1kZXYgYnV0IGludHJvZHVj
aW5nIHNvbWUNCm5ldyBhdHRyaWJ1dGUvY2FwYWJpbGl0eSB0byBpbmRpY2F0ZSBzdWNoIHB1cnBv
c2UuDQoNClRoYW5rcw0KS2V2aW4NCg==
