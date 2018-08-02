From: "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RFC PATCH 3/7] vfio: add spimdev support
Date: Thu, 2 Aug 2018 04:24:22 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19129102C@SHSMSX101.ccr.corp.intel.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
 <20180801102221.5308-4-nek.in.cn@gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D191290F7B@SHSMSX101.ccr.corp.intel.com>
 <20180802034727.GK160746@Turing-Arch-b>
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
In-Reply-To: <20180802034727.GK160746@Turing-Arch-b>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

PiBGcm9tOiBLZW5uZXRoIExlZSBbbWFpbHRvOmxpZ3Vvemh1QGhpc2lsaWNvbi5jb21dDQo+IFNl
bnQ6IFRodXJzZGF5LCBBdWd1c3QgMiwgMjAxOCAxMTo0NyBBTQ0KPiANCj4gPg0KPiA+ID4gRnJv
bTogS2VubmV0aCBMZWUNCj4gPiA+IFNlbnQ6IFdlZG5lc2RheSwgQXVndXN0IDEsIDIwMTggNjoy
MiBQTQ0KPiA+ID4NCj4gPiA+IEZyb206IEtlbm5ldGggTGVlIDxsaWd1b3podUBoaXNpbGljb24u
Y29tPg0KPiA+ID4NCj4gPiA+IFNQSU1ERVYgaXMgIlNoYXJlIFBhcmVudCBJT01NVSBNZGV2Ii4g
SXQgaXMgYSB2ZmlvLW1kZXYuIEJ1dCBkaWZmZXINCj4gZnJvbQ0KPiA+ID4gdGhlIGdlbmVyYWwg
dmZpby1tZGV2Og0KPiA+ID4NCj4gPiA+IDEuIEl0IHNoYXJlcyBpdHMgcGFyZW50J3MgSU9NTVUu
DQo+ID4gPiAyLiBUaGVyZSBpcyBubyBoYXJkd2FyZSByZXNvdXJjZSBhdHRhY2hlZCB0byB0aGUg
bWRldiBpcyBjcmVhdGVkLiBUaGUNCj4gPiA+IGhhcmR3YXJlIHJlc291cmNlIChBIGBxdWV1ZScp
IGlzIGFsbG9jYXRlZCBvbmx5IHdoZW4gdGhlIG1kZXYgaXMNCj4gPiA+IG9wZW5lZC4NCj4gPg0K
PiA+IEFsZXggaGFzIGNvbmNlcm4gb24gZG9pbmcgc28sIGFzIHBvaW50ZWQgb3V0IGluOg0KPiA+
DQo+ID4gCWh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2t2bS9tc2cxNzI2NTIuaHRtbA0K
PiA+DQo+ID4gcmVzb3VyY2UgYWxsb2NhdGlvbiBzaG91bGQgYmUgcmVzZXJ2ZWQgYXQgY3JlYXRp
b24gdGltZS4NCj4gDQo+IFllcy4gVGhhdCBpcyB3aHkgSSBrZWVwIHRlbGxpbmcgdGhhdCBTUElN
REVWIGlzIG5vdCBmb3IgIlZNIiwgaXQgaXMgZm9yICJtYW55DQo+IHByb2Nlc3NlcyIsIGl0IGlz
IGp1c3QgYW4gYWNjZXNzIHBvaW50IHRvIHRoZSBwcm9jZXNzLiBOb3QgYSBkZXZpY2UgdG8gVk0u
IEkNCj4gaG9wZQ0KPiBBbGV4IGNhbiBhY2NlcHQgaXQ6KQ0KPiANCg0KVkZJTyBpcyBqdXN0IGFi
b3V0IGFzc2lnbmluZyBkZXZpY2UgcmVzb3VyY2UgdG8gdXNlciBzcGFjZS4gSXQgZG9lc24ndCBj
YXJlDQp3aGV0aGVyIGl0J3MgbmF0aXZlIHByb2Nlc3NlcyBvciBWTSB1c2luZyB0aGUgZGV2aWNl
IHNvIGZhci4gQWxvbmcgdGhlIGRpcmVjdGlvbg0Kd2hpY2ggeW91IGRlc2NyaWJlZCwgbG9va3Mg
VkZJTyBuZWVkcyB0byBzdXBwb3J0IHRoZSBjb25maWd1cmF0aW9uIHRoYXQNCnNvbWUgbWRldnMg
YXJlIHVzZWQgZm9yIG5hdGl2ZSBwcm9jZXNzIG9ubHksIHdoaWxlIG90aGVycyBjYW4gYmUgdXNl
ZA0KZm9yIGJvdGggbmF0aXZlIGFuZCBWTS4gSSdtIG5vdCBzdXJlIHdoZXRoZXIgdGhlcmUgaXMg
YSBjbGVhbiB3YXkgdG8NCmVuZm9yY2UgaXQuLi4NCg0KTGV0J3MgaGVhciBmcm9tIEFsZXgncyB0
aG91Z2h0Lg0KDQpUaGFua3MNCktldmluDQo=
