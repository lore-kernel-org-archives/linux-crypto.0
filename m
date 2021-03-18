Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB18C4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5120564F9A
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhCRMpD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 08:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbhCRMom (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 08:44:42 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F82C06174A
        for <linux-crypto@vger.kernel.org>; Thu, 18 Mar 2021 05:44:41 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id p19so3471855wmq.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Mar 2021 05:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TY1HutZnteRyydV5Ih0Egjx6tbg8POtzIYYu0tZ9gLI=;
        b=YpCedp9IdwWeyxohsMCGQpMQoLV/hkD4ApREPjeUj04im6YuhY7tA13/cQE/+ppygN
         gD4CV7xwu/vJdv5lQCoaNMHriSIdIv5N5QBPK4Wmn0C4U2djRnpU7/C+E5upxSCkWGzE
         tOHe9MF2in8lHi0Op/RB+Od7D9SCVOqREpzBkQArb4HKpO6hAcjGDN64seMVmvqwHPEP
         r9nseEw/mDgKSTAg8kqsHIeCaOWrJc1XDZrInFEKRSwtrMPhD7pJ9wZh3wzYT+Lm4bQO
         CoTKTy2nH43TNBDPGKNNWkgx4Qf9u4MvFGSgQqtWJC8oTc7Xsla9O4alkLDH06QTK7hS
         e9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TY1HutZnteRyydV5Ih0Egjx6tbg8POtzIYYu0tZ9gLI=;
        b=lk9MMFMiwQ8ZSafSYBAed0EJJgI1bpa9TYvEnIT4vdS5MkRwvhbxiomgczcXmrtvze
         cYPHsFzzNsFINB9LYBOF7QQEyuTYoTfFWJLwtJXGXF4/OyrnejjCfdBQwdDRF7zESchV
         3aM3bkzHaVcMyHOFHyLoASI7bPETk4OwpMgka54Q/5rUT5d1cHLMDpsHQojEtCojV9xd
         JpeNwISySwZemWDjOsqo+NO4EaHs6uNv2mNIEt1MU/GUDkCso1mmDRtsXqmhpBLxNz6x
         qcCUUlOOTjOdpF3+poSwYFSaEu8R/Kquq9ZT4ywYFa7iJsKtJT6w69+mcWAj5XJpAmzl
         VlcQ==
X-Gm-Message-State: AOAM532PDfVcr9WSF305oSejT/tPrCyPdyjwEiD7ngIb1KTXwRLSlpOg
        Wj+AEog4e/bPO+A52LLtVI1lXA==
X-Google-Smtp-Source: ABdhPJwayS+6aJydxHj5yStfZeVa3lyWXiOrvhsKnl33t0rWgECJEOb5yGGRqE5y2RprFfC7xgfXqg==
X-Received: by 2002:a05:600c:3514:: with SMTP id h20mr3567716wmq.45.1616071480151;
        Thu, 18 Mar 2021 05:44:40 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id q15sm2813900wrx.56.2021.03.18.05.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 05:44:39 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 10/10] crypto: cavium: nitrox_isr: Demote non-compliant kernel-doc headers
Date:   Thu, 18 Mar 2021 12:44:22 +0000
Message-Id: <20210318124422.3200180-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318124422.3200180-1-lee.jones@linaro.org>
References: <20210318124422.3200180-1-lee.jones@linaro.org>
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

