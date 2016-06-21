From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: use timespec64 for jent_get_nstime
Date: Tue, 21 Jun 2016 19:16:15 +0200
Message-ID: <2228716.yrSLSS60Ke@tauon.atsec.com>
References: <20160617155952.1021006-1-arnd@arndb.de>
 <12040808.ISNuLM4SqW@tauon.atsec.com>
 <CALAqxLV4qmY8hhzYjQ8+Mx-Tb5WKP1RUQd4JLUnoZRndKTM9og@mail.gmail.com>
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
In-Reply-To: <CALAqxLV4qmY8hhzYjQ8+Mx-Tb5WKP1RUQd4JLUnoZRndKTM9og@mail.gmail.com>
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

QW0gRGllbnN0YWcsIDIxLiBKdW5pIDIwMTYsIDEwOjEyOjI0IHNjaHJpZWIgSm9obiBTdHVsdHo6
CgpIaSBKb2huLAo+IAo+IFNvIHRoaXMgaXMgZGVmaW5pdGVseSBtb3JlIGNsZWFyIHRoZW4gd2hh
dCB3YXMgZGVzY3JpYmVkIGVhcmxpZXIsIGFuZAo+IHdvcnJpZXMgbWUgYmVjYXVzZSBvbiBtYW55
IHg4NiBtYWNoaW5lcyAodGhvdWdoIGZld2VyIEkgZ3Vlc3MgdGhlc2UKPiBkYXlzIHRoZW4gaW4g
dGhlIHBhc3QpIHRoZSBjbG9ja3NvdXJjZSB3aWxsIG9mdGVuIG5vdCBiZSB0aGUgVFNDIChhbmQK
PiBoYXZlIGxvd2VyIHJlc29sdXRpb24pLgoKUGxlYXNlIG5vdGUsIHRoZSB1c2Ugb2YgdGhlIGt0
aW1lX2dldF9yYXdfbnMoKSBpcyAqb25seSogdXNlZCBhcyBhIGZhbGxiYWNrIG9uIAphcmNoaXRl
Y3R1cmVzIHdoZXJlIHJhbmRvbV9nZXRfZW50cm9weSAvIGdldF9jeWNsZXMgaXMgbm90IGltcGxl
bWVudGVkLgoKU28sIG9uIFg4NiBhbmQgb24gbWFueSBvdGhlciBhcmNoZXMsIHRoaXMgZnVuY3Rp
b24gY2FsbCB3aWxsIG5ldmVyIGJlIAp0cmlnZ2VyZWQuCgouLi4KPiAKPiBCdXQgcGxlYXNlIGp1
c3QgbWFrZSBzdXJlIHRoZSByZWFzb24gd2h5IHlvdSdyZSB1c2luZyB0aGF0IHNwZWNpZmljCj4g
aW50ZXJmYWNlIGlzIGNsZWFybHkgZG9jdW1lbnRlZCBpbiB0aGUgY29kZSBzbyB3ZSBkb24ndCBo
YXZlIHRvIGxhdGVyCj4gcmV2ZXJzZSBlbmdpbmVlciB0aGUgaW50ZW50LgoKV2lsbCBkby4KCkBB
cm5kOiBJIHdvdWxkIHByZXBhcmUgYSBwYXRjaCB0aGVuIHVzaW5nIGt0aW1lX2dldF9yYXdfbnMg
YW5kIHByb3ZpZGluZyBhIApnb29kIGRvY3VtZW50YXRpb24gaW4gdGhlIGNvZGUuCgpDaWFvClN0
ZXBoYW4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIw
MzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5h
cm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
