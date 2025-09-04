Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B60285404;
	Thu,  4 Sep 2025 16:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001619; cv=none; b=IsXF+GEgoRRHHGc+bqHsKZTMliYuObq5SrKQLP0Sw6fhstV3yJMZ2qGCcO4ootubwAkPYd/RVdUfQ7k77EbezIS9+8PE7GR3z1MxiLad4m140FxLqtO7Odb1kOwCw4S0KXww9TPhUxQiTNwSG1MMoJcgI3F3LZw6TNTb+zE2Bkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001619; c=relaxed/simple;
	bh=tPNVoseCnUJm+SFkgbJURggytapsSZrXHWK4qoPx5U4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MzeQBGQaN/smcb4lg0kdAfWr+Y5Jow6Cy4h3LCb8pOwuhPulaIkIy43ODQfSiZa310UgCGbr8c++iTWz7HyKYVYD8vsb8UsVxdkaowWVnHvCrHZHOXS/JzZCsiUoTMhvLD3V5kCQCvraJzzT5z9uFnmqOHxfKzp9mhcTXH5ZYow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PdSKXMQX; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PdSKXMQX"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtiTi023828;
	Thu, 4 Sep 2025 16:00:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=vDSM5
	ymDrKAzXdx2g3jB2X5dL+HwxiwE83qz5BE5MM4=; b=PdSKXMQX650mMZ0AyevEX
	O62tMsyd34tfvub/1FQG30eSoth8tXIKkzNcqALHau0QZjKXSwkI9JuI5YuYQZGr
	owcvq8By/CssMG6fai0j9phQlZjgurdgZ7LQNFypajmepAfQCsgZ6x2MdHYaKky+
	19vV2WHZ5fAr9FVtg7ktTZtEhvEdQBCH/0GV1WnrQ3t8xtyuFO6rW7cW4iIK/zzc
	mWEexgjtXCSO9ZfLXtzhqTCvSp5dqysYPQRuzIXXVBU1uGXUuF3U5/t3YFgng7f2
	z5W3O2eaVHkc5nTs6WeJHupUcp8IeSDtOU43D+yyPup7vTlRLFBcT9HoXLXcyTfZ
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd02bp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FIfl4040023;
	Thu, 4 Sep 2025 16:00:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtrbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:03 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7M000707;
	Thu, 4 Sep 2025 16:00:02 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-78;
	Thu, 04 Sep 2025 16:00:02 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH RFC 077/104] crypto: fips140: convert crypto/asymmetric_keys/asymmetric_type.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:49 +0200
Message-Id: <20250904155216.460962-78-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040157
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfXzYlSrAtmwR6D
 Axst/WamQMPyDoSMi4bCcmHBQGErw2KesP5ghYc2ropjFz0OPBpFuQ1Koj13h+CzbqA4hBXpKqS
 3D0LwUSBzAt0XrZ01beaHV0OwgndU21uuJMmoqPoqEJOmGBFf7KrcPNujR+r+AGtawhb6W5bjHA
 Sf/pffPcCltLQdbQ/3EO+UhmpL2SIgr8dS+YvmttQ7bBaXmUdny4igbYFh5vMZrIrFHZTnMmCay
 G6uLE2MlOXhCwv9YO71ch1t3s+L8AOtylg62Pe2bPt8MhvgU0+K3CKJapImd0VPXYPTkFO/+RVX
 6aEqDKIwpbfqguWHu/YXuDwQrw+yIBeR1yoq4rWc57hFrKrSqPcFjwlQY54xILR8A6nVc+CHW40
 kKbJye8DCkZ+p/6dNui4c7/Fo2CPtg==
X-Proofpoint-GUID: yI3o0DG3sjAqAsORIAqMx3tUO2BggFne
X-Proofpoint-ORIG-GUID: yI3o0DG3sjAqAsORIAqMx3tUO2BggFne
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b784 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=SSClFjmXXrTqyXdkiKcA:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_ASYMMETRIC_KEY_TYPE --source crypto/asymmetric_keys/asymmetric_type.c --header include/keys/asymmetric-parser.h include/keys/asymmetric-type.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/asymmetric_keys/asymmetric_type.c | 30 ++++++++++++------------
 crypto/fips140-api.c                     | 19 +++++++++++++++
 include/keys/asymmetric-parser.h         |  8 +++++--
 include/keys/asymmetric-type.h           | 26 ++++++++++----------
 4 files changed, 53 insertions(+), 30 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index ba2d9d1ea235..7c0a73d17eb9 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -38,7 +38,7 @@ static DECLARE_RWSEM(asymmetric_key_parsers_sem);
  * exactly.  If both are missing, id_2 must match the sought key's third
  * identifier exactly.
  */
