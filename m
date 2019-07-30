Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285C1C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBDF6206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbfG3LDH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 07:03:07 -0400
Received: from inva021.nxp.com ([92.121.34.21]:51554 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfG3LDH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 07:03:07 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 99F9E20065E;
        Tue, 30 Jul 2019 13:03:05 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8DE20200186;
        Tue, 30 Jul 2019 13:03:05 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2E711204D6;
        Tue, 30 Jul 2019 13:03:05 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH v3] crypto: gcm - restrict assoclen for rfc4543
Date:   Tue, 30 Jul 2019 13:54:37 +0300
Message-Id: <1564484077-27727-1-git-send-email-iuliana.prodan@nxp.com>
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
Changes since v2:
- use, newly renamed, helper functions added in crypto API, in series:
https://patchwork.kernel.org/project/linux-crypto/list/?series=152649

 crypto/gcm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 2f3b50f..7eb5ced 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -1034,11 +1034,23 @@ static int crypto_rfc4543_copy_src_to_dst(struct aead_request *req, bool enc)
 
 static int crypto_rfc4543_encrypt(struct aead_request *req)
 {
+	int err;
+
+	err = crypto_ipsec_check_assoclen(req->assoclen);
+	if (err)
+		return err;
+
 	return crypto_rfc4543_crypt(req, true);
 }
 
 static int crypto_rfc4543_decrypt(struct aead_request *req)
 {
+	int err;
+
+	err = crypto_ipsec_check_assoclen(req->assoclen);
+	if (err)
+		return err;
+
 	return crypto_rfc4543_crypt(req, false);
 }
 
-- 
2.1.0

