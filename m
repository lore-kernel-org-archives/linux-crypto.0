Return-Path: <SRS0=me0G=UN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098CFC31E44
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 08:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCA3020851
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 08:34:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KajoO1eg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfFNIeT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jun 2019 04:34:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37865 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfFNIeS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jun 2019 04:34:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id v14so1577473wrr.4
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jun 2019 01:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jVi9QO7CHKBZdi2+fLpwMFoN+KF7AYiGK0YKfY/qKiM=;
        b=KajoO1egiIOR9nWNNH2fm5ullJAmhXmPemSugKLGhmub7m/OwqcoMcL00HrUCcNZQG
         GM76T7SP/PWooKtj0lMylEDTFWqv/WN1NeXmM1WDE1AFfWhHQlcKWdQ/xCtN7IRutTfi
         SNOmNMyQOk9qiCEv7Q04HwpnEaBs6wVXyWtLMVr2YGTjiKyH8ig/woEtfh1ksCm9UTUI
         7A0FUosbcrXBcUU3Rs6gzOObrgGlv4z99bF5HdfTfF615zgI5/scnZ1nxpV/n7E7+dux
         e7QZvigJp3QXnvb3ydPJAbkpnpR5vV0E/MNNBuODlQ5qHPpvpadhOYLpshHn9PyX4n9Z
         +v8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jVi9QO7CHKBZdi2+fLpwMFoN+KF7AYiGK0YKfY/qKiM=;
        b=h57yd2iuCYqJ+J/J5owU9D1i0zgsWRMl12yw8eXMNCoooPHFcKS3xA4cf/mHio/CQC
         CNusKf2rOyPPo3i54+KHReHzGBonQegCC8DGO5pg+BU+rwB83ysXUOWE7hnh8DtGNRwV
         sUoVNKbG5Hpc8pZKZQVAou1+yjpTJaGXXOUn29+3Lk4M5l2aqmZ4TY7r0gqRdPJHBIhW
         WQcYQ3aqYvCPdCq2eVXrPhk6N3ZpVsJom1MBfR4cNhiPDhz/Pw3sIrE0Lzhc1TlA71WQ
         9gSdUTBYu7dAHil6V7WYV1kO0fs2iekEDO9q2CFwEjqfmS39tYBv61AcJy0WI0mDJse4
         WHpw==
X-Gm-Message-State: APjAAAUNaq0G42QyBIFKtQjItrOQ/dLotGpC5JPKfydMlbjoYFCdHElu
        o8CQCZnJztYHNeyQ4bZVhIVPfj34abX1oQ==
X-Google-Smtp-Source: APXvYqx9YTHS84gIPgmRDm73UK26a4NsmO0BPvni9R5bFdBUI1GN/Eqp45TdzoWwLNTOb2ytUW9GGA==
X-Received: by 2002:adf:8367:: with SMTP id 94mr13146436wrd.179.1560501255767;
        Fri, 14 Jun 2019 01:34:15 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:8d0e:a5b1:c005:e3b5])
        by smtp.gmail.com with ESMTPSA id f3sm1710802wre.93.2019.06.14.01.34.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 01:34:15 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>
Subject: [RFC PATCH 2/3] dm crypt: switch to essiv shash
Date:   Fri, 14 Jun 2019 10:34:03 +0200
Message-Id: <20190614083404.20514-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace the open coded ESSIV handling with invocations into the new
ESSIV shash, created specifically for this purpose. Using this more
abstract interface allows the crypto subsystem to refactor the way
ciphers are used, and to provide better testing coverage.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/md/Kconfig    |   1 +
 drivers/md/dm-crypt.c | 137 ++++----------------
 2 files changed, 24 insertions(+), 114 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 45254b3ef715..30ca87cf25db 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -271,6 +271,7 @@ config DM_CRYPT
 	depends on BLK_DEV_DM
 	select CRYPTO
 	select CRYPTO_CBC
