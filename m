Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3219AC43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 16:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0804F214D8
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 16:36:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qZoivr6Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbfLKQgB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 11:36:01 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38202 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729260AbfLKQgB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 11:36:01 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so7663981wmi.3
        for <linux-crypto@vger.kernel.org>; Wed, 11 Dec 2019 08:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P/yUfamX8cAKoRPLBpUB3gU7OGBsxgEVu/US14BXdDQ=;
        b=qZoivr6Y6jABFYLUom62m6R46PtcWDKbcLnnMJ0gs2MWsH3JCh2+I7ByOfOnKhYmSi
         vwNgfDCGscUbGbqHFHUcVoWqhEFIrubBb/n4HMoDNlYAAqpcjckvDGYP87R+F1etRsWV
         K40GYcWKcqg5KdMu0gdOFWoVpVXLwQBjK/QXaw92kYU6WXOo6Mpn9Fwt7tltcfPHz/Rh
         tjTOy1lQ4zJYHA14yuP8ImlqOuZK6sVa7sLv65BNXE/1sE4VL28sRy5QGmPkAQ/eY+QV
         OhW/bWP4Lx+uKVvl+g2WLRID5B+7efQ2cahzTMso7+d8Hz1nR+2ddZxrpcO73fYslnVk
         wbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P/yUfamX8cAKoRPLBpUB3gU7OGBsxgEVu/US14BXdDQ=;
        b=rxiEnoidBrBDDFerQ7uNEZ7A80ZbQp5QtoQ3ZHbG11u1IsGJKRGzuIGf4kqlR9o69n
         6tn1sJ5t1UyB03vNOu+Yu1d085ipc3jp/nlUI/kKi0FxINMS59Rr/2gAIykaU26kpVws
         Eu0ygjhIqtn8TYT0l7N06qNt+SKgk4Y/j2Uy9VcxIq78ojObYfg6uwYuyqU+8Aic5BBW
         ZPz7GIfuoZxPmEUnJbnLuRisD3ckvDdwUSCDtao5mJAKxk/YrJLEoooa5cIuialNht+z
         e5sv2qOoM8bhCRDtuLE9d5zOnd/titUXlj4QM5SnsgAMlqddZ4pVkxLZVHqiabu/4jur
         5Qmw==
X-Gm-Message-State: APjAAAUgLio1XkZ7ZTHgq6PfiiHajNqrMIcJv6x4K0DWWkbMmnbae0xb
        XeU7VNWh5dlxn69bZd1Vq//W1XEPRI9jFQ==
X-Google-Smtp-Source: APXvYqy2AnfcvD1LUssfkk+uPmqJMWkG2YAwPhoeEMljPZcCXQNijuf6mXYJfHpes3+zhisHi3dTtg==
X-Received: by 2002:a05:600c:2218:: with SMTP id z24mr790421wml.50.1576082158598;
        Wed, 11 Dec 2019 08:35:58 -0800 (PST)
Received: from localhost.localdomain.com ([31.149.181.161])
        by smtp.gmail.com with ESMTPSA id o19sm2162405wmc.18.2019.12.11.08.35.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Dec 2019 08:35:58 -0800 (PST)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@rambus.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, Pascal van Leeuwen <pvanleeuwen@rambus.com>
Subject: [PATCH 3/3] crypto: inside-secure - Fix hang case on EIP97 with basic DES/3DES ops
Date:   Wed, 11 Dec 2019 17:32:37 +0100
Message-Id: <1576081957-5971-4-git-send-email-pvanleeuwen@rambus.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576081957-5971-1-git-send-email-pvanleeuwen@rambus.com>
References: <1576081957-5971-1-git-send-email-pvanleeuwen@rambus.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes another hang case on the EIP97 caused by sending
invalidation tokens to the hardware when doing basic (3)DES ECB/CBC
operations. Invalidation tokens are an EIP197 feature and needed nor
supported by the EIP97. So they should not be sent for that device.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@rambus.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 6 ++++--
 drivers/crypto/inside-secure/safexcel_hash.c   | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index db26166..6353901 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1509,6 +1509,7 @@ static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 			       unsigned int len)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
+	struct safexcel_crypto_priv *priv = ctx->priv;
 	int ret;

 	ret = verify_skcipher_des_key(ctfm, key);
@@ -1516,7 +1517,7 @@ static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 		return ret;

 	/* if context exits and key changed, need to invalidate it */
-	if (ctx->base.ctxr_dma)
+	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma)
 		if (memcmp(ctx->key, key, len))
 			ctx->base.needs_inv = true;

@@ -1605,6 +1606,7 @@ static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
 				   const u8 *key, unsigned int len)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
+	struct safexcel_crypto_priv *priv = ctx->priv;
 	int err;

 	err = verify_skcipher_des3_key(ctfm, key);
@@ -1612,7 +1614,7 @@ static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
 		return err;

 	/* if context exits and key changed, need to invalidate it */
-	if (ctx->base.ctxr_dma)
+	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma)
 		if (memcmp(ctx->key, key, len))
 			ctx->base.needs_inv = true;

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index ef3a489..25e49d1 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -282,7 +282,8 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv,
 			sreq->processed = sreq->block_sz;
 			sreq->hmac = 0;

-			ctx->base.needs_inv = true;
+			if (priv->flags & EIP197_TRC_CACHE)
+				ctx->base.needs_inv = true;
 			areq->nbytes = 0;
 			safexcel_ahash_enqueue(areq);

--
1.8.3.1
