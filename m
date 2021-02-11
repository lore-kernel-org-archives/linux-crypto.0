Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDC0C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B63164E4D
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhBKUFh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Feb 2021 15:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbhBKUDg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Feb 2021 15:03:36 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D61C06121F
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:39 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id b24so5063882qtp.13
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4BViZmMHUNQYYu9VpJJKST4ly897JCfdbGhTeJJKpE=;
        b=d8ymdmwFXCwez4mLOrfhKf5mFT0mnFj75aMOO4K6woC6nV8wCoQmGV1QYH3VAl3Uoq
         YgUVNwD6VcAu2MtRViHxmnA/sG2aJN2lKQsaKyZE3nas3C/Rxn32TDXlYHJYU8mj19zb
         U8eT3V9ICgvWeem//Hbl/x66G2nQXDXcvsgdjYbh8z7pH2gKpoiYzc+dqc9mUSH2A1zN
         6GqMDkGXeRidVvXqN8aa1dGIzSSa+kdDA4s8Ifz68XrFZhqZ/Xb8/V/GB6eTnnVFiw9S
         0Xl6Zy1hGthmd3iI1871kouJz4sFS5GbOaXXuiP6HwVdu1WvW5/tZCDjxvsXbp2sfDm+
         TpjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4BViZmMHUNQYYu9VpJJKST4ly897JCfdbGhTeJJKpE=;
        b=OiuwO58gUDFcaaCClGO6o/7vG+Esn1jHugKIgKJN5r5qKTVbG8MZESRj8WYtYgPp1g
         zOrXLIeZk849g3kju0DxAKnK6AIX6V6qDj1NVgAplfRg/2FyeKq46xA6NKafE7GIxlco
         MAuThH9jKG1gjv/3MbHAMkFY+xNTGRNBd/EJQ3gEL/FYb8ZWylSshp+HZjmJPKtTLJjA
         IiVJgVMfcb2IpkutYhlM98cod4jujhBynenqU2Dnn4y8QMjaom8Mpx4C5DYbNtIiwkq7
         HfZaANq1WZp7S13ccmo+EYFsvFuE04oKQC+lnQ/l4aTgJS43oWwGK6udbL4uQ7zx2T2N
         Yw3g==
X-Gm-Message-State: AOAM532OjblJkfXjKqiLiVFYmMnoLUqDN6MhCTuRUOHsj0Q8yS/5E0SJ
        +c9A77m8TpaAUIlexSkOXZs7GRk9rQesPg==
X-Google-Smtp-Source: ABdhPJwIoe4FnuMOqW/b3lz3GUJCoLf6gkWdWYGsr9A4a/o9PsOHB4lIcd2kDNU8FFABJdNkrtaB8w==
X-Received: by 2002:ac8:5992:: with SMTP id e18mr9063133qte.177.1613073698273;
        Thu, 11 Feb 2021 12:01:38 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id 17sm4496243qtu.23.2021.02.11.12.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 12:01:37 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 09/11] crypto: qce: common: Set data unit size to message length for AES XTS transformation
Date:   Thu, 11 Feb 2021 15:01:26 -0500
Message-Id: <20210211200128.2886388-10-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211200128.2886388-1-thara.gopinath@linaro.org>
References: <20210211200128.2886388-1-thara.gopinath@linaro.org>
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

