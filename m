Return-Path: <SRS0=7/wf=D2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87264C43457
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 15:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 354E92236F
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 15:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgJSPaV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Oct 2020 11:30:21 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41545 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729075AbgJSPaU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Oct 2020 11:30:20 -0400
Received: by mail-io1-f68.google.com with SMTP id 67so41872iob.8;
        Mon, 19 Oct 2020 08:30:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oRMf8eK1KvMjfAflD4Pf4h9XYH++ind//dYyDMVAMdw=;
        b=UOmzfKM0wvNbMOBoA/La7t0l9tA75WQNjMZ7qYtZ2vFV/S2MO8tYdwTm2Z1Qk9aTrw
         Umh5cdZToscvtHrSBsnkW3wSUZwoKLXv+OTQWeHlpNRIB3hFxcNEPomo2O5nKy9jirv9
         bPm1MEWLCeBIWq7TnC1Hh4ApZpLVh+GvckbsU1KKEF3dAJCJR/j9ZBAVE/pZAvPXjwQE
         GKbKcXE17SksdcNXo/B4Gtn10OnOylN4LeEQfDIOo8s41OWyImdun2MNn9iajZX4nW2O
         qzwpfehpImKzVOtbfHTqQw6V0ESJRprrzY7+ibRioc2SwQzX4WJStZk/aYOtIgwYk62V
         6PGg==
X-Gm-Message-State: AOAM532URCCzrAoD2JmdZqU06vL3wwnqqR21yMF1dnovBwuv6Comm0HO
        CfObSiFffK29GSrDi/zeeY4=
X-Google-Smtp-Source: ABdhPJwmisNlApvWTi/B8O58P9BhXFSvUiIK7retzl0s8xclNOToTf4xuf+A7lT0x/xcbNBGT+jZRA==
X-Received: by 2002:a5d:8908:: with SMTP id b8mr3749227ion.96.1603121419444;
        Mon, 19 Oct 2020 08:30:19 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id m86sm20898ilb.44.2020.10.19.08.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 08:30:18 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] crypto: Use memzero_explicit() for clearing state
Date:   Mon, 19 Oct 2020 11:30:12 -0400
Message-Id: <20201019153016.2698303-2-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201019153016.2698303-1-nivedita@alum.mit.edu>
References: <20201019153016.2698303-1-nivedita@alum.mit.edu>
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

