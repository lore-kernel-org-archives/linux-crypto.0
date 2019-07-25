Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70E9C7618B
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 13:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79D9D22BEF
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 13:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388113AbfGYNuL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 09:50:11 -0400
Received: from inva021.nxp.com ([92.121.34.21]:49876 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387579AbfGYNuK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 09:50:10 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2176020071C;
        Thu, 25 Jul 2019 15:50:09 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1421D200716;
        Thu, 25 Jul 2019 15:50:09 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C76CA205EE;
        Thu, 25 Jul 2019 15:50:08 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH v2] crypto: gcm - restrict assoclen for rfc4543
Date:   Thu, 25 Jul 2019 16:49:59 +0300
Message-Id: <1564062599-8965-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Based on seqiv, IPsec ESP and rfc4543/rfc4106 the assoclen can be 16 or
20 bytes.

From esp4/esp6, assoclen is sizeof IP Header. This includes spi, seq_no
and extended seq_no, that is 8 or 12 bytes.
In seqiv, to asscolen is added the IV size (8 bytes).
Therefore, the assoclen, for rfc4543, should be restricted to 16 or 20
bytes, as for rfc4106.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
Changes since v1:
- use helper functions added in crypto API, in series:
https://patchwork.kernel.org/project/linux-crypto/list/?series=150651

 crypto/gcm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index f69c251..3346e1f 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -1037,11 +1037,23 @@ static int crypto_rfc4543_copy_src_to_dst(struct aead_request *req, bool enc)
 
 static int crypto_rfc4543_encrypt(struct aead_request *req)
 {
+	int err;
+
+	err = check_ipsec_assoclen(req->assoclen);
+	if (err)
+		return err;
+
 	return crypto_rfc4543_crypt(req, true);
 }
 
 static int crypto_rfc4543_decrypt(struct aead_request *req)
 {
+	int err;
+
+	err = check_ipsec_assoclen(req->assoclen);
+	if (err)
+		return err;
+
 	return crypto_rfc4543_crypt(req, false);
 }
 
-- 
2.1.0

