Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB606C32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 07:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF040206A3
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 07:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pMS2Vvwm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfGaHNZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 03:13:25 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37744 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfGaHNZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 03:13:25 -0400
Received: by mail-ed1-f68.google.com with SMTP id w13so64763640eds.4
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jul 2019 00:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6oIw027f0HKD2xJg0d0WXgTkldm3EAJIJYEg02YTlL0=;
        b=pMS2VvwmaFnDz21vbaE3hM29nqIZfhcNJ4VRQ4+jZeFPhMxmKJjOipylZRLpwK3cnm
         /8JdO3SFbPPyw2HvDJRWcA9N0b/x9jNB2IcLuUGbwiiZIV5KCDG6qPIobzLF2uWgQ2G4
         MIVaoo+tlVg4Nh6amzh/LY89esQVzlr9RQnM8wFhbn+2qv+bmWeCkIYwbirhgzcTbs76
         +Vn3tBc2laBjpPnEKppE8/tfUAhkEYSjloiErTj3U2VcilwBphyxRiLcN6Q+PbtqGaTY
         jB5Qo9O0qi/dCtncYESHg9wBZZ6zS8qiF8+M+6RMTYGFHw53tqEWrMq1ucIquSjO6Ojk
         LJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6oIw027f0HKD2xJg0d0WXgTkldm3EAJIJYEg02YTlL0=;
        b=Oo1gNw2I1kJBjs8UvEFC2XpCJtIm6XSzkDAN64/1NkyQD8bugXjZ/R2ZSoPLd1NrpJ
         1QG4TTQeqtY3eOYHyqeuI7BhMy3FjsGb6YvbOpmba3tbJXpcnt5DnteuwZ3dTcVg/KJX
         xYZgFZtbdAif/QuLwhHmn4jkhev/BDJWr8WefOvcIp6q9BcoR58qPDGMVEGP6hzza7Qo
         LvF+XWev1aRnPGRYvR1zf4jKl2/YEjt4dp0teebc77KPUooFzngozXMBriaS4RE8zdzF
         bHnNNw/XJFuVrI7RBZtECmeUJq/IC5ATDv1PT1rY9r3UYeYyQtltI7xqYJN76lpmB1Fd
         3m/A==
X-Gm-Message-State: APjAAAWhDXFexoNQUdDdInYzpSAaSOhqlaCruihhihd0tiC6p8/DAr5U
        b9Ym8pao1J4uFA3mR/W2wrHplKjF
X-Google-Smtp-Source: APXvYqxJWCKJ9nnQ1UBZCk4+pDeDn4f3sw1rtTveF3wf6AMPs7wQwSba7fV04EXV1oIP/y0z26SnKQ==
X-Received: by 2002:a17:907:447e:: with SMTP id oo22mr73526279ejb.169.1564557203519;
        Wed, 31 Jul 2019 00:13:23 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z2sm12156076ejp.73.2019.07.31.00.13.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 00:13:22 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure: Remove redundant DES ECB & CBC keysize check
Date:   Wed, 31 Jul 2019 08:10:54 +0200
Message-Id: <1564553454-25955-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch removes a DES key size check that is redundant as it is already
performed by the crypto API itself due to min_keysize = max_keysize.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 56dc8f9..d52b8ff 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1188,11 +1188,6 @@ static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 	u32 tmp[DES_EXPKEY_WORDS];
 	int ret;
 
-	if (len != DES_KEY_SIZE) {
-		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
 	ret = des_ekey(tmp, key);
 	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-- 
1.8.3.1

