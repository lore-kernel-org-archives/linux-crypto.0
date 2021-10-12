Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED305C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 02:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D74C760C41
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 02:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhJLCVH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Oct 2021 22:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbhJLCU4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Oct 2021 22:20:56 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4D6C06161C;
        Mon, 11 Oct 2021 19:18:55 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q12so11733908pgq.12;
        Mon, 11 Oct 2021 19:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xt7rgWPrwK28vY6niYAGTfZ1xmGRbeyDlGFissoKwwk=;
        b=XeipyhNCO+iH/8jlr6hO4QzZ2demj1OEpV/0w4+KahJJ5NrOx0C24b/2R0czXmsf9c
         9ylFgv2UVXoFURNe6FiXaL4Y9UettLnWa8OAT5pfY1pgkbm7/HS+H55tujlgD1H+XZv7
         fn+iwcL4RLT+E3A9fn8VT8YJxSt8wj+YUFzvPFoxidBtHLe0ayjy7R5IapGfi63GQNty
         kY5vMjfCvEe7q4cX2X3gGPesyQV1aNld2vrhHVPck2+nNDjHkr7+HvlQIwkyYVnZQqBw
         ds5n3em9Hkea7w4gZMY5qeGLmEz8Y3f7ynOEWN9hCzna+q24ZtI9DLsqCWiyczGUDY6i
         Q3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xt7rgWPrwK28vY6niYAGTfZ1xmGRbeyDlGFissoKwwk=;
        b=Bv2RBav7wUnBrBMAB9qFKgqZgMg+03r22Tqp9Cqd/nx/lu5KfZfnBxV9vr68GczylF
         ctuxl5aar1r3mLUsETlfUkz9sD84x93jiD6Bm+VtYwjpXRHvt70bRapufpqjMdSZa+5w
         TJNGaLDArmzUKnth/+xsRG4v7Yt750im9LEceZMIdMSuZyGReNujqcqf8z/5LhRYoreD
         PBt87MMcoZyNjZBPbr596rF8djT4XBZ6X4JzDVOhtsBqJgAVXS2XAGwvsEqebZVl1imE
         1GAsjC3UW9gzmiT5UpSE3WW42OwKbI8QNP7WRo5Mmwvia1syZhhwND1fsUDi1BNSU83b
         y2mA==
X-Gm-Message-State: AOAM5309UD3EtKNh5yPkHRp6p0qJSR6lpLlWdss/xiGztJQKE1n4dGoW
        ZNUy1ZT3NUm8/EUhi8eplaUpJB03jvQ=
X-Google-Smtp-Source: ABdhPJw8YVQrH9pFP+VWmiFxEejVFA8XcYM9db3tAO8uHAFZ7k8ga3/N9EsipI1TKaq/kvdozs7agQ==
X-Received: by 2002:a63:e613:: with SMTP id g19mr21212963pgh.12.1634005134215;
        Mon, 11 Oct 2021 19:18:54 -0700 (PDT)
Received: from localhost.localdomain ([162.14.23.249])
        by smtp.gmail.com with ESMTPSA id l207sm8963835pfd.199.2021.10.11.19.18.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Oct 2021 19:18:53 -0700 (PDT)
From:   Hongbo Li <herbert.tencent@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        herberthbli@tencent.com
Cc:     linux-kernel@vger.kernel.org, Hongbo Li <herbert.tencent@gmail.com>
Subject: [PATCH v3 2/5] x509: add support for eddsa
Date:   Tue, 12 Oct 2021 10:17:53 +0800
Message-Id: <1634005076-17534-3-git-send-email-herbert.tencent@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634005076-17534-1-git-send-email-herbert.tencent@gmail.com>
References: <1634005076-17534-1-git-send-email-herbert.tencent@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch make x509 support eddsa(currently ed25519). According to
RFC8032 section 5.1.7[1], the digest is not on the original message,
but on a special formated message string:
        SHA512(dom2(F, C) || R || A || PH(M))

[1]: https://tools.ietf.org/html/rfc8032#section-5.1.7

Signed-off-by: Hongbo Li <herbert.tencent@gmail.com>
---
 crypto/asymmetric_keys/public_key.c       | 73 +++++++++++++++++++++++++++----
 crypto/asymmetric_keys/x509_cert_parser.c | 14 +++++-
 crypto/asymmetric_keys/x509_public_key.c  |  4 +-
 include/linux/oid_registry.h              |  1 +
 4 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 4fefb21..c1236a8 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -251,8 +251,8 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 }
 
 #if IS_REACHABLE(CONFIG_CRYPTO_SM2)
