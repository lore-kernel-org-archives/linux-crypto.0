Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49B2C433E2
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 06:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2921215A4
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 06:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIGGYH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 02:24:07 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50712 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgIGGYG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 02:24:06 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kFAZM-0002T0-IF; Mon, 07 Sep 2020 16:24:01 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Sep 2020 16:24:00 +1000
Date:   Mon, 7 Sep 2020 16:24:00 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: sun4i-ss - Fix SHA1 hash on A33-variant with BE CPU
Message-ID: <20200907062400.GA15841@gondor.apana.org.au>
References: <202009061621.J89kO43Q%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009061621.J89kO43Q%lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Sep 06, 2020 at 04:52:24PM +0800, kernel test robot wrote:
>
> >> drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:483:35: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [assigned] [usertype] v @@     got restricted __le32 [usertype] @@
>    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:483:35: sparse:     expected unsigned int [assigned] [usertype] v
>    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:483:35: sparse:     got restricted __le32 [usertype]
>    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:485:35: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [assigned] [usertype] v @@     got restricted __be32 [usertype] @@
>    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:485:35: sparse:     expected unsigned int [assigned] [usertype] v
>    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:485:35: sparse:     got restricted __be32 [usertype]
>    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:490:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [addressable] [assigned] [usertype] v @@     got restricted __le32 [usertype] @@
>    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:490:27: sparse:     expected unsigned int [addressable] [assigned] [usertype] v
>    drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c:490:27: sparse:     got restricted __le32 [usertype]

This appears to be a genuine bug, on big-endian CPUs at least.

---8<---
When the hash is written out on the A33 variant, it is incorrectly
swabbed on big-endian CPUs, when it should simply be written out as
is because it's already in the right format.  This was caught by
sparse warnings.

Instead of using cpu_to_Xe32 followed by a memcpy, this patch
converts the final hash write to use put_unaligned instead.  This
simplifies the code and makes the A33 variant handling a lot clearer.

This patch also fixes the incorrect endianness marking on wb,
although this should have no effect in the genereated code.

Fixes: 1e02e6fbdadb ("crypto: sun4i-ss - add the A33 variant of SS")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
index dc35edd90034..84f7921de577 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
@@ -9,6 +9,7 @@
  * You could find the datasheet in Documentation/arm/sunxi.rst
  */
 #include "sun4i-ss.h"
+#include <asm/unaligned.h>
 #include <linux/scatterlist.h>
 
 /* This is a totally arbitrary value */
@@ -196,7 +197,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	struct sg_mapping_iter mi;
 	int in_r, err = 0;
 	size_t copied = 0;
-	__le32 wb = 0;
+	u32 wb = 0;
 
 	dev_dbg(ss->dev, "%s %s bc=%llu len=%u mode=%x wl=%u h0=%0x",
 		__func__, crypto_tfm_alg_name(areq->base.tfm),
@@ -408,7 +409,7 @@ static int sun4i_hash(struct ahash_request *areq)
 
 		nbw = op->len - 4 * nwait;
 		if (nbw) {
-			wb = cpu_to_le32(*(u32 *)(op->buf + nwait * 4));
+			wb = le32_to_cpup((__le32 *)(op->buf + nwait * 4));
 			wb &= GENMASK((nbw * 8) - 1, 0);
 
 			op->byte_count += nbw;
@@ -417,7 +418,7 @@ static int sun4i_hash(struct ahash_request *areq)
 
 	/* write the remaining bytes of the nbw buffer */
 	wb |= ((1 << 7) << (nbw * 8));
-	bf[j++] = le32_to_cpu(wb);
+	((__le32 *)bf)[j++] = cpu_to_le32(wb);
 
 	/*
 	 * number of space to pad to obtain 64o minus 8(size) minus 4 (final 1)
@@ -479,16 +480,16 @@ static int sun4i_hash(struct ahash_request *areq)
 	/* Get the hash from the device */
 	if (op->mode == SS_OP_SHA1) {
 		for (i = 0; i < 5; i++) {
+			v = readl(ss->base + SS_MD0 + i * 4);
 			if (ss->variant->sha1_in_be)
-				v = cpu_to_le32(readl(ss->base + SS_MD0 + i * 4));
+				put_unaligned(v, areq->result + i * 4);
 			else
-				v = cpu_to_be32(readl(ss->base + SS_MD0 + i * 4));
-			memcpy(areq->result + i * 4, &v, 4);
+				put_unaligned_be32(v, areq->result + i * 4);
 		}
 	} else {
 		for (i = 0; i < 4; i++) {
-			v = cpu_to_le32(readl(ss->base + SS_MD0 + i * 4));
-			memcpy(areq->result + i * 4, &v, 4);
+			v = readl(ss->base + SS_MD0 + i * 4);
+			put_unaligned_le32(v, areq->result + i * 4);
 		}
 	}
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
