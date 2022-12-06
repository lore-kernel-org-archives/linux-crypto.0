Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2041C47090
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Dec 2022 19:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiLFTUr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Dec 2022 14:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiLFTUp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Dec 2022 14:20:45 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAA140939
        for <linux-crypto@vger.kernel.org>; Tue,  6 Dec 2022 11:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1670354441; bh=5IM/phMQ0TGMCBqH3/NVEG7XFvEwYXix6JL0+2qXL/A=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=DAbqa/6dsgu9MUw3ScLS6++NlCh/LfdL1g/mZZO3FFjz352BILZBzz+kHiV4W0Mj+
         UkelZYCszCqRzFd0F2SqHXrsk6FukQuLmU19OzM4owRUadxe7SwSQJ+VwaiTRjzgkB
         DOG9Th4uz9cDxRKsuutnbMaKdbOqpNX7p8EOwAvGdHELvLzHLILjNYURLoZ3ZIXBDU
         XF+eoeOpnGLyN2HD+LM02PjJJt/VHIWqke5tiw0ICiWLcbXmU8ocRJWdLQzk0biDnd
         0kh3sK1o0bCqCkLWNAdJb6MjhE/JeGdTKOR1V3ZHpf6vTF/R2qeP08odfZPQaA5BWq
         wxMAc92An6BVQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from fedora.willemsstb.de ([94.31.87.22]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M9FnZ-1p55Xa0Hqx-006Ojq; Tue, 06
 Dec 2022 20:20:41 +0100
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH v2 3/6] crypto/realtek: hash algorithms
Date:   Tue,  6 Dec 2022 20:20:34 +0100
Message-Id: <20221206192037.608808-4-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206192037.608808-1-markus.stockhausen@gmx.de>
References: <20221206192037.608808-1-markus.stockhausen@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:yVElCvmIwG8Nei6jX1akYmDCxEo1HV4MbCtT7owu1+/MLF6SjL2
 bdgpCQQfSYh2RxT+dXlxNlexX/aKObzPj5/NSso5U5JMaBk66hH35EGqxrGiVx2yEv7Y2T3
 4THk+cNGzspaoB4pDrzx80gKgCbXF6Z3KCfBWfUlAVJhYzDxT/TYZ0HY0/y9XHIz+b7Waua
 AUOrQ/zheHsymyp+5LbMw==
UI-OutboundReport: notjunk:1;M01:P0:pWjXkWn4u1w=;BrXf6UDJSBlRRo50IZSpZIWXtka
 /QeKZbRnXurW9EnPS+uSjP6hfb2naVByox+zAgZkBNY/1rssyz1O8OljHrhLYqY5GH8Rv0MuV
 EtgZ2x89WFmHLV3y//usmxFHCrxW8i64Ws/6JpVkYLmly7lAic84mp9yze5s6R/yfXUw0UrI4
 qI7tmV144yFh54kiq/rUIg+mOGb72jB/JoswVMYfRymjKlKHf919kBEOilqraLQlIif4QywgI
 kxgGa+B5E6lbupkJHBfmFM/R3KOuA2yk8+wX1HV7CnhpDH2NSddCwErdTvAzhOxer8fFWSPlI
 qcm1nbtjlP7Z0rX0gb0gQXBcCggCuw8cv4s51DYqGIrYSt0uF7Mg1xr2MOLCq+0FW4C8jCjV0
 uJt8pQoYQ7JopqdWSZIu9eIQ9P+ZDg6u+0A68slqxEuxlpha3fB52FvVoxRc3UNy4cjxlG3p2
 P52C8We35o0ZdjodZpGdDqp8avI1DQyW3+cU9284cLcNmzs23E6F6qkW3scghtVqgSXMB5tZC
 UYnkSSd0ou7PWYm1GxAhTUbvlUuwtP9BbVucZW6b2TVDpfsSwtnVcGzC6OOHE4BYRYomDEoVu
 SvNZJiWcNCxH5EkjeauIpNEAuctE0J6JiT6di747aZLHvvlBdm/Rev558wyEx/H8T60Jetd/V
 JIoykBtXFShOhbDZMCFmtPYqSmawyEWhNUWFsSNDdSxvs+cTTdalvjl53tD4p2Au11zj0zjV8
 c8AA3wFf0AQ6J6TZxshWzE7eeDeTQ89cB/+ac5tKXxJD6x5yScayqE6OyH1ikKUY+/w4aEBQo
 vk51x2Cj3tag0nncQh5TEZmFRtaZg3xJmRpKi5l1YvepkGz6ERAuKXuTUBwZZhj1qLreo4owf
 cuuSvPQqOgVLKD+YCOxQBoVcXtoYJhEsMQ4xfnGbox9xrt4j6Ln8VUfHnQ0+otVyfUGKv9FJU
 mDIZvQ==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add md5/sha1 hash algorithms for new Realtek crypto device.

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
=2D--
 drivers/crypto/realtek/realtek_crypto_ahash.c | 407 ++++++++++++++++++
 1 file changed, 407 insertions(+)
 create mode 100644 drivers/crypto/realtek/realtek_crypto_ahash.c