-struct key *find_asymmetric_key(struct key *keyring,
+struct key *CRYPTO_API(find_asymmetric_key)(struct key *keyring,
 				const struct asymmetric_key_id *id_0,
 				const struct asymmetric_key_id *id_1,
 				const struct asymmetric_key_id *id_2,
@@ -124,7 +124,7 @@ struct key *find_asymmetric_key(struct key *keyring,
 	key_put(key);
 	return ERR_PTR(-EKEYREJECTED);
 }
-EXPORT_SYMBOL_GPL(find_asymmetric_key);
+DEFINE_CRYPTO_API(find_asymmetric_key);
 
 /**
  * asymmetric_key_generate_id: Construct an asymmetric key ID
@@ -135,7 +135,7 @@ EXPORT_SYMBOL_GPL(find_asymmetric_key);
  *
  * Construct an asymmetric key ID from a pair of binary blobs.
  */
-struct asymmetric_key_id *asymmetric_key_generate_id(const void *val_1,
+struct asymmetric_key_id *CRYPTO_API(asymmetric_key_generate_id)(const void *val_1,
 						     size_t len_1,
 						     const void *val_2,
 						     size_t len_2)
@@ -151,14 +151,14 @@ struct asymmetric_key_id *asymmetric_key_generate_id(const void *val_1,
 	memcpy(kid->data + len_1, val_2, len_2);
 	return kid;
 }
-EXPORT_SYMBOL_GPL(asymmetric_key_generate_id);
+DEFINE_CRYPTO_API(asymmetric_key_generate_id);
 
 /**
  * asymmetric_key_id_same - Return true if two asymmetric keys IDs are the same.
  * @kid1: The key ID to compare
  * @kid2: The key ID to compare
  */
-bool asymmetric_key_id_same(const struct asymmetric_key_id *kid1,
+bool CRYPTO_API(asymmetric_key_id_same)(const struct asymmetric_key_id *kid1,
 			    const struct asymmetric_key_id *kid2)
 {
 	if (!kid1 || !kid2)
@@ -167,7 +167,7 @@ bool asymmetric_key_id_same(const struct asymmetric_key_id *kid1,
 		return false;
 	return memcmp(kid1->data, kid2->data, kid1->len) == 0;
 }
-EXPORT_SYMBOL_GPL(asymmetric_key_id_same);
+DEFINE_CRYPTO_API(asymmetric_key_id_same);
 
 /**
  * asymmetric_key_id_partial - Return true if two asymmetric keys IDs
@@ -175,7 +175,7 @@ EXPORT_SYMBOL_GPL(asymmetric_key_id_same);
  * @kid1: The key ID to compare
  * @kid2: The key ID to compare
  */
-bool asymmetric_key_id_partial(const struct asymmetric_key_id *kid1,
+bool CRYPTO_API(asymmetric_key_id_partial)(const struct asymmetric_key_id *kid1,
 			       const struct asymmetric_key_id *kid2)
 {
 	if (!kid1 || !kid2)
@@ -185,7 +185,7 @@ bool asymmetric_key_id_partial(const struct asymmetric_key_id *kid1,
 	return memcmp(kid1->data + (kid1->len - kid2->len),
 		      kid2->data, kid2->len) == 0;
 }
-EXPORT_SYMBOL_GPL(asymmetric_key_id_partial);
+DEFINE_CRYPTO_API(asymmetric_key_id_partial);
 
 /**
  * asymmetric_match_key_ids - Search asymmetric key IDs 1 & 2
@@ -281,7 +281,7 @@ static bool asymmetric_key_cmp_name(const struct key *key,
 	const struct asymmetric_key_ids *kids = asymmetric_key_ids(key);
 	const struct asymmetric_key_id *match_id = match_data->preparsed;
 
-	return kids && asymmetric_key_id_same(kids->id[2], match_id);
+	return kids && CRYPTO_API(asymmetric_key_id_same)(kids->id[2], match_id);
 }
 
 /*
@@ -617,7 +617,7 @@ EXPORT_SYMBOL_GPL(key_type_asymmetric);
  * register_asymmetric_key_parser - Register a asymmetric key blob parser
  * @parser: The parser to register
  */
-int register_asymmetric_key_parser(struct asymmetric_key_parser *parser)
+int CRYPTO_API(register_asymmetric_key_parser)(struct asymmetric_key_parser *parser)
 {
 	struct asymmetric_key_parser *cursor;
 	int ret;
@@ -642,13 +642,13 @@ int register_asymmetric_key_parser(struct asymmetric_key_parser *parser)
 	up_write(&asymmetric_key_parsers_sem);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(register_asymmetric_key_parser);
+DEFINE_CRYPTO_API(register_asymmetric_key_parser);
 
 /**
  * unregister_asymmetric_key_parser - Unregister a asymmetric key blob parser
  * @parser: The parser to unregister
  */
-void unregister_asymmetric_key_parser(struct asymmetric_key_parser *parser)
+void CRYPTO_API(unregister_asymmetric_key_parser)(struct asymmetric_key_parser *parser)
 {
 	down_write(&asymmetric_key_parsers_sem);
 	list_del(&parser->link);
@@ -656,7 +656,7 @@ void unregister_asymmetric_key_parser(struct asymmetric_key_parser *parser)
 
 	pr_notice("Asymmetric key parser '%s' unregistered\n", parser->name);
 }
-EXPORT_SYMBOL_GPL(unregister_asymmetric_key_parser);
+DEFINE_CRYPTO_API(unregister_asymmetric_key_parser);
 
 /*
  * Module stuff
@@ -671,5 +671,5 @@ static void __exit asymmetric_key_cleanup(void)
 	unregister_key_type(&key_type_asymmetric);
 }
 
-module_init(asymmetric_key_init);
-module_exit(asymmetric_key_cleanup);
+crypto_module_init(asymmetric_key_init);
+crypto_module_exit(asymmetric_key_cleanup);
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 5599cfa963d8..81d920836e1b 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -620,3 +620,22 @@ DEFINE_CRYPTO_API_STUB(alg_test);
 
 #endif
 
+/*
+ * crypto/asymmetric_keys/asymmetric_type.c
+ */
+#if !IS_BUILTIN(CONFIG_ASYMMETRIC_KEY_TYPE)
+
+#include <keys/asymmetric-parser.h>
+
+DEFINE_CRYPTO_API_STUB(register_asymmetric_key_parser);
+DEFINE_CRYPTO_API_STUB(unregister_asymmetric_key_parser);
+
+#include <keys/asymmetric-type.h>
+
+DEFINE_CRYPTO_API_STUB(asymmetric_key_id_same);
+DEFINE_CRYPTO_API_STUB(asymmetric_key_id_partial);
+DEFINE_CRYPTO_API_STUB(asymmetric_key_generate_id);
+DEFINE_CRYPTO_API_STUB(find_asymmetric_key);
+
+#endif
+
diff --git a/include/keys/asymmetric-parser.h b/include/keys/asymmetric-parser.h
index 516a3f51179e..682c82588cee 100644
--- a/include/keys/asymmetric-parser.h
+++ b/include/keys/asymmetric-parser.h
@@ -29,7 +29,11 @@ struct asymmetric_key_parser {
 	int (*parse)(struct key_preparsed_payload *prep);
 };
 
-extern int register_asymmetric_key_parser(struct asymmetric_key_parser *);
-extern void unregister_asymmetric_key_parser(struct asymmetric_key_parser *);
+DECLARE_CRYPTO_API(register_asymmetric_key_parser, int,
+	(struct asymmetric_key_parser *parser),
+	(parser));
+DECLARE_CRYPTO_API(unregister_asymmetric_key_parser, void,
+	(struct asymmetric_key_parser *parser),
+	(parser));
 
 #endif /* _KEYS_ASYMMETRIC_PARSER_H */
diff --git a/include/keys/asymmetric-type.h b/include/keys/asymmetric-type.h
index 69a13e1e5b2e..fb7f82527978 100644
--- a/include/keys/asymmetric-type.h
+++ b/include/keys/asymmetric-type.h
@@ -10,6 +10,7 @@
 #ifndef _KEYS_ASYMMETRIC_TYPE_H
 #define _KEYS_ASYMMETRIC_TYPE_H
 
+#include <crypto/api.h>
 #include <linux/key-type.h>
 #include <linux/verification.h>
 
@@ -56,16 +57,17 @@ struct asymmetric_key_ids {
 	void		*id[3];
 };
 
-extern bool asymmetric_key_id_same(const struct asymmetric_key_id *kid1,
-				   const struct asymmetric_key_id *kid2);
+DECLARE_CRYPTO_API(asymmetric_key_id_same, bool,
+	(const struct asymmetric_key_id *kid1, const struct asymmetric_key_id *kid2),
+	(kid1, kid2));
 
-extern bool asymmetric_key_id_partial(const struct asymmetric_key_id *kid1,
-				      const struct asymmetric_key_id *kid2);
+DECLARE_CRYPTO_API(asymmetric_key_id_partial, bool,
+	(const struct asymmetric_key_id *kid1, const struct asymmetric_key_id *kid2),
+	(kid1, kid2));
 
-extern struct asymmetric_key_id *asymmetric_key_generate_id(const void *val_1,
-							    size_t len_1,
-							    const void *val_2,
-							    size_t len_2);
+DECLARE_CRYPTO_API(asymmetric_key_generate_id, struct asymmetric_key_id *,
+	(const void *val_1, size_t len_1, const void *val_2, size_t len_2),
+	(val_1, len_1, val_2, len_2));
 static inline
 const struct asymmetric_key_ids *asymmetric_key_ids(const struct key *key)
 {
@@ -78,11 +80,9 @@ const struct public_key *asymmetric_key_public_key(const struct key *key)
 	return key->payload.data[asym_crypto];
 }
 
-extern struct key *find_asymmetric_key(struct key *keyring,
-				       const struct asymmetric_key_id *id_0,
-				       const struct asymmetric_key_id *id_1,
-				       const struct asymmetric_key_id *id_2,
-				       bool partial);
+DECLARE_CRYPTO_API(find_asymmetric_key, struct key *,
+	(struct key *keyring, const struct asymmetric_key_id *id_0, const struct asymmetric_key_id *id_1, const struct asymmetric_key_id *id_2, bool partial),
+	(keyring, id_0, id_1, id_2, partial));
 
 int x509_load_certificate_list(const u8 cert_list[], const unsigned long list_size,
 			       const struct key *keyring);
-- 
2.39.3

