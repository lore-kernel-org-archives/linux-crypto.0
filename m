Return-Path: <SRS0=juaY=D6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA723C388F9
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 19:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60EAF206DC
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 19:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754141AbgJWTWI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Oct 2020 15:22:08 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44540 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbgJWTWH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Oct 2020 15:22:07 -0400
Received: by mail-qt1-f195.google.com with SMTP id m65so1815195qte.11;
        Fri, 23 Oct 2020 12:22:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WaiSZM/zHLv+SM8aG+Xi49iKWwDUu00ZSVCNFd+ZJGs=;
        b=Z/Ydp5l/AvCHjWW1VKrtutnIQLhW7PIL2RaC0pc1yU9u+uGymeYowGFBwtNhKGy7Rx
         m4s3ZUjmUalVexVhsG6eWGiQli/IvhBVMsZxkVlfY0AtReqggVog3+B0dV/VD8pbFNuG
         cD+LoE+DewMhcXeJBBpqqTC+AHE3UoUr/N/BRPSAaiHuPUsdkyxp3kZsEgvXiPAJL01Z
         hBTPkwl8RflQLs+fcQFfXwV61ZH60kU+KIRkYsBQmTLymCpQLVkrVZcPs/OFgqT+YuDr
         BlGhJDGI/kfjAEf7Ug6EX5IZxvNCa4aTIjo3A2FfPAswCAPZPTWPZ3eblm09uD6LHleu
         GvWA==
X-Gm-Message-State: AOAM5302P/1yuR9/PFMTPNMH1Z9+3h8ryO/I146MBXUomVBCyHmfse08
        PnpFKODMBLrUiLLlJ5RTCUKwvmneFXpNgA==
X-Google-Smtp-Source: ABdhPJytdwI+3HmIDdQi7x7r8HKnTSFaLNhqau7lJt0ZB5UiXnBLv+RF4MalVjpqB3HF1pY7R+M1gQ==
X-Received: by 2002:ac8:58ce:: with SMTP id u14mr3720555qta.56.1603480925844;
        Fri, 23 Oct 2020 12:22:05 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id n199sm1398493qkn.77.2020.10.23.12.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 12:22:05 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        David Laight <David.Laight@aculab.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/5] crypto: Use memzero_explicit() for clearing state
Date:   Fri, 23 Oct 2020 15:21:59 -0400
Message-Id: <20201023192203.400040-2-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023192203.400040-1-nivedita@alum.mit.edu>
References: <20201023192203.400040-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Without the barrier_data() inside memzero_explicit(), the compiler may
optimize away the state-clearing if it can tell that the state is not
used afterwards. At least in lib/crypto/sha256.c:__sha256_final(), the
function can get inlined into sha256(), in which case the memset is
optimized away.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
---
 arch/arm64/crypto/ghash-ce-glue.c | 2 +-
 arch/arm64/crypto/poly1305-glue.c | 2 +-
 arch/arm64/crypto/sha3-ce-glue.c  | 2 +-
 arch/x86/crypto/poly1305_glue.c   | 2 +-
 include/crypto/sha1_base.h        | 3 ++-
 include/crypto/sha256_base.h      | 3 ++-
 include/crypto/sha512_base.h      | 3 ++-
 include/crypto/sm3_base.h         | 3 ++-
 lib/crypto/sha256.c               | 2 +-
 9 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 8536008e3e35..2427e2f3a9a1 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -168,7 +168,7 @@ static int ghash_final(struct shash_desc *desc, u8 *dst)
 	put_unaligned_be64(ctx->digest[1], dst);
 	put_unaligned_be64(ctx->digest[0], dst + 8);
 
-	*ctx = (struct ghash_desc_ctx){};
+	memzero_explicit(ctx, sizeof(*ctx));
 	return 0;
 }
 
diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
index f33ada70c4ed..683de671741a 100644
--- a/arch/arm64/crypto/poly1305-glue.c
+++ b/arch/arm64/crypto/poly1305-glue.c
@@ -177,7 +177,7 @@ void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 	}
 
 	poly1305_emit(&dctx->h, dst, dctx->s);
-	*dctx = (struct poly1305_desc_ctx){};
+	memzero_explicit(dctx, sizeof(*dctx));
 }
 EXPORT_SYMBOL(poly1305_final_arch);
 
diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
index 9a4bbfc45f40..e5a2936f0886 100644
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ b/arch/arm64/crypto/sha3-ce-glue.c
@@ -94,7 +94,7 @@ static int sha3_final(struct shash_desc *desc, u8 *out)
 	if (digest_size & 4)
 		put_unaligned_le32(sctx->st[i], (__le32 *)digest);
 
-	*sctx = (struct sha3_state){};
+	memzero_explicit(sctx, sizeof(*sctx));
 	return 0;
 }
 
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index e508dbd91813..64d09520d279 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -209,7 +209,7 @@ void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
 	}
 
 	poly1305_simd_emit(&dctx->h, dst, dctx->s);
-	*dctx = (struct poly1305_desc_ctx){};
+	memzero_explicit(dctx, sizeof(*dctx));
 }
 EXPORT_SYMBOL(poly1305_final_arch);
 
diff --git a/include/crypto/sha1_base.h b/include/crypto/sha1_base.h
index 20fd1f7468af..a5d6033efef7 100644
--- a/include/crypto/sha1_base.h
+++ b/include/crypto/sha1_base.h
@@ -12,6 +12,7 @@
 #include <crypto/sha.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
+#include <linux/string.h>
 
 #include <asm/unaligned.h>
 
@@ -101,7 +102,7 @@ static inline int sha1_base_finish(struct shash_desc *desc, u8 *out)
 	for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(__be32); i++)
 		put_unaligned_be32(sctx->state[i], digest++);
 
-	*sctx = (struct sha1_state){};
+	memzero_explicit(sctx, sizeof(*sctx));
 	return 0;
 }
 
diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
index 6ded110783ae..93f9fd21cc06 100644
--- a/include/crypto/sha256_base.h
+++ b/include/crypto/sha256_base.h
@@ -12,6 +12,7 @@
 #include <crypto/sha.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
+#include <linux/string.h>
 
 #include <asm/unaligned.h>
 
@@ -105,7 +106,7 @@ static inline int sha256_base_finish(struct shash_desc *desc, u8 *out)
 	for (i = 0; digest_size > 0; i++, digest_size -= sizeof(__be32))
 		put_unaligned_be32(sctx->state[i], digest++);
 
-	*sctx = (struct sha256_state){};
+	memzero_explicit(sctx, sizeof(*sctx));
 	return 0;
 }
 
diff --git a/include/crypto/sha512_base.h b/include/crypto/sha512_base.h
index fb19c77494dc..93ab73baa38e 100644
--- a/include/crypto/sha512_base.h
+++ b/include/crypto/sha512_base.h
@@ -12,6 +12,7 @@
 #include <crypto/sha.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
+#include <linux/string.h>
 
 #include <asm/unaligned.h>
 
@@ -126,7 +127,7 @@ static inline int sha512_base_finish(struct shash_desc *desc, u8 *out)
 	for (i = 0; digest_size > 0; i++, digest_size -= sizeof(__be64))
 		put_unaligned_be64(sctx->state[i], digest++);
 
-	*sctx = (struct sha512_state){};
+	memzero_explicit(sctx, sizeof(*sctx));
 	return 0;
 }
 
diff --git a/include/crypto/sm3_base.h b/include/crypto/sm3_base.h
index 1cbf9aa1fe52..2f3a32ab97bb 100644
--- a/include/crypto/sm3_base.h
+++ b/include/crypto/sm3_base.h
@@ -13,6 +13,7 @@
 #include <crypto/sm3.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
+#include <linux/string.h>
 #include <asm/unaligned.h>
 
 typedef void (sm3_block_fn)(struct sm3_state *sst, u8 const *src, int blocks);
@@ -104,7 +105,7 @@ static inline int sm3_base_finish(struct shash_desc *desc, u8 *out)
 	for (i = 0; i < SM3_DIGEST_SIZE / sizeof(__be32); i++)
 		put_unaligned_be32(sctx->state[i], digest++);
 
-	*sctx = (struct sm3_state){};
+	memzero_explicit(sctx, sizeof(*sctx));
 	return 0;
 }
 
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 2321f6cb322f..d43bc39ab05e 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -265,7 +265,7 @@ static void __sha256_final(struct sha256_state *sctx, u8 *out, int digest_words)
 		put_unaligned_be32(sctx->state[i], &dst[i]);
 
 	/* Zeroize sensitive information. */
-	memset(sctx, 0, sizeof(*sctx));
+	memzero_explicit(sctx, sizeof(*sctx));
 }
 
 void sha256_final(struct sha256_state *sctx, u8 *out)
-- 
2.26.2

