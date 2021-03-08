Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5367C433E9
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 20:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7340865299
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 20:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhCHUYC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhCHUXd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Mar 2021 15:23:33 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28DBC06174A;
        Mon,  8 Mar 2021 12:23:33 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso3817513pjb.4;
        Mon, 08 Mar 2021 12:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xzUW1+fN5LNzr5gYKSWpNlwj+hZH5hSn4gpB0V8MSR0=;
        b=UIorIW8MGS2Kx15nBWjrAC+z86uZlIYRgtfZ50uBRnWwCNEGsTi5D1fJe4PCGIZm9p
         xQVZIauMdhR74OfKVZCP5xs9MiF7juUuYiVFpwm9mHPhb4/jbFS3swVDZB+G+Rd9MLj5
         7GuuqK24u4YaqlN0VbZtGy53dJ3jhF0sq444TyT7loqk2Cbj0mS03bBd5NEdjoFXy5U3
         zdE4DpbBw3+4ZclLLgV7mxBkQo918V3cfRP3mgLSQPmLP7JU5NYQTo0PnYOzeLzARLay
         GKcNdjdXgWqmAvZ8rVLzW5D0MU2E9b07TGnya1vyxyVekIlP3HQWOqIVPjLEsSdcjcpl
         8pHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xzUW1+fN5LNzr5gYKSWpNlwj+hZH5hSn4gpB0V8MSR0=;
        b=np4hdI4fZoHOYVnCMpjzCmvpJH67WMJDdTPNa+8xVnUKu/6YwhZ896CqmVV1c/DsUG
         q4VwgsaJSMTLcNiNSZ3Mo5Ms1mUArdfWLLBPIrVCj61lqtBzaMd1BWjvFtvoIyg+2J8j
         /J7eOSxfJX4fLGKX3S6XpYdcOwxnsDkHO26hODv9WCNJ83kQzFRAIU3pvXgvtbe6fBrP
         M23I/9qtN0IczHz1UW61UaEzfJ364yph2cEM5bUGQYNudylRhGNT3nViBhFWQUH/Wfv6
         BToPYorYJz7gNwy81yqMfGwOXuvelxfVD+2RsT9wry2jAsAVTzt3sGY+1LGR78r7V+W0
         BJBw==
X-Gm-Message-State: AOAM5325854ThhrVGVQSmWNFnk7KY6XzhqAT9VeJ/TtrtaAWujF4HRrM
        rOV68dCvOxrXVvrgJFrnkgc=
X-Google-Smtp-Source: ABdhPJyhDOXYp2Gh6Rh6X8TDFgP5yDtpeClYp3+e4I4dkhaXP2eNQjkZrqJHuckqC73rMmTVnjhvIw==
X-Received: by 2002:a17:90b:3884:: with SMTP id mu4mr680050pjb.128.1615235013352;
        Mon, 08 Mar 2021 12:23:33 -0800 (PST)
Received: from varodek.localdomain ([223.233.103.31])
        by smtp.gmail.com with ESMTPSA id m3sm10262962pgk.47.2021.03.08.12.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 12:23:33 -0800 (PST)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Kishon Vijay Abraham <kishon@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vaibhav Gupta <v_gupta@ti.com>
Subject: [PATCH v1 2/3] crypto: sa2ul: Support for per channel coherency
Date:   Tue,  9 Mar 2021 01:50:04 +0530
Message-Id: <20210308202005.243228-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308202005.243228-1-vaibhavgupta40@gmail.com>
References: <20210308202005.243228-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

On AM64 the DMA channel for sa2ul can be configured to be coherent or
non coherent via DT binding.

Use the dmaengine_get_device_for_dma_api() to get the device pointer which
should be used for with the dma_api to use matching dma_ops for the
channel coherency/non coherency.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Vaibhav Gupta <v_gupta@ti.com>
---
 drivers/crypto/sa2ul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index f300b0a5958a..6107bfea862d 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1106,7 +1106,7 @@ static int sa_run(struct sa_req *req)
 	else
 		dma_rx = pdata->dma_rx1;
 
-	ddev = dma_rx->device->dev;
+	ddev = dmaengine_get_dma_device(pdata->dma_tx);
 	rxd->ddev = ddev;
 
 	memcpy(cmdl, sa_ctx->cmdl, sa_ctx->cmdl_size);
-- 
2.30.1

