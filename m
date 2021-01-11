Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D5AC433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C92AB2250F
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389094AbhAKQxh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:53:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728911AbhAKQxf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 11:53:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF74122AAD;
        Mon, 11 Jan 2021 16:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610383975;
        bh=FJmpS5/x409gUNG+5LuompKBu98uDrt0lWpADeOtLqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBs4Sot7qg5OJcFDWlt21fNAQn/usBhOuLsUj0f7sCBmDpqBIUO+BH7GbPgHcgDzl
         k5VFchotKiRyp4o1hq1cGBYz/gOSOpOdkoTkUT3Ku5LxxyPqB0ix3blmnua3UplDyE
         Wky88jCZho4R7ku6hyjiJuAAUtuKw3XSyA3FDwzEOa3se1D9tUkI2J6SH1F/pFA03t
         9HaDmboHjNicPqw07uWIzWNcq+tNlXWHQ7l01QSysfMrUAcmUCLH45qDjn7v8veztP
         qC7xRC4bqL8svQLRYdn1MxyP4Enxvt/kjHRmH+kCLqbXTro84B0SWPIs99JcxDok+R
         CjXTS+ZEYCARw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/7] crypto: lib/crc-t10dif - add static call support for optimized versions
Date:   Mon, 11 Jan 2021 17:52:32 +0100
Message-Id: <20210111165237.18178-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111165237.18178-1-ardb@kernel.org>
References: <20210111165237.18178-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Wire up the new static call facility to the CRC-T10DIF library code, so
that optimized implementations can be swapped in easily, without having
to rely on the complexity of the crypto API shash infrastructure.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/crc-t10dif.h | 21 ++++++++++++--
 lib/crc-t10dif.c           | 30 +++++++++++++++-----
 2 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
index 6bb0c0bf357b..ad8b0a358680 100644
--- a/include/linux/crc-t10dif.h
+++ b/include/linux/crc-t10dif.h
@@ -3,6 +3,7 @@
 #define _LINUX_CRC_T10DIF_H
 
 #include <linux/types.h>
+#include <linux/static_call.h>
 
 #define CRC_T10DIF_DIGEST_SIZE 2
 #define CRC_T10DIF_BLOCK_SIZE 1
@@ -10,7 +11,23 @@
 
 extern __u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer,
 				size_t len);
-extern __u16 crc_t10dif(unsigned char const *, size_t);
-extern __u16 crc_t10dif_update(__u16 crc, unsigned char const *, size_t);
+
+DECLARE_STATIC_CALL(crc_t10dif_arch, crc_t10dif_generic);
+
+static inline __u16 crc_t10dif_update(__u16 crc, unsigned char const *buffer,
+				      size_t len)
+{
+	return static_call(crc_t10dif_arch)(crc, buffer, len);
+}
+
+static inline __u16 crc_t10dif(unsigned char const *buffer, size_t len)
+{
+	return crc_t10dif_update(0, buffer, len);
+}
+
+int crc_t10dif_register(__u16 (*)(__u16, const unsigned char *, size_t),
+			const char *name);
+
+int crc_t10dif_unregister(void);
 
 #endif
diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index cbb739f0a0d7..b657cdfb118a 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -18,6 +18,11 @@
 #include <linux/static_key.h>
 #include <linux/notifier.h>
 
+DEFINE_STATIC_CALL(crc_t10dif_arch, crc_t10dif_generic);
+EXPORT_STATIC_CALL(crc_t10dif_arch);
+
+static char const *crc_t10dif_arch_name;
+
 /* Table generated using the following polynomium:
  * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
  * gt: 0x8bb7
@@ -68,21 +73,32 @@ __u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer, size_t len)
 }
 EXPORT_SYMBOL(crc_t10dif_generic);
 
-__u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
+int crc_t10dif_register(__u16 (*func)(__u16, const unsigned char *, size_t),
+			const char *name)
 {
-	return crc_t10dif_generic(crc, buffer, len);
+	if (!name || cmpxchg(&crc_t10dif_arch_name, NULL, name) != NULL)
+		return -EBUSY;
+
+	static_call_update(crc_t10dif_arch, func);
+	return 0;
 }
-EXPORT_SYMBOL(crc_t10dif_update);
+EXPORT_SYMBOL_NS(crc_t10dif_register, CRYPTO_INTERNAL);
 
-__u16 crc_t10dif(const unsigned char *buffer, size_t len)
+int crc_t10dif_unregister(void)
 {
-	return crc_t10dif_update(0, buffer, len);
+	// revert to generic implementation
+	static_call_update(crc_t10dif_arch, crc_t10dif_generic);
+	crc_t10dif_arch_name = NULL;
+
+	// wait for all potential callers of the unregistered routine to finish
+	synchronize_rcu_tasks();
+	return 0;
 }
-EXPORT_SYMBOL(crc_t10dif);
+EXPORT_SYMBOL_NS(crc_t10dif_unregister, CRYPTO_INTERNAL);
 
 static int crc_t10dif_transform_show(char *buffer, const struct kernel_param *kp)
 {
-	return sprintf(buffer, "fallback\n");
+	return sprintf(buffer, "%s\n", crc_t10dif_arch_name ?: "fallback");
 }
 
 module_param_call(transform, NULL, crc_t10dif_transform_show, NULL, 0444);
-- 
2.17.1

