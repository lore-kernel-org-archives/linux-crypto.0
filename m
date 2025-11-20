Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F2932E13E
	for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 10:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763635535; cv=none; b=B73Wp5z8lNBHX8bfQzWgHNiPu/JJtWVY/80fOmwIUr5HlcXnkF+2tmeqg1X9S+yt9jI4TiEnuvN6Vcu7g/gHhAJrky5eQlHWiUobhsctkjeF0Ah/e66XB3MmhozsrqhC0k29njF3m+5OXtZ5scQm0NSJY1KsS0AC8ebXCxij5Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763635535; c=relaxed/simple;
	bh=zeXydqlp12ltKR1XwuYGS62RBEPwV4kgQtRgD0XdwUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTVDWaZRPi2FKq6G4KVOZ4tcxTkqUteVkc6034mlXYMKa/XPtf78nTt/gHljsbAqyzTfH8D8lPDgg84vcmgqt5XgxnyqULeJhJXYKbiRIvCbI4xzwg9+oDGc5wephiynJWzEbS/d2d/ZBxrWzCK/ckS+8UKo4k2w8zsxaUreWg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DG+q41kt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DG+q41kt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763635531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSZ+c2yO1Yv6DnULPBViIMfprslEn1tX4m8x3Z6qv4E=;
	b=DG+q41ktzkj5/ghvEk2NfLDmFwctB+2eV3U5JNhKvMg4sUlCEdzLj0dNQcn7kT5DCiDWiP
	GHAh8fldD7TsFB9yN3Ot2VT1cyq6Fk709VHR4+jxjufKfxo472YCrSDAfJmMldG1b92jOy
	qxMPhLLxvn7yc2RbbBxXqkRB3MOd8PY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-jp5xbV56NbWsJpNQWELRww-1; Thu,
 20 Nov 2025 05:45:28 -0500
X-MC-Unique: jp5xbV56NbWsJpNQWELRww-1
X-Mimecast-MFC-AGG-ID: jp5xbV56NbWsJpNQWELRww_1763635526
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 124E91801323;
	Thu, 20 Nov 2025 10:45:26 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BEACA1800965;
	Thu, 20 Nov 2025 10:45:21 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Stephan Mueller <smueller@chronox.de>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>,
	linux-crypto@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 7/8] pkcs7, x509: Add ML-DSA support
Date: Thu, 20 Nov 2025 10:44:34 +0000
Message-ID: <20251120104439.2620205-8-dhowells@redhat.com>
In-Reply-To: <20251120104439.2620205-1-dhowells@redhat.com>
References: <20251120104439.2620205-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Add support for ML-DSA keys and signatures to the PKCS#7 and X.509
implementations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Lukas Wunner <lukas@wunner.de>
cc: Ignat Korchagin <ignat@cloudflare.com>
cc: Stephan Mueller <smueller@chronox.de>
cc: Eric Biggers <ebiggers@kernel.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: keyrings@vger.kernel.org
cc: linux-crypto@vger.kernel.org
---
 crypto/asymmetric_keys/pkcs7_parser.c     | 15 ++++++++++++++
 crypto/asymmetric_keys/public_key.c       |  7 +++++++
 crypto/asymmetric_keys/x509_cert_parser.c | 24 +++++++++++++++++++++++
 include/linux/oid_registry.h              |  5 +++++
 4 files changed, 51 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 3cdbab3b9f50..90c36fe1b5ed 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -297,6 +297,21 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
 		ctx->sinfo->sig->pkey_algo = "ecrdsa";
 		ctx->sinfo->sig->encoding = "raw";
 		break;
