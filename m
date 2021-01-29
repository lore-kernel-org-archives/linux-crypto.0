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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8EDC433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 21:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BE6E64E0B
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 21:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhA2V1S (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbhA2V1J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Jan 2021 16:27:09 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505DEC061574
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jan 2021 13:26:29 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id t17so7808542qtq.2
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jan 2021 13:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O+GKl9V7EjD7/v6/Gyuu4j02tEHsKDGALFwoxLjyXqw=;
        b=L9fUiGezImVtWO/GgswsywHN62utf6DIV2GjptTvsLgPz+5J2jVw9fnF29hfnr/5s8
         r7C2tt74ZySPmBSFh4cxc9PXIMKt86eK/iUQY0R6VUNY7JojFLdxTFhP2YaM6pMd5S4R
         HNrOzwF5h3wv7PttsnAj6Fhh3B7fn4xyrPYPCFL+ltqNKw4IXUWORt4xfdVePaUSTMSy
         Mj32qKyfHZxbRrD2KNPTM2ZJSOfBGxneEqkbG02F7GP4qYqs2WIkiLjTag1RrdEXtXwH
         vYY9vKLX54m0R2AISk8TtK0uo1DVhjkzROOr2ocSrNNb0oMlprNa+9+aOzzRwEkms3QA
         BJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O+GKl9V7EjD7/v6/Gyuu4j02tEHsKDGALFwoxLjyXqw=;
        b=qbAEbtVOWgGX/jC3+Hq/h0TtYIzLlKomwcVFUwp5kMHMjcddXjmUtvf1Gycbd4xaG4
         uEIap4eLvmJqwHC72DdQOkNSXVUHLRKVEeRWtAWPff5Pl51WjTjotETPRm9qzepr+pXe
         9v3c7hJuPdWmDQgRvkfex+B9tgcGuUcfcHzSECAzHdBD+Q7cGEdrGD94KS1s6xUKs4+h
         AbOLsJu+H10NC1wWo2/fEaij/bAS9EryG11DXzvLhK1phSoMLiVJAe2vYMh3kt/CXl8P
         xpXX/mo6lq8AsZo3DV1aR+mZMGKTZHAEuCndTBF5f4ef5HO0OCxj1MqcdIHnX5SBdYPR
         RZ6w==
X-Gm-Message-State: AOAM532QkYVTkjYWDj/GChI+woX3ha6gUNSNmcS5CTLIva0q7nh31jVM
        A3dxZtI+W+qdWjZ7pvO79uPhOghjyuaWQN0n
X-Google-Smtp-Source: ABdhPJyi/uxsxA29k3tZGqslHYIikpWacc88MZOXMWRoID4s3CXb0i+sLWl4tgR2o0n5dS+VDGeZGw==
X-Received: by 2002:ac8:5d0d:: with SMTP id f13mr5959975qtx.317.1611955588142;
        Fri, 29 Jan 2021 13:26:28 -0800 (PST)
Received: from warrior-desktop.domains. ([189.61.66.20])
        by smtp.gmail.com with ESMTPSA id b194sm6763995qkc.102.2021.01.29.13.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:26:27 -0800 (PST)
From:   Saulo Alessandre <saulo.alessandre@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Saulo Alessandre <saulo.alessandre@tse.jus.br>
Subject: [PATCH v2 1/4] ecdsa: add params to ecdsa algo
Date:   Fri, 29 Jan 2021 18:25:32 -0300
Message-Id: <20210129212535.2257493-2-saulo.alessandre@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129212535.2257493-1-saulo.alessandre@gmail.com>
References: <20210129212535.2257493-1-saulo.alessandre@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Saulo Alessandre <saulo.alessandre@tse.jus.br>

* crypto/ecc_curve_defs.h
 - nist_p384_(x,y,p,n,z,b) and nist_p384 added curve params added;
 - nist_p521_(x,y,p,n,z,b) and nist_p521 added curve params added;

* include/crypto/ecdh.h
  - ECC_CURVE_NIST_P384, ECC_CURVE_NIST_P521 - added new curves

* lib/oid_registry.c
  - lookup_oid_sign_info - added to return sign algo name;
  - lookup_oid_digest_info - added to return hash algo name, len and
  generic OID

* include/linux/oid_registry.h
  - OID_undef - added to reflect a zeroed structure as undefined
  - OID_id_secp(192r1,256r1), OID_id_ecdsa_with_sha(256,384,512),
    OID_id_secp(384r1,521r1) - added oid types for ecdsa algo;
  - lookup_oid_sign_info, lookup_oid_digest_info - added to get hash,
  sig info;
---
 crypto/ecc_curve_defs.h      |  82 ++++++++++++++++++++++++++++
 include/crypto/ecdh.h        |   2 +
 include/linux/oid_registry.h |  12 +++++
 lib/oid_registry.c           | 100 +++++++++++++++++++++++++++++++++++
 4 files changed, 196 insertions(+)

diff --git a/crypto/ecc_curve_defs.h b/crypto/ecc_curve_defs.h
index 69be6c7d228f..3d97761021b7 100644
--- a/crypto/ecc_curve_defs.h
+++ b/crypto/ecc_curve_defs.h
@@ -54,4 +54,86 @@ static struct ecc_curve nist_p256 = {
 	.b = nist_p256_b
 };
 
+/* NIST P-384 */
+static u64 nist_p384_g_x[] = { 0x3A545E3872760AB7ull, 0x5502F25DBF55296Cull,
+				0x59F741E082542A38ull, 0x6E1D3B628BA79B98ull,
+				0x8Eb1C71EF320AD74ull, 0xAA87CA22BE8B0537ull };
+static u64 nist_p384_g_y[] = { 0x7A431D7C90EA0E5Full, 0x0A60B1CE1D7E819Dull,
+				0xE9DA3113B5F0B8C0ull, 0xF8F41DBD289A147Cull,
+				0x5D9E98BF9292DC29ull, 0x3617DE4A96262C6Full };
+static u64 nist_p384_p[] = { 0x00000000FFFFFFFFull, 0xFFFFFFFF00000000ull,
+				0xFFFFFFFFFFFFFFFEull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull };
+static u64 nist_p384_n[] = { 0xECEC196ACCC52973ull, 0x581A0DB248B0A77Aull,
+				0xC7634D81F4372DDFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull };
+static u64 nist_p384_a[] = { 0x00000000FFFFFFFCull, 0xFFFFFFFF00000000ull,
+				0xFFFFFFFFFFFFFFFEull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull };
+static u64 nist_p384_b[] = { 0x2a85c8edd3ec2aefull, 0xc656398d8a2ed19dull,
+				0x0314088f5013875aull, 0x181d9c6efe814112ull,
+				0x988e056be3f82d19ull, 0xb3312fa7e23ee7e4ull };
+static struct ecc_curve nist_p384 = {
+	.name = "nist_384",
+	.g = {
+		.x = nist_p384_g_x,
+		.y = nist_p384_g_y,
+		.ndigits = 6,
+	},
+	.p = nist_p384_p,
+	.n = nist_p384_n,
+	.a = nist_p384_a,
+	.b = nist_p384_b
+};
+
+/* NIST P-521 */
+static u64 nist_p521_g_x[] = { 0xF97E7E31C2E5BD66ull, 0x3348B3C1856A429Bull,
+				0xFE1DC127A2FFA8DEull, 0xA14B5E77EFE75928ull,
+				0xF828AF606B4D3DBAull, 0x9C648139053FB521ull,
+				0x9E3ECB662395B442ull, 0x858E06B70404E9CDull,
+				0x00000000000000C6ull };
+static u64 nist_p521_g_y[] = { 0x88BE94769FD16650ull, 0x353C7086A272C240ull,
+				0xC550B9013FAD0761ull, 0x97EE72995EF42640ull,
+				0x17AFBD17273E662Cull, 0x98F54449579B4468ull,
+				0x5C8A5FB42C7D1BD9ull, 0x39296A789A3BC004ull,
+				0x0000000000000118ull };
+static u64 nist_p521_p[] = { 0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0x00000000000001FFull };
+static u64 nist_p521_n[] = { 0xBB6FB71E91386409ull, 0x3BB5C9B8899C47AEull,
+				0x7FCC0148F709A5D0ull, 0x51868783BF2F966Bull,
+				0xFFFFFFFFFFFFFFFAull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0x00000000000001FFull };
+static u64 nist_p521_a[] = { 0xFFFFFFFFFFFFFFFCull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFFull,
+				0x00000000000001FFull };
+static u64 nist_p521_b[] = { 0xEF451FD46B503F00ull, 0x3573DF883D2C34F1ull,
+				0x1652C0BD3BB1BF07ull, 0x56193951EC7E937Bull,
+				0xB8B489918EF109E1ull, 0xA2DA725B99B315F3ull,
+				0x929A21A0B68540EEull, 0x953EB9618E1C9A1Full,
+				0x0000000000000051ull };
+
+static struct ecc_curve nist_p521 = {
+	.name = "nist_521",
+	.g = {
+		.x = nist_p521_g_x,
+		.y = nist_p521_g_y,
+		.ndigits = 9,
+	},
+	.p = nist_p521_p,
+	.n = nist_p521_n,
+	.a = nist_p521_a,
+	.b = nist_p521_b
+};
+
+#define NIST_UNPACKED_KEY_ID 0x04
+#define NISTP256_PACKED_KEY_SIZE 64
+#define NISTP384_PACKED_KEY_SIZE 96
+#define NISTP521_PACKED_KEY_SIZE 132
+
 #endif
diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index a5b805b5526d..6c7333f82b9c 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -25,6 +25,8 @@
 /* Curves IDs */
 #define ECC_CURVE_NIST_P192	0x0001
 #define ECC_CURVE_NIST_P256	0x0002
+#define ECC_CURVE_NIST_P384	0x0003
+#define ECC_CURVE_NIST_P521	0x0004
 
 /**
  * struct ecdh - define an ECDH private key
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index 4462ed2c18cd..7871c574b56a 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -17,9 +17,15 @@
  *	  build_OID_registry.pl to generate the data for look_up_OID().
  */
 enum OID {
+	OID__undef,		/* 1.0 */
 	OID_id_dsa_with_sha1,		/* 1.2.840.10030.4.3 */
 	OID_id_dsa,			/* 1.2.840.10040.4.1 */
+	OID_id_secp192r1,	/* 1.2.840.10045.3.1.1 */
+	OID_id_secp256r1,	/* 1.2.840.10045.3.1.7 */
 	OID_id_ecdsa_with_sha1,		/* 1.2.840.10045.4.1 */
+	OID_id_ecdsa_with_sha256,		/* 1.2.840.10045.4.3.2 */
+	OID_id_ecdsa_with_sha384,		/* 1.2.840.10045.4.3.3 */
+	OID_id_ecdsa_with_sha512,		/* 1.2.840.10045.4.3.4 */
 	OID_id_ecPublicKey,		/* 1.2.840.10045.2.1 */
 
 	/* PKCS#1 {iso(1) member-body(2) us(840) rsadsi(113549) pkcs(1) pkcs-1(1)} */
@@ -58,6 +64,8 @@ enum OID {
 
 	OID_certAuthInfoAccess,		/* 1.3.6.1.5.5.7.1.1 */
 	OID_sha1,			/* 1.3.14.3.2.26 */
+	OID_id_secp384r1,		/* 1.3.132.0.34 */
+	OID_id_secp521r1,		/* 1.3.132.0.35 */
 	OID_sha256,			/* 2.16.840.1.101.3.4.2.1 */
 	OID_sha384,			/* 2.16.840.1.101.3.4.2.2 */
 	OID_sha512,			/* 2.16.840.1.101.3.4.2.3 */
@@ -119,5 +127,9 @@ enum OID {
 extern enum OID look_up_OID(const void *data, size_t datasize);
 extern int sprint_oid(const void *, size_t, char *, size_t);
 extern int sprint_OID(enum OID, char *, size_t);
+extern int lookup_oid_sign_info(enum OID oid,
+		const char **sign_algo);
+extern int lookup_oid_digest_info(enum OID oid,
+		const char **hash_algo, u32 *hash_len, enum OID *oid_algo);
 
 #endif /* _LINUX_OID_REGISTRY_H */
diff --git a/lib/oid_registry.c b/lib/oid_registry.c
index f7ad43f28579..aea941dd93ba 100644
--- a/lib/oid_registry.c
+++ b/lib/oid_registry.c
@@ -92,6 +92,106 @@ enum OID look_up_OID(const void *data, size_t datasize)
 }
 EXPORT_SYMBOL_GPL(look_up_OID);
 
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wswitch"
+int lookup_oid_sign_info(enum OID oid, const char **sign_algo)
+{
+	int ret = -1;
+
+	if (sign_algo) {
+		switch (oid) {
+		case OID_md4WithRSAEncryption:
+		case OID_sha1WithRSAEncryption:
+		case OID_sha256WithRSAEncryption:
+		case OID_sha384WithRSAEncryption:
+		case OID_sha512WithRSAEncryption:
+		case OID_sha224WithRSAEncryption:
+			if (sign_algo)
+				*sign_algo = "rsa";
+			ret = 0;
+			break;
+		case OID_id_ecdsa_with_sha1:
+		case OID_id_ecdsa_with_sha256:
+		case OID_id_ecdsa_with_sha384:
+		case OID_id_ecdsa_with_sha512:
+			if (sign_algo)
+				*sign_algo = "ecdsa";
+			ret = 0;
+			break;
+		}
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lookup_oid_sign_info);
+
+int lookup_oid_digest_info(enum OID oid,
+			   const char **digest_algo, u32 *digest_len,
+			   enum OID *digest_oid)
+{
+	int ret = 0;
+
+	switch (oid) {
+	case OID_md4WithRSAEncryption:
+		if (digest_algo)
+			*digest_algo = "md4";
+		if (digest_oid)
+			*digest_oid = OID_md4;
+		if (digest_len)
+			*digest_len = 16;
+		break;
+	case OID_sha1WithRSAEncryption:
+	case OID_id_ecdsa_with_sha1:
+		if (digest_algo)
+			*digest_algo = "sha1";
+		if (digest_oid)
+			*digest_oid = OID_sha1;
+		if (digest_len)
+			*digest_len = 20;
+		break;
+	case OID_sha224WithRSAEncryption:
+		if (digest_algo)
+			*digest_algo = "sha224";
+		if (digest_oid)
+			*digest_oid = OID_sha224;
+		if (digest_len)
+			*digest_len = 28;
+		break;
+	case OID_sha256WithRSAEncryption:
+	case OID_id_ecdsa_with_sha256:
+		if (digest_algo)
+			*digest_algo = "sha256";
+		if (digest_oid)
+			*digest_oid = OID_sha256;
+		if (digest_len)
+			*digest_len = 32;
+		break;
+	case OID_sha384WithRSAEncryption:
+	case OID_id_ecdsa_with_sha384:
+		if (digest_algo)
+			*digest_algo = "sha384";
+		if (digest_oid)
+			*digest_oid = OID_sha384;
+		if (digest_len)
+			*digest_len = 48;
+		break;
+	case OID_sha512WithRSAEncryption:
+	case OID_id_ecdsa_with_sha512:
+		if (digest_algo)
+			*digest_algo = "sha512";
+		if (digest_oid)
+			*digest_oid = OID_sha512;
+		if (digest_len)
+			*digest_len = 64;
+		break;
+	default:
+		ret = -1;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lookup_oid_digest_info);
+
+#pragma GCC diagnostic pop
+
 /*
  * sprint_OID - Print an Object Identifier into a buffer
  * @data: The encoded OID to print
-- 
2.25.1

