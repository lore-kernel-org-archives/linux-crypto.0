Return-Path: <SRS0=RXXs=4E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A206CC76199
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Feb 2020 09:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85489206E2
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Feb 2020 09:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgBPJAK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 16 Feb 2020 04:00:10 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:54952 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726222AbgBPJAK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Feb 2020 04:00:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04455;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Tq4XVIu_1581843596;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Tq4XVIu_1581843596)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 16 Feb 2020 16:59:57 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@kernel.org, pvanleeuwen@rambus.com, zohar@linux.ibm.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] X.509: support OSCCA sm2-with-sm3 certificate verification
Date:   Sun, 16 Feb 2020 16:59:28 +0800
Message-Id: <20200216085928.108838-8-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216085928.108838-1-tianjia.zhang@linux.alibaba.com>
References: <20200216085928.108838-1-tianjia.zhang@linux.alibaba.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The digital certificate format based on SM2 crypto algorithm as
specified in GM/T 0015-2012. It was published by State Encryption
Management Bureau, China.

The method of generating Other User Information is defined as
ZA=H256(ENTLA || IDA || a || b || xG || yG || xA || yA), it also
specified in https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02.

The x509 certificate supports sm2-with-sm3 type certificate
verification.  Because certificate verification requires ZA
in addition to tbs data, ZA also depends on elliptic curve
parameters and public key data, so you need to access tbs in sig
and calculate ZA. Finally calculate the digest of the
signature and complete the verification work. The calculation
process of ZA is declared in specifications GM/T 0009-2012
and GM/T 0003.2-2012.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 crypto/asymmetric_keys/public_key.c      | 61 ++++++++++++++++++++++++
 crypto/asymmetric_keys/x509_public_key.c |  2 +
 include/crypto/public_key.h              |  1 +
 3 files changed, 64 insertions(+)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index d7f43d4ea925..a51b09ee484d 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -17,6 +17,11 @@
 #include <keys/asymmetric-subtype.h>
 #include <crypto/public_key.h>
 #include <crypto/akcipher.h>
+#ifdef CONFIG_CRYPTO_SM2
+#include <crypto/sm3_base.h>
+#include <crypto/sm2.h>
+#include "x509_parser.h"
+#endif
 
 MODULE_DESCRIPTION("In-software asymmetric public-key subtype");
 MODULE_AUTHOR("Red Hat, Inc.");
@@ -245,6 +250,54 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 	return ret;
 }
 
+#ifdef CONFIG_CRYPTO_SM2
+static int cert_sig_digest_update(const struct public_key_signature *sig,
+				struct crypto_akcipher *tfm_pkey)
+{
+	struct x509_certificate *cert = sig->cert;
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	size_t desc_size;
+	unsigned char dgst[SM3_DIGEST_SIZE];
+	int ret;
+
+	if (!cert)
+		return -EINVAL;
+
+	ret = sm2_compute_z_digest(tfm_pkey, SM2_DEFAULT_USERID,
+					SM2_DEFAULT_USERID_LEN, dgst);
+	if (ret)
+		return ret;
+
+	tfm = crypto_alloc_shash(sig->hash_algo, 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	desc = kzalloc(desc_size, GFP_KERNEL);
+	if (!desc)
+		goto error_free_tfm;
+
+	desc->tfm = tfm;
+
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error_free_desc;
+
+	ret = crypto_shash_update(desc, dgst, SM3_DIGEST_SIZE);
+	if (ret < 0)
+		goto error_free_desc;
+
+	ret = crypto_shash_finup(desc, cert->tbs, cert->tbs_size, sig->digest);
+
+error_free_desc:
+	kfree(desc);
+error_free_tfm:
+	crypto_free_shash(tfm);
+	return ret;
+}
+#endif
+
 /*
  * Verify a signature using a public key.
  */
@@ -298,6 +351,14 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (ret)
 		goto error_free_key;
 
+#ifdef CONFIG_CRYPTO_SM2
+	if (strcmp(sig->pkey_algo, "sm2") == 0) {
+		ret = cert_sig_digest_update(sig, tfm);
+		if (ret)
+			goto error_free_key;
+	}
+#endif
+
 	sg_init_table(src_sg, 2);
 	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
 	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index d964cc82b69c..feccec08b244 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -30,6 +30,8 @@ int x509_get_sig_params(struct x509_certificate *cert)
 
 	pr_devel("==>%s()\n", __func__);
 
+	sig->cert = cert;
+
 	if (!cert->pub->pkey_algo)
 		cert->unsupported_key = true;
 
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 0588ef3bc6ff..27775e617e38 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -44,6 +44,7 @@ struct public_key_signature {
 	const char *pkey_algo;
 	const char *hash_algo;
 	const char *encoding;
+	void *cert;		/* For certificate */
 };
 
 extern void public_key_signature_free(struct public_key_signature *sig);
-- 
2.17.1

