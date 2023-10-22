Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA75DC001DF
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjJVITO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbjJVISx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E30D53
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307F8C433C7
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962729;
        bh=ji3lKzqwdzm3b5FtRsxKYlJDL+v3S0VySToriL6uwC4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tdyNRRNLpkK4MxpRc3j3/km9Jwaty08JLzhB9aZfw7S8X+YFUT6sM6uG2ztvBOK3c
         GNgrSL9djBNzTYfFKCLZvdIL9/fgLqR3yhXijwlk2JpK+1ODiQUGjPtex2KAK+lk8P
         g1401dS87fpPrhvQzED5qr1K+Npm1iT/e+kozKeNqYDK38FaO8iNN3lJA4/rpeTbYr
         dlYV/RG+pm7+inWjhZZmzdnN+h9obwPsNtupVwndxJ5kqCU27DKJl8Phcwppb3YwkL
         c3nyVa0GVJSdM+TrRD6dTeCmmPJVcQGdPJEpynuT1bu9AMBwwjEUL9c0XAd57hBwCR
         QejP4ZTuer2rQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 26/30] crypto: chelsio - stop using crypto_ahash::init
Date:   Sun, 22 Oct 2023 01:10:56 -0700
Message-ID: <20231022081100.123613-27-ebiggers@kernel.org>
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
code, which is unnecessary and inefficient.  The chelsio driver is one
of those drivers.  Make it just call its own code directly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 16298ae4a00bf..177428480c7d1 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1913,39 +1913,46 @@ static int chcr_ahash_finup(struct ahash_request *req)
 	set_wr_txq(skb, CPL_PRIORITY_DATA, req_ctx->txqidx);
 	chcr_send_wr(skb);
 	return -EINPROGRESS;
 unmap:
 	chcr_hash_dma_unmap(&u_ctx->lldi.pdev->dev, req);
 err:
 	chcr_dec_wrcount(dev);
 	return error;
 }
 
+static int chcr_hmac_init(struct ahash_request *areq);
+static int chcr_sha_init(struct ahash_request *areq);
+
 static int chcr_ahash_digest(struct ahash_request *req)
 {
 	struct chcr_ahash_req_ctx *req_ctx = ahash_request_ctx(req);
 	struct crypto_ahash *rtfm = crypto_ahash_reqtfm(req);
 	struct chcr_dev *dev = h_ctx(rtfm)->dev;
 	struct uld_ctx *u_ctx = ULD_CTX(h_ctx(rtfm));
 	struct chcr_context *ctx = h_ctx(rtfm);
 	struct sk_buff *skb;
 	struct hash_wr_param params;
 	u8  bs;
 	int error;
 	unsigned int cpu;
 
 	cpu = get_cpu();
 	req_ctx->txqidx = cpu % ctx->ntxq;
 	req_ctx->rxqidx = cpu % ctx->nrxq;
 	put_cpu();
 
-	rtfm->init(req);
+	if (is_hmac(crypto_ahash_tfm(rtfm)))
+		chcr_hmac_init(req);
+	else
+		chcr_sha_init(req);
+
 	bs = crypto_tfm_alg_blocksize(crypto_ahash_tfm(rtfm));
 	error = chcr_inc_wrcount(dev);
 	if (error)
 		return -ENXIO;
 
 	if (unlikely(cxgb4_is_crypto_q_full(u_ctx->lldi.ports[0],
 						req_ctx->txqidx) &&
 		(!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))) {
 			error = -ENOSPC;
 			goto err;
-- 
2.42.0

