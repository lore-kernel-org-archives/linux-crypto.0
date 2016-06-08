From: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] crypto: ux500: memmove the right size
Date: Wed,  8 Jun 2016 14:56:39 +0200
Message-ID: <1465390599-20605-1-git-send-email-linus.walleij@linaro.org>
Cc: David Binderman <linuxdev.baldrick@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Joakim Bech <joakim.bech@linaro.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35142 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161222AbcFHM5A (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2016 08:57:00 -0400
Received: by mail-lf0-f45.google.com with SMTP id u74so5172181lff.2
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jun 2016 05:56:59 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The hash buffer is really HASH_BLOCK_SIZE bytes, someone
must have thought that memmove takes n*u32 words by mistake.
Tests work as good/bad as before after this patch.

Cc: Joakim Bech <joakim.bech@linaro.org>
Reported-by: David Binderman <linuxdev.baldrick@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/ux500/hash/hash_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 574e87c7f2b8..9acccad26928 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -781,7 +781,7 @@ static int hash_process_data(struct hash_device_data *device_data,
 						&device_data->state);
 				memmove(req_ctx->state.buffer,
 					device_data->state.buffer,
-					HASH_BLOCK_SIZE / sizeof(u32));
+					HASH_BLOCK_SIZE);
 				if (ret) {
 					dev_err(device_data->dev,
 						"%s: hash_resume_state() failed!\n",
@@ -832,7 +832,7 @@ static int hash_process_data(struct hash_device_data *device_data,
 
 			memmove(device_data->state.buffer,
 				req_ctx->state.buffer,
-				HASH_BLOCK_SIZE / sizeof(u32));
+				HASH_BLOCK_SIZE);
 			if (ret) {
 				dev_err(device_data->dev, "%s: hash_save_state() failed!\n",
 					__func__);
-- 
2.4.11
