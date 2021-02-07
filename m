Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF60C4332D
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1118764DF2
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhBGOlT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Feb 2021 09:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhBGOlM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Feb 2021 09:41:12 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D71DC0617A9
        for <linux-crypto@vger.kernel.org>; Sun,  7 Feb 2021 06:39:53 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id x81so11978672qkb.0
        for <linux-crypto@vger.kernel.org>; Sun, 07 Feb 2021 06:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ImO8jkC+DpvrTwFdTRomeqFeWgN9hrI9w+kY9c6b/Eg=;
        b=OCLgpZUE37foaDocZaEHBNJMw5JQFRlcV/GQrDUXCXyz99cMVjbMSB2FtH6tTfG2cx
         E40uoln4Rg3HMYsiCXRdjQ0iKjARyTtS7RBiPPm0LW+Hjo39/NnLxCUbYOsCpQplG8A0
         jSwNYwfQnLgYzxJp9qkMP/VzDat7T+ILOMsk+sfT+x4fCiE4BqmogoreyTZb8eeIJ6jr
         tiwjBcMC3loAKNeFr9gudpWumDus6vUZbpx21UM3C/t//pjbauNLsDDn00iE6YDh4wpR
         cgwC1mh6tEq3/fSAYF0DtOEtS2J/DF0xxfFjtK9b1M7W+okZls1HwwHYzPlzwV6D/5z4
         CpLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ImO8jkC+DpvrTwFdTRomeqFeWgN9hrI9w+kY9c6b/Eg=;
        b=PW02RMS1/kzBTbnscHTQPsKmINDvfFS+gljbNfF+gP3F7b64pcGXn1qpO78RM64PBd
         HuFtayrZeeKjwtTiWQlYsku/QtB/mQLulHW6Xw4D8FySXXcjhesl9hfxX2riGqA65Xf/
         UGGN9SExRUCz6tVcA4iWzOLKJwfFxb2xMP0fHrsYkZgcwa/OIg3oDOQKT3eN53hL6hb6
         hoH83Q9LfNpNKf1KVI5ui/CkwGTOzFlvRo9n0VnOQqheEvP/joNbbrzGsSidpMPXeyPx
         JlpGyjPhQ9XY8436PnK1D4uRu0cq6aypgIZ3e5eok9xMcu3aGdDFyXsyyOLNeCcU2Zlc
         7oiA==
X-Gm-Message-State: AOAM532OlPkEu9u0yryyFAGv+EC+NrQK5G3qXsWqmXocSzIKJZF6Fgzv
        9plYZc+GgYTSIpUjZpsz2QNKYw==
X-Google-Smtp-Source: ABdhPJwsP/au8aPfn6AANj8C2f8SfkkfbtzTYwhiu7dp6lGVagiGs+lxB62wlWqsgsIHLsKI4Gk5Hg==
X-Received: by 2002:a05:620a:12d7:: with SMTP id e23mr12618290qkl.58.1612708792517;
        Sun, 07 Feb 2021 06:39:52 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id c81sm13941493qkb.88.2021.02.07.06.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 06:39:52 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 05/11] crypto: qce: skcipher: Return error for zero length messages
Date:   Sun,  7 Feb 2021 09:39:40 -0500
Message-Id: <20210207143946.2099859-6-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207143946.2099859-1-thara.gopinath@linaro.org>
References: <20210207143946.2099859-1-thara.gopinath@linaro.org>
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
index de1f37ed4ee6..96af40c2c8f3 100644
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

