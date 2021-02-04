Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFECC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 847F864F60
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhBDLLe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbhBDLLb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 06:11:31 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E96C06178B
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 03:10:08 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id 7so3062245wrz.0
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 03:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EFpX+AmGU+/V3bANCqUU3BguvAC+waEIfHhaAdI4zMs=;
        b=hv1VBzJc6RilH2aUMiuk9Ns6LYXu2wa4OjuB1dtlBKNQoUwuZi1zdEuhynoL4Qr0sl
         zqvRLwKWWrIX+Zuda0m/14lI0psfn2i9Ws28XwDAEcFS8uQgjaLBnuDAj2424NU/MZdg
         bJC0bjoXMrAW1YDA4a8iv3PIyPjcYzUVf44Zn8+D3L1kpHfZY91MGJ7OBj7M7xYxIbnT
         pC3d0vfoY4BZS2eDEImbR/BoeMQeUBxWFBDCBkvbZmUm5Z/adSkHh4ckAP1OnVAwWmRd
         EtlecuTomKf+rSFNglyaSRXiyLYh+uGQ49JqyVAqjji82ZXTFGBNEJiAWlWnq9KfRTY2
         SYEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EFpX+AmGU+/V3bANCqUU3BguvAC+waEIfHhaAdI4zMs=;
        b=GzzEASzcHZu8onN49en/+ZeczhC/1K4vh1J1F1FUVRmqQX2j6sHkOz5Neji403YPFL
         UWKsEc7W6OLoVpl1j3riBp1yvdp/oCaQZc/UzmCnCV6rSnEpEAaS7L13qK6qlTLjLB0b
         4A0x5Q6j1d14fXxb7rydlPGCxng28oc3hVKobk3DYN3fyxb4FOJ9t3BA+MgmFZEEJM+J
         XZnNiWSi2Zpgn96eOAsLA4jT/GOgYTBxN2AM706WtWV4qC2w+HmiaYAbOZ3enSUKe/PJ
         4/iDboB37n+hnxBHZwkUYi73iugQV2ZUodn57i+e6J1WCJAg/usOYwFOdq+iiHrKis9Q
         DhdA==
X-Gm-Message-State: AOAM530vFc4p/193BZZiZ2+NU9kUdSPeXmCjdxmmPuxVo5GgdoujLBH3
        v0HEHosBCCs78M8c+uO4XL2jaw==
X-Google-Smtp-Source: ABdhPJwJoinTJrS70FP+INyhS5zItFKn/Hlz+JZP5Bfka/wi3Li3Vy649PizAtfAUivpTpZCP3jaxQ==
X-Received: by 2002:a5d:6b47:: with SMTP id x7mr8918819wrw.170.1612437007388;
        Thu, 04 Feb 2021 03:10:07 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id y18sm7696218wrt.19.2021.02.04.03.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 03:10:06 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Manoj Malviya <manojmalviya@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Jitendra Lulla <jlulla@chelsio.com>,
        M R Gowda <yeshaswi@chelsio.com>,
        Harsh Jain <harsh@chelsio.com>, linux-crypto@vger.kernel.org
Subject: [PATCH 03/20] crypto: chelsio: chcr_core: File headers are not good candidates for kernel-doc
Date:   Thu,  4 Feb 2021 11:09:43 +0000
Message-Id: <20210204111000.2800436-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204111000.2800436-1-lee.jones@linaro.org>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/chelsio/chcr_core.c:2: warning: wrong kernel-doc identifier on line:

Cc: Ayush Sawal <ayush.sawal@chelsio.com>
Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc: Rohit Maheshwari <rohitm@chelsio.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Manoj Malviya <manojmalviya@chelsio.com>
Cc: Atul Gupta <atul.gupta@chelsio.com>
Cc: Jitendra Lulla <jlulla@chelsio.com>
Cc: M R Gowda <yeshaswi@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/chelsio/chcr_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index f91f9d762a45e..f03ef4a23f96d 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -1,4 +1,4 @@
-/**
+/*
  * This file is part of the Chelsio T4/T5/T6 Ethernet driver for Linux.
  *
  * Copyright (C) 2011-2016 Chelsio Communications.  All rights reserved.
-- 
2.25.1

