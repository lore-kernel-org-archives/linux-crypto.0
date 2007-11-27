From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] geode: do not copy the IV too often
Date: Tue, 27 Nov 2007 20:33:58 +0100
Message-ID: <20071127193358.GB3506@Chamillionaire.breakpoint.cc>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115212335.GB21159@Chamillionaire.breakpoint.cc> <20071126092521.GC18309@Chamillionaire.breakpoint.cc> <20071126092832.GA25693@gondor.apana.org.au> <20071126094226.GA18532@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38961 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbXK0Td7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Nov 2007 14:33:59 -0500
Content-Disposition: inline
In-Reply-To: <20071126094226.GA18532@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

There is no reason to keep the IV in the private structre. Instead keep
just a pointer to make the patch smaller :)
This also remove a few memcpy()s

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/geode-aes.c |    6 ++----
 drivers/crypto/geode-aes.h |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 0ca92d4..68be7d0 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -315,7 +315,7 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
-	memcpy(op->iv, walk.iv, AES_IV_LENGTH);
+	op->iv = walk.iv;
 
 	while((nbytes = walk.nbytes)) {
 		op->src = walk.src.virt.addr,
@@ -330,7 +330,6 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	memcpy(walk.iv, op->iv, AES_IV_LENGTH);
 	return err;
 }
 
@@ -348,7 +347,7 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
-	memcpy(op->iv, walk.iv, AES_IV_LENGTH);
+	op->iv = walk.iv;
 
 	while((nbytes = walk.nbytes)) {
 		op->src = walk.src.virt.addr,
@@ -362,7 +361,6 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	memcpy(walk.iv, op->iv, AES_IV_LENGTH);
 	return err;
 }
 
diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
index 14cc763..f1855b5 100644
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -65,7 +65,7 @@ struct geode_aes_op {
 	int len;
 
 	u8 key[AES_KEY_LENGTH];
-	u8 iv[AES_IV_LENGTH];
+	u8 *iv;
 
 	union {
 		struct crypto_blkcipher *blk;
-- 
1.5.3.4
