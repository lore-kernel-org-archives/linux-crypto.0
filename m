From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: powerpc: Add POWER8 optimised crc32c
Date: Fri, 1 Jul 2016 17:32:09 +0800
Message-ID: <20160701093209.GC13424@gondor.apana.org.au>
References: <1467325185-21091-1-git-send-email-anton@ozlabs.org>
 <1467325185-21091-2-git-send-email-anton@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: paulus@samba.org, linux-crypto@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
To: Anton Blanchard <anton@ozlabs.org>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <1467325185-21091-2-git-send-email-anton@ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

T24gRnJpLCBKdWwgMDEsIDIwMTYgYXQgMDg6MTk6NDVBTSArMTAwMCwgQW50b24gQmxhbmNoYXJk
IHdyb3RlOgo+IEZyb206IEFudG9uIEJsYW5jaGFyZCA8YW50b25Ac2FtYmEub3JnPgo+IAo+IFVz
ZSB0aGUgdmVjdG9yIHBvbHlub21pYWwgbXVsdGlwbHktc3VtIGluc3RydWN0aW9ucyBpbiBQT1dF
UjggdG8KPiBzcGVlZCB1cCBjcmMzMmMuCj4gCj4gVGhpcyBpcyBqdXN0IG92ZXIgNDF4IGZhc3Rl
ciB0aGFuIHRoZSBzbGljZS1ieS04IG1ldGhvZCB0aGF0IGl0Cj4gcmVwbGFjZXMuIE1lYXN1cmVt
ZW50cyBvbiBhIDQuMSBHSHogUE9XRVI4IHNob3cgaXQgc3VzdGFpbmluZwo+IDUyIEdpQi9zZWMu
Cj4gCj4gQSBzaW1wbGUgYnRyZnMgd3JpdGUgcGVyZm9ybWFuY2UgdGVzdDoKPiAKPiAgICAgZGQg
aWY9L2Rldi96ZXJvIG9mPS9tbnQvdG1wZmlsZSBicz0xTSBjb3VudD00MDk2Cj4gICAgIHN5bmMK
PiAKPiBpcyBvdmVyIDMuN3ggZmFzdGVyLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFudG9uIEJsYW5j
aGFyZCA8YW50b25Ac2FtYmEub3JnPgoKTG9va3MgZ29vZCB0byBtZS4gIFdoZXJlIGRvIHlvdSB3
YW50IHRoaXMgcGF0Y2ggdG8gZ28gQW50b24/CgpUaGFua3MsCi0tIApFbWFpbDogSGVyYmVydCBY
dSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1PgpIb21lIFBhZ2U6IGh0dHA6Ly9nb25kb3Iu
YXBhbmEub3JnLmF1L35oZXJiZXJ0LwpQR1AgS2V5OiBodHRwOi8vZ29uZG9yLmFwYW5hLm9yZy5h
dS9+aGVyYmVydC9wdWJrZXkudHh0Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCkxpbnV4cHBjLWRldiBtYWlsaW5nIGxpc3QKTGludXhwcGMtZGV2QGxpc3Rz
Lm96bGFicy5vcmcKaHR0cHM6Ly9saXN0cy5vemxhYnMub3JnL2xpc3RpbmZvL2xpbnV4cHBjLWRl
dg==
