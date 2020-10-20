Return-Path: <SRS0=SXL7=D3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7CAC4363A
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 20:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E650522256
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 20:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438559AbgJTUkC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Oct 2020 16:40:02 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41472 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438557AbgJTUkC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Oct 2020 16:40:02 -0400
Received: by mail-qk1-f194.google.com with SMTP id b69so3100863qkg.8;
        Tue, 20 Oct 2020 13:40:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oRMf8eK1KvMjfAflD4Pf4h9XYH++ind//dYyDMVAMdw=;
        b=W6pPbOPEUGg0pRmE2oaHDqY3VKncBAopnMkqOSMAwa4xqUVtTNue08J069+J3vY6Xb
         WM2l0pAjdGuXsKOZfHWvvBPw5KCrx1u1UNX8d+46PVGDsPbrV4jYIaO0QqMQOHpp4jKe
         oPEB/Nz74vzTqocNseVkwxPSQNcio2fiSVxh/ImWwIduQQs0lIIJIugjFN1Eq0sAA/Wx
         ez+/JwVyn2iXips0SgEBVj5qZRq2UeA9mxNG7vKVrk0hBWtPi0iZ84v22iioTb0Aiv4N
         /m/jvS5m7nOLZTiwCuKR+DTlQJAEjcJJ0DeEi5ShST5iU3NpBj0j+i4YnJmW0eOLJ4sw
         Z4JA==
X-Gm-Message-State: AOAM533LaVLz41kBVkhnbXhT4AgT1hZ2gWrEh0nJfqBneF5eKlJeGfg8
        iMlrd8+55h6ubaGAVTL8vFc=
X-Google-Smtp-Source: ABdhPJz4tvqVqHLDMnlnleuvqD40m9l2fUpJCovASQvKnNfxaQXFPeJtjG24MU2UqPAT2ANEid6shA==
X-Received: by 2002:a05:620a:986:: with SMTP id x6mr72820qkx.434.1603226400783;
        Tue, 20 Oct 2020 13:40:00 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id m18sm1411165qkk.102.2020.10.20.13.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 13:39:59 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] crypto: Use memzero_explicit() for clearing state
Date:   Tue, 20 Oct 2020 16:39:52 -0400
Message-Id: <20201020203957.3512851-2-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020203957.3512851-1-nivedita@alum.mit.edu>
References: <20201020203957.3512851-1-nivedita@alum.mit.edu>
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
 include/crypto/sha1_base.h   | 3 ++-
 include/crypto/sha256_base.h | 3 ++-
 include/crypto/sha512_base.h | 3 ++-
 include/crypto/sm3_base.h    | 3 ++-
 lib/crypto/sha256.c          | 2 +-
 5 files changed, 9 insertions(+), 5 deletions(-)

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

