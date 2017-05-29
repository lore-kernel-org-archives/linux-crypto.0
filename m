From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v2 02/12] crypto: sun4i-ss: remove conditional checks against 0
Date: Mon, 29 May 2017 22:27:28 +0200
Message-ID: <20170529202738.2167-3-antoine.tenart@free-electrons.com>
References: <20170529202738.2167-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36565 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbdE2U2N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 16:28:13 -0400
In-Reply-To: <20170529202738.2167-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Cosmetic clean up if conditional checks on 0s values.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 28 +++++++++++-----------
 drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 10 ++++----
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c   | 40 +++++++++++++++----------------
 3 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index 90efd10d57a1..23e549204365 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -38,7 +38,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 	unsigned int oi, oo; /* offset for in and out */
 	unsigned long flags;
 
-	if (areq->nbytes == 0)
+	if (!areq->nbytes)
 		return 0;
 
 	if (!areq->info) {
@@ -82,7 +82,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 	oo = 0;
 	do {
 		todo = min3(rx_cnt, ileft, (mi.length - oi) / 4);
-		if (todo > 0) {
+		if (todo) {
 			ileft -= todo;
 			writesl(ss->base + SS_RXFIFO, mi.addr + oi, todo);
 			oi += todo * 4;
@@ -97,7 +97,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 		tx_cnt = SS_TXFIFO_SPACES(spaces);
 
 		todo = min3(tx_cnt, oleft, (mo.length - oo) / 4);
-		if (todo > 0) {
+		if (todo) {
 			oleft -= todo;
 			readsl(ss->base + SS_TXFIFO, mo.addr + oo, todo);
 			oo += todo * 4;
@@ -106,7 +106,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 			sg_miter_next(&mo);
 			oo = 0;
 		}
-	} while (oleft > 0);
+	} while (oleft);
 
 	if (areq->info) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
@@ -154,7 +154,7 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 	unsigned int obl = 0;	/* length of data in bufo */
 	unsigned long flags;
 
-	if (areq->nbytes == 0)
+	if (!areq->nbytes)
 		return 0;
 
 	if (!areq->info) {
@@ -172,12 +172,12 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 	 * we can use the SS optimized function
 	 */
 	while (in_sg && no_chunk == 1) {
-		if ((in_sg->length % 4) != 0)
+		if (in_sg->length % 4)
 			no_chunk = 0;
 		in_sg = sg_next(in_sg);
 	}
 	while (out_sg && no_chunk == 1) {
-		if ((out_sg->length % 4) != 0)
+		if (out_sg->length % 4)
 			no_chunk = 0;
 		out_sg = sg_next(out_sg);
 	}
@@ -214,14 +214,14 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 	oi = 0;
 	oo = 0;
 
-	while (oleft > 0) {
-		if (ileft > 0) {
+	while (oleft) {
+		if (ileft) {
 			/*
 			 * todo is the number of consecutive 4byte word that we
 			 * can read from current SG
 			 */
 			todo = min3(rx_cnt, ileft / 4, (mi.length - oi) / 4);
-			if (todo > 0 && ob == 0) {
+			if (todo && !ob) {
 				writesl(ss->base + SS_RXFIFO, mi.addr + oi,
 					todo);
 				ileft -= todo * 4;
@@ -240,7 +240,7 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 				ileft -= todo;
 				oi += todo;
 				ob += todo;
-				if (ob % 4 == 0) {
+				if (!(ob % 4)) {
 					writesl(ss->base + SS_RXFIFO, buf,
 						ob / 4);
 					ob = 0;
@@ -260,11 +260,11 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 			oi, mi.length, ileft, areq->nbytes, rx_cnt,
 			oo, mo.length, oleft, areq->nbytes, tx_cnt, ob);
 
-		if (tx_cnt == 0)
+		if (!tx_cnt)
 			continue;
 		/* todo in 4bytes word */
 		todo = min3(tx_cnt, oleft / 4, (mo.length - oo) / 4);
-		if (todo > 0) {
+		if (todo) {
 			readsl(ss->base + SS_TXFIFO, mo.addr + oo, todo);
 			oleft -= todo * 4;
 			oo += todo * 4;
@@ -516,7 +516,7 @@ int sun4i_ss_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	flags = crypto_ablkcipher_get_flags(tfm);
 
 	ret = des_ekey(tmp, key);
-	if (unlikely(ret == 0) && (flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+	if (unlikely(!ret) && (flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
 		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
 		dev_dbg(ss->dev, "Weak key %u\n", keylen);
 		return -EINVAL;
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
index 3ac6c6c4ad18..50af81c3eb45 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -266,12 +266,12 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 
 	/* Enable both clocks */
 	err = clk_prepare_enable(ss->busclk);
-	if (err != 0) {
+	if (err) {
 		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
 		return err;
 	}
 	err = clk_prepare_enable(ss->ssclk);
-	if (err != 0) {
+	if (err) {
 		dev_err(&pdev->dev, "Cannot prepare_enable ssclk\n");
 		goto error_ssclk;
 	}
@@ -281,7 +281,7 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 	 * Try to set the clock to the maximum allowed
 	 */
 	err = clk_set_rate(ss->ssclk, cr_mod);
-	if (err != 0) {
+	if (err) {
 		dev_err(&pdev->dev, "Cannot set clock rate to ssclk\n");
 		goto error_clk;
 	}
@@ -342,7 +342,7 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 		switch (ss_algs[i].type) {
 		case CRYPTO_ALG_TYPE_ABLKCIPHER:
 			err = crypto_register_alg(&ss_algs[i].alg.crypto);
-			if (err != 0) {
+			if (err) {
 				dev_err(ss->dev, "Fail to register %s\n",
 					ss_algs[i].alg.crypto.cra_name);
 				goto error_alg;
@@ -350,7 +350,7 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			err = crypto_register_ahash(&ss_algs[i].alg.hash);
-			if (err != 0) {
+			if (err) {
 				dev_err(ss->dev, "Fail to register %s\n",
 					ss_algs[i].alg.hash.halg.base.cra_name);
 				goto error_alg;
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 855325338844..39f0abe5ee25 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -60,7 +60,7 @@ int sun4i_hash_export_md5(struct ahash_request *areq, void *out)
 
 	memcpy(octx->block, op->buf, op->len);
 
-	if (op->byte_count > 0) {
+	if (op->byte_count) {
 		for (i = 0; i < 4; i++)
 			octx->hash[i] = op->hash[i];
 	} else {
@@ -102,7 +102,7 @@ int sun4i_hash_export_sha1(struct ahash_request *areq, void *out)
 
 	memcpy(octx->buffer, op->buf, op->len);
 
-	if (op->byte_count > 0) {
+	if (op->byte_count) {
 		for (i = 0; i < 5; i++)
 			octx->state[i] = op->hash[i];
 	} else {
@@ -195,7 +195,7 @@ static int sun4i_hash(struct ahash_request *areq)
 		op->byte_count, areq->nbytes, op->mode,
 		op->len, op->hash[0]);
 
-	if (unlikely(areq->nbytes == 0) && (op->flags & SS_HASH_FINAL) == 0)
+	if (unlikely(!areq->nbytes) && !(op->flags & SS_HASH_FINAL))
 		return 0;
 
 	/* protect against overflow */
@@ -204,7 +204,7 @@ static int sun4i_hash(struct ahash_request *areq)
 		return -EINVAL;
 	}
 
-	if (op->len + areq->nbytes < 64 && (op->flags & SS_HASH_FINAL) == 0) {
+	if (op->len + areq->nbytes < 64 && !(op->flags & SS_HASH_FINAL)) {
 		/* linearize data to op->buf */
 		copied = sg_pcopy_to_buffer(areq->src, sg_nents(areq->src),
 					    op->buf + op->len, areq->nbytes, 0);
@@ -218,7 +218,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	 * if some data have been processed before,
 	 * we need to restore the partial hash state
 	 */
-	if (op->byte_count > 0) {
+	if (op->byte_count) {
 		ivmode = SS_IV_ARBITRARY;
 		for (i = 0; i < 5; i++)
 			writel(op->hash[i], ss->base + SS_IV0 + i * 4);
@@ -226,11 +226,11 @@ static int sun4i_hash(struct ahash_request *areq)
 	/* Enable the device */
 	writel(op->mode | SS_ENABLED | ivmode, ss->base + SS_CTL);
 
-	if ((op->flags & SS_HASH_UPDATE) == 0)
+	if (!(op->flags & SS_HASH_UPDATE))
 		goto hash_final;
 
 	/* start of handling data */
-	if ((op->flags & SS_HASH_FINAL) == 0) {
+	if (!(op->flags & SS_HASH_FINAL)) {
 		end = ((areq->nbytes + op->len) / 64) * 64 - op->len;
 
 		if (end > areq->nbytes || areq->nbytes - end > 63) {
@@ -244,14 +244,14 @@ static int sun4i_hash(struct ahash_request *areq)
 		end = ((areq->nbytes + op->len) / 4) * 4 - op->len;
 	}
 
-	/* TODO if SGlen % 4 and op->len == 0 then DMA */
+	/* TODO if SGlen % 4 and !op->len then DMA */
 	i = 1;
 	while (in_sg && i == 1) {
-		if ((in_sg->length % 4) != 0)
+		if (in_sg->length % 4)
 			i = 0;
 		in_sg = sg_next(in_sg);
 	}
-	if (i == 1 && op->len == 0)
+	if (i == 1 && !op->len)
 		dev_dbg(ss->dev, "We can DMA\n");
 
 	i = 0;
@@ -266,7 +266,7 @@ static int sun4i_hash(struct ahash_request *areq)
 		 * - the buffer is already used
 		 * - the SG does not have enough byte remaining ( < 4)
 		 */
-		if (op->len > 0 || (mi.length - in_i) < 4) {
+		if (op->len || (mi.length - in_i) < 4) {
 			/*
 			 * if we have entered here we have two reason to stop
 			 * - the buffer is full
@@ -285,7 +285,7 @@ static int sun4i_hash(struct ahash_request *areq)
 					in_i = 0;
 				}
 			}
-			if (op->len > 3 && (op->len % 4) == 0) {
+			if (op->len > 3 && !(op->len % 4)) {
 				/* write buf to the device */
 				writesl(ss->base + SS_RXFIFO, op->buf,
 					op->len / 4);
@@ -304,7 +304,7 @@ static int sun4i_hash(struct ahash_request *areq)
 			i += todo * 4;
 			in_i += todo * 4;
 			rx_cnt -= todo;
-			if (rx_cnt == 0) {
+			if (!rx_cnt) {
 				spaces = readl(ss->base + SS_FCSR);
 				rx_cnt = SS_RXFIFO_SPACES(spaces);
 			}
@@ -342,7 +342,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	 * Now if we have the flag final go to finalize part
 	 * If not, store the partial hash
 	 */
-	if ((op->flags & SS_HASH_FINAL) > 0)
+	if (op->flags & SS_HASH_FINAL)
 		goto hash_final;
 
 	writel(op->mode | SS_ENABLED | SS_DATA_END, ss->base + SS_CTL);
@@ -350,7 +350,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	do {
 		v = readl(ss->base + SS_CTL);
 		i++;
-	} while (i < SS_TIMEOUT && (v & SS_DATA_END) > 0);
+	} while (i < SS_TIMEOUT && (v & SS_DATA_END));
 	if (unlikely(i >= SS_TIMEOUT)) {
 		dev_err_ratelimited(ss->dev,
 				    "ERROR: hash end timeout %d>%d ctl=%x len=%u\n",
@@ -379,9 +379,9 @@ static int sun4i_hash(struct ahash_request *areq)
 hash_final:
 
 	/* write the remaining words of the wait buffer */
-	if (op->len > 0) {
+	if (op->len) {
 		nwait = op->len / 4;
-		if (nwait > 0) {
+		if (nwait) {
 			writesl(ss->base + SS_RXFIFO, op->buf, nwait);
 			op->byte_count += 4 * nwait;
 		}
@@ -391,7 +391,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	}
 
 	/* write the remaining bytes of the nbw buffer */
-	if (nbw > 0) {
+	if (nbw) {
 		wb |= ((1 << 7) << (nbw * 8));
 		bf[j++] = wb;
 	} else {
@@ -444,7 +444,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	do {
 		v = readl(ss->base + SS_CTL);
 		i++;
-	} while (i < SS_TIMEOUT && (v & SS_DATA_END) > 0);
+	} while (i < SS_TIMEOUT && (v & SS_DATA_END));
 	if (unlikely(i >= SS_TIMEOUT)) {
 		dev_err_ratelimited(ss->dev,
 				    "ERROR: hash end timeout %d>%d ctl=%x len=%u\n",
@@ -504,7 +504,7 @@ int sun4i_hash_digest(struct ahash_request *areq)
 	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
 
 	err = sun4i_hash_init(areq);
-	if (err != 0)
+	if (err)
 		return err;
 
 	op->flags = SS_HASH_UPDATE | SS_HASH_FINAL;
-- 
2.9.4
