Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2537EECE58E
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0E5420700
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yIU2dZEo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbfJGQql (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50443 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbfJGQqk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id 5so230871wmg.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3KYzyJG0KPQg/NKCrKbyZmAb/K1Eaht43wf2/3hmTm4=;
        b=yIU2dZEo0XsjshtytMGuhBZhGR09qyYHKCr21brIQCK3Unw+v3wLqkxCMNfzyTf0lH
         ZQfxsF1op4/ze56BGKtoqToKX5+ykX+b8GW6TNHS+CJPc597zfnZvNVDaSGnlpG+Yfhg
         aBf+jwVdlfSr0bp9jzYH0PnPmt5FpszKzejvd1Gz4A+wASN00QRA/6QY4/X9Xvay4+QH
         2i7gIh6stpKLRo5tlxCXFqvBWWSZX0VaHRb8wyTP/2eFWShjKNk4wV+sjd9awHqIKqDa
         CivtiQ95LI0aBtZamk50ZwERSpDIb/6lINEYJhz/be/io804UGgNeRzTlXzlgiW1tsEx
         ntmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3KYzyJG0KPQg/NKCrKbyZmAb/K1Eaht43wf2/3hmTm4=;
        b=XeaoFtzALm3YTKXhH91ToMmIN6b31URM6SLa2f5A395+GEKD6oULCTzmb2tWL2z6TT
         S6axd2HHBxP+UwWVRAeHczexY2mKk5HKITXSOHU0UO4df5xc/4d39JyuX5DIOyhcjbBR
         mzCwsAUsyWr0wI4UyBhrSEj0snPxtzgoF7arhv4X4kwXXW3SsYFFx4kd7W60HAfo+nz2
         DidiykOd4e4r+xtrXLKrQ2t2tywYfLERb9mV7ai5ZjpIWh3HD5jvOLilcJn0tvrHYvME
         8iKyaXoksiCT7nBwbc4ODzcU4ck24COWhWNtyRAbf3uGK+Y0g+JcVDA4IOhL5Nx8VmlC
         yWzQ==
X-Gm-Message-State: APjAAAVxqBxBjCwJe8FvWeF0CbEtsxd83cM23fHvR9ziROG1mbf/oy+B
        Jidlf/eDZkiYO82jviZND9ksDCeUYIn7JQ==
X-Google-Smtp-Source: APXvYqwfDcCkKDTe0SlMcEUoRwj2DkMd3yyWiMfTHP2+/ACZXjV1SeSW7G0aCcuK+CZKUQgimPcF6w==
X-Received: by 2002:a7b:c049:: with SMTP id u9mr193700wmc.12.1570466798096;
        Mon, 07 Oct 2019 09:46:38 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:37 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Subject: [PATCH v3 14/29] crypto: poly1305 - expose init/update/final library interface
Date:   Mon,  7 Oct 2019 18:45:55 +0200
Message-Id: <20191007164610.6881-15-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Expose the existing generic Poly1305 code via a init/update/final
library interface so that callers are not required to go through
the crypto API's shash abstraction to access it. At the same time,
make some preparations so that the library implementation can be
superseded by an accelerated arch-specific version in the future.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig                     | 11 +++
 crypto/poly1305_generic.c          | 22 +----
 include/crypto/internal/poly1305.h |  7 ++
 include/crypto/poly1305.h          |  8 +-
 lib/crypto/poly1305.c              | 90 ++++++++++++++++++++
 5 files changed, 116 insertions(+), 22 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e510caf587df..ead0c3d15823 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -682,8 +682,19 @@ config CRYPTO_GHASH
 	  GHASH is the hash function used in GCM (Galois/Counter Mode).
 	  It is not a general-purpose cryptographic hash function.
 
+config CRYPTO_ARCH_HAVE_LIB_POLY1305
+	tristate
+
+config CRYPTO_LIB_POLY1305_RSIZE
+	int
+	default 1
+
+config CRYPTO_LIB_POLY1305
+	tristate
+
 config CRYPTO_LIB_POLY1305_GENERIC
 	tristate
+	default CRYPTO_LIB_POLY1305 if !CRYPTO_ARCH_HAVE_LIB_POLY1305
 
 config CRYPTO_POLY1305
 	tristate "Poly1305 authenticator algorithm"
diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index f3fcd9578a47..afe9a9e576dd 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -85,31 +85,11 @@ EXPORT_SYMBOL_GPL(crypto_poly1305_update);
 int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
-	__le32 digest[4];
-	u64 f = 0;
 
 	if (unlikely(!dctx->sset))
 		return -ENOKEY;
 
-	if (unlikely(dctx->buflen)) {
-		dctx->buf[dctx->buflen++] = 1;
-		memset(dctx->buf + dctx->buflen, 0,
-		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_core_blocks(&dctx->h, dctx->r, dctx->buf, 1, 0);
-	}
-
-	poly1305_core_emit(&dctx->h, digest);
-
-	/* mac = (h + s) % (2^128) */
-	f = (f >> 32) + le32_to_cpu(digest[0]) + dctx->s[0];
-	put_unaligned_le32(f, dst + 0);
-	f = (f >> 32) + le32_to_cpu(digest[1]) + dctx->s[1];
-	put_unaligned_le32(f, dst + 4);
-	f = (f >> 32) + le32_to_cpu(digest[2]) + dctx->s[2];
-	put_unaligned_le32(f, dst + 8);
-	f = (f >> 32) + le32_to_cpu(digest[3]) + dctx->s[3];
-	put_unaligned_le32(f, dst + 12);
-
+	poly1305_final_generic(dctx, dst);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_poly1305_final);
diff --git a/include/crypto/internal/poly1305.h b/include/crypto/internal/poly1305.h
index 04fa269e5534..68269f0d0062 100644
--- a/include/crypto/internal/poly1305.h
+++ b/include/crypto/internal/poly1305.h
@@ -28,6 +28,13 @@ void poly1305_core_blocks(struct poly1305_state *state,
 			  unsigned int nblocks, u32 hibit);
 void poly1305_core_emit(const struct poly1305_state *state, void *dst);
 
+void poly1305_init_generic(struct poly1305_desc_ctx *desc, const u8 *key);
+
+void poly1305_update_generic(struct poly1305_desc_ctx *desc, const u8 *src,
+			     unsigned int nbytes);
+
+void poly1305_final_generic(struct poly1305_desc_ctx *desc, u8 *digest);
+
 /* Crypto API helper functions for the Poly1305 MAC */
 int crypto_poly1305_init(struct shash_desc *desc);
 
diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
index 36b5886cb50c..39afea016ac3 100644
--- a/include/crypto/poly1305.h
+++ b/include/crypto/poly1305.h
@@ -35,7 +35,13 @@ struct poly1305_desc_ctx {
 	/* accumulator */
 	struct poly1305_state h;
 	/* key */
-	struct poly1305_key r[1];
+	struct poly1305_key r[CONFIG_CRYPTO_LIB_POLY1305_RSIZE];
 };
 
+void poly1305_init(struct poly1305_desc_ctx *desc, const u8 *key);
+
+void poly1305_update(struct poly1305_desc_ctx *desc, const u8 *src,
+		     unsigned int nbytes);
+void poly1305_final(struct poly1305_desc_ctx *desc, u8 *digest);
+
 #endif
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
index f019a57dbc1b..88367139b125 100644
--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -154,5 +154,95 @@ void poly1305_core_emit(const struct poly1305_state *state, void *dst)
 }
 EXPORT_SYMBOL_GPL(poly1305_core_emit);
 
