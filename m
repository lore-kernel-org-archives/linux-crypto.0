Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FDB5C433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1020A206E9
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="LSeK1xGj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbgGUTHF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 15:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730450AbgGUTGz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 15:06:55 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47A1C0619E0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:54 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 184so3951848wmb.0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B84TBgeETkt4nO+wKVIpW+Ds3pJrpx/FZNcZ1KM26KI=;
        b=LSeK1xGjBnv8i4W04Dv4ztwC2TBRXXgN8Xc6t6/bhSIP/UzM0Vswn6OOYXKnOYU/L3
         0PizVcS3eWp7ZJMHM5kqovoCp+7VnwK75XTxaqTxipR1brGb3WKstpkxmsXwgX4McnKx
         7k4cbnH6uzuUg2sNnC4gvMRyPosScPDQdQtcoGrcKPe3k4d00/3kR/aaKgmN70+Neioe
         Sh5IAJ868Xmt4sPqmluJxzZTDYm7zLpIaarTaRUevAgd6Sx+rY78iJnQlxO+OxKHsYHW
         9bCbvbcVjQd+44i8XHp1nJzii5LY2/5yGk77gavPNnXfEQI+5sGOoHuKLhIcYjIQWxdg
         z6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B84TBgeETkt4nO+wKVIpW+Ds3pJrpx/FZNcZ1KM26KI=;
        b=NHNWj0PFFkC3OQNY1qwkXbbQqij2MfTrOQIUuO7bdC9EjKk+0Kq37LPCWJqILv7RC6
         TFcZ90yMDIJbnlW1T2KHldaJHGQtYsOytwyWvD4u5WhbA5qXutlOhDp4YTNOSk1GtVk0
         ZsWjE16p7lSEjR9VzXTJpHe2eO41E3Ptr/ypLLy7I7FNCUy/5DiZUVwqeF6UeD+E4B6x
         Lhu15X1q+dCLGQBamCi5wC54RNwsWXSAs869vW3e4MDszhVAFD2TRqzscenl8DtQJr3c
         GapmU6FqKqsxYy7Wn8kWN+z+KyAAzDS0IcSYK3HZcuMMlc53bKAmqgLV2uhTokjKvBPR
         plog==
X-Gm-Message-State: AOAM531YJSzlpydxn3333Z6ISWVQtYvA5A2llOdu4icn0dZWStwWXy1t
        ZgnJUgJIi0kMh0UFicH8lFOquA==
X-Google-Smtp-Source: ABdhPJy0cpGwHpuP7n9I53pUkU64JLL1SBHkZHHfNDR+jmd4j0T7R55BkSFYsbbYXWWgQEPg8kY/2w==
X-Received: by 2002:a7b:cb98:: with SMTP id m24mr5261799wmi.98.1595358413672;
        Tue, 21 Jul 2020 12:06:53 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id s14sm25794848wrv.24.2020.07.21.12.06.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 12:06:53 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 13/17] crypto: sun8i-ce: Add stat_bytes debugfs
Date:   Tue, 21 Jul 2020 19:06:27 +0000
Message-Id: <1595358391-34525-14-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
References: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
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
index 6bbafdf9d40c..910b510d7bb2 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -276,6 +276,7 @@ struct sun8i_ce_hash_reqctx {
  * @alg:		one of sub struct must be used
  * @stat_req:		number of request done on this template
  * @stat_fb:		number of request which has fallbacked
+ * @stat_bytes:		total data size done by this template
  */
 struct sun8i_ce_alg_template {
 	u32 type;
@@ -289,6 +290,7 @@ struct sun8i_ce_alg_template {
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	unsigned long stat_req;
 	unsigned long stat_fb;
+	unsigned long stat_bytes;
 #endif
 };
 
-- 
2.26.2

