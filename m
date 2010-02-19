From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 07/19] crypto: seed - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:22:18 +0100
Message-ID: <1266538939-3311-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44202 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab0BSAWg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Feb 2010 19:22:36 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/seed.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/seed.c b/crypto/seed.c
index d3e422f..3c0afae 100644
--- a/crypto/seed.c
+++ b/crypto/seed.c
@@ -329,7 +329,7 @@ static const u32 KC[SEED_NUM_KCONSTANTS] = {
 	X2 ^= t1;
 
 static int seed_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-		        unsigned int key_len)
+                        unsigned int key_len)
 {
 	struct seed_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *keyout = ctx->keysched;
-- 
1.6.6.1

