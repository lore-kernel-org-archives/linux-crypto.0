Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12AEC4332F
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Dec 2022 16:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiLaQZi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Dec 2022 11:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiLaQZe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Dec 2022 11:25:34 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A28E6333
        for <linux-crypto@vger.kernel.org>; Sat, 31 Dec 2022 08:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672503930; bh=o9ngwcJGOfCQYLWLMAwmdq+al4bVg1/2QtjcnOraQlw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=tQHdeQOMub5WxPvAPMjlmroVA+dLIHB7O2r8ge+hMM+eCO0wkR/yh0KoDV7IoRxc5
         jbkaruaS9zczggrz5Nb2cDenCXyKCNBwIdBt3cEsuHtRcmyezxs4yAlVS9yUoDrev0
         R03qoQSzLKG5n085MnHPzL7WsRzfkUdo0BXHKF/ySTxAMmWuGYRnx0Z6u0U8C3x0hr
         AficjOfD5zgjPRXLceGSO9m9eEaiCaQ4UhT3graiN9taQOCigQKBJ1VNlpHEMgHaNn
         j9SRwwd1a0IKCFz+IlnbFy/U4PuA1tCGL+rV56iM3XVH/iNBxNSOcrKdJhrGGsjDVn
         RMVwqrExKUJVQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from fedora.willemsstb.de ([94.31.82.22]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MulmF-1ouwu118mB-00rpJE; Sat, 31
 Dec 2022 17:25:30 +0100
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH v4 4/6] crypto/realtek: skcipher algorithms
Date:   Sat, 31 Dec 2022 17:25:23 +0100
Message-Id: <20221231162525.416709-5-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221231162525.416709-1-markus.stockhausen@gmx.de>
References: <20221231162525.416709-1-markus.stockhausen@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:v6oyZf3EN6Gz7pmNKHb6nHTczhpeEoW81QvcmsGuOTHUdOZ/Q4S
 wU/S0xw8WCRSIFsJXLHKSPH9Paz6W/LrO3Rum149tqGsRnC3pUdtpQGTr9bGukTOeizIjjq
 lX3QelESuJ7qPjJVat8O5umzXdzaQWCWdlFn6sEy4OLEdeMuA5bapSy7n6tExXndJeH2i5M
 OKzmNkd6ZUMvyUttdYgtA==
UI-OutboundReport: notjunk:1;M01:P0:HqvXTKlBPVM=;L1zJMt68oHkRSbhUlNq/o4MpM+0
 Fe3r5vXc2EixzegmIC6EjZ4nIivkyW53yYkjeKRhjrrmkZo7DZ+ogoY3+d+v5wPkEp85KZQxS
 KDc8D5YtGRBw0euFaXFotU4FEX196ML/BWXIBvJ4N4kcqR0Glie17CvHfIfim7Cp4UcCDft6I
 DRJotqc1cGxgy2VsLK2nnruAs+LXbsh/7Qq0aosvnT7V8N4Bju0mfOC5pyHGJ9Ih1r5eBP/dj
 4q4H9N/zJvNNHJnhKyq32UCIe2zoVM07zAdmS2vHMbnxnAAHatExDBDHpkqytyYeqezJNcG20
 idKNDfKyPtEySbtuI7WkhGHuXFTGy/EVlxqCjxVb4g6yrvtfEuielvdLQEXJX/oeXD6KpDJLN
 qZlY52c7jN3TrM0CqLslYGXQ8T9R2LaQFgeN2Qow9vax+g3ExYFZ1F/2jx3kU30MzQsGiecDy
 osYHCpewOesvQvYY1fO8ztjQFhyw1zVku9EhSybmQaQ6PVZR/sHDhJq6pCJ+issyJjS3/kNwa
 co2bTDwUrWZCd6EPmUr0YYmj7K2duvpVjWR5RtDT1qCSBfqKrlvsuej2U0Y3z3UZpbg0GA+db
 0p7uWfnZPntTty75IpB/IuV9Ce3qnQQ5F2V3Q2+BkGBgjNVFyNNN9T93cCUw22a0XxfcZs1za
 isQ2gVUCJKhKsuJUfT8Bzn/dPYDVoXjYts70JZPNpWn0ZU3SRlxGinKOixRiH407fIU+bX0uw
 KkdsQ27xQp1BUttf+XEbNj+WE/SorR6sv7GIp0qTPsB8t23/T3qMe08La6CTbArI39ifzE9NH
 /fRjtxFs0EISuqKx5j6SUDVh8IUBq3NoUCi2urOzkjK1fFvvYNPw135in/Of8cO425mQg7ZfN
 QwAOm/LFnNl94fp7Tfddu9VHlphAz/o6fKbSib51QChGxpQgQzpW+r7uxjM9xWB52cciWDBnz
 Ia7OiQ==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add ecb(aes), cbc(aes) and ctr(aes) skcipher algorithms for
