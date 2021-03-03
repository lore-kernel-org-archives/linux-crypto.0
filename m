Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200F6C43142
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0340064F4B
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357307AbhCDAHg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444108AbhCCPBU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 10:01:20 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9502FC061223
        for <linux-crypto@vger.kernel.org>; Wed,  3 Mar 2021 06:34:57 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d15so8689844wrv.5
        for <linux-crypto@vger.kernel.org>; Wed, 03 Mar 2021 06:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cqK2Pp2ViTz0xdgYhapttz8LcH4etuWNmG0+y0P94Tk=;
        b=vZ//Oq17fVFIHNxnYuSz7zmIiCfX7FKb2JjXbFKwrJueBoLWMipljxZqkZkU6bIQsB
         likK+NsLkdz8/McVfqMXARxi6qK/OQPOL2bifNzI2lcmDegxejtRTlJc+lYK5AQOb6yb
         FkgBKNZo0SRcoId0GkIXHIrUC+7koACkR0MblOhBkdKRML/CY9WK34OzgRqD4tBnq21m
         Cs2D2ftMTFMSUmZsXykMPRi6KOKNFWj4xZtzDpRuRT8Intf0vM3l0o4ga3s4LRTjpTio
         KInznYoMVYau0okheGPv0WCchkmH9hi6dcNx3w6x9z+Ni4hKysTVX1n7wIk/NALdSnV8
         bPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cqK2Pp2ViTz0xdgYhapttz8LcH4etuWNmG0+y0P94Tk=;
        b=R34J4CT9FhbDnIWg0aQBV5qUSDRCc/6mQeQ+4eJW0YRVqO4J23ABPLXfBcZzWbZlB8
         Dz7Rx2xN/2ygFLXkIuoy/fHaKqs3w5c8/U7A3LIWGP68bRlASKSmz2F5KPwBa7ehQ1QD
         yEe3BrBu4gC6YlZhIJGcuzgUZoArthBY1KwzBTAKSdu92d27JF+Xn0pNGyQXsrmO6L2A
         Hq6D24S4Dr9vdzk+/p4bV4cEAUWhRw2mo0v0nAmfcLycYPc81Frzz9/LLTZ4xxVdrhcr
         y3VPgAXW6dbAqwUQv229MIhEzrGvESkETC9EBDRQStDVPyt7MBoGaC7H+uokDAuz4Ae0
         mnZQ==
X-Gm-Message-State: AOAM5337bzdbAuCkGvyzBS4fqZ5V0GNOhN1IMnFKCueJSQbG5nUe+5M4
        x4tmTQZZyfFBXcvHcv/xr5CjbQ==
X-Google-Smtp-Source: ABdhPJyf2yjx43drbtYr6Sa1JuOvqI7QyppRGNrIh9Eyf+kpjqOVo8aQOZvzn5sS8PCKV5rOt92yhA==
X-Received: by 2002:a5d:4903:: with SMTP id x3mr23879642wrq.143.1614782096340;
        Wed, 03 Mar 2021 06:34:56 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id f16sm31475923wrt.21.2021.03.03.06.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:34:55 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 01/10] crypto: hisilicon: sec_drv: Supply missing description for 'sec_queue_empty()'s 'queue' param
Date:   Wed,  3 Mar 2021 14:34:40 +0000
Message-Id: <20210303143449.3170813-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303143449.3170813-1-lee.jones@linaro.org>
References: <20210303143449.3170813-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/hisilicon/sec/sec_drv.c:843: warning: Function parameter or member 'queue' not described in 'sec_queue_empty'

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Zaibo Xu <xuzaibo@huawei.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/hisilicon/sec/sec_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/hisilicon/sec/sec_drv.c b/drivers/crypto/hisilicon/sec/sec_drv.c
index 91ee2bb575df2..3c26871db12f3 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.c
+++ b/drivers/crypto/hisilicon/sec/sec_drv.c
@@ -834,6 +834,7 @@ int sec_queue_stop_release(struct sec_queue *queue)
 
 /**
  * sec_queue_empty() - Is this hardware queue currently empty.
+ * @queue: The queue to test
  *
  * We need to know if we have an empty queue for some of the chaining modes
  * as if it is not empty we may need to hold the message in a software queue
-- 
2.27.0

