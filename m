Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727353AbfADEUz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:55 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: stable@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 01/16] crypto: cfb - add missing 'chunksize' property
Date: Thu,  3 Jan 2019 20:16:10 -0800
Message-Id: <20190104041625.3259-2-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Like some other block cipher mode implementations, the CFB
implementation assumes that while walking through the scatterlist, a
partial block does not occur until the end.  But the walk is incorrectly
being done with a blocksize of 1, as 'cra_blocksize' is set to 1 (since
CFB is a stream cipher) but no 'chunksize' is set.  This bug causes
incorrect encryption/decryption for some scatterlist layouts.

Fix it by setting the 'chunksize'.  Also extend the CFB test vectors to
cover this bug as well as cases where the message length is not a
multiple of the block size.

Fixes: a7d85e06ed80 ("crypto: cfb - add support for Cipher FeedBack mode")
Cc: <stable@vger.kernel.org> # v4.17+
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cfb.c     |  6 ++++++
 crypto/testmgr.h | 25 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/crypto/cfb.c b/crypto/cfb.c
index e81e456734985..183e8a9c33128 100644
--- a/crypto/cfb.c
+++ b/crypto/cfb.c
@@ -298,6 +298,12 @@ static int crypto_cfb_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->cra_alignmask;
 
+	/*
+	 * To simplify the implementation, configure the skcipher walk to only
+	 * give a partial block at the very end, never earlier.
+	 */
+	inst->alg.chunksize = alg->cra_blocksize;
+
 	inst->alg.ivsize = alg->cra_blocksize;
 	inst->alg.min_keysize = alg->cra_cipher.cia_min_keysize;
 	inst->alg.max_keysize = alg->cra_cipher.cia_max_keysize;
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index e8f47d7b92cdd..7f4dae7a57a1c 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -12870,6 +12870,31 @@ static const struct cipher_testvec aes_cfb_tv_template[] = {
 			  "\x75\xa3\x85\x74\x1a\xb9\xce\xf8"
 			  "\x20\x31\x62\x3d\x55\xb1\xe4\x71",
 		.len	= 64,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 31, 33 },
+	}, { /* > 16 bytes, not a multiple of 16 bytes */
+		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.klen	= 16,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae",
+		.ctext	= "\x3b\x3f\xd9\x2e\xb7\x2d\xad\x20"
+			  "\x33\x34\x49\xf8\xe8\x3c\xfb\x4a"
+			  "\xc8",
+		.len	= 17,
+	}, { /* < 16 bytes */
+		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.klen	= 16,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f",
+		.ctext	= "\x3b\x3f\xd9\x2e\xb7\x2d\xad",
+		.len	= 7,
 	},
 };
 
-- 
2.20.1
