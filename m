Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97563C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Dec 2021 10:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241709AbhLOKmx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Dec 2021 05:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbhLOKmx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Dec 2021 05:42:53 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04648C061574
        for <linux-crypto@vger.kernel.org>; Wed, 15 Dec 2021 02:42:53 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id o13so37314101wrs.12
        for <linux-crypto@vger.kernel.org>; Wed, 15 Dec 2021 02:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u39bS1Cb1q0ZvFivSQ0bPVUI1WzG2lEMqJpYNQJ7sMI=;
        b=E1qBKLCc9Y8v6XbRVioDhnmFJ97IRzewurZphcXXEqw5wsswfYoLqbeRvJUaoKL+Kf
         83KEeiKEq4nFnpY/0oLwbmDOj90h/9S9a5/THImR1X8j7UoTiwjGSzSn0PWLowGlcjTS
         uL3M1l7cmScfSmSBXTdxXilFHCXLlCX/ZwBww9q8CculQwHzPeGDnNP72sEcwouMrvFT
         wBoPcvhqXD7A8K03SLA/VCzcf8p917SCQoI9OF0D/+F1OeWm8X2U+sUZjrfh+hWV92ih
         j8gBrvemBVvO1Z9lGTPBbv+0V07Zyg0nD2BylG6hZbrOloHtw+4EODtI1JkU4iQ9qFQu
         ht2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u39bS1Cb1q0ZvFivSQ0bPVUI1WzG2lEMqJpYNQJ7sMI=;
        b=WdehpHiEP54QMvzDwoQaE08lx0J+jSpflSzJWTdCeoFmgRrd0gQg5aVorQ+gwkRUCD
         JjbUp6jm938rH/U3qtKDHVbsNUNqetpAdgs1QgPzh/MM06XLFssnk7skwa4WEzLPX4EX
         h5SpXWGfQURPZAsh/g1dJuDgSnjNc5JIWESqVa1IW5pYTiLNwrMnUe/0CwCW68FjQfYq
         yDOf3qqTBZZuycvYFMrutdinZJt7pnrA9+V7Y894UG6SZ+2A0oF/9Wrvd5kceS7xCEsG
         meBWGpz8Z+H+06LThD+NxLz5w+NAlzGwFWv95hwhc/lNf0g65Ct97ZSxV6KissuGGGS4
         cuvg==
X-Gm-Message-State: AOAM530KtEwPOf7Svv2g0ooI1qJzPHn4aNJG/2hdMMr56WnyIvHBA190
        k8LiPlKhre0sATG9fsgmd27kRg==
X-Google-Smtp-Source: ABdhPJz4cUohwpfTnswYYZh8vQE9RXm72Qv04LqhD754Vz22/rCynZ1rpfgFnNjQk03c7MKW0POHtQ==
X-Received: by 2002:a5d:4ece:: with SMTP id s14mr3939045wrv.371.1639564971518;
        Wed, 15 Dec 2021 02:42:51 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id k7sm1643494wrg.105.2021.12.15.02.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 02:42:51 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: omap: increase priority of DES/3DES
Date:   Wed, 15 Dec 2021 10:42:39 +0000
Message-Id: <20211215104239.800193-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Give the same priority of OMAP DES/3DES than OMAP AES for being sure it
is picked before software implementation.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/omap-des.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index be77656864e3..538aff80869f 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -735,7 +735,7 @@ static struct skcipher_alg algs_ecb_cbc[] = {
 {
 	.base.cra_name		= "ecb(des)",
 	.base.cra_driver_name	= "ecb-des-omap",
-	.base.cra_priority	= 100,
+	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	= DES_BLOCK_SIZE,
@@ -752,7 +752,7 @@ static struct skcipher_alg algs_ecb_cbc[] = {
 {
 	.base.cra_name		= "cbc(des)",
 	.base.cra_driver_name	= "cbc-des-omap",
-	.base.cra_priority	= 100,
+	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	= DES_BLOCK_SIZE,
@@ -770,7 +770,7 @@ static struct skcipher_alg algs_ecb_cbc[] = {
 {
 	.base.cra_name		= "ecb(des3_ede)",
 	.base.cra_driver_name	= "ecb-des3-omap",
-	.base.cra_priority	= 100,
+	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
@@ -787,7 +787,7 @@ static struct skcipher_alg algs_ecb_cbc[] = {
 {
 	.base.cra_name		= "cbc(des3_ede)",
 	.base.cra_driver_name	= "cbc-des3-omap",
-	.base.cra_priority	= 100,
+	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
-- 
2.32.0

