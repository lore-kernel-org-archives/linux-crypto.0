Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA86AC0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C947820693
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbfG3LGz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 07:06:55 -0400
Received: from inva020.nxp.com ([92.121.34.13]:37014 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730303AbfG3LGy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 07:06:54 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9558C1A0689;
        Tue, 30 Jul 2019 13:06:51 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 88A5C1A0671;
        Tue, 30 Jul 2019 13:06:51 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 34EB1204D6;
        Tue, 30 Jul 2019 13:06:51 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH v4 06/14] crypto: caam - check assoclen
Date:   Tue, 30 Jul 2019 14:06:37 +0300
Message-Id: <1564484805-28735-7-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1564484805-28735-1-git-send-email-iuliana.prodan@nxp.com>
References: <1564484805-28735-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Check assoclen to solve the extra tests that expect -EINVAL to be
returned when the associated data size is not valid.

Validated assoclen for RFC4106 and RFC4543 which expects an assoclen
of 16 or 20.
Based on seqiv, IPsec ESP and RFC4543/RFC4106 the assoclen is sizeof IP
Header (spi, seq_no, extended seq_no) and IV len. This can be 16 or 20
bytes.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Horia Geanta <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c     | 10 ++--------
 drivers/crypto/caam/caamalg_qi.c  | 12 ++++--------
 drivers/crypto/caam/caamalg_qi2.c | 10 ++--------
 3 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 0461bf3..47e61c0 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1598,10 +1598,7 @@ static int chachapoly_decrypt(struct aead_request *req)
 
 static int ipsec_gcm_encrypt(struct aead_request *req)
 {
-	if (req->assoclen < 8)
-		return -EINVAL;
-
-	return gcm_encrypt(req);
+	return crypto_ipsec_check_assoclen(req->assoclen) ? : gcm_encrypt(req);
 }
 
 static int aead_encrypt(struct aead_request *req)
@@ -1675,10 +1672,7 @@ static int gcm_decrypt(struct aead_request *req)
 
 static int ipsec_gcm_decrypt(struct aead_request *req)
 {
-	if (req->assoclen < 8)
-		return -EINVAL;
-
-	return gcm_decrypt(req);
+	return crypto_ipsec_check_assoclen(req->assoclen) ? : gcm_decrypt(req);
 }
 
 static int aead_decrypt(struct aead_request *req)
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 8011a2a..794d155d 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -1237,18 +1237,14 @@ static int aead_decrypt(struct aead_request *req)
 
 static int ipsec_gcm_encrypt(struct aead_request *req)
 {
-	if (req->assoclen < 8)
-		return -EINVAL;
-
-	return aead_crypt(req, true);
+	return crypto_ipsec_check_assoclen(req->assoclen) ? : aead_crypt(req,
+					   true);
 }
 
 static int ipsec_gcm_decrypt(struct aead_request *req)
 {
-	if (req->assoclen < 8)
-		return -EINVAL;
-
-	return aead_crypt(req, false);
+	return crypto_ipsec_check_assoclen(req->assoclen) ? : aead_crypt(req,
+					   false);
 }
 
 static void skcipher_done(struct caam_drv_req *drv_req, u32 status)
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index e351ff2..5fd6529 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1406,18 +1406,12 @@ static int aead_decrypt(struct aead_request *req)
 
 static int ipsec_gcm_encrypt(struct aead_request *req)
 {
-	if (req->assoclen < 8)
-		return -EINVAL;
-
-	return aead_encrypt(req);
+	return crypto_ipsec_check_assoclen(req->assoclen) ? : aead_encrypt(req);
 }
 
 static int ipsec_gcm_decrypt(struct aead_request *req)
 {
-	if (req->assoclen < 8)
-		return -EINVAL;
-
-	return aead_decrypt(req);
+	return crypto_ipsec_check_assoclen(req->assoclen) ? : aead_decrypt(req);
 }
 
 static void skcipher_encrypt_done(void *cbk_ctx, u32 status)
-- 
2.1.0

