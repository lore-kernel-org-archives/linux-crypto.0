From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] crypto: Jitter RNG - use ktime_get_ns as
	fallback
Date: Wed, 22 Jun 2016 22:16:03 +0200
Message-ID: <3682553.NXCjD7b2Nc@wuerfel>
References: <2249326.PVY2Dy3CIm@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: herbert@gondor.apana.org.au, Alexander Kuleshov <kuleshovmail@gmail.com>,
 Stephan Mueller <smueller@chronox.de>, linux-kernel@vger.kernel.org,
 John Stultz <john.stultz@linaro.org>, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>
To: y2038@lists.linaro.org
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

T24gV2VkbmVzZGF5LCBKdW5lIDIyLCAyMDE2IDc6MjY6MDYgUE0gQ0VTVCBTdGVwaGFuIE11ZWxs
ZXIgd3JvdGU6Cj4gQXMgcGFydCBvZiB0aGUgWTIwMzggZGV2ZWxvcG1lbnQsIF9fZ2V0bnN0aW1l
b2ZkYXkgaXMgbm90IHN1cHBvc2VkIHRvIGJlCj4gdXNlZCBhbnkgbW9yZS4gSXQgaXMgbm93IHJl
cGxhY2VkIHdpdGgga3RpbWVfZ2V0X25zLiBUaGUgSml0dGVyIFJORyB1c2VzCj4gdGhlIHRpbWUg
c3RhbXAgdG8gbWVhc3VyZSB0aGUgZXhlY3V0aW9uIHRpbWUgb2YgYSBnaXZlbiBjb2RlIHBhdGgg
YW5kCj4gdHJpZXMgdG8gZGV0ZWN0IHZhcmlhdGlvbnMgaW4gdGhlIGV4ZWN1dGlvbiB0aW1lLiBU
aGVyZWZvcmUsIHRoZSBvbmx5Cj4gcmVxdWlyZW1lbnQgdGhlIEppdHRlciBSTkcgaGFzLCBpcyBh
IHN1ZmZpY2llbnQgaGlnaCByZXNvbHV0aW9uIHRvCj4gZGV0ZWN0IHRoZXNlIHZhcmlhdGlvbnMu
Cj4gCj4gVGhlIGNoYW5nZSB3YXMgdGVzdGVkIG9uIHg4NiB0byBzaG93IGFuIGlkZW50aWNhbCBi
ZWhhdmlvciBhcyBSRFRTQy4gVGhlCj4gdXNlZCB0ZXN0IGNvZGUgc2ltcGx5IG1lYXN1cmVzIHRo
ZSBleGVjdXRpb24gdGltZSBvZiB0aGUgaGVhcnQgb2YgdGhlCj4gUk5HOgo+IAo+ICAgICAgICAg
amVudF9nZXRfbnN0aW1lKCZ0aW1lKTsKPiAgICAgICAgIGplbnRfbWVtYWNjZXNzKGVjLCBtaW4p
Owo+ICAgICAgICAgamVudF9mb2xkX3RpbWUoTlVMTCwgdGltZSwgJmZvbGRlZCwgbWluKTsKPiAg
ICAgICAgIGplbnRfZ2V0X25zdGltZSgmdGltZTIpOwo+ICAgICAgICAgcmV0dXJuICgodGltZTIg
LSB0aW1lKSk7Cj4gCj4gU2lnbmVkLW9mZi1ieTogU3RlcGhhbiBNdWVsbGVyIDxzbXVlbGxlckBj
aHJvbm94LmRlPgo+IC0tLQo+IAoKQWNrZWQtYnk6IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIu
ZGU+Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4
IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJv
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
