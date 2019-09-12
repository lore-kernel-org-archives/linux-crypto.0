Return-Path: <SRS0=/8o3=XH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E6AC49ED9
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 10:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CC9220830
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 10:13:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GaLkX4rm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbfILKNG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Sep 2019 06:13:06 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:37890 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730386AbfILKNF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Sep 2019 06:13:05 -0400
Received: by mail-ed1-f53.google.com with SMTP id a23so21201072edv.5
        for <linux-crypto@vger.kernel.org>; Thu, 12 Sep 2019 03:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6t270amJZLgOavz3Zzqj4c4sViNremZJWKTXzibWcO0=;
        b=GaLkX4rm05Rr0Lr2oHJtHSBRpq6+KTsZQWYwPY7iH5F0sGrL8uoiPwqBCaily8Gu50
         mty430p1njgUQ++aE8Hd4QYSV5ftSdSAIlMOce21YyHwBNChasvBQdYqtDSlluP+YA2y
         6JPzdSH41uIGactrUYFQ2GJRVQIora6cFyPBgnG5rlkRnFaV4nK4A1VWKGcbf0klArpF
         7+geNy6tZ49UVPw2EAW09Nipg18RpZEepQkoA5xQVDja+Js09bVv8OH2/3cqqkAcIn2F
         bpa5TvXQ//AWNvGblNxDPi3tzZ1Jlx1/ozQYxkdHgHpkPMPSYbEf9y5DKtPysXn6mv0t
         j2Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6t270amJZLgOavz3Zzqj4c4sViNremZJWKTXzibWcO0=;
        b=fAggtjadh0c24vlMzosP4OLDkbjUC2CIJsdKe4Mi3qxq8StloeojOwkoULkr0wjuzU
         IeKKtQ4ppe5QQMoPIU7zW5+yOWJWjfkCYZcJcJmHjOD+dcilYLjYFus2zzSVFC3MOyiM
         AMBFnIxQpjmvyS9Gflq66TjEu9wvFdlTPl25vXol1D+nGLSgfEJkaNirD03LZOC4Bi52
         tz2nWdReTkyQDwogXeI0LRQ33fjk2zk4xK2Aalq/6ZQiyxr3U07Q0ur/FnINIXroXX2v
         sjiIALdC5HA8YmXEimp75W7fTjiylButa6wFh4rRghrGhHvhBAVOkFn08zgtk6GN8tj5
         MplQ==
X-Gm-Message-State: APjAAAUoiMdfc5MCscFmE7GNlHElt08wgSzw2n6dZ3lxED64FeHZnOot
        I3XtBmqpMEZlxhtQkubESyB5Mu1L
X-Google-Smtp-Source: APXvYqwV06mgQBOnD5XCKYTtv/jNbRySVKjjjFNeqaYPKabGTsw4zxzsDHjhYekUPyfybW4MQrdhbg==
X-Received: by 2002:aa7:ccda:: with SMTP id y26mr41075556edt.303.1568283183015;
        Thu, 12 Sep 2019 03:13:03 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id k11sm2561499ejr.3.2019.09.12.03.13.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 03:13:02 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 2/3] crypto: inside-secure - Added support for HMAC-SM3 ahash
Date:   Thu, 12 Sep 2019 11:10:13 +0200
Message-Id: <1568279414-16773-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568279414-16773-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568279414-16773-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for the hmac(sm3) ahash authentication algorithm

changes since v1:
- added Acked-by tag below, no changes to the source

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
index 4c22df8..73055dc 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -871,5 +871,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_chachapoly;
 extern struct safexcel_alg_template safexcel_alg_chachapoly_esp;
 extern struct safexcel_alg_template safexcel_alg_sm3;
+extern struct safexcel_alg_template safexcel_alg_hmac_sm3;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index a4107bb..fdf4bcc 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -2280,3 +2280,73 @@ struct safexcel_alg_template safexcel_alg_sm3 = {
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

