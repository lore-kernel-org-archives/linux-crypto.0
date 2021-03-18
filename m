Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA2BC4332E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D18A464F8B
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhCRMo4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 08:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbhCRMod (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 08:44:33 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CEAC06174A
        for <linux-crypto@vger.kernel.org>; Thu, 18 Mar 2021 05:44:32 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id z2so5377702wrl.5
        for <linux-crypto@vger.kernel.org>; Thu, 18 Mar 2021 05:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cqK2Pp2ViTz0xdgYhapttz8LcH4etuWNmG0+y0P94Tk=;
        b=OA9EIYsInkm8+sbKDz65mq57blKnFk/VyB2KwDk4y5vDgz6vnx4e19aC7mQ4UamzvD
         8axwr/dUv/8a30fI7OPHVI6nG5Hpj237RPlR9w/4Me0kWU4D65vEKauzTCHvM4TXlXqt
         Ye7le7bu5vxmYtgQ29JW01tPCw2+eLDnmKkReOUOeOlRJm3h00gybG0Sn/tofbARn+4v
         Nk5YEyh5SBRVM0kgOl5TGaU9YS4XgQ5LCG97a7VD6aXvKM0TL921nV8IgWxH1wHDN7KQ
         WXx50dqy7LYZI2p5efB/j3TTR1hXGzQgwh9pxXBQSeD7rVwlAxlcvUqX9+LFOEy3NaNA
         gkPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cqK2Pp2ViTz0xdgYhapttz8LcH4etuWNmG0+y0P94Tk=;
        b=NHaVg+bhx3pBz8lb0JO3pKJJfV/Svo1esb0SUriIIKWLDssma8oNxhbDFIBXD2xPqf
         HJkisp7BdiePcILUQSeCvPTKFzyzBLIQiZ2TbD5oc2hYt1BFV8cneFKijEYNgcyhMFpY
         8mMttSe0lfeu2iNnzEMZzgvJcfy3TnFz91z9hufC/rw1YYykmYPKyiCSTcbGZAe6qLCE
         RRtjD8pfDE0zAjZIDUUgO+X9w4nz9NJvc+Wh1cpvj2OtPaqkSUVOcdQxhNDzxf3GE6zM
         KKs/4FYJhEwSgin3QMe7budQfw0nHllmC7iiBrRNJrbGSmRXjD1RI3iglc1zJYb6oyLv
         AquA==
X-Gm-Message-State: AOAM530yIs6/UyYD0OfVHefXpn/tFsuXh/f9V8LHlNi5uPgjLHDwKYdD
        TIqi4sNePo8O/5ryxvyOpGhfuw==
X-Google-Smtp-Source: ABdhPJwV0CtMRkwCaOXy/5vvgsMtNuWjcOi3sZABwA4HMtXR7vy5o/de4/orKnRynrT1wJ3qUCKnpw==
X-Received: by 2002:adf:ea8d:: with SMTP id s13mr9585919wrm.32.1616071471400;
        Thu, 18 Mar 2021 05:44:31 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id q15sm2813900wrx.56.2021.03.18.05.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 05:44:31 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 01/10] crypto: hisilicon: sec_drv: Supply missing description for 'sec_queue_empty()'s 'queue' param
Date:   Thu, 18 Mar 2021 12:44:13 +0000
Message-Id: <20210318124422.3200180-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318124422.3200180-1-lee.jones@linaro.org>
References: <20210318124422.3200180-1-lee.jones@linaro.org>
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

