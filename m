Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A8BC43465
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:23:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D61821741
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:23:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="kajG9cKe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgIRHXt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgIRHXc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:23:32 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F1AC06178B
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:31 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y15so4469527wmi.0
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FT+2gDwi+eo+TtESsfWRD1fT3NbLCZL+Gr5RVIpvd9A=;
        b=kajG9cKesfuCLkDVQktBcuffakvi8SBjQK518QnYcvbS1EYOuYrvReyD/u61WuAjXS
         KX7phG9hzjPmBUhc2bQ0zXYL0P2aey1VYjZHot7PHBl4ejNlwkCRrYURYkpnjgp5dCLb
         rPLGWUfRQZbe3eR/NNYsSJ3sTS31usThb58CULqMyqs8M4U2707+TgFZk8ApmAcUVWlm
         fzP1HoXtv3OcIQz3Cqii3zTnvd/tbroprmfToN+AvGfoGD1A44HNhIXRFftwjn9Wk0Bu
         Bch9pOOMJo/HWbjm3Q2ibiyW+w2t5nJCotwuOw65vSIBd1g8FzsOuARu66o851iEBknt
         oWaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FT+2gDwi+eo+TtESsfWRD1fT3NbLCZL+Gr5RVIpvd9A=;
        b=XZJnNlU0SMi1bYSBYiFbPcPiSR64I9N/S5SlR5+cx+EW+aqzBB5SHzUw7cexIXRi9N
         4NkekBm0hXovmrFUh8chcTiy3rfxw6gONxteZbebKTqKS3U3STgYQ4kZBufzYWvDQCCw
         NUIC4Kr8XN49xFqunxcBuKMgKCK9fDw+uc+njIufr6GxDhzwn4lO7ah+VKAh8bRy1KZB
         sw6zJX0T2QPpDArpdroZXyLMnHpM61IzOtuoTirfUD1QrHG0/i7fNVXxo9uP4FFUtXxa
         eOoZwv8Emo9d5kvTWC2l+Qjup1blWfQRo+7qvy0wa8SyFPJGhMtYsEd8okDGf+fTenb6
         Nq4w==
X-Gm-Message-State: AOAM532glpzvOMFonOpbyhyNQqaHcDUx7wOmnqEne8+hG4AJj8baMZAa
        V7yPuFvwhox77/OB7AtIYA3uYA==
X-Google-Smtp-Source: ABdhPJwgYYSuIzrXjZSpjEQwjE+Ch/NO0oWfQmYzsoREzFcKKF64dtUDLBnM55e4X+5xb9gNNvgvIA==
X-Received: by 2002:a1c:bad5:: with SMTP id k204mr14509287wmf.111.1600413809980;
        Fri, 18 Sep 2020 00:23:29 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id z19sm3349546wmi.3.2020.09.18.00.23.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2020 00:23:29 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 04/17] crypto: sun8i-ss: fix a trivial typo
Date:   Fri, 18 Sep 2020 07:23:02 +0000
Message-Id: <1600413795-39256-5-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
References: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fixes a trivial typo.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index 377ea7acb54d..da71d8059019 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -100,7 +100,7 @@ struct ss_clock {
  * @alg_hash:	list of supported hashes. for each SS_ID_ this will give the
  *              corresponding SS_ALG_XXX value
  * @op_mode:	list of supported block modes
- * @ss_clks!	list of clock needed by this variant
+ * @ss_clks:	list of clock needed by this variant
  */
 struct ss_variant {
 	char alg_cipher[SS_ID_CIPHER_MAX];
-- 
2.26.2

