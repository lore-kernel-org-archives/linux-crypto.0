Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F75C282C2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4CF1218A1
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548283998;
	bh=SCp6vGorxapnyCSsitgDpGs2nA2Hjs2F3NlkEJukUNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0rSZbQJzEJgXGexbDvyAWhaHsCUYg/pj/GqbPflLl1A255bcgI0e/e5wG7V6HeCBM
	 cxMD19L6aaL/lpN5MoLoT6D8TphAO0exg6xy7BYK/Hp33OPs88PP+5wpSCFmcQxAE0
	 RMSa8jVAk+g46BeXRFO0TBoMd4WBf68LGbpxhKpE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfAWWxJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:53:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbfAWWwg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 17:52:36 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61201218A3;
        Wed, 23 Jan 2019 22:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548283955;
        bh=SCp6vGorxapnyCSsitgDpGs2nA2Hjs2F3NlkEJukUNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1mHp3y1y9PPNdiEDDxvtQ/nPGTwEjKGjh4D+mcJr8rzy7k7o1e1xWnFA2AEFAZ3dd
         UCj74agu7P1UIAhyWjIirOosSBlhbLdrND/4FdSP66dsNQeIbxx/Wjp4QgMRCW2Hjg
         RAkgT5lL9VC1K518R2Y3dA//rQIx56fATIl8NK4c=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [RFC/RFT PATCH 14/15] crypto: testmgr - check for skcipher_request corruption
Date:   Wed, 23 Jan 2019 14:49:25 -0800
Message-Id: <20190123224926.250525-15-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
In-Reply-To: <20190123224926.250525-1-ebiggers@kernel.org>
References: <20190123224926.250525-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Check that algorithms do not change the skcipher_request structure, as
users may rely on submitting the request again (e.g. after copying new
data into the same source buffer) without reinitializing everything.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index fa971b83d3d2..e5f06844c793 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1536,6 +1536,47 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 		return err;
 	}
 
+	/* Check that the algorithm didn't overwrite things it shouldn't have */
+	if (req->cryptlen != vec->len ||
+	    req->iv != iv ||
+	    req->src != tsgls->src.sgl_ptr ||
+	    req->dst != tsgls->dst.sgl_ptr ||
+	    crypto_skcipher_reqtfm(req) != tfm ||
+	    req->base.complete != crypto_req_done ||
+	    req->base.flags != req_flags ||
+	    req->base.data != &wait) {
+		pr_err("alg: skcipher: %s %s corrupted request struct on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		if (req->cryptlen != vec->len)
+			pr_err("alg: skcipher: changed 'req->cryptlen'\n");
+		if (req->iv != iv)
+			pr_err("alg: skcipher: changed 'req->iv'\n");
+		if (req->src != tsgls->src.sgl_ptr)
+			pr_err("alg: skcipher: changed 'req->src'\n");
+		if (req->dst != tsgls->dst.sgl_ptr)
+			pr_err("alg: skcipher: changed 'req->dst'\n");
+		if (crypto_skcipher_reqtfm(req) != tfm)
+			pr_err("alg: skcipher: changed 'req->base.tfm'\n");
+		if (req->base.complete != crypto_req_done)
+			pr_err("alg: skcipher: changed 'req->base.complete'\n");
+		if (req->base.flags != req_flags)
+			pr_err("alg: skcipher: changed 'req->base.flags'\n");
+		if (req->base.data != &wait)
+			pr_err("alg: skcipher: changed 'req->base.data'\n");
+		return -EINVAL;
+	}
+	if (is_test_sglist_corrupted(&tsgls->src)) {
+		pr_err("alg: skcipher: %s %s corrupted src sgl on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return -EINVAL;
+	}
+	if (tsgls->dst.sgl_ptr != tsgls->src.sgl &&
+	    is_test_sglist_corrupted(&tsgls->dst)) {
+		pr_err("alg: skcipher: %s %s corrupted dst sgl on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return -EINVAL;
+	}
+
 	/* Check for the correct output (ciphertext or plaintext) */
 	err = verify_correct_output(&tsgls->dst, enc ? vec->ctext : vec->ptext,
 				    vec->len, 0, true);
-- 
2.20.1.321.g9e740568ce-goog

