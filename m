Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A130FC10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 15:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B1F3217F4
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 15:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfDKPv5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 11:51:57 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:44548 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbfDKPv4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 11:51:56 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 72C0C72CC58;
        Thu, 11 Apr 2019 18:51:53 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id 238144A4A2A;
        Thu, 11 Apr 2019 18:51:53 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v9 04/10] KEYS: do not kmemdup digest in {public,tpm}_key_verify_signature
Date:   Thu, 11 Apr 2019 18:51:16 +0300
Message-Id: <20190411155122.13245-5-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190411155122.13245-1-vt@altlinux.org>
References: <20190411155122.13245-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Treat (struct public_key_signature)'s digest same as its signature (s).
Since digest should be already in the kmalloc'd memory do not kmemdup
digest value before calling {public,tpm}_key_verify_signature.

Patch is split from the previous as suggested by Herbert Xu.

Suggested-by: David Howells <dhowells@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Reviewed-by: Denis Kenzior <denkenz@gmail.com>
---
 crypto/asymmetric_keys/asym_tpm.c   | 10 +---------
 crypto/asymmetric_keys/public_key.c |  9 +--------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
index 4e5b6fb57a94..402fc34ca044 100644
--- a/crypto/asymmetric_keys/asym_tpm.c
+++ b/crypto/asymmetric_keys/asym_tpm.c
@@ -748,7 +748,6 @@ static int tpm_key_verify_signature(const struct key *key,
 	char alg_name[CRYPTO_MAX_ALG_NAME];
 	uint8_t der_pub_key[PUB_KEY_BUF_SIZE];
 	uint32_t der_pub_key_len;
-	void *digest;
 	int ret;
 
 	pr_devel("==>%s()\n", __func__);
@@ -780,14 +779,9 @@ static int tpm_key_verify_signature(const struct key *key,
 	if (!req)
 		goto error_free_tfm;
 
-	ret = -ENOMEM;
-	digest = kmemdup(sig->digest, sig->digest_size, GFP_KERNEL);
-	if (!digest)
-		goto error_free_req;
-
 	sg_init_table(src_sg, 2);
 	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
-	sg_set_buf(&src_sg[1], digest, sig->digest_size);
+	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
 	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
 				   sig->digest_size);
 	crypto_init_wait(&cwait);
@@ -796,8 +790,6 @@ static int tpm_key_verify_signature(const struct key *key,
 				      crypto_req_done, &cwait);
 	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
 
-	kfree(digest);
-error_free_req:
 	akcipher_request_free(req);
 error_free_tfm:
 	crypto_free_akcipher(tfm);
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 0c069fe8a59c..33093b7bcc47 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -229,7 +229,6 @@ int public_key_verify_signature(const struct public_key *pkey,
 	struct akcipher_request *req;
 	struct scatterlist src_sg[2];
 	char alg_name[CRYPTO_MAX_ALG_NAME];
-	void *digest;
 	int ret;
 
 	pr_devel("==>%s()\n", __func__);
@@ -262,14 +261,9 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (ret)
 		goto error_free_req;
 
-	ret = -ENOMEM;
-	digest = kmemdup(sig->digest, sig->digest_size, GFP_KERNEL);
-	if (!digest)
-		goto error_free_req;
-
 	sg_init_table(src_sg, 2);
 	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
-	sg_set_buf(&src_sg[1], digest, sig->digest_size);
+	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
 	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
 				   sig->digest_size);
 	crypto_init_wait(&cwait);
@@ -278,7 +272,6 @@ int public_key_verify_signature(const struct public_key *pkey,
 				      crypto_req_done, &cwait);
 	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
 
-	kfree(digest);
 error_free_req:
 	akcipher_request_free(req);
 error_free_tfm:
-- 
2.11.0