+	select CRYPTO_ESSIV
 	---help---
 	  This device-mapper target allows you to create a device that
 	  transparently encrypts the data on it. You'll need to activate
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1b16d34bb785..b66ef3de835a 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -98,11 +98,6 @@ struct crypt_iv_operations {
 		    struct dm_crypt_request *dmreq);
 };
 
-struct iv_essiv_private {
-	struct crypto_shash *hash_tfm;
-	u8 *salt;
-};
-
 struct iv_benbi_private {
 	int shift;
 };
@@ -155,7 +150,6 @@ struct crypt_config {
 
 	const struct crypt_iv_operations *iv_gen_ops;
 	union {
-		struct iv_essiv_private essiv;
 		struct iv_benbi_private benbi;
 		struct iv_lmk_private lmk;
 		struct iv_tcw_private tcw;
@@ -165,7 +159,7 @@ struct crypt_config {
 	unsigned short int sector_size;
 	unsigned char sector_shift;
 
-	/* ESSIV: struct crypto_cipher *essiv_tfm */
+	/* ESSIV: struct crypto_shash *essiv_tfm */
 	void *iv_private;
 	union {
 		struct crypto_skcipher **tfms;
@@ -326,94 +320,27 @@ static int crypt_iv_plain64be_gen(struct crypt_config *cc, u8 *iv,
 /* Initialise ESSIV - compute salt but no local memory allocations */
 static int crypt_iv_essiv_init(struct crypt_config *cc)
 {
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-	SHASH_DESC_ON_STACK(desc, essiv->hash_tfm);
-	struct crypto_cipher *essiv_tfm;
-	int err;
-
-	desc->tfm = essiv->hash_tfm;
-
-	err = crypto_shash_digest(desc, cc->key, cc->key_size, essiv->salt);
-	shash_desc_zero(desc);
-	if (err)
-		return err;
-
-	essiv_tfm = cc->iv_private;
+	struct crypto_shash *essiv_tfm = cc->iv_private;
 
-	err = crypto_cipher_setkey(essiv_tfm, essiv->salt,
-			    crypto_shash_digestsize(essiv->hash_tfm));
-	if (err)
-		return err;
-
-	return 0;
+	return crypto_shash_setkey(essiv_tfm, cc->key, cc->key_size);
 }
 
 /* Wipe salt and reset key derived from volume key */
 static int crypt_iv_essiv_wipe(struct crypt_config *cc)
 {
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-	unsigned salt_size = crypto_shash_digestsize(essiv->hash_tfm);
-	struct crypto_cipher *essiv_tfm;
-	int r, err = 0;
-
-	memset(essiv->salt, 0, salt_size);
+	struct crypto_shash *essiv_tfm;
 
 	essiv_tfm = cc->iv_private;
-	r = crypto_cipher_setkey(essiv_tfm, essiv->salt, salt_size);
-	if (r)
-		err = r;
-
-	return err;
-}
-
-/* Allocate the cipher for ESSIV */
-static struct crypto_cipher *alloc_essiv_cipher(struct crypt_config *cc,
-						struct dm_target *ti,
-						const u8 *salt,
-						unsigned int saltsize)
-{
-	struct crypto_cipher *essiv_tfm;
-	int err;
-
-	/* Setup the essiv_tfm with the given salt */
-	essiv_tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
-	if (IS_ERR(essiv_tfm)) {
-		ti->error = "Error allocating crypto tfm for ESSIV";
-		return essiv_tfm;
-	}
-
-	if (crypto_cipher_blocksize(essiv_tfm) != cc->iv_size) {
-		ti->error = "Block size of ESSIV cipher does "
-			    "not match IV size of block cipher";
-		crypto_free_cipher(essiv_tfm);
-		return ERR_PTR(-EINVAL);
-	}
-
-	err = crypto_cipher_setkey(essiv_tfm, salt, saltsize);
-	if (err) {
-		ti->error = "Failed to set key for ESSIV cipher";
-		crypto_free_cipher(essiv_tfm);
-		return ERR_PTR(err);
-	}
-
-	return essiv_tfm;
+	return crypto_shash_setkey(essiv_tfm, NULL, 0);
 }
 
 static void crypt_iv_essiv_dtr(struct crypt_config *cc)
 {
-	struct crypto_cipher *essiv_tfm;
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-
-	crypto_free_shash(essiv->hash_tfm);
-	essiv->hash_tfm = NULL;
-
-	kzfree(essiv->salt);
-	essiv->salt = NULL;
+	struct crypto_shash *essiv_tfm;
 
 	essiv_tfm = cc->iv_private;
-
 	if (essiv_tfm)
-		crypto_free_cipher(essiv_tfm);
+		crypto_free_shash(essiv_tfm);
 
 	cc->iv_private = NULL;
 }
@@ -421,9 +348,8 @@ static void crypt_iv_essiv_dtr(struct crypt_config *cc)
 static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 			      const char *opts)
 {
-	struct crypto_cipher *essiv_tfm = NULL;
-	struct crypto_shash *hash_tfm = NULL;
-	u8 *salt = NULL;
+	struct crypto_shash *essiv_tfm = NULL;
+	u8 name[CRYPTO_MAX_ALG_NAME];
 	int err;
 
 	if (!opts) {
@@ -431,51 +357,34 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	/* Allocate hash algorithm */
-	hash_tfm = crypto_alloc_shash(opts, 0, 0);
-	if (IS_ERR(hash_tfm)) {
-		ti->error = "Error initializing ESSIV hash";
-		err = PTR_ERR(hash_tfm);
-		goto bad;
-	}
-
-	salt = kzalloc(crypto_shash_digestsize(hash_tfm), GFP_KERNEL);
-	if (!salt) {
-		ti->error = "Error kmallocing salt storage in ESSIV";
-		err = -ENOMEM;
-		goto bad;
-	}
-
-	cc->iv_gen_private.essiv.salt = salt;
-	cc->iv_gen_private.essiv.hash_tfm = hash_tfm;
+	snprintf(name, CRYPTO_MAX_ALG_NAME, "essiv(%s,%s)", cc->cipher, opts);
 
-	essiv_tfm = alloc_essiv_cipher(cc, ti, salt,
-				       crypto_shash_digestsize(hash_tfm));
-	if (IS_ERR(essiv_tfm)) {
-		crypt_iv_essiv_dtr(cc);
+	essiv_tfm = crypto_alloc_shash(name, 0, 0);
+	if (IS_ERR(essiv_tfm))
 		return PTR_ERR(essiv_tfm);
+
+	err = crypto_shash_setkey(essiv_tfm, cc->key, cc->key_size);
+	if (err) {
+		ti->error = "Failed to set key for ESSIV cipher";
+		crypto_free_shash(essiv_tfm);
+		return err;
 	}
+
 	cc->iv_private = essiv_tfm;
 
 	return 0;
-
-bad:
-	if (hash_tfm && !IS_ERR(hash_tfm))
-		crypto_free_shash(hash_tfm);
-	kfree(salt);
-	return err;
 }
 
 static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv,
 			      struct dm_crypt_request *dmreq)
 {
-	struct crypto_cipher *essiv_tfm = cc->iv_private;
+	struct crypto_shash *essiv_tfm = cc->iv_private;
+	SHASH_DESC_ON_STACK(desc, essiv_tfm);
 
 	memset(iv, 0, cc->iv_size);
 	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector);
-	crypto_cipher_encrypt_one(essiv_tfm, iv, iv);
-
-	return 0;
+	desc->tfm = essiv_tfm;
+	return crypto_shash_digest(desc, iv, sizeof(__le64), iv);
 }
 
 static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
-- 
2.20.1

