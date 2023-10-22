Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50DAC25B41
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjJVITO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbjJVISx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38C2D63
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64860C433CC
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962729;
        bh=DgquwnLDj9ZPnrfqI9YyHmqxn4/fEiZRBImpandoewA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=P0+onzynMVCsOEuYEz7Hg51zOOiTWIIIFg3RkOhc66SHFaqgNVukgXCXvj/RRPtQ8
         trSlHDhVr9qt84p3x/8cHMd1A958kKbC89WnlVpkE98LyekpL00l2Migsl2kGH4Wwh
         exlSQcP3HuWXQ506FRCE1MUt9NPw7p48La27XljFLfbRxethCZ0etslZlOhZeP8RA+
         4GL527iwIE0Z/ORbcyscREwE0ze66gfeGnxZf6khw0RY0KylnNYaP4b5cCSJTyjRpr
         VdkDAPF+cesDHqQWlLJVGN5nDckz58j5C3qkKfwISQVAFyF8mLliGPD8e32p9AfYGE
         RA/2CwvC4+OgQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 27/30] crypto: talitos - stop using crypto_ahash::init
Date:   Sun, 22 Oct 2023 01:10:57 -0700
Message-ID: <20231022081100.123613-28-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The function pointer crypto_ahash::init is an internal implementation
detail of the ahash API that exists to help it support both ahash and
shash algorithms.  With an upcoming refactoring of how the ahash API
supports shash algorithms, this field will be removed.

Some drivers are invoking crypto_ahash::init to call into their own
code, which is unnecessary and inefficient.  The talitos driver is one
of those drivers.  Make it just call its own code directly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/talitos.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index e8f710d87007b..e39fc46a0718e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2112,27 +2112,28 @@ static int ahash_finup(struct ahash_request *areq)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
 	req_ctx->last = 1;
 
 	return ahash_process_req(areq, areq->nbytes);
 }
 
 static int ahash_digest(struct ahash_request *areq)
 {
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(areq);
-
-	ahash->init(areq);
-	req_ctx->last = 1;
+	ahash_init(areq);
+	return ahash_finup(areq);
+}
 
-	return ahash_process_req(areq, areq->nbytes);
+static int ahash_digest_sha224_swinit(struct ahash_request *areq)
+{
+	ahash_init_sha224_swinit(areq);
+	return ahash_finup(areq);
 }
 
 static int ahash_export(struct ahash_request *areq, void *out)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct talitos_export_state *export = out;
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct device *dev = ctx->dev;
 	dma_addr_t dma;
@@ -3235,20 +3236,22 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 
 		if (!(priv->features & TALITOS_FTR_HMAC_OK) &&
 		    !strncmp(alg->cra_name, "hmac", 4)) {
 			devm_kfree(dev, t_alg);
 			return ERR_PTR(-ENOTSUPP);
 		}
 		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
 		    (!strcmp(alg->cra_name, "sha224") ||
 		     !strcmp(alg->cra_name, "hmac(sha224)"))) {
 			t_alg->algt.alg.hash.init = ahash_init_sha224_swinit;
+			t_alg->algt.alg.hash.digest =
+				ahash_digest_sha224_swinit;
 			t_alg->algt.desc_hdr_template =
 					DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
 					DESC_HDR_SEL0_MDEUA |
 					DESC_HDR_MODE0_MDEU_SHA256;
 		}
 		break;
 	default:
 		dev_err(dev, "unknown algorithm type %d\n", t_alg->algt.type);
 		devm_kfree(dev, t_alg);
 		return ERR_PTR(-EINVAL);
-- 
2.42.0

