From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in deflate.c
Date: Wed, 10 Feb 2010 02:34:15 +0100
Message-ID: <1265765656-26181-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53956 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab0BJBeu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 20:34:50 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/deflate.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index 9128da4..463dc85 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -1,14 +1,14 @@
-/* 
+/*
  * Cryptographic API.
  *
  * Deflate algorithm (RFC 1951), implemented here primarily for use
  * by IPCOMP (RFC 3173 & RFC 2394).
  *
  * Copyright (c) 2003 James Morris <jmorris@intercode.com.au>
- * 
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
+ * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
  * FIXME: deflate transforms will require up to a total of about 436k of kernel
@@ -49,7 +49,7 @@ static int deflate_comp_init(struct deflate_ctx *ctx)
 	struct z_stream_s *stream = &ctx->comp_stream;
 
 	stream->workspace = vmalloc(zlib_deflate_workspacesize());
-	if (!stream->workspace ) {
+	if (!stream->workspace) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -61,7 +61,7 @@ static int deflate_comp_init(struct deflate_ctx *ctx)
 		ret = -EINVAL;
 		goto out_free;
 	}
-out:	
+out:
 	return ret;
 out_free:
 	vfree(stream->workspace);
@@ -74,7 +74,7 @@ static int deflate_decomp_init(struct deflate_ctx *ctx)
 	struct z_stream_s *stream = &ctx->decomp_stream;
 
 	stream->workspace = kzalloc(zlib_inflate_workspacesize(), GFP_KERNEL);
-	if (!stream->workspace ) {
+	if (!stream->workspace) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -106,7 +106,7 @@ static int deflate_init(struct crypto_tfm *tfm)
 {
 	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
 	int ret;
-	
+
 	ret = deflate_comp_init(ctx);
 	if (ret)
 		goto out;
@@ -153,11 +153,11 @@ static int deflate_compress(struct crypto_tfm *tfm, const u8 *src,
 out:
 	return ret;
 }
- 
+
 static int deflate_decompress(struct crypto_tfm *tfm, const u8 *src,
 			      unsigned int slen, u8 *dst, unsigned int *dlen)
 {
-	
+
 	int ret = 0;
 	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
 	struct z_stream_s *stream = &dctx->decomp_stream;
@@ -182,7 +182,7 @@ static int deflate_decompress(struct crypto_tfm *tfm, const u8 *src,
 	if (ret == Z_OK && !stream->avail_in && stream->avail_out) {
 		u8 zerostuff = 0;
 		stream->next_in = &zerostuff;
-		stream->avail_in = 1; 
+		stream->avail_in = 1;
 		ret = zlib_inflate(stream, Z_FINISH);
 	}
 	if (ret != Z_STREAM_END) {
-- 
1.6.6.1

