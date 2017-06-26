From: Jyri Sarha <jsarha@ti.com>
Subject: Re: [PATCH 6/7] drm/tilcdc: clean up ifdef hacks around iowrite64
Date: Mon, 26 Jun 2017 11:55:03 +0300
Message-ID: <504da99a-838c-48ec-c5b2-6b611d587a10@ti.com>
References: <20170622164817.25515-1-logang@deltatee.com>
 <20170622164817.25515-7-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Tomi Valkeinen <tomi.valkeinen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
 Stephen Bates <sbates@raithlin.com>
To: Logan Gunthorpe <logang@deltatee.com>, <linux-kernel@vger.kernel.org>,
 <linux-arch@vger.kernel.org>, <linux-ntb@googlegroups.com>,
 <linux-alpha@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-crypto@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20170622164817.25515-7-logang@deltatee.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
List-Id: linux-crypto.vger.kernel.org

T24gMDYvMjIvMTcgMTk6NDgsIExvZ2FuIEd1bnRob3JwZSB3cm90ZToKPiBOb3cgdGhhdCB3ZSBj
YW4gZXhwZWN0IGlvd3JpdGU2NCB0byBhbHdheXMgZXhpc3QgdGhlIGhhY2sgaXMgbm8gbG9uZ2Vy
Cj4gbmVjZXNzYXJ5IHNvIHdlIGp1c3QgY2FsbCBpb3dyaXRlNjQgZGlyZWN0bHkuCj4gCj4gU2ln
bmVkLW9mZi1ieTogTG9nYW4gR3VudGhvcnBlIDxsb2dhbmdAZGVsdGF0ZWUuY29tPgo+IENjOiBK
eXJpIFNhcmhhIDxqc2FyaGFAdGkuY29tPgo+IENjOiBUb21pIFZhbGtlaW5lbiA8dG9taS52YWxr
ZWluZW5AdGkuY29tPgo+IENjOiBEYXZpZCBBaXJsaWUgPGFpcmxpZWRAbGludXguaWU+CgpBY2tl
ZC1ieTogSnlyaSBTYXJoYSA8anNhcmhhQHRpLmNvbT4KCkFuZCB0aGFua3MhCgo+IC0tLQo+ICBk
cml2ZXJzL2dwdS9kcm0vdGlsY2RjL3RpbGNkY19yZWdzLmggfCA2IC0tLS0tLQo+ICAxIGZpbGUg
Y2hhbmdlZCwgNiBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJt
L3RpbGNkYy90aWxjZGNfcmVncy5oIGIvZHJpdmVycy9ncHUvZHJtL3RpbGNkYy90aWxjZGNfcmVn
cy5oCj4gaW5kZXggZTljZTcyNTY5OGE5Li4wYjkwMTQwNWYzMGEgMTAwNjQ0Cj4gLS0tIGEvZHJp
dmVycy9ncHUvZHJtL3RpbGNkYy90aWxjZGNfcmVncy5oCj4gKysrIGIvZHJpdmVycy9ncHUvZHJt
L3RpbGNkYy90aWxjZGNfcmVncy5oCj4gQEAgLTEzMywxMyArMTMzLDcgQEAgc3RhdGljIGlubGlu
ZSB2b2lkIHRpbGNkY193cml0ZTY0KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYsIHUzMiByZWcsIHU2
NCBkYXRhKQo+ICAJc3RydWN0IHRpbGNkY19kcm1fcHJpdmF0ZSAqcHJpdiA9IGRldi0+ZGV2X3By
aXZhdGU7Cj4gIAl2b2lkIF9faW9tZW0gKmFkZHIgPSBwcml2LT5tbWlvICsgcmVnOwo+ICAKPiAt
I2lmZGVmIGlvd3JpdGU2NAo+ICAJaW93cml0ZTY0KGRhdGEsIGFkZHIpOwo+IC0jZWxzZQo+IC0J
X19pb3dtYigpOwo+IC0JLyogVGhpcyBjb21waWxlcyB0byBzdHJkICg9NjQtYml0IHdyaXRlKSBv
biBBUk03ICovCj4gLQkqKHU2NCBfX2ZvcmNlICopYWRkciA9IF9fY3B1X3RvX2xlNjQoZGF0YSk7
Cj4gLSNlbmRpZgo+ICB9Cj4gIAo+ICBzdGF0aWMgaW5saW5lIHUzMiB0aWxjZGNfcmVhZChzdHJ1
Y3QgZHJtX2RldmljZSAqZGV2LCB1MzIgcmVnKQo+IAoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxA
bGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxt
YW4vbGlzdGluZm8vZHJpLWRldmVsCg==
