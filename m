Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F12C433E9
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 21:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F238564E0B
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 21:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbhA2V1U (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbhA2V1M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Jan 2021 16:27:12 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1FFC06174A
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jan 2021 13:26:32 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id n15so10204973qkh.8
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jan 2021 13:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M0ubs7pUNZxPzkda/rjhGWjfmmaFMt2B1S5B/WNfUYA=;
        b=mx1SHErJ88x4BFNB332q+AifKDDTbx2exvNhkin8mNe6Xx+M3BO14fu9V8SRRd9aDa
         Id18zvWEn+L+63J41vxryK0GXYIxUn4kE19/FmTZtB16m/lbpvPfinIRrWc+VS7JAO10
         /SQj5rYaDIrbrmCzzx0yvEHw1dqoiR4ULMdWo0Ie0s6qfmJAmDF+769PSTTRSIUyFcKr
         bABcJbfGwVSdRqfN7cEVIOXS3/L47MrNFayCcbWMLT9kcZuJOidWTpuICBhZ3F9Xvde1
         JY1YIY/QTrLNIODOQFSGE8WoOy39ZVCx2PAflEBTyNfNIbxZgJ445DdzjIfMpiC8QSDZ
         2IUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M0ubs7pUNZxPzkda/rjhGWjfmmaFMt2B1S5B/WNfUYA=;
        b=dSDPlQeMkgi9FkY+Eo1ZHxUvZRcwmeHwU0SsXoFB8++Kf4ux4Sn6/gF4HlL87HGyA+
         1k3GuobIAMxwfuM02JUk6pxXnbHOvRUNcPFtL9hYaLK5U27X3QFJ+N0GfDxmV7/AMQe1
         GHeBA9dG+ZWGlJo5Iz2TSMeakChisfK7eYnrlL7/wDn5Tmipm0OvYabNWsq5VOmj93R2
         5HF/u6mFXuISs+UklubxMiTrds5+/iRYXpmWoxrBgf2vSQNVkSpRAOSUcR99oC0W5r3N
         PrkhYDRmVuWPsDLG1KZNZQFfZ/akeDCbL5gX0nXuoRbQAN9M/afoo5szdfImdLHX2tI5
         fBAA==
X-Gm-Message-State: AOAM532B8W5M9QE2jFwV0xN/loKDxTjyFjUoCtJ/RKb6Pq8CappLXhAu
        Bhl9IL7Ql4kLLLy+DgymAiTYgCT2VgNWgl6f
X-Google-Smtp-Source: ABdhPJyUZoml5rjT8g/3/pQcJArsovnNYfsAAcY+dEg6tLx6MsGASkGCwxDoEbr+jwAlEHJsnzgWDQ==
X-Received: by 2002:a37:d03:: with SMTP id 3mr6178831qkn.45.1611955591182;
        Fri, 29 Jan 2021 13:26:31 -0800 (PST)
Received: from warrior-desktop.domains. ([189.61.66.20])
        by smtp.gmail.com with ESMTPSA id b194sm6763995qkc.102.2021.01.29.13.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:26:30 -0800 (PST)
From:   Saulo Alessandre <saulo.alessandre@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Saulo Alessandre <saulo.alessandre@tse.jus.br>
Subject: [PATCH v2 2/4] ecdsa: prepare akcipher and x509 parser to use incoming ecdsa
Date:   Fri, 29 Jan 2021 18:25:33 -0300
Message-Id: <20210129212535.2257493-3-saulo.alessandre@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129212535.2257493-1-saulo.alessandre@gmail.com>
References: <20210129212535.2257493-1-saulo.alessandre@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Saulo Alessandre <saulo.alessandre@tse.jus.br>

* crypto/asymmetric_keys/pkcs7_parser.c
  - pkcs7_sig_note_pkey_algo - changed to recognize OID_id_ecdsa_with_sha(1,256,384,512).

* crypto/asymmetric_keys/pkcs7_verify.c
  - pkcs7_digest - added warning when the summary has an unsupported algorithm, to avoid let others waste time, like me.

* crypto/asymmetric_keys/public_key.c
  - software_key_determine_akcipher - modified to recognize ecdsa.

* crypto/asymmetric_keys/x509_cert_parser.c
  - x509_note_pkey_algo - changed to recognize ecdsa and to use lookup_oid_
    routines; added info about certificates found inside kernel;
  - x509_note_signature - changed to recognize ecdsa;
  - x509_extract_key_data - changed to recognize OID_id_ecPublicKey as ecdsa
---
 crypto/asymmetric_keys/pkcs7_parser.c     |  7 ++++-
 crypto/asymmetric_keys/pkcs7_verify.c     |  5 ++-
 crypto/asymmetric_keys/public_key.c       | 30 ++++++++++++------
 crypto/asymmetric_keys/x509_cert_parser.c | 37 ++++++++++++-----------
 4 files changed, 49 insertions(+), 30 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 967329e0a07b..501af4937516 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -267,12 +267,17 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
 	switch (ctx->last_oid) {
 	case OID_rsaEncryption:
 		ctx->sinfo->sig->pkey_algo = "rsa";
-		ctx->sinfo->sig->encoding = "pkcs1";
+		break;
+	case OID_id_ecdsa_with_sha256:
+	case OID_id_ecdsa_with_sha384:
+	case OID_id_ecdsa_with_sha512:
+		ctx->sinfo->sig->pkey_algo = "ecdsa";
 		break;
 	default:
 		printk("Unsupported pkey algo: %u\n", ctx->last_oid);
 		return -ENOPKG;
 	}
+	ctx->sinfo->sig->encoding = "pkcs1";
 	return 0;
 }
 
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index ce49820caa97..a963aa9ec648 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -41,8 +41,11 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 	 * big the hash operational data will be.
 	 */
 	tfm = crypto_alloc_shash(sinfo->sig->hash_algo, 0, 0);
