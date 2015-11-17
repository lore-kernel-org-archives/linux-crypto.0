From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: atmel: fix 64-bit warnings
Date: Tue, 17 Nov 2015 10:22:06 +0100
Message-ID: <4444008.DmhAgm3J77@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Leilei Zhao <leilei.zhao@atmel.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Nicolas Royer <nicolas@eukrea.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:63168 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbbKQJY3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 04:24:29 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The atmel AES driver assumes that 'int' and 'size_t' are the same
type in multiple locations, which the compiler warns about when
building it for 64-bit systems:

In file included from ../drivers/crypto/atmel-aes.c:17:0:
drivers/crypto/atmel-aes.c: In function 'atmel_aes_sg_copy':
include/linux/kernel.h:724:17: warning: comparison of distinct pointer types lacks a cast
drivers/crypto/atmel-aes.c:448:11: note: in expansion of macro 'min'

drivers/crypto/atmel-aes.c: In function 'atmel_aes_crypt_dma_stop':
include/linux/kern_levels.h:4:18: warning: format '%u' expects argument of type 'unsigned int', but argument 2 has type 'size_t {aka long unsigned int}' [-Wformat=]

This changes the format strings to use the %z modifier when printing
a size_t, and makes sure that we use the correct size_t type where
needed. In case of sg_dma_len(), the type of the result depends
on CONFIG_NEED_SG_DMA_LENGTH, so we have to use min_t to get it to
work in all configurations.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index fb16d812c8f5..bfb1f799bf56 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -184,7 +184,7 @@ static int atmel_aes_sg_length(struct ablkcipher_request *req,
 static int atmel_aes_sg_copy(struct scatterlist **sg, size_t *offset,
 			void *buf, size_t buflen, size_t total, int out)
 {
-	unsigned int count, off = 0;
+	size_t count, off = 0;
 
 	while (buflen && total) {
 		count = min((*sg)->length - *offset, total);
@@ -444,8 +444,8 @@ static int atmel_aes_crypt_dma_start(struct atmel_aes_dev *dd)
 
 
 	if (fast)  {
-		count = min(dd->total, sg_dma_len(dd->in_sg));
-		count = min(count, sg_dma_len(dd->out_sg));
+		count = min_t(size_t, dd->total, sg_dma_len(dd->in_sg));
+		count = min_t(size_t, count, sg_dma_len(dd->out_sg));
 
 		err = dma_map_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		if (!err) {
@@ -639,7 +639,7 @@ static int atmel_aes_crypt_dma_stop(struct atmel_aes_dev *dd)
 				dd->buf_out, dd->buflen, dd->dma_size, 1);
 			if (count != dd->dma_size) {
 				err = -EINVAL;
-				pr_err("not all data converted: %u\n", count);
+				pr_err("not all data converted: %zu\n", count);
 			}
 		}
 	}
@@ -666,7 +666,7 @@ static int atmel_aes_buff_init(struct atmel_aes_dev *dd)
 	dd->dma_addr_in = dma_map_single(dd->dev, dd->buf_in,
 					dd->buflen, DMA_TO_DEVICE);
 	if (dma_mapping_error(dd->dev, dd->dma_addr_in)) {
-		dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
+		dev_err(dd->dev, "dma %zd bytes error\n", dd->buflen);
 		err = -EINVAL;
 		goto err_map_in;
 	}
@@ -674,7 +674,7 @@ static int atmel_aes_buff_init(struct atmel_aes_dev *dd)
 	dd->dma_addr_out = dma_map_single(dd->dev, dd->buf_out,
 					dd->buflen, DMA_FROM_DEVICE);
 	if (dma_mapping_error(dd->dev, dd->dma_addr_out)) {
-		dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
+		dev_err(dd->dev, "dma %zd bytes error\n", dd->buflen);
 		err = -EINVAL;
 		goto err_map_out;
 	}
