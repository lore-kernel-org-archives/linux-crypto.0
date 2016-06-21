From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: use timespec64 for jent_get_nstime
Date: Tue, 21 Jun 2016 19:07:45 +0200
Message-ID: <2121132.qNHuddqZk8@tauon.atsec.com>
References: <20160617155952.1021006-1-arnd@arndb.de>
 <CALAqxLXTxM=Rt01_wOpbiYQByVMQ6rO1mazR1BAMRF_uxNHY6A@mail.gmail.com>
 <12040808.ISNuLM4SqW@tauon.atsec.com>
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
In-Reply-To: <12040808.ISNuLM4SqW@tauon.atsec.com>
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

QW0gRGllbnN0YWcsIDIxLiBKdW5pIDIwMTYsIDE4OjUxOjMyIHNjaHJpZWIgU3RlcGhhbiBNdWVs
bGVyOgoKSGksCgo+ID4gU28uLiBhZ2FpbiwgSSdkIGF2b2lkIHVzaW5nIHRoZSAiZmFzdCIgYWNj
ZXNzb3IgdW5sZXNzIHRoZXJlIGlzIGEKPiA+IGNsZWFyIG5lZWQgb3Igb2J2aW91cyBiZW5lZml0
LiBXaGljaCBzaG91bGQgYmUgZG9jdW1lbnRlZC4KPiAKPiBTbywgeW91IHN1Z2dlc3Qga3RpbWVf
Z2V0X3Jhd19ucz8gSWYgeWVzLCBsZXQgbWUgdGVzdCB0aGF0IGZvciBvbmUgdXNlIGNhc2UuCgpJ
IHRlc3RlZCBrdGltZV9nZXRfcmF3X25zIGFuZCBpdCBleGhpYml0cyB0aGUgc2FtZSByZXN1bHRz
IGFzIAprdGltZV9nZXRfcmF3X2Zhc3RfbnMgYW5kIFJEVFNDLiBTbywgSSBzZWUgbm8gb2JqZWN0
aW9ucyBpbiB1c2luZyAKa3RpbWVfZ2V0X3Jhd19ucy4KCkNpYW8KU3RlcGhhbgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5nIGxpc3QK
WTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9s
aXN0aW5mby95MjAzOAo=
