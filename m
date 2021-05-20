Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CCFC433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 19:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC802611AD
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 19:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbhETTih (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 15:38:37 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:21429 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbhETTig (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 15:38:36 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2021 15:38:36 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1621539073; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=OE65IJFw7vqwMzx55fnN8ooaONM55v+ilUf5u1TKvNKhGI4f6F4MLxCukD4Zauti3R
    Z2aiOEK//JQYZp3DPtHUNPU2LtpA9rzH3rX1Zj01zQxdRwYVQpxr3wQVq9DcxXSJil2Y
    D3fWlDR9KGG20TKUQxefeyt7VyfDHexPJgXVrX3NDTvg/FFE3rz0khaPHOQfTMNuF5vX
    TVQRypkPCzIT8toJhY9MigvIwYuQirWaVAhpGQ7KrjWwW+Ge+qT5kWy4V+/Cnl5g/wgr
    SwpTApcRbEvepkOH7n62A/ISSMbUE+HKH4FuZcuK5FptC+s5AxjGesdsX8RM+a/BnmW8
    45rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621539073;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=cmA0CcMD/U9YqBKObfXooA2cVKegWzGYs4H8toqG9Vw=;
    b=Ap3VPwy1QZPaAvEBBHtauiM0cmt8+s3vAdh/pjBubyfObCybrsx0vgb/nbeJb8TeSK
    3amR+mB1AlRaETB0nNTQ0OXScNWRRmGDx0BpFk/HLwzFdOJrnGvyS2vKMvAxm3HzRcDd
    Xco/jZQHcFMqQyCmEZmdoTf0HPniOm+HbD1sQECYjwRMxPB1asVYWnS2AW8i2pfl5oF1
    d9A3XaaHT7gKbtoef3CdXKgCWDCdlvVEjxmQ4qP8mkciJ/o2RrzYb9NuVTA2zUB+6FyL
    xyv4a0S+4+GzfWQyOJD77o7Er8zUBBM50XTWS9w1mY0Nu9t446pxvcuX8a0/gWey3nWp
    VCnQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621539073;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=cmA0CcMD/U9YqBKObfXooA2cVKegWzGYs4H8toqG9Vw=;
    b=cTBTeCtT22K1UP19QtfoKrp1C9osH8zcPSQNpANrol0kzAqb0HW0yRMOmqpPFTjdUr
    hUwNU3OXu+wOliyVlcNopt5QmCcAcCHJr1ZH6Mr6JPzkVBAqrUqM5f/mHx5p3hTa4zrr
    lqLuYlKbtkeJC6elPjy9WqfcNnFuWnO3ODfuJfAjz4qRmmzOyOCKapyyf4MAeQTRSChk
    rFqLpm38iyxZ18BHyUsiSYY0v7WhMTqxmPy8/401PlT9sBS8JbYhtRAtBcIK2jy1xT7m
    vCViHZCn/JsS5ImAwvYHduHSdK09SbsZxVETBohxGJVh3e2TIWvzAKR/mCZEYU239xJa
    e6tA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbIvScKz23"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.26.1 DYNA|AUTH)
    with ESMTPSA id j02838x4KJVC09l
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 20 May 2021 21:31:12 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au
Subject: [PATCH] crypto: DRBG - switch to HMAC SHA512 DRBG as default DRBG
Date:   Thu, 20 May 2021 21:31:11 +0200
Message-ID: <3171520.o5pSzXOnS6@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The default DRBG is the one that has the highest priority. The priority
is defined based on the order of the list drbg_cores[] where the highest
priority is given to the last entry by drbg_fill_array.

With this patch the default DRBG is switched from HMAC SHA256 to HMAC
SHA512 to support compliance with SP800-90B and SP800-90C (current
draft).

The user of the crypto API is completely unaffected by the change.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 1b4587e0ddad..ea85d4a0fe9e 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -176,18 +176,18 @@ static const struct drbg_core drbg_cores[] = {
 		.blocklen_bytes = 48,
 		.cra_name = "hmac_sha384",
 		.backend_cra_name = "hmac(sha384)",
-	}, {
-		.flags = DRBG_HMAC | DRBG_STRENGTH256,
-		.statelen = 64, /* block length of cipher */
-		.blocklen_bytes = 64,
-		.cra_name = "hmac_sha512",
-		.backend_cra_name = "hmac(sha512)",
 	}, {
 		.flags = DRBG_HMAC | DRBG_STRENGTH256,
 		.statelen = 32, /* block length of cipher */
 		.blocklen_bytes = 32,
 		.cra_name = "hmac_sha256",
 		.backend_cra_name = "hmac(sha256)",
+	}, {
+		.flags = DRBG_HMAC | DRBG_STRENGTH256,
+		.statelen = 64, /* block length of cipher */
+		.blocklen_bytes = 64,
+		.cra_name = "hmac_sha512",
+		.backend_cra_name = "hmac(sha512)",
 	},
 #endif /* CONFIG_CRYPTO_DRBG_HMAC */
 };
-- 
2.31.1




