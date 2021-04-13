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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB67C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 09:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1F0A610CE
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 09:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238844AbhDMJVU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 05:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238477AbhDMJVT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 05:21:19 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617C4C061574;
        Tue, 13 Apr 2021 02:21:00 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t23so8141489pjy.3;
        Tue, 13 Apr 2021 02:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ufYL7t5jtQdHvhDHkCBpGNIyLrPDkiGBHwLlkR/vVHs=;
        b=jKIk6Oi3aAj4KaXxgxdGvX4TqSqwj1dzAb5TxhuTA38XEPh47TlPsNv/ZqfI2wL1JR
         zMBhl/Jpb2f6JIXQ/JxVuEz1Xf3Z4FwjspS9PY9fYsWxM9S9mRU9WliwowJc3UMsCjZz
         I9RAWFYy7lVcbR4kMsPq7aAiuIQIbdVg8TN92Zg0u7BN+xFlaGhCVntpI4tGreluIuCi
         ffQEFzI1UqF6e2IJ2Avxirj7sc4xYJKQQmb2T1CcoDyLeGZ6O/lVgOtXMCWeK5nSfOg1
         9dSsbew6YchUEVe70JNli+2Nvn2tK9YplgLJTRuMxBbS0at77sV/iRd2pFV7uUYKWxtu
         fiCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ufYL7t5jtQdHvhDHkCBpGNIyLrPDkiGBHwLlkR/vVHs=;
        b=VOZT3Rn6+X8zSSYxTDnW1at+Ns8+1Pzm9s+VJl2qUfM5l96WLVL9f/AR+XhXUSTK5l
         FndStCDf3qCTRDpBHptiOOSyGEc6w/c+7C7a4IpShWdj3fV9o15w7fXViOis+3m6cIhR
         zo59IJeWlkUefFytapmqJZfkya/HmQk8oF3JrXjvsmmLwwMm6z6Wm6zI21TGfePL6Plo
         5GY8V9WyCv4z6NqTj58pHJxVHGuskdGzfAVcQupYjOLfhL5CQMoIyCiTfzwrkkcIy64j
         pXFJFF+YFVfQwiBS8l84gfKELGHe2ooiBsFFSjIT4EhpDmggpmd+G1FT6so50KWuVlCx
         pQEA==
X-Gm-Message-State: AOAM530WLRMFMKAWKtzNFE39lAJOIDJEZcZd77TxJW7lpUVLfSixC7PM
        8W2HWYk33fSpVUke4QrOB44=
X-Google-Smtp-Source: ABdhPJwsxXnUEut88WhTJtWCV+W7Kr7YR7bh3b3QaHU1tsy/rfbnuyfUg/IDDrbyu7H2ZPaEw/+Vjg==
X-Received: by 2002:a17:90b:4a81:: with SMTP id lp1mr3816531pjb.154.1618305660002;
        Tue, 13 Apr 2021 02:21:00 -0700 (PDT)
Received: from varodek.localdomain ([171.61.181.173])
        by smtp.gmail.com with ESMTPSA id x194sm13388570pfc.18.2021.04.13.02.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 02:20:59 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     vaibhavgupta40@gmail.com, Kishon Vijay Abraham <kishon@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] crypto: sa2ul: Support for per channel coherency
Date:   Tue, 13 Apr 2021 14:45:58 +0530
Message-Id: <20210413091559.154169-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210413091559.154169-1-vaibhavgupta40@gmail.com>
References: <20210316220558.GA3754419@robh.at.kernel.org>
 <20210413091559.154169-1-vaibhavgupta40@gmail.com>
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
2.31.0

