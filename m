Return-Path: <SRS0=6HzI=CR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1073DC433E2
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 05:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6368206B8
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 05:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgIHFAq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Sep 2020 01:00:46 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52396 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbgIHFAq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Sep 2020 01:00:46 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kFVkC-0000ag-4X; Tue, 08 Sep 2020 15:00:37 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Sep 2020 15:00:36 +1000
Date:   Tue, 8 Sep 2020 15:00:36 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [v2 PATCH] crypto: sun4i-ss - Fix sparse endianness markers
Message-ID: <20200908050036.GA19817@gondor.apana.org.au>
References: <202009061621.J89kO43Q%lkp@intel.com>
 <20200907062400.GA15841@gondor.apana.org.au>
 <20200907160029.GC11894@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907160029.GC11894@Red>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 07, 2020 at 06:00:29PM +0200, Corentin Labbe wrote:
>
> The put_unaligned should be _le32.
> 
> This fix the modprobe tcrypt fail.

Thanks.  Yes the original code was correct.

---8<---
This patch also fixes the incorrect endianness markings in the
sun4i-ss driver.  It should have no effect in the genereated code.

Instead of using cpu_to_Xe32 followed by a memcpy, this patch
converts the final hash write to use put_unaligned_X instead.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
index dc35edd90034..1dff48558f53 100644
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
+				put_unaligned_le32(v, areq->result + i * 4);
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