-	if (IS_ERR(tfm))
+	if (IS_ERR(tfm)) {
+		pr_warn("%s unsupported hash_algo[%s]", __func__,
+				sinfo->sig->hash_algo);
 		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
+	}
 
 	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
 	sig->digest_size = crypto_shash_digestsize(tfm);
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 8892908ad58c..42429a10ef0b 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -70,18 +70,28 @@ int software_key_determine_akcipher(const char *encoding,
 	int n;
 
 	if (strcmp(encoding, "pkcs1") == 0) {
-		/* The data wangled by the RSA algorithm is typically padded
-		 * and encoded in some manner, such as EMSA-PKCS1-1_5 [RFC3447
-		 * sec 8.2].
-		 */
-		if (!hash_algo)
+		if (pkey->pkey_algo && strcmp(pkey->pkey_algo, "rsa") == 0) {
+			/* The data wangled by the RSA algorithm is typically padded
+			 * and encoded in some manner, such as EMSA-PKCS1-1_5 [RFC3447
+			 * sec 8.2].
+			 */
+			if (!hash_algo)
+				n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
+						"pkcs1pad(%s)",
+						pkey->pkey_algo);
+			else
+				n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
+						"pkcs1pad(%s,%s)",
+						pkey->pkey_algo, hash_algo);
+		} else if (pkey->pkey_algo &&
+					strcmp(pkey->pkey_algo, "ecdsa") == 0) {
 			n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
-				     "pkcs1pad(%s)",
-				     pkey->pkey_algo);
-		else
+					"%s(%s)", pkey->pkey_algo, hash_algo);
+		} else {
 			n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
-				     "pkcs1pad(%s,%s)",
-				     pkey->pkey_algo, hash_algo);
+					"pkcs1pad(%s,%s)",
+					pkey->pkey_algo, hash_algo);
+		}
 		return n >= CRYPTO_MAX_ALG_NAME ? -EINVAL : 0;
 	}
 
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 52c9b455fc7d..a67bdbae1055 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -197,6 +197,7 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 
 	pr_debug("PubKey Algo: %u\n", ctx->last_oid);
 
