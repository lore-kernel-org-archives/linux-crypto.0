Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F05C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07E9664FB2
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbhBDVpe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 16:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhBDVpY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 16:45:24 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7DEC0617A9
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 13:44:06 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id k193so4919307qke.6
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 13:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fbaPzVOJqVBKum7B5yoNy4q+qHm6B45n0RkRe3mNDrc=;
        b=kGJX8eyN3yi8UlOcJJ6kU9ufahtm5U/YGN/KL9tEJ+qlTwFMpipOSJDa7XCZx8Q2dR
         Owa3CpMKTbBsV9fBpN5nB+yTvgiICdGsxMVhRPYcVhKf0SQCF1jB4v2iqrHp+348HZNc
         UcUOxHimAxMBmosQCRTnC73Gj9PrO7ztPQkDr42+QZ1hCQm8VMNNr0GaayO3VW8yS7f3
         wWzuMU51Ywf0X+pvisB+l8GMqaH12XN1JuFHoon+U0zNpSLDum6H/Q5V9ph0BJunJrYS
         GDKt17AvSLpx3BtXwS3OxxFHRTfsNBcEObpX0pDxSv31B1mJVr1vvuNPtZOfadrEGbEC
         KfPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fbaPzVOJqVBKum7B5yoNy4q+qHm6B45n0RkRe3mNDrc=;
        b=LZ5Wj4f9QBqTbPVbZMRBuWkUYz0XsyFVsFp7+i8RIZ43v64cZiw3ZswTxIEA8XsgE1
         BuIX7u+eeMG9+8YcZlsf7ByJeAj+1nigFoxpwu2nMyZp4pn6lhPmotuGjn5TlI+1rTQK
         y33in7JK8pPHkJG5vPAE+AAOZkf0kk82RT2ebu58dWUWgNebTlKw1pVVsIwZOhoPnHD3
         YBXC6SVk11Jg+RZYWjo7r7l8yQH4TTOGQuCCjwO3Nqe4vu0XiHwQ65DILgP6UeiU8pjV
         JQT5DSX5s5EaQZJ4USDLMAllacXVRd++0m2+/2XsoY4rpxcWWamat1xcDGfJn2hUzdU6
         drPQ==
X-Gm-Message-State: AOAM531ouyM9Kc/CuSk0JgYZ4F2JKiuh6iCsz1mzUzziI0hBx8/+ncGv
        YD7UStq0EjHLB9Bc39fcsVdCMw==
X-Google-Smtp-Source: ABdhPJyQOgn+xSH+44L0bkypXvxB7wf9HXqeHuTlOjrrnsCnCYL7MfNwwggTxr+sxpSO/ueQyxEvgA==
X-Received: by 2002:a05:620a:158e:: with SMTP id d14mr1263186qkk.111.1612475045331;
        Thu, 04 Feb 2021 13:44:05 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id h185sm6353858qkd.122.2021.02.04.13.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 13:44:04 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 05/11] crypto: qce: skcipher: Return error for zero length messages
Date:   Thu,  4 Feb 2021 16:43:53 -0500
Message-Id: <20210204214359.1993065-6-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204214359.1993065-1-thara.gopinath@linaro.org>
References: <20210204214359.1993065-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Crypto engine BAM dma does not support 0 length data. Return unsupported
if zero length messages are passed for transformation.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/skcipher.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index de1f37ed4ee6..331b3c3a5b59 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -8,6 +8,7 @@
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
+#include <linux/errno.h>
 #include <crypto/aes.h>
 #include <crypto/internal/des.h>
 #include <crypto/internal/skcipher.h>
@@ -260,6 +261,10 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
 	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
 
+	/* CE does not handle 0 length messages */
+	if (!req->cryptlen)
+		return -EOPNOTSUPP;
+
 	/* qce is hanging when AES-XTS request len > QCE_SECTOR_SIZE and
 	 * is not a multiple of it; pass such requests to the fallback
 	 */
-- 
2.25.1

