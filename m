From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: Jitter RNG - use ktime_get_raw_ns as
	fallback
Date: Tue, 21 Jun 2016 20:49:17 +0200
Message-ID: <1724645.8YjKaqazLv@positron.chronox.de>
References: <8242305.3NQCWfJAlD@positron.chronox.de>
 <CALAqxLU6-=r8z9dVF5PQCzps-Y4SWcXMd_=QDgZuYj7Dij5whg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Alexander Kuleshov <kuleshovmail@gmail.com>,
 y2038 Mailman List <y2038@lists.linaro.org>,
 lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>
To: John Stultz <john.stultz@linaro.org>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CALAqxLU6-=r8z9dVF5PQCzps-Y4SWcXMd_=QDgZuYj7Dij5whg@mail.gmail.com>
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

QW0gRGllbnN0YWcsIDIxLiBKdW5pIDIwMTYsIDExOjExOjQyIHNjaHJpZWIgSm9obiBTdHVsdHo6
CgpIaSBKb2huLAoKPiBJIGRvbid0IHNlZSBpbiB0aGUgYWJvdmUgYW4gZXhwbGFuYXRpb24gb2Yg
KndoeSogeW91J3JlIHVzaW5nCj4ga3RpbWVfZ2V0X3Jhd19ucygpIGluc3RlYWQgb2Yga3RpbWVf
Z2V0X25zKCkuCgpDb3VsZCB5b3UgaGVscCBtZSB1bmRlcnN0YW5kIHdoYXQgdGhlIGRpZmZlcmVu
Y2UgaXMgb3IgcG9pbnQgbWUgdG8gc29tZSAKZG9jdW1lbnRhdGlvbj8gSSB1bmRlcnN0b29kIHRo
YXQgd2Ugb25seSB0YWxrZWQgYWJvdXQgdGhlIF9yYXcgdmFyaWFudC4KPiAKPiBBbHNvIHRoZSBi
aXQgYWJvdXQgdGltZSBydW5uaW5nIGJhY2t3YXJkcyBiZWluZyBvayBpcyBjb25mdXNpbmcgc2lu
Y2UKPiB5b3UncmUgbm90IHVzaW5nIHRoZSAiZmFzdCIgYWNjZXNzb3Igd2hlcmUgdGhhdCB3b3Vs
ZCBiZSBhIHJpc2suCgpPaywgaWYgdGhlIHJ1bm5pbmcgYmFja3dhcmRzIGhpbnQgaXMgb25seSBh
cHBsaWNhYmxlIHRvIHRoZSBfZmFzdCB2YXJpYW50cywgSSAKY2FuIGNlcnRhaW5seSBkcm9wIGl0
LgoKVGhhbmtzClN0ZXBoYW4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6
Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
