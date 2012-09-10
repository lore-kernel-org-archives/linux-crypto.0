From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH] crypto: caam - change key gen functions to return signed
 int
Date: Mon, 10 Sep 2012 11:50:51 -0500
Message-ID: <20120910115051.5df72bade33a67c816ab048b@freescale.com>
References: <20120906153550.e159a02bfc2ba3f153df101d@freescale.com>
	<50491171.9030300@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:6624
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935Ab2IJQxJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Sep 2012 12:53:09 -0400
Received: from mail85-co1 (localhost [127.0.0.1])	by mail85-co1-R.bigfish.com
 (Postfix) with ESMTP id AEB3D180156	for <linux-crypto@vger.kernel.org>; Mon,
 10 Sep 2012 16:53:07 +0000 (UTC)
Received: from CO1EHSMHS022.bigfish.com (unknown [10.243.78.252])	by
 mail85-co1.bigfish.com (Postfix) with ESMTP id 0F8C32E0046	for
 <linux-crypto@vger.kernel.org>; Mon, 10 Sep 2012 16:53:05 +0000 (UTC)
Received: from x9.am.freescale.net (x9.am.freescale.net [10.82.120.9])	by
 tx30smr01.am.freescale.net (8.14.3/8.14.0) with SMTP id q8AGr0JR001600	for
 <linux-crypto@vger.kernel.org>; Mon, 10 Sep 2012 09:53:00 -0700
In-Reply-To: <50491171.9030300@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The 'coccicheck fixes' commit added error return values yet
neglected to change the type from unsigned.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamhash.c | 4 ++--
 drivers/crypto/caam/key_gen.c  | 2 +-
 drivers/crypto/caam/key_gen.h  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index fbf3fe8..656cd4d 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -411,7 +411,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 	return 0;
 }
 
-static u32 gen_split_hash_key(struct caam_hash_ctx *ctx, const u8 *key_in,
+static int gen_split_hash_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 			      u32 keylen)
 {
 	return gen_split_key(ctx->jrdev, ctx->key, ctx->split_key_len,
@@ -420,7 +420,7 @@ static u32 gen_split_hash_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 }
 
 /* Digest hash size if it is too large */
-static u32 hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
+static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 			   u32 *keylen, u8 *key_out, u32 digestsize)
 {
 	struct device *jrdev = ctx->jrdev;
diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index 0028881..2eb8e28 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -44,7 +44,7 @@ Split key generation-----------------------------------------------
 [06] 0x64260028    fifostr: class2 mdsplit-jdk len=40
 			@0xffe04000
 */
-u32 gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
+int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 		  int split_key_pad_len, const u8 *key_in, u32 keylen,
 		  u32 alg_op)
 {
diff --git a/drivers/crypto/caam/key_gen.h b/drivers/crypto/caam/key_gen.h
index d95d290..c5588f6 100644
--- a/drivers/crypto/caam/key_gen.h
+++ b/drivers/crypto/caam/key_gen.h
@@ -12,6 +12,6 @@ struct split_key_result {
 
 void split_key_done(struct device *dev, u32 *desc, u32 err, void *context);
 
-u32 gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
+int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 		    int split_key_pad_len, const u8 *key_in, u32 keylen,
 		    u32 alg_op);
-- 
1.7.12
