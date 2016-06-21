From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: use timespec64 for jent_get_nstime
Date: Tue, 21 Jun 2016 08:20:10 +0200
Message-ID: <10630099.jHjGp8aIto@positron.chronox.de>
References: <20160617155952.1021006-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Alexander Kuleshov <kuleshovmail@gmail.com>, y2038@lists.linaro.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20160617155952.1021006-1-arnd@arndb.de>
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

QW0gRnJlaXRhZywgMTcuIEp1bmkgMjAxNiwgMTc6NTk6NDEgc2NocmllYiBBcm5kIEJlcmdtYW5u
OgoKSGkgQXJuZCwKCj4gVGhlIGplbnRfZ2V0X25zdGltZSgpIGZ1bmN0aW9uIHVzZXMgX19nZXRu
c3RpbWVvZmRheSgpIHRvIGdldAo+IHNvbWV0aGluZyBzaW1pbGFyIHRvIGEgNjQtYml0IG5hbm9z
ZWNvbmQgY291bnRlci4gQXMgd2Ugd2FudAo+IHRvIGdldCByaWQgb2Ygc3RydWN0IHRpbWVzcGVj
IHRvIGZpeCB0aGUgeTIwMzggb3ZlcmZsb3csCj4gdGhpcyBwYXRjaCBjaGFuZ2VzIHRoZSBjb2Rl
IHRvIHVzZSBfX2dldG5zdGltZW9mZGF5NjQoKQo+IGluc3RlYWQsIHdoaWNoIHJldHVybnMgYSB0
aW1lc3BlYzY0IHN0cnVjdHVyZS4KPiAKPiBOb3RoaW5nIGNoYW5nZXMgYWJvdXQgdGhlIGFsZ29y
aXRobSwgYnV0IGl0IGxvb2tzIGxpa2UgaXQKPiBtaWdodCBiZSBiZXR0ZXIgdG8gdXNlCj4gCj4g
ICpvdXQgPSB0cy50dl9zZWMgKiBOU0VDX1BFUl9TRUMgKyB0cy50dl9uc2VjOwo+IAo+IG9yIGV2
ZW4KPiAKPiAgKm91dCA9IGt0aW1lX2dldF9yYXdfZmFzdF9ucygpOwoKSSB0ZXN0ZWQga3RpbWVf
Z2V0X3Jhd19mYXN0X25zIGFuZCBpdCB3b3JrcyBwZXJmZWN0bHkgd2VsbCBmb3IgdGhlIHVzZSBj
YXNlLCAKaS5lLiB0aGUgUk5HIGJlaGF2aW9yIGlzIGluZGlzdGluZ3Vpc2hhYmxlIGZyb20gUkRU
U0Mgb24geDg2LgoKV2hpY2ggdGltZSBzb3VyY2UgaXMgdXNlZCBmb3IgdGhpcyBmdW5jdGlvbj8g
SSBhbSB3b25kZXJpbmcgYWJvdXQgCmFyY2hpdGVjdHVyZXMgb3RoZXIgdGhhbiBYODYuCgpOb3Rl
LCB0aGlzIGZ1bmN0aW9uIGlzIHVzZWQgYXMgYSBmYWxsYmFjayB3aGVuIHJhbmRvbV9nZXRfZW50
cm9weSBpcyBub3QgCmltcGxlbWVudGVkLiBJbiBhZGRpdGlvbiB0aGUgSml0dGVyIFJORyBoYXMg
YW4gb25saW5lIGhlYWx0aCB0ZXN0IHdoaWNoIHdpbGwgCmNhdGNoIHRoZSBmYWlsdXJlIG9mIHRo
ZSB0aW1lIHN0YW1wIG9wZXJhdGlvbi4gSGVuY2UsIGV2ZW4gaWYgdGhpcyBmdW5jdGlvbiAKbWF5
IG5vdCBiZSBzdWl0YWJsZSBvbiBvbmUgb3IgdGhlIG90aGVyIGFyY2gsIGl0IHNob3VsZCBub3Qg
aHVydCB0aG91Z2guCgpQUzogSWYgc29tZW9uZSBpcyBpbnRlcmVzdGVkIGluIHRoZSB0ZXN0IGNv
ZGUgb3IgdGhlIHRlc3QgcmVzdWx0cywgbGV0IG1lIAprbm93LgoKQ2lhbwpTdGVwaGFuCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcg
bGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWls
bWFuL2xpc3RpbmZvL3kyMDM4Cg==
