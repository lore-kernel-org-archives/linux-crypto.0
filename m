Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF872C282C2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CC972184C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548283984;
	bh=MklWbl0VE4tMq0gPx0uCw+/dKmbmqahLBeql2PiT+OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bz4y3XrDtnXFwTrdHx/3J1VQxp0c0D2S5p3nU7xcdkP84Ys0w6qHLPIDyG0j3SAgC
	 sfbZyVBomoPiulw6ZA9wFnm2nP40U9c10rjz38AU+kmhq0ZhMd5U7y54RCBHN8xaTT
	 yYY6Eem578ufLrFfC3VqU9cWHiqK7hl1+NgcXOp8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfAWWxD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:50202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbfAWWwg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 17:52:36 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A42DD218A4;
        Wed, 23 Jan 2019 22:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548283955;
        bh=MklWbl0VE4tMq0gPx0uCw+/dKmbmqahLBeql2PiT+OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ATCOtA5Lnk4UpQpYP+YUqXTDw7+dXwjgJP5gLLviW23QeYABiPNd35f2rrQGvlIE4
         z7KWMXE+p1utFpy1WacgOeRRPStqO92A3NJsQ03I4L2XUUa3YKM90gWci+ioS/8O0z
         yFDL7CpFMt7xK73hbsnKbqH2NaP41gwley9W1y04=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [RFC/RFT PATCH 15/15] crypto: testmgr - check for aead_request corruption
Date:   Wed, 23 Jan 2019 14:49:26 -0800
Message-Id: <20190123224926.250525-16-ebiggers@kernel.org>
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

Check that algorithms do not change the aead_request structure, as users
may rely on submitting the request again (e.g. after copying new data
into the same source buffer) without reinitializing everything.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index e5f06844c793..8e36fa3605d7 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1254,6 +1254,50 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 		return -EINVAL;
 	}
 
+	/* Check that the algorithm didn't overwrite things it shouldn't have */
+	if (req->cryptlen != (enc ? vec->plen : vec->clen) ||
+	    req->assoclen != vec->alen ||
+	    req->iv != iv ||
+	    req->src != tsgls->src.sgl_ptr ||
+	    req->dst != tsgls->dst.sgl_ptr ||
+	    crypto_aead_reqtfm(req) != tfm ||
+	    req->base.complete != crypto_req_done ||
+	    req->base.flags != req_flags ||
+	    req->base.data != &wait) {
+		pr_err("alg: aead: %s %s corrupted request struct on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		if (req->cryptlen != (enc ? vec->plen : vec->clen))
+			pr_err("alg: aead: changed 'req->cryptlen'\n");
+		if (req->assoclen != vec->alen)
+			pr_err("alg: aead: changed 'req->assoclen'\n");
+		if (req->iv != iv)
+			pr_err("alg: aead: changed 'req->iv'\n");
+		if (req->src != tsgls->src.sgl_ptr)
+			pr_err("alg: aead: changed 'req->src'\n");
+		if (req->dst != tsgls->dst.sgl_ptr)
+			pr_err("alg: aead: changed 'req->dst'\n");
+		if (crypto_aead_reqtfm(req) != tfm)
+			pr_err("alg: aead: changed 'req->base.tfm'\n");
+		if (req->base.complete != crypto_req_done)
+			pr_err("alg: aead: changed 'req->base.complete'\n");
+		if (req->base.flags != req_flags)
+			pr_err("alg: aead: changed 'req->base.flags'\n");
+		if (req->base.data != &wait)
+			pr_err("alg: aead: changed 'req->base.data'\n");
+		return -EINVAL;
+	}
+	if (is_test_sglist_corrupted(&tsgls->src)) {
+		pr_err("alg: aead: %s %s corrupted src sgl on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return -EINVAL;
+	}
+	if (tsgls->dst.sgl_ptr != tsgls->src.sgl &&
+	    is_test_sglist_corrupted(&tsgls->dst)) {
+		pr_err("alg: aead: %s %s corrupted dst sgl on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return -EINVAL;
+	}
+
 	/* Check for the correct output (ciphertext or plaintext) */
 	err = verify_correct_output(&tsgls->dst, enc ? vec->ctext : vec->ptext,
 				    enc ? vec->clen : vec->plen,
-- 
2.20.1.321.g9e740568ce-goog