diff --git a/drivers/crypto/realtek/realtek_crypto_ahash.c b/drivers/crypt=
o/realtek/realtek_crypto_ahash.c
new file mode 100644
index 000000000000..c8476719b3a4
=2D-- /dev/null
+++ b/drivers/crypto/realtek/realtek_crypto_ahash.c
@@ -0,0 +1,407 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Crypto acceleration support for Realtek crypto engine. Based on ideas =
from
+ * Rockchip & SafeXcel driver plus Realtek OpenWrt RTK.
+ *
+ * Copyright (c) 2022, Markus Stockhausen <markus.stockhausen@gmx.de>
+ */
+
+#include <asm/unaligned.h>
+#include <crypto/internal/hash.h>
+#include <linux/dma-mapping.h>
+
+#include "realtek_crypto.h"
+
+static inline struct ahash_request *fallback_request_ctx(struct ahash_req=
uest *areq)
+{
+	char *p =3D (char *)ahash_request_ctx(areq);
+
+	return (struct ahash_request *)(p + offsetof(struct rtcr_ahash_req, vect=
or));
+}
+
+static inline void *fallback_export_state(void *export)
+{
+	char *p =3D (char *)export;
+
+	return (void *)(p + offsetof(struct rtcr_ahash_req, vector));
+}
+
+static int rtcr_process_hash(struct ahash_request *areq, int opmode)
+{
+	unsigned int len, nextbuflen, datalen, padlen, reqlen;
+	struct rtcr_ahash_req *hreq =3D ahash_request_ctx(areq);
+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
+	struct rtcr_ahash_ctx *hctx =3D crypto_ahash_ctx(tfm);
+	int sgcnt =3D hreq->state & RTCR_REQ_SG_MASK;
+	struct rtcr_crypto_dev *cdev =3D hctx->cdev;
+	struct scatterlist *sg =3D areq->src;
+	int idx, srcidx, dstidx, ret;
+	u64 pad[RTCR_HASH_PAD_SIZE];
+	char *ppad;
+
+	/* Quick checks if processing is really needed */
+	if (unlikely(!areq->nbytes) && !(opmode & RTCR_HASH_FINAL))
+		return 0;
+
+	if (hreq->buflen + areq->nbytes < 64 && !(opmode & RTCR_HASH_FINAL)) {
+		hreq->buflen +=3D sg_pcopy_to_buffer(areq->src, sg_nents(areq->src),
+						   hreq->buf + hreq->buflen,
+						   areq->nbytes, 0);
+		return 0;
+	}
+
+	/* calculate required parts of the request */
+	datalen =3D (opmode & RTCR_HASH_UPDATE) ? areq->nbytes : 0;
+	if (opmode & RTCR_HASH_FINAL) {
+		nextbuflen =3D 0;
+		padlen =3D 64 - ((hreq->buflen + datalen) & 63);
+		if (padlen < 9)
+			padlen +=3D 64;
+		hreq->totallen +=3D hreq->buflen + datalen;
+
+		memset(pad, 0, sizeof(pad) - sizeof(u64));
+		ppad =3D (char *)&pad[RTCR_HASH_PAD_SIZE] - padlen;
+		*ppad =3D 0x80;
+		pad[RTCR_HASH_PAD_SIZE - 1] =3D hreq->state & RTCR_REQ_MD5 ?
+					      cpu_to_le64(hreq->totallen << 3) :
+					      cpu_to_be64(hreq->totallen << 3);
+	} else {
+		nextbuflen =3D (hreq->buflen + datalen) & 63;
+		padlen =3D 0;
+		datalen -=3D nextbuflen;
+		hreq->totallen +=3D hreq->buflen + datalen;
+	}
+	reqlen =3D hreq->buflen + datalen + padlen;
+
+	/* Write back any uncommitted data to memory. */
+	if (hreq->buflen)
+		dma_sync_single_for_device(cdev->dev, virt_to_phys(hreq->buf),
+					   hreq->buflen, DMA_TO_DEVICE);
+	if (padlen)
+		dma_sync_single_for_device(cdev->dev, virt_to_phys(ppad),
+					   padlen, DMA_TO_DEVICE);
+	if (datalen)
+		dma_map_sg(cdev->dev, sg, sgcnt, DMA_TO_DEVICE);
+
+	/* Get free space in the ring */
+	sgcnt =3D 1 + (hreq->buflen ? 1 : 0) + (datalen ? sgcnt : 0) + (padlen ?=
 1 : 0);
+
+	ret =3D rtcr_alloc_ring(cdev, sgcnt, &srcidx, &dstidx, RTCR_WB_LEN_HASH,=
 NULL);
+	if (ret)
+		return ret;
+	/*
+	 * Feed input data into the rings. Start with destination ring and fill
+	 * source ring afterwards. Ensure that the owner flag of the first sourc=
e
+	 * ring is the last that becomes visible to the engine.
+	 */
+	rtcr_add_dst_to_ring(cdev, dstidx, NULL, 0, hreq->vector, 0);
+
+	idx =3D srcidx;
+	if (hreq->buflen) {
+		idx =3D rtcr_inc_src_idx(idx, 1);
+		rtcr_add_src_to_ring(cdev, idx, hreq->buf, hreq->buflen, reqlen);
+	}
+
+	while (datalen) {
+		len =3D min(sg_dma_len(sg), datalen);
+
+		idx =3D rtcr_inc_src_idx(idx, 1);
+		rtcr_add_src_to_ring(cdev, idx, sg_virt(sg), len, reqlen);
+
+		datalen -=3D len;
+		if (datalen)
+			sg =3D sg_next(sg);
+	}
+
+	if (padlen) {
+		idx =3D rtcr_inc_src_idx(idx, 1);
+		rtcr_add_src_to_ring(cdev, idx, ppad, padlen, reqlen);
+	}
+
+	rtcr_add_src_pad_to_ring(cdev, idx, reqlen);
+	rtcr_add_src_ahash_to_ring(cdev, srcidx, hctx->opmode, reqlen);
+
+	/* Off we go */
+	rtcr_kick_engine(cdev);
+	if (rtcr_wait_for_request(cdev, dstidx))
+		return -EINVAL;
+
+	hreq->state |=3D RTCR_REQ_FB_ACT;
+	hreq->buflen =3D nextbuflen;
+
+	if (nextbuflen)
+		sg_pcopy_to_buffer(sg, sg_nents(sg), hreq->buf, nextbuflen, len);
+	if (padlen)
+		memcpy(areq->result, hreq->vector, crypto_ahash_digestsize(tfm));
+
+	return 0;
+}
+
+static void rtcr_check_request(struct ahash_request *areq, int opmode)
+{
+	struct rtcr_ahash_req *hreq =3D ahash_request_ctx(areq);
+	struct scatterlist *sg =3D areq->src;
+	int reqlen, sgcnt, sgmax;
+
+	if (hreq->state & RTCR_REQ_FB_ACT)
+		return;
+
+	if (reqlen > RTCR_MAX_REQ_SIZE) {
+		hreq->state |=3D RTCR_REQ_FB_ACT;
+		return;
+	}
+
+	sgcnt =3D 0;
+	sgmax =3D RTCR_MAX_SG_AHASH - (hreq->buflen ? 1 : 0);
+	reqlen =3D areq->nbytes;
+	if (!(opmode & RTCR_HASH_FINAL)) {
+		reqlen -=3D (hreq->buflen + reqlen) & 63;
+		sgmax--;
+	}
+
+	while (reqlen > 0) {
+		reqlen -=3D sg_dma_len(sg);
+		sgcnt++;
+		sg =3D sg_next(sg);
+	}
+
+	if (sgcnt > sgmax)
+		hreq->state |=3D RTCR_REQ_FB_ACT;
+	else
+		hreq->state =3D (hreq->state & ~RTCR_REQ_SG_MASK) | sgcnt;
+}
+
+static bool rtcr_check_fallback(struct ahash_request *areq)
+{
+	struct ahash_request *freq =3D fallback_request_ctx(areq);
+	struct rtcr_ahash_req *hreq =3D ahash_request_ctx(areq);
+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
+	struct rtcr_ahash_ctx *hctx =3D crypto_ahash_ctx(tfm);
+	union rtcr_fallback_state state;
+
+	if (!(hreq->state & RTCR_REQ_FB_ACT))
+		return false;
+
+	if (!(hreq->state & RTCR_REQ_FB_RDY)) {
+		/* Convert state to generic fallback state */
+		if (hreq->state & RTCR_REQ_MD5) {
+			memcpy(state.md5.hash, hreq->vector, MD5_DIGEST_SIZE);
+			if (hreq->totallen)
+				cpu_to_le32_array(state.md5.hash, 4);
+			memcpy(state.md5.block, hreq->buf, SHA1_BLOCK_SIZE);
+			state.md5.byte_count =3D hreq->totallen + (u64)hreq->buflen;
+		} else {
+			memcpy(state.sha1.state, hreq->vector, SHA1_DIGEST_SIZE);
+			memcpy(state.sha1.buffer, &hreq->buf, SHA1_BLOCK_SIZE);
+			state.sha1.count =3D hreq->totallen + (u64)hreq->buflen;
+		}
+	}
+
+	ahash_request_set_tfm(freq, hctx->fback);
+	ahash_request_set_crypt(freq, areq->src, areq->result, areq->nbytes);
+
+	if (!(hreq->state & RTCR_REQ_FB_RDY)) {
+		crypto_ahash_import(freq, &state);
+		hreq->state |=3D RTCR_REQ_FB_RDY;
+	}
+
+	return true;
+}
+
+static int rtcr_ahash_init(struct ahash_request *areq)
+{
+	struct rtcr_ahash_req *hreq =3D ahash_request_ctx(areq);
+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
+	int ds =3D crypto_ahash_digestsize(tfm);
+
+	memset(hreq, 0, sizeof(*hreq));
+
+	hreq->vector[0] =3D SHA1_H0;
+	hreq->vector[1] =3D SHA1_H1;
+	hreq->vector[2] =3D SHA1_H2;
+	hreq->vector[3] =3D SHA1_H3;
+	hreq->vector[4] =3D SHA1_H4;
+
+	hreq->state |=3D (ds =3D=3D MD5_DIGEST_SIZE) ? RTCR_REQ_MD5 : RTCR_REQ_S=
HA1;
+
+	return 0;
+}
+
+static int rtcr_ahash_update(struct ahash_request *areq)
+{
+	struct ahash_request *freq =3D fallback_request_ctx(areq);
+
+	rtcr_check_request(areq, RTCR_HASH_UPDATE);
+	if (rtcr_check_fallback(areq))
+		return crypto_ahash_update(freq);
+	return rtcr_process_hash(areq, RTCR_HASH_UPDATE);
+}
+
+static int rtcr_ahash_final(struct ahash_request *areq)
+{
+	struct ahash_request *freq =3D fallback_request_ctx(areq);
+
+	if (rtcr_check_fallback(areq))
+		return crypto_ahash_final(freq);
+
+	return rtcr_process_hash(areq, RTCR_HASH_FINAL);
+}
+
+static int rtcr_ahash_finup(struct ahash_request *areq)
+{
+	struct ahash_request *freq =3D fallback_request_ctx(areq);
+
+	rtcr_check_request(areq, RTCR_HASH_FINAL | RTCR_HASH_UPDATE);
+	if (rtcr_check_fallback(areq))
+		return crypto_ahash_finup(freq);
+
+	return rtcr_process_hash(areq, RTCR_HASH_FINAL | RTCR_HASH_UPDATE);
+}
+
+static int rtcr_ahash_digest(struct ahash_request *areq)
+{
+	struct ahash_request *freq =3D fallback_request_ctx(areq);
+	int ret;
+
+	ret =3D rtcr_ahash_init(areq);
+	if (ret)
+		return ret;
+
+	rtcr_check_request(areq, RTCR_HASH_FINAL | RTCR_HASH_UPDATE);
+	if (rtcr_check_fallback(areq))
+		return crypto_ahash_digest(freq);
+
+	return rtcr_process_hash(areq, RTCR_HASH_FINAL | RTCR_HASH_UPDATE);
+}
+
+static int rtcr_ahash_import(struct ahash_request *areq, const void *in)
+{
+	const void *fexp =3D (const void *)fallback_export_state((void *)in);
+	struct ahash_request *freq =3D fallback_request_ctx(areq);
+	struct rtcr_ahash_req *hreq =3D ahash_request_ctx(areq);
+	const struct rtcr_ahash_req *hexp =3D in;
+
+	hreq->state =3D get_unaligned(&hexp->state);
+	if (hreq->state & RTCR_REQ_FB_ACT)
+		hreq->state |=3D RTCR_REQ_FB_RDY;
+
+	if (rtcr_check_fallback(areq))
+		return crypto_ahash_import(freq, fexp);
+
+	memcpy(hreq, hexp, sizeof(struct rtcr_ahash_req));
+
+	return 0;
+}
+
+static int rtcr_ahash_export(struct ahash_request *areq, void *out)
+{
+	struct ahash_request *freq =3D fallback_request_ctx(areq);
+	struct rtcr_ahash_req *hreq =3D ahash_request_ctx(areq);
+	void *fexp =3D fallback_export_state(out);
+	struct rtcr_ahash_req *hexp =3D out;
+
+	if (rtcr_check_fallback(areq)) {
+		put_unaligned(hreq->state, &hexp->state);
+		return crypto_ahash_export(freq, fexp);
+	}
+
+	memcpy(hexp, hreq, sizeof(struct rtcr_ahash_req));
+
+	return 0;
+}
+
+static int rtcr_ahash_cra_init(struct crypto_tfm *tfm)
+{
+	struct crypto_ahash *ahash =3D __crypto_ahash_cast(tfm);
+	struct rtcr_ahash_ctx *hctx =3D crypto_tfm_ctx(tfm);
+	struct rtcr_crypto_dev *cdev =3D hctx->cdev;
+	struct rtcr_alg_template *tmpl;
+
+	tmpl =3D container_of(__crypto_ahash_alg(tfm->__crt_alg),
+			     struct rtcr_alg_template, alg.ahash);
+
+	hctx->cdev =3D tmpl->cdev;
+	hctx->opmode =3D tmpl->opmode;
+	hctx->fback =3D crypto_alloc_ahash(crypto_tfm_alg_name(tfm), 0,
+					 CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+
+	if (IS_ERR(hctx->fback)) {
+		dev_err(cdev->dev, "could not allocate fallback for %s\n",
+			crypto_tfm_alg_name(tfm));
+		return PTR_ERR(hctx->fback);
+	}
+
+	crypto_ahash_set_reqsize(ahash, max(sizeof(struct rtcr_ahash_req),
+					    offsetof(struct rtcr_ahash_req, vector) +
+					    sizeof(struct ahash_request) +
+					    crypto_ahash_reqsize(hctx->fback)));
+
+	return 0;
+}
+
+static void rtcr_ahash_cra_exit(struct crypto_tfm *tfm)
+{
+	struct rtcr_ahash_ctx *hctx =3D crypto_tfm_ctx(tfm);
+
+	crypto_free_ahash(hctx->fback);
+}
+
+struct rtcr_alg_template rtcr_ahash_md5 =3D {
+	.type =3D RTCR_ALG_AHASH,
+	.opmode =3D RTCR_SRC_OP_MS_HASH | RTCR_SRC_OP_HASH_MD5,
+	.alg.ahash =3D {
+		.init =3D rtcr_ahash_init,
+		.update =3D rtcr_ahash_update,
+		.final =3D rtcr_ahash_final,
+		.finup =3D rtcr_ahash_finup,
+		.export =3D rtcr_ahash_export,
+		.import =3D rtcr_ahash_import,
+		.digest =3D rtcr_ahash_digest,
+		.halg =3D {
+			.digestsize =3D MD5_DIGEST_SIZE,
+			/* statesize calculated during initialization */
+			.base =3D {
+				.cra_name =3D "md5",
+				.cra_driver_name =3D "realtek-md5",
+				.cra_priority =3D 300,
+				.cra_flags =3D CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				.cra_blocksize =3D SHA1_BLOCK_SIZE,
+				.cra_ctxsize =3D sizeof(struct rtcr_ahash_ctx),
+				.cra_alignmask =3D 0,
+				.cra_init =3D rtcr_ahash_cra_init,
+				.cra_exit =3D rtcr_ahash_cra_exit,
+				.cra_module =3D THIS_MODULE,
+			}
+		}
+	}
+};
+
+struct rtcr_alg_template rtcr_ahash_sha1 =3D {
+	.type =3D RTCR_ALG_AHASH,
+	.opmode =3D RTCR_SRC_OP_MS_HASH | RTCR_SRC_OP_HASH_SHA1,
+	.alg.ahash =3D {
+		.init =3D rtcr_ahash_init,
+		.update =3D rtcr_ahash_update,
+		.final =3D rtcr_ahash_final,
+		.finup =3D rtcr_ahash_finup,
+		.export =3D rtcr_ahash_export,
+		.import =3D rtcr_ahash_import,
+		.digest =3D rtcr_ahash_digest,
+		.halg =3D {
+			.digestsize =3D SHA1_DIGEST_SIZE,
+			/* statesize calculated during initialization */
+			.base =3D {
+				.cra_name =3D "sha1",
+				.cra_driver_name =3D "realtek-sha1",
+				.cra_priority =3D 300,
+				.cra_flags =3D CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				.cra_blocksize =3D SHA1_BLOCK_SIZE,
+				.cra_ctxsize =3D sizeof(struct rtcr_ahash_ctx),
+				.cra_alignmask =3D 0,
+				.cra_init =3D rtcr_ahash_cra_init,
+				.cra_exit =3D rtcr_ahash_cra_exit,
+				.cra_module =3D THIS_MODULE,
+			}
+		}
+	}
+};
=2D-
2.38.1