+	case OID_id_ml_dsa_44:
+		ctx->sinfo->sig->pkey_algo = "mldsa44";
+		ctx->sinfo->sig->encoding = "raw";
+		ctx->sinfo->sig->algo_does_hash = true;
+		break;
+	case OID_id_ml_dsa_65:
+		ctx->sinfo->sig->pkey_algo = "mldsa65";
+		ctx->sinfo->sig->encoding = "raw";
+		ctx->sinfo->sig->algo_does_hash = true;
+		break;
+	case OID_id_ml_dsa_87:
+		ctx->sinfo->sig->pkey_algo = "mldsa87";
+		ctx->sinfo->sig->encoding = "raw";
+		ctx->sinfo->sig->algo_does_hash = true;
+		break;
 	default:
 		printk("Unsupported pkey algo: %u\n", ctx->last_oid);
 		return -ENOPKG;
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index e5b177c8e842..ed6b4b5ae4ef 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -142,6 +142,13 @@ software_key_determine_akcipher(const struct public_key *pkey,
 		if (strcmp(hash_algo, "streebog256") != 0 &&
 		    strcmp(hash_algo, "streebog512") != 0)
 			return -EINVAL;
+	} else if (strcmp(pkey->pkey_algo, "mldsa44") == 0 ||
+		   strcmp(pkey->pkey_algo, "mldsa65") == 0 ||
+		   strcmp(pkey->pkey_algo, "mldsa87") == 0) {
+		if (strcmp(encoding, "raw") != 0)
+			return -EINVAL;
+		if (!hash_algo)
+			return -EINVAL;
 	} else {
 		/* Unknown public key algorithm */
 		return -ENOPKG;
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 8df3fa60a44f..d14584eca452 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -257,6 +257,15 @@ int x509_note_sig_algo(void *context, size_t hdrlen, unsigned char tag,
 	case OID_gost2012Signature512:
 		ctx->cert->sig->hash_algo = "streebog512";
 		goto ecrdsa;
+	case OID_id_ml_dsa_44:
+		ctx->cert->sig->pkey_algo = "mldsa44";
+		goto ml_dsa;
+	case OID_id_ml_dsa_65:
+		ctx->cert->sig->pkey_algo = "mldsa65";
+		goto ml_dsa;
+	case OID_id_ml_dsa_87:
+		ctx->cert->sig->pkey_algo = "mldsa87";
+		goto ml_dsa;
 	}
 
 rsa_pkcs1:
@@ -274,6 +283,12 @@ int x509_note_sig_algo(void *context, size_t hdrlen, unsigned char tag,
 	ctx->cert->sig->encoding = "x962";
 	ctx->sig_algo = ctx->last_oid;
 	return 0;
+ml_dsa:
+	ctx->cert->sig->algo_does_hash = true;
+	ctx->cert->sig->hash_algo = ctx->cert->sig->pkey_algo;
+	ctx->cert->sig->encoding = "raw";
+	ctx->sig_algo = ctx->last_oid;
+	return 0;
 }
 
 /*
@@ -524,6 +539,15 @@ int x509_extract_key_data(void *context, size_t hdrlen,
 			return -ENOPKG;
 		}
 		break;
+	case OID_id_ml_dsa_44:
+		ctx->cert->pub->pkey_algo = "mldsa44";
+		break;
+	case OID_id_ml_dsa_65:
+		ctx->cert->pub->pkey_algo = "mldsa65";
+		break;
+	case OID_id_ml_dsa_87:
+		ctx->cert->pub->pkey_algo = "mldsa87";
+		break;
 	default:
 		return -ENOPKG;
 	}
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index 6de479ebbe5d..30821a6a4f72 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -145,6 +145,11 @@ enum OID {
 	OID_id_rsassa_pkcs1_v1_5_with_sha3_384, /* 2.16.840.1.101.3.4.3.15 */
 	OID_id_rsassa_pkcs1_v1_5_with_sha3_512, /* 2.16.840.1.101.3.4.3.16 */
 
+	/* NIST FIPS-204 ML-DSA (Dilithium) */
+	OID_id_ml_dsa_44,			/* 2.16.840.1.101.3.4.3.17 */
+	OID_id_ml_dsa_65,			/* 2.16.840.1.101.3.4.3.18 */
+	OID_id_ml_dsa_87,			/* 2.16.840.1.101.3.4.3.19 */
+
 	OID__NR
 };
 

