From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v5 09/13] rhashtable: use get_random_u32 for hash_rnd
Date: Thu,  8 Jun 2017 01:26:03 +0200
Message-ID: <20170607232607.26870-10-Jason@zx2c4.com>
References: <20170607232607.26870-1-Jason@zx2c4.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Theodore Ts'o <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:33481 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753430AbdFGX0e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2017 19:26:34 -0400
In-Reply-To: <20170607232607.26870-1-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is much faster and just as secure. It also has the added benefit of
probably returning better randomness at early-boot on systems with
architectural RNGs.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 lib/rhashtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index d9e7274a04cd..a1eb7c947f46 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -235,7 +235,7 @@ static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
 
 	INIT_LIST_HEAD(&tbl->walkers);
 
-	get_random_bytes(&tbl->hash_rnd, sizeof(tbl->hash_rnd));
+	tbl->hash_rnd = get_random_u32();
 
 	for (i = 0; i < nbuckets; i++)
 		INIT_RHT_NULLS_HEAD(tbl->buckets[i], ht, i);
-- 
2.13.0
