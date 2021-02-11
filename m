Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F404FC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C28C964E4A
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhBKUE6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Feb 2021 15:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhBKUDF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Feb 2021 15:03:05 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11D9C0617A7
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:35 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id v206so6522336qkb.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1CgjtrleZBn361kEsQacHmwktwYHTlh2i7RhqRtwQhU=;
        b=ys1ClJjc89p3uIaKVv5nPzEGLGYSpyZfo96p7Ho137WBXWf4266h587cPDZnOwuDgt
         aj9XK0idolxShycDxNigx165a9CaAJz7AZW+C52i6odq7YLRiDEKU6e6O7MtmBPapKix
         Y54MCwi2HRFFi7xBAXFl8Z3Thxi+nH912l4cHaOv6Fk3oOJAwSIPsgDTyRq7pHa/h3NB
         Y22uTRSobrXNdkVbkr+7en8T0i5hUKwAUp8p7lkADan0vf7+k6D69BdrtfSIHGedJDzi
         4b94tnuvLhDGwwid/GRVCgNkkGNvrEwi95rjtZJ5HaU107Vm6WuW/WH47nGb8g3E+WTq
         XnhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1CgjtrleZBn361kEsQacHmwktwYHTlh2i7RhqRtwQhU=;
        b=MPvH1EBWfPF/21o7wR+0JuaCV87MyHQKy/7SYXi6rh1thNj0RXo0dm7/YX+aARLUPs
         4nrgXTlcNJGASEEWeegHkNlwwzU3XYFjkXDJuOjgIBCW12LOAjsuJj1TedCYuQJVK0wd
         1w+rEaCuHidEkKq3C38j1/xcmtnulvx1MuLRsWC8vs/OHhqEDB1CfLYZp51vlKARY6jK
         UD3hAYOkGpBmps2suknjv0AFxpFsXs+S43ObGp5Ra2AHE9ELliOQeE1f6srsnP9VnAWy
         wGjoAQX45Y7GS5koY04ZS/RRbWCFogmyJu3GpD9370qvTwfQBHq2iDDvWxoGa4qHudYD
         A6TQ==
X-Gm-Message-State: AOAM532AuauyZyY6+sD/O7yf/1P49DcZgd7fbtbC5JlxC5jcZaN0JNL8
        SUg4PJ4QQrxd2LhAGcr1wFf/qQ==
X-Google-Smtp-Source: ABdhPJyTW/w6d2hG7OAGHIbsWO3Sa25NlI+GgMhqPovvFAnQ9Chp8NIopA6QUNMziTj+IL1soQo9Lw==
X-Received: by 2002:ae9:e883:: with SMTP id a125mr10206879qkg.431.1613073694918;
        Thu, 11 Feb 2021 12:01:34 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id 17sm4496243qtu.23.2021.02.11.12.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 12:01:34 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 05/11] crypto: qce: skcipher: Return error for zero length messages
Date:   Thu, 11 Feb 2021 15:01:22 -0500
Message-Id: <20210211200128.2886388-6-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211200128.2886388-1-thara.gopinath@linaro.org>
References: <20210211200128.2886388-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Crypto engine BAM dma does not support 0 length data. Return unsupported
if zero length messages are passed for transformation.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---

v5->v6:
	- Return 0 for zero length messages instead of -EOPNOTSUPP in the
	  cipher algorithms as pointed out by Eric Biggers.

 drivers/crypto/qce/skcipher.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 8aeb741ca5a3..6b3dc3a9797c 100644
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
+		return 0;
+
 	/* qce is hanging when AES-XTS request len > QCE_SECTOR_SIZE and
 	 * is not a multiple of it; pass such requests to the fallback
 	 */
-- 
2.25.1

