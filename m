From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 4/7] alpha: provide ioread64 and iowrite64 implementations
Date: Thu, 22 Jun 2017 23:03:17 +0200
Message-ID: <CAK8P3a1R-uvjjs=UpbvJjVXnFpD_OL1aRsw0KE_GkvNy+dVj8g@mail.gmail.com>
References: <20170622164817.25515-1-logang@deltatee.com>
 <20170622164817.25515-5-logang@deltatee.com>
 <20170622210828.27304f6a@alans-desktop>
 <401cdb64-6fdb-be30-b8bc-bf51c1a35074@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-arch <linux-arch@vger.kernel.org>,
 Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 dri-devel <dri-devel@lists.freedesktop.org>,
 Stephen Bates <sbates@raithlin.com>,
 Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-crypto@vger.kernel.org,
 linux-alpha@vger.kernel.org, linux-ntb@googlegroups.com,
 linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
 Richard Henderson <rth@twiddle.net>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <401cdb64-6fdb-be30-b8bc-bf51c1a35074@deltatee.com>
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

T24gVGh1LCBKdW4gMjIsIDIwMTcgYXQgMTA6MDkgUE0sIExvZ2FuIEd1bnRob3JwZSA8bG9nYW5n
QGRlbHRhdGVlLmNvbT4gd3JvdGU6Cj4gT24gNi8yMi8yMDE3IDI6MDggUE0sIEFsYW4gQ294IHdy
b3RlOgo+Pgo+PiBCdXQgdGhpcyBkb2VzIG5vdCBkbyB0aGUgc2FtZSB0aGluZyBhcyBhbiBpb3Jl
YWQ2NCB3aXRoIHJlZ2FyZHMgdG8KPj4gYXRvbWljaXR5IG9yIHNpZGUgZWZmZWN0cyBvbiB0aGUg
ZGV2aWNlLiBUaGUgc2FtZSBpcyB0cnVlIG9mIHRoZSBvdGhlcgo+PiBoYWNrcy4gWW91IGVpdGhl
ciBoYXZlIGEgcmVhbCA2NGJpdCBzaW5nbGUgcmVhZC93cml0ZSBmcm9tIE1NSU8gc3BhY2Ugb3IK
Pj4geW91IGRvbid0LiBZb3UgY2FuJ3QgZmFrZSBpdC4KPgo+Cj4gWWVzLCBJIGtub3cuIEJ1dCBp
cyBpdCBub3QgYmV0dGVyIHRoYW4gaGF2aW5nIGV2ZXJ5IGRyaXZlciB0aGF0IHdhbnRzIHRvIHVz
ZQo+IHRoZXNlIGZ1bmN0aW9ucyBmYWtlIGl0IHRoZW1zZWx2ZXM/CgpEcml2ZXJzIHRoYXQgd2Fu
dCBhIG5vbi1hdG9taWMgdmFyaWFudCBzaG91bGQgaW5jbHVkZSBlaXRoZXIKaW5jbHVkZS9saW51
eC9pby02NC1ub25hdG9taWMtaGktbG8uaCBvciBpbmNsdWRlL2xpbnV4L2lvLTY0LW5vbmF0b21p
Yy1sby1oaS5oCmRlcGVuZGluZyBvbiB3aGF0IHRoZXkgbmVlZC4gRHJpdmVycyB0aGF0IHJlcXVp
cmUgNjQtYml0IEkvTyBzaG91bGQKcHJvYmFibHkganVzdCBkZXBlbmQgb24gQ09ORklHXzY0QklU
IGFuZCBtYXliZSB1c2UgcmVhZHEvd3JpdGVxLgoKSSBzZWUgdGhhdCB0aGVyZSBhcmUgZXhhY3Rs
eSB0d28gZHJpdmVycyBjYWxsaW5nIGlvcmVhZDY0L2lvd3JpdGU2NDoKZHJpdmVycy9jcnlwdG8v
Y2FhbS8gaXMgYXJjaGl0ZWN0dXJlIHNwZWNpZmljIGFuZApkcml2ZXJzL250Yi9ody9pbnRlbC9u
dGJfaHdfaW50ZWwuYyBhbHJlYWR5IGhhcyBhIHdvcmthcm91bmQgdGhhdCBzaG91bGQKbWFrZSBp
dCBidWlsZCBvbiBhbHBoYS4KCiAgICAgICAgQXJuZApfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBs
aXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1h
bi9saXN0aW5mby9kcmktZGV2ZWwK
