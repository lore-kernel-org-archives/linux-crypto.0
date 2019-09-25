Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC856C432C2
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAC7821D7E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s3m7b9na"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387914AbfIYQNv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:13:51 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38778 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387893AbfIYQNv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 12:13:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id 3so5622385wmi.3
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 09:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D96R9BcQ8eKJUV7xjET5CNTgwensabrJ4To3CfkaNW8=;
        b=s3m7b9naLnNHrD0f/3+dV9tT2F26ZviX7fM8ksVZppWW7QbSmlRyhtUnKmysWyycxL
         QRgbfaz9jdwloFQ0zmVeGl860ldSIqTCS24yRKEnUgkxsXZQBieWx7+RsIyOabP5l1NI
         CaLze6rOX7Ks1YC8g2XOeNtTS5/IG33f917vYpdsKsKh+XoLQsYogu3bdNXE8TKiSMoO
         lVMRxjAD1pES7Xjw4dmUla/yurD8Lb3HymYsZJKnl29MJ9Ye7dH//ulN/TgabxNdsScb
         YMXMeYP5mQpbr4owmS5HBlq8lFvmKyx5dR9AUIJbus4U0FMeHDjZ1RVoAnMfdwEKJ7H9
         JNOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D96R9BcQ8eKJUV7xjET5CNTgwensabrJ4To3CfkaNW8=;
        b=ZoPYf+lN7U1nJ+G2fWnyHAmu4gB12sDHCg1WzBlcyV3UJbjdWbMFp4ukJTCLwnqngg
         tA0zzVpvvLdsAvnuLHFGfwHQwXgusRpjpIFeHRPPJS04oxIIkzjk6+N1NINCNU87nn9w
         f7jNqiofLkqCH1f23OyIvpNy0rHtbDID28NXr3KXM8TntLD0n3eFk0oZZxonTGlyW/dx
         eNmVCrqDiGIcYKsPey2/ocTTNndA9+gWA+ega/E5zsy9bCHld8DIKm4gneWYqVsemf/q
         gqAMR4EwFRHRWI12Z243v8jUpZuvyoHzS9HGpy5Nv/cl5PRoEap2g1RM1nfkerGcac/L
         glzA==
X-Gm-Message-State: APjAAAVPocXuueUSKrE7usXK3KNnMegafjb76C4wePWARXY1XPboah6I
        Hh1GiGQ6IiD2EcJuO/ybsJPKFKxXY0LK4G54
X-Google-Smtp-Source: APXvYqw7KfClP8SL65AqCCS1/nALL/cUk8vlg2o2VxH4LDsP9p1MBordH+gxH4Q/8d+71ltDn1xJjA==
X-Received: by 2002:a1c:f602:: with SMTP id w2mr8378409wmc.145.1569428029595;
        Wed, 25 Sep 2019 09:13:49 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id o70sm4991085wme.29.2019.09.25.09.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 09:13:48 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [RFC PATCH 02/18] crypto: x86/poly1305 - implement .update_from_sg method
Date:   Wed, 25 Sep 2019 18:12:39 +0200
Message-Id: <20190925161255.1871-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to reduce the number of invocations of the RFC7539 template
into the Poly1305 driver, implement the new internal .update_from_sg
method that allows the driver to amortize the cost of FPU preserve/
restore sequences over a larger chunk of input.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/poly1305_glue.c | 54 ++++++++++++++++----
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index 4a1c05dce950..f2afaa8e23c2 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -115,18 +115,11 @@ static unsigned int poly1305_simd_blocks(struct poly1305_desc_ctx *dctx,
 	return srclen;
 }
 
-static int poly1305_simd_update(struct shash_desc *desc,
-				const u8 *src, unsigned int srclen)
+static void poly1305_simd_do_update(struct shash_desc *desc,
+				    const u8 *src, unsigned int srclen)
 {
-	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 	unsigned int bytes;
 
-	/* kernel_fpu_begin/end is costly, use fallback for small updates */
-	if (srclen <= 288 || !crypto_simd_usable())
-		return crypto_poly1305_update(desc, src, srclen);
-
-	kernel_fpu_begin();
-
 	if (unlikely(dctx->buflen)) {
 		bytes = min(srclen, POLY1305_BLOCK_SIZE - dctx->buflen);
 		memcpy(dctx->buf + dctx->buflen, src, bytes);
@@ -147,12 +140,50 @@ static int poly1305_simd_update(struct shash_desc *desc,
 		srclen = bytes;
 	}
 
-	kernel_fpu_end();
-
 	if (unlikely(srclen)) {
 		dctx->buflen = srclen;
 		memcpy(dctx->buf, src, srclen);
 	}
+}
+
+static int poly1305_simd_update(struct shash_desc *desc,
+				const u8 *src, unsigned int srclen)
+{
+	/* kernel_fpu_begin/end is costly, use fallback for small updates */
+	if (srclen <= 288 || !crypto_simd_usable())
+		return crypto_poly1305_update(desc, src, srclen);
+
+	kernel_fpu_begin();
+	poly1305_simd_do_update(desc, src, srclen);
+	kernel_fpu_end();
+
+	return 0;
+}
+
+static int poly1305_simd_update_from_sg(struct shash_desc *desc,
+					struct scatterlist *sg,
+					unsigned int srclen,
+					int flags)
+{
+	bool do_simd = crypto_simd_usable() && srclen > 288;
+	struct crypto_hash_walk walk;
+	int nbytes;
+
+	if (do_simd) {
+		kernel_fpu_begin();
+		flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	}
+
+	for (nbytes = crypto_shash_walk_sg(desc, sg, srclen, &walk, flags);
+	     nbytes > 0;
+	     nbytes = crypto_hash_walk_done(&walk, 0)) {
+		if (do_simd)
+			poly1305_simd_do_update(desc, walk.data, nbytes);
+		else
+			crypto_poly1305_update(desc, walk.data, nbytes);
+	}
+	if (do_simd)
+		kernel_fpu_end();
 
 	return 0;
 }
@@ -161,6 +192,7 @@ static struct shash_alg alg = {
 	.digestsize	= POLY1305_DIGEST_SIZE,
 	.init		= poly1305_simd_init,
 	.update		= poly1305_simd_update,
+	.update_from_sg	= poly1305_simd_update_from_sg,
 	.final		= crypto_poly1305_final,
 	.descsize	= sizeof(struct poly1305_simd_desc_ctx),
 	.base		= {
-- 
2.20.1

