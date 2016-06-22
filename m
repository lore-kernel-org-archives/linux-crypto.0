From: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2] crypto: Jitter RNG - use ktime_get_ns as
	fallback
Date: Wed, 22 Jun 2016 10:59:52 -0700
Message-ID: <CALAqxLVgouX=6upL+W=LZnwQy4Kcw3avxKmpP5xo41biOG5+zQ@mail.gmail.com>
References: <2249326.PVY2Dy3CIm@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Alexander Kuleshov <kuleshovmail@gmail.com>,
 y2038 Mailman List <y2038@lists.linaro.org>,
 lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <y2038-bounces@lists.linaro.org>
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

T24gV2VkLCBKdW4gMjIsIDIwMTYgYXQgMTA6MjYgQU0sIFN0ZXBoYW4gTXVlbGxlciA8c211ZWxs
ZXJAY2hyb25veC5kZT4gd3JvdGU6Cj4gSGkgSm9obiwgSGVyYmVydCwKPgo+IENoYW5nZXMgdjI6
IHVzZSBrdGltZV9nZXRfbnMgaW5zdGVhZCBvZiBrdGltZV9nZXRfcmF3X25zCj4KPiBUaGUgdGVz
dGluZyB3YXMgcmUtcGVyZm9ybWVkIGFuZCBpbmRpY2F0ZSBubyBkaWZmZXJlbmNlIHRvIHRoZSBw
cmV2aW91cyB0ZXN0aW5nLgoKVGhhbmtzIGZvciBmb2xsb3dpbmcgdGhyb3VnaCBvbiB0aGlzLiBU
aGlzIHZlcnNpb24gYWRkcmVzc2VzIG15CmNvbmNlcm5zIGFib3V0IHVzaW5nIHNwZWNpYWxpemVk
IHRpbWUgYWNjZXNzb3JzIHdpdGhvdXQgY2xlYXIKcmF0aW9uYWwuCgp0aGFua3MKLWpvaG4KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFpbGlu
ZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3JnL21h
aWxtYW4vbGlzdGluZm8veTIwMzgK
