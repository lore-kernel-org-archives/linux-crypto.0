Return-Path: <SRS0=YBhh=TS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BE9C04AAF
	for <linux-crypto@archiver.kernel.org>; Sat, 18 May 2019 21:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C430320675
	for <linux-crypto@archiver.kernel.org>; Sat, 18 May 2019 21:28:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jqwsd98C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbfERV2P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 May 2019 17:28:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37727 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfERV2P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 May 2019 17:28:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id e15so10524964wrs.4
        for <linux-crypto@vger.kernel.org>; Sat, 18 May 2019 14:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LR0/tiq4ddUgfYUX6hacaYLf6IMLrXRZI5ELFE1jzoc=;
        b=jqwsd98C4kebn39BeYA4RMN0gAgI0zfIg9aRelBXGFvjrqrRMrDdLZCeMFvYIxVSeg
         vX6/hCOSw/j9L6iZgmWi5xAumJb7ZCIN7TTAF6kIMy1n7yZMDVO0gbpEa8q77x/pcyRr
         UUsTvVpEzx77giFv3d/S4bLJUrxbIuo+TZpLzvSTs9ZiTWoQ79tJTqEl70FYg3li0hbk
         fBJo76vgins+RC5SlgAA9U2z8Z2Uz18qCRbXT7ZCiVdcdRLjfU++fTziHDPlzHvoBuBr
         NQWhK9EgYJwtfDLjbiGxNaXjwDmDZKPMozdbyHZD+EtiEVYQDfl+8vXtB5EG6pgBgWGq
         46VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LR0/tiq4ddUgfYUX6hacaYLf6IMLrXRZI5ELFE1jzoc=;
        b=R7CFyVEGv6D4fbCp58FDWHLeOHobN4wic2HrLwYIf6J8FYEfrviuhiyj69psyb3KgX
         yqegvbv1PZ+OpZCDLvCeSx0T3PGovEhH77aTReryjsFQt95pCls2rwVLjMR3iYN4rUzu
         8sQFBzkKHfR9/g78YTdCiGRQ+NnWALh0AwjIV7YwGviJrafEBeQqD5ElpBc3Hx+bx1Ch
         gv7jzWqvERz5mOMRfq8z9EN1hEtoE1Vwlr3Ub8YKsoIiRe4xA3qYckuaG8hKzGDJa3ge
         DflGx2qR/fiMblGd15dD9F04L8ezYQhlB3r7pfNRpN3apAWlsy5BSR2raUgverOpOEe4
         DeDA==
X-Gm-Message-State: APjAAAU2zMKqmo8gJJaK4LKV9tsq6GAZhs6iCe/4rLj664L39sPT63ac
        QyA77rKv2njNKhWMkzLAO/CU/61F
X-Google-Smtp-Source: APXvYqzwzqAmWWfr91hV6VWSiCZK3jWAKV9gke44CUAf4awu8NbWHH2oqPHfJATtA2fHxf7ilhfgAA==
X-Received: by 2002:a5d:54cc:: with SMTP id x12mr3109675wrv.303.1558214893559;
        Sat, 18 May 2019 14:28:13 -0700 (PDT)
Received: from debian64.daheim (p4FD0962E.dip0.t-ipconnect.de. [79.208.150.46])
        by smtp.gmail.com with ESMTPSA id y18sm13304227wmd.29.2019.05.18.14.28.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 18 May 2019 14:28:12 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hS6sG-0005a8-14; Sat, 18 May 2019 23:28:12 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: crypto4xx - fix blocksize for cfb and ofb
Date:   Sat, 18 May 2019 23:28:11 +0200
Message-Id: <20190518212812.21414-1-chunkeey@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

While the hardware consider them to be blockciphers, the
reference implementation defines them as streamciphers.

Do the right thing and set the blocksize to 1. This
was found by CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.

This fixes the following issues:
skcipher: blocksize for ofb-aes-ppc4xx (16) doesn't match generic impl (1)
skcipher: blocksize for cfb-aes-ppc4xx (16) doesn't match generic impl (1)

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org
Fixes: f2a13e7cba9e ("crypto: crypto4xx - enable AES RFC3686, ECB, CFB and OFB offloads")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 0322ae8ac466..5f2709cffc5b 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1231,7 +1231,7 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
 			.cra_module = THIS_MODULE,
 		},
@@ -1311,7 +1311,7 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
 			.cra_module = THIS_MODULE,
 		},
-- 
2.20.1

