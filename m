From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] crypto: stm32 - Try to fix hash padding
Date: Tue, 12 Sep 2017 11:35:39 +0200
Message-ID: <20170912093553.2580986-2-arnd@arndb.de>
References: <20170912093553.2580986-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Lionel Debieve <lionel.debieve@st.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:61513 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbdILJhH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Sep 2017 05:37:07 -0400
In-Reply-To: <20170912093553.2580986-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

gcc warns that the length for the extra unaligned data in the hash
function may be used unaligned. In theory this could happen if
we pass a zero-length sg_list, or if sg_is_last() was never true:

In file included from drivers/crypto/stm32/stm32-hash.c:23:
drivers/crypto/stm32/stm32-hash.c: In function 'stm32_hash_one_request':
include/uapi/linux/kernel.h:12:49: error: 'ncp' may be used uninitialized in this function [-Werror=maybe-uninitialized]
 #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))

Neither of these can happen in practice, so the warning is harmless.

However while trying to suppress the warning, I noticed multiple
problems with that code:

- On big-endian kernels, we byte-swap the data like we do for
  register accesses, however this is a data stream and almost
  certainly needs to use a single writesl() instead of series
  of writel() to give the correct hash.

- If the length is not a multiple of four bytes, we skip the
  last word entirely, since we write the truncated length
  using stm32_hash_set_nblw().

- If we change the code to round the length up rather than
  down, the last bytes contain stale data, so it needs some
  form of padding.

This tries to address all four problems, by correctly
initializing the length to zero, using endian-safe copy
functions, adding zero-padding and passing the padded length.

I have done no testing on this patch, so please review
carefully and if possible test with an unaligned length
and big-endian kernel builds.

Fixes: 8a1012d3f2ab ("crypto: stm32 - Support for STM32 HASH module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/stm32/stm32-hash.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 3c23a23e9ee5..b2ed2bccdb66 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -553,9 +553,9 @@ static int stm32_hash_dma_send(struct stm32_hash_dev *hdev)
 {
 	struct stm32_hash_request_ctx *rctx = ahash_request_ctx(hdev->req);
 	struct scatterlist sg[1], *tsg;
-	int err = 0, len = 0, reg, ncp;
+	int err = 0, len = 0, reg, ncp = 0;
 	unsigned int i;
-	const u32 *buffer = (const u32 *)rctx->buffer;
+	u32 *buffer = (void *)rctx->buffer;
 
 	rctx->sg = hdev->req->src;
 	rctx->total = hdev->req->nbytes;
@@ -620,10 +620,13 @@ static int stm32_hash_dma_send(struct stm32_hash_dev *hdev)
 		reg |= HASH_CR_DMAA;
 		stm32_hash_write(hdev, HASH_CR, reg);
 
-		for (i = 0; i < DIV_ROUND_UP(ncp, sizeof(u32)); i++)
-			stm32_hash_write(hdev, HASH_DIN, buffer[i]);
-
-		stm32_hash_set_nblw(hdev, ncp);
+		if (ncp) {
+			memset(buffer + ncp, 0,
+			       DIV_ROUND_UP(ncp, sizeof(u32)) - ncp);
+			writesl(hdev->io_base + HASH_DIN, buffer,
+				DIV_ROUND_UP(ncp, sizeof(u32)));
+		}
+		stm32_hash_set_nblw(hdev, DIV_ROUND_UP(ncp, sizeof(u32)));
 		reg = stm32_hash_read(hdev, HASH_STR);
 		reg |= HASH_STR_DCAL;
 		stm32_hash_write(hdev, HASH_STR, reg);
-- 
2.9.0
