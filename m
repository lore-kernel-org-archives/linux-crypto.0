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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957D4FC6194
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 07:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 681F0207FA
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 07:49:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EX43zm+K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbfKHHtP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:49:15 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34688 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfKHHtO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 02:49:14 -0500
Received: by mail-wm1-f66.google.com with SMTP id v3so6676131wmh.1
        for <linux-crypto@vger.kernel.org>; Thu, 07 Nov 2019 23:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UIMGPvrsHWgPTPgSVN47FIgG2nJKkp25lHvqnAXp7Nc=;
        b=EX43zm+Krdbh/puR44JBj1WxYV9xZEcM+I1oOLVQuEfhE0cnt5cZD3fgboZpl+ju+v
         DQkEyP2yeIrHMkn135CYhkE6VTpBN0u+Gdb6lpVQ1oOoT5SHFoODumpP4jWtcdR4ye9K
         Gge2T2jA7aqcXVCZnCYLHEx6qIg5S58oUBaGKkwOExH3kJIohD/bV4zFMqiet59qm6X+
         YykKVocs9PQLPmK4cDI4ATdiUFJgyDXv3Ai6Hng6ub0WLfhc1GjrE8T3I6SD+izKwKZg
         Y/pXUb/FOi7y7vuuB7AfqBBtCfD2uJ1iAUBLpCQ8hcm1SrG5BaqlFhF+byYV64T+OY96
         YqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UIMGPvrsHWgPTPgSVN47FIgG2nJKkp25lHvqnAXp7Nc=;
        b=OqDc95nDBaaD+9DZEJvE4061q2340Dfs9k3pOCwFGMf3cfEhG2r6wPl0UYowvdVUK4
         Qukp2ucreqC28UedIc94LkYCUHdiSdLIM8BFepfQygOfJNEGHOdQOuJcZeMMcq5XWQ87
         OgSL10KMPsdYWjHmWyq8oIUr9za8kW8LBlkuGkDyr1awqvj1V7WO74vgrLh8qPUlpgr/
         wOa43r6kZxrcCrWBXeM81Y3rhQa4IpG9lJnlzS8+tEl7oODBe72fP9RhHTyLs0ztvC7x
         fg7WI6C3cCt1fbVdjMQ/BgwRe+SqEDjMyKUCRQXwOM64m13EfTxIAaFPsKhHtmWycdBD
         s1RQ==
X-Gm-Message-State: APjAAAUcgxN/LgE2X5zEK3h5DLBxCFyW8lRrN2vSRrdFqjkajTUJazEK
        0IYe8aaKoqX000hwN6b1mjojJocl
X-Google-Smtp-Source: APXvYqxuhzh10XgG0KYfdgnvk/7eGBpXxfyg38cf12Jg7fc5D9cKNgH08cBm41X5iLVnZ39fiaxNTA==
X-Received: by 2002:a1c:6641:: with SMTP id a62mr6677554wmc.54.1573199352098;
        Thu, 07 Nov 2019 23:49:12 -0800 (PST)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id x7sm10273231wrg.63.2019.11.07.23.49.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 23:49:10 -0800 (PST)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure - Fixed authenc w/ (3)DES fails on Macchiatobin
Date:   Fri,  8 Nov 2019 08:46:05 +0100
Message-Id: <1573199165-8279-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixed 2 copy-paste mistakes made during commit 13a1bb93f7b1c9 ("crypto:
inside-secure - Fixed warnings on inconsistent byte order handling")
that caused authenc w/ (3)DES to consistently fail on Macchiatobin (but
strangely work fine on x86+FPGA??).
Now fully tested on both platforms.

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

