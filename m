Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F67C282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 16:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 514B72184C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 16:33:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="UyjWTiTn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfAXQd5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:33:57 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35108 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfAXQd5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 11:33:57 -0500
Received: by mail-wm1-f65.google.com with SMTP id t200so3789901wmt.0
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 08:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RPyzbyLlh3W2c/h1LkXMkKRinYA35oe3Ivdo9s+NBuM=;
        b=UyjWTiTnHAfLcBttuKjyCyxxh4Aa8zetJMxMInnaRfr1zO2W4PYmohLJUgHs2XjRYt
         m7nZWUTZoxtpGje/ovujA90qpv32Ks1ViRUam9BPzWF3ib7NlMXjJDfg2nmcz89V9arh
         C9j8sZlv94rFmsX8+eE17hc0RYJWlCIEmC38w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RPyzbyLlh3W2c/h1LkXMkKRinYA35oe3Ivdo9s+NBuM=;
        b=o2XMWrVJpnBUXxLW1AaAHI93+BimTsWsAzmnmvsEHgvrfVYGbeTFZJR8OEi/duni27
         Tx65B4LEdChTQAn73BoMyjP16Dyzcyw0Nx9itgbM00S8cvpuhvXtxdKUz/H3tWrHYfZ2
         0C5XFMtXH0aknnmMs/Y47tHp25r/ISEexlzOtfouZedg1pqByLZ5sfQ2Dad9wZijODiP
         hPu6l4Godrm6FUKJ0XzoEEwMf81YGP8pf+r68FNocv2HaYmf7setweSuY3gzEXhI4clG
         CjwixWzjr9KaAfQXx4jkZ2IDA24/ZYo25u3dwSS7qulrLszPd+1RvTcKaqLQxHPIZQDT
         b2dQ==
X-Gm-Message-State: AJcUukfuqgztDdynOzySWVodvkimloiaC2sHMvulDQA6ZVEjei+OwHcw
        rKVFqr5qoQ6rUVo01R7fE3HjNqzftCfMIw==
X-Google-Smtp-Source: ALg8bN7b0oDEsLhAb/6R7oIs7r3b+HpW9o8u7DH59EbEb2kakzdaoDDWsiCNQhVjvMZNuGu2EUnvTg==
X-Received: by 2002:a1c:be11:: with SMTP id o17mr3282887wmf.111.1548347635155;
        Thu, 24 Jan 2019 08:33:55 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id t12sm99629069wrr.65.2019.01.24.08.33.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 08:33:54 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/3] crypto: arm64/aes-ccm - don't use an atomic walk needlessly
Date:   Thu, 24 Jan 2019 17:33:47 +0100
Message-Id: <20190124163347.12653-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190124163347.12653-1-ard.biesheuvel@linaro.org>
References: <20190124163347.12653-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When the AES-CCM code was first added, the NEON register were saved
and restored eagerly, and so the code avoided doing so, and executed
the scatterwalk in atomic context inside the kernel_neon_begin/end
section.

This has been changed in the meantime, so switch to non-atomic
scatterwalks.

Fixes: bd2ad885e30d ("crypto: arm64/aes-ce-ccm - move kernel mode neon ...")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 986191e8c058..5fc6f51908fd 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -253,7 +253,7 @@ static int ccm_encrypt(struct aead_request *req)
 	/* preserve the original iv for the final round */
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
-	err = skcipher_walk_aead_encrypt(&walk, req, true);
+	err = skcipher_walk_aead_encrypt(&walk, req, false);
 
 	if (may_use_simd()) {
 		while (walk.nbytes) {
@@ -311,7 +311,7 @@ static int ccm_decrypt(struct aead_request *req)
 	/* preserve the original iv for the final round */
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
-	err = skcipher_walk_aead_decrypt(&walk, req, true);
+	err = skcipher_walk_aead_decrypt(&walk, req, false);
 
 	if (may_use_simd()) {
 		while (walk.nbytes) {
-- 
2.20.1

