From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: authenc - cryptlen must be at least AAD len
Date: Wed, 06 Sep 2017 21:22:44 +0200
Message-ID: <4634467.01PS30tDXi@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34646 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750933AbdIFTWz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Sep 2017 15:22:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With AF_ALG, AAD len and cryptlen can be set freely by unprivileged
user space. The cipher implementation must therefore validate the input
data for sanity. For AEAD ciphers, this implies that cryptlen must be
at least as large as AAD size.

This fixes a kernel crash that can be triggered via AF_ALG detected by
the fuzzing test implemented with libkcapi.

CC: <stable@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/authenc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 875470b0e026..21e202fc32c1 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -209,6 +209,9 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 	struct scatterlist *src, *dst;
 	int err;
 
+	if (req->assoclen > cryptlen)
+		return -EINVAL;
+
 	src = scatterwalk_ffwd(areq_ctx->src, req->src, req->assoclen);
 	dst = src;
 
-- 
2.13.5
