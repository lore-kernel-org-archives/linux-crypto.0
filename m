From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.17 55/67] crypto: dont optimize keccakf()
Date: Mon, 16 Jul 2018 09:35:24 +0200
Message-ID: <20180716073452.383199246@linuxfoundation.org>
References: <20180716073443.294323458@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        syzbot+37035ccfa9a0a017ffcf@syzkaller.appspotmail.com,
        syzbot+e073e4740cfbb3ae200b@syzkaller.appspotmail.com,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-kernel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180716073443.294323458@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

4.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Vyukov <dvyukov@google.com>

commit f044a84e040b85cd609851ac88ae8b54b2cc0b75 upstream.

keccakf() is the only function in kernel that uses __optimize() macro.
__optimize() breaks frame pointer unwinder as optimized code uses RBP,
and amusingly this always lead to degraded performance as gcc does not
inline across different optimizations levels, so keccakf() wasn't inlined
into its callers and keccakf_round() wasn't inlined into keccakf().

Drop __optimize() to resolve both problems.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Fixes: 83dee2ce1ae7 ("crypto: sha3-generic - rewrite KECCAK transform to help the compiler optimize")
Reported-by: syzbot+37035ccfa9a0a017ffcf@syzkaller.appspotmail.com
Reported-by: syzbot+e073e4740cfbb3ae200b@syzkaller.appspotmail.com
Cc: linux-crypto@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/sha3_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -152,7 +152,7 @@ static SHA3_INLINE void keccakf_round(u6
 	st[24] ^= bc[ 4];
 }
 
-static void __optimize("O3") keccakf(u64 st[25])
+static void keccakf(u64 st[25])
 {
 	int round;
 
