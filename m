From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next 3/3] tcp: use monotonic timestamps for
	PAWS
Date: Mon, 18 Jun 2018 08:59:34 -0700
Message-ID: <67ebb94d-c73f-6c9f-493b-00c86f595120@gmail.com>
References: <20180618152242.1566661-1-arnd@arndb.de>
 <20180618152242.1566661-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Lawrence Brakmo <brakmo@fb.com>, Christoph Paasch <cpaasch@apple.com>,
 Soheil Hassas Yeganeh <soheil@google.com>, y2038@lists.linaro.org,
 netdev@vger.kernel.org, Ursula Braun <ubraun@linux.vnet.ibm.com>,
 Florian Westphal <fw@strlen.de>, Alexei Starovoitov <ast@kernel.org>,
 linux-kernel@vger.kernel.org, Priyaranjan Jha <priyarjha@google.com>,
 =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
 Yuchung Cheng <ycheng@google.com>, David Ahern <dsahern@gmail.com>,
 Ivan Delalande <colona@arista.com>, Michael Werner <werner@chelsio.com>,
 Neal Cardwell <ncardwell@google.com>, linux-crypto@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Harsh Jain <harsh@chelsio.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
 Atul Gupta <atul.gupta@chelsio.com>,
 "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20180618152242.1566661-3-arnd@arndb.de>
Content-Language: en-US
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

CgpPbiAwNi8xOC8yMDE4IDA4OjIyIEFNLCBBcm5kIEJlcmdtYW5uIHdyb3RlOgo+IFVzaW5nIGdl
dF9zZWNvbmRzKCkgZm9yIHRpbWVzdGFtcHMgaXMgZGVwcmVjYXRlZCBzaW5jZSBpdCBjYW4gbGVh
ZAo+IHRvIG92ZXJmbG93cyBvbiAzMi1iaXQgc3lzdGVtcy4gV2hpbGUgdGhlIGludGVyZmFjZSBn
ZW5lcmFsbHkgZG9lc24ndAo+IG92ZXJmbG93IHVudGlsIHllYXIgMjEwNiwgdGhlIHNwZWNpZmlj
IGltcGxlbWVudGF0aW9uIG9mIHRoZSBUQ1AgUEFXUwo+IGFsZ29yaXRobSBicmVha3MgaW4gMjAz
OCB3aGVuIHRoZSBpbnRlcm1lZGlhdGUgc2lnbmVkIDMyLWJpdCB0aW1lc3RhbXBzCj4gb3ZlcmZs
b3cuCj4KLi4uCgo+Cj4gIAo+ICBzdGF0aWMgaW5saW5lIHUzMiB0Y3BfY29va2llX3RpbWUodm9p
ZCkKPiBAQCAtMTM2MSw3ICsxMzYyLDcgQEAgc3RhdGljIGlubGluZSBib29sIHRjcF9wYXdzX2No
ZWNrKGNvbnN0IHN0cnVjdCB0Y3Bfb3B0aW9uc19yZWNlaXZlZCAqcnhfb3B0LAo+ICB7Cj4gIAlp
ZiAoKHMzMikocnhfb3B0LT50c19yZWNlbnQgLSByeF9vcHQtPnJjdl90c3ZhbCkgPD0gcGF3c193
aW4pCj4gIAkJcmV0dXJuIHRydWU7Cj4gLQlpZiAodW5saWtlbHkoZ2V0X3NlY29uZHMoKSA+PSBy
eF9vcHQtPnRzX3JlY2VudF9zdGFtcCArIFRDUF9QQVdTXzI0REFZUykpCj4gKwlpZiAodW5saWtl
bHkoa3RpbWVfZ2V0X3NlY29uZHMoKSA+PSByeF9vcHQtPnRzX3JlY2VudF9zdGFtcCArIFRDUF9Q
QVdTXzI0REFZUykpCj4gIAkJcmV0dXJuIHRydWU7Cj4gIAkvKgo+ICAJICogU29tZSBPU2VzIHNl
bmQgU1lOIGFuZCBTWU5BQ0sgbWVzc2FnZXMgd2l0aCB0c3ZhbD0wIHRzZWNyPTAsCj4gQEAgLTEz
OTEsNyArMTM5Miw3IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCB0Y3BfcGF3c19yZWplY3QoY29uc3Qg
c3RydWN0IHRjcF9vcHRpb25zX3JlY2VpdmVkICpyeF9vcHQsCj4gIAo+ICAJICAgSG93ZXZlciwg
d2UgY2FuIHJlbGF4IHRpbWUgYm91bmRzIGZvciBSU1Qgc2VnbWVudHMgdG8gTVNMLgo+ICAJICov
Cj4gLQlpZiAocnN0ICYmIGdldF9zZWNvbmRzKCkgPj0gcnhfb3B0LT50c19yZWNlbnRfc3RhbXAg
KyBUQ1BfUEFXU19NU0wpCj4gKwlpZiAocnN0ICYmIGt0aW1lX2dldF9zZWNvbmRzKCkgPj0gcnhf
b3B0LT50c19yZWNlbnRfc3RhbXAgKyBUQ1BfUEFXU19NU0wpCj4gIAkJcmV0dXJuIGZhbHNlOwo+
ICAJcmV0dXJuIHRydWU7CgoKClBsZWFzZSB1c2UgdGhlIHRpbWVfYWZ0ZXIzMigpLCBzaW5jZSBr
dGltZV9nZXRfc2Vjb25kcygpIGlzIHRpbWU2NF90IHdoaWxlIHRzX3JlY2VudF9zdGFtcCBpcyBp
bnQuCgpTYW1lIHJlbWFyayBmb3IgdGNwX3R3c2tfdW5pcXVlKCkKCkxldHMgY2xlYW4gdXAgdGhp
cyBzdHVmZiwgdGhhbmtzICEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fClkyMDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBz
Oi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
