From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 1/6] crypto: talitos - Don't provide setkey for non hmac
 hashing algs.
Date: Thu, 21 Sep 2017 09:19:47 +0200 (CEST)
Message-ID: <47fddd0f43aaedf31bc55da9ff3114079254452f.1575825623.git.christophe.leroy@c-s.fr>
References: <cover.1575825623.git.christophe.leroy@c-s.fr>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:49335 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751528AbdIUHTt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 03:19:49 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 3xySfb0Kgqz9ttBX
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:35 +0200 (CEST)
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id p4qV_UZOQqxd for <linux-crypto@vger.kernel.org>;
        Thu, 21 Sep 2017 09:19:34 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 3xySfZ6svhz9ttBK
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:34 +0200 (CEST)
In-Reply-To: <cover.1575825623.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Today, md5sum fails with error -ENOKEY because a setkey
function is set for non hmac hashing algs, see strace output below:

mmap(NULL, 378880, PROT_READ, MAP_SHARED, 6, 0) = 0x77f50000
accept(3, 0, NULL)                      = 7
vmsplice(5, [{"bin/\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 378880}], 1, SPLICE_F_MORE|SPLICE_F_GIFT) = 262144
splice(4, NULL, 7, NULL, 262144, SPLICE_F_MORE) = -1 ENOKEY (Required key not available)
write(2, "Generation of hash for file kcap"..., 50) = 50
munmap(0x77f50000, 378880)              = 0

This patch ensures that setkey() function is set only
for hmac hashing.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 79791c690858..5cc160078286 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3057,7 +3057,8 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		t_alg->algt.alg.hash.final = ahash_final;
 		t_alg->algt.alg.hash.finup = ahash_finup;
 		t_alg->algt.alg.hash.digest = ahash_digest;
-		t_alg->algt.alg.hash.setkey = ahash_setkey;
+		if (!strncmp(alg->cra_name, "hmac", 4))
+			t_alg->algt.alg.hash.setkey = ahash_setkey;
 		t_alg->algt.alg.hash.import = ahash_import;
 		t_alg->algt.alg.hash.export = ahash_export;
 
-- 
2.13.3
