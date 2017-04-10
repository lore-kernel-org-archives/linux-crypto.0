From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v4 2/2] crypto: hw_random - Add new Exynos RNG driver
Date: Mon, 10 Apr 2017 12:12:03 +0200
Message-ID: <1713505.1UrJUbMZVN@amdc3058>
References: <20170408133245.30147-1-krzk@kernel.org>
 <CGME20170408133346epcas2p1d015a5a590955524e98cfd1119414e21@epcas2p1.samsung.com>
 <20170408133245.30147-3-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-samsung-soc@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
 Bernie Thompson <bernie@plugable.com>, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org,
 Javier Martinez Canillas <javier@osg.samsung.com>, linux-metag@vger.kernel.org,
 Kukjin Kim <kgene@kernel.org>,
 Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>,
 linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org,
 Matt Mackall <mpm@selenic.com>, Dave Airlie <airlied@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-reply-to: <20170408133245.30147-3-krzk@kernel.org>
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

CkhpLAoKT24gU2F0dXJkYXksIEFwcmlsIDA4LCAyMDE3IDAzOjMyOjQ1IFBNIEtyenlzenRvZiBL
b3psb3dza2kgd3JvdGU6Cj4gUmVwbGFjZSBleGlzdGluZyBod19yYW5uZG9tL2V4eW5vcy1ybmcg
ZHJpdmVyIHdpdGggYSBuZXcsIHJld29ya2VkIG9uZS4KPiBUaGlzIGlzIGEgZHJpdmVyIGZvciBw
c2V1ZG8gcmFuZG9tIG51bWJlciBnZW5lcmF0b3IgYmxvY2sgd2hpY2ggb24KPiBFeHlub3M0IGNo
aXBzZXRzIG11c3QgYmUgc2VlZGVkIHdpdGggc29tZSB2YWx1ZS4gIE9uIG5ld2VyIEV4eW5vczU0
MjAKPiBjaGlwc2V0cyBpdCBtaWdodCBzZWVkIGl0c2VsZiBmcm9tIHRydWUgcmFuZG9tIG51bWJl
ciBnZW5lcmF0b3IgYmxvY2sKPiBidXQgdGhpcyBpcyBub3QgaW1wbGVtZW50ZWQgeWV0Lgo+IAo+
IE5ldyBkcml2ZXIgaXMgYSBjb21wbGV0ZSByZXdvcmsgdG8gdXNlIHRoZSBjcnlwdG8gQUxHQVBJ
IGluc3RlYWQgb2YKPiBod19yYW5kb20gQVBJLiAgUmF0aW9uYWxlIGZvciB0aGUgY2hhbmdlOgo+
IDEuIGh3X3JhbmRvbSBpbnRlcmZhY2UgaXMgZm9yIHRydWUgUk5HIGRldmljZXMuCj4gMi4gVGhl
IG9sZCBkcml2ZXIgd2FzIHNlZWRpbmcgaXRzZWxmIHdpdGggamlmZmllcyB3aGljaCBpcyBub3Qg
YQo+ICAgIHJlbGlhYmxlIHNvdXJjZSBmb3IgcmFuZG9tbmVzcy4KPiAzLiBEZXZpY2UgZ2VuZXJh
dGVzIGZpdmUgcmFuZG9tIDMyLWJpdCBudW1iZXJzIGluIGVhY2ggcGFzcyBidXQgb2xkCj4gICAg
ZHJpdmVyIHdhcyByZXR1cm5pbmcgb25seSBvbmUgMzItYml0IG51bWJlciB0aHVzIGl0cyBwZXJm
b3JtYW5jZSB3YXMKPiAgICByZWR1Y2VkLgo+IAo+IENvbXBhdGliaWxpdHkgd2l0aCBEZXZpY2VU
cmVlIGJpbmRpbmdzIGlzIHByZXNlcnZlZC4KPiAKPiBOZXcgZHJpdmVyIGRvZXMgbm90IHVzZSBy
dW50aW1lIHBvd2VyIG1hbmFnZW1lbnQgYnV0IG1hbnVhbGx5IGVuYWJsZXMKPiBhbmQgZGlzYWJs
ZXMgdGhlIGNsb2NrIHdoZW4gbmVlZGVkLiAgVGhpcyBpcyBwcmVmZXJyZWQgYXBwcm9hY2ggYmVj
YXVzZQo+IHVzaW5nIHJ1bnRpbWUgUE0ganVzdCB0byB0b2dnbGUgY2xvY2sgaXMgaHVnZSBvdmVy
aGVhZC4KPiAKPiBBbm90aGVyIGRpZmZlcmVuY2UgaXMgcmVzZWVkaW5nIGl0c2VsZiB3aXRoIGdl
bmVyYXRlZCByYW5kb20gZGF0YQo+IHBlcmlvZGljYWxseSBhbmQgZHVyaW5nIHJlc3VtaW5nIGZy
b20gc3lzdGVtIHN1c3BlbmQgKHByZXZpb3VzbHkgZHJpdmVyCj4gd2FzIHJlLXNlZWRpbmcgaXRz
ZWxmIGFnYWluIHdpdGggamlmZmllcykuCj4gCj4gU2lnbmVkLW9mZi1ieTogS3J6eXN6dG9mIEtv
emxvd3NraSA8a3J6a0BrZXJuZWwub3JnPgo+IFJldmlld2VkLWJ5OiBTdGVwaGFuIE3DvGxsZXIg
PHNtdWVsbGVyQGNocm9ub3guZGU+Cj4gUmV2aWV3ZWQtYnk6IFByYXNhbm5hS3VtYXIgTXVyYWxp
ZGhhcmFuIDxwcmFzYW5uYXRzbWt1bWFyQGdtYWlsLmNvbT4KClJldmlld2VkLWJ5OiBCYXJ0bG9t
aWVqIFpvbG5pZXJraWV3aWN6IDxiLnpvbG5pZXJraWVAc2Ftc3VuZy5jb20+CgpCZXN0IHJlZ2Fy
ZHMsCi0tCkJhcnRsb21pZWogWm9sbmllcmtpZXdpY3oKU2Ftc3VuZyBSJkQgSW5zdGl0dXRlIFBv
bGFuZApTYW1zdW5nIEVsZWN0cm9uaWNzCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5m
cmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0
aW5mby9kcmktZGV2ZWwK
