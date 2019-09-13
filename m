Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E879C4CEC5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 16:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 451692084F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 16:23:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VVEaYoQX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388673AbfIMQXh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 12:23:37 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:36743 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388221AbfIMQXh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 12:23:37 -0400
Received: by mail-ed1-f52.google.com with SMTP id f2so21214445edw.3
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 09:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t03O1lGA2w1JthcCeg9Z1ZYH3gKBRQCUleElET66vhg=;
        b=VVEaYoQXLyiNULnroC4LCOAYl1VGLQXOvcG2uxaNBve0z/YUCwng1zrNQfajcG1kKk
         k8pSE1AB4nAGxEOHb7a7JW4v52yyJM+6475/+nXNBGfPo+DKS6C63Nb5JmoE5wvPp5mB
         sX5hnYrcg9MQqEgHOpNCxQqt0BCnnNixWAoim8Z7sF8nvfjh6NU5E3O/tGHaI+VdcMws
         LWnnX5aXrFKE2anjA/p85/93dpNU/KoRNpu8NjdDSO9g5nryzkH3/1VmUNa1LO+TpGGb
         QwF0nAaz3dYlwFJi9QBgA1t1G6pug4wZbX/+OAAEUNVnNueDcrBpDAW/KnAa0qKA7yo7
         f7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t03O1lGA2w1JthcCeg9Z1ZYH3gKBRQCUleElET66vhg=;
        b=qC6S5l1lrt6ukKXOStzaMYPYv1SENJecpMRWYxA+boOqwUXmc+FlAiZucWn2iSzFqM
         /5/Wx6nO1nhUPNYo51bc6f/col2ajKU8UYmAWzzqBvGSz+JlD5BichWkFfkmFwOm/Opd
         9EU6oESui2dz9BQtYIsgZfHdGxn0PcawkcMYZVS4qIGWaEM9qZj+NgxHp7Nj3ryuez0l
         gDHz2kLZ0a2UN9iPVzbxJwBYIflZE/TNTYr56Nh3Ob1bFF4Ja5A9BASEJfTBBy7UaxuT
         9KZEs6F4EkLdeGAIaXYK0yruadauGgpNZn+XHdEF9fcx2/fAxNaG9AK2BFzU+GHvb2wz
         JPpw==
X-Gm-Message-State: APjAAAW0bsV/zDWslTMgpFni6jvR8AwALhq7VvHDyZ8mUMjpa7ilk8+g
        al3rTgdJHSFSMl2W9sxfbnOa534o
X-Google-Smtp-Source: APXvYqwT8EF4fMYovVvDPrgbyK0pHZIfkT/8/EPaEjI6Iw8V+qd2Hs3FtgvbZ353Uj8RqiFZInGPYw==
X-Received: by 2002:a17:907:2102:: with SMTP id qn2mr40700600ejb.266.1568391813691;
        Fri, 13 Sep 2019 09:23:33 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id r18sm5497669edl.6.2019.09.13.09.23.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 09:23:32 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv3 2/3] crypto: inside-secure - Added support for HMAC-SM3 ahash
Date:   Fri, 13 Sep 2019 17:20:37 +0200
Message-Id: <1568388038-1268-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568388038-1268-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568388038-1268-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for the hmac(sm3) ahash authentication algorithm

changes since v1:
- added Acked-by tag below, no changes to the source

changes since v2:
- nothing

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c      |  1 +
 drivers/crypto/inside-secure/safexcel.h      |  1 +
 drivers/crypto/inside-secure/safexcel_hash.c | 70 ++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 826d1fb..7d907d5 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1177,6 +1177,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_chachapoly,
 	&safexcel_alg_chachapoly_esp,
 	&safexcel_alg_sm3,
+	&safexcel_alg_hmac_sm3,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index e2993b5..1b2d709 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -877,5 +877,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_chachapoly;
 extern struct safexcel_alg_template safexcel_alg_chachapoly_esp;
 extern struct safexcel_alg_template safexcel_alg_sm3;
+extern struct safexcel_alg_template safexcel_alg_hmac_sm3;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 873b774..272e5fd 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -2285,3 +2285,73 @@ struct safexcel_alg_template safexcel_alg_sm3 = {
 		},
 	},
 };
+
+static int safexcel_hmac_sm3_setkey(struct crypto_ahash *tfm, const u8 *key,
+				    unsigned int keylen)
+{
+	return safexcel_hmac_alg_setkey(tfm, key, keylen, "safexcel-sm3",
+					SM3_DIGEST_SIZE);
+}
+
+static int safexcel_hmac_sm3_init(struct ahash_request *areq)
+{
+	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
+	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
+
+	memset(req, 0, sizeof(*req));
+
+	/* Start from ipad precompute */
+	memcpy(req->state, ctx->ipad, SM3_DIGEST_SIZE);
+	/* Already processed the key^ipad part now! */
+	req->len	= SM3_BLOCK_SIZE;
+	req->processed	= SM3_BLOCK_SIZE;
+
+	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SM3;
+	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
+	req->state_sz = SM3_DIGEST_SIZE;
+	req->block_sz = SM3_BLOCK_SIZE;
+	req->hmac = true;
+
+	return 0;
+}
+
+static int safexcel_hmac_sm3_digest(struct ahash_request *areq)
+{
+	int ret = safexcel_hmac_sm3_init(areq);
+
+	if (ret)
+		return ret;
+
+	return safexcel_ahash_finup(areq);
+}
+
+struct safexcel_alg_template safexcel_alg_hmac_sm3 = {
+	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SM3,
+	.alg.ahash = {
+		.init = safexcel_hmac_sm3_init,
+		.update = safexcel_ahash_update,
+		.final = safexcel_ahash_final,
+		.finup = safexcel_ahash_finup,
+		.digest = safexcel_hmac_sm3_digest,
+		.setkey = safexcel_hmac_sm3_setkey,
+		.export = safexcel_ahash_export,
+		.import = safexcel_ahash_import,
+		.halg = {
+			.digestsize = SM3_DIGEST_SIZE,
+			.statesize = sizeof(struct safexcel_ahash_export_state),
+			.base = {
+				.cra_name = "hmac(sm3)",
+				.cra_driver_name = "safexcel-hmac-sm3",
+				.cra_priority = SAFEXCEL_CRA_PRIORITY,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_KERN_DRIVER_ONLY,
+				.cra_blocksize = SM3_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
+				.cra_init = safexcel_ahash_cra_init,
+				.cra_exit = safexcel_ahash_cra_exit,
+				.cra_module = THIS_MODULE,
+			},
+		},
+	},
+};
-- 
1.8.3.1

