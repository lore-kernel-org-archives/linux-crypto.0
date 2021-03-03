Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3538C001C7
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDDC764F5E
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351879AbhCDAHb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383500AbhCCOjF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 09:39:05 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA91C061A30
        for <linux-crypto@vger.kernel.org>; Wed,  3 Mar 2021 06:35:09 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id b18so17443336wrn.6
        for <linux-crypto@vger.kernel.org>; Wed, 03 Mar 2021 06:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TY1HutZnteRyydV5Ih0Egjx6tbg8POtzIYYu0tZ9gLI=;
        b=ZrZtPbhtMvfSfUn1CpaM/MJoaOHiS73bOkPE4fNSZTfjUEZOFTPG9QWcs/aeegYLFS
         f44kVN1zeKnnoyhuhPS7kUznosUtF1IH/wbGXk1tF/7blzw6ufR/lKeIBHYgXs8R7GB+
         S2JCCq7ed4tqHQQ6IhWJowxYnpBMk7bqNuS5OHFXDSJgUldfEl+BoB6s1HerOOMayVRA
         UsCLzhOh3MeXhozA5M4RdFT3sj5ZdhaftbNm3zAGZLlm3+v1ElhiHtH3jdQ8LbiVTWW/
         c/ZCG2Jb6uwxjh9KwFVVtPEqBGoitNp6y/WyY7ciBAbNTxs4Y6/Y9Tk/WiESIVPn6KI9
         vKlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TY1HutZnteRyydV5Ih0Egjx6tbg8POtzIYYu0tZ9gLI=;
        b=MPpLU7DbyDKqriorZtNX6pd2sdIfEVUPTxBBhtAES1m6RmIjSGyVXpQIVaq0+y3Tzn
         LtP431Jv1UNF4xe9cyosGkm5wf3s/fIaPMraNzYzBCIlMchHrTwwGbpx9T8mO6ufZLEy
         dNFNFIWxcPUAMCIZgTpN9bLQnyazB9zWQ1fNjvFZRW0PlLJ4mIm0/hE3p3T4KSHxyj4V
         1xhKu0gndsqdH7orIOZUso1PDXW/+D9PTkVJkrdevV5U/dplGIRRLEtM1N1zqWkopSkw
         IpmK0e7GB9MZSFWUWr3Tp7/ZFFBOaJTP5SgICIt9Pog2orsNi26/qOmFA1G5YHckHu0e
         1GUA==
X-Gm-Message-State: AOAM532v/MKcWiMjRCKZRbfw6vLjmMw45PZ4a4+u2IkFKDzp0C+BjIQO
        zrNeXKByqrhmY6nnERtd62Ppgg==
X-Google-Smtp-Source: ABdhPJzDZbGYGKGfQpxNOw+Cx28KOumuLa28Wak6NvF82YGJcdRai/Jr3G9CMfQtP+SeizwIrtJtHw==
X-Received: by 2002:adf:dbc2:: with SMTP id e2mr26742037wrj.227.1614782108194;
        Wed, 03 Mar 2021 06:35:08 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id f16sm31475923wrt.21.2021.03.03.06.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:35:07 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 10/10] crypto: cavium: nitrox_isr: Demote non-compliant kernel-doc headers
Date:   Wed,  3 Mar 2021 14:34:49 +0000
Message-Id: <20210303143449.3170813-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303143449.3170813-1-lee.jones@linaro.org>
References: <20210303143449.3170813-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/cavium/nitrox/nitrox_isr.c:17: warning: expecting prototype for One vector for each type of ring(). Prototype was for NR_RING_VECTORS() instead
 drivers/crypto/cavium/nitrox/nitrox_isr.c:224: warning: Function parameter or member 'irq' not described in 'nps_core_int_isr'
 drivers/crypto/cavium/nitrox/nitrox_isr.c:224: warning: Function parameter or member 'data' not described in 'nps_core_int_isr'

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/cavium/nitrox/nitrox_isr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.c b/drivers/crypto/cavium/nitrox/nitrox_isr.c
index 99b053094f5af..c288c4b51783d 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -10,7 +10,7 @@
 #include "nitrox_isr.h"
 #include "nitrox_mbx.h"
 
-/**
+/*
  * One vector for each type of ring
  *  - NPS packet ring, AQMQ ring and ZQMQ ring
  */
@@ -216,7 +216,7 @@ static void nps_core_int_tasklet(unsigned long data)
 	}
 }
 
-/**
+/*
  * nps_core_int_isr - interrupt handler for NITROX errors and
  *   mailbox communication
  */
-- 
2.27.0

