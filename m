From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 1/2] crypto: echainiv - Remove unused alg/spawn variable
Date: Tue, 12 Dec 2017 19:30:13 +0000
Message-ID: <1513107014-11975-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:42022 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752247AbdLLTaa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Dec 2017 14:30:30 -0500
Received: by mail-wm0-f66.google.com with SMTP id b199so834856wme.1
        for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2017 11:30:29 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch remove two unused variable and some dead "code" using it.

Fixes: 66008d4230f6 ("crypto: echainiv - Remove AEAD compatibility code")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/echainiv.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index e3d889b122e0..45819e6015bf 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -118,8 +118,6 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 				struct rtattr **tb)
 {
 	struct aead_instance *inst;
-	struct crypto_aead_spawn *spawn;
-	struct aead_alg *alg;
 	int err;
 
 	inst = aead_geniv_alloc(tmpl, tb, 0, 0);
@@ -127,9 +125,6 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
 
-	spawn = aead_instance_ctx(inst);
-	alg = crypto_spawn_aead_alg(spawn);
-
 	err = -EINVAL;
 	if (inst->alg.ivsize & (sizeof(u64) - 1) || !inst->alg.ivsize)
 		goto free_inst;
-- 
2.13.6
