From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] crypto: fix missing unlock on error case
Date: Sun, 21 Oct 2012 19:56:42 +0800
Message-ID: <CAPgLHd8f2UorFGa57n94k_7cbD8G3XNYVOkmHPqhySs2Nd0pNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, linux-crypto@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	grant.likely@secretlab.ca, rob.herring@calxeda.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35541 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab2JUL4n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Oct 2012 07:56:43 -0400
Received: by mail-qc0-f174.google.com with SMTP id o22so999108qcr.19
        for <linux-crypto@vger.kernel.org>; Sun, 21 Oct 2012 04:56:42 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock on the error handling path in function
tegra_aes_get_random() and tegra_aes_rng_reset().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/crypto/tegra-aes.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 37185e6..19adf1c 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -674,8 +674,10 @@ static int tegra_aes_get_random(struct crypto_rng *tfm, u8 *rdata,
 	mutex_lock(&aes_lock);
 
 	ret = clk_prepare_enable(dd->aes_clk);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&aes_lock);
 		return ret;
+	}
 
 	ctx->dd = dd;
 	dd->ctx = ctx;
@@ -759,8 +761,10 @@ static int tegra_aes_rng_reset(struct crypto_rng *tfm, u8 *seed,
 	dd->flags = FLAGS_ENCRYPT | FLAGS_RNG;
 
 	ret = clk_prepare_enable(dd->aes_clk);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&aes_lock);
 		return ret;
+	}
 
 	aes_set_key(dd);
 
