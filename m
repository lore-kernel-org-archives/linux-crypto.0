Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD04C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ED0A214DA
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:57:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HI/IwxzU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfKHI5L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:57:11 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:37862 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbfKHI5L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 03:57:11 -0500
Received: by mail-wm1-f41.google.com with SMTP id q130so5352495wme.2
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 00:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uxJBSvtE0oq3pifNIDHY3/IppCnCTwH/D6tOj/TCN7o=;
        b=HI/IwxzU3PkSim+doAuoUZ7HC0wUxa8NjYxFEIgwoEJ8jYV1zzAzda8l3GHwvhVFsZ
         rrbAwXlqErRluq8Df3BBLl0lJzNMCW1QH4Wd3+bs2w4Kqw0GhAEX+8vfsWfcdg4aPIkk
         IvEwslK5ZnMDWcZ5vU/apf87PTbB0NU+fkqCzNajjWO4V/i4YEMcBzLhqNSHraCT0td0
         kbsNK1BSZrSqPIoZ2+KlWNtYMwYGjVnbOzbecw+cCEv8c/4A/o3eh1UD1oZmlIxWYbhc
         Z69/7JyHr+whVWA8KCtENvFHky2y8qQRQBX3x8Yba9BoUTDJ1QGItPlen+KGzBLlSFAU
         03Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uxJBSvtE0oq3pifNIDHY3/IppCnCTwH/D6tOj/TCN7o=;
        b=jlxsJkeDWU43uzseewMrNFzdP16d3jJh4xEsutqjz1Rf6qpPW8R5zhcWCgRiW741Pf
         2GkrePNIu+Q3uBQpXi/tjsezHHXhFPCimFWSE0ztWNdzqZZkeJsqRLN4MlPz7De6EqjR
         p/vEI/otWPDJMoej5+qQjXbr/YMlz2Lnyxtqlpx5sy5cQp3HHyC6S3jh/tRe/KPw/l18
         MBYIm4rg315CHbOPqd6pKSf7o/sHgh+NGxfXk6HEqr99Vi/sYxmuDvKn9n04V+z/savQ
         EWfSkaypvwu3i2nfWtmHDJvKkFb3NMpadth5NjGVn4w9SGZfNFskzIMJ8YkkTBins3oy
         aeng==
X-Gm-Message-State: APjAAAV873PORf4V8M18ePT9ZhqgCiNmlpFm6BUUzeAyMUpUNgSOtH3j
        SUc5FEqOhUwGkDYMqVPxNgHN61YE
X-Google-Smtp-Source: APXvYqyvi4huAJ3350eHRlpDX6Y8zRcNngrGZkvZ+0+Vz3dXl4bEH02xGaxBkBJ2apcd+zSpMP0k0Q==
X-Received: by 2002:a1c:e308:: with SMTP id a8mr7126826wmh.55.1573203428960;
        Fri, 08 Nov 2019 00:57:08 -0800 (PST)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id 200sm8762479wme.32.2019.11.08.00.57.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 00:57:08 -0800 (PST)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv3] crypto: inside-secure - Fixed authenc w/ (3)DES fails on Macchiatobin
Date:   Fri,  8 Nov 2019 09:53:54 +0100
Message-Id: <1573203234-8428-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixed 2 copy-paste mistakes in the commit mentioned below that caused
authenc w/ (3)DES to consistently fail on Macchiatobin (but strangely
work fine on x86+FPGA??).
Now fully tested on both platforms.

changes since v1:
- added Fixes: tag

changes since v2:
- moved Fixes: tag down near other tags

Fixes: 13a1bb93f7b1c9 ("crypto: inside-secure - Fixed warnings on
inconsistent byte order handling")

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 98f9fc6..c029956 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -405,7 +405,8 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < keys.enckeylen / sizeof(u32); i++) {
-			if (le32_to_cpu(ctx->key[i]) != aes.key_enc[i]) {
+			if (le32_to_cpu(ctx->key[i]) !=
+			    ((u32 *)keys.enckey)[i]) {
 				ctx->base.needs_inv = true;
 				break;
 			}
@@ -459,7 +460,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 	/* Now copy the keys into the context */
 	for (i = 0; i < keys.enckeylen / sizeof(u32); i++)
-		ctx->key[i] = cpu_to_le32(aes.key_enc[i]);
+		ctx->key[i] = cpu_to_le32(((u32 *)keys.enckey)[i]);
 	ctx->key_len = keys.enckeylen;
 
 	memcpy(ctx->ipad, &istate.state, ctx->state_sz);
-- 
1.8.3.1