new Realtek crypto device.

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
=2D--
 .../crypto/realtek/realtek_crypto_skcipher.c  | 376 ++++++++++++++++++
 1 file changed, 376 insertions(+)
 create mode 100644 drivers/crypto/realtek/realtek_crypto_skcipher.c

diff --git a/drivers/crypto/realtek/realtek_crypto_skcipher.c b/drivers/cr=
ypto/realtek/realtek_crypto_skcipher.c
new file mode 100644
index 000000000000..8efc41485716
=2D-- /dev/null
+++ b/drivers/crypto/realtek/realtek_crypto_skcipher.c
@@ -0,0 +1,376 @@
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
+	int padlen, sgnoff, sgcnt, reqlen, ret, fblen, sgmap, sgdir;
+	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(sreq);
+	struct rtcr_skcipher_ctx *sctx =3D crypto_skcipher_ctx(tfm);
+	int totallen =3D sreq->cryptlen, sgoff =3D 0, dgoff =3D 0;
+	struct rtcr_crypto_dev *cdev =3D sctx->cdev;
+	struct scatterlist *sg =3D sreq->src, *sgn;
+	int idx, srcidx, dstidx, len, datalen;
+	dma_addr_t ivdma, outdma, indma;
+
+	if (!totallen)
+		return 0;
+
+	if ((totallen & (AES_BLOCK_SIZE - 1)) && (!(opmode & RTCR_SRC_OP_CRYPT_C=
TR)))
+		return -EINVAL;
+
+redo:
+	indma =3D outdma =3D 0;
+	sgmap =3D 0;
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
+		sgdir =3D DMA_BIDIRECTIONAL;
+		sgmap =3D dma_map_sg(cdev->dev, sg, sgcnt, sgdir);
+	} else {
+		outdma =3D dma_map_single(cdev->dev, dataout, reqlen, DMA_BIDIRECTIONAL=
);
+		if (fblen)
+			indma =3D dma_map_single(cdev->dev, datain, reqlen, DMA_TO_DEVICE);
+		else {
+			sgdir =3D DMA_TO_DEVICE;
+			sgmap =3D dma_map_sg(cdev->dev, sg, sgcnt, sgdir);
+		}
+	}
+
+	if (sreq->iv)
+		ivdma =3D dma_map_single(cdev->dev, sreq->iv, AES_BLOCK_SIZE, DMA_TO_DE=
VICE);
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
+	if (sreq->iv)
+		dma_unmap_single(cdev->dev, ivdma, AES_BLOCK_SIZE, DMA_TO_DEVICE);
+	if (outdma)
+		dma_unmap_single(cdev->dev, outdma, reqlen, DMA_BIDIRECTIONAL);
+	if (indma)
+		dma_unmap_single(cdev->dev, indma, reqlen, DMA_TO_DEVICE);
+	if (sgmap)
+		dma_unmap_sg(cdev->dev, sg, sgcnt, sgdir);
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
+	memcpy(sctx->keyenc, key, keylen);
+	/* decryption key is derived from expanded key */
+	p =3D ((keylen / 4) + 6) * 4;
+	for (i =3D 0; i < 8; i++) {
+		sctx->keydec[i] =3D cpu_to_le32(kctx.key_enc[p + i]);
+		if (i =3D=3D 3)
+			p -=3D keylen =3D=3D AES_KEYSIZE_256 ? 8 : 6;
+	}
+
+	dma_sync_single_for_device(cdev->dev, sctx->keydma, 2 * AES_KEYSIZE_256,=
 DMA_TO_DEVICE);
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
+	sctx->keydma =3D dma_map_single(sctx->cdev->dev, sctx->keyenc,
+				      2 * AES_KEYSIZE_256, DMA_TO_DEVICE);
+
+	return 0;
+}
+
+static void rtcr_skcipher_cra_exit(struct crypto_tfm *tfm)
+{
+	struct rtcr_skcipher_ctx *sctx =3D crypto_tfm_ctx(tfm);
+	struct rtcr_crypto_dev *cdev =3D sctx->cdev;
+
+	dma_unmap_single(cdev->dev, sctx->keydma, 2 * AES_KEYSIZE_256, DMA_TO_DE=
VICE);
+	memzero_explicit(sctx, tfm->__crt_alg->cra_ctxsize);
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

