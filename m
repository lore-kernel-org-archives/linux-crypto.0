From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 3/3] crypto: tegra-aes - Staticize tegra_aes_cra_exit
Date: Fri, 13 Sep 2013 17:06:47 +0530
Message-ID: <1379072207-11179-3-git-send-email-sachin.kamat@linaro.org>
References: <1379072207-11179-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, sachin.kamat@linaro.org,
	Stephen Warren <swarren@wwwdotorg.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60310 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab3IMLzB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Sep 2013 07:55:01 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp13so2429690pab.21
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2013 04:55:00 -0700 (PDT)
In-Reply-To: <1379072207-11179-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

'tegra_aes_cra_exit' is used only in this file.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/crypto/tegra-aes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 2d58da9..4f5f715 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -804,7 +804,7 @@ static int tegra_aes_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-void tegra_aes_cra_exit(struct crypto_tfm *tfm)
+static void tegra_aes_cra_exit(struct crypto_tfm *tfm)
 {
 	struct tegra_aes_ctx *ctx =
 		crypto_ablkcipher_ctx((struct crypto_ablkcipher *)tfm);
-- 
1.7.9.5
