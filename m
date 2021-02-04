Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FFAC433E6
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACDEA64F58
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbhBDLLF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbhBDLKq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 06:10:46 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6071AC0613ED
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 03:10:06 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id a1so3005453wrq.6
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 03:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t1Hcpu/GsWIJa0ISm8bZ6HXe5H9dtQ9e34hCFzoGJVs=;
        b=GqGjTH3exPZnUvuas4XWPGoETlhvPot3+TvjkOlDnxXoe1coZAt2hy/jT3XKnkw6fh
         LGklIUq3zBgQ9jgyWRbi/e2qTa+QBTpniwrYo+NSlKVCjg/KQXXeNmb8n13P0g8F8yY1
         n3drLix+WlfPPYGTgkDxPcesnJ9vYZm/dLFPMd7drEiwSFEBeRSD0Iz8LbUhQ3IOQyK5
         2bLD5kx6MQnR72F7ZbfJeM6Oy6gvgo5De/X1RNQ83wcQ368guKzegRsbSnin3uejNjhn
         F13499ZOFCdtjxeGUrJ420lTbM4Mrem03vUVRJM0wFzInoE1iCVzRjouEFhNKsTKt3NY
         WEqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t1Hcpu/GsWIJa0ISm8bZ6HXe5H9dtQ9e34hCFzoGJVs=;
        b=HIerv+6t533ONosw3NVa9RsQZa8cHKsh5v1zj2CbWU4gwu+MenDmK1ctjZmh+6lhYj
         +pGiPH8IjdlHeQkc+KGYjBOjYF300oiXRcS0PbUAE7PgHPHKWf9RGUF5EQ/vQFFV1/19
         xr0+rmof7jEzJu4mlIpYI1Kw0qnCJaaeExRsZoxRhzwIFlCMHoG77/TJslVtrbHx6iPV
         x5kDdEfbEvmqjzOxsvr81lj0PuCTKvp3nXliCifUt2JAjcXEbPT2WTpD7QjsxgYamnbA
         RX6dUcZFXZq+u1eoRsP8jF6JNm9QYT+N0crwOo4Ijx1ny6V0/n6tP/4zqy2l0STrU6qQ
         urBw==
X-Gm-Message-State: AOAM531Sx7eNqt9e9rJm2oh7zSCkyMD3Y5wwqqi9w80lUzq2FzwcqYl3
        /pZN6Hjbz+SD+JtxZUJ1KBKfpg==
X-Google-Smtp-Source: ABdhPJwjdkC95lnOwPsXjE3KbW1ymbODYl/4EWoKmla9E92T0UEh0s4HJSxjepfmFWLxqqxeWowLog==
X-Received: by 2002:a5d:4142:: with SMTP id c2mr8797431wrq.359.1612437005106;
        Thu, 04 Feb 2021 03:10:05 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id y18sm7696218wrt.19.2021.02.04.03.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 03:10:04 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 01/20] crypto: hisilicon: sec_drv: Supply missing description for 'sec_queue_empty()'s 'queue' param
Date:   Thu,  4 Feb 2021 11:09:41 +0000
Message-Id: <20210204111000.2800436-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204111000.2800436-1-lee.jones@linaro.org>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
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
2.25.1

