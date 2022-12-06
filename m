Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0ACAC636F9
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Dec 2022 19:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiLFTUr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Dec 2022 14:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLFTUp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Dec 2022 14:20:45 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116B540920
        for <linux-crypto@vger.kernel.org>; Tue,  6 Dec 2022 11:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1670354441; bh=zVUHqCJ84GllTcJFCmSYFeaC4bAuLxzS3zDt/gzsgAY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Af1DqJ/oxx2k9gEhYSRb2/QnjoRDUZQkxvQlIqSGyB9ix1zr2DAHZF2XbzoCFA3fN
         bO0z8vjv5IT2IELiWQqMRHH+LeTy8wKBx4TmxELZJ2gh414huIXk2XkuGcFzxbc+f2
         igTVI96DxeuvqfOtsBX637HCyJLsGCIxWROJgi1heSsoiBbhi0OezOoxkStllHCqJG
         wgqedMKm10llYfsHctSPA6NpF7mKJnj2SASggAIJSphpc83V2iFUYfFL5QahiPhi6K
         /bwhoF/Cr0oJcJWqn42O1I7irKCtUSod1u38XjHxRdxw5nNIX+0mQeTqkiw68ICerC
         VOW6Qj8ZzWwow==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from fedora.willemsstb.de ([94.31.87.22]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M3DO3-1oz4Bo0vLJ-003fyy; Tue, 06
 Dec 2022 20:20:41 +0100
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH v2 4/6] crypto/realtek: skcipher algorithms
Date:   Tue,  6 Dec 2022 20:20:35 +0100
Message-Id: <20221206192037.608808-5-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206192037.608808-1-markus.stockhausen@gmx.de>
References: <20221206192037.608808-1-markus.stockhausen@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:swL7VYpOD4QWk8c+aPsSJ374Ds8jb5y+mwauPeWiyyXjsnekLf7
 7N0LcUu7p5XWUwuVQMj5q3nheD+VxmALHXyKKLaQB8CoPjtu0vUr4N2aed5kEyBraM/ts0W
 FpPx4SfZLnT/mxzpi/vT4IW7293psGScAmmnNaInYFLyuAEazmULwpHT3Zq8tbmytq+1tk8
 ryUBgHEdullthKaaA24lw==
UI-OutboundReport: notjunk:1;M01:P0:pzvlXN3M0Gg=;QslXLJtwS3mkWrK4E01GAW03Sk8
 WoR3wL4JdMFSt/9tbkGTGgHx3u1fUtqeYwYi1qCBXtItb1X3mibyKGVDvbyfsV+ETB58WM+iI
 sljFfNZZ00o5DbHz2J581cIFzaSgqvtOZSAViUYsUuuap1EASC+b0jv2DWODWr+oCzpFVOQSu
 ZM70UkGPzxFMyp0eIge8f+xsnmJRSxxJh8QDECQgfuoXBipsW1Tn/HnJLk/GTtWo3nAm6EG9s
 /TT/ig7UQQQY9Q4+2BItXXb12VXcSgK5FrjwNKmnCXc5cUlrHm3FwFYgoKy7oq7tgYGNufaEO
 p5MlFvay3j460j8xDnnGAZgk610YscQSD+7foTVBYsYg+itMQ/EI3cgqoofJSLuqp/IAjK+S9
 4h0l/gyUburdDVR4u6hc/JnPpNSRJvNsf7D6FggEw7WSxMxLQgRAkSZYndUtUP3Jweu9ksozk
 6HuaHOKmzO0fYcc7qpDn7m6tafeXsSnMPycuZA5eOM//znlzKHJryNo9bhPLv0ufihUq0vwyK
 LSL8Gg0w5+DAXRb1ZkKvam0BrdRcY0tUdG2pFK5cNHlHfo31mOScfNY60WX5kZ4wXW5ua8U6W
 gPnDguaabY4diabKU++WaPbGSOLbrCTzkwW8fIHPQ8Yjgcij/ZDMIae3CvIwaDTQVoEfqF1vM
 lryjVl6Q1/F4F1ZKY21Cwb8idWwKimK5qa1OOatT5Qqvb2NbRJiU5zZQxihi17MBxTnZZ43w3
 JGKHxrhYBkx5/H+Qcy7vQ5oM2JyF0pEZlhgGcJFoHsVRxa75JRuWpx81DNYjxcc10JvrosADs
 VydZlfysEhte//8LNyehBYqiEsDdgnFq7R88RQIvw2t1VHXCcR8X+HwLevhQangMYQHrqLxUH
 7tbMvCQZs3WuW681RGhned2/ociOORxnVkKg4Za1i+An1ZLoFfAfhk9YRLFVZ+4QZIS2c2rls
 6PcsFX08mk1p8uTJM5+pfl2RDqY=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add ecb(aes), cbc(aes) and ctr(aes) skcipher algorithms for
