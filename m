Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B5DC76188
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 07:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B132A2173B
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 07:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfGSHJe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 03:09:34 -0400
Received: from inva020.nxp.com ([92.121.34.13]:44568 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfGSHJe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 03:09:34 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A209C1A0130;
        Fri, 19 Jul 2019 09:09:32 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 953971A0126;
        Fri, 19 Jul 2019 09:09:32 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4BAEE205D1;
        Fri, 19 Jul 2019 09:09:32 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH 2/2] crypto: bcm - check assoclen for rfc4543/rfc4106
Date:   Fri, 19 Jul 2019 10:09:24 +0300
Message-Id: <1563520164-1153-2-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1563520164-1153-1-git-send-email-iuliana.prodan@nxp.com>
References: <1563520164-1153-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Validated assoclen for RFC4543 which expects an assoclen
of 16 or 20, the same as RFC4106.
Based on seqiv, IPsec ESP and RFC4543/RFC4106 the assoclen is sizeof
IP Header (spi, seq_no, extended seq_no) and IV len. This can be 16 or
20 bytes.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/bcm/cipher.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index d972ffa..02ef600 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2640,6 +2640,19 @@ static int aead_need_fallback(struct aead_request *req)
 		return 1;
 	}
 
+	/*
+	 * RFC4106 and RFC4543 cannot handle the case where AAD is other than
+	 * 16 or 20 bytes long. So use fallback in this case.
+	 */
+	if (ctx->cipher.mode == CIPHER_MODE_GCM &&
+	    ctx->cipher.alg == CIPHER_ALG_AES &&
+	    rctx->iv_ctr_len == GCM_RFC4106_IV_SIZE &&
+	    req->assoclen != 16 && req->assoclen != 20) {
+		flow_log("RFC4106/RFC4543 needs fallback for assoclen"
+			 " other than 16 or 20 bytes\n");
+		return 1;
+	}
+
 	payload_len = req->cryptlen;
 	if (spu->spu_type == SPU_TYPE_SPUM)
 		payload_len += req->assoclen;
-- 
2.1.0

