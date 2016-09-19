From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 2/8] crypto: omap-sham: align algorithms on word offset
Date: Mon, 19 Sep 2016 18:22:13 +0300
Message-ID: <1474298539-23897-3-git-send-email-t-kristo@ti.com>
References: <1474298539-23897-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:38771 "EHLO arroyo.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751646AbcISPXL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2016 11:23:11 -0400
In-Reply-To: <1474298539-23897-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

OMAP HW generally expects data for DMA to be on word boundary, so make the
SHA driver inform crypto framework of the same preference.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 74653c9..3f2bf98 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1368,7 +1368,7 @@ static struct ahash_alg algs_sha1_md5[] = {
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
-		.cra_alignmask		= 0,
+		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_init,
 		.cra_exit		= omap_sham_cra_exit,
@@ -1467,7 +1467,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA224_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
-		.cra_alignmask		= 0,
+		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_init,
 		.cra_exit		= omap_sham_cra_exit,
@@ -1489,7 +1489,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA256_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
-		.cra_alignmask		= 0,
+		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_init,
 		.cra_exit		= omap_sham_cra_exit,
@@ -1562,7 +1562,7 @@ static struct ahash_alg algs_sha384_sha512[] = {
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA384_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
-		.cra_alignmask		= 0,
+		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_init,
 		.cra_exit		= omap_sham_cra_exit,
@@ -1584,7 +1584,7 @@ static struct ahash_alg algs_sha384_sha512[] = {
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA512_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
-		.cra_alignmask		= 0,
+		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_init,
 		.cra_exit		= omap_sham_cra_exit,
-- 
1.9.1
