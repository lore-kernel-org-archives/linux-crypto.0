Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8923C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 824B621850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KSqQ31mT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfGBTme (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:34 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:47059 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbfGBTmd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:33 -0400
Received: by mail-lf1-f65.google.com with SMTP id z15so12235871lfh.13
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EQ+7881FqzZH4XJUNCnQNTsoZJakZlk4h+tK69pjZnw=;
        b=KSqQ31mTMR68uqoDDMtL18VTyUwNomEO6rBJl3cZAEG8HW6OPTdeCayCfVuFkuHCiJ
         630Ksb8d2TGsFnmZ14/Egsfh2/kWZpjTlN9hHrT1hKOeOh2PtX65ABGdqEMc+8TxOI7z
         2YRmE7kkF/Ft27kDoEFqsvuFJAOiqGc8oNiiQzBv75y4NnMUw4A5tIimYsmR9VOswKsa
         6NS0SuhhqOOPXhfAvBnuiSq3+JwvpqsBb24gTZDWmnF3h4Brn0hY/pYtRSYQsVPDlF+H
         OEwKTaqu4bAnFnnlzpxkMjpKqqb4GjPKFZA+RD+MtGCRTnETa9XlToUqN4lwt4OT3Gn+
         vPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EQ+7881FqzZH4XJUNCnQNTsoZJakZlk4h+tK69pjZnw=;
        b=FCuZ9vwaZBdTgE8aWSZ5kf1MLOadg28WAlmOXVPq2VU+YxXCGT8DuC7v12xVhPVgmt
         lfEs856aqMVpkcmfAr19hTy11oBH2bSb1Dqz5nPxBS0xvaJBkdll7krBwud3+BVWllfV
         UlauB8zOrJ3Uh9S82ve431x8HZKGS9vsi5snh2Zr+dvn1ThuJx6LAreH8ScCL21L8eE0
         e2700uUJL8ivoT1TOtFvp0iqssZ4PsCRHspiiCI463PlrOkdj0vyuOcLL6dsKx16OPww
         fKEy+eB3ZM0uKAz1u9CCzHRCCgpxMwhl8peQ2OxSMuVHPWkDKtJZk4tl6NANCbYIjaV7
         fwkQ==
X-Gm-Message-State: APjAAAW2tRkgpd/+2ae3YU3KNLlW8XV56R0qlougptFRRaaP5H2PukD9
        +DuomV40ChxqcoGrVea4wC4J2OzmXUk/uqaY
X-Google-Smtp-Source: APXvYqySSbv758Csh2RO4EtWkWZnt5/91SPMb47DhW82U0bjzagjhbXhcui41bfdk1mH5gQlvawMxg==
X-Received: by 2002:a19:6602:: with SMTP id a2mr15069293lfc.25.1562096550597;
        Tue, 02 Jul 2019 12:42:30 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:29 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 15/32] crypto: generic/aes - drop key expansion routine in favor of library version
Date:   Tue,  2 Jul 2019 21:41:33 +0200
Message-Id: <20190702194150.10405-16-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop aes-generic's version of crypto_aes_expand_key(), and switch to
the key expansion routine provided by the AES library. AES key expansion
is not performance critical, and it is better to have a single version
shared by all AES implementations.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig       |   1 +
 crypto/aes_generic.c | 153 +-------------------
 include/crypto/aes.h |   2 -
 3 files changed, 3 insertions(+), 153 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index df6f0be66574..80ea118600ab 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1072,6 +1072,7 @@ config CRYPTO_LIB_AES
 config CRYPTO_AES
 	tristate "AES cipher algorithms"
 	select CRYPTO_ALGAPI
+	select CRYPTO_LIB_AES
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
 	  algorithm.
diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index 3aa4a715c216..426deb437f19 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1125,155 +1125,6 @@ EXPORT_SYMBOL_GPL(crypto_fl_tab);
 EXPORT_SYMBOL_GPL(crypto_it_tab);
 EXPORT_SYMBOL_GPL(crypto_il_tab);
 
