Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AE1C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 09:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A8DF64F3C
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 09:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCQJPe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCQJPV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Mar 2021 05:15:21 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC5BC06174A;
        Wed, 17 Mar 2021 02:15:20 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id 73so838662qtg.13;
        Wed, 17 Mar 2021 02:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=69VFIqzqTrNqnfgEhd+Giga9K2odtmm4uislAVTg41E=;
        b=AzI58HKRcnJelnLc1FWqBQd0w+PIxjUbXo4YEsBeB8VvAFu9lvhKyX5yom3JVA0326
         PMFQoUbYTFc0QPBspmavMv6X6Oy8GD0Y/UhWakLYOoSaptoonAxZR4H4N39z6rgJsgzf
         Edy9YJ6nG/KH86xPOlvAI2ot/u9crxNbnkAuO2gjI/mh8/kORUn+u9t9cfnLwV2ZNH98
         fft4+XcxkqEQLhyTqF1bxZdjO3m2/CpREwqu77omL0Kgg1fYibSlBokjHL4q91cMeRqA
         lStmDTJCQ/RyvtOTmLXhX+7TRLUuXJG72otBRKFLHgdqDez6rlHuYavkVq0Yxo6PQQz+
         vXBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=69VFIqzqTrNqnfgEhd+Giga9K2odtmm4uislAVTg41E=;
        b=qk9/5WyuAVU3M/2G8U8+itSjR0qgxAHoK2qaup2CWNeTcjqDp9wAV/ASbYjczT3hUJ
         sJngCsIzBYqQrStlMn4agv9wXxgSEDrw3iCjKwuStPHFewiS3UlIU2qXm1GklwflOLiJ
         Ci0jua2ijKsKycBvXV+d2VckpIgoguUdFoNQnljz6y8wdx5zmYp2W5M+cyZ23y2lfRf4
         LsO3t/x+VKQp0WwI25gigSzT96tRReOX5cKrciM/Pdssfrh/Z1H9qMniSt7y0bPhf0pG
         to/TADg+XM9AFMb/54LR+mSjtwhSTzsRgVzT6pEFMxMhQaXkP53zLQhhSd7MR/xTrTV7
         ugCw==
X-Gm-Message-State: AOAM533SamKydq+kC4RiGZpjYMdEe2yD8w8SM3WK5RAOnQ7A+jqP59JR
        KAeEXz1MqBVl0G4Ke2uDGXA=
X-Google-Smtp-Source: ABdhPJzJ4SR/RRq0hLJA+BnBhn+ZrjIn0SGv8m7wYQLdeefuj4aZoyVqzIIZ0rDKn3UvXHNJGTHhng==
X-Received: by 2002:ac8:bc7:: with SMTP id p7mr3036857qti.207.1615972520129;
        Wed, 17 Mar 2021 02:15:20 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.48])
        by smtp.gmail.com with ESMTPSA id q2sm16798754qkq.59.2021.03.17.02.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:15:19 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     atenart@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] crypto: inside-secure: Minor typo fix in the file safexcel.c
Date:   Wed, 17 Mar 2021 14:44:45 +0530
Message-Id: <20210317091445.614865-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


s/procesing/processing/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/crypto/inside-secure/safexcel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 6364583b88b2..9ff885d50edf 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -688,7 +688,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		/* Leave the DSE threads reset state */
 		writel(0, EIP197_HIA_DSE_THR(priv) + EIP197_HIA_DSE_THR_CTRL(pe));

-		/* Configure the procesing engine thresholds */
+		/* Configure the processing engine thresholds */
 		writel(EIP197_PE_OUT_DBUF_THRES_MIN(opbuflo) |
 		       EIP197_PE_OUT_DBUF_THRES_MAX(opbufhi),
 		       EIP197_PE(priv) + EIP197_PE_OUT_DBUF_THRES(pe));
--
2.30.2

