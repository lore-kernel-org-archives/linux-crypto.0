Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79C7C282CE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 15:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84E3D20818
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 15:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfDKPvo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 11:51:44 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:44222 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfDKPvn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 11:51:43 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 79ADF72CC61;
        Thu, 11 Apr 2019 18:51:41 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id 269CE4A4A2A;
        Thu, 11 Apr 2019 18:51:41 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 01/10] crypto: akcipher - default implementations for request callbacks
Date:   Thu, 11 Apr 2019 18:51:13 +0300
Message-Id: <20190411155122.13245-2-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190411155122.13245-1-vt@altlinux.org>
References: <20190411155122.13245-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Because with the introduction of EC-RDSA and change in workings of RSA
in regard to sign/verify, akcipher could have not all callbacks defined,
check the presence of callbacks in crypto_register_akcipher() and
provide default implementation if the callback is not implemented.

This is suggested by Herbert Xu instead of checking the presence of the
callback on every request.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/akcipher.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 0cbeae137e0a..780daa436dac 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -119,10 +119,24 @@ static void akcipher_prepare_alg(struct akcipher_alg *alg)
 	base->cra_flags |= CRYPTO_ALG_TYPE_AKCIPHER;
 }
 
+static int akcipher_default_op(struct akcipher_request *req)
+{
+	return -ENOSYS;
+}
+
 int crypto_register_akcipher(struct akcipher_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 
+	if (!alg->sign)
+		alg->sign = akcipher_default_op;
+	if (!alg->verify)
+		alg->verify = akcipher_default_op;
+	if (!alg->encrypt)
+		alg->encrypt = akcipher_default_op;
+	if (!alg->decrypt)
+		alg->decrypt = akcipher_default_op;
+
 	akcipher_prepare_alg(alg);
 	return crypto_register_alg(base);
 }
-- 
2.11.0

