Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A44C3DA7A
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Dec 2022 16:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiLaQZg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Dec 2022 11:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiLaQZd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Dec 2022 11:25:33 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A5E6330
        for <linux-crypto@vger.kernel.org>; Sat, 31 Dec 2022 08:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672503930; bh=2PN+aQfliJmr7CVXGIDg84d5SMY+P+P2eYJaeusJyZU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=tEEe1Blu2zMIpwhzrjeM7v0d+6fymq5pqTS7DbFNIVFjpuz4LaCmSA3mddZ5WwQK/
         rpwRCMrCGLhD4WKjgMqn9grdQD7uUmOcN+bH2nPzrcmaRxILtdYhKQF8Qmx9d3ISlD
         qBa0NGxPgV+BuUvHFw56WhXwB9G98HY7Q+d94fngbzMBFxfRVAjGHUWw6Zau+lw+JH
         IwlmeoeAzG7usAOXHySnbfBpIMHfTa1HSo+YXa7vB0R3y9+/4lqEEYo+MPiReKQNAJ
         BQC4JOc19ZG88wy0pbk1ZkPL0I7FyEC4hEaGS9jpOlRB+LtxMREPp4Q4Gd60Q+MRxT
         bJdkvPYH8kZqQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from fedora.willemsstb.de ([94.31.82.22]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MGQj7-1p21kV0a2n-00GqKA; Sat, 31
 Dec 2022 17:25:30 +0100
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     linux-crypto@vger.kernel.org
Cc:     Markus Stockhausen <markus.stockhausen@gmx.de>
Subject: [PATCH v3 3/6] crypto/realtek: hash algorithms
Date:   Sat, 31 Dec 2022 17:25:22 +0100
Message-Id: <20221231162525.416709-4-markus.stockhausen@gmx.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221231162525.416709-1-markus.stockhausen@gmx.de>
References: <20221231162525.416709-1-markus.stockhausen@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fMG7vSkntaH5RjNFZ81lGss62QpGN6iXnoouKSBqDhfSNWUf2BE
 Ul7ER7beGmBHSfsgJHs5FBaphD9/Nplre6rIdYf39BbRBMFYkSKkZ2A4b7RF9XWhGBul1Th
 LtnsmI+/D1uYowSvFwOUfk2f3Yaw0yUdPa4PgFWob36/eg+bdBI9km88piBOnMIzpEFX+Eb
 rcgBvg3jo5SzkhnQ1bxAw==
UI-OutboundReport: notjunk:1;M01:P0:Mc4cYr9V3n4=;NvNLjSd/Sns2m/pAENBd9TnpeIg
 6aAmj+EQdgArevGV0NX0P29hmoneHqBXEPUZh20Ju3iQQ2PhJVkcAETHns8dFqMhX7AnIYLbl
 mfjNRTT6uZhcbRujp5ODacnEEiXa3b4X5/bWR0OZnXol8ThEDYRJefMaAH3eRWdCt0DYeag9O
 C8HUfd6lnpajSO+mXbMG/AcH7CAmUx6SG9yzc7vjUDgUHGWD/T9o4wzISqo/JHoqzf+Knkas9
 LEbrMRovFwbkrWsyZhCq9QISEtnjdBW2KLs0cEn1eF3iLNb4QILJMHpgh80HScRKRCibv011P
 CLI0mHULP5TXKTxX4V6RLge++BglsZykeJ/EWHsIDvJkluK7MSjdbhU8Rh+Q7PfMQ0QPD5h3e
 ixDHW1JN1uV7AiiONZkHWu7lUttienO5FiHfshoYWgfkCe/U+JezJ61/T7WE6G5nNUisAtq08
 xovfLwcmi8Hy62n46UnvvB5xc6zDSK5/30k5Wm8RQQjS82mZqj8CLaKoPc1uopeILUrjH5Ddm
 y9xBOlfsnJD5n4QH8jYQiOj4oXY941C6lU9duag7acvcWERXh4lQRiy6GACjxjDA0w2c5YW7f
 aulssRyo/eNnf0xKBK//jDDWYyKfzaPkeCHwpae1+7hV0oCQC36poMIMQidcQqKEjGO3PsOp3
 7f9RJ2EWOsnRMQHPQyLkwxfG6qMtcp5wjvxvqMfd23FfUGBwsxNALLwFqiGkYgV0Wy6gqr+sT
 t30uqnlRCcNkGsEl/0DvSPFPyjI1Pw6Ad9lVlc5ddZFFUIt+/x5EkAepU7dISAafWtsa9LSDJ
 La7p+4LwEqIIZBtPNdzJxXP99jLjeBIlL5MbFkwkiN8YvdXZIRtg3ro5z3Fd4z6OFWe0uZR1a
 HGxXGUGsnpDx0eKoXWi1j+x91XdG0YqUFKKiBCY6jKg2qya6AVqA5Ebfi+3s6jJLcdkL+77Hs
 iV4IkA==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add md5/sha1 hash algorithms for new Realtek crypto device.

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
=2D--
 drivers/crypto/realtek/realtek_crypto_ahash.c | 412 ++++++++++++++++++
 1 file changed, 412 insertions(+)
 create mode 100644 drivers/crypto/realtek/realtek_crypto_ahash.c

diff --git a/drivers/crypto/realtek/realtek_crypto_ahash.c b/drivers/crypt=
o/realtek/realtek_crypto_ahash.c
new file mode 100644
index 000000000000..445c13dedaf7
=2D-- /dev/null
+++ b/drivers/crypto/realtek/realtek_crypto_ahash.c
@@ -0,0 +1,412 @@
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
+	unsigned int len, nextbuflen, datalen, padlen, reqlen, sgmap =3D 0;
+	struct rtcr_ahash_req *hreq =3D ahash_request_ctx(areq);
+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(areq);
+	struct rtcr_ahash_ctx *hctx =3D crypto_ahash_ctx(tfm);
+	int sgcnt =3D hreq->state & RTCR_REQ_SG_MASK;
+	struct rtcr_crypto_dev *cdev =3D hctx->cdev;
+	struct scatterlist *sg =3D areq->src;
+	int idx, srcidx, dstidx, ret;
+	u64 pad[RTCR_HASH_PAD_SIZE];
+	dma_addr_t paddma, bufdma;
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
+		bufdma =3D dma_map_single(cdev->dev, hreq->buf, hreq->buflen, DMA_TO_DE=
VICE);
+	if (padlen)
+		paddma =3D dma_map_single(cdev->dev, ppad, padlen, DMA_TO_DEVICE);
+	if (datalen)
+		sgmap =3D dma_map_sg(cdev->dev, sg, sgcnt, DMA_TO_DEVICE);
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
+	if (sgmap)
+		dma_unmap_sg(cdev->dev, sg, sgcnt, DMA_TO_DEVICE);
+	if (hreq->buflen)
+		dma_unmap_single(cdev->dev, bufdma, hreq->buflen, DMA_TO_DEVICE);
+	if (nextbuflen)
+		sg_pcopy_to_buffer(sg, sg_nents(sg), hreq->buf, nextbuflen, len);
+	if (padlen) {
+		dma_unmap_single(cdev->dev, paddma, padlen, DMA_TO_DEVICE);
+		memcpy(areq->result, hreq->vector, crypto_ahash_digestsize(tfm));
+	}
+
+	hreq->state |=3D RTCR_REQ_FB_ACT;
+	hreq->buflen =3D nextbuflen;
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

