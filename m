From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: Jitter RNG - use ktime_get_ns as
	fallback
Date: Fri, 24 Jun 2016 21:31:04 +0800
Message-ID: <20160624133104.GB21111@gondor.apana.org.au>
References: <2249326.PVY2Dy3CIm@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
 Alexander Kuleshov <kuleshovmail@gmail.com>,
 y2038 Mailman List <y2038@lists.linaro.org>, linux-kernel@vger.kernel.org,
 John Stultz <john.stultz@linaro.org>, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <y2038-bounces@lists.linaro.org>
Content-Disposition: inline
In-Reply-To: <2249326.PVY2Dy3CIm@positron.chronox.de>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
List-Id: linux-crypto.vger.kernel.org

T24gV2VkLCBKdW4gMjIsIDIwMTYgYXQgMDc6MjY6MDZQTSArMDIwMCwgU3RlcGhhbiBNdWVsbGVy
IHdyb3RlOgo+IEhpIEpvaG4sIEhlcmJlcnQsCj4gCj4gQ2hhbmdlcyB2MjogdXNlIGt0aW1lX2dl
dF9ucyBpbnN0ZWFkIG9mIGt0aW1lX2dldF9yYXdfbnMKPiAKPiBUaGUgdGVzdGluZyB3YXMgcmUt
cGVyZm9ybWVkIGFuZCBpbmRpY2F0ZSBubyBkaWZmZXJlbmNlIHRvIHRoZSBwcmV2aW91cyB0ZXN0
aW5nLgoKUGF0Y2ggYXBwbGllZC4gIFRoYW5rcy4KLS0gCkVtYWlsOiBIZXJiZXJ0IFh1IDxoZXJi
ZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+CkhvbWUgUGFnZTogaHR0cDovL2dvbmRvci5hcGFuYS5v
cmcuYXUvfmhlcmJlcnQvClBHUCBLZXk6IGh0dHA6Ly9nb25kb3IuYXBhbmEub3JnLmF1L35oZXJi
ZXJ0L3B1YmtleS50eHQKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9s
aXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
