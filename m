From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 3/7] asm-generic/io.h: make ioread64 and iowrite64
 universally available
Date: Thu, 22 Jun 2017 21:36:55 +0100
Message-ID: <20170622213655.07dffac2@alans-desktop>
References: <20170622164817.25515-1-logang@deltatee.com>
 <20170622164817.25515-4-logang@deltatee.com>
 <20170622211431.14270378@alans-desktop>
 <e856de0b-e9a3-8228-7a73-4daa38cb4479@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, Stephen Bates <sbates@raithlin.com>,
 linux-crypto@vger.kernel.org, linux-alpha@vger.kernel.org,
 linux-ntb@googlegroups.com, linuxppc-dev@lists.ozlabs.org
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <e856de0b-e9a3-8228-7a73-4daa38cb4479@deltatee.com>
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

T24gVGh1LCAyMiBKdW4gMjAxNyAxNDoyNDo1OCAtMDYwMApMb2dhbiBHdW50aG9ycGUgPGxvZ2Fu
Z0BkZWx0YXRlZS5jb20+IHdyb3RlOgoKPiBPbiA2LzIyLzIwMTcgMjoxNCBQTSwgQWxhbiBDb3gg
d3JvdGU6Cj4gPiBJZiBhIHBsYXRmb3JtIGRvZXNuJ3Qgc3VwcG9ydCA2NGJpdCBJL08gb3BlcmF0
aW9ucyBmcm9tIHRoZSBDUFUgdGhlbiB5b3UKPiA+IGVpdGhlciBuZWVkIHRvIHVzZSBzb21lIGtp
bmQgb2YgcGxhdGZvcm0vYXJjaGl0ZWN0dXJlIHNwZWNpZmljIGludGVyZmFjZQo+ID4gaWYgcHJl
c2VudCBvciBhY2NlcHQgeW91IGRvbid0IGhhdmUgb25lLiAgCj4gCj4gWWVzLCBJIHVuZGVyc3Rh
bmQgdGhhdC4KPiAKPiBUaGUgdGhpbmcgaXMgdGhhdCBldmVyeSB1c2VyIHRoYXQncyBjdXJyZW50
bHkgdXNpbmcgaXQgcmlnaHQgbm93IGlzIAo+IHBhdGNoaW5nIGluIHRoZWlyIG93biB2ZXJzaW9u
IHRoYXQgc3BsaXRzIGl0IG9uIG5vbi02NGJpdCBzeXN0ZW1zLgo+IAo+ID4gSXQncyBub3Qgc2Fm
ZSB0byBzcGxpdCBpdC4gUG9zc2libHkgZm9yIHNvbWUgdXNlIGNhc2VzIHlvdSBjb3VsZCBhZGQg
YW4KPiA+IGlvcmVhZDY0X21heXNwbGl0KCkgIAo+IAo+IEknbSBvcGVuIHRvIGRvaW5nIHNvbWV0
aGluZyBsaWtlIHRoYXQuCgpJIHRoaW5rIHRoYXQgbWFrZXMgc2Vuc2UgZm9yIHRoZSBwbGF0Zm9y
bXMgd2l0aCB0aGF0IHByb2JsZW0uIEknbSBub3QKc3VyZSB0aGVyZSBhcmUgbWFueSB0aGF0IGNh
bid0IGRvIGl0IGZvciBtbWlvIGF0IGxlYXN0LiA0ODZTWCBjYW4ndCBkbyBpdAphbmQgSSBndWVz
cyBzb21lIEFSTTMyIGJ1dCBJIHRoaW5rIGFsbW9zdCBldmVyeW9uZSBlbHNlIGNhbiBpbmNsdWRp
bmcKbW9zdCAzMmJpdCB4ODYuCgpXaGF0J3MgbW9yZSBvZiBhIHByb2JsZW0gaXMgYSBsb3Qgb2Yg
cGxhdGZvcm1zIGNhbiBkbyA2NGJpdCBNTUlPIHZpYQppb3JlYWQvd3JpdGU2NCBidXQgbm90IDY0
Yml0IHBvcnQgSS9PLCBhbmQgaXQncyBub3QgY2xlYXIgaG93IHlvdQpyZXByZXNlbnQgdGhhdCB2
aWEgYW4gaW9yZWFkL3dyaXRlIEFQSSB0aGF0IGFic3RyYWN0cyBpdCBhd2F5LgoKQWxhbgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFp
bGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5m
cmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
