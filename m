Return-Path: <SRS0=MzAP=55=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E88EC2BA19
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 10:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B1E12073E
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 10:06:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="e1WrT4Kc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgDMKGV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Apr 2020 06:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728173AbgDMKEn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Apr 2020 06:04:43 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2648CC008614
        for <linux-crypto@vger.kernel.org>; Mon, 13 Apr 2020 02:58:24 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o81so3266355wmo.2
        for <linux-crypto@vger.kernel.org>; Mon, 13 Apr 2020 02:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KJ5PBE+QCFWEenkZ4gUgAJxpbhutHi1vjlsaJ3JQibs=;
        b=e1WrT4KcRVi9wuVJVygj8vhAkk71TGHmHpMYTjCJuHliLGWyDssU9cGqkK2CSWVejb
         4tT7JgSQKtWSPtNh3MjeQe8Xag+jQXEUvDzA4/c/aaEnJYs60cHLHBhujmeY4hi+2jOZ
         QOgTyQT1PBEuG3CNM4Dzr7gnqon6jRP/XbvFjRMA5pLCqDH5m4NWksv6aOpkM35twxc1
         C5RVOi9OWRzoAxTOoZeZX/Rqh/7Sb5KQ8kMAoxCxBZfIrd4KOqCmv7p62qTS15T2tZaM
         4LPqKZuEN8KUTxxGwhYIznawduuzubHIjr/o+hRL6rcZfZRKmub0W2+6H1q20NktRFAE
         pIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KJ5PBE+QCFWEenkZ4gUgAJxpbhutHi1vjlsaJ3JQibs=;
        b=hIZgzqT2pQ2pxkWKK0E3LCn8rU+7Qm4d7KJUtAkPDU95QCCqKctZKNM5D7jNu2UkGE
         o4/YHZdrlRqpete/HbSCkD56zqw+gZvjJ9XtnusAzolKvi7qcC3zZRvAoJ87hDButCyH
         IZwcHafFeC9nYYsI5vhcdS3+dVgdsa4BvChN1fSC6KcIe4t5p4lNmkp0Ce5mWEiW8FZQ
         zIsiN9zzAFj1P5QTp26218E7yChbr5nch6hIx9BVjs3Hc/wWZ4ucM0QdoG7FR3JOryjs
         9whxiMKUm8Dymbf54/oJSsdgFJICSAp/ADUawfXZvRCqOSmeJmunmNiVm/s9hMFBG4NP
         uA9w==
X-Gm-Message-State: AGi0PuZ8/y8JOYOe85mPFcYexBFYhWJXCnyXK1PwZ8Pry9PPk5ndTKE6
        VFxfF1VQEp4DSjcVcWMi+li/PQ==
X-Google-Smtp-Source: APiQypI8Oui5Njp9cGwOgZMXxDuOowTpat6FLkW6gIqG5p+5OQvCmGnkx5jBVxT8gj6Q9S2kjdEoxw==
X-Received: by 2002:a1c:c90a:: with SMTP id f10mr17527326wmb.179.1586771902925;
        Mon, 13 Apr 2020 02:58:22 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id v21sm13594491wmj.8.2020.04.13.02.58.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 02:58:22 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 7/9] crypto: sun8i-ce: Add stat_bytes debugfs
Date:   Mon, 13 Apr 2020 09:58:07 +0000
Message-Id: <1586771889-3299-8-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1586771889-3299-1-git-send-email-clabbe@baylibre.com>
References: <1586771889-3299-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds a new stat_bytes counter in the sun8i-ce debugfs.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 19ced8b1cd89..ef2f1e5aa23a 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -274,6 +274,7 @@ struct sun8i_ce_hash_reqctx {
  * @alg:		one of sub struct must be used
  * @stat_req:		number of request done on this template
  * @stat_fb:		number of request which has fallbacked
+ * @stat_bytes:		total data size done by this template
  */
 struct sun8i_ce_alg_template {
 	u32 type;
@@ -287,6 +288,7 @@ struct sun8i_ce_alg_template {
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	unsigned long stat_req;
 	unsigned long stat_fb;
+	unsigned long stat_bytes;
 #endif
 };
 
-- 
2.24.1

