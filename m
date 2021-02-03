Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F8FC43381
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A9064F8C
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhBCOfn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 09:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbhBCOfO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 09:35:14 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F6AC061355
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 06:33:19 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id d15so17609650qtw.12
        for <linux-crypto@vger.kernel.org>; Wed, 03 Feb 2021 06:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4BViZmMHUNQYYu9VpJJKST4ly897JCfdbGhTeJJKpE=;
        b=Fn9CA4YwyxlXYNEjYdibrpe1DxpcKeD8/v0w0LcbTQArYbUr1mqMEehOF8wsJYUpv6
         FBMdrK0DQQVx8JrH+CY1ihpqsT+/ma+PyoAw+0CYQLXmYM6LvFDUZph1/wYQF/7rIF4t
         7HcEwqOEQW4AK4YiGOY1bNGUp41ctQael1o+fRjNzz2bQZLh3LoKstrw7TXBVBCjB3v9
         ls3zCZM/mMcb2ZKtVXW0GDHzAgSgStI1WO6IIVsBAkTy15kfge32Qm8E9iTu4UdMzxyv
         8OXAYTjeRdSKw4tUV0PsGlWcRFz+aBXnJq3WwMul7NyeJKyKgHBruIpa2SEzl7+7QZZl
         xETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4BViZmMHUNQYYu9VpJJKST4ly897JCfdbGhTeJJKpE=;
        b=eSgvSdt3ncVUEJsrim4oIu4RTAchvDt4WUMQseO0H77t+HKkQOqyqwVSFxYFogPkam
         qu7cM9kZFJWbJcnkZ75ndmdD+lwOD9ijzHykxItdGme7pxo+Gv2Av6zaaQ73+2EXoWO4
         rAyl1obQOvFB0eZb0+EeFwg1Ewwg0snDQhmiARH4KrmeBHACxm27ltf4HdM/SQaqCPQH
         Z4+qUJtxUgruxEc0/thRVxf6a5G2zRGOmTe0jFxMT1NFDCjcJhVAeNePyVAfJT4irvw2
         34HsEt5nyvW/N2Qdwon8XSEPeS7lu9XZ4ZnIYsBICTJJ57P9wpovC3q9SX0QgjTXI4xJ
         hEgw==
X-Gm-Message-State: AOAM5337S/7nu8kDRBD/y2rZUhtf4cZSYHx8OM+bzyqTvYJlARWaW2BE
        8yVyzEwpCmpJjnnSyEqtj1Nejg==
X-Google-Smtp-Source: ABdhPJwh7/mykZlq/TuNp0sNl6eKd27+UNFUfFdP00kXLjF/61T/Y9e8QvsIx7ZhAdQ8tInlk+j2gA==
X-Received: by 2002:aed:2f86:: with SMTP id m6mr2580104qtd.253.1612362798885;
        Wed, 03 Feb 2021 06:33:18 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id v15sm1775433qkv.36.2021.02.03.06.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 06:33:18 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 09/11] crypto: qce: common: Set data unit size to message length for AES XTS transformation
Date:   Wed,  3 Feb 2021 09:33:05 -0500
Message-Id: <20210203143307.1351563-10-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203143307.1351563-1-thara.gopinath@linaro.org>
References: <20210203143307.1351563-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Set the register REG_ENCR_XTS_DU_SIZE to cryptlen for AES XTS
transformation. Anything else causes the engine to return back
wrong results.

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index a73db2a5637f..f7bc701a4aa2 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -295,15 +295,15 @@ static void qce_xtskey(struct qce_device *qce, const u8 *enckey,
 {
 	u32 xtskey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(u32)] = {0};
 	unsigned int xtsklen = enckeylen / (2 * sizeof(u32));
-	unsigned int xtsdusize;
 
 	qce_cpu_to_be32p_array((__be32 *)xtskey, enckey + enckeylen / 2,
 			       enckeylen / 2);
 	qce_write_array(qce, REG_ENCR_XTS_KEY0, xtskey, xtsklen);
 
-	/* xts du size 512B */
-	xtsdusize = min_t(u32, QCE_SECTOR_SIZE, cryptlen);
-	qce_write(qce, REG_ENCR_XTS_DU_SIZE, xtsdusize);
+	/* Set data unit size to cryptlen. Anything else causes
+	 * crypto engine to return back incorrect results.
+	 */
+	qce_write(qce, REG_ENCR_XTS_DU_SIZE, cryptlen);
 }
 
 static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
-- 
2.25.1

