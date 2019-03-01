Return-Path: <SRS0=jX8O=RE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9F7C10F03
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 18:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B28E20842
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 18:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388913AbfCASAd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Mar 2019 13:00:33 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:40188 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389760AbfCAR73 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Mar 2019 12:59:29 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 4393172CCB8;
        Fri,  1 Mar 2019 20:59:26 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id 1C3F94A4AE7;
        Fri,  1 Mar 2019 20:59:26 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 02/11] crypto: akcipher - check the presence of callback before the call
Date:   Fri,  1 Mar 2019 20:59:09 +0300
Message-Id: <20190301175918.29694-3-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190301175918.29694-1-vt@altlinux.org>
References: <20190301175918.29694-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Because with introduction of EC-RDSA and change in workings of RSA in
regard to sign/verify, akcipher could have not all callbacks defined,
check the presence of callbacks before calling them to increase
robustness.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 include/crypto/akcipher.h | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 2d690494568c..f537fad1989f 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -268,7 +268,10 @@ static inline unsigned int crypto_akcipher_maxsize(struct crypto_akcipher *tfm)
 {
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
-	return alg->max_size(tfm);
+	if (alg->max_size)
+		return alg->max_size(tfm);
+	else
+		return 0;
 }
 
 /**
@@ -287,10 +290,11 @@ static inline int crypto_akcipher_encrypt(struct akcipher_request *req)
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 	struct crypto_alg *calg = tfm->base.__crt_alg;
 	unsigned int src_len = req->src_len;
-	int ret;
+	int ret = -ENOSYS;
 
 	crypto_stats_get(calg);
-	ret = alg->encrypt(req);
+	if (alg->encrypt)
+		ret = alg->encrypt(req);
 	crypto_stats_akcipher_encrypt(src_len, ret, calg);
 	return ret;
 }
@@ -311,10 +315,11 @@ static inline int crypto_akcipher_decrypt(struct akcipher_request *req)
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 	struct crypto_alg *calg = tfm->base.__crt_alg;
 	unsigned int src_len = req->src_len;
-	int ret;
+	int ret = -ENOSYS;
 
 	crypto_stats_get(calg);
-	ret = alg->decrypt(req);
+	if (alg->decrypt)
+		ret = alg->decrypt(req);
 	crypto_stats_akcipher_decrypt(src_len, ret, calg);
 	return ret;
 }
@@ -334,10 +339,11 @@ static inline int crypto_akcipher_sign(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 	struct crypto_alg *calg = tfm->base.__crt_alg;
-	int ret;
+	int ret = -ENOSYS;
 
 	crypto_stats_get(calg);
-	ret = alg->sign(req);
+	if (alg->sign)
+		ret = alg->sign(req);
 	crypto_stats_akcipher_sign(ret, calg);
 	return ret;
 }
@@ -357,10 +363,11 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 	struct crypto_alg *calg = tfm->base.__crt_alg;
-	int ret;
+	int ret = -ENOSYS;
 
 	crypto_stats_get(calg);
-	ret = alg->verify(req);
+	if (alg->verify)
+		ret = alg->verify(req);
 	crypto_stats_akcipher_verify(ret, calg);
 	return ret;
 }
-- 
2.11.0

