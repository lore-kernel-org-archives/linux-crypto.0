Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09DE0C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3379207D2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgLWIOQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:14:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbgLWIOP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 03:14:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA16B224D4;
        Wed, 23 Dec 2020 08:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608711176;
        bh=q4F9axpwjHT+hZCneYUehP2waWRDVZo8NQHm18Rvv8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRgb0YHY7nLLWkRGRYheVHAwG0hkbfuZl72KhzElKOFinUleUQ4wTPZULrx1EOiS/
         91+jd1LkKsWFcRWBQ6tw0Nu+k42lFGIkiCcMuuopKoNLR+ukNCuyykggGUqGbB/FeE
         VF38QzIeILBMrE3hoJ6k1oMOLz75rn9WPCm0xM0TMtmCVEb1nGNGvUOW+h2FSqs+yX
         LMKs71l1HfIu2jxyJc8b81qEWoHSHbVJax1NGm4Z1yalmGhd9ej3Zd7R7FXqilYTUj
         +wVRwMdfL4Q+1oe/05+qbxglVphIa86kPAeP4w7yY+2d9xeK5CYXCnDtJDL/D9eWYB
         NVfRIEmJURd2Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v3 08/14] crypto: blake2s - adjust include guard naming
Date:   Wed, 23 Dec 2020 00:09:57 -0800
Message-Id: <20201223081003.373663-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223081003.373663-1-ebiggers@kernel.org>
References: <20201223081003.373663-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Use the full path in the include guards for the BLAKE2s headers to avoid
ambiguity and to match the convention for most files in include/crypto/.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/blake2s.h          | 6 +++---
 include/crypto/internal/blake2s.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/crypto/blake2s.h b/include/crypto/blake2s.h
index f1c8330a61a91..3f06183c2d804 100644
--- a/include/crypto/blake2s.h
+++ b/include/crypto/blake2s.h
@@ -3,8 +3,8 @@
  * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
-#ifndef BLAKE2S_H
-#define BLAKE2S_H
+#ifndef _CRYPTO_BLAKE2S_H
+#define _CRYPTO_BLAKE2S_H
 
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -105,4 +105,4 @@ static inline void blake2s(u8 *out, const u8 *in, const u8 *key,
 void blake2s256_hmac(u8 *out, const u8 *in, const u8 *key, const size_t inlen,
 		     const size_t keylen);
 
-#endif /* BLAKE2S_H */
+#endif /* _CRYPTO_BLAKE2S_H */
diff --git a/include/crypto/internal/blake2s.h b/include/crypto/internal/blake2s.h
index 867ef3753f5c1..8e50d487500f2 100644
--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -4,8 +4,8 @@
  * Keep this in sync with the corresponding BLAKE2b header.
  */
 
-#ifndef BLAKE2S_INTERNAL_H
-#define BLAKE2S_INTERNAL_H
+#ifndef _CRYPTO_INTERNAL_BLAKE2S_H
+#define _CRYPTO_INTERNAL_BLAKE2S_H
 
 #include <crypto/blake2s.h>
 #include <crypto/internal/hash.h>
@@ -116,4 +116,4 @@ static inline int crypto_blake2s_final(struct shash_desc *desc, u8 *out,
 	return 0;
 }
 
-#endif /* BLAKE2S_INTERNAL_H */
+#endif /* _CRYPTO_INTERNAL_BLAKE2S_H */
-- 
2.29.2

