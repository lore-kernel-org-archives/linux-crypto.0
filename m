Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AEADCD68EE
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Oct 2023 06:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442161AbjJJGAT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Oct 2023 02:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442194AbjJJGAQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2023 02:00:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05506B4
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 23:00:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85176C433CB
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 06:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696917613;
        bh=bDLgZBam5w4ilzHISXwNsTofurMK7QkqJggeXhLzNuU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ama8bXXpPGX2Lx2k/EQ1hEab4l70pg25dktoq8ZJzC69akzejlXiKw54tnkwIOr6w
         rL8wSGJBpIt9fuVwtq59+fe+5oT4C05XO3k+m3EiRJmnHdO+XHtfY64rBR3kJyheag
         B6EXd0wDY94Y1GL0hZjhqVE9QD/FCQJn+oJ9zq3Wej3MhkbbF7oC5ib5DQUvaWiXZV
         HzEbLMF4m2Y7gcgY0fBt/oVJo6dOAKKKN1JBFNPzNM47d2LuRpwyobj3HYSUiDuw+X
         Beox1j+f/QQ4/yidULdnJQdUUV2RkbVrPoKK+lOiy5xUkLm4p9OSlDfLjlZ0tmA9wh
         pTZObyTWr6/lA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 4/4] crypto: x86/nhpoly1305 - implement ->digest
Date:   Mon,  9 Oct 2023 22:59:46 -0700
Message-ID: <20231010055946.263981-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231010055946.263981-1-ebiggers@kernel.org>
References: <20231010055946.263981-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Implement the ->digest method to improve performance on single-page
messages by reducing the number of indirect calls.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/nhpoly1305-avx2-glue.c | 9 +++++++++
 arch/x86/crypto/nhpoly1305-sse2-glue.c | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/crypto/nhpoly1305-avx2-glue.c b/arch/x86/crypto/nhpoly1305-avx2-glue.c
index 46b036204ed91..c3a872f4d6a77 100644
--- a/arch/x86/crypto/nhpoly1305-avx2-glue.c
+++ b/arch/x86/crypto/nhpoly1305-avx2-glue.c
@@ -27,30 +27,39 @@ static int nhpoly1305_avx2_update(struct shash_desc *desc,
 
 		kernel_fpu_begin();
 		crypto_nhpoly1305_update_helper(desc, src, n, nh_avx2);
 		kernel_fpu_end();
 		src += n;
 		srclen -= n;
 	} while (srclen);
 	return 0;
 }
 
+static int nhpoly1305_avx2_digest(struct shash_desc *desc,
+				  const u8 *src, unsigned int srclen, u8 *out)
+{
+	return crypto_nhpoly1305_init(desc) ?:
+	       nhpoly1305_avx2_update(desc, src, srclen) ?:
+	       crypto_nhpoly1305_final(desc, out);
+}
+
 static struct shash_alg nhpoly1305_alg = {
 	.base.cra_name		= "nhpoly1305",
 	.base.cra_driver_name	= "nhpoly1305-avx2",
 	.base.cra_priority	= 300,
 	.base.cra_ctxsize	= sizeof(struct nhpoly1305_key),
 	.base.cra_module	= THIS_MODULE,
 	.digestsize		= POLY1305_DIGEST_SIZE,
 	.init			= crypto_nhpoly1305_init,
 	.update			= nhpoly1305_avx2_update,
 	.final			= crypto_nhpoly1305_final,
+	.digest			= nhpoly1305_avx2_digest,
 	.setkey			= crypto_nhpoly1305_setkey,
 	.descsize		= sizeof(struct nhpoly1305_state),
 };
 
 static int __init nhpoly1305_mod_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_AVX2) ||
 	    !boot_cpu_has(X86_FEATURE_OSXSAVE))
 		return -ENODEV;
 
diff --git a/arch/x86/crypto/nhpoly1305-sse2-glue.c b/arch/x86/crypto/nhpoly1305-sse2-glue.c
index 4a4970d751076..a268a8439a5c9 100644
--- a/arch/x86/crypto/nhpoly1305-sse2-glue.c
+++ b/arch/x86/crypto/nhpoly1305-sse2-glue.c
@@ -27,30 +27,39 @@ static int nhpoly1305_sse2_update(struct shash_desc *desc,
 
 		kernel_fpu_begin();
 		crypto_nhpoly1305_update_helper(desc, src, n, nh_sse2);
 		kernel_fpu_end();
 		src += n;
 		srclen -= n;
 	} while (srclen);
 	return 0;
 }
 
+static int nhpoly1305_sse2_digest(struct shash_desc *desc,
+				  const u8 *src, unsigned int srclen, u8 *out)
+{
+	return crypto_nhpoly1305_init(desc) ?:
+	       nhpoly1305_sse2_update(desc, src, srclen) ?:
+	       crypto_nhpoly1305_final(desc, out);
+}
+
 static struct shash_alg nhpoly1305_alg = {
 	.base.cra_name		= "nhpoly1305",
 	.base.cra_driver_name	= "nhpoly1305-sse2",
 	.base.cra_priority	= 200,
 	.base.cra_ctxsize	= sizeof(struct nhpoly1305_key),
 	.base.cra_module	= THIS_MODULE,
 	.digestsize		= POLY1305_DIGEST_SIZE,
 	.init			= crypto_nhpoly1305_init,
 	.update			= nhpoly1305_sse2_update,
 	.final			= crypto_nhpoly1305_final,
+	.digest			= nhpoly1305_sse2_digest,
 	.setkey			= crypto_nhpoly1305_setkey,
 	.descsize		= sizeof(struct nhpoly1305_state),
 };
 
 static int __init nhpoly1305_mod_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_XMM2))
 		return -ENODEV;
 
 	return crypto_register_shash(&nhpoly1305_alg);
-- 
2.42.0