+void poly1305_init_generic(struct poly1305_desc_ctx *desc, const u8 *key)
+{
+	poly1305_core_setkey(desc->r, key);
+	desc->s[0] = get_unaligned_le32(key + 16);
+	desc->s[1] = get_unaligned_le32(key + 20);
+	desc->s[2] = get_unaligned_le32(key + 24);
+	desc->s[3] = get_unaligned_le32(key + 28);
+	poly1305_core_init(&desc->h);
+	desc->buflen = 0;
+	desc->sset = true;
+	desc->rset = 1;
+}
+EXPORT_SYMBOL_GPL(poly1305_init_generic);
+
+void poly1305_update_generic(struct poly1305_desc_ctx *desc, const u8 *src,
+			     unsigned int nbytes)
+{
+	unsigned int bytes;
+
+	if (unlikely(desc->buflen)) {
+		bytes = min(nbytes, POLY1305_BLOCK_SIZE - desc->buflen);
+		memcpy(desc->buf + desc->buflen, src, bytes);
+		src += bytes;
+		nbytes -= bytes;
+		desc->buflen += bytes;
+
+		if (desc->buflen == POLY1305_BLOCK_SIZE) {
+			poly1305_core_blocks(&desc->h, desc->r, desc->buf, 1, 1);
+			desc->buflen = 0;
+		}
+	}
+
+	if (likely(nbytes >= POLY1305_BLOCK_SIZE)) {
+		poly1305_core_blocks(&desc->h, desc->r, src,
+				     nbytes / POLY1305_BLOCK_SIZE, 1);
+		src += nbytes - (nbytes % POLY1305_BLOCK_SIZE);
+		nbytes %= POLY1305_BLOCK_SIZE;
+	}
+
+	if (unlikely(nbytes)) {
+		desc->buflen = nbytes;
+		memcpy(desc->buf, src, nbytes);
+	}
+}
+EXPORT_SYMBOL_GPL(poly1305_update_generic);
+
+void poly1305_final_generic(struct poly1305_desc_ctx *desc, u8 *dst)
+{
+	__le32 digest[4];
+	u64 f = 0;
+
+	if (unlikely(desc->buflen)) {
+		desc->buf[desc->buflen++] = 1;
+		memset(desc->buf + desc->buflen, 0,
+		       POLY1305_BLOCK_SIZE - desc->buflen);
+		poly1305_core_blocks(&desc->h, desc->r, desc->buf, 1, 0);
+	}
+
+	poly1305_core_emit(&desc->h, digest);
+
+	/* mac = (h + s) % (2^128) */
+	f = (f >> 32) + le32_to_cpu(digest[0]) + desc->s[0];
+	put_unaligned_le32(f, dst + 0);
+	f = (f >> 32) + le32_to_cpu(digest[1]) + desc->s[1];
+	put_unaligned_le32(f, dst + 4);
+	f = (f >> 32) + le32_to_cpu(digest[2]) + desc->s[2];
+	put_unaligned_le32(f, dst + 8);
+	f = (f >> 32) + le32_to_cpu(digest[3]) + desc->s[3];
+	put_unaligned_le32(f, dst + 12);
+
+	*desc = (struct poly1305_desc_ctx){};
+}
+EXPORT_SYMBOL_GPL(poly1305_final_generic);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
+
+extern void poly1305_init(struct poly1305_desc_ctx *desc, const u8 *key)
+	__weak __alias(poly1305_init_generic);
+
+extern void poly1305_update(struct poly1305_desc_ctx *desc, const u8 *src,
+			    unsigned int nbytes)
+	__weak __alias(poly1305_update_generic);
+
+extern void poly1305_final(struct poly1305_desc_ctx *desc, u8 *dst)
+	__weak __alias(poly1305_final_generic);
+
+#if !IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305)
+EXPORT_SYMBOL_GPL(poly1305_init);
+EXPORT_SYMBOL_GPL(poly1305_update);
+EXPORT_SYMBOL_GPL(poly1305_final);
+#endif
-- 
2.20.1

