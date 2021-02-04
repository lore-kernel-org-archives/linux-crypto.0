Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604BAC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1042C64F8C
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhBDVqO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 16:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhBDVp1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 16:45:27 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA970C06121C
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 13:44:07 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id l11so2523440qvt.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 13:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KjZ2FfLW1/QZmo1tCtVZh16jkU5d2sBI2rN7J1hvIYw=;
        b=g5EgL9oKkFrP4qrDMqJXWuVtfqL+27lOlV4TwftWzdFlWpIMb6cY1CPR2U7M/CM8r7
         EoCtl2w4xW5UovRh4KwzaRDDjowaeSougjpE0WSpQB1/7EVGEd4X0CI577NJkKIqbOdl
         i5/VH5hfpVECB5EUfIhpUtFXAqaUkR8VOTD3F+mtD2SyuMdVrNmvkGN+fs32lbJVtC/S
         FX3fC9rRsZ/C/7IcF+R9fxfCliW7b8InuPEypVnzhHv/n8UliqJgCPc3aqTmpNsSyvJd
         nO812hYm+e5ghRyx+XQtUBgc24kq63WR3lT6jMjS9vPR1ZpO7u9LD+4EGLA6dPo9KxLR
         VVpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KjZ2FfLW1/QZmo1tCtVZh16jkU5d2sBI2rN7J1hvIYw=;
        b=G4FNa8zM+ltIUome/jTaRw22G3iEMTHYMTo2XfZiLxfvUtP24wXLQwUdJpCI7bGq4t
         gsBuJjbfsnajDUhqbXCuZvHOaqacsN3S4NZG0IXitrTekpKmtVFS0yOydHSji6QMTKN9
         x2A397V+gZeFE4+OGmxGrtJ8/uAXbAeWr3fInZwHNdy5Zj2lyn1z9ZQxnSCxboXw5TiV
         XClzwwmr7+Dit+opWtbWJGymj6VMHF8sRFFrJ+plbkaigjWCaq+QT8yAv6JIu3Kdn/G3
         /o9hCfY5WKTWCMyEjGUixwNKyiqcR7LNaIKM/rJRD4ppGgzZEXVpmYkBu2yXufeMeThY
         +Ezw==
X-Gm-Message-State: AOAM532LOXhIwSeGzQ4syOj0biCKWUAVq3aPLr3U+U8URHdaSDW8cawR
        e5atEyeUpTmAuD0rQ77j4vwNPQ==
X-Google-Smtp-Source: ABdhPJx9ajQnJ+hZhTECoHCc6ZLXXi93dKDogMtbR24kimnPUwxf1ueYp44gJfP6PvfWjet4GSOj3Q==
X-Received: by 2002:a0c:ffc5:: with SMTP id h5mr1622019qvv.48.1612475047129;
        Thu, 04 Feb 2021 13:44:07 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id h185sm6353858qkd.122.2021.02.04.13.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 13:44:06 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 07/11] crypto: qce: skcipher: Set ivsize to 0 for ecb(aes)
Date:   Thu,  4 Feb 2021 16:43:55 -0500
Message-Id: <20210204214359.1993065-8-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204214359.1993065-1-thara.gopinath@linaro.org>
References: <20210204214359.1993065-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ECB transformations do not have an IV and hence set the ivsize to 0 for
ecb(aes).

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 28bea9584c33..10e85b1fc0fd 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -356,7 +356,7 @@ static const struct qce_skcipher_def skcipher_def[] = {
 		.name		= "ecb(aes)",
 		.drv_name	= "ecb-aes-qce",
 		.blocksize	= AES_BLOCK_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
+		.ivsize		= 0,
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
 	},
-- 
2.25.1

