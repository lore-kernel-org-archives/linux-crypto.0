Return-Path: <SRS0=xEWH=4H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DA7C34053
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Feb 2020 15:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99BED24671
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Feb 2020 15:51:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="vsPf0AKc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgBSPvp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Feb 2020 10:51:45 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36122 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgBSPvp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Feb 2020 10:51:45 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so1144239wru.3
        for <linux-crypto@vger.kernel.org>; Wed, 19 Feb 2020 07:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NlNA5caPFDkRRH0y0qsccyBK12IFqz12JUTfxJlSVCM=;
        b=vsPf0AKcpWyPNj6F2JMoW6AtOfj+k/44fPz0eHs3WR9SU8e788OrvazJ4K+MAcaAqN
         INmpJrIB4W7COEiD4pvB+3El/FioM3wJAFyWr64DD6jLRr0/esnS5ywD4R6Uon6cf0yN
         0R4+mXOmfl2a1xQQayyf/1zH8L8S0f3FU1F3zgk6Bx4t4UkR4ebYPNtnDo+qhouPswAU
         gVLHHT5Bzzk3fu2wKB9RRkzxdD9CiRntJXWvGYO2V26GjWgVumFWfmRq9SUIAQacqlm7
         VG1Y3qxLU5VqtyBvVe8/VrgGucpZ1KTA31eE2tnOg6yl+Kuf/WXv5V2A/Yrvpu1ws3+S
         poaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NlNA5caPFDkRRH0y0qsccyBK12IFqz12JUTfxJlSVCM=;
        b=VsvHjeGPwFvqrb9oL9PIqVfAeY76ZlnvJzRQyz5Lu6gRoeoim30WEOn66NkG/FLtVV
         kgUD2uj8Kky82LTbKY9/Ly3qRIH83xUBa33b3RaW8Jov7+9MC9Mtt7gs71v7/z3OBIT5
         ZNqQvOR+yh2v10eNH9XwX/7Wx4lw1TTgMHSxaWZvtk7I9nVFnI8XwaXQvp2DWO5WMPyI
         dhsr1mPD8OdW2/260BSNWLZSHr95M+n4sm2EZ3xqI6y4mJS+Nu2ISMjplpSLyOz3etPo
         sRq4N7+TZ7xJ19tn2Dbn8jcnQeX7+YcVI3SyhhDALXpAtoRgvp9vLCwOLM1Yv3GGk1aw
         0NGw==
X-Gm-Message-State: APjAAAV/jbMdgl9EV7mNbnKIt0SBV7+47Al/x06IomYgzuiQ1wDAno0i
        GW/7I/g5HygqP7v4m3as01LwvA==
X-Google-Smtp-Source: APXvYqyPz9quIQgUnKHU3+UaSMfbxNnk62gkJXMkIlQjMT7rfQaC77nit7zVt3ALZ/CjtPhn7Ddgag==
X-Received: by 2002:a5d:640d:: with SMTP id z13mr35278231wru.181.1582127502904;
        Wed, 19 Feb 2020 07:51:42 -0800 (PST)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id d4sm251578wra.14.2020.02.19.07.51.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Feb 2020 07:51:41 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 2/2] crypto: drbg: DRBG_CTR should select CTR
Date:   Wed, 19 Feb 2020 15:51:35 +0000
Message-Id: <1582127495-5871-2-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582127495-5871-1-git-send-email-clabbe@baylibre.com>
References: <1582127495-5871-1-git-send-email-clabbe@baylibre.com>
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
ialg: drbg: Test 0 failed for drbg_nopr_ctr_aes256

Since setting DRBG_CTR=CTR lead to a recursive dependency, let's depends
on CTR=y

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6d27fc6a7bf5..eddeb43fc01c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1822,7 +1822,7 @@ config CRYPTO_DRBG_HASH
 config CRYPTO_DRBG_CTR
 	bool "Enable CTR DRBG"
 	select CRYPTO_AES
-	depends on CRYPTO_CTR
+	depends on CRYPTO_CTR=y
 	help
 	  Enable the CTR DRBG variant as defined in NIST SP800-90A.
 
-- 
2.24.1

