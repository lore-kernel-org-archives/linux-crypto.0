From: Jyri Sarha <jsarha@ti.com>
Subject: Re: [PATCH 1/7] drm/tilcdc: don't use volatile with iowrite64
Date: Mon, 26 Jun 2017 11:54:25 +0300
Message-ID: <33b6c00f-1982-69dd-86b2-107266d238d0@ti.com>
References: <20170622164817.25515-1-logang@deltatee.com>
 <20170622164817.25515-2-logang@deltatee.com>
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
In-Reply-To: <20170622164817.25515-2-logang@deltatee.com>
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

T24gMDYvMjIvMTcgMTk6NDgsIExvZ2FuIEd1bnRob3JwZSB3cm90ZToKPiBUaGlzIGlzIGEgcHJl
cCBwYXRjaCBmb3IgYWRkaW5nIGEgdW5pdmVyc2FsIGlvd3JpdGU2NC4KPiAKPiBUaGUgcGF0Y2gg
aXMgdG8gcHJldmVudCBjb21waWxlciB3YXJuaW5ncyB3aGVuIHdlIGFkZCBpb3dyaXRlNjQgdGhh
dAo+IHdvdWxkIG9jY3VyIGJlY2F1c2UgdGhlcmUgaXMgYW4gdW5uZWNlc3Nhcnkgdm9sYXRpbGUg
aW4gdGhpcyBkcml2ZXIuCj4gCj4gU2lnbmVkLW9mZi1ieTogTG9nYW4gR3VudGhvcnBlIDxsb2dh
bmdAZGVsdGF0ZWUuY29tPgo+IENjOiBKeXJpIFNhcmhhIDxqc2FyaGFAdGkuY29tPgo+IENjOiBU
b21pIFZhbGtlaW5lbiA8dG9taS52YWxrZWluZW5AdGkuY29tPgo+IENjOiBEYXZpZCBBaXJsaWUg
PGFpcmxpZWRAbGludXguaWU+CgpBY2tlZC1ieTogSnlyaSBTYXJoYSA8anNhcmhhQHRpLmNvbT4K
Cj4gLS0tCj4gIGRyaXZlcnMvZ3B1L2RybS90aWxjZGMvdGlsY2RjX3JlZ3MuaCB8IDQgKystLQo+
ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+IAo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vdGlsY2RjL3RpbGNkY19yZWdzLmggYi9kcml2ZXJz
L2dwdS9kcm0vdGlsY2RjL3RpbGNkY19yZWdzLmgKPiBpbmRleCA5ZDUyOGMwYTY3YTQuLmU5Y2U3
MjU2OThhOSAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vdGlsY2RjL3RpbGNkY19yZWdz
LmgKPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vdGlsY2RjL3RpbGNkY19yZWdzLmgKPiBAQCAtMTMx
LDE0ICsxMzEsMTQgQEAgc3RhdGljIGlubGluZSB2b2lkIHRpbGNkY193cml0ZShzdHJ1Y3QgZHJt
X2RldmljZSAqZGV2LCB1MzIgcmVnLCB1MzIgZGF0YSkKPiAgc3RhdGljIGlubGluZSB2b2lkIHRp
bGNkY193cml0ZTY0KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYsIHUzMiByZWcsIHU2NCBkYXRhKQo+
ICB7Cj4gIAlzdHJ1Y3QgdGlsY2RjX2RybV9wcml2YXRlICpwcml2ID0gZGV2LT5kZXZfcHJpdmF0
ZTsKPiAtCXZvbGF0aWxlIHZvaWQgX19pb21lbSAqYWRkciA9IHByaXYtPm1taW8gKyByZWc7Cj4g
Kwl2b2lkIF9faW9tZW0gKmFkZHIgPSBwcml2LT5tbWlvICsgcmVnOwo+ICAKPiAgI2lmZGVmIGlv
d3JpdGU2NAo+ICAJaW93cml0ZTY0KGRhdGEsIGFkZHIpOwo+ICAjZWxzZQo+ICAJX19pb3dtYigp
Owo+ICAJLyogVGhpcyBjb21waWxlcyB0byBzdHJkICg9NjQtYml0IHdyaXRlKSBvbiBBUk03ICov
Cj4gLQkqKHZvbGF0aWxlIHU2NCBfX2ZvcmNlICopYWRkciA9IF9fY3B1X3RvX2xlNjQoZGF0YSk7
Cj4gKwkqKHU2NCBfX2ZvcmNlICopYWRkciA9IF9fY3B1X3RvX2xlNjQoZGF0YSk7Cj4gICNlbmRp
Zgo+ICB9Cj4gIAo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Au
b3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRl
dmVsCg==
