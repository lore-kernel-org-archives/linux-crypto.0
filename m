From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCHv2 6/6] omap-aes: checkpatch --file warning fixes
Date: Tue, 30 Nov 2010 10:13:32 +0200
Message-ID: <4a86008d10891d67ba7ce1de03cd2da867255daf.1291104329.git.dmitry.kasatkin@nokia.com>
References: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:51699 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab0K3INE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Nov 2010 03:13:04 -0500
In-Reply-To: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
References: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-aes.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index b69da4f..add2a1a 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -96,7 +96,7 @@ struct omap_aes_reqctx {
 struct omap_aes_dev {
 	struct list_head	list;
 	unsigned long		phys_base;
-	void __iomem 		*io_base;
+	void __iomem		*io_base;
 	struct clk		*iclk;
 	struct omap_aes_ctx	*ctx;
 	struct device		*dev;
@@ -759,7 +759,7 @@ static struct crypto_alg algs[] = {
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
-	.cra_alignmask	 	= 0,
+	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= omap_aes_cra_init,
@@ -779,7 +779,7 @@ static struct crypto_alg algs[] = {
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
-	.cra_alignmask	 	= 0,
+	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= omap_aes_cra_init,
-- 
1.7.0.4