-/* initialise the key schedule from the user supplied key */
-
-#define star_x(x) (((x) & 0x7f7f7f7f) << 1) ^ ((((x) & 0x80808080) >> 7) * 0x1b)
-
-#define imix_col(y, x)	do {		\
-	u	= star_x(x);		\
-	v	= star_x(u);		\
-	w	= star_x(v);		\
-	t	= w ^ (x);		\
-	(y)	= u ^ v ^ w;		\
-	(y)	^= ror32(u ^ t, 8) ^	\
-		ror32(v ^ t, 16) ^	\
-		ror32(t, 24);		\
-} while (0)
-
-#define ls_box(x)		\
-	crypto_fl_tab[0][byte(x, 0)] ^	\
-	crypto_fl_tab[1][byte(x, 1)] ^	\
-	crypto_fl_tab[2][byte(x, 2)] ^	\
-	crypto_fl_tab[3][byte(x, 3)]
-
-#define loop4(i)	do {		\
-	t = ror32(t, 8);		\
-	t = ls_box(t) ^ rco_tab[i];	\
-	t ^= ctx->key_enc[4 * i];		\
-	ctx->key_enc[4 * i + 4] = t;		\
-	t ^= ctx->key_enc[4 * i + 1];		\
-	ctx->key_enc[4 * i + 5] = t;		\
-	t ^= ctx->key_enc[4 * i + 2];		\
-	ctx->key_enc[4 * i + 6] = t;		\
-	t ^= ctx->key_enc[4 * i + 3];		\
-	ctx->key_enc[4 * i + 7] = t;		\
-} while (0)
-
-#define loop6(i)	do {		\
-	t = ror32(t, 8);		\
-	t = ls_box(t) ^ rco_tab[i];	\
-	t ^= ctx->key_enc[6 * i];		\
-	ctx->key_enc[6 * i + 6] = t;		\
-	t ^= ctx->key_enc[6 * i + 1];		\
-	ctx->key_enc[6 * i + 7] = t;		\
-	t ^= ctx->key_enc[6 * i + 2];		\
-	ctx->key_enc[6 * i + 8] = t;		\
-	t ^= ctx->key_enc[6 * i + 3];		\
-	ctx->key_enc[6 * i + 9] = t;		\
-	t ^= ctx->key_enc[6 * i + 4];		\
-	ctx->key_enc[6 * i + 10] = t;		\
-	t ^= ctx->key_enc[6 * i + 5];		\
-	ctx->key_enc[6 * i + 11] = t;		\
-} while (0)
-
-#define loop8tophalf(i)	do {			\
-	t = ror32(t, 8);			\
-	t = ls_box(t) ^ rco_tab[i];		\
-	t ^= ctx->key_enc[8 * i];			\
-	ctx->key_enc[8 * i + 8] = t;			\
-	t ^= ctx->key_enc[8 * i + 1];			\
-	ctx->key_enc[8 * i + 9] = t;			\
-	t ^= ctx->key_enc[8 * i + 2];			\
-	ctx->key_enc[8 * i + 10] = t;			\
-	t ^= ctx->key_enc[8 * i + 3];			\
-	ctx->key_enc[8 * i + 11] = t;			\
-} while (0)
-
-#define loop8(i)	do {				\
-	loop8tophalf(i);				\
-	t  = ctx->key_enc[8 * i + 4] ^ ls_box(t);	\
-	ctx->key_enc[8 * i + 12] = t;			\
-	t ^= ctx->key_enc[8 * i + 5];			\
-	ctx->key_enc[8 * i + 13] = t;			\
-	t ^= ctx->key_enc[8 * i + 6];			\
-	ctx->key_enc[8 * i + 14] = t;			\
-	t ^= ctx->key_enc[8 * i + 7];			\
-	ctx->key_enc[8 * i + 15] = t;			\
-} while (0)
-
-/**
- * crypto_aes_expand_key - Expands the AES key as described in FIPS-197
- * @ctx:	The location where the computed key will be stored.
- * @in_key:	The supplied key.
- * @key_len:	The length of the supplied key.
- *
- * Returns 0 on success. The function fails only if an invalid key size (or
- * pointer) is supplied.
- * The expanded key size is 240 bytes (max of 14 rounds with a unique 16 bytes
- * key schedule plus a 16 bytes key which is used before the first round).
- * The decryption key is prepared for the "Equivalent Inverse Cipher" as
- * described in FIPS-197. The first slot (16 bytes) of each key (enc or dec) is
- * for the initial combination, the second slot for the first round and so on.
- */
-int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
-		unsigned int key_len)
-{
-	u32 i, t, u, v, w, j;
-
-	if (key_len != AES_KEYSIZE_128 && key_len != AES_KEYSIZE_192 &&
-			key_len != AES_KEYSIZE_256)
-		return -EINVAL;
-
-	ctx->key_length = key_len;
-
-	ctx->key_enc[0] = get_unaligned_le32(in_key);
-	ctx->key_enc[1] = get_unaligned_le32(in_key + 4);
-	ctx->key_enc[2] = get_unaligned_le32(in_key + 8);
-	ctx->key_enc[3] = get_unaligned_le32(in_key + 12);
-
-	ctx->key_dec[key_len + 24] = ctx->key_enc[0];
-	ctx->key_dec[key_len + 25] = ctx->key_enc[1];
-	ctx->key_dec[key_len + 26] = ctx->key_enc[2];
-	ctx->key_dec[key_len + 27] = ctx->key_enc[3];
-
-	switch (key_len) {
-	case AES_KEYSIZE_128:
-		t = ctx->key_enc[3];
-		for (i = 0; i < 10; ++i)
-			loop4(i);
-		break;
-
-	case AES_KEYSIZE_192:
-		ctx->key_enc[4] = get_unaligned_le32(in_key + 16);
-		t = ctx->key_enc[5] = get_unaligned_le32(in_key + 20);
-		for (i = 0; i < 8; ++i)
-			loop6(i);
-		break;
-
-	case AES_KEYSIZE_256:
-		ctx->key_enc[4] = get_unaligned_le32(in_key + 16);
-		ctx->key_enc[5] = get_unaligned_le32(in_key + 20);
-		ctx->key_enc[6] = get_unaligned_le32(in_key + 24);
-		t = ctx->key_enc[7] = get_unaligned_le32(in_key + 28);
-		for (i = 0; i < 6; ++i)
-			loop8(i);
-		loop8tophalf(i);
-		break;
-	}
-
-	ctx->key_dec[0] = ctx->key_enc[key_len + 24];
-	ctx->key_dec[1] = ctx->key_enc[key_len + 25];
-	ctx->key_dec[2] = ctx->key_enc[key_len + 26];
-	ctx->key_dec[3] = ctx->key_enc[key_len + 27];
-
-	for (i = 4; i < key_len + 24; ++i) {
-		j = key_len + 24 - (i & ~3) + (i & 3);
-		imix_col(ctx->key_dec[j], ctx->key_enc[i]);
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(crypto_aes_expand_key);
-
 /**
  * crypto_aes_set_key - Set the AES key.
  * @tfm:	The %crypto_tfm that is used in the context.
@@ -1281,7 +1132,7 @@ EXPORT_SYMBOL_GPL(crypto_aes_expand_key);
  * @key_len:	The size of the key.
  *
  * Returns 0 on success, on failure the %CRYPTO_TFM_RES_BAD_KEY_LEN flag in tfm
- * is set. The function uses crypto_aes_expand_key() to expand the key.
+ * is set. The function uses aes_expand_key() to expand the key.
  * &crypto_aes_ctx _must_ be the private data embedded in @tfm which is
  * retrieved with crypto_tfm_ctx().
  */
@@ -1292,7 +1143,7 @@ int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	u32 *flags = &tfm->crt_flags;
 	int ret;
 
-	ret = crypto_aes_expand_key(ctx, in_key, key_len);
+	ret = aes_expandkey(ctx, in_key, key_len);
 	if (!ret)
 		return 0;
 
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index d0067fca0cd0..0a64a977f9b3 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -35,8 +35,6 @@ extern const u32 crypto_il_tab[4][256] ____cacheline_aligned;
 
 int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		unsigned int key_len);
-int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
-		unsigned int key_len);
 
 /**
  * aes_expandkey - Expands the AES key as described in FIPS-197
-- 
2.17.1

