Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E114FC433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Mar 2021 20:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99DE36198F
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Mar 2021 20:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhC2UMf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Mar 2021 16:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhC2UMJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Mar 2021 16:12:09 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13628C061574;
        Mon, 29 Mar 2021 13:12:09 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id x7so14058232wrw.10;
        Mon, 29 Mar 2021 13:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8g3Xjbg3fbahjoByRE/+tcyx39UgnhRllmKIjvIgRw8=;
        b=cTxPpZhDQBZUbDbidcDkLHqzoEgcLAB/KfBM6N/voAnoirI6g8+XiYtvT9+RGABvGz
         UYt0XVO4gH3xqgImlqvDZWuyHOgnSsdGk2jUTtPO5sfBictaiNqCxhGQ9hzpN3Ki9Goc
         SNZVtCKexi+Y0OEmRTlzeKqJAFb1AYIyVKP8iP2Nv1FxDK3CcZKP3nK0LFZleefqRgmZ
         RqpR2D+wOZlE2aWmiL1TQSx3E34xmJmyrueFw62FUNcNS0/7wEEkCoMBMPAUrLNu1tBj
         YscGctX2NP1rnJ+KDeK6aPvpQjpif5uh3qbLpQ3Uz1STip+uiIvQhnMoADf3e4QMLWJv
         J4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8g3Xjbg3fbahjoByRE/+tcyx39UgnhRllmKIjvIgRw8=;
        b=rvP0rfe6sUqRzR6RSRVBjhaa/QmzYzpizbhR0hjog6Q0i9ViTwXwgz54p/w5d0VgAk
         M0pU+CT3RcByrRyR8QvStHI/mnnYiMAwkyIqBn4XgfcSPXL/dO9/E37W6fClwx/8Z48v
         ClzoiUO8TsEI/9RKNdie9nF0DxJB8SPLiRr8xGK/9u+wHqGYRtUUPkKTQPPcj4tX19Ih
         geFcYAcxgHZ8bZto7cziQaLZ/RyZ11mVAOBNMkAAlocFnRG87odStxsNvbWN28QR+rDE
         aA04dKr1HzJW4XbxoBz/Oyb3jGvM2Jl0vz7lvnCMtp1j68XUvZuvI6ybi5LY/honjJ8l
         LBFQ==
X-Gm-Message-State: AOAM531tsCdcpeSEh2BWsoHIPSCHr/Wf9kG8r/28VEfYBWf3MjTova4p
        Zoww+ybC5KH0ASFBGzfeDZw=
X-Google-Smtp-Source: ABdhPJzrwnglFwIvovMh0hC4BGRnzOYdgQgY33rTN+iw3SrcE958bn1KI1ik6mKwh1tlxIPCyKbw+g==
X-Received: by 2002:adf:ff8c:: with SMTP id j12mr30192112wrr.297.1617048727877;
        Mon, 29 Mar 2021 13:12:07 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id l21sm436993wmg.41.2021.03.29.13.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 13:12:07 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, wens@csie.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: allwinner: add missing CRYPTO_ prefix
Date:   Mon, 29 Mar 2021 22:12:00 +0200
Message-Id: <20210329201200.1089-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some CONFIG select miss CRYPTO_.

Reported-by: Chen-Yu Tsai <wens@csie.org>
Fixes: 56f6d5aee88d1 ("crypto: sun8i-ce - support hash algorithms")
Fixes: d9b45418a9177 ("crypto: sun8i-ss - support hash algorithms")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/Kconfig | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index 7e2d2738b237..ef7ed21b053e 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -90,10 +90,10 @@ config CRYPTO_DEV_SUN8I_CE_DEBUG
 config CRYPTO_DEV_SUN8I_CE_HASH
 	bool "Enable support for hash on sun8i-ce"
 	depends on CRYPTO_DEV_SUN8I_CE
-	select MD5
-	select SHA1
-	select SHA256
-	select SHA512
+	select CRYPTO_MD5
+	select CRYPTO_SHA1
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 	help
 	  Say y to enable support for hash algorithms.
 
@@ -159,8 +159,8 @@ config CRYPTO_DEV_SUN8I_SS_PRNG
 config CRYPTO_DEV_SUN8I_SS_HASH
 	bool "Enable support for hash on sun8i-ss"
 	depends on CRYPTO_DEV_SUN8I_SS
-	select MD5
-	select SHA1
-	select SHA256
+	select CRYPTO_MD5
+	select CRYPTO_SHA1
+	select CRYPTO_SHA256
 	help
 	  Say y to enable support for hash algorithms.
-- 
2.26.3

