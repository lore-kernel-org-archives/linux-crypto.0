Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C6AC31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 21:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05D0D20861
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 21:15:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="lwRp6G/w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfFQVPH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 17:15:07 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:39052 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727337AbfFQVPG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 17:15:06 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45SPB03RFxz9v32j;
        Mon, 17 Jun 2019 23:15:04 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=lwRp6G/w; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id MU2O3ImLPtYv; Mon, 17 Jun 2019 23:15:04 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45SPB02Nzlz9v32f;
        Mon, 17 Jun 2019 23:15:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1560806104; bh=ICrZPIPXP+mZQXc1EQQD5yVv+C0fZhFeOVrVqgUA7t4=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=lwRp6G/wlgzAB+8ObZlvJvVIuCE7iEsvWVAQc2CYpKjnNSl1+jVim2R/MRJNh+6PX
         HWLwie0q++ZNypepWFQaM5FP2f2WHCcJJbb8LHeiX7/3Q+HgH9dZNF4uoo75qFHvpT
         ftwuTo1b16ELTNp5vtNb6mwT0kgK1LO48IPEaIGk=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 865138B84B;
        Mon, 17 Jun 2019 23:15:04 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id MF9o1Fkm4w36; Mon, 17 Jun 2019 23:15:04 +0200 (CEST)
Received: from po16838vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 477658B7FF;
        Mon, 17 Jun 2019 23:15:04 +0200 (CEST)
Received: by localhost.localdomain (Postfix, from userid 0)
        id F0A63682B3; Mon, 17 Jun 2019 21:15:03 +0000 (UTC)
Message-Id: <14e9e58bf69a08ec4c17d22d03e89cc7c3394f97.1560805614.git.christophe.leroy@c-s.fr>
In-Reply-To: <cover.1560805614.git.christophe.leroy@c-s.fr>
References: <cover.1560805614.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v4 2/4] crypto: talitos - move struct talitos_edesc into
 talitos.h
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Mon, 17 Jun 2019 21:15:03 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Moves struct talitos_edesc into talitos.h so that it can be used
from any place in talitos.c

It will be required for next patch ("crypto: talitos - fix hash
on SEC1")

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: stable@vger.kernel.org
---
 drivers/crypto/talitos.c | 30 ------------------------------
 drivers/crypto/talitos.h | 30 ++++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a7704b53529d..95dc3957f358 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -951,36 +951,6 @@ static int aead_des3_setkey(struct crypto_aead *authenc,
 	goto out;
 }
 
-/*
- * talitos_edesc - s/w-extended descriptor
- * @src_nents: number of segments in input scatterlist
- * @dst_nents: number of segments in output scatterlist
- * @icv_ool: whether ICV is out-of-line
- * @iv_dma: dma address of iv for checking continuity and link table
- * @dma_len: length of dma mapped link_tbl space
- * @dma_link_tbl: bus physical address of link_tbl/buf
- * @desc: h/w descriptor
- * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1) (SEC2)
- * @buf: input and output buffeur (if {src,dst}_nents > 1) (SEC1)
- *
- * if decrypting (with authcheck), or either one of src_nents or dst_nents
- * is greater than 1, an integrity check value is concatenated to the end
- * of link_tbl data
- */
-struct talitos_edesc {
-	int src_nents;
-	int dst_nents;
-	bool icv_ool;
-	dma_addr_t iv_dma;
-	int dma_len;
-	dma_addr_t dma_link_tbl;
-	struct talitos_desc desc;
-	union {
-		struct talitos_ptr link_tbl[0];
-		u8 buf[0];
-	};
-};
-
 static void talitos_sg_unmap(struct device *dev,
 			     struct talitos_edesc *edesc,
 			     struct scatterlist *src,
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 32ad4fc679ed..95f78c6d9206 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -42,6 +42,36 @@ struct talitos_desc {
 
 #define TALITOS_DESC_SIZE	(sizeof(struct talitos_desc) - sizeof(__be32))
 
+/*
+ * talitos_edesc - s/w-extended descriptor
+ * @src_nents: number of segments in input scatterlist
+ * @dst_nents: number of segments in output scatterlist
+ * @icv_ool: whether ICV is out-of-line
+ * @iv_dma: dma address of iv for checking continuity and link table
+ * @dma_len: length of dma mapped link_tbl space
+ * @dma_link_tbl: bus physical address of link_tbl/buf
+ * @desc: h/w descriptor
+ * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1) (SEC2)
+ * @buf: input and output buffeur (if {src,dst}_nents > 1) (SEC1)
+ *
+ * if decrypting (with authcheck), or either one of src_nents or dst_nents
+ * is greater than 1, an integrity check value is concatenated to the end
+ * of link_tbl data
+ */
+struct talitos_edesc {
+	int src_nents;
+	int dst_nents;
+	bool icv_ool;
+	dma_addr_t iv_dma;
+	int dma_len;
+	dma_addr_t dma_link_tbl;
+	struct talitos_desc desc;
+	union {
+		struct talitos_ptr link_tbl[0];
+		u8 buf[0];
+	};
+};
+
 /**
  * talitos_request - descriptor submission request
  * @desc: descriptor pointer (kernel virtual)
-- 
2.13.3

