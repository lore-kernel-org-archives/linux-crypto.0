From: jang@linux.vnet.ibm.com
Subject: [PATCH 1/8] s390: extend crypto facility check
Date: Tue, 19 Apr 2011 21:29:14 +0200
Message-ID: <20110419193246.730721818@linux.vnet.ibm.com>
References: <20110419192913.888086020@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:33674 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1DSTeA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2011 15:34:00 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate3.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p3JJXvAw031943
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 19:33:57 GMT
Received: from d06av06.portsmouth.uk.ibm.com (d06av06.portsmouth.uk.ibm.com [9.149.37.217])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3JJYr8j1789958
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 20:34:53 +0100
Received: from d06av06.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av06.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3JJXuKR022176
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 13:33:57 -0600
Content-Disposition: inline; filename=crypto-stfle.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jan Glauber <jang@linux.vnet.ibm.com>

The specification which crypto facility is required for an algorithm is added
as a parameter to the availability check which is done before an algorithm is
registered. With this change it is easier to add new algorithms that require
different facilities.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/crypto/aes_s390.c    |    6 +++---
 arch/s390/crypto/crypt_s390.h  |   14 +++++++++++---
 arch/s390/crypto/des_s390.c    |    4 ++--
 arch/s390/crypto/prng.c        |    2 +-
 arch/s390/crypto/sha1_s390.c   |    2 +-
 arch/s390/crypto/sha256_s390.c |    2 +-
 arch/s390/crypto/sha512_s390.c |    2 +-
 7 files changed, 20 insertions(+), 12 deletions(-)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -508,11 +508,11 @@ static int __init aes_s390_init(void)
 {
 	int ret;
 
-	if (crypt_s390_func_available(KM_AES_128_ENCRYPT))
+	if (crypt_s390_func_available(KM_AES_128_ENCRYPT, CRYPT_S390_MSA))
 		keylen_flag |= AES_KEYLEN_128;
-	if (crypt_s390_func_available(KM_AES_192_ENCRYPT))
+	if (crypt_s390_func_available(KM_AES_192_ENCRYPT, CRYPT_S390_MSA))
 		keylen_flag |= AES_KEYLEN_192;
-	if (crypt_s390_func_available(KM_AES_256_ENCRYPT))
+	if (crypt_s390_func_available(KM_AES_256_ENCRYPT, CRYPT_S390_MSA))
 		keylen_flag |= AES_KEYLEN_256;
 
 	if (!keylen_flag)
--- a/arch/s390/crypto/crypt_s390.h
+++ b/arch/s390/crypto/crypt_s390.h
@@ -24,6 +24,10 @@
 #define CRYPT_S390_PRIORITY 300
 #define CRYPT_S390_COMPOSITE_PRIORITY 400
 
+#define CRYPT_S390_MSA	0x1
+#define CRYPT_S390_MSA3	0x2
+#define CRYPT_S390_MSA4	0x4
+
 /* s390 cryptographic operations */
 enum crypt_s390_operations {
 	CRYPT_S390_KM   = 0x0100,
@@ -291,13 +295,17 @@ static inline int crypt_s390_kmac(long f
  *
  * Returns 1 if func available; 0 if func or op in general not available
  */
-static inline int crypt_s390_func_available(int func)
+static inline int crypt_s390_func_available(int func,
+					    unsigned int facility_mask)
 {
 	unsigned char status[16];
 	int ret;
 
-	/* check if CPACF facility (bit 17) is available */
-	if (!test_facility(17))
+	if (facility_mask & CRYPT_S390_MSA && !test_facility(17))
+		return 0;
+	if (facility_mask & CRYPT_S390_MSA3 && !test_facility(76))
+		return 0;
+	if (facility_mask & CRYPT_S390_MSA4 && !test_facility(77))
 		return 0;
 
 	switch (func & CRYPT_S390_OP_MASK) {
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -381,8 +381,8 @@ static int des_s390_init(void)
 {
 	int ret;
 
-	if (!crypt_s390_func_available(KM_DEA_ENCRYPT) ||
-	    !crypt_s390_func_available(KM_TDEA_192_ENCRYPT))
+	if (!crypt_s390_func_available(KM_DEA_ENCRYPT, CRYPT_S390_MSA) ||
+	    !crypt_s390_func_available(KM_TDEA_192_ENCRYPT, CRYPT_S390_MSA))
 		return -EOPNOTSUPP;
 
 	ret = crypto_register_alg(&des_alg);
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -166,7 +166,7 @@ static int __init prng_init(void)
 	int ret;
 
 	/* check if the CPU has a PRNG */
-	if (!crypt_s390_func_available(KMC_PRNG))
+	if (!crypt_s390_func_available(KMC_PRNG, CRYPT_S390_MSA))
 		return -EOPNOTSUPP;
 
 	if (prng_chunk_size < 8)
--- a/arch/s390/crypto/sha1_s390.c
+++ b/arch/s390/crypto/sha1_s390.c
@@ -90,7 +90,7 @@ static struct shash_alg alg = {
 
 static int __init sha1_s390_init(void)
 {
-	if (!crypt_s390_func_available(KIMD_SHA_1))
+	if (!crypt_s390_func_available(KIMD_SHA_1, CRYPT_S390_MSA))
 		return -EOPNOTSUPP;
 	return crypto_register_shash(&alg);
 }
--- a/arch/s390/crypto/sha256_s390.c
+++ b/arch/s390/crypto/sha256_s390.c
@@ -86,7 +86,7 @@ static struct shash_alg alg = {
 
 static int sha256_s390_init(void)
 {
-	if (!crypt_s390_func_available(KIMD_SHA_256))
+	if (!crypt_s390_func_available(KIMD_SHA_256, CRYPT_S390_MSA))
 		return -EOPNOTSUPP;
 
 	return crypto_register_shash(&alg);
--- a/arch/s390/crypto/sha512_s390.c
+++ b/arch/s390/crypto/sha512_s390.c
@@ -132,7 +132,7 @@ static int __init init(void)
 {
 	int ret;
 
-	if (!crypt_s390_func_available(KIMD_SHA_512))
+	if (!crypt_s390_func_available(KIMD_SHA_512, CRYPT_S390_MSA))
 		return -EOPNOTSUPP;
 	if ((ret = crypto_register_shash(&sha512_alg)) < 0)
 		goto out;

-- 
