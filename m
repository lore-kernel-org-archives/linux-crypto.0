Return-Path: <SRS0=me0G=UN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0DD8C31E44
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 09:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B51632084E
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 09:44:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l4wr6ZjP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfFNJoB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jun 2019 05:44:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38858 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfFNJoA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jun 2019 05:44:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id d18so1807522wrs.5
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jun 2019 02:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d7QHelOdf1VojElzrgyoDdfkxaOz6RwB+V0HENv373k=;
        b=l4wr6ZjPUMB86QVfD8CdAoVJPpzvnatyScOGTvHN372q2OQJTdCvlEHiQTGJ++Pdca
         MZavZ5e6W32rXb9U2ZrwDwqFWoLECmFa63Crrgq9kEyXMHW+bp4Y8jjoHgBo2mclajQm
         Ooh2EJ8+i1ZScJJzki3FUhsAWPB+rm1xNaA8P+ZVV71JyS4rLbBFRGNW5w4oXN3KDoQr
         yhXxNLc8rwoVTVL0XyUCeP3sNZTMrYrAgnf8RMyJn5WpHPzmffOcnQ//a9mZr1ayJn1A
         3P2tlPrZGNGp7SQRtGvqoOyouEdHt76oGi8o2qaRZE7RL5Ofwo9es1q6xCe6gaJbfHJi
         2Ndw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d7QHelOdf1VojElzrgyoDdfkxaOz6RwB+V0HENv373k=;
        b=aC3sCDFaz0TLadNQj6wTo58hbTrB4XyAa3husabAHlxQR4BEHTV/O8ArIRclmm8Ojr
         Lfv9yf4UEuedswvfjPd4MFRRSyfZ+6W7MwbqBKT5ceUyu2UlTHB+9M+LF5AqWbEznvDO
         on1gBgssONv+ss8S/Mjxht9gGAq3FF2/Elbq8gev956zsFZae+rGgcKsEmvJ+mXGaiTr
         Q3oJQG9fQWOhhjIyWRO0S+jRL0FRR01KMVtWaVdKL1bzsyUq7eD5YX1M8vrsXUMvYYYZ
         wJueh7vQUGWS+mcWds+16YoxpfWOyb8WyeN0Ex6eoUw+L9cPexJJXmEWt58Vv5tdKPqc
         kHlA==
X-Gm-Message-State: APjAAAW8d8prPuQ7XTetAlUdb/K1Q1RiqPhjLT9IBW9hqu5IcJJ3O3F/
        1N7EbY5TrzRtuY/jY6Hm8T1fjw==
X-Google-Smtp-Source: APXvYqxCccaiI+vAc99grLNm5CrTrif+OxQ6pC973zBY1nltA7SO6lWic5aeOcboWuRJHVhp/GgZQA==
X-Received: by 2002:a5d:4ec1:: with SMTP id s1mr11579961wrv.19.1560505438510;
        Fri, 14 Jun 2019 02:43:58 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:8d0e:a5b1:c005:e3b5])
        by smtp.gmail.com with ESMTPSA id b2sm2722994wrp.72.2019.06.14.02.43.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 02:43:57 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-usb@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        ebiggers@kernel.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2] wusb: switch to cbcmac transform
Date:   Fri, 14 Jun 2019 11:43:53 +0200
Message-Id: <20190614094353.23089-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The wusb code takes a very peculiar approach at implementing CBC-MAC,
by using plain CBC into a scratch buffer, and taking the output IV
as the MAC.

We can clean up this code substantially by switching to the cbcmac
shash, as exposed by the CCM template. To ensure that the module is
loaded on demand, add the cbcmac template name as a module alias.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v2: - use finup()/digest() where possible, and process b0+b1 using a single
      call to update()
    - make 'stv_hsmic_hs' static const and remove comment regarding GCC 4.1

NOTE: I don't have any hardware to test this, but the built-in selftest
      still passes.

 crypto/ccm.c                  |   1 +
 drivers/usb/wusbcore/crypto.c | 168 +++++---------------
 2 files changed, 44 insertions(+), 125 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 8c24605c791e..380eb619f657 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -1009,3 +1009,4 @@ MODULE_DESCRIPTION("Counter with CBC MAC");
 MODULE_ALIAS_CRYPTO("ccm_base");
 MODULE_ALIAS_CRYPTO("rfc4309");
 MODULE_ALIAS_CRYPTO("ccm");
