Return-Path: <SRS0=ApwQ=4M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E1CC11D2F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 16:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5369720838
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 16:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="OHU2Pf21"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgBXQSO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Feb 2020 11:18:14 -0500
Received: from gateway21.websitewelcome.com ([192.185.45.38]:42831 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727901AbgBXQSN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Feb 2020 11:18:13 -0500
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 10ABF400C7432
        for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2020 10:18:12 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6GQujYaLZvBMd6GQujUnoa; Mon, 24 Feb 2020 10:18:12 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BK34gbLB0O61efyzvyQ9e7T52/oWtRmHRLRXHAw2v7A=; b=OHU2Pf21ilVR4MIoRzfIuodi0t
        pC+s5ssxjXj8L3bE0xKBCzGGycCO0QybaEiSs0oa/u4/UXDHzCU82ejg2pXvoxO8l4vsTETQ3uWss
        fxKalF60rtAuTQNT9lFIWavUT3LzGwO1hgYvNuc9GpNEFlLTWFZnvzR+6N2HOUwBmEXJeIhUZciQl
        5epUOHZpAs7Ae3uniNt4jskl/P1ZENzz4i0NtOuJtErWQJ/rbMHxAaP/RUl9R4UWnvw00KGPHYTaH
        cSAagkMPtII9V80o5IQ1FUjs4xwqa4cqFwCsDaYJhSs8msYuP2hb01LXn37DfcZQoQGkodd1LvYky
        WuUVvmiQ==;
Received: from [200.68.140.135] (port=11044 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6GQr-002hbl-Rj; Mon, 24 Feb 2020 10:18:09 -0600
Date:   Mon, 24 Feb 2020 10:21:00 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto: Replace zero-length array with flexible-array member
Message-ID: <20200224162100.GA25697@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.68.140.135
X-Source-L: No
X-Exim-ID: 1j6GQr-002hbl-Rj
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.135]:11044
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 32
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/crypto/caam/caamalg.c              | 2 +-
 drivers/crypto/caam/caamalg_qi.c           | 4 ++--
 drivers/crypto/caam/caamalg_qi2.h          | 6 +++---
 drivers/crypto/caam/caamhash.c             | 2 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c | 2 +-
 drivers/crypto/chelsio/chcr_core.h         | 2 +-
 drivers/crypto/mediatek/mtk-sha.c          | 2 +-
 drivers/crypto/nx/nx.h                     | 2 +-
 drivers/crypto/omap-sham.c                 | 4 ++--
 include/crypto/if_alg.h                    | 2 +-
 10 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 03797f9b1050..b7bb7c30adeb 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -909,7 +909,7 @@ struct skcipher_edesc {
 	bool bklog;
 	dma_addr_t sec4_sg_dma;
 	struct sec4_sg_entry *sec4_sg;
-	u32 hw_desc[0];
+	u32 hw_desc[];
 };
 
 static void caam_unmap(struct device *dev, struct scatterlist *src,
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 4a29e0ef9d63..27e36bdf6163 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -783,7 +783,7 @@ struct aead_edesc {
 	unsigned int assoclen;
 	dma_addr_t assoclen_dma;
 	struct caam_drv_req drv_req;
-	struct qm_sg_entry sgt[0];
+	struct qm_sg_entry sgt[];
 };
 
 /*
@@ -803,7 +803,7 @@ struct skcipher_edesc {
 	int qm_sg_bytes;
 	dma_addr_t qm_sg_dma;
 	struct caam_drv_req drv_req;
-	struct qm_sg_entry sgt[0];
+	struct qm_sg_entry sgt[];
 };
 
 static struct caam_drv_ctx *get_drv_ctx(struct caam_ctx *ctx,
diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caamalg_qi2.h
index 706736776b47..f29cb7bd7dd3 100644
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -114,7 +114,7 @@ struct aead_edesc {
 	dma_addr_t qm_sg_dma;
 	unsigned int assoclen;
 	dma_addr_t assoclen_dma;
-	struct dpaa2_sg_entry sgt[0];
+	struct dpaa2_sg_entry sgt[];
 };
 
 /*
@@ -132,7 +132,7 @@ struct skcipher_edesc {
 	dma_addr_t iv_dma;
 	int qm_sg_bytes;
 	dma_addr_t qm_sg_dma;
-	struct dpaa2_sg_entry sgt[0];
+	struct dpaa2_sg_entry sgt[];
 };
 
 /*
@@ -146,7 +146,7 @@ struct ahash_edesc {
 	dma_addr_t qm_sg_dma;
 	int src_nents;
 	int qm_sg_bytes;
-	struct dpaa2_sg_entry sgt[0];
+	struct dpaa2_sg_entry sgt[];
 };
 
 /**
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 2fe852853d40..943bc0296267 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -536,7 +536,7 @@ struct ahash_edesc {
 	int sec4_sg_bytes;
 	bool bklog;
 	u32 hw_desc[DESC_JOB_IO_LEN_MAX / sizeof(u32)] ____cacheline_aligned;
-	struct sec4_sg_entry sec4_sg[0];
+	struct sec4_sg_entry sec4_sg[];
 };
 
 static inline void ahash_unmap(struct device *dev,
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index c4632d84c9a1..e91be9b8b083 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -71,7 +71,7 @@ struct ucode {
 	char version[VERSION_LEN - 1];
 	__be32 code_size;
 	u8 raz[12];
-	u64 code[0];
+	u64 code[];
 };
 
 /**
diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index b41ef1abfe74..e480096754b5 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -68,7 +68,7 @@ struct _key_ctx {
 	__be32 ctx_hdr;
 	u8 salt[MAX_SALT];
 	__be64 iv_to_auth;
-	unsigned char key[0];
+	unsigned char key[];
 };
 
 #define KEYCTX_TX_WR_IV_S  55
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index 9e9f48bb7f85..bd6309e57ab8 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -107,7 +107,7 @@ struct mtk_sha_ctx {
 	u8 id;
 	u8 buf[SHA_BUF_SIZE] __aligned(sizeof(u32));
 
-	struct mtk_sha_hmac_ctx	base[0];
+	struct mtk_sha_hmac_ctx	base[];
 };
 
 struct mtk_sha_drv {
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index 91c54289124a..c6233173c612 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -37,7 +37,7 @@ struct max_sync_cop {
 	u32 fc;
 	u32 mode;
 	u32 triplets;
-	struct msc_triplet trip[0];
+	struct msc_triplet trip[];
 } __packed;
 
 struct alg_props {
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 4f915a4ef5b0..e4072cd38585 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -159,7 +159,7 @@ struct omap_sham_reqctx {
 	int			sg_len;
 	unsigned int		total;	/* total request */
 
-	u8			buffer[0] OMAP_ALIGNED;
+	u8			buffer[] OMAP_ALIGNED;
 };
 
 struct omap_sham_hmac_ctx {
@@ -176,7 +176,7 @@ struct omap_sham_ctx {
 	/* fallback stuff */
 	struct crypto_shash	*fallback;
 
-	struct omap_sham_hmac_ctx base[0];
+	struct omap_sham_hmac_ctx base[];
 };
 
 #define OMAP_SHAM_QUEUE_LENGTH	10
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 24cfa96f98ea..56527c85d122 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -66,7 +66,7 @@ struct af_alg_sgl {
 struct af_alg_tsgl {
 	struct list_head list;
 	unsigned int cur;		/* Last processed SG entry */
-	struct scatterlist sg[0];	/* Array of SGs forming the SGL */
+	struct scatterlist sg[];	/* Array of SGs forming the SGL */
 };
 
 #define MAX_SGL_ENTS ((4096 - sizeof(struct af_alg_tsgl)) / \
-- 
2.25.0