-static int cert_sig_digest_update(const struct public_key_signature *sig,
-				  struct crypto_akcipher *tfm_pkey)
+static int sm2_cert_sig_digest_update(const struct public_key_signature *sig,
+				      struct crypto_akcipher *tfm_pkey)
 {
 	struct crypto_shash *tfm;
 	struct shash_desc *desc;
@@ -297,7 +297,7 @@ static int cert_sig_digest_update(const struct public_key_signature *sig,
 	return ret;
 }
 #else
-static inline int cert_sig_digest_update(
+static inline int sm2_cert_sig_digest_update(
 	const struct public_key_signature *sig,
 	struct crypto_akcipher *tfm_pkey)
 {
@@ -305,6 +305,58 @@ static inline int cert_sig_digest_update(
 }
 #endif /* ! IS_REACHABLE(CONFIG_CRYPTO_SM2) */
 
+static int eddsa_cert_sig_digest_update(const struct public_key *pub,
+					const struct public_key_signature *sig)
+{
+	struct crypto_shash *tfm = NULL;
+	struct shash_desc *desc = NULL;
+	int key_size, ret = 0;
+
+	if (strcmp(pub->pkey_algo, "eddsa-25519"))
+		return -ENOPKG;
+
+	tfm = crypto_alloc_shash(sig->hash_algo, 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	desc = kzalloc(sizeof(*desc) + crypto_shash_descsize(tfm), GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
+	desc->tfm = tfm;
+
+	/* RFC8032 section 5.1.7
+	 * step 2. SHA512(dom2(F, C) || R || A || PH(M))
+	 */
+	key_size = 32;
+	if (sig->s_size != key_size * 2 ||
+	    pub->keylen != key_size) {
+		ret = -EINVAL;
+		goto free;
+	}
+
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto free;
+
+	ret = crypto_shash_update(desc, sig->s, key_size);
+	if (ret < 0)
+		goto free;
+
+	ret = crypto_shash_update(desc, pub->key, key_size);
+	if (ret < 0)
+		goto free;
+
+	ret = crypto_shash_finup(desc, sig->data, sig->data_size, sig->digest);
+
+free:
+	kfree(desc);
+	crypto_free_shash(tfm);
+	return ret;
+}
+
 /*
  * Verify a signature using a public key.
  */
@@ -358,11 +410,16 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (ret)
 		goto error_free_key;
 
-	if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") == 0 &&
-	    sig->data_size) {
-		ret = cert_sig_digest_update(sig, tfm);
-		if (ret)
-			goto error_free_key;
+	if (sig->pkey_algo && sig->data_size) {
+		if (strcmp(sig->pkey_algo, "sm2") == 0) {
+			ret = sm2_cert_sig_digest_update(sig, tfm);
+			if (ret)
+				goto error_free_key;
+		} else if (strcmp(sig->pkey_algo, "eddsa") == 0) {
+			ret = eddsa_cert_sig_digest_update(pkey, sig);
+			if (ret)
+				goto error_free_key;
+		}
 	}
 
 	sg_init_table(src_sg, 2);
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 6d00309..3f60c57 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -258,6 +258,9 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 	case OID_SM2_with_SM3:
 		ctx->cert->sig->hash_algo = "sm3";
 		goto sm2;
+	case OID_ed25519:
+		ctx->cert->sig->hash_algo = "sha512";
+		goto eddsa;
 	}
 
 rsa_pkcs1:
@@ -280,6 +283,11 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 	ctx->cert->sig->encoding = "x962";
 	ctx->algo_oid = ctx->last_oid;
 	return 0;
+eddsa:
+	ctx->cert->sig->pkey_algo = "eddsa";
+	ctx->cert->sig->encoding = "raw";
+	ctx->algo_oid = ctx->last_oid;
+	return 0;
 }
 
 /*
@@ -302,7 +310,8 @@ int x509_note_signature(void *context, size_t hdrlen,
 	if (strcmp(ctx->cert->sig->pkey_algo, "rsa") == 0 ||
 	    strcmp(ctx->cert->sig->pkey_algo, "ecrdsa") == 0 ||
 	    strcmp(ctx->cert->sig->pkey_algo, "sm2") == 0 ||
-	    strcmp(ctx->cert->sig->pkey_algo, "ecdsa") == 0) {
+	    strcmp(ctx->cert->sig->pkey_algo, "ecdsa") == 0 ||
+	    strcmp(ctx->cert->sig->pkey_algo, "eddsa") == 0) {
 		/* Discard the BIT STRING metadata */
 		if (vlen < 1 || *(const u8 *)value != 0)
 			return -EBADMSG;
@@ -517,6 +526,9 @@ int x509_extract_key_data(void *context, size_t hdrlen,
 			return -ENOPKG;
 		}
 		break;
+	case OID_ed25519:
+		ctx->cert->pub->pkey_algo = "eddsa-25519";
+		break;
 	default:
 		return -ENOPKG;
 	}
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 3d45161..a8fd368 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -131,7 +131,9 @@ int x509_check_for_self_signed(struct x509_certificate *cert)
 	ret = -EKEYREJECTED;
 	if (strcmp(cert->pub->pkey_algo, cert->sig->pkey_algo) != 0 &&
 	    (strncmp(cert->pub->pkey_algo, "ecdsa-", 6) != 0 ||
-	     strcmp(cert->sig->pkey_algo, "ecdsa") != 0))
+	     strcmp(cert->sig->pkey_algo, "ecdsa") != 0) &&
+	    (strncmp(cert->pub->pkey_algo, "eddsa-", 6) != 0 ||
+	     strcmp(cert->sig->pkey_algo, "eddsa") != 0))
 		goto out;
 
 	ret = public_key_verify_signature(cert->pub, cert->sig);
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index 0f4a890..ed91472 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -75,6 +75,7 @@ enum OID {
 	OID_Scram,			/* 1.3.6.1.5.5.14 */
 	OID_certAuthInfoAccess,		/* 1.3.6.1.5.5.7.1.1 */
 	OID_sha1,			/* 1.3.14.3.2.26 */
+	OID_ed25519,			/* 1.3.101.112 */
 	OID_id_ansip384r1,		/* 1.3.132.0.34 */
 	OID_sha256,			/* 2.16.840.1.101.3.4.2.1 */
 	OID_sha384,			/* 2.16.840.1.101.3.4.2.2 */
-- 
1.8.3.1