+MODULE_ALIAS_CRYPTO("cbcmac");
diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
index edb7263bff40..089c8e81f721 100644
--- a/drivers/usb/wusbcore/crypto.c
+++ b/drivers/usb/wusbcore/crypto.c
@@ -31,6 +31,8 @@
  *             funneled through AES are...16 bytes in size!
  */
 
+#include <crypto/aes.h>
+#include <crypto/hash.h>
 #include <crypto/skcipher.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
@@ -109,16 +111,6 @@ struct aes_ccm_a {
 	__be16 counter;	/* Value of x */
 } __attribute__((packed));
 
-static void bytewise_xor(void *_bo, const void *_bi1, const void *_bi2,
-			 size_t size)
-{
-	u8 *bo = _bo;
-	const u8 *bi1 = _bi1, *bi2 = _bi2;
-	size_t itr;
-	for (itr = 0; itr < size; itr++)
-		bo[itr] = bi1[itr] ^ bi2[itr];
-}
-
 /* Scratch space for MAC calculations. */
 struct wusb_mac_scratch {
 	struct aes_ccm_b0 b0;
@@ -150,8 +142,7 @@ struct wusb_mac_scratch {
  * @a: ASCII string, 14 bytes long (I guess zero padded if needed;
  *     we use exactly 14 bytes).
  *
- * @b: data stream to be processed; cannot be a global or const local
- *     (will confuse the scatterlists)
+ * @b: data stream to be processed
  *
  * @blen: size of b...
  *
@@ -160,16 +151,10 @@ struct wusb_mac_scratch {
  * @key. We bytewise xor B0 with B1 (1) and AES-crypt that. Then we
  * take the payload and divide it in blocks (16 bytes), xor them with
  * the previous crypto result (16 bytes) and crypt it, repeat the next
- * block with the output of the previous one, rinse wash (I guess this
- * is what AES CBC mode means...but I truly have no idea). So we use
- * the CBC(AES) blkcipher, that does precisely that. The IV (Initial
+ * block with the output of the previous one, rinse wash. So we use
+ * the CBC-MAC(AES) shash, that does precisely that. The IV (Initial
  * Vector) is 16 bytes and is set to zero, so
  *
- * See rfc3610. Linux crypto has a CBC implementation, but the
- * documentation is scarce, to say the least, and the example code is
- * so intricated that is difficult to understand how things work. Most
- * of this is guess work -- bite me.
- *
  * (1) Created as 6.5 says, again, using as l(a) 'Blen + 14', and
  *     using the 14 bytes of @a to fill up
  *     b1.{mac_header,e0,security_reserved,padding}.
@@ -189,44 +174,24 @@ struct wusb_mac_scratch {
  * NOTE: blen is not aligned to a block size, we'll pad zeros, that's
  *       what sg[4] is for. Maybe there is a smarter way to do this.
  */
-static int wusb_ccm_mac(struct crypto_sync_skcipher *tfm_cbc,
-			struct crypto_cipher *tfm_aes,
+static int wusb_ccm_mac(struct crypto_shash *tfm_cbcmac,
 			struct wusb_mac_scratch *scratch,
 			void *mic,
 			const struct aes_ccm_nonce *n,
 			const struct aes_ccm_label *a, const void *b,
 			size_t blen)
 {
-	int result = 0;
-	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm_cbc);
-	struct scatterlist sg[4], sg_dst;
-	void *dst_buf;
-	size_t dst_size;
-	u8 *iv;
-	size_t zero_padding;
+	SHASH_DESC_ON_STACK(desc, tfm_cbcmac);
+	u8 iv[AES_BLOCK_SIZE];
 
 	/*
 	 * These checks should be compile time optimized out
 	 * ensure @a fills b1's mac_header and following fields
 	 */
-	WARN_ON(sizeof(*a) != sizeof(scratch->b1) - sizeof(scratch->b1.la));
-	WARN_ON(sizeof(scratch->b0) != sizeof(struct aes_ccm_block));
-	WARN_ON(sizeof(scratch->b1) != sizeof(struct aes_ccm_block));
-	WARN_ON(sizeof(scratch->ax) != sizeof(struct aes_ccm_block));
-
-	result = -ENOMEM;
-	zero_padding = blen % sizeof(struct aes_ccm_block);
-	if (zero_padding)
-		zero_padding = sizeof(struct aes_ccm_block) - zero_padding;
-	dst_size = blen + sizeof(scratch->b0) + sizeof(scratch->b1) +
-		zero_padding;
-	dst_buf = kzalloc(dst_size, GFP_KERNEL);
-	if (!dst_buf)
-		goto error_dst_buf;
-
-	iv = kzalloc(crypto_sync_skcipher_ivsize(tfm_cbc), GFP_KERNEL);
-	if (!iv)
-		goto error_iv;
+	BUILD_BUG_ON(sizeof(*a) != sizeof(scratch->b1) - sizeof(scratch->b1.la));
+	BUILD_BUG_ON(sizeof(scratch->b0) != sizeof(struct aes_ccm_block));
+	BUILD_BUG_ON(sizeof(scratch->b1) != sizeof(struct aes_ccm_block));
+	BUILD_BUG_ON(sizeof(scratch->ax) != sizeof(struct aes_ccm_block));
 
 	/* Setup B0 */
 	scratch->b0.flags = 0x59;	/* Format B0 */
@@ -243,46 +208,28 @@ static int wusb_ccm_mac(struct crypto_sync_skcipher *tfm_cbc,
 	scratch->b1.la = cpu_to_be16(blen + 14);
 	memcpy(&scratch->b1.mac_header, a, sizeof(*a));
 
-	sg_init_table(sg, ARRAY_SIZE(sg));
-	sg_set_buf(&sg[0], &scratch->b0, sizeof(scratch->b0));
-	sg_set_buf(&sg[1], &scratch->b1, sizeof(scratch->b1));
-	sg_set_buf(&sg[2], b, blen);
-	/* 0 if well behaved :) */
-	sg_set_page(&sg[3], ZERO_PAGE(0), zero_padding, 0);
-	sg_init_one(&sg_dst, dst_buf, dst_size);
-
-	skcipher_request_set_sync_tfm(req, tfm_cbc);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, sg, &sg_dst, dst_size, iv);
-	result = crypto_skcipher_encrypt(req);
-	skcipher_request_zero(req);
-	if (result < 0) {
-		printk(KERN_ERR "E: can't compute CBC-MAC tag (MIC): %d\n",
-		       result);
-		goto error_cbc_crypt;
-	}
+	desc->tfm = tfm_cbcmac;
+	crypto_shash_init(desc);
+	crypto_shash_update(desc, (u8 *)&scratch->b0, sizeof(scratch->b0) +
+						      sizeof(scratch->b1));
+	crypto_shash_finup(desc, b, blen, iv);
 
 	/* Now we crypt the MIC Tag (*iv) with Ax -- values per WUSB1.0[6.5]
 	 * The procedure is to AES crypt the A0 block and XOR the MIC
 	 * Tag against it; we only do the first 8 bytes and place it
 	 * directly in the destination buffer.
-	 *
-	 * POS Crypto API: size is assumed to be AES's block size.
-	 * Thanks for documenting it -- tip taken from airo.c
 	 */
 	scratch->ax.flags = 0x01;		/* as per WUSB 1.0 spec */
 	scratch->ax.ccm_nonce = *n;
 	scratch->ax.counter = 0;
-	crypto_cipher_encrypt_one(tfm_aes, (void *)&scratch->ax,
-				  (void *)&scratch->ax);
-	bytewise_xor(mic, &scratch->ax, iv, 8);
-	result = 8;
-error_cbc_crypt:
-	kfree(iv);
-error_iv:
-	kfree(dst_buf);
-error_dst_buf:
-	return result;
+
+	/* reuse the CBC-MAC transform to perform the single block encryption */
+	crypto_shash_digest(desc, (u8 *)&scratch->ax, sizeof(scratch->ax),
+			    (u8 *)&scratch->ax);
+
+	crypto_xor_cpy(mic, (u8 *)&scratch->ax, iv, 8);
+
+	return 8;
 }
 
 /*
@@ -298,45 +245,28 @@ ssize_t wusb_prf(void *out, size_t out_size,
 {
 	ssize_t result, bytes = 0, bitr;
 	struct aes_ccm_nonce n = *_n;
-	struct crypto_sync_skcipher *tfm_cbc;
-	struct crypto_cipher *tfm_aes;
-	struct wusb_mac_scratch *scratch;
+	struct crypto_shash *tfm_cbcmac;
+	struct wusb_mac_scratch scratch;
 	u64 sfn = 0;
 	__le64 sfn_le;
 
-	tfm_cbc = crypto_alloc_sync_skcipher("cbc(aes)", 0, 0);
-	if (IS_ERR(tfm_cbc)) {
-		result = PTR_ERR(tfm_cbc);
-		printk(KERN_ERR "E: can't load CBC(AES): %d\n", (int)result);
-		goto error_alloc_cbc;
-	}
-	result = crypto_sync_skcipher_setkey(tfm_cbc, key, 16);
-	if (result < 0) {
-		printk(KERN_ERR "E: can't set CBC key: %d\n", (int)result);
-		goto error_setkey_cbc;
+	tfm_cbcmac = crypto_alloc_shash("cbcmac(aes)", 0, 0);
+	if (IS_ERR(tfm_cbcmac)) {
+		result = PTR_ERR(tfm_cbcmac);
+		printk(KERN_ERR "E: can't load CBCMAC-AES: %d\n", (int)result);
+		goto error_alloc_cbcmac;
 	}
 
-	tfm_aes = crypto_alloc_cipher("aes", 0, 0);
-	if (IS_ERR(tfm_aes)) {
-		result = PTR_ERR(tfm_aes);
-		printk(KERN_ERR "E: can't load AES: %d\n", (int)result);
-		goto error_alloc_aes;
-	}
-	result = crypto_cipher_setkey(tfm_aes, key, 16);
+	result = crypto_shash_setkey(tfm_cbcmac, key, AES_BLOCK_SIZE);
 	if (result < 0) {
-		printk(KERN_ERR "E: can't set AES key: %d\n", (int)result);
-		goto error_setkey_aes;
-	}
-	scratch = kmalloc(sizeof(*scratch), GFP_KERNEL);
-	if (!scratch) {
-		result = -ENOMEM;
-		goto error_alloc_scratch;
+		printk(KERN_ERR "E: can't set CBCMAC-AES key: %d\n", (int)result);
+		goto error_setkey_cbcmac;
 	}
 
 	for (bitr = 0; bitr < (len + 63) / 64; bitr++) {
 		sfn_le = cpu_to_le64(sfn++);
 		memcpy(&n.sfn, &sfn_le, sizeof(n.sfn));	/* n.sfn++... */
-		result = wusb_ccm_mac(tfm_cbc, tfm_aes, scratch, out + bytes,
+		result = wusb_ccm_mac(tfm_cbcmac, &scratch, out + bytes,
 				      &n, a, b, blen);
 		if (result < 0)
 			goto error_ccm_mac;
@@ -344,15 +274,10 @@ ssize_t wusb_prf(void *out, size_t out_size,
 	}
 	result = bytes;
 
-	kfree(scratch);
-error_alloc_scratch:
 error_ccm_mac:
-error_setkey_aes:
-	crypto_free_cipher(tfm_aes);
-error_alloc_aes:
-error_setkey_cbc:
-	crypto_free_sync_skcipher(tfm_cbc);
-error_alloc_cbc:
+error_setkey_cbcmac:
+	crypto_free_shash(tfm_cbcmac);
+error_alloc_cbcmac:
 	return result;
 }
 
@@ -377,12 +302,8 @@ static int wusb_oob_mic_verify(void)
 {
 	int result;
 	u8 mic[8];
-	/* WUSB1.0[A.2] test vectors
-	 *
-	 * Need to keep it in the local stack as GCC 4.1.3something
-	 * messes up and generates noise.
-	 */
-	struct usb_handshake stv_hsmic_hs = {
+	/* WUSB1.0[A.2] test vectors */
+	static const struct usb_handshake stv_hsmic_hs = {
 		.bMessageNumber = 2,
 		.bStatus 	= 00,
 		.tTKID 		= { 0x76, 0x98, 0x01 },
@@ -457,11 +378,8 @@ static int wusb_key_derive_verify(void)
 {
 	int result = 0;
 	struct wusb_keydvt_out keydvt_out;
-	/* These come from WUSB1.0[A.1] + 2006/12 errata
-	 * NOTE: can't make this const or global -- somehow it seems
-	 *       the scatterlists for crypto get confused and we get
-	 *       bad data. There is no doc on this... */
-	struct wusb_keydvt_in stv_keydvt_in_a1 = {
+	/* These come from WUSB1.0[A.1] + 2006/12 errata */
+	static const struct wusb_keydvt_in stv_keydvt_in_a1 = {
 		.hnonce = {
 			0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
 			0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f
-- 
2.20.1

