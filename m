Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654A7C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Oct 2022 19:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiJMTMI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Oct 2022 15:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiJMTLu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2022 15:11:50 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710C9E4E5E
        for <linux-crypto@vger.kernel.org>; Thu, 13 Oct 2022 12:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1665688306;
        bh=vMnMvN2Vormu2vCNvhs5YyBOVabvMXVZ700gLozC4kQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=PBVVImJ2SPsKu3K2n37MF+scFMXpnXb6Fsqs07GTaeBmpk2KAwdVmV4mKXkc1Q10L
         wEZohrk7a8xooxRz+4dPHDF0i3R1hYa9LuLMQvb6snNUd39UYw5BVv3yxYFOVgdcJC
         RuQp9EDPDBQFuFUjXCVC9xB3ekgVIq2Hhp2inc74=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from fedora.willemsstb.de ([94.31.86.22]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mqb1c-1pVbIb45Ro-00mZ5Z; Thu, 13
 Oct 2022 20:40:30 +0200
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH 4/6] crypto/realtek: skcipher algorithms
Date:   Thu, 13 Oct 2022 20:40:24 +0200
Message-Id: <20221013184026.63826-5-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221013184026.63826-1-markus.stockhausen@gmx.de>
References: <20221013184026.63826-1-markus.stockhausen@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:XIUA76as5s1cvVn6eFdlCZXpqlrL/PP/F87PWSz3ajQhILeIZec
 tlKMdqUe+iR1MK55PICJeaeS92zHqRyjv4LTwdfGwmninDQRk2JDu1N80a9w7aVsv5gJbrv
 pEpgj3ZQ6aukppuqh4VQpJ9YFLcKxdhyERAq8HfYNy9Ohxu+H6Vv62Zj7qNbSFTIMiIQ1lo
 PwcZtJpPzMrch0zlCqIuA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:W3Mlv0hDdEo=:lobCYeDYgZXvnRrwDpS39S
 VK1xl4ppM8prn54irghqfn630hAnoPBttnfZvuyJWDmffLzqwfYpG3hwp7KqVB4l2l3EFz2Q7
 ImgvCQFYKhRTpEsStOe+pKUjK8Yzut+cKJERMrZJB/kvhbfNLyD5s9Bo5xQ4EPe9//HbVMKov
 v7HNSmu7T14CBvVQHxq16LNNNqE8vElo0R8mc4doNgeMiFUNiZ+Pjc32gThHXyXWjix+l17dN
 DLAqEuAlqxjEtcuU4ezZnAxF5irdnKU9q3F6JI+S8s/QYnGlw+16iAknxFePHIsqzZHR7F5aE
 CSZlfcMXO+JTrx+ZPMe2xlY+4vL4ErFFDYNq1PfTgn3oRPHfLtGXAS+qU4o03BkuiHbaG10kO
 xVGvwpFzdnzc4rOw4Y2aHfJUC5D61rzGwK8HzHFzJiUqLxgHeGz1WGpyRlImgqmqVubEZlX8p
 QI1DC5Pm1iqrNmKs02jO9zcVKzy7gvK8Q7Rk1oFC3Wtyn+XZ6LJBpb8PUyYIKgHxknIwDjsRG
 j7FQBlgdZfSSMpSjCOvExPVida/bXQF4kIgH+OXAlW7Pc07XCb0grh4U7mU0x8p9lNlxPURBo
 FkZzZe/mW5uUUlShI0ObqQpugE8+FOPru8QMsIeFnf1Gx0FpJgF5/fkNFgDN0OlHRoCjIA67j
 CKZmvfMB7FxgfuKltH+WuS6jt0JC/hGbJFC7pzk1wR9K+qhXzBNanyoXnZ/ycXvKmB9/RA1sc
 GNrFlqrG0Qf+vTHo2XCPNw/v0zkXKT3iUfj3pdBTfdNTiNOIv0Uxa25zg9QTE4UOdR7jUf/23
 bRF6qeGoCpT1YazJZGX/4SLmapobBKYejXAbfY3xgihOuTLQlpc2d35MAZBk43P0wLf/bS0b3
 958dGqlOLY8C7iFO6vlX+55CMHah8dM1HYF4McxpmjjpSf3LvYA4gMmipcWQfYsEFMUYbV1D2
 VT4uiiDygA3IIwizEGU87XnWlnEWBgQWefMPVsAs7KP0hiRjHytSCEAaMWtovYLx49mXLoub7
 OL+LzIjIeqECFGSgDAWsmbdxFDQmT22fVqMQ/U2BCJiccZaTHpen0xZ8tLss556MzBR6Xn6XC
 OSO1DVA6FJqpUXma+zvUDVQgwXIHkKTVurjgdSD0DCAK08c0K9+3EVGNHsNS39gaMSedfc4Mp
 x24tp78Ngzg2KYsY+Qu1KFSYg6n2VhD+UP1KvA19pe3tg4ZXt50shJOCZcCOA8VvonHz0XQpa
 io905aR/wVb7waXMDg/Cz3/gHaqIUGbZqC5SaaThR5Xd+dTCLizx7OsINa2hL1WxQ7CURLv1j
 nYHC3KtsW2PX/LKhJKmf32pWkQ1akK4n1Mz2H69z9KACEoN5ZOSD2OOPzRmDBvvMswn8jZjCK
 Zej0xJu3VBY3OU+GfbT28xZCHgOeL27noUQEMcYQqxMIInCZDAuKOPMFSGnB1AINKYwPLrdO8
 +zNtI0JzJ0Em3mP+7pV1u3xENl57tdjDDffrkANZoV6Wlgi/7DNGM4lbksKYdtwA4eMSq21Ze
 i5lrrRJG4Co7FzCaWZ46zfjjzqkUpLyfnr59NCXc23Bpu
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
2.37.3

