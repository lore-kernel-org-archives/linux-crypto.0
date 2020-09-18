Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62580C43463
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30EBA22211
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="FBjC2lBJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgIRHYT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgIRHXl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:23:41 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1969CC061355
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z9so4471934wmk.1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E3NfwmgIkusrIFQh/foQlCaqxL73ivfTwGYpo+owuO8=;
        b=FBjC2lBJgTf02yY59wYmdUOTO8EzhTzonxlGgL2okMT0KFicBzAtQY0qV8nAQHUCr4
         69vUbx01Qz1CZ0mJ0zOJDes8v7oNqLFTtomIpaxRDZWjalbhpbllRnxbl15ZLaPs70WH
         gkk2Mt95FxliA+8Ogeh4fgvM9H3n6Uy0DcVQk3ocKawBzphUeMuxFBBcOH0LW0KU1zP6
         okmqLAEIJY+L1OYLtqrZK0MTEg32yRwxHjcDsbffj+NrVm2XIJwbOVaXA3p5GoSuUVej
         Z+lgZVlqvxIBojWuiXmr23l3eljiwz1fPKuAhG61JowNzqL0UrCxFEkumljrJqdsriPb
         WwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E3NfwmgIkusrIFQh/foQlCaqxL73ivfTwGYpo+owuO8=;
        b=HVIrjcrvNRVgDZSDNL8SE2LASTkEIQqSn1SdPYgsEbx/GivV9Iisff1Upo3bc0tj0F
         Jpz2c3aPejuKDDx+Ao+fNKJiCGW6z95J17yHZYSQkD0tgk2IY0MKAs2QIjhCQI9z669u
         IkBjUnI8YWYxN+AbmxEfzeOnx9tqXeSGtda2yMJv79Fq+ITwB4PxSHmP+KmONstVeIa9
         eZ/J11MNx0wdBmkBnaa2cDOXUti5matkPUCYuDR5Gh/ROREXdcX4ojwmHcCwfT4pRpZj
         L76VB9tYdqSynwk5KqBgq91t4SSk1EEFO1W7e1vUsa0rN7q0Z7cY57Y4RY9iOuQpLcE1
         2CIg==
X-Gm-Message-State: AOAM531tP9+Ohj967H8TKZI6RwnWi9aEQbuEeF0IXJlEyJckwy6jCiUC
        oNi4MIz+fRRiNDsdXZqobkUjhQ==
X-Google-Smtp-Source: ABdhPJyiEUHG4TOWclIOaejkiufPXE8kBmSlXhj5fEFu4UCDkbLnQ606xYLAMEzyVtWtnzsEJImRPw==
X-Received: by 2002:a7b:c958:: with SMTP id i24mr14673116wml.50.1600413819812;
        Fri, 18 Sep 2020 00:23:39 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id z19sm3349546wmi.3.2020.09.18.00.23.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2020 00:23:39 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 13/17] crypto: sun8i-ce: Add stat_bytes debugfs
Date:   Fri, 18 Sep 2020 07:23:11 +0000
Message-Id: <1600413795-39256-14-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
References: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds a new stat_bytes counter in the sun8i-ce debugfs.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 9311c114947d..c80006853d10 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -280,6 +280,7 @@ struct sun8i_ce_hash_reqctx {
  * @alg:		one of sub struct must be used
  * @stat_req:		number of request done on this template
  * @stat_fb:		number of request which has fallbacked
+ * @stat_bytes:		total data size done by this template
  */
 struct sun8i_ce_alg_template {
 	u32 type;
@@ -293,6 +294,7 @@ struct sun8i_ce_alg_template {
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	unsigned long stat_req;
 	unsigned long stat_fb;
+	unsigned long stat_bytes;
 #endif
 };
 
-- 
2.26.2

