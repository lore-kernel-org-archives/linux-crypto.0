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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6829C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 09:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7252218AE
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 09:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I5mp8DrR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbfKHJD3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 04:03:29 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:33728 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728513AbfKHJD3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 04:03:29 -0500
Received: by mail-wm1-f43.google.com with SMTP id a17so6054792wmb.0
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 01:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=owWUaalVwziaFaUHoZUY9jWXi17Ctqs5ud9x7EnAef0=;
        b=I5mp8DrRd50mdk2dBtKzvz/tz6QDI/vFNPucC811nfovYPS9U9hUs6wREYu2P8h5tA
         ULy1R5vbb9ewOzEcGwIcQb8RGrMeyvB0K+hpMZ6VvmN1Z8oN36XvXkS9L7ksalwdgVZi
         e+EJWoIHAcVzmE0R7IA5iBT+72elUdMdClTESlD2lotEo/fB98uYpB/nCCG8JZwnJRgF
         ICDxbphu5zjpwjov2vX7iMGvcfEWktFC7PC889Q3jOdIyCULlQNqLy4XV39hn/Qesn4l
         HGKNzdsOCZjN4GtYgewq8My1912X50NVOahyOWJG4siaPCZ8KKqCN720kUzyiCUrYnsH
         Jbdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=owWUaalVwziaFaUHoZUY9jWXi17Ctqs5ud9x7EnAef0=;
        b=CouCn0Q4gof+6GBfbcaD9YmKHsjzIjPE4yiEt9wetiqFSbu95bJj30bppFFH33BDao
         HvEsObBHD8GkeusXNaxgJ9jMRDeFWDGUYeoNPRSe6LL7r6y9gUpMQ3kj6eL099L5ZFQk
         V2UG/1daLZZxcAOqM3hv7YlxAauTVqWWkd8L1jiwHeCVtif71k1WMky+X36/l1/biSZS
         aVe9ogJxScxjPhHZ44LjeANjOHzSUayEXH1FNBfYMUazN8uCuAIz+Li0Vs5Ex/2pPO0P
         XmruIULpqaszi220VQUAnzKy4YpRB9O9suq6NKvkaIsDqXNXTj5aw2sNAu73U3w3RR2r
         az7g==
X-Gm-Message-State: APjAAAVz1TzVatWI0YSL6TGJIci6iPJzO2N1BVFwUmaRLcAmLfTOuEF5
        +y1AHngZ/NVktZItsxH0mqaJzugj
X-Google-Smtp-Source: APXvYqyRpVHOOFD1OJh8GS2L3RNpSeLC0+E5tQxtKGiYZVCK/2hEUYL5ckQ3f8JMD8WsTw53PABusQ==
X-Received: by 2002:a1c:7412:: with SMTP id p18mr7015606wmc.9.1573203806643;
        Fri, 08 Nov 2019 01:03:26 -0800 (PST)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id b4sm10410985wrh.87.2019.11.08.01.03.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 01:03:26 -0800 (PST)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv4] crypto: inside-secure - Fixed authenc w/ (3)DES fails on Macchiatobin
Date:   Fri,  8 Nov 2019 10:00:21 +0100
Message-Id: <1573203621-8641-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixed 2 copy-paste mistakes in the commit mentioned below that caused
authenc w/ (3)DES to consistently fail on Macchiatobin (but strangely
work fine on x86+FPGA??).
Now fully tested on both platforms.

Fixes: 13a1bb93f7b1c9 ("crypto: inside-secure - Fixed warnings on
inconsistent byte order handling")

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---

changes since v1:
- added Fixes: tag

changes since v2:
- moved Fixes: tag down near other tags

changes since v3:
- moved changelog below the ---

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

