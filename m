Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F93CC19759
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 05:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 315CB21BF6
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 05:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lMdIxIi6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfHGFue (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 01:50:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55811 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfHGFue (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 01:50:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id f72so169517wmf.5
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 22:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=CXyjD2LOgdjBHwvd9Z5OLX5HdLR1iysQUf/zzqY6Pg0=;
        b=lMdIxIi6yJdoqNFjkK2obWzPaZeIBmGxoeEOHIr1pzD9k61SjXsh8zh4Nm6xWfws3S
         0ANsw1PpWH0aQgvkRH2+kfNcAiS3xokvUz7g4ZxBCGkHJBDI3+KCGptK/+RFBkQdw1cX
         fySnCvJD19wnY4s9FX9yeFQgKm3NUEXBumMWanotIp11zUhCTJdFFnhDFIt84ttQ4Fby
         0fSjwFMzLdmMRUJWAR9IG4D7y4hcF4wUpeWwdF2ahvwNVLDBmVJGycNr8qC6KjlDDaVq
         /3UuW+MLvfDwRPjHCytTyLlKaY1fi670gSxm+r9NvBzn7hOg1IlPOnzaIyYj81xjkIHn
         sfYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CXyjD2LOgdjBHwvd9Z5OLX5HdLR1iysQUf/zzqY6Pg0=;
        b=QtDNAGOGRHFs3AVWvX6mk5Asf+nhgVQ6TdYwuprNG1Wc/GVHeX2ym8PS/UzS1Mtuth
         ohGv5i2h4TlbaJl8W5mUz0TVJzB/JxHAF7QoC4EqvX/YMa8fXzUjrX+7fVYNn2Tune+5
         YLb+vCWGsujEgM9LWmbr2iwpFrQvc8wiVsvB6USpg7SzJ6qTdn+QBq2A/1BSIbme9pS1
         ayHVeY90QJsT4YRynZlT8bu/qfJJ9nI8vOfuVm2Vdwtcc4OYGnv0+qqPZBHkuT0Dz9Kx
         yaSoe6MpTg6FShDFwvq8cp22hYgLpRE7XSHmX9yVZ+1GCwEwf+AyaoYXWMkJqK2zf6d6
         nbQQ==
X-Gm-Message-State: APjAAAXUvTcHps+i2UHHzrN0CSITJSOMBVyozDj15rIVfcKeRON388Xx
        YC3vi4yNWxM/fidjoDPGIOc+w/tNEARabg==
X-Google-Smtp-Source: APXvYqy5kfvAkfH07mTHeHFHdgjVJ7ziNQjvaHEfPh0RCtkU5MmVmrtte4aRS9enZq15t2U40VZJNg==
X-Received: by 2002:a1c:9889:: with SMTP id a131mr1664005wme.22.1565157031209;
        Tue, 06 Aug 2019 22:50:31 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id h11sm2659891wrc.35.2019.08.06.22.50.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 22:50:29 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org, agk@redhat.com,
        snitzer@redhat.com, dm-devel@redhat.com, gmazyland@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
Date:   Wed,  7 Aug 2019 08:50:22 +0300
Message-Id: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of instantiating a separate cipher to perform the encryption
needed to produce the IV, reuse the skcipher used for the block data
and invoke it one additional time for each block to encrypt a zero
vector and use the output as the IV.

For CBC mode, this is equivalent to using the bare block cipher, but
without the risk of ending up with a non-time invariant implementation
of AES when the skcipher itself is time variant (e.g., arm64 without
Crypto Extensions has a NEON based time invariant implementation of
cbc(aes) but no time invariant implementation of the core cipher other
than aes-ti, which is not enabled by default)

This approach is a compromise between dm-crypt API flexibility and
reducing dependence on parts of the crypto API that should not usually
be exposed to other subsystems, such as the bare cipher API.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/md/dm-crypt.c | 70 ++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 48 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d5216bcc4649..48cd76c88d77 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -120,10 +120,6 @@ struct iv_tcw_private {
 	u8 *whitening;
 };
 
-struct iv_eboiv_private {
-	struct crypto_cipher *tfm;
-};
-
 /*
  * Crypt: maps a linear range of a block device
  * and encrypts / decrypts at the same time.
@@ -163,7 +159,6 @@ struct crypt_config {
 		struct iv_benbi_private benbi;
 		struct iv_lmk_private lmk;
 		struct iv_tcw_private tcw;
-		struct iv_eboiv_private eboiv;
 	} iv_gen_private;
 	u64 iv_offset;
 	unsigned int iv_size;
@@ -847,65 +842,47 @@ static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
 	return 0;
 }
 
-static void crypt_iv_eboiv_dtr(struct crypt_config *cc)
-{
-	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
-
-	crypto_free_cipher(eboiv->tfm);
-	eboiv->tfm = NULL;
-}
-
 static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 			    const char *opts)
 {
-	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
-	struct crypto_cipher *tfm;
-
-	tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
-	if (IS_ERR(tfm)) {
-		ti->error = "Error allocating crypto tfm for EBOIV";
-		return PTR_ERR(tfm);
+	if (test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags)) {
+		ti->error = "AEAD transforms not supported for EBOIV";
+		return -EINVAL;
 	}
 
-	if (crypto_cipher_blocksize(tfm) != cc->iv_size) {
+	if (crypto_skcipher_blocksize(any_tfm(cc)) != cc->iv_size) {
 		ti->error = "Block size of EBOIV cipher does "
 			    "not match IV size of block cipher";
-		crypto_free_cipher(tfm);
 		return -EINVAL;
 	}
 
-	eboiv->tfm = tfm;
 	return 0;
 }
 
-static int crypt_iv_eboiv_init(struct crypt_config *cc)
+static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
+			    struct dm_crypt_request *dmreq)
 {
-	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
+	u8 buf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
+	struct skcipher_request *req;
+	struct scatterlist src, dst;
+	struct crypto_wait wait;
 	int err;
 
-	err = crypto_cipher_setkey(eboiv->tfm, cc->key, cc->key_size);
-	if (err)
-		return err;
-
-	return 0;
-}
-
-static int crypt_iv_eboiv_wipe(struct crypt_config *cc)
-{
-	/* Called after cc->key is set to random key in crypt_wipe() */
-	return crypt_iv_eboiv_init(cc);
-}
+	req = skcipher_request_alloc(any_tfm(cc), GFP_KERNEL | GFP_NOFS);
+	if (!req)
+		return -ENOMEM;
 
-static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
-			    struct dm_crypt_request *dmreq)
-{
-	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
+	memset(buf, 0, cc->iv_size);
+	*(__le64 *)buf = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
 
-	memset(iv, 0, cc->iv_size);
-	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
-	crypto_cipher_encrypt_one(eboiv->tfm, iv, iv);
+	sg_init_one(&src, page_address(ZERO_PAGE(0)), cc->iv_size);
+	sg_init_one(&dst, iv, cc->iv_size);
+	skcipher_request_set_crypt(req, &src, &dst, cc->iv_size, buf);
+	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
+	err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+	skcipher_request_free(req);
 
-	return 0;
+	return err;
 }
 
 static const struct crypt_iv_operations crypt_iv_plain_ops = {
@@ -962,9 +939,6 @@ static struct crypt_iv_operations crypt_iv_random_ops = {
 
 static struct crypt_iv_operations crypt_iv_eboiv_ops = {
 	.ctr	   = crypt_iv_eboiv_ctr,
-	.dtr	   = crypt_iv_eboiv_dtr,
-	.init	   = crypt_iv_eboiv_init,
-	.wipe	   = crypt_iv_eboiv_wipe,
 	.generator = crypt_iv_eboiv_gen
 };
 
-- 
2.17.1

