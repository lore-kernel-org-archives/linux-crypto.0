Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D519C43461
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F97F2073B
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:37:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="JXzM4BfF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730044AbgIDLhA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729959AbgIDLKT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 07:10:19 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA630C06125C
        for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2020 04:10:17 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id c15so6293252wrs.11
        for <linux-crypto@vger.kernel.org>; Fri, 04 Sep 2020 04:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=liOvMqJ23zZD+1Jnxjs/VNAD87FK/p7rypoysOK5cqw=;
        b=JXzM4BfFTGoVXCU03k/7IUiSQHrxJgQsHmuSQQwuWK/viG1URNM96o9ZAdRx0EIGSb
         elSdZIcLzXTqSkRorVqU1ErU/6CEWhdDf6lGxCSOnv1DYkASJwxXyzzOCPlo1tbI1aar
         Oc73uBtG5rUBAb57rzeDmYsLmq1EptRm450cS0J7NlaVQWBFOWDX4kPKe+jCO8bVkop2
         sTxZaHaUGtYTx3sC2lRGXLpGOtq+LDvAACH6YlOwuBUyYkUYmbka6ne3P9y7I/G6ZeOo
         /AAT7rVVPjc/McFKZ66c+/e1ygFjPOtBZL+YhL+NscQmWcSITuC+xiEoYfKS+Gip4aQL
         G4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=liOvMqJ23zZD+1Jnxjs/VNAD87FK/p7rypoysOK5cqw=;
        b=DD78vVsx8AXuywQrbyjinN0GZr2hWoymTNTTNIMRi6dWXD4knGGmik6+nTrQYeFzPH
         BvwPlvsXl82wmI0IMQSjVm1+PoJTmLkKfMvtV9IiF9dFmLmIPt07xhgAoqiB/lIz2jGO
         mjbqc957pSmoo0Q4ugdfuXamjQ9Dja6ElFTkDO+y0V8PJIuco5o18kjW9c829OhsrfKg
         Ufo/csIy5SJGlPyvb6k98NqqMMFmRaAa6elz1zDNAYYxjKtN4U4GnN1tHO+mxbY6nyCB
         GA5TSYUoqdny+w7cf92Q65HQayVJOI4Y6rjSuBUUqCvIBI8WBBabshE7TjZVBBMNLvkz
         +Yuw==
X-Gm-Message-State: AOAM5323YZGeOB5B6CoP3zwH+wxYN5xrOMYtgc7h0s4efxToJ0dc4eGT
        i8erPiSQDfFtzBEjQBBOU0IbNQ==
X-Google-Smtp-Source: ABdhPJzLTD+PvBpI825a8vjh5Zb1BAwwnZrkhMUvoKWAHNONldwOpr4en9aR59rdJI6NBuclLymfRA==
X-Received: by 2002:adf:ff83:: with SMTP id j3mr7339891wrr.135.1599217816535;
        Fri, 04 Sep 2020 04:10:16 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id m3sm10622743wmb.26.2020.09.04.04.10.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2020 04:10:15 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 05/18] crypto: sun8i-ss: Add more comment on some structures
Date:   Fri,  4 Sep 2020 11:09:50 +0000
Message-Id: <1599217803-29755-6-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599217803-29755-1-git-send-email-clabbe@baylibre.com>
References: <1599217803-29755-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds some comment on structures used by sun8i-ss.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index da71d8059019..1a66457f4a20 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -195,6 +195,8 @@ struct sun8i_cipher_req_ctx {
  * @keylen:		len of the key
  * @ss:			pointer to the private data of driver handling this TFM
  * @fallback_tfm:	pointer to the fallback TFM
+ *
+ * enginectx must be the first element
  */
 struct sun8i_cipher_tfm_ctx {
 	struct crypto_engine_ctx enginectx;
-- 
2.26.2

