From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v3 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Sun, 26 Mar 2017 21:09:59 +0300
Message-ID: <20170326180959.rmps6pj5376l45fz@kozik-lap>
References: <20170325162654.3827-1-krzk@kernel.org>
 <20170326160126.nwboar7mwztwxtgp@kozik-lap>
 <CANc+2y4xkDs2kQGXKP=8i_v9oYw4dPKTjWs0xFnvOcwDbar47g@mail.gmail.com>
 <1535446.zHpTqe8jba@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-samsung-soc@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Arnd Bergmann <arnd@arndb.de>,
 Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
 PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
 linux-kernel@vger.kernel.org,
 Javier Martinez Canillas <javier@osg.samsung.com>,
 Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
 Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1535446.zHpTqe8jba@positron.chronox.de>
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

T24gU3VuLCBNYXIgMjYsIDIwMTcgYXQgMDc6MDU6NDhQTSArMDIwMCwgU3RlcGhhbiBNw7xsbGVy
IHdyb3RlOgo+IEFtIFNvbm50YWcsIDI2LiBNw6RyeiAyMDE3LCAxODo0NjowMiBDRVNUIHNjaHJp
ZWIgUHJhc2FubmFLdW1hciBNdXJhbGlkaGFyYW46Cj4gCj4gSGkgCUtyenlzenRvZiwKPiAKPiA+
ID4+ID4gKyAgICAgICBpZiAoc2xlbiA8IEVYWU5PU19STkdfU0VFRF9TSVpFKSB7Cj4gPiA+PiA+
ICsgICAgICAgICAgICAgICBkZXZfd2FybihybmctPmRldiwgIlNlZWQgdG9vIHNob3J0IChvbmx5
ICV1IGJ5dGVzKVxuIiwKPiA+ID4+ID4gc2xlbik7ICsgICAgICAgICAgICAgICByZXR1cm4gLUVJ
TlZBTDsKPiA+ID4+ID4gKyAgICAgICB9Cj4gPiA+PiAKPiA+ID4+IFdpbGwgaXQgYmUgaGVscGZ1
bCB0byBwcmludCB0aGUgcmVxdWlyZWQgc2VlZCBzaXplPwo+ID4gPiAKPiA+ID4gSXQgaXMgaW4g
L3Byb2MvY3J5cHRvLi4uIEl0IGlzIG5vdCBhIHByb2JsZW0gdG8gcHJpbnQgaXQgYnV0IGlzbid0
IHRoYXQKPiA+ID4gcmVkdW5kYW50Pwo+ID4gCj4gPiBOb3QgbmVjZXNzYXJ5IGlmIGl0IGlzIGFs
cmVhZHkgYXZhaWxhYmxlLgo+IAo+IE1heWJlIHRoZSBkZXZfd2FybiBzaG91bGQgYmUgcmVtb3Zl
ZC4gTm90ZSwgdW5wcml2aWxlZ2VkIHVzZXIgc3BhY2UgY2FuIAo+IHRyaWdnZXIgdGhpcyB3YXJu
aW5nIGJ5IHNpbXBseSBpbnZva2luZyB0aGUgc2VlZGluZyBvcGVyYXRpb24gb3ZlciBhbmQgb3Zl
ciAKPiBhZ2FpbiB3aXRoIGFuIGluc3VmZmljaWVudCBzZWVkIHNpemUuIFRoaXMgd291bGQgY2x1
dHRlciB0aGUgbG9nLgoKTWFrZXMgc2Vuc2UuIFRoZSBnZW5lcmljIGRldl9kYmcoKSBiZWZvcmUg
d291bGQgYnJpbmcgZW5vdWdoCmluZm9ybWF0aW9uLgoKQmVzdCByZWdhcmRzLApLcnp5c3p0b2YK
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpsaW51eC1h
cm0ta2VybmVsIG1haWxpbmcgbGlzdApsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5v
cmcKaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1hcm0t
a2VybmVsCg==
