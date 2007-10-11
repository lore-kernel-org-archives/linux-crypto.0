From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [RFC 2/6] [crypto] geode aes: consistent IV copy
Date: Thu, 11 Oct 2007 16:33:07 +0200
Message-ID: <E1IgMP3-0002ku-Uk@Chamillionaire.breakpoint.cc>
References: <1192202467-10335-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.2.5"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50914 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389AbXJLP0T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Oct 2007 11:26:19 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc authenticated by bigeasy with local
	(easymta 1.00 BETA 1)
	id 1IgMP3-0002ku-Uk
	for linux-crypto@vger.kernel.org; Fri, 12 Oct 2007 17:26:17 +0200
In-Reply-To: <1192202467-10335-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.
--------------1.5.2.5
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


It is enough if the IV is copied before and after the while loop.
With DM-Crypt is seems not be required to save the IV after encrytion
because a new IV is used in the request (dunno about other users).
It is not save to load the IV within while loop and not save afterwards
because we will end up with the wrong IV if the request consists of more 
than one page.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/geode-aes.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)
--------------1.5.2.5
Content-Type: text/x-patch; name="859476c38eb7658240d647df03ec0fd513e3bfa5.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="859476c38eb7658240d647df03ec0fd513e3bfa5.diff"

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
 

--------------1.5.2.5--
