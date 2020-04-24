Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CD0C54FD0
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 13:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0313320767
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 13:41:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="G81Ll6c5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgDXNlG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 09:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727082AbgDXNk7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 09:40:59 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560CBC09B045
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 06:40:59 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g13so10848707wrb.8
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 06:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O3kXCksVkplPGu3RGgTbI+iq8pciZUYI4GkLsC8wbL8=;
        b=G81Ll6c5opzW5zFc63Alaqh/e+btp5X6IQl1HpHHDi6dl0xRO4wvNA9qi3J59TOz+o
         SvXiRP6tetznCFSbdETva7YcrKJmDPcBMJKNIJZJXgO4RpYRS0sWAgEILBButaqg8W80
         TW5Uls5hswSlnuMz0fv//No+aoD9XjRGTWb1ulgHJ7j1xVCLGjNzXQ0Mh/oGWgTND94d
         pgQZhaaJ3DvAWxn1eKeoZpZcc7JEp3EX/WsQO7pD6nvwBYGG5Lcj3dlk38mwmXMFmzT4
         gFSb4lLr6W+VJpwRLk296Jzz3kTCeajnhE4WJLkLXLhFvqPqegy7ZGijF5hEV1mPB7uk
         /OoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O3kXCksVkplPGu3RGgTbI+iq8pciZUYI4GkLsC8wbL8=;
        b=pV+JGD4ecIcsdrYo9v4IPkuOhTYKLELtQ9fxrtErwT7UZuI+lE3ILLUfSp7d2b6WEm
         xxliWPrAudNKNrYYksPwBA4otDG2SvlKKmaXwMMII1CK55eCAfzop4KAYva0lRDctkig
         xLH6CnBeHV910McVGGf472cV1UODkcAlTmRdqOuTw8e9u9se8guVVo3YDVE9mkWkBeP0
         Cc6mMHuHzxNqT5pMalztaZ/EEIR0rEgzVTQyERODP7Nx2T55wEba6cgZjr+oicREOM1N
         yk49tMVT09m/KWSvqbFPvd3ZVKUhkz7ZmzduugOyoOhrAImCWumJU2OjhG/aPCvt5wvW
         Fl9Q==
X-Gm-Message-State: AGi0PuZ+Q0zuqRVEnPTzncIzDgZjir67E42p1xFecZszX+q/Fz9ck2GU
        azOlaLZRo8gKQAYH0vSFDAyXwA==
X-Google-Smtp-Source: APiQypKnTfqip7b5mE8+3UKvsXuGNUavHQ6pIWXq2hDs60y/tQb8fIgLHxsyOKmb1F51FZBX1GVKNg==
X-Received: by 2002:adf:d091:: with SMTP id y17mr10891464wrh.418.1587735658098;
        Fri, 24 Apr 2020 06:40:58 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id 185sm3408958wmc.32.2020.04.24.06.40.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 06:40:57 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 3/3] crypto: drbg: DRBG_CTR should select CTR
Date:   Fri, 24 Apr 2020 13:40:47 +0000
Message-Id: <1587735647-17718-4-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587735647-17718-1-git-send-email-clabbe@baylibre.com>
References: <1587735647-17718-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

if CRYPTO_DRBG_CTR is builtin and CTR is module, allocating such algo
will fail.
DRBG: could not allocate CTR cipher TFM handle: ctr(aes)
alg: drbg: Failed to reset rng
alg: drbg: Test 0 failed for drbg_pr_ctr_aes128
DRBG: could not allocate CTR cipher TFM handle: ctr(aes)
alg: drbg: Failed to reset rng
alg: drbg: Test 0 failed for drbg_nopr_ctr_aes128
DRBG: could not allocate CTR cipher TFM handle: ctr(aes)
alg: drbg: Failed to reset rng
alg: drbg: Test 0 failed for drbg_nopr_ctr_aes192
DRBG: could not allocate CTR cipher TFM handle: ctr(aes)
alg: drbg: Failed to reset rng
alg: drbg: Test 0 failed for drbg_nopr_ctr_aes256

So let's select CTR instead of just depend on it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a5936e967fe2..7c2c09a76173 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1821,7 +1821,7 @@ config CRYPTO_DRBG_HASH
 config CRYPTO_DRBG_CTR
 	bool "Enable CTR DRBG"
 	select CRYPTO_AES
-	depends on CRYPTO_CTR
+	select CRYPTO_CTR
 	help
 	  Enable the CTR DRBG variant as defined in NIST SP800-90A.
 
-- 
2.26.2

