Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA377286435;
	Thu,  4 Sep 2025 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001464; cv=none; b=O9qwkzroUAZJ1W0OYo7Pw83AbSzU21h8Bh1hfLd9AQTwQgqY6p5i1jhoE+cXuYX1n1lEl1i6ZjpO4zG/bE5SgAnYIOSucyggQTOZgswHk/idNbxO4FWNp9LpmqS+JBPCZYolNpyB4vkkSPopwsFJZfB6AeKxHzYGJFD2yPsNVGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001464; c=relaxed/simple;
	bh=A3ych3J4Ved+HQBqsVKdSa+sKpjLb6N30s0MFdNVU3s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ICrZfmUJIrZ23p5xt1U8PlaHAls47J8WGAzcvUR6dtVwuNK/c0Xiv7not6icm7j0p77lR4MlZFUlqHutUzChK2pCX3pSgIGQoPXBCFugiZ8EXVcnhjv3Ma+McQ0zfB1uWMqvRzNEPhBtRblsgKPpGxIKKj7uaWLCuFb7ERiOTNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=psw7gPSY; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="psw7gPSY"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtvYg027991;
	Thu, 4 Sep 2025 15:57:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=JGpbn
	tKKsCHn0HikhbA4QoiOanOmLkeS3tKqEXHK1vU=; b=psw7gPSYKlpIGKSExEEjc
	hWzr9AU57pmvpTPhg3/DyRI4wfIyNUUjLDgXlFS6padGOZxCNjkDMWswzzdkctos
	0nRlnas/+fMEzfisWKSgFY/rUWuVMf/tgavR2HYHMq7MjV//kIVgPCrHGj5njB30
	k3mYjxyZ1Ge0LZauJwoIARp5pDNVXB6WZDghGcJEEONlHJvw7lFTVUPqdkSxAIuc
	WTQezyaKN9b6k8QnvkMDHsXcRArwnLZcIwVuD1zwmpBrqeECwTdZcoZlS7aF85pZ
	hQ8N0/8hs/0tXUOeVAOgguR4MfLFPum1/jFkYjBRn3uvRivMkp0+HUVBPKvxVzY0
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ycgn0732-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584F7QoY040109;
	Thu, 4 Sep 2025 15:57:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtp0m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:27 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx68000707;
	Thu, 4 Sep 2025 15:57:26 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-41;
	Thu, 04 Sep 2025 15:57:26 +0000
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
Subject: [PATCH RFC 040/104] crypto: fips140: convert crypto/cipher.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:12 +0200
Message-Id: <20250904155216.460962-41-vegard.nossum@oracle.com>
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
 definitions=main-2509040156
X-Authority-Analysis: v=2.4 cv=evbfzppX c=1 sm=1 tr=0 ts=68b9b6e9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=LXVyHd1FUNepLQpq86gA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: 4w3_AatzmST61VGgHnKIg2NtKw-PnmLt
X-Proofpoint-ORIG-GUID: 4w3_AatzmST61VGgHnKIg2NtKw-PnmLt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0MiBTYWx0ZWRfX1XHGiKOwYm9j
 jmxqQYPSDmbQRCX1sQo/ngMpiUzdEFfXPEWaA3qzE4nCZiNc5hcQJDDmbyyWzBKhJBkPKYPoRJy
 9uOm473irMazlD5solgAiZppy86CTGGj1I4tfqLklbUu8xJmrF3A+PKOgnKT/ftJqakdqRQ+zMb
 z+TxgYuHFSc6xymdn/jwT2exCuDjG+kAvih2BagL+PCj/n34sDgLKejKfUHFyTEt4cqW2084ArJ
 iCFzRWRsfx5yTTbYvBp/AZiT2ooXDenuRebTY48d+5BVx6WcX8INP/qMtNsqoTFhc5W8DmUa7hq
 4mZ8b2Uvx3iThq8PcnK6xro9NJnn6FUVDP94vMTcPEFbaTvqhiUFcBdv4N2VVvagb4dl843ZvrM
 NohfwYHLdCumNDOwUk2rFFV3mv4rlw==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO --source crypto/cipher.c --header include/crypto/internal/cipher.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/cipher.c                  | 16 ++++++++--------
 crypto/fips140-api.c             | 14 ++++++++++++++
 include/crypto/internal/cipher.h | 20 +++++++++++++-------
 3 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/crypto/cipher.c b/crypto/cipher.c
index 1fe62bf79656..7aeb577ac388 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -39,7 +39,7 @@ static int setkey_unaligned(struct crypto_cipher *tfm, const u8 *key,
 
 }
 
