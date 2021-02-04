Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB235C433E9
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F7C564FAC
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBDVuV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 16:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhBDVqJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 16:46:09 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F044C061221
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 13:44:09 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id r13so2478573qvm.11
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 13:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4BViZmMHUNQYYu9VpJJKST4ly897JCfdbGhTeJJKpE=;
        b=qSmPUBrYZyY3E7e0B+TomSazy4rmNtQf+cbA4jP7UBTtDjl9PiOpNAr3+Bqq7oNlt1
         VJVc2nQb82J0ITH+RisAG1+YoQiQxXURBSGzutmFYFfXV+ALtlvZD6sh7SsZ2kGu/P4V
         QbfbZWGT9myU5nsQNwQSONpdrm2lqM/SgULmU/XMJ6UiPsowWnwa7WgZ3B1KnJr2AM8j
         ddoBalsHmb1Cuxn3qx3JQ+wwscXVwBfWAIkDoYD1EtYFtMUSgNOTzYKnlSwCjE5f+ODz
         2PeT5v0smAxAd73MhD8xWAhgHsROXc5Bn6PUNpphasf8wy1VmIRkpjOotBEP8HkcyheM
         D7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4BViZmMHUNQYYu9VpJJKST4ly897JCfdbGhTeJJKpE=;
        b=Kd0gUq77bTIGiqaS97dlLBh87/KufZOdm8c+zOYOhK1CuJhLzleKRxNMUXu8QXNDKZ
         kbXAd94wlOLXmRADgyXmPoB907Fv8BSOE+yW3PmvWfzB9kXdMSROwud/sTiy/lGD1t69
         ifFgGBWElloHluy8HXf1qzzhHvw9fhJyEnEEE+gF9McomloreF8EXsYYHWw/imohXdbC
         0QWTu5a/UjHlzXHFYDp9OVx0lpPDqquews6ZNvMj/rziq7lt2q8Q/XphQtx9lCggMltM
         OGqvQIsO6ZJl2rMWp821jWTUcgtLYSILlf1gOQjTh2ubnij5zvoa4fpVSzeDgVhWX7wn
         qR9w==
X-Gm-Message-State: AOAM531avhY39N9hmRUXBqe4oT5uggB5afgKAVWfjA8k7+/ZqOulpQGN
        zfyjeW1id85DDOK6NJatLOwNXw==
X-Google-Smtp-Source: ABdhPJw7gaAXtBIKNQ9/gzv0zDWIcltELlQLThM40iQJ0Bswjyw4FanIBgMiEjXcVlfn4+s7tat9Vw==
X-Received: by 2002:a05:6214:522:: with SMTP id x2mr1604236qvw.13.1612475048876;
        Thu, 04 Feb 2021 13:44:08 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id h185sm6353858qkd.122.2021.02.04.13.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 13:44:08 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 09/11] crypto: qce: common: Set data unit size to message length for AES XTS transformation
Date:   Thu,  4 Feb 2021 16:43:57 -0500
Message-Id: <20210204214359.1993065-10-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204214359.1993065-1-thara.gopinath@linaro.org>
References: <20210204214359.1993065-1-thara.gopinath@linaro.org>
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

