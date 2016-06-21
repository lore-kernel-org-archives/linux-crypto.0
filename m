From: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] crypto: Jitter RNG - use ktime_get_raw_ns as
	fallback
Date: Tue, 21 Jun 2016 12:05:06 -0700
Message-ID: <CALAqxLW-TKy2CpTst=AtJY8JNGYg_WB0MxTU3Kf4J6ijKCtBVA@mail.gmail.com>
References: <8242305.3NQCWfJAlD@positron.chronox.de>
 <CALAqxLU6-=r8z9dVF5PQCzps-Y4SWcXMd_=QDgZuYj7Dij5whg@mail.gmail.com>
 <1724645.8YjKaqazLv@positron.chronox.de>
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
In-Reply-To: <1724645.8YjKaqazLv@positron.chronox.de>
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

T24gVHVlLCBKdW4gMjEsIDIwMTYgYXQgMTE6NDkgQU0sIFN0ZXBoYW4gTXVlbGxlciA8c211ZWxs
ZXJAY2hyb25veC5kZT4gd3JvdGU6Cj4gQW0gRGllbnN0YWcsIDIxLiBKdW5pIDIwMTYsIDExOjEx
OjQyIHNjaHJpZWIgSm9obiBTdHVsdHo6Cj4KPiBIaSBKb2huLAo+Cj4+IEkgZG9uJ3Qgc2VlIGlu
IHRoZSBhYm92ZSBhbiBleHBsYW5hdGlvbiBvZiAqd2h5KiB5b3UncmUgdXNpbmcKPj4ga3RpbWVf
Z2V0X3Jhd19ucygpIGluc3RlYWQgb2Yga3RpbWVfZ2V0X25zKCkuCj4KPiBDb3VsZCB5b3UgaGVs
cCBtZSB1bmRlcnN0YW5kIHdoYXQgdGhlIGRpZmZlcmVuY2UgaXMgb3IgcG9pbnQgbWUgdG8gc29t
ZQo+IGRvY3VtZW50YXRpb24/IEkgdW5kZXJzdG9vZCB0aGF0IHdlIG9ubHkgdGFsa2VkIGFib3V0
IHRoZSBfcmF3IHZhcmlhbnQuCgpVc2luZyBzcGVjaWFsaXplZCBpbnRlcmZhY2VzIHdpdGggc3Vi
dGxlIHNlbWFudGljcyB3L28gdW5kZXJzdGFuZGluZwp0aGVtIGlzIHNvcnQgb2YgbXkgY29uY2Vy
biBoZXJlLgoKVGhlcmUgYXJlIHJlYXNvbnMgd2h5IHlvdSBtaWdodCB3YW50IHRvIHVzZSB0aGUg
a3RpbWVfZ2V0X3Jhd19ucygpCmludGVyZmFjZSBvdmVyIGt0aW1lX2dldF9ucygpLCBidXQgdGhl
eSBoYXZlIG5vdCBiZWVuIG1hZGUgY2xlYXIgaW4KdGhlIGNvbW1lbnQuIEFybmQgZGlzY3Vzc2Vk
IHNvbWUgcG90ZW50aWFsIGNvbmNlcm5zIHRoYXQgdGhlIGZyZXEKYWRqdXN0bWVudCBkb25lIGJ5
IG50cCBtaWdodCBiZSBzb21ld2hhdCBwcmVkaWN0YWJsZS9jb250cm9sbGVkIGJ5CnJlbW90ZSBw
YXJ0aWVzLCB3aGljaCBjb3VsZCBoYXZlIHNvbWUgZWZmZWN0IGluIHRoZSBjYWxjdWxhdGlvbi4g
VGhhdApmZWVscyBhIGxpdHRsZSBvdmVybHkgdmFndWUgdG8gbWUsIGJ1dCBJJ20gbm8gY3J5cHRv
IGV4cGVydCwgc28gaWYKdGhhdCBpcyBhIHJlYXNvbmFibGUgY29uY2VybiwgdGhlbiBpdCBzaG91
bGQgYmUgYSBjb25zY2lvdXMgYW5kCmRvY3VtZW50ZWQgZGVjaXNpb24uCgp0aGFua3MKLWpvaG4K
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFp
bGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3Jn
L21haWxtYW4vbGlzdGluZm8veTIwMzgK