+	ctx->key_algo = ctx->last_oid;
 	switch (ctx->last_oid) {
 	case OID_md2WithRSAEncryption:
 	case OID_md3WithRSAEncryption:
@@ -204,27 +205,15 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 		return -ENOPKG; /* Unsupported combination */
 
 	case OID_md4WithRSAEncryption:
-		ctx->cert->sig->hash_algo = "md4";
-		goto rsa_pkcs1;
-
 	case OID_sha1WithRSAEncryption:
-		ctx->cert->sig->hash_algo = "sha1";
-		goto rsa_pkcs1;
-
 	case OID_sha256WithRSAEncryption:
-		ctx->cert->sig->hash_algo = "sha256";
-		goto rsa_pkcs1;
-
 	case OID_sha384WithRSAEncryption:
-		ctx->cert->sig->hash_algo = "sha384";
-		goto rsa_pkcs1;
-
 	case OID_sha512WithRSAEncryption:
-		ctx->cert->sig->hash_algo = "sha512";
-		goto rsa_pkcs1;
-
 	case OID_sha224WithRSAEncryption:
-		ctx->cert->sig->hash_algo = "sha224";
+	case OID_id_ecdsa_with_sha1:
+	case OID_id_ecdsa_with_sha256:
+	case OID_id_ecdsa_with_sha384:
+	case OID_id_ecdsa_with_sha512:
 		goto rsa_pkcs1;
 
 	case OID_gost2012Signature256:
@@ -241,9 +230,13 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 	}
 
 rsa_pkcs1:
-	ctx->cert->sig->pkey_algo = "rsa";
+	lookup_oid_sign_info(ctx->key_algo, &ctx->cert->sig->pkey_algo);
+	lookup_oid_digest_info(ctx->key_algo, &ctx->cert->sig->hash_algo,
+							NULL, NULL);
 	ctx->cert->sig->encoding = "pkcs1";
 	ctx->algo_oid = ctx->last_oid;
+	pr_info("Found %s(%s) X509 certificate\n", ctx->cert->sig->pkey_algo,
+		ctx->cert->sig->hash_algo);
 	return 0;
 ecrdsa:
 	ctx->cert->sig->pkey_algo = "ecrdsa";
@@ -275,6 +268,7 @@ int x509_note_signature(void *context, size_t hdrlen,
 	}
 
 	if (strcmp(ctx->cert->sig->pkey_algo, "rsa") == 0 ||
+	    strcmp(ctx->cert->sig->pkey_algo, "ecdsa") == 0 ||
 	    strcmp(ctx->cert->sig->pkey_algo, "ecrdsa") == 0 ||
 	    strcmp(ctx->cert->sig->pkey_algo, "sm2") == 0) {
 		/* Discard the BIT STRING metadata */
@@ -470,7 +464,14 @@ int x509_extract_key_data(void *context, size_t hdrlen,
 		ctx->cert->pub->pkey_algo = "ecrdsa";
 		break;
 	case OID_id_ecPublicKey:
-		ctx->cert->pub->pkey_algo = "sm2";
+		if (ctx->algo_oid == OID_id_ecdsa_with_sha512 ||
+			ctx->algo_oid == OID_id_ecdsa_with_sha384 ||
+			ctx->algo_oid == OID_id_ecdsa_with_sha256 ||
+			ctx->algo_oid == OID_id_ecdsa_with_sha1) {
+			ctx->cert->pub->pkey_algo = "ecdsa";
+		} else {
+			ctx->cert->pub->pkey_algo = "sm2";
+		}
 		break;
 	default:
 		return -ENOPKG;
-- 
2.25.1

