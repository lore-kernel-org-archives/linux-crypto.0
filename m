Return-Path: <SRS0=2cET=YT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1F2C47E49
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 14:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AD5F21655
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572101639;
	bh=Tb61mM6yE+GYvbH8qeXuxuRPGbWwsEOBP0rD5F1PxWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=z2joxA9uZ93PKjycaQpp3wQDBdfC0pblayYnrqZHTTrpvaNouk2184DHbwMi+7hdp
	 tXYnGqhZYg/HWBKR+3EWLlQ3Fk++oJOg2Dnew67VwdYqBxMXM1fHklIcVQmKIeRS/3
	 oABhl6FyvOuTAbTraDegSVQPeAAN4inLfnqpLlI8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfJZOx6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Oct 2019 10:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfJZOx6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Oct 2019 10:53:58 -0400
Received: from e123331-lin.home (lfbn-mar-1-643-104.w90-118.abo.wanadoo.fr [90.118.215.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 912602070B;
        Sat, 26 Oct 2019 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572101638;
        bh=Tb61mM6yE+GYvbH8qeXuxuRPGbWwsEOBP0rD5F1PxWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvtLyLYRk5krgFpQodD8nCqvnp8WiiLCL+lQ8CTQBqbABmvkHX47UBkzSBq1y0ZDI
         GT6onIxdMQMAZY24SfSb2YeunzeV8wsg3nSPLFLYiFNpNSuocL0TUZS4n+EkDDuNFw
         qhL3qFZ8x6EGQ61iACeBd4/gkjJh0HtCpy0yeYfo=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        linux-omap@vger.kernel.org, Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 5/6] crypto: omap-aes-gcm - check length of assocdata in RFC4106 mode
Date:   Sat, 26 Oct 2019 16:52:58 +0200
Message-Id: <20191026145259.16040-6-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191026145259.16040-1-ardb@kernel.org>
References: <20191026145259.16040-1-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RFC4106 requires the associated data to be a certain size, so reject
inputs that are wrong. This also prevents crashes or other problems due
to assoclen becoming negative after subtracting 8 bytes.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/omap-aes-gcm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
index 70398fbd669d..1aabf9a72066 100644
--- a/drivers/crypto/omap-aes-gcm.c
+++ b/drivers/crypto/omap-aes-gcm.c
@@ -365,7 +365,8 @@ int omap_aes_4106gcm_encrypt(struct aead_request *req)
 
 	memcpy(rctx->iv, ctx->nonce, 4);
 	memcpy(rctx->iv + 4, req->iv, 8);
-	return omap_aes_gcm_crypt(req, FLAGS_ENCRYPT | FLAGS_GCM |
+	return crypto_ipsec_check_assoclen(req->assoclen) ?:
+	       omap_aes_gcm_crypt(req, FLAGS_ENCRYPT | FLAGS_GCM |
 				  FLAGS_RFC4106_GCM);
 }
 
@@ -376,7 +377,8 @@ int omap_aes_4106gcm_decrypt(struct aead_request *req)
 
 	memcpy(rctx->iv, ctx->nonce, 4);
 	memcpy(rctx->iv + 4, req->iv, 8);
-	return omap_aes_gcm_crypt(req, FLAGS_GCM | FLAGS_RFC4106_GCM);
+	return crypto_ipsec_check_assoclen(req->assoclen) ?:
+	       omap_aes_gcm_crypt(req, FLAGS_GCM | FLAGS_RFC4106_GCM);
 }
 
 int omap_aes_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
-- 
2.17.1

