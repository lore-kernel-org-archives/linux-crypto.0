Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2943C04AB6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 08:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7A5026569
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 08:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Tl2OcOqb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfEaIOZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 04:14:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51807 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaIOZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 04:14:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id f10so5450192wmb.1
        for <linux-crypto@vger.kernel.org>; Fri, 31 May 2019 01:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2xX51WQIoP1+ZqR28S6jiUO+xuvJxJXjpCal4lbmyxE=;
        b=Tl2OcOqbB8XjOC6BJxwKg+4cuNCQNR5SdpBqRJ9ngj8WJEbAEc94aZb0N7TVr+u7kv
         isicPM9PWHcLsw3e98KCvJUF0RrU6cFBrzxcbwXiKkOzlhRgg4W9Z9eJBBKZV3YFXmwD
         sgkGFndqw0klmAlBPJomzj2pjlhpQ1mpRLcCE8v1JWgJRbsp7tLC0kPO0+bGvVKLpph0
         yLf1b16lJtxyhsNgZS9LR8gm+g93u+ToI9QsAK+dS/MqKrH2QFullEmcan6c8AfyiFOV
         Iuju4Ui6pBONdWNtP6rWbBLY7vXQVeVQUTMXmbQwfyu+Aic/GTk7iiugDUwEXltXOEHt
         /GpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2xX51WQIoP1+ZqR28S6jiUO+xuvJxJXjpCal4lbmyxE=;
        b=oH8XcI5xCK8GqvW+5wrUz2L7NPqp5DR6bfmQtJp26Y1In2RKTkrxL6MlAXMXUNWXU2
         xDLqxJu4cOC0m5BnDjEoJhGMgcEtkzh9bPDMsparqau37Bppzkiy6bY1fHIH11DqWV7T
         2W6DvNwBXvpgtatZgMLjR9plLTAu1fe4B/zr8h0s9+/cRwv+VjBxT4Rhg0O0u9icfaqB
         gnLovCoU01sDEqs6zLD+Bcxd379ZTgHQ3dHe02ntOe9YPoHGmg28YZ4nPkGR4MyAJKbG
         eJitWzaP1UieK42/B++4xyWLTJN6CgK9bCI558v3waPZ4GDJMQ3yPCPdhTQb0z5yS5RR
         w/Kg==
X-Gm-Message-State: APjAAAUdFUDKCbCbJkXurlU/m++t5eZN0y/xAJRVopb1JCZnJ94LQdeK
        2ztDNftjRwaARXkk11yCvMKhleofmacI5g==
X-Google-Smtp-Source: APXvYqzAUiZbLhJDQ8+JtEH8qQr/me62fo7Ty3AgFzlwlZvazkOMTxh/18WNYZ86J7DfzOwkVQFWpA==
X-Received: by 2002:a1c:e356:: with SMTP id a83mr4941760wmh.38.1559290462493;
        Fri, 31 May 2019 01:14:22 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:c225:e9ff:fe2e:ea8])
        by smtp.gmail.com with ESMTPSA id j2sm7013804wrx.65.2019.05.31.01.14.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 01:14:21 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        pvanleeuwen@insidesecure.com, linux-imx@nxp.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] crypto: caam - limit output IV to CBC to work around CTR mode DMA issue
Date:   Fri, 31 May 2019 10:13:06 +0200
Message-Id: <20190531081306.30359-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CAAM driver currently violates an undocumented and slightly
controversial requirement imposed by the crypto stack that a buffer
referred to by the request structure via its virtual address may not
be modified while any scatterlists passed via the same request
structure are mapped for inbound DMA.

This may result in errors like

  alg: aead: decryption failed on test 1 for gcm_base(ctr-aes-caam,ghash-generic): ret=74
  alg: aead: Failed to load transform for gcm(aes): -2

on non-cache coherent systems, due to the fact that the GCM driver
passes an IV buffer by virtual address which shares a cacheline with
the auth_tag buffer passed via a scatterlist, resulting in corruption
of the auth_tag when the IV is updated while the DMA mapping is live.

Since the IV that is returned to the caller is only valid for CBC mode,
and given that the in-kernel users of CBC (such as CTS) don't trigger the
same issue as the GCM driver, let's just disable the output IV generation
for all modes except CBC for the time being.

Cc: Horia Geanta <horia.geanta@nxp.com>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/caam/caamalg.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index c0ece44f303b..e1778e209ea2 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -999,6 +999,7 @@ static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	struct skcipher_request *req = context;
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	int ivsize = crypto_skcipher_ivsize(skcipher);
 
 #ifdef DEBUG
@@ -1023,9 +1024,9 @@ static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	/*
 	 * The crypto API expects us to set the IV (req->iv) to the last
-	 * ciphertext block. This is used e.g. by the CTS mode.
+	 * ciphertext block when running in CBC mode.
 	 */
-	if (ivsize)
+	if ((ctx->cdata.algtype & OP_ALG_AAI_MASK) == OP_ALG_AAI_CBC)
 		scatterwalk_map_and_copy(req->iv, req->dst, req->cryptlen -
 					 ivsize, ivsize, 0);
 
@@ -1842,9 +1843,9 @@ static int skcipher_decrypt(struct skcipher_request *req)
 
 	/*
 	 * The crypto API expects us to set the IV (req->iv) to the last
-	 * ciphertext block.
+	 * ciphertext block when running in CBC mode.
 	 */
-	if (ivsize)
+	if ((ctx->cdata.algtype & OP_ALG_AAI_MASK) == OP_ALG_AAI_CBC)
 		scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen -
 					 ivsize, ivsize, 0);
 
-- 
2.20.1

