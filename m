From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] arm aes: fix encryption of unaligned data
Date: Fri, 25 Jul 2014 19:42:30 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407251940380.11227@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andy Polyakov <appro@openssl.org>, Nicolas Pitre <nico@linaro.org>,
	"Alasdair G. Kergon" <agk@redhat.com>,
	linux-crypto@vger.kernel.org, dm-devel@redhat.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaGYXm6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Jul 2014 19:42:58 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix the same alignment bug as in arm64 - we need to pass residue
unprocessed bytes as the last argument to blkcipher_walk_done.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# 3.13+

Index: linux-3.16.0-0.rc6.git1.1.fc21.aarch64/arch/arm/crypto/aesbs-glue.c
===================================================================
--- linux-3.16.0-0.rc6.git1.1.fc21.aarch64.orig/arch/arm/crypto/aesbs-glue.c
+++ linux-3.16.0-0.rc6.git1.1.fc21.aarch64/arch/arm/crypto/aesbs-glue.c
@@ -137,7 +137,7 @@ static int aesbs_cbc_encrypt(struct blkc
 				dst += AES_BLOCK_SIZE;
 			} while (--blocks);
 		}
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
@@ -158,7 +158,7 @@ static int aesbs_cbc_decrypt(struct blkc
 		bsaes_cbc_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
 				  walk.nbytes, &ctx->dec, walk.iv);
 		kernel_neon_end();
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	while (walk.nbytes) {
 		u32 blocks = walk.nbytes / AES_BLOCK_SIZE;
@@ -182,7 +182,7 @@ static int aesbs_cbc_decrypt(struct blkc
 			dst += AES_BLOCK_SIZE;
 			src += AES_BLOCK_SIZE;
 		} while (--blocks);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
@@ -268,7 +268,7 @@ static int aesbs_xts_encrypt(struct blkc
 		bsaes_xts_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
 				  walk.nbytes, &ctx->enc, walk.iv);
 		kernel_neon_end();
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
@@ -292,7 +292,7 @@ static int aesbs_xts_decrypt(struct blkc
 		bsaes_xts_decrypt(walk.src.virt.addr, walk.dst.virt.addr,
 				  walk.nbytes, &ctx->dec, walk.iv);
 		kernel_neon_end();
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
