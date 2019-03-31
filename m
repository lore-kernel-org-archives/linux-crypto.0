Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2AFC10F12
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F2AD21874
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554062764;
	bh=cBx8qUpjy5tFMB08r6g5uY+16VQVD5GDook0Pbk3ik8=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wF70dQCZ5IemoW37cabm1aV7+PLODDZ8KrxQ96iWg7tDeC3Eqmjhapz2p1cemdqyf
	 pdtHOHdz0gcL9LuCBw970h6V+s4IMTQz8c9m99sN/tdzoKL5G0y20N41xuZ0G6jI/j
	 +ePnjSJGpNa3chftKVOnXt+rmPILCYGKgHr7/aPs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731326AbfCaUGC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 16:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731467AbfCaUF7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 16:05:59 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A0C721874
        for <linux-crypto@vger.kernel.org>; Sun, 31 Mar 2019 20:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554062758;
        bh=cBx8qUpjy5tFMB08r6g5uY+16VQVD5GDook0Pbk3ik8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gPiVCHCYQgeQUI+9VBgKrjea7YIZtfHPy+oUSZrOEogmMphKTFv1JWXyaRe3oV7Rv
         28I8+p4Kxxa4d1ppJbSfHf5s6RbqM9rPQzD/nK9Pe93UFbR5pF/58UiYahVjewhY1/
         K5W5MfMUVda1gAHVCYjYQjGQGOGqn61A5teKppbc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [RFC/RFT PATCH 10/18] crypto: cts - don't support empty messages
Date:   Sun, 31 Mar 2019 13:04:20 -0700
Message-Id: <20190331200428.26597-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190331200428.26597-1-ebiggers@kernel.org>
References: <20190331200428.26597-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

My patches to make testmgr fuzz algorithms against their generic
implementation detected that the arm64 implementations of
"cts(cbc(aes))" handle empty messages differently from the cts template.
Namely, the arm64 implementations forbids (with -EINVAL) all messages
shorter than the block size, including the empty message; but the cts
template permits empty messages as a special case.

No user should be CTS-encrypting/decrypting empty messages, but we need
to keep the behavior consistent.  Unfortunately, as noted in the source
of OpenSSL's CTS implementation [1], there's no common specification for
CTS.  This makes it somewhat debatable what the behavior should be.

However, all CTS specifications seem to agree that messages shorter than
the block size are not allowed, and OpenSSL follows this in both CTS
conventions it implements.  It would also simplify the user-visible
semantics to have empty messages no longer be a special case.

Therefore, make the cts template return -EINVAL on *all* messages
shorter than the block size, including the empty message.

[1] https://github.com/openssl/openssl/blob/master/crypto/modes/cts128.c

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cts.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/crypto/cts.c b/crypto/cts.c
index 4e28d83ae37da..9441da797bb90 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -152,12 +152,14 @@ static int crypto_cts_encrypt(struct skcipher_request *req)
 	struct skcipher_request *subreq = &rctx->subreq;
 	int bsize = crypto_skcipher_blocksize(tfm);
 	unsigned int nbytes = req->cryptlen;
-	int cbc_blocks = (nbytes + bsize - 1) / bsize - 1;
 	unsigned int offset;
 
 	skcipher_request_set_tfm(subreq, ctx->child);
 
-	if (cbc_blocks <= 0) {
+	if (nbytes < bsize)
+		return -EINVAL;
+
+	if (nbytes == bsize) {
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      req->base.complete,
 					      req->base.data);
@@ -166,7 +168,7 @@ static int crypto_cts_encrypt(struct skcipher_request *req)
 		return crypto_skcipher_encrypt(subreq);
 	}
 
-	offset = cbc_blocks * bsize;
+	offset = rounddown(nbytes - 1, bsize);
 	rctx->offset = offset;
 
 	skcipher_request_set_callback(subreq, req->base.flags,
@@ -244,13 +246,15 @@ static int crypto_cts_decrypt(struct skcipher_request *req)
 	struct skcipher_request *subreq = &rctx->subreq;
 	int bsize = crypto_skcipher_blocksize(tfm);
 	unsigned int nbytes = req->cryptlen;
-	int cbc_blocks = (nbytes + bsize - 1) / bsize - 1;
 	unsigned int offset;
 	u8 *space;
 
 	skcipher_request_set_tfm(subreq, ctx->child);
 
-	if (cbc_blocks <= 0) {
+	if (nbytes < bsize)
+		return -EINVAL;
+
+	if (nbytes == bsize) {
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      req->base.complete,
 					      req->base.data);
@@ -264,10 +268,10 @@ static int crypto_cts_decrypt(struct skcipher_request *req)
 
 	space = crypto_cts_reqctx_space(req);
 
-	offset = cbc_blocks * bsize;
+	offset = rounddown(nbytes - 1, bsize);
 	rctx->offset = offset;
 
-	if (cbc_blocks <= 1)
+	if (offset <= bsize)
 		memcpy(space, req->iv, bsize);
 	else
 		scatterwalk_map_and_copy(space, req->src, offset - 2 * bsize,
-- 
2.21.0

