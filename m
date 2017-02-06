From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: linux-next: build warnings after merge of the crypto tree
Date: Mon, 6 Feb 2017 17:03:40 +0800
Message-ID: <20170206090340.GA9531@gondor.apana.org.au>
References: <20170206122837.0226fb89@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170206122837.0226fb89@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephen:

On Mon, Feb 06, 2017 at 12:28:37PM +1100, Stephen Rothwell wrote:
> 
> After merging the crypto tree, today's linux-next build (x86_64
> allmodconfig) produced these warnings:
> 
> warning: (CRYPTO_DEV_ATMEL_AUTHENC) selects CRYPTO_DEV_ATMEL_SHA which has unmet direct dependencies (CRYPTO && CRYPTO_HW && ARCH_AT91)
> warning: (CRYPTO_DEV_ATMEL_AUTHENC) selects CRYPTO_DEV_ATMEL_SHA which has unmet direct dependencies (CRYPTO && CRYPTO_HW && ARCH_AT91)
> 
> Introduced by commit
> 
>   89a82ef87e01 ("crypto: atmel-authenc - add support to authenc(hmac(shaX), Y(aes)) modes")
> 
> In file included from include/linux/printk.h:329:0,
>                  from include/linux/kernel.h:13,
>                  from drivers/crypto/atmel-sha.c:17:

This patch should fix both issues.  Thanks,

---8<---
Subject: crypto: atmel - Fix authenc compile test warnings

The authenc code depends on the sha code so in order to allow
compile testing on the former we must allow it on sha as well.

This patch enables compile testing on sha as well as tdes and
fixes the few x86-64 warnings that arise in the sha code.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 7482461..9b7e19e 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -444,7 +444,7 @@ config CRYPTO_DEV_ATMEL_AES
 
 config CRYPTO_DEV_ATMEL_TDES
 	tristate "Support for Atmel DES/TDES hw accelerator"
-	depends on ARCH_AT91
+	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
 	help
@@ -457,7 +457,7 @@ config CRYPTO_DEV_ATMEL_TDES
 
 config CRYPTO_DEV_ATMEL_SHA
 	tristate "Support for Atmel SHA hw accelerator"
-	depends on ARCH_AT91
+	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_HASH
 	help
 	  Some Atmel processors have SHA1/SHA224/SHA256/SHA384/SHA512
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 22d0c0c..b081e78 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -568,7 +568,7 @@ static int atmel_sha_xmit_cpu(struct atmel_sha_dev *dd, const u8 *buf,
 	int count, len32;
 	const u32 *buffer = (const u32 *)buf;
 
-	dev_dbg(dd->dev, "xmit_cpu: digcnt: 0x%llx 0x%llx, length: %d, final: %d\n",
+	dev_dbg(dd->dev, "xmit_cpu: digcnt: 0x%llx 0x%llx, length: %zu, final: %d\n",
 		ctx->digcnt[1], ctx->digcnt[0], length, final);
 
 	atmel_sha_write_ctrl(dd, 0);
@@ -597,7 +597,7 @@ static int atmel_sha_xmit_pdc(struct atmel_sha_dev *dd, dma_addr_t dma_addr1,
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(dd->req);
 	int len32;
 
-	dev_dbg(dd->dev, "xmit_pdc: digcnt: 0x%llx 0x%llx, length: %d, final: %d\n",
+	dev_dbg(dd->dev, "xmit_pdc: digcnt: 0x%llx 0x%llx, length: %zu, final: %d\n",
 		ctx->digcnt[1], ctx->digcnt[0], length1, final);
 
 	len32 = DIV_ROUND_UP(length1, sizeof(u32));
@@ -644,7 +644,7 @@ static int atmel_sha_xmit_dma(struct atmel_sha_dev *dd, dma_addr_t dma_addr1,
 	struct dma_async_tx_descriptor	*in_desc;
 	struct scatterlist sg[2];
 
-	dev_dbg(dd->dev, "xmit_dma: digcnt: 0x%llx 0x%llx, length: %d, final: %d\n",
+	dev_dbg(dd->dev, "xmit_dma: digcnt: 0x%llx 0x%llx, length: %zu, final: %d\n",
 		ctx->digcnt[1], ctx->digcnt[0], length1, final);
 
 	dd->dma_lch_in.dma_conf.src_maxburst = 16;
@@ -723,7 +723,7 @@ static int atmel_sha_xmit_dma_map(struct atmel_sha_dev *dd,
 	ctx->dma_addr = dma_map_single(dd->dev, ctx->buffer,
 				ctx->buflen + ctx->block_size, DMA_TO_DEVICE);
 	if (dma_mapping_error(dd->dev, ctx->dma_addr)) {
-		dev_err(dd->dev, "dma %u bytes error\n", ctx->buflen +
+		dev_err(dd->dev, "dma %zu bytes error\n", ctx->buflen +
 				ctx->block_size);
 		atmel_sha_complete(dd, -EINVAL);
 	}
@@ -744,7 +744,7 @@ static int atmel_sha_update_dma_slow(struct atmel_sha_dev *dd)
 
 	final = (ctx->flags & SHA_FLAGS_FINUP) && !ctx->total;
 
-	dev_dbg(dd->dev, "slow: bufcnt: %u, digcnt: 0x%llx 0x%llx, final: %d\n",
+	dev_dbg(dd->dev, "slow: bufcnt: %zu, digcnt: 0x%llx 0x%llx, final: %d\n",
 		 ctx->bufcnt, ctx->digcnt[1], ctx->digcnt[0], final);
 
 	if (final)
@@ -772,7 +772,7 @@ static int atmel_sha_update_dma_start(struct atmel_sha_dev *dd)
 	if (ctx->bufcnt || ctx->offset)
 		return atmel_sha_update_dma_slow(dd);
 
-	dev_dbg(dd->dev, "fast: digcnt: 0x%llx 0x%llx, bufcnt: %u, total: %u\n",
+	dev_dbg(dd->dev, "fast: digcnt: 0x%llx 0x%llx, bufcnt: %zu, total: %u\n",
 		ctx->digcnt[1], ctx->digcnt[0], ctx->bufcnt, ctx->total);
 
 	sg = ctx->sg;
@@ -814,7 +814,7 @@ static int atmel_sha_update_dma_start(struct atmel_sha_dev *dd)
 		ctx->dma_addr = dma_map_single(dd->dev, ctx->buffer,
 			ctx->buflen + ctx->block_size, DMA_TO_DEVICE);
 		if (dma_mapping_error(dd->dev, ctx->dma_addr)) {
-			dev_err(dd->dev, "dma %u bytes error\n",
+			dev_err(dd->dev, "dma %zu bytes error\n",
 				ctx->buflen + ctx->block_size);
 			atmel_sha_complete(dd, -EINVAL);
 		}
@@ -994,7 +994,7 @@ static int atmel_sha_finish(struct ahash_request *req)
 	if (ctx->digcnt[0] || ctx->digcnt[1])
 		atmel_sha_copy_ready_hash(req);
 
-	dev_dbg(dd->dev, "digcnt: 0x%llx 0x%llx, bufcnt: %d\n", ctx->digcnt[1],
+	dev_dbg(dd->dev, "digcnt: 0x%llx 0x%llx, bufcnt: %zu\n", ctx->digcnt[1],
 		ctx->digcnt[0], ctx->bufcnt);
 
 	return 0;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
