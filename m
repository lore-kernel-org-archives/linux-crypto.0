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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC40AC5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEB2221D6C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NfVDBcBa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfKHIue (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:50:34 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:44772 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfKHIue (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 03:50:34 -0500
Received: by mail-wr1-f49.google.com with SMTP id f2so6005471wrs.11
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 00:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bN0snTLyc0KCMcvcjAb+zIxhELtMoVCFiJKps/WFlwM=;
        b=NfVDBcBaAxEQ7P+egTq9BRbz7ycsnDvbKNJ81ElTkBG7ndP//8ToAo/AhiuYwDUHrS
         LwW6UGx8dm3hIP7XVnHChJyKxHvTiq2zk23068uIN4RH/qIbgsHeGyepuJLe2C67G4v+
         ZlM52gnn84khbONG6IwAazindRQ7NI1J0NcZDRYF8lpRCO6a2Z87mLd3GXG8OEnqebr9
         LNqV84IW4dtOejQqjRmtRQgjfJYCtmwg1nHtkq4J7amYFCIWr8EOj+3uR6jHArjC0rLG
         Y6/vIUtyzipNMq0o1NuHyEhzr1MIrYzMfaDAFfDkWjv4FryilySWSkzvzUp/y4LUQlU7
         xNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bN0snTLyc0KCMcvcjAb+zIxhELtMoVCFiJKps/WFlwM=;
        b=RZeCQL88zIxSi5e6X7Uik2gPmd01f8MQNJ+w8pc2X74LIW2vEdmzpLMRP3tU2+/HHU
         9URGHklqNbFtc5r/BHKRLwjQwSM1GW+YTKCsC5S7+2lgw+zyxaX2PT1QQSRYl53XJPnw
         d5xMQwoXfLViXaDYXeYv1PTVUPxNM5CT/RvXZXlhuc1aHa14yKb63xJI+RMXMaS/J/K3
         qa2sRVxpm8yDqscMo88h2aaWKTL6/OWQvLY+PTsHlYd7XzeVBB/mkApWONM7VlrANmTa
         v3kWUfh2qq0fZDKdD3X5cwK8P4qTtq6I3bezmbsScBaDeMxrCUV2rspGahAZielhh18C
         gjYQ==
X-Gm-Message-State: APjAAAVZEF9UV0Xk0vDPzRiWOj1Vfj1kC1zt02LyoDT/56CUCDgO/1a4
        s7+3ypIX/csQW3YWWaR9GAy8za4j
X-Google-Smtp-Source: APXvYqwqpa3w7S4CrbWetdyJHv8yR4dP33x7gWEsK4uu4Ye5VFi4nICd1Mw8OLZOXwJfSI9k25DhMw==
X-Received: by 2002:a05:6000:49:: with SMTP id k9mr7234593wrx.43.1573203032328;
        Fri, 08 Nov 2019 00:50:32 -0800 (PST)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id t134sm5326541wmt.24.2019.11.08.00.50.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 00:50:31 -0800 (PST)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2] crypto: inside-secure - Fixed authenc w/ (3)DES fails on Macchiatobin
Date:   Fri,  8 Nov 2019 09:47:27 +0100
Message-Id: <1573202847-8292-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes: 13a1bb93f7b1c9 ("crypto: inside-secure - Fixed warnings on
inconsistent byte order handling")

Fixed 2 copy-paste mistakes in the abovementioned commit that caused
authenc w/ (3)DES to consistently fail on Macchiatobin (but strangely
work fine on x86+FPGA??).
Now fully tested on both platforms.

changes since v1:
- added Fixes: tag

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

