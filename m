From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC 1/5] [crypto] geode: use consistent IV copy
Date: Fri, 19 Oct 2007 12:03:49 +0200
Message-ID: <1192788233-14968-2-git-send-email-linux-crypto@ml.breakpoint.cc>
References: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60848 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755452AbXJSKDy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Oct 2007 06:03:54 -0400
In-Reply-To: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Sebastian Siewior <sebastian@breakpoint.cc>

It is enough if the IV is copied before and after the while loop.
With DM-Crypt is seems not be required to save the IV after encrytion
because a new one is used in the request (dunno about other users).
It is not save to load the IV within while loop and not save afterwards
because we mill end up with the wrong IV if the request goes consists
of more than one page.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/geode-aes.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 7c6f13f..8bcd6d5 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -227,6 +227,7 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	memcpy(op->iv, walk.iv, AES_IV_LENGTH);
 
 	while((nbytes = walk.nbytes)) {
 		op->src = walk.src.virt.addr,
@@ -235,16 +236,13 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
 		op->dir = AES_DIR_DECRYPT;
 
-		memcpy(op->iv, walk.iv, AES_IV_LENGTH);
-
 		ret = geode_aes_crypt(op);
 
-		memcpy(walk.iv, op->iv, AES_IV_LENGTH);
 		nbytes -= ret;
-
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
+	memcpy(walk.iv, op->iv, AES_IV_LENGTH);
 	return err;
 }
 
@@ -259,6 +257,7 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	memcpy(op->iv, walk.iv, AES_IV_LENGTH);
 
 	while((nbytes = walk.nbytes)) {
 		op->src = walk.src.virt.addr,
@@ -267,13 +266,12 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
 		op->dir = AES_DIR_ENCRYPT;
 
-		memcpy(op->iv, walk.iv, AES_IV_LENGTH);
-
 		ret = geode_aes_crypt(op);
 		nbytes -= ret;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
+	memcpy(walk.iv, op->iv, AES_IV_LENGTH);
 	return err;
 }
 
-- 
1.5.3.4
