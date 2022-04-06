Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB5EC433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 17:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238406AbiDFREZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238398AbiDFREF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 13:04:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FB31D7DB9
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 07:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 021C4B82252
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 14:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A80C385A8;
        Wed,  6 Apr 2022 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255250;
        bh=KahxCYVg/8TEhsqoOIH+X+MfVVHAt2qaRWPxtkQzza4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7JHS3utba6R1jd32Mo3AyW+yvc86YkaSJstxo2D6CzhzmZPz2N9VLQ8BPgwm6RB3
         z3SnNG4e4V4UBeAV4MaxRp3Oi/yuUoJdSkZie1+QiO+M95rOeI9ZLGVd4YvfFV3y/n
         PSLofXR/NamAxvh5Riy2SvdD1CS0IL/i94yMxivW9o3S3FFMW9KTBN8+xi3JBbpZm4
         hr6ocwzHqlmrhVd2nmZEdTu+gUGAfOrE3VoXbnh8tR3DLe0OVE423hCti1kElbWBqW
         Mbo0DUDpc8kzB6D5yQQOIkufKRIZArbCZWmBILALesz68wXt6UbfK4ZFOzJcCojqho
         bmXyxuTbjZLaA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, keescook@chromium.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4/8] crypto: drivers - avoid setting skcipher TFM reqsize directly
Date:   Wed,  6 Apr 2022 16:27:11 +0200
Message-Id: <20220406142715.2270256-5-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406142715.2270256-1-ardb@kernel.org>
References: <20220406142715.2270256-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3592; h=from:subject; bh=KahxCYVg/8TEhsqoOIH+X+MfVVHAt2qaRWPxtkQzza4=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBiTaM8uLeAmE+1w1UJ1HanZ1GKYLAXdxSiA4ZnkiJQ aeyYSTKJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYk2jPAAKCRDDTyI5ktmPJAFrC/ 9y2mwTvyPCon9mspdHzrZ2Y51MN23smph2n0Ji0o3YXnvl5e5KyuDlWIye3/8qG4Qw5g04vPYKZdzX bmaCahxZh3L8kXnaDGHhcRpm+aB9ae4eeIZC5l1dTg2AgXt36g7cPjZpBPG+HfytiSRJdGi6Qd/Lhf crxgUrd1ODReBYp9VgAwqf84LfvLIli+k+3imUn692aw/953SCzZTQN9SSHlwFAz5PRd8+Qzm2t3Et 7YZEKBrXw0Z/XXnKOn6x4jq/y5//9tBfF4vO0ZZCsUVw199qtyxw/6dlCeWlpOZPStR3i7YT9of5FB gF8yiR7ggzGM47OvRX6mmbVUqqfB0lAotHmyq6t4MCI3BPgVRFE8Z9BO3absbrQdngCBRXriPK7fT9 Y4p15uGAAwaJA1nEQqVPDGdJHkbT2qJ7rh25cLUSRm37u/W27FEB6FrUQljV6LEoXsPWwM+RBGKrl0 EdLpRCdcih+09RgoLrBtWbd0vQ1PmqpihdkpLgjuxHKHs=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The skcipher TFM reqsize field will be rounded up to DMA alignment and
padded so that the resulting request allocations contain context buffers
that are safe for DMA if the algo implementation requires it. So avoid
setting the field directly, and use the appropriate setter instead.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 6 +++---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 6 +++---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c         | 5 +++--
 drivers/crypto/gemini/sl3516-ce-cipher.c            | 5 +++--
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 35e3cadccac2..de0e2211292b 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -395,9 +395,9 @@ int sun8i_ce_cipher_init(struct crypto_tfm *tfm)
 		return PTR_ERR(op->fallback_tfm);
 	}
 
-	sktfm->reqsize = sizeof(struct sun8i_cipher_req_ctx) +
-			 crypto_skcipher_reqsize(op->fallback_tfm);
-
+	crypto_skcipher_set_reqsize(sktfm,
+				    sizeof(struct sun8i_cipher_req_ctx) +
+				    crypto_skcipher_reqsize(op->fallback_tfm));
 
 	dev_info(op->ce->dev, "Fallback for %s is %s\n",
 		 crypto_tfm_alg_driver_name(&sktfm->base),
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 554e400d41ca..11b711553261 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -345,9 +345,9 @@ int sun8i_ss_cipher_init(struct crypto_tfm *tfm)
 		return PTR_ERR(op->fallback_tfm);
 	}
 
-	sktfm->reqsize = sizeof(struct sun8i_cipher_req_ctx) +
-			 crypto_skcipher_reqsize(op->fallback_tfm);
-
+	crypto_skcipher_set_reqsize(sktfm,
+				    sizeof(struct sun8i_cipher_req_ctx) +
+				    crypto_skcipher_reqsize(op->fallback_tfm));
 
 	dev_info(op->ss->dev, "Fallback for %s is %s\n",
 		 crypto_tfm_alg_driver_name(&sktfm->base),
diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index e79514fce731..a3e839a97c78 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -328,8 +328,9 @@ int meson_cipher_init(struct crypto_tfm *tfm)
 		return PTR_ERR(op->fallback_tfm);
 	}
 
-	sktfm->reqsize = sizeof(struct meson_cipher_req_ctx) +
-			 crypto_skcipher_reqsize(op->fallback_tfm);
+	crypto_skcipher_set_reqsize(sktfm,
+				    sizeof(struct meson_cipher_req_ctx) +
+				    crypto_skcipher_reqsize(op->fallback_tfm));
 
 	op->enginectx.op.do_one_request = meson_handle_cipher_request;
 	op->enginectx.op.prepare_request = NULL;
diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
index 14d0d83d388d..ad4c878e834d 100644
--- a/drivers/crypto/gemini/sl3516-ce-cipher.c
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -328,8 +328,9 @@ int sl3516_ce_cipher_init(struct crypto_tfm *tfm)
 		return PTR_ERR(op->fallback_tfm);
 	}
 
-	sktfm->reqsize = sizeof(struct sl3516_ce_cipher_req_ctx) +
-			 crypto_skcipher_reqsize(op->fallback_tfm);
+	crypto_skcipher_set_reqsize(sktfm,
+				    sizeof(struct sl3516_ce_cipher_req_ctx) +
+				    crypto_skcipher_reqsize(op->fallback_tfm));
 
 	dev_info(op->ce->dev, "Fallback for %s is %s\n",
 		 crypto_tfm_alg_driver_name(&sktfm->base),
-- 
2.30.2

