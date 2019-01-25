Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3E1C282C2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 09:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ABA321855
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 09:36:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="a1O8FZXP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfAYJgh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 04:36:37 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35497 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfAYJgh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 04:36:37 -0500
Received: by mail-wm1-f66.google.com with SMTP id t200so6002166wmt.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jan 2019 01:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pHeXQyjHBGPZ2p98q1m4Ogx2QHTHJsPCH+kq0wtIQtM=;
        b=a1O8FZXPbRSdLVvC+7SFfRYY57XdY8Bns4xivd2uaq2ijEzntpWiiG0LV9zF3oXew8
         Q7p9mE8EEOaxKjBWigr8x12ITPZUa+hrdzO5mtHaFfeMae3XFZQ9VpdPwxF0QqrspM5/
         0ESVJjKZ1JAUhzV5qFFT4/HtrsEnBTXdxwchA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pHeXQyjHBGPZ2p98q1m4Ogx2QHTHJsPCH+kq0wtIQtM=;
        b=qbql5E7Pe216dbmQciwcEVhvX2H80MO6GmA/EpNXVvv9cBk1mGBZp1caZ0+MLlegXD
         R1IqGn/Iskh1Vt3WCZXx6yQF7X6uDxGWIZA5etypBZcZWgFCp6Y5ELI7Dpiy+eCOMnx6
         eHxL+mfu+Lk8DrktL0gvpNf6Y/y1qvFPxKykr4qiwkrPvRIKCDlKsDixrc17WORaMo3i
         BeVextW1fJzpdb0BUXUOi+m7O4XvGzGOvBESxBT5QIRc9IjR4F+3AvkVAlPti8gq9sWz
         +abwfHrJ740qVSF3NSZIECAReDfSOcOvBPVXeYGaKfLQbLVW45Aw64j62jEGq4jEiiBU
         I/dA==
X-Gm-Message-State: AJcUukepovySLJyabOQbmRuxQGFDWSuqFra48PKD0+E4jos9VR0G05H0
        XzNMqqKoEfZNZvtna9rjKIoddhs42OqG5g==
X-Google-Smtp-Source: ALg8bN7W8XiSBbwCNA0YbcWWYpuG1/JArKsEjClX/FcQwW/WzhBYTiNez80ufkQM/QhL2mn3mAcwrg==
X-Received: by 2002:a1c:1383:: with SMTP id 125mr6346548wmt.71.1548408994700;
        Fri, 25 Jan 2019 01:36:34 -0800 (PST)
Received: from dogfood.home ([2a01:cb1d:112:6f00:bcd4:806e:230a:673e])
        by smtp.gmail.com with ESMTPSA id w80sm92323955wme.38.2019.01.25.01.36.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jan 2019 01:36:33 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: arm64/crct10dif - register PMULL variants as separate algos
Date:   Fri, 25 Jan 2019 10:36:26 +0100
Message-Id: <20190125093627.14288-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190125093627.14288-1-ard.biesheuvel@linaro.org>
References: <20190125093627.14288-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The arm64 CRC-T10DIF implementation either uses 8-bit or 64-bit
polynomial multiplication instructions, since the latter are
faster but not mandatory in the architecture.

Since that prevents us from testing both implementations on the
same system, let's expose both implementations to the crypto API,
with the priorities reflecting that the P64 version is the
preferred one if available.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crct10dif-ce-glue.c | 54 +++++++++++++++-----
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index 567c24f3d224..242757cc6da9 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -25,8 +25,6 @@
 asmlinkage u16 crc_t10dif_pmull_p64(u16 init_crc, const u8 buf[], u64 len);
 asmlinkage u16 crc_t10dif_pmull_p8(u16 init_crc, const u8 buf[], u64 len);
 
-static u16 (*crc_t10dif_pmull)(u16 init_crc, const u8 buf[], u64 len);
-
 static int crct10dif_init(struct shash_desc *desc)
 {
 	u16 *crc = shash_desc_ctx(desc);
@@ -35,14 +33,30 @@ static int crct10dif_init(struct shash_desc *desc)
 	return 0;
 }
 
-static int crct10dif_update(struct shash_desc *desc, const u8 *data,
+static int crct10dif_update_pmull_p8(struct shash_desc *desc, const u8 *data,
+			    unsigned int length)
+{
+	u16 *crc = shash_desc_ctx(desc);
+
+	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && may_use_simd()) {
+		kernel_neon_begin();
+		*crc = crc_t10dif_pmull_p8(*crc, data, length);
+		kernel_neon_end();
+	} else {
+		*crc = crc_t10dif_generic(*crc, data, length);
+	}
+
+	return 0;
+}
+
+static int crct10dif_update_pmull_p64(struct shash_desc *desc, const u8 *data,
 			    unsigned int length)
 {
 	u16 *crc = shash_desc_ctx(desc);
 
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && may_use_simd()) {
 		kernel_neon_begin();
-		*crc = crc_t10dif_pmull(*crc, data, length);
+		*crc = crc_t10dif_pmull_p64(*crc, data, length);
 		kernel_neon_end();
 	} else {
 		*crc = crc_t10dif_generic(*crc, data, length);
@@ -59,10 +73,22 @@ static int crct10dif_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
-static struct shash_alg crc_t10dif_alg = {
+static struct shash_alg crc_t10dif_alg[] = {{
 	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
 	.init			= crct10dif_init,
-	.update			= crct10dif_update,
+	.update			= crct10dif_update_pmull_p8,
+	.final			= crct10dif_final,
+	.descsize		= CRC_T10DIF_DIGEST_SIZE,
+
+	.base.cra_name		= "crct10dif",
+	.base.cra_driver_name	= "crct10dif-arm64-neon",
+	.base.cra_priority	= 100,
+	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}, {
+	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
+	.init			= crct10dif_init,
+	.update			= crct10dif_update_pmull_p64,
 	.final			= crct10dif_final,
 	.descsize		= CRC_T10DIF_DIGEST_SIZE,
 
@@ -71,21 +97,25 @@ static struct shash_alg crc_t10dif_alg = {
 	.base.cra_priority	= 200,
 	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
-};
+}};
 
 static int __init crc_t10dif_mod_init(void)
 {
 	if (elf_hwcap & HWCAP_PMULL)
-		crc_t10dif_pmull = crc_t10dif_pmull_p64;
+		return crypto_register_shashes(crc_t10dif_alg,
+					       ARRAY_SIZE(crc_t10dif_alg));
 	else
-		crc_t10dif_pmull = crc_t10dif_pmull_p8;
-
-	return crypto_register_shash(&crc_t10dif_alg);
+		/* only register the first array element */
+		return crypto_register_shash(crc_t10dif_alg);
 }
 
 static void __exit crc_t10dif_mod_exit(void)
 {
-	crypto_unregister_shash(&crc_t10dif_alg);
+	if (elf_hwcap & HWCAP_PMULL)
+		crypto_unregister_shashes(crc_t10dif_alg,
+					  ARRAY_SIZE(crc_t10dif_alg));
+	else
+		crypto_unregister_shash(crc_t10dif_alg);
 }
 
 module_cpu_feature_match(ASIMD, crc_t10dif_mod_init);
-- 
2.17.1

