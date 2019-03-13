Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2690C10F03
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0640218A3
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552454136;
	bh=vHRu0W9KwUGaloXhGjaFpSkQdr99+L7HhU0sp5EPj+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=k8kwXcvWiVJyB7VJaeXLZEC//x+yRuq7s1BviOnaakVyR32mQXPuf5mh0mQmW8+yW
	 bIrYZVfnX5MWU5JHd89Wnt/bCHJj7rEZjlMLsUgjTEDmRXZq16QFAYbDrT0tWX3s/d
	 SPHhrwnOoDkuU2/p5voi18JNeCozulr77iB1P82o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfCMFPf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 01:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbfCMFPf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 01:15:35 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 464F82183E;
        Wed, 13 Mar 2019 05:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552454134;
        bh=vHRu0W9KwUGaloXhGjaFpSkQdr99+L7HhU0sp5EPj+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qU1LRDFUW97TFZ1BeNbXj7hLZ9eyZr7HZRg6/2fXtXeYvSmqalfxeUwvQchaDg8CP
         QE0cxQGVVLQUvjAzptDVmZwrW9dpBZj6Xt+rYEu5CIhleXDDBoKZCwKF0f6IOQmms+
         V6Sd/9yMLMJ1ByU/RfNLGZs1HfSDN9e2/5jvLomc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: [PATCH 1/8] crypto: chacha-generic - fix use as arm64 no-NEON fallback
Date:   Tue, 12 Mar 2019 22:12:45 -0700
Message-Id: <20190313051252.2917-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190313051252.2917-1-ebiggers@kernel.org>
References: <20190313051252.2917-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The arm64 implementations of ChaCha and XChaCha are failing the extra
crypto self-tests following my patches to test the !may_use_simd() code
paths, which previously were untested.  The problem is as follows:

When !may_use_simd(), the arm64 NEON implementations fall back to the
generic implementation, which uses the skcipher_walk API to iterate
through the src/dst scatterlists.  Due to how the skcipher_walk API
works, walk.stride is set from the skcipher_alg actually being used,
which in this case is the arm64 NEON algorithm.  Thus walk.stride is
5*CHACHA_BLOCK_SIZE, not CHACHA_BLOCK_SIZE.

This unnecessarily large stride shouldn't cause an actual problem.
However, the generic implementation computes round_down(nbytes,
walk.stride).  round_down() assumes the round amount is a power of 2,
which 5*CHACHA_BLOCK_SIZE is not, so it gives the wrong result.

This causes the following case in skcipher_walk_done() to be hit,
causing a WARN() and failing the encryption operation:

	if (WARN_ON(err)) {
		/* unexpected case; didn't process all bytes */
		err = -EINVAL;
		goto finish;
	}

Fix it by rounding down to CHACHA_BLOCK_SIZE instead of walk.stride.

(Or we could replace round_down() with rounddown(), but that would add a
slow division operation every time, which I think we should avoid.)

Fixes: 2fe55987b262 ("crypto: arm64/chacha - use combined SIMD/ALU routine for more speed")
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/chacha_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
index 35b583101f4f..90ec0ec1b4f7 100644
--- a/crypto/chacha_generic.c
+++ b/crypto/chacha_generic.c
@@ -52,7 +52,7 @@ static int chacha_stream_xor(struct skcipher_request *req,
 		unsigned int nbytes = walk.nbytes;
 
 		if (nbytes < walk.total)
-			nbytes = round_down(nbytes, walk.stride);
+			nbytes = round_down(nbytes, CHACHA_BLOCK_SIZE);
 
 		chacha_docrypt(state, walk.dst.virt.addr, walk.src.virt.addr,
 			       nbytes, ctx->nrounds);
-- 
2.21.0

