Return-Path: <SRS0=q4N3=V5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7D7C19759
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 04:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B91A206A3
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 04:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfHAEwE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Aug 2019 00:52:04 -0400
Received: from outbound.smtp.vt.edu ([198.82.183.121]:34213 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728770AbfHAEwD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Aug 2019 00:52:03 -0400
Received: from mr1.cc.vt.edu (junk.cc.ipv6.vt.edu [IPv6:2607:b400:92:9:0:9d:8fcb:4116])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id x714q2xT031952
        for <linux-crypto@vger.kernel.org>; Thu, 1 Aug 2019 00:52:02 -0400
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        by mr1.cc.vt.edu (8.14.7/8.14.7) with ESMTP id x714pvpS007047
        for <linux-crypto@vger.kernel.org>; Thu, 1 Aug 2019 00:52:02 -0400
Received: by mail-qt1-f198.google.com with SMTP id 41so57742644qtm.4
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jul 2019 21:52:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=CZzuDKWbKN1JTYir8Hgre+/x4pJE/cZrbW2sxcH/pD8=;
        b=HENNQq2HDWh5BIHEyF3TVviB3wf9sTeyHaXTTwSbYSPK4DnbPYroCSTpGFOCiR+n/1
         MOxijYrV/AfHl85KT2UtgLlRTgJYdQ2VWv/c/XmvEcDmyPWxYeV4e6KZeT4jWfLb59Ac
         qgwYb6XxRZ3dmmBh1PGs4xiAUs/T04079bwyX28mMbgO9KbNV2KC+d7QpGTifyxkWFnp
         OaP5LEXE2KL1fdfCAbaDl6dZ8c+tdl7x+6C3dQO/aOFOrCAncs51fq4gyt6OF235BBL4
         BXXDUFe8MY6o8lKwD5X9AcD5rhi8OXh4C+aJpwVg2pnGLX1i1viVMYcUKZeF57MHDaEC
         wXrQ==
X-Gm-Message-State: APjAAAWzi4GFCv5/hZnxgDNGj59gtomy/KkiuclwLpsvSwsOCjsbH7mw
        Qux4IZnyqHVyu8kPeGrATkimBCbDn3H39bouQdika6hSZJ4AIhzWPO6qbwHMbH2C1/9VrC2geoy
        KIzU9gbgY/rcXGNmkALxzAej46awbBiLtMQo=
X-Received: by 2002:a0c:8a76:: with SMTP id 51mr91296634qvu.210.1564635117013;
        Wed, 31 Jul 2019 21:51:57 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyZCZFPQt0JJB7U5BSL0tsH/+sb5gLek8gpvJd14zbTLTHzN9tKQrsvTS4Pz3p/0+WCwK/bUw==
X-Received: by 2002:a0c:8a76:: with SMTP id 51mr91296617qvu.210.1564635116699;
        Wed, 31 Jul 2019 21:51:56 -0700 (PDT)
Received: from turing-police ([2601:5c0:c001:4341::7ca])
        by smtp.gmail.com with ESMTPSA id m8sm31129350qti.97.2019.07.31.21.51.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 21:51:55 -0700 (PDT)
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] linux-next 20190731 - aegis128-core.c fails to build
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Thu, 01 Aug 2019 00:51:54 -0400
Message-ID: <13353.1564635114@turing-police>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The recent NEON SIMD patches break the build if CONFIG_CRYPTO_AEGIS128_SIMD isn't set:

  MODPOST 558 modules
ERROR: "crypto_aegis128_decrypt_chunk_simd" [crypto/aegis128.ko] undefined!
ERROR: "crypto_aegis128_update_simd" [crypto/aegis128.ko] undefined!
ERROR: "crypto_aegis128_encrypt_chunk_simd" [crypto/aegis128.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:105: modules-modpost] Error 1
make: *** [Makefile:1299: modules] Error 2

Add proper definitions and stubs to aegis.h so it builds both ways. This
necessitated moving other stuff from aegis128-core.c to aegis.h so things were
defined in the proper order.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
---
diff --git a/crypto/aegis.h b/crypto/aegis.h
index 4d56a85aea49..50a7496ca4ae 100644
--- a/crypto/aegis.h
+++ b/crypto/aegis.h
@@ -13,6 +13,11 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 
+#define AEGIS128_NONCE_SIZE 16
+#define AEGIS128_STATE_BLOCKS 5
+#define AEGIS128_KEY_SIZE 16
+#define AEGIS128_MIN_AUTH_SIZE 8
+#define AEGIS128_MAX_AUTH_SIZE 16
 #define AEGIS_BLOCK_SIZE 16
 
 union aegis_block {
@@ -21,6 +26,39 @@ union aegis_block {
 	u8 bytes[AEGIS_BLOCK_SIZE];
 };
 
+struct aegis_state {
+	union aegis_block blocks[AEGIS128_STATE_BLOCKS];
+};
+
+struct aegis_ctx {
+	union aegis_block key;
+};
+
+struct aegis128_ops {
+	int (*skcipher_walk_init)(struct skcipher_walk *walk,
+				  struct aead_request *req, bool atomic);
+
+	void (*crypt_chunk)(struct aegis_state *state, u8 *dst,
+			    const u8 *src, unsigned int size);
+};
+
+
+#ifdef CONFIG_CRYPTO_AEGIS128_SIMD
+bool crypto_aegis128_have_simd(void);
+void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg);
+void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
+					const u8 *src, unsigned int size);
+void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
+					const u8 *src, unsigned int size);
+#else
+static inline bool crypto_aegis128_have_simd(void) { return false; }
+static inline void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg) { }
+static inline void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
+					const u8 *src, unsigned int size) { }
+static inline void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
+					const u8 *src, unsigned int size) { }
+#endif
+
 #define AEGIS_BLOCK_ALIGN (__alignof__(union aegis_block))
 #define AEGIS_ALIGNED(p) IS_ALIGNED((uintptr_t)p, AEGIS_BLOCK_ALIGN)
 
diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index f815b4685156..8b738128a921 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -20,37 +20,8 @@
 
 #include "aegis.h"
 
-#define AEGIS128_NONCE_SIZE 16
-#define AEGIS128_STATE_BLOCKS 5
-#define AEGIS128_KEY_SIZE 16
-#define AEGIS128_MIN_AUTH_SIZE 8
-#define AEGIS128_MAX_AUTH_SIZE 16
-
-struct aegis_state {
-	union aegis_block blocks[AEGIS128_STATE_BLOCKS];
-};
-
-struct aegis_ctx {
-	union aegis_block key;
-};
-
-struct aegis128_ops {
-	int (*skcipher_walk_init)(struct skcipher_walk *walk,
-				  struct aead_request *req, bool atomic);
-
-	void (*crypt_chunk)(struct aegis_state *state, u8 *dst,
-			    const u8 *src, unsigned int size);
-};
-
 static bool have_simd;
 
-bool crypto_aegis128_have_simd(void);
-void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg);
-void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
-					const u8 *src, unsigned int size);
-void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
-					const u8 *src, unsigned int size);
-
 static void crypto_aegis128_update(struct aegis_state *state)
 {
 	union aegis_block tmp;

