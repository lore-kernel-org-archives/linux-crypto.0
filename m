Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982C9C2BA17
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AB7D206E9
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:51:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="oTC8E0fO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgDCTux (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 15:50:53 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38047 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727593AbgDCTuw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 15:50:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id f6so9012349wmj.3
        for <linux-crypto@vger.kernel.org>; Fri, 03 Apr 2020 12:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JPGH//guNKXE+zw41mQiI9K56gZGeqLsPljirbPkDWA=;
        b=oTC8E0fOGssBxycTlFxGc5xx1oGSLXbNDvBvKosjDidLGr48hSossWLYM0KZigOptZ
         YAAtgwVJT3V6AW3KvWpvdSLfBe2WYYiAQ4pm3tqJNDw4SsjmCdubD2xam8FVAP2eSjrR
         byJESroXjDP2Sj9enh9tZm/Je857QdVz6kJkA5qsFOhjIcGDtTAanvVWudXfqe9yIuB9
         eB9SLG4ado0P2ITngZHDhfKb2ghxqlfk3m7sSlOO+CEpL/pSPsbIu+eSaBhWt6hWYoS6
         JgqyDOhQvWYJU7Zj35xuD9AJCJ9qJREu0wA1ugn+NMW5Uo9e5Uj9Ti7YEQ/keW1fScl/
         IuoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JPGH//guNKXE+zw41mQiI9K56gZGeqLsPljirbPkDWA=;
        b=caKs2bl6VE/6VlYqe6tYP1LjjVqzA3uywJSW5HLBq9G66fV8KuZH63MVFhh8ZSIVyx
         eq83uh1WZrP5+dNkxnruBqpCXgEUsKhurujSEeek+tQVhAjzPh/T+OpryQQWhjQTC7eE
         wOhN8/HKzlQFBLJcZ1P2gytIU0x85P/aCgRr2kKpa0zpWOdA1tCr/BdKer8truniyL1g
         elXerO2tvk2AhSiN/C4HqrJq8lg/MEfYLa00IGMcCqcZbeyEk3yMgbFcqgi2jckE/FQX
         /mtZced2zIwzwp2mCiZrfog+inGJdKLryNifbb1dmz/bRKihNE37xXSe1YEUuM4D1wqS
         fivA==
X-Gm-Message-State: AGi0PuYQ0bQMZLBSjGoYqzGPdAG41d56lW1gPF0ssc8U5ulqQhK1lwXK
        R3aFgEzww1/PULO00uV+FTIDYg==
X-Google-Smtp-Source: APiQypJEbUNkRzvYEwZksUdMc+GOiGb1oOeidTkof3qLE2rcJOLmNJKIfsDxMpHa2IfgnELMwfr6uQ==
X-Received: by 2002:a05:600c:2c06:: with SMTP id q6mr10472251wmg.42.1585943448931;
        Fri, 03 Apr 2020 12:50:48 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id c17sm8102448wrp.28.2020.04.03.12.50.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 Apr 2020 12:50:48 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 2/7] crypto: sun8i-ss: Add SS_START define
Date:   Fri,  3 Apr 2020 19:50:33 +0000
Message-Id: <1585943438-862-3-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585943438-862-1-git-send-email-clabbe@baylibre.com>
References: <1585943438-862-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of using an hardcoded value, let's use a defined value for
SS_START.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 2 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 6b301afffd11..a5cea855e7d8 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -61,7 +61,7 @@ int sun8i_ss_run_task(struct sun8i_ss_dev *ss, struct sun8i_cipher_req_ctx *rctx
 		      const char *name)
 {
 	int flow = rctx->flow;
-	u32 v = 1;
+	u32 v = SS_START;
 	int i;
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index 29c44f279112..f7a64033fc03 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -13,6 +13,8 @@
 #include <linux/debugfs.h>
 #include <linux/crypto.h>
 
+#define SS_START	1
+
 #define SS_ENCRYPTION		0
 #define SS_DECRYPTION		BIT(6)
 
-- 
2.24.1

