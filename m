From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] arm64 aes: fix encryption of unaligned data
Date: Fri, 25 Jul 2014 19:40:20 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407251937110.11227@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andy Polyakov <appro@openssl.org>, Nicolas Pitre <nico@linaro.org>,
	"Alasdair G. Kergon" <agk@redhat.com>,
	linux-crypto@vger.kernel.org, dm-devel@redhat.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaGYXl1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Jul 2014 19:41:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

cryptsetup fails on arm64 when using kernel encryption via AF_ALG socket.
See https://bugzilla.redhat.com/show_bug.cgi?id=1122937

The bug is caused by incorrect handling of unaligned data in
arch/arm64/crypto/aes-glue.c. Cryptsetup creates a buffer that is aligned
on 8 bytes, but not on 16 bytes. It opens AF_ALG socket and uses the
socket to encrypt data in the buffer. The arm64 crypto accelerator causes
data corruption or crashes in the scatterwalk_pagedone.

This patch fixes the bug by passing the residue bytes that were not
processed as the last parameter to blkcipher_walk_done.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-3.16.0-0.rc6.git1.1.fc21.aarch64/arch/arm64/crypto/aes-glue.c
===================================================================
--- linux-3.16.0-0.rc6.git1.1.fc21.aarch64.orig/arch/arm64/crypto/aes-glue.c
+++ linux-3.16.0-0.rc6.git1.1.fc21.aarch64/arch/arm64/crypto/aes-glue.c
@@ -106,7 +106,7 @@ static int ecb_encrypt(struct blkcipher_
 	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
 		aes_ecb_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				(u8 *)ctx->key_enc, rounds, blocks, first);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	kernel_neon_end();
 	return err;
@@ -128,7 +128,7 @@ static int ecb_decrypt(struct blkcipher_
 	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
 		aes_ecb_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				(u8 *)ctx->key_dec, rounds, blocks, first);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	kernel_neon_end();
 	return err;
@@ -151,7 +151,7 @@ static int cbc_encrypt(struct blkcipher_
 		aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				(u8 *)ctx->key_enc, rounds, blocks, walk.iv,
 				first);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	kernel_neon_end();
 	return err;
@@ -174,7 +174,7 @@ static int cbc_decrypt(struct blkcipher_
 		aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				(u8 *)ctx->key_dec, rounds, blocks, walk.iv,
 				first);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	kernel_neon_end();
 	return err;
@@ -243,7 +243,7 @@ static int xts_encrypt(struct blkcipher_
 		aes_xts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				(u8 *)ctx->key1.key_enc, rounds, blocks,
 				(u8 *)ctx->key2.key_enc, walk.iv, first);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	kernel_neon_end();
 
@@ -267,7 +267,7 @@ static int xts_decrypt(struct blkcipher_
 		aes_xts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				(u8 *)ctx->key1.key_dec, rounds, blocks,
 				(u8 *)ctx->key2.key_enc, walk.iv, first);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	kernel_neon_end();
 
