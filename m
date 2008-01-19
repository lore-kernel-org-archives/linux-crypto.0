From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] [crypto] tcrypt: shrink speed templates
Date: Sat, 19 Jan 2008 01:02:12 +0100
Message-ID: <1200700935-3844-3-git-send-email-sebastian@breakpoint.cc>
References: <1200700935-3844-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto@ml.breakpoint.cc,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38854 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbYASIdk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2008 03:33:40 -0500
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1JG991-0002d2-IO
	for linux-crypto@vger.kernel.org; Sat, 19 Jan 2008 09:33:39 +0100
In-Reply-To: <1200700935-3844-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The speed templates as it look always the same. The key size
is repeated for each block size and we test always the same
block size. The addition of one inner loop makes it possible
to get rid of the struct and it is possible to use a tiny
u8 array :)
Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/tcrypt.c |   89 +++++++++++++++++++++-----------------
 crypto/tcrypt.h |  129 +++----------------------------------------------------
 2 files changed, 57 insertions(+), 161 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index cff1836..6b8315b 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -721,15 +721,18 @@ out:
 	return ret;
 }
 
+static u32 block_sizes[] = { 16, 64, 256, 1024, 8192, 0 };
+
 static void test_cipher_speed(char *algo, int enc, unsigned int sec,
 			      struct cipher_testvec *template,
-			      unsigned int tcount, struct cipher_speed *speed)
+			      unsigned int tcount, u8 *keysize)
 {
 	unsigned int ret, i, j, iv_len;
 	unsigned char *key, *p, iv[128];
 	struct crypto_blkcipher *tfm;
 	struct blkcipher_desc desc;
 	const char *e;
+	u32 *b_size;
 
 	if (enc == ENCRYPT)
 	        e = "encryption";
@@ -748,52 +751,60 @@ static void test_cipher_speed(char *algo, int enc, unsigned int sec,
 	desc.tfm = tfm;
 	desc.flags = 0;
 
-	for (i = 0; speed[i].klen != 0; i++) {
-		if ((speed[i].blen + speed[i].klen) > TVMEMSIZE) {
-			printk("template (%u) too big for tvmem (%u)\n",
-			       speed[i].blen + speed[i].klen, TVMEMSIZE);
-			goto out;
-		}
+	i = 0;
+	do {
 
-		printk("test %u (%d bit key, %d byte blocks): ", i,
-		       speed[i].klen * 8, speed[i].blen);
+		b_size = block_sizes;
+		do {
 
-		memset(tvmem, 0xff, speed[i].klen + speed[i].blen);
+			if ((*keysize + *b_size) > TVMEMSIZE) {
+				printk("template (%u) too big for tvmem (%u)\n",
+						*keysize + *b_size, TVMEMSIZE);
+				goto out;
+			}
 
-		/* set key, plain text and IV */
-		key = (unsigned char *)tvmem;
-		for (j = 0; j < tcount; j++) {
-			if (template[j].klen == speed[i].klen) {
-				key = template[j].key;
-				break;
+			printk("test %u (%d bit key, %d byte blocks): ", i,
+					*keysize * 8, *b_size);
+
+			memset(tvmem, 0xff, *keysize + *b_size);
+
+			/* set key, plain text and IV */
+			key = (unsigned char *)tvmem;
+			for (j = 0; j < tcount; j++) {
+				if (template[j].klen == *keysize) {
+					key = template[j].key;
+					break;
+				}
 			}
-		}
-		p = (unsigned char *)tvmem + speed[i].klen;
+			p = (unsigned char *)tvmem + *keysize;
 
-		ret = crypto_blkcipher_setkey(tfm, key, speed[i].klen);
-		if (ret) {
-			printk("setkey() failed flags=%x\n",
-			       crypto_blkcipher_get_flags(tfm));
-			goto out;
-		}
+			ret = crypto_blkcipher_setkey(tfm, key, *keysize);
+			if (ret) {
+				printk("setkey() failed flags=%x\n",
+						crypto_blkcipher_get_flags(tfm));
+				goto out;
+			}
 
-		iv_len = crypto_blkcipher_ivsize(tfm);
-		if (iv_len) {
-			memset(&iv, 0xff, iv_len);
-			crypto_blkcipher_set_iv(tfm, iv, iv_len);
-		}
+			iv_len = crypto_blkcipher_ivsize(tfm);
+			if (iv_len) {
+				memset(&iv, 0xff, iv_len);
+				crypto_blkcipher_set_iv(tfm, iv, iv_len);
+			}
 
-		if (sec)
-			ret = test_cipher_jiffies(&desc, enc, p, speed[i].blen,
-						  sec);
-		else
-			ret = test_cipher_cycles(&desc, enc, p, speed[i].blen);
+			if (sec)
+				ret = test_cipher_jiffies(&desc, enc, p, *b_size, sec);
+			else
+				ret = test_cipher_cycles(&desc, enc, p, *b_size);
 
-		if (ret) {
-			printk("%s() failed flags=%x\n", e, desc.flags);
-			break;
-		}
-	}
+			if (ret) {
+				printk("%s() failed flags=%x\n", e, desc.flags);
+				break;
+			}
+			b_size++;
+			i++;
+		} while (*b_size);
+		keysize++;
+	} while (*keysize);
 
 out:
 	crypto_free_blkcipher(tfm);
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 4180a74..45e79b5 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -72,11 +72,6 @@ struct aead_testvec {
 	unsigned short rlen;
 };
 
-struct cipher_speed {
-	unsigned char klen;
-	unsigned int blen;
-};
-
 struct hash_speed {
 	unsigned int blen;	/* buffer length */
 	unsigned int plen;	/* per-update length */
@@ -8032,123 +8027,13 @@ static struct hash_testvec crc32c_tv_template[] = {
 /*
  * Cipher speed tests
  */
-static struct cipher_speed speed_template_8[] = {
-	{ .klen = 8, .blen = 16, },
-	{ .klen = 8, .blen = 64, },
-	{ .klen = 8, .blen = 256, },
-	{ .klen = 8, .blen = 1024, },
-	{ .klen = 8, .blen = 8192, },
-
-	/* End marker */
-	{  .klen = 0, .blen = 0, }
-};
-
-static struct cipher_speed speed_template_24[] = {
-	{ .klen = 24, .blen = 16, },
-	{ .klen = 24, .blen = 64, },
-	{ .klen = 24, .blen = 256, },
-	{ .klen = 24, .blen = 1024, },
-	{ .klen = 24, .blen = 8192, },
-
-	/* End marker */
-	{  .klen = 0, .blen = 0, }
-};
-
-static struct cipher_speed speed_template_8_32[] = {
-	/* Don't support blowfish keys > 256 bit in this test */
-	{ .klen = 8, .blen = 16, },
-	{ .klen = 8, .blen = 64, },
-	{ .klen = 8, .blen = 256, },
-	{ .klen = 8, .blen = 1024, },
-	{ .klen = 8, .blen = 8192, },
-	{ .klen = 32, .blen = 16, },
-	{ .klen = 32, .blen = 64, },
-	{ .klen = 32, .blen = 256, },
-	{ .klen = 32, .blen = 1024, },
-	{ .klen = 32, .blen = 8192, },
-
-	/* End marker */
-	{  .klen = 0, .blen = 0, }
-};
-
-static struct cipher_speed speed_template_16_32[] = {
-      { .klen = 16, .blen = 16, },
-      { .klen = 16, .blen = 64, },
-      { .klen = 16, .blen = 256, },
-      { .klen = 16, .blen = 1024, },
-      { .klen = 16, .blen = 8192, },
-      { .klen = 32, .blen = 16, },
-      { .klen = 32, .blen = 64, },
-      { .klen = 32, .blen = 256, },
-      { .klen = 32, .blen = 1024, },
-      { .klen = 32, .blen = 8192, },
-
-      /* End marker */
-      {  .klen = 0, .blen = 0, }
-};
-
-static struct cipher_speed speed_template_16_24_32[] = {
-	{ .klen = 16, .blen = 16, },
-	{ .klen = 16, .blen = 64, },
-	{ .klen = 16, .blen = 256, },
-	{ .klen = 16, .blen = 1024, },
-	{ .klen = 16, .blen = 8192, },
-	{ .klen = 24, .blen = 16, },
-	{ .klen = 24, .blen = 64, },
-	{ .klen = 24, .blen = 256, },
-	{ .klen = 24, .blen = 1024, },
-	{ .klen = 24, .blen = 8192, },
-	{ .klen = 32, .blen = 16, },
-	{ .klen = 32, .blen = 64, },
-	{ .klen = 32, .blen = 256, },
-	{ .klen = 32, .blen = 1024, },
-	{ .klen = 32, .blen = 8192, },
-
-	/* End marker */
-	{  .klen = 0, .blen = 0, }
-};
-
-static struct cipher_speed speed_template_32_40_48[] = {
-	{ .klen = 32, .blen = 16, },
-	{ .klen = 32, .blen = 64, },
-	{ .klen = 32, .blen = 256, },
-	{ .klen = 32, .blen = 1024, },
-	{ .klen = 32, .blen = 8192, },
-	{ .klen = 40, .blen = 16, },
-	{ .klen = 40, .blen = 64, },
-	{ .klen = 40, .blen = 256, },
-	{ .klen = 40, .blen = 1024, },
-	{ .klen = 40, .blen = 8192, },
-	{ .klen = 48, .blen = 16, },
-	{ .klen = 48, .blen = 64, },
-	{ .klen = 48, .blen = 256, },
-	{ .klen = 48, .blen = 1024, },
-	{ .klen = 48, .blen = 8192, },
-
-	/* End marker */
-	{  .klen = 0, .blen = 0, }
-};
-
-static struct cipher_speed speed_template_32_48_64[] = {
-	{ .klen = 32, .blen = 16, },
-	{ .klen = 32, .blen = 64, },
-	{ .klen = 32, .blen = 256, },
-	{ .klen = 32, .blen = 1024, },
-	{ .klen = 32, .blen = 8192, },
-	{ .klen = 48, .blen = 16, },
-	{ .klen = 48, .blen = 64, },
-	{ .klen = 48, .blen = 256, },
-	{ .klen = 48, .blen = 1024, },
-	{ .klen = 48, .blen = 8192, },
-	{ .klen = 64, .blen = 16, },
-	{ .klen = 64, .blen = 64, },
-	{ .klen = 64, .blen = 256, },
-	{ .klen = 64, .blen = 1024, },
-	{ .klen = 64, .blen = 8192, },
-
-	/* End marker */
-	{  .klen = 0, .blen = 0, }
-};
+static u8 speed_template_8[] = {8, 0};
+static u8 speed_template_24[] = {24, 0};
+static u8 speed_template_8_32[] = {8, 32, 0};
+static u8 speed_template_16_32[] = {16, 32, 0};
+static u8 speed_template_16_24_32[] = {16, 24, 32, 0};
+static u8 speed_template_32_40_48[] = {32, 40, 48, 0};
+static u8 speed_template_32_48_64[] = {32, 48, 64, 0};
 
 /*
  * Digest speed tests
-- 
1.5.3.6
