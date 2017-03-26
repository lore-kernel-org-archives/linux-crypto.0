From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v3 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Sun, 26 Mar 2017 21:00:12 +0300
Message-ID: <20170326180012.3eic4bt2p6h6u3nh@kozik-lap>
References: <20170325162654.3827-1-krzk@kernel.org>
 <20170325162654.3827-2-krzk@kernel.org>
 <2736911.EcZSki4vB1@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-samsung-soc@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Arnd Bergmann <arnd@arndb.de>,
 Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
 linux-kernel@vger.kernel.org,
 Javier Martinez Canillas <javier@osg.samsung.com>,
 Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
 Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <2736911.EcZSki4vB1@positron.chronox.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

T24gU3VuLCBNYXIgMjYsIDIwMTcgYXQgMDc6MTE6MjhQTSArMDIwMCwgU3RlcGhhbiBNw7xsbGVy
IHdyb3RlOgo+IEFtIFNhbXN0YWcsIDI1LiBNw6RyeiAyMDE3LCAxNzoyNjo1MiBDRVNUIHNjaHJp
ZWIgS3J6eXN6dG9mIEtvemxvd3NraToKPiA+ICtzdGF0aWMgaW50IGV4eW5vc19ybmdfc2V0X3Nl
ZWQoc3RydWN0IGV4eW5vc19ybmdfZGV2ICpybmcsCj4gPiArCQkJICAgICAgIGNvbnN0IHU4ICpz
ZWVkLCB1bnNpZ25lZCBpbnQgc2xlbikKPiA+ICt7Cj4gPiArCXUzMiB2YWw7Cj4gPiArCWludCBp
Owo+ID4gKwo+ID4gKwlkZXZfZGJnKHJuZy0+ZGV2LCAiU2VlZGluZyB3aXRoICV1IGJ5dGVzXG4i
LCBzbGVuKTsKPiA+ICsKPiA+ICsJaWYgKHNsZW4gPCBFWFlOT1NfUk5HX1NFRURfU0laRSkgewo+
ID4gKwkJZGV2X3dhcm4ocm5nLT5kZXYsICJTZWVkIHRvbyBzaG9ydCAob25seSAldSBieXRlcylc
biIsIHNsZW4pOwo+ID4gKwkJcmV0dXJuIC1FSU5WQUw7Cj4gPiArCX0KPiA+ICsKPiA+ICsJZm9y
IChpID0gMCA7IGkgPCBFWFlOT1NfUk5HX1NFRURfUkVHUyA7IGkrKykgewo+ID4gKwkJdmFsID0g
c2VlZFtpICogNF0gPDwgMjQ7Cj4gPiArCQl2YWwgfD0gc2VlZFtpICogNCArIDFdIDw8IDE2Owo+
ID4gKwkJdmFsIHw9IHNlZWRbaSAqIDQgKyAyXSA8PCA4Owo+ID4gKwkJdmFsIHw9IHNlZWRbaSAq
IDQgKyAzXSA8PCAwOwo+ID4gKwo+ID4gKwkJZXh5bm9zX3JuZ193cml0ZWwocm5nLCB2YWwsIEVY
WU5PU19STkdfU0VFRChpKSk7Cj4gPiArCX0KPiAKPiBXb3VsZCBpdCBtYWtlIHNlbnNlIHRvIGFk
ZCBhbm90aGVyIG91dGVyIGxvb3AgaGVyZSB0byBhbGxvdyBhbGwgb2Ygc2xlbiB0byBiZSAKPiBp
bmplY3RlZCBpbnRvIHRoZSBEUk5HPyBOb3RlLCBpbiBzb21lIGNhc2VzLCBhIHVzZXIgd2FudHMg
dG8gYWRkIG1vcmUgc2VlZCAKPiBpbnRvIHRoZSBEUk5HIHRoYW4gdGhlIGFjdHVhbCBzZWVkIHNp
emUuIEluIHRoaXMgY2FzZSwgdGhlIERSTkcgYWN0cyBhcyBhIAo+IGNvbXByZXNzaW9uIG9wZXJh
dGlvbiBvZiBlbnRyb3B5LiBUaGlzIGlzIHVzZWQgd2hlbiB0aGUgZW50cm9weS10by1kYXRhIHJh
dGlvIAo+IGlzIG5vdCAxOjEuIEluIGEgbG90IG9mIGNhc2VzLCB1c2VycyBoYXZlIGEgc2VlZCB3
aGljaCBoYXMgbGVzcyBlbnRyb3B5IGluIAo+IGJpdHMgcGVyIGRhdGEgYml0LgoKSGksCgpJIGRv
IG5vdCBrbm93IHdoZXRoZXIgdGhpcyB3b3VsZCBoYXZlIGFueSBiZW5lZml0IG9uIGhhcmR3YXJl
LiBUaGUKZGF0YXNoZWV0IGlzIG5vdCBkZXNjcmliaW5nIHRvbyBtdWNoIGhlcmUuIEl0IGlzIGFj
dHVhbGx5IHNheWluZyBvbmx5OgoxLiBXcml0ZSBTRUVEIHRvIGVhY2ggcmVnaXN0ZXIgKGZpdmUg
aW4gdG90YWwpLgoyLiBDb25maXJtIHRoYXQgU1RBVFVTIHJlZ2lzdGVyIHNheXMgc2VlZGluZyBk
b25lLgozLiBTdGFydCBSTkcgZW5naW5lLgo0LiBXYWl0IGZvciBlbmdpbmUgZmluaXNoIChhbm90
aGVyIGJpdCBpbiBTVEFUVVMgLSBjbGVhciBpdCB0aGVuKS4KNS4gUmVhZCB0aGUgcmFuZG9tcy4K
Ckkgd291bGQgZ3Vlc3MgdGhhdCB0aGUgaGFyZHdhcmUgd2lsbCBpZ25vcmUgYWxsIHByZXZpb3Vz
bHkgd3JpdHRlbiBzZWVkcwphbmQgdXNlIHRoZSBsYXN0IG9uZS4gTWF5YmUgdGhlIGhhcmR3YXJl
IHdpbGwgdXNlIGFsbCBvZiB0aGUgc2VlZHMKd3JpdHRlbiBhcyB5b3UgaW1wbHkuIEl0IGlzIGp1
c3QgYSBndWVzc2luZy4KCkJlc3QgcmVnYXJkcywKS3J6eXN6dG9mCgoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KbGludXgtYXJtLWtlcm5lbCBtYWlsaW5n
IGxpc3QKbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9saXN0cy5p
bmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtYXJtLWtlcm5lbAo=