new Realtek crypto device.

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
=2D--
 .../crypto/realtek/realtek_crypto_skcipher.c  | 361 ++++++++++++++++++
 1 file changed, 361 insertions(+)
 create mode 100644 drivers/crypto/realtek/realtek_crypto_skcipher.c

diff --git a/drivers/crypto/realtek/realtek_crypto_skcipher.c b/drivers/cr=
ypto/realtek/realtek_crypto_skcipher.c
new file mode 100644
index 000000000000..6e2cde77b4d4
=2D-- /dev/null
+++ b/drivers/crypto/realtek/realtek_crypto_skcipher.c
@@ -0,0 +1,361 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Crypto acceleration support for Realtek crypto engine. Based on ideas =
from
+ * Rockchip & SafeXcel driver plus Realtek OpenWrt RTK.
+ *
+ * Copyright (c) 2022, Markus Stockhausen <markus.stockhausen@gmx.de>
+ */
+
+#include <crypto/internal/skcipher.h>
+#include <linux/dma-mapping.h>
+
+#include "realtek_crypto.h"
+
+static inline void rtcr_inc_iv(u8 *iv, int cnt)
+{
+	u32 *ctr =3D (u32 *)iv + 4;
+	u32 old, new, carry =3D cnt;
+
+	/* avoid looping with crypto_inc() */
+	do {
+		old =3D be32_to_cpu(*--ctr);
+		new =3D old + carry;
+		*ctr =3D cpu_to_be32(new);
+		carry =3D (new < old) && (ctr > (u32 *)iv) ? 1 : 0;
+	} while (carry);
+}
+
+static inline void rtcr_cut_skcipher_len(int *reqlen, int opmode, u8 *iv)
+{
+	int len =3D min(*reqlen, RTCR_MAX_REQ_SIZE);
+
+	if (opmode & RTCR_SRC_OP_CRYPT_CTR) {
+		/* limit data as engine does not wrap around cleanly */
+		u32 ctr =3D be32_to_cpu(*((u32 *)iv + 3));
+		int blocks =3D min(~ctr, 0x3fffu) + 1;
+
+		len =3D min(blocks * AES_BLOCK_SIZE, len);
+	}
+
+	*reqlen =3D len;
+}
+
+static inline void rtcr_max_skcipher_len(int *reqlen, struct scatterlist =
**sg,
+					 int *sgoff, int *sgcnt)
+{
+	int len, cnt, sgnoff, sgmax =3D RTCR_MAX_SG_SKCIPHER, datalen, maxlen =
=3D *reqlen;
+	struct scatterlist *sgn;
+
+redo:
+	datalen =3D cnt =3D 0;
+	sgnoff =3D *sgoff;
+	sgn =3D *sg;
+
+	while (sgn && (datalen < maxlen) && (cnt < sgmax)) {
+		cnt++;
+		len =3D min((int)sg_dma_len(sgn) - sgnoff, maxlen - datalen);
+		datalen +=3D len;
+		if (len + sgnoff < sg_dma_len(sgn)) {
+			sgnoff =3D sgnoff + len;
+			break;
+		}
+		sgn =3D sg_next(sgn);
+		sgnoff =3D 0;
+		if (unlikely((cnt =3D=3D sgmax) && (datalen < AES_BLOCK_SIZE))) {
+			/* expand search to get at least one block */
+			sgmax =3D AES_BLOCK_SIZE;
+			maxlen =3D min(maxlen, AES_BLOCK_SIZE);
+		}
+	}
+
+	if (unlikely((datalen < maxlen) && (datalen & (AES_BLOCK_SIZE - 1)))) {
+		/* recalculate to get aligned size */
+		maxlen =3D datalen & ~(AES_BLOCK_SIZE - 1);
+		goto redo;
+	}
+
+	*sg =3D sgn;
+	*sgoff =3D sgnoff;
+	*sgcnt =3D cnt;
+	*reqlen =3D datalen;
+}
+
+static int rtcr_process_skcipher(struct skcipher_request *sreq, int opmod=
e)
+{
+	char *dataout, *iv, ivbk[AES_BLOCK_SIZE], datain[AES_BLOCK_SIZE];
+	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(sreq);
+	struct rtcr_skcipher_ctx *sctx =3D crypto_skcipher_ctx(tfm);
+	int totallen =3D sreq->cryptlen, sgoff =3D 0, dgoff =3D 0;
+	int padlen, sgnoff, sgcnt, reqlen, ret, fblen;
+	struct rtcr_crypto_dev *cdev =3D sctx->cdev;
+	struct scatterlist *sg =3D sreq->src, *sgn;
+	int idx, srcidx, dstidx, len, datalen;
+
+	if (!totallen)
+		return 0;
+
+	if ((totallen & (AES_BLOCK_SIZE - 1)) && (!(opmode & RTCR_SRC_OP_CRYPT_C=
TR)))
+		return -EINVAL;
+
+redo:
+	sgnoff =3D sgoff;
+	sgn =3D sg;
+	datalen =3D totallen;
+
+	/* limit input so that engine can process it */
+	rtcr_cut_skcipher_len(&datalen, opmode, sreq->iv);
+	rtcr_max_skcipher_len(&datalen, &sgn, &sgnoff, &sgcnt);
+
+	/* CTR padding */
+	padlen =3D (AES_BLOCK_SIZE - datalen) & (AES_BLOCK_SIZE - 1);
+	reqlen =3D datalen + padlen;
+
+	fblen =3D 0;
+	if (sgcnt > RTCR_MAX_SG_SKCIPHER) {
+		/* single AES block with too many SGs */
+		fblen =3D datalen;
+		sg_pcopy_to_buffer(sg, sgcnt, datain, datalen, sgoff);
+	}
+
+	if ((opmode & RTCR_SRC_OP_CRYPT_CBC) &&
+	    (!(opmode & RTCR_SRC_OP_KAM_ENC))) {
+		/* CBC decryption IV might get overwritten */
+		sg_pcopy_to_buffer(sg, sgcnt, ivbk, AES_BLOCK_SIZE,
+				   sgoff + datalen - AES_BLOCK_SIZE);
+	}
+
+	/* Get free space in the ring */
+	if (padlen || (datalen + dgoff > sg_dma_len(sreq->dst))) {
+		len =3D datalen;
+	} else {
+		len =3D RTCR_WB_LEN_SG_DIRECT;
+		dataout =3D sg_virt(sreq->dst) + dgoff;
+	}
+
+	ret =3D rtcr_alloc_ring(cdev, 2 + (fblen ? 1 : sgcnt) + (padlen ? 1 : 0)=
,
+			      &srcidx, &dstidx, len, &dataout);
+	if (ret)
+		return ret;
+
+	/* Write back any uncommitted data to memory */
+	if (dataout =3D=3D sg_virt(sreq->src) + sgoff) {
+		dma_map_sg(cdev->dev, sg, sgcnt, DMA_BIDIRECTIONAL);
+	} else {
+		dma_sync_single_for_device(cdev->dev, virt_to_phys(dataout),
+					   reqlen, DMA_BIDIRECTIONAL);
+		if (fblen)
+			dma_sync_single_for_device(cdev->dev, virt_to_phys(datain),
+						   reqlen, DMA_TO_DEVICE);
+		else
+			dma_map_sg(cdev->dev, sg, sgcnt, DMA_TO_DEVICE);
+	}
+
+	if (sreq->iv)
+		dma_sync_single_for_device(cdev->dev, virt_to_phys(sreq->iv),
+					   AES_BLOCK_SIZE, DMA_TO_DEVICE);
+	/*
+	 * Feed input data into the rings. Start with destination ring and fill
+	 * source ring afterwards. Ensure that the owner flag of the first sourc=
e
+	 * ring is the last that becomes visible to the engine.
+	 */
+	rtcr_add_dst_to_ring(cdev, dstidx, dataout, reqlen, sreq->dst, dgoff);
+
+	idx =3D rtcr_inc_src_idx(srcidx, 1);
+	rtcr_add_src_to_ring(cdev, idx, sreq->iv, AES_BLOCK_SIZE, reqlen);
+
+	if (fblen) {
+		idx =3D rtcr_inc_src_idx(idx, 1);
+		rtcr_add_src_to_ring(cdev, idx, (void *)datain, fblen, reqlen);
+	}
+
+	datalen -=3D fblen;
+	while (datalen) {
+		len =3D min((int)sg_dma_len(sg) - sgoff, datalen);
+
+		idx =3D rtcr_inc_src_idx(idx, 1);
+		rtcr_add_src_to_ring(cdev, idx, sg_virt(sg) + sgoff, len, reqlen);
+
+		datalen -=3D len;
+		sg =3D sg_next(sg);
+		sgoff =3D 0;
+	}
+
+	if (padlen) {
+		idx =3D rtcr_inc_src_idx(idx, 1);
+		rtcr_add_src_to_ring(cdev, idx, (void *)empty_zero_page, padlen, reqlen=
);
+	}
+
+	rtcr_add_src_pad_to_ring(cdev, idx, reqlen);
+	rtcr_add_src_skcipher_to_ring(cdev, srcidx, opmode, reqlen, sctx);
+
+	/* Off we go */
+	rtcr_kick_engine(cdev);
+	if (rtcr_wait_for_request(cdev, dstidx))
+		return -EINVAL;
+
+	/* Handle IV feedback as engine does not provide it */
+	if (opmode & RTCR_SRC_OP_CRYPT_CTR) {
+		rtcr_inc_iv(sreq->iv, reqlen / AES_BLOCK_SIZE);
+	} else if (opmode & RTCR_SRC_OP_CRYPT_CBC) {
+		iv =3D opmode & RTCR_SRC_OP_KAM_ENC ?
+		     dataout + reqlen - AES_BLOCK_SIZE : ivbk;
+		memcpy(sreq->iv, iv, AES_BLOCK_SIZE);
+	}
+
+	sg =3D sgn;
+	sgoff =3D sgnoff;
+	dgoff +=3D reqlen;
+	totallen -=3D min(reqlen, totallen);
+
+	if (totallen)
+		goto redo;
+
+	return 0;
+}
+
+static int rtcr_skcipher_encrypt(struct skcipher_request *sreq)
+{
+	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(sreq);
+	struct rtcr_skcipher_ctx *sctx =3D crypto_skcipher_ctx(tfm);
+	int opmode =3D sctx->opmode | RTCR_SRC_OP_KAM_ENC;
+
+	return rtcr_process_skcipher(sreq, opmode);
+}
+
+static int rtcr_skcipher_decrypt(struct skcipher_request *sreq)
+{
+	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(sreq);
+	struct rtcr_skcipher_ctx *sctx =3D crypto_skcipher_ctx(tfm);
+	int opmode =3D sctx->opmode;
+
+	opmode |=3D sctx->opmode & RTCR_SRC_OP_CRYPT_CTR ?
+		  RTCR_SRC_OP_KAM_ENC : RTCR_SRC_OP_KAM_DEC;
+
+	return rtcr_process_skcipher(sreq, opmode);
+}
+
+static int rtcr_skcipher_setkey(struct crypto_skcipher *cipher,
+				const u8 *key, unsigned int keylen)
+{
+	struct crypto_tfm *tfm =3D crypto_skcipher_tfm(cipher);
+	struct rtcr_skcipher_ctx *sctx =3D crypto_tfm_ctx(tfm);
+	struct rtcr_crypto_dev *cdev =3D sctx->cdev;
+	struct crypto_aes_ctx kctx;
+	int p, i;
+
+	if (aes_expandkey(&kctx, key, keylen))
+		return -EINVAL;
+
+	sctx->keylen =3D keylen;
+	sctx->opmode =3D (sctx->opmode & ~RTCR_SRC_OP_CIPHER_MASK) |
+			RTCR_SRC_OP_CIPHER_FROM_KEY(keylen);
+
+	memcpy(sctx->key_enc, key, keylen);
+	/* decryption key is derived from expanded key */
+	p =3D ((keylen / 4) + 6) * 4;
+	for (i =3D 0; i < 8; i++) {
+		sctx->key_dec[i] =3D cpu_to_le32(kctx.key_enc[p + i]);
+		if (i =3D=3D 3)
+			p -=3D keylen =3D=3D AES_KEYSIZE_256 ? 8 : 6;
+	}
+
+	dma_sync_single_for_device(cdev->dev, virt_to_phys(sctx->key_enc),
+				   2 * AES_KEYSIZE_256, DMA_TO_DEVICE);
+
+	return 0;
+}
+
+static int rtcr_skcipher_cra_init(struct crypto_tfm *tfm)
+{
+	struct rtcr_skcipher_ctx *sctx =3D crypto_tfm_ctx(tfm);
+	struct rtcr_alg_template *tmpl;
+
+	tmpl =3D container_of(tfm->__crt_alg, struct rtcr_alg_template,
+			    alg.skcipher.base);
+
+	sctx->cdev =3D tmpl->cdev;
+	sctx->opmode =3D tmpl->opmode;
+
+	return 0;
+}
+
+static void rtcr_skcipher_cra_exit(struct crypto_tfm *tfm)
+{
+	void *ctx =3D crypto_tfm_ctx(tfm);
+
+	memzero_explicit(ctx, tfm->__crt_alg->cra_ctxsize);
+}
+
+struct rtcr_alg_template rtcr_skcipher_ecb_aes =3D {
+	.type =3D RTCR_ALG_SKCIPHER,
+	.opmode =3D RTCR_SRC_OP_MS_CRYPTO | RTCR_SRC_OP_CRYPT_ECB,
+	.alg.skcipher =3D {
+		.setkey =3D rtcr_skcipher_setkey,
+		.encrypt =3D rtcr_skcipher_encrypt,
+		.decrypt =3D rtcr_skcipher_decrypt,
+		.min_keysize =3D AES_MIN_KEY_SIZE,
+		.max_keysize =3D AES_MAX_KEY_SIZE,
+		.base =3D {
+			.cra_name =3D "ecb(aes)",
+			.cra_driver_name =3D "realtek-ecb-aes",
+			.cra_priority =3D 300,
+			.cra_flags =3D CRYPTO_ALG_ASYNC,
+			.cra_blocksize =3D AES_BLOCK_SIZE,
+			.cra_ctxsize =3D sizeof(struct rtcr_skcipher_ctx),
+			.cra_alignmask =3D 0,
+			.cra_init =3D rtcr_skcipher_cra_init,
+			.cra_exit =3D rtcr_skcipher_cra_exit,
+			.cra_module =3D THIS_MODULE,
+		},
+	},
+};
+
+struct rtcr_alg_template rtcr_skcipher_cbc_aes =3D {
+	.type =3D RTCR_ALG_SKCIPHER,
+	.opmode =3D RTCR_SRC_OP_MS_CRYPTO | RTCR_SRC_OP_CRYPT_CBC,
+	.alg.skcipher =3D {
+		.setkey =3D rtcr_skcipher_setkey,
+		.encrypt =3D rtcr_skcipher_encrypt,
+		.decrypt =3D rtcr_skcipher_decrypt,
+		.min_keysize =3D AES_MIN_KEY_SIZE,
+		.max_keysize =3D AES_MAX_KEY_SIZE,
+		.ivsize	=3D AES_BLOCK_SIZE,
+		.base =3D {
+			.cra_name =3D "cbc(aes)",
+			.cra_driver_name =3D "realtek-cbc-aes",
+			.cra_priority =3D 300,
+			.cra_flags =3D CRYPTO_ALG_ASYNC,
+			.cra_blocksize =3D AES_BLOCK_SIZE,
+			.cra_ctxsize =3D sizeof(struct rtcr_skcipher_ctx),
+			.cra_alignmask =3D 0,
+			.cra_init =3D rtcr_skcipher_cra_init,
+			.cra_exit =3D rtcr_skcipher_cra_exit,
+			.cra_module =3D THIS_MODULE,
+		},
+	},
+};
+
+struct rtcr_alg_template rtcr_skcipher_ctr_aes =3D {
+	.type =3D RTCR_ALG_SKCIPHER,
+	.opmode =3D RTCR_SRC_OP_MS_CRYPTO | RTCR_SRC_OP_CRYPT_CTR,
+	.alg.skcipher =3D {
+		.setkey =3D rtcr_skcipher_setkey,
+		.encrypt =3D rtcr_skcipher_encrypt,
+		.decrypt =3D rtcr_skcipher_decrypt,
+		.min_keysize =3D AES_MIN_KEY_SIZE,
+		.max_keysize =3D AES_MAX_KEY_SIZE,
+		.ivsize	=3D AES_BLOCK_SIZE,
+		.base =3D {
+			.cra_name =3D "ctr(aes)",
+			.cra_driver_name =3D "realtek-ctr-aes",
+			.cra_priority =3D 300,
+			.cra_flags =3D CRYPTO_ALG_ASYNC,
+			.cra_blocksize =3D 1,
+			.cra_ctxsize =3D sizeof(struct rtcr_skcipher_ctx),
+			.cra_alignmask =3D 0,
+			.cra_init =3D rtcr_skcipher_cra_init,
+			.cra_exit =3D rtcr_skcipher_cra_exit,
+			.cra_module =3D THIS_MODULE,
+		},
+	},
+};
=2D-
2.38.1

