From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH net] ipv6: sr: fix passing wrong flags to crypto_alloc_shash()
Date: Sat, 30 Jun 2018 15:26:56 -0700
Message-ID: <20180630222656.333-1-ebiggers3@gmail.com>
Cc: David Lebrun <david.lebrun@uclouvain.be>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The 'mask' argument to crypto_alloc_shash() uses the CRYPTO_ALG_* flags,
not 'gfp_t'.  So don't pass GFP_KERNEL to it.

Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/ipv6/seg6_hmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 33fb35cbfac13..558fe8cc6d438 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -373,7 +373,7 @@ static int seg6_hmac_init_algo(void)
 			return -ENOMEM;
 
 		for_each_possible_cpu(cpu) {
-			tfm = crypto_alloc_shash(algo->name, 0, GFP_KERNEL);
+			tfm = crypto_alloc_shash(algo->name, 0, 0);
 			if (IS_ERR(tfm))
 				return PTR_ERR(tfm);
 			p_tfm = per_cpu_ptr(algo->tfms, cpu);
-- 
2.18.0
