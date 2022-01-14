Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF65C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jan 2022 00:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbiANAax (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jan 2022 19:30:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40034 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiANAaw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jan 2022 19:30:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F24161D50;
        Fri, 14 Jan 2022 00:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBC9C36AEF;
        Fri, 14 Jan 2022 00:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642120251;
        bh=31ObngJIWRlK96KNN1SCehwf7gev5VKl+XnN67ihKiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pt7yE0iVvBipSScUJ96hfSjYvqCvkagbShfokre5nz43pdtdnR+HQ8QP5MZyU+kTI
         aHjwD0n87S2Pq3jsVS9o2Wx5gI1QrpHlNpSKjV4f0wnKBaeVG0oNKnIKfKmQQClasN
         OTybyqzbMbG3fClmNwWkLmOqfTYx+UxPq64nFtjDPRt5Iala+0vGiMQ1TI1XirFcDr
         00vYtBi4F1odQkzgQ+bbUdFYJrQl2vAEFQ087MUEeHE9r69QeV6aACCsr9vNPjbWZV
         LEDV47zxAkzW8iW0svEC/mJNHeamgA6YZIgv6XbaIGkNWTI7y9SgOxKIUAZvC+lYRz
         Qpvjurj5GMipw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 1/4] KEYS: x509: clearly distinguish between key and signature algorithms
Date:   Thu, 13 Jan 2022 16:29:17 -0800
Message-Id: <20220114002920.103858-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114002920.103858-1-ebiggers@kernel.org>
References: <20220114002920.103858-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

An X.509 certificate has two, potentially different public key
algorithms: the one used by the certificate's key, and the one that was
used to sign the certificate.  Some of the naming made it unclear which
algorithm was meant.  Rename things appropriately:

    - x509_note_pkey_algo() => x509_note_sig_algo()
    - algo_oid => sig_algo

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/x509.asn1          |  2 +-
 crypto/asymmetric_keys/x509_cert_parser.c | 32 +++++++++++++----------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/crypto/asymmetric_keys/x509.asn1 b/crypto/asymmetric_keys/x509.asn1
index 5c9f4e4a5231..92d59c32f96a 100644
--- a/crypto/asymmetric_keys/x509.asn1
+++ b/crypto/asymmetric_keys/x509.asn1
@@ -7,7 +7,7 @@ Certificate ::= SEQUENCE {
 TBSCertificate ::= SEQUENCE {
 	version           [ 0 ]	Version DEFAULT,
 	serialNumber		CertificateSerialNumber ({ x509_note_serial }),
-	signature		AlgorithmIdentifier ({ x509_note_pkey_algo }),
+	signature		AlgorithmIdentifier ({ x509_note_sig_algo }),
 	issuer			Name ({ x509_note_issuer }),
 	validity		Validity,
 	subject			Name ({ x509_note_subject }),
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 083405eb80c3..aec2396a7f7e 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -24,9 +24,9 @@ struct x509_parse_context {
 	size_t		key_size;		/* Size of key data */
 	const void	*params;		/* Key parameters */
 	size_t		params_size;		/* Size of key parameters */
-	enum OID	key_algo;		/* Public key algorithm */
+	enum OID	key_algo;		/* Algorithm used by the cert's key */
 	enum OID	last_oid;		/* Last OID encountered */
-	enum OID	algo_oid;		/* Algorithm OID */
+	enum OID	sig_algo;		/* Algorithm used to sign the cert */
 	unsigned char	nr_mpi;			/* Number of MPIs stored */
 	u8		o_size;			/* Size of organizationName (O) */
 	u8		cn_size;		/* Size of commonName (CN) */
@@ -187,11 +187,10 @@ int x509_note_tbs_certificate(void *context, size_t hdrlen,
 }
 
 /*
- * Record the public key algorithm
+ * Record the algorithm that was used to sign this certificate.
  */
-int x509_note_pkey_algo(void *context, size_t hdrlen,
-			unsigned char tag,
-			const void *value, size_t vlen)
+int x509_note_sig_algo(void *context, size_t hdrlen, unsigned char tag,
+		       const void *value, size_t vlen)
 {
 	struct x509_parse_context *ctx = context;
 
@@ -263,22 +262,22 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 rsa_pkcs1:
 	ctx->cert->sig->pkey_algo = "rsa";
 	ctx->cert->sig->encoding = "pkcs1";
-	ctx->algo_oid = ctx->last_oid;
+	ctx->sig_algo = ctx->last_oid;
 	return 0;
 ecrdsa:
 	ctx->cert->sig->pkey_algo = "ecrdsa";
 	ctx->cert->sig->encoding = "raw";
-	ctx->algo_oid = ctx->last_oid;
+	ctx->sig_algo = ctx->last_oid;
 	return 0;
 sm2:
 	ctx->cert->sig->pkey_algo = "sm2";
 	ctx->cert->sig->encoding = "raw";
-	ctx->algo_oid = ctx->last_oid;
+	ctx->sig_algo = ctx->last_oid;
 	return 0;
 ecdsa:
 	ctx->cert->sig->pkey_algo = "ecdsa";
 	ctx->cert->sig->encoding = "x962";
-	ctx->algo_oid = ctx->last_oid;
+	ctx->sig_algo = ctx->last_oid;
 	return 0;
 }
 
@@ -291,11 +290,16 @@ int x509_note_signature(void *context, size_t hdrlen,
 {
 	struct x509_parse_context *ctx = context;
 
-	pr_debug("Signature type: %u size %zu\n", ctx->last_oid, vlen);
+	pr_debug("Signature: alg=%u, size=%zu\n", ctx->last_oid, vlen);
 
-	if (ctx->last_oid != ctx->algo_oid) {
-		pr_warn("Got cert with pkey (%u) and sig (%u) algorithm OIDs\n",
-			ctx->algo_oid, ctx->last_oid);
+	/*
+	 * In X.509 certificates, the signature's algorithm is stored in two
+	 * places: inside the TBSCertificate (the data that is signed), and
+	 * alongside the signature.  These *must* match.
+	 */
+	if (ctx->last_oid != ctx->sig_algo) {
+		pr_warn("signatureAlgorithm (%u) differs from tbsCertificate.signature (%u)\n",
+			ctx->last_oid, ctx->sig_algo);
 		return -EINVAL;
 	}
 
-- 
2.34.1

