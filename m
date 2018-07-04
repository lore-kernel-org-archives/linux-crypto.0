From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto: chtls - use 64-bit arithmetic instead of 32-bit
Date: Wed, 4 Jul 2018 11:37:20 -0500
Message-ID: <20180704163720.GA16912@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Cast *val* to u64 in order to give the compiler complete
information about the proper arithmetic to use.

Notice that such variable is used in a context that expects an
expression of type u64 (64 bits, unsigned) and the following
expression is currently being evaluated using 32-bit arithmetic:

val << bit_pos

Addresses-Coverity-ID: 1467425 ("Unintentional integer overflow")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/crypto/chelsio/chtls/chtls_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_hw.c b/drivers/crypto/chelsio/chtls/chtls_hw.c
index 55d5014..4909607 100644
--- a/drivers/crypto/chelsio/chtls/chtls_hw.c
+++ b/drivers/crypto/chelsio/chtls/chtls_hw.c
@@ -97,7 +97,7 @@ static int chtls_set_tcb_field(struct sock *sk, u16 word, u64 mask, u64 val)
 int chtls_set_tcb_tflag(struct sock *sk, unsigned int bit_pos, int val)
 {
 	return chtls_set_tcb_field(sk, 1, 1ULL << bit_pos,
-				   val << bit_pos);
+				   (u64)val << bit_pos);
 }
 
 static int chtls_set_tcb_keyid(struct sock *sk, int keyid)
-- 
2.7.4
