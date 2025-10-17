Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEB9336EC8
	for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 14:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760712299; cv=none; b=fYg/FMaom/h/VGCPuyOIlXOphVbOHg3Vsc4pIqKxLCAsWODJmGapV+cdXPZUo4liC4zbmWE3aeaPUH8SqujQqbaNig4FDkB/6BhjhzLfUJgYw6DR7TLFIxg3ZNIwkWH8wNXa0f9DWa9ZsPp67c084ty+mQIuOPUf1w1iWcnGnmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760712299; c=relaxed/simple;
	bh=RvusHb8iCMBSU7BMwlq1o6N1lbxg25PBi5W0BeXHl0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNigu0M8wkjHrRo9pOD8OBeW6GHqRBWAXu2JcGugjDDEPmgfoZnp5wSyLyB2e3mcbcubQYV2yLfO1DlhiNQVMF8WKHlr8zQCVsjHLBu9l24V0zyqe2GLY2IndNHd9bFtO8oRcPsjaTADZkoHyA1zbeBnAyVMZwzAy0GIpyxPDS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fSlNh3ca; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fSlNh3ca"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760712295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dwXTvBD4Yvz8oojCSyImVAOTuEGuJkeQWe5NSzvpamE=;
	b=fSlNh3caPtzC7Y26/ExJwrjF7APD117VtUN3CvBeEa/pRTcwmBugVrx1CqQU0yNp0V5fTd
	rr0PdoMZnKm1zDRxTaZniOH8oq28hgrhWVlH8r2Z+1KY3+3fYVBu8An435dbXvM8qNUJrg
	7BWRCe9mwvjkhnEZoT6OQFKdGXsaA9A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-147-nqmhOHySPIa0xp8IupHunQ-1; Fri,
 17 Oct 2025 10:44:51 -0400
X-MC-Unique: nqmhOHySPIa0xp8IupHunQ-1
X-Mimecast-MFC-AGG-ID: nqmhOHySPIa0xp8IupHunQ_1760712288
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F4001800673;
	Fri, 17 Oct 2025 14:44:48 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.57])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EF2041800452;
	Fri, 17 Oct 2025 14:44:44 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	linux-crypto@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 16/17] pkcs7, x509: Add ML-DSA support
Date: Fri, 17 Oct 2025 15:43:00 +0100
Message-ID: <20251017144311.817771-17-dhowells@redhat.com>
In-Reply-To: <20251017144311.817771-1-dhowells@redhat.com>
References: <20251017144311.817771-1-dhowells@redhat.com>
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
index 3cdbab3b9f50..d7c88b90a4fd 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -297,6 +297,21 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
 		ctx->sinfo->sig->pkey_algo = "ecrdsa";
 		ctx->sinfo->sig->encoding = "raw";
 		break;
+	case OID_id_ml_dsa_44:
+		ctx->sinfo->sig->pkey_algo = "ml-dsa44";
+		ctx->sinfo->sig->encoding = "raw";
+		ctx->sinfo->sig->algo_does_hash = true;
+		break;
+	case OID_id_ml_dsa_65:
+		ctx->sinfo->sig->pkey_algo = "ml-dsa65";
+		ctx->sinfo->sig->encoding = "raw";
+		ctx->sinfo->sig->algo_does_hash = true;
+		break;
+	case OID_id_ml_dsa_87:
+		ctx->sinfo->sig->pkey_algo = "ml-dsa87";
+		ctx->sinfo->sig->encoding = "raw";
+		ctx->sinfo->sig->algo_does_hash = true;
+		break;
 	default:
 		printk("Unsupported pkey algo: %u\n", ctx->last_oid);
 		return -ENOPKG;
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index e5b177c8e842..96e084668d1b 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -142,6 +142,13 @@ software_key_determine_akcipher(const struct public_key *pkey,
 		if (strcmp(hash_algo, "streebog256") != 0 &&
 		    strcmp(hash_algo, "streebog512") != 0)
 			return -EINVAL;
+	} else if (strcmp(pkey->pkey_algo, "ml-dsa44") == 0 ||
+		   strcmp(pkey->pkey_algo, "ml-dsa65") == 0 ||
+		   strcmp(pkey->pkey_algo, "ml-dsa87") == 0) {
+		if (strcmp(encoding, "raw") != 0)
+			return -EINVAL;
+		if (!hash_algo)
+			return -EINVAL;
 	} else {
 		/* Unknown public key algorithm */
 		return -ENOPKG;
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 8df3fa60a44f..6a2a77a647a5 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -257,6 +257,15 @@ int x509_note_sig_algo(void *context, size_t hdrlen, unsigned char tag,
 	case OID_gost2012Signature512:
 		ctx->cert->sig->hash_algo = "streebog512";
 		goto ecrdsa;
+	case OID_id_ml_dsa_44:
+		ctx->cert->sig->pkey_algo = "ml-dsa44";
+		goto ml_dsa;
+	case OID_id_ml_dsa_65:
+		ctx->cert->sig->pkey_algo = "ml-dsa65";
+		goto ml_dsa;
+	case OID_id_ml_dsa_87:
+		ctx->cert->sig->pkey_algo = "ml-dsa87";
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
+		ctx->cert->pub->pkey_algo = "ml-dsa44";
+		break;
+	case OID_id_ml_dsa_65:
+		ctx->cert->pub->pkey_algo = "ml-dsa65";
+		break;
+	case OID_id_ml_dsa_87:
+		ctx->cert->pub->pkey_algo = "ml-dsa87";
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
 