-int crypto_cipher_setkey(struct crypto_cipher *tfm,
+int CRYPTO_API(crypto_cipher_setkey)(struct crypto_cipher *tfm,
 			 const u8 *key, unsigned int keylen)
 {
 	struct cipher_alg *cia = crypto_cipher_alg(tfm);
@@ -53,7 +53,7 @@ int crypto_cipher_setkey(struct crypto_cipher *tfm,
 
 	return cia->cia_setkey(crypto_cipher_tfm(tfm), key, keylen);
 }
-EXPORT_SYMBOL_NS_GPL(crypto_cipher_setkey, "CRYPTO_INTERNAL");
+DEFINE_CRYPTO_API(crypto_cipher_setkey);
 
 static inline void cipher_crypt_one(struct crypto_cipher *tfm,
 				    u8 *dst, const u8 *src, bool enc)
@@ -76,21 +76,21 @@ static inline void cipher_crypt_one(struct crypto_cipher *tfm,
 	}
 }
 
-void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
+void CRYPTO_API(crypto_cipher_encrypt_one)(struct crypto_cipher *tfm,
 			       u8 *dst, const u8 *src)
 {
 	cipher_crypt_one(tfm, dst, src, true);
 }
-EXPORT_SYMBOL_NS_GPL(crypto_cipher_encrypt_one, "CRYPTO_INTERNAL");
+DEFINE_CRYPTO_API(crypto_cipher_encrypt_one);
 
-void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
+void CRYPTO_API(crypto_cipher_decrypt_one)(struct crypto_cipher *tfm,
 			       u8 *dst, const u8 *src)
 {
 	cipher_crypt_one(tfm, dst, src, false);
 }
-EXPORT_SYMBOL_NS_GPL(crypto_cipher_decrypt_one, "CRYPTO_INTERNAL");
+DEFINE_CRYPTO_API(crypto_cipher_decrypt_one);
 
-struct crypto_cipher *crypto_clone_cipher(struct crypto_cipher *cipher)
+struct crypto_cipher *CRYPTO_API(crypto_clone_cipher)(struct crypto_cipher *cipher)
 {
 	struct crypto_tfm *tfm = crypto_cipher_tfm(cipher);
 	struct crypto_alg *alg = tfm->__crt_alg;
@@ -116,4 +116,4 @@ struct crypto_cipher *crypto_clone_cipher(struct crypto_cipher *cipher)
 
 	return ncipher;
 }
-EXPORT_SYMBOL_GPL(crypto_clone_cipher);
+DEFINE_CRYPTO_API(crypto_clone_cipher);
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index df1dfcd5cf22..c05fc645a5b6 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -313,3 +313,17 @@ DEFINE_CRYPTO_API_STUB(crypto_authenc_extractkeys);
 
 #endif
 
+/*
+ * crypto/cipher.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO)
+
+#include <crypto/internal/cipher.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_cipher_setkey);
+DEFINE_CRYPTO_API_STUB(crypto_cipher_encrypt_one);
+DEFINE_CRYPTO_API_STUB(crypto_cipher_decrypt_one);
+DEFINE_CRYPTO_API_STUB(crypto_clone_cipher);
+
+#endif
+
diff --git a/include/crypto/internal/cipher.h b/include/crypto/internal/cipher.h
index 5030f6d2df31..13c48b20879c 100644
--- a/include/crypto/internal/cipher.h
+++ b/include/crypto/internal/cipher.h
@@ -11,6 +11,7 @@
 #ifndef _CRYPTO_INTERNAL_CIPHER_H
 #define _CRYPTO_INTERNAL_CIPHER_H
 
+#include <crypto/api.h>
 #include <crypto/algapi.h>
 
 struct crypto_cipher {
@@ -149,8 +150,9 @@ static inline void crypto_cipher_clear_flags(struct crypto_cipher *tfm,
  *
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
-int crypto_cipher_setkey(struct crypto_cipher *tfm,
-			 const u8 *key, unsigned int keylen);
+DECLARE_CRYPTO_API(crypto_cipher_setkey, int,
+	(struct crypto_cipher *tfm, const u8 *key, unsigned int keylen),
+	(tfm, key, keylen));
 
 /**
  * crypto_cipher_encrypt_one() - encrypt one block of plaintext
@@ -161,8 +163,9 @@ int crypto_cipher_setkey(struct crypto_cipher *tfm,
  * Invoke the encryption operation of one block. The caller must ensure that
  * the plaintext and ciphertext buffers are at least one block in size.
  */
-void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
-			       u8 *dst, const u8 *src);
+DECLARE_CRYPTO_API(crypto_cipher_encrypt_one, void,
+	(struct crypto_cipher *tfm, u8 *dst, const u8 *src),
+	(tfm, dst, src));
 
 /**
  * crypto_cipher_decrypt_one() - decrypt one block of ciphertext
@@ -173,10 +176,13 @@ void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
  * Invoke the decryption operation of one block. The caller must ensure that
  * the plaintext and ciphertext buffers are at least one block in size.
  */
-void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
-			       u8 *dst, const u8 *src);
+DECLARE_CRYPTO_API(crypto_cipher_decrypt_one, void,
+	(struct crypto_cipher *tfm, u8 *dst, const u8 *src),
+	(tfm, dst, src));
 
-struct crypto_cipher *crypto_clone_cipher(struct crypto_cipher *cipher);
+DECLARE_CRYPTO_API(crypto_clone_cipher, struct crypto_cipher *,
+	(struct crypto_cipher *cipher),
+	(cipher));
 
 struct crypto_cipher_spawn {
 	struct crypto_spawn base;
-- 
2.39.3

