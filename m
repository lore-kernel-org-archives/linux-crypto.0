Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BED3284696;
	Thu,  4 Sep 2025 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001563; cv=none; b=NxqUtGi2XVFBN+TIRVUp4mtahtoRkp/v3ZzvQzNcpM4+x15cVkbhDjvdCk5PhIopfQQs//ezn4wsVnLRwG34CzGXTJHw7RuB/qooasmHFVlF+HGMrCF1y2EtTDDzMj9ENfKtaa4uu1x4sAtsINKnDCHtZdXwQ6iadWr8/aJjrYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001563; c=relaxed/simple;
	bh=BwGQqQp+po6ewgfj5M82+4R/uK0Lwvfht0o2UTCThV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zmm7bLO53lstYAa/cOUR4REJex1aMR5tuRsZJqLpgRxo9PrnVbKtX7KDan12o9DEcsVFIwiyxoJ0KrJI8wfAr5vJxx2C1zWnsv3a0mW1e29L5VR/yNs/jYNBfsZ433EVM4tchnBjTzmvvADmfXIdhAnzFBw7dlpvaBAfKLF5LBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IeUuVs/x; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IeUuVs/x"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fuh0S004085;
	Thu, 4 Sep 2025 15:59:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=K1bHr
	1lC3TXJKSGumZi5VMsypDGX1AvRL8yVx2604Kw=; b=IeUuVs/xXE0+Cp0V/Q3LA
	AJicpefEJUR3KSqkYLwa2SnV4jQ4+QRnkiuyjD4v9tOtzvzhBF9pxYvivDWiwNbS
	+5q+jeTirKWuef42CKkO2PK/S5KgYqRKqsQWcT96/3RhUYoNnbstprHMt/+0Oy5Q
	obIrDaWgvtknuiJ8J/Fm+CKnBrxCmhmNQll9gnLtQcBUAczoZlQoZSamRzt8trXh
	2c7PzXsprMbKD8CrUCWNpwtJTSzQE6ZiCxiQBRGuvumrEg+lRZQay0PPikwAp67a
	GGq5gBNxo5Uscmd5TpHV4Oq15spZsdjnEofS1Wy3IpSHck2185jvGEFP/LXXRi39
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun006a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FDegH040212;
	Thu, 4 Sep 2025 15:59:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtqfq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:10 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6q000707;
	Thu, 4 Sep 2025 15:59:09 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-63;
	Thu, 04 Sep 2025 15:59:09 +0000
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
Subject: [PATCH RFC 062/104] crypto: fips140: convert crypto/rng.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:34 +0200
Message-Id: <20250904155216.460962-63-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: ha27Oth7CNVamJ5DxaWlk4zKN49CQCT6
X-Proofpoint-GUID: ha27Oth7CNVamJ5DxaWlk4zKN49CQCT6
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b74e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=oovuvzNscppnFL_TSnsA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX2kyoGqOp6VKA
 QhM4tnJtnEbiCH3gDY/mRGP8CZlfdlFGvKzai0JQlNAoMfGNh2kCNu/m/+ceiqIxz/TxgA+odef
 WdjOhf1KlXwk/YKPMbXq88bv6ZF9Jph5z5xJB58EQ4kiEbx5Kw3gzp70fdz0Ut+Kl6Ubj5IWcK7
 N2NSojdBStc5Gi37Vq/M82TtKKCB9Bqr0ei+t6l5N8VWBE7OFn3L1xsVJ57GVcpe8iQ6L5AftWQ
 nX2bpJglynivCFkNcrDVsH7luA2YoKLaptk8PBc6mmVBJgvW3wiFK6OuN/y4MhnYXJEJWNrhTZw
 1AS+Zoupbi79pdjVVBq+CF5vg3f8CXWbcBtR/B2C11U3ZFhc3iveX8HsCL9A3/22DoEMv01irNV
 oe+A+9vqy+sdfDWYgzFmW5jwDHbDuA==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_RNG2 --source crypto/rng.c --header include/crypto/rng.h include/crypto/internal/rng.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c          | 22 +++++++++++++++++++++
 crypto/rng.c                  | 36 +++++++++++++++++------------------
 include/crypto/internal/rng.h | 21 +++++++++++++++-----
 include/crypto/rng.h          | 18 +++++++++++++-----
 4 files changed, 69 insertions(+), 28 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 70b896ef42ff..8810af32dd43 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -466,3 +466,25 @@ DEFINE_CRYPTO_API_STUB(lskcipher_alloc_instance_simple);
 
 #endif
 
+/*
+ * crypto/rng.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_RNG2)
+
+#include <crypto/rng.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_get_default_rng);
+DEFINE_CRYPTO_API_STUB(crypto_put_default_rng);
+DEFINE_CRYPTO_API_STUB(crypto_alloc_rng);
+DEFINE_CRYPTO_API_STUB(crypto_rng_reset);
+
+#include <crypto/internal/rng.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_register_rng);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_rng);
+DEFINE_CRYPTO_API_STUB(crypto_register_rngs);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_rngs);
+DEFINE_CRYPTO_API_STUB(crypto_del_default_rng);
+
+#endif
+
diff --git a/crypto/rng.c b/crypto/rng.c
index 2a246e1a0918..66bbb976ac95 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -27,7 +27,7 @@ static DEFINE_MUTEX(crypto_default_rng_lock);
 static struct crypto_rng *crypto_default_rng;
 static int crypto_default_rng_refcnt;
 
-int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
+int CRYPTO_API(crypto_rng_reset)(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 {
 	u8 *buf = NULL;
 	int err;
@@ -48,7 +48,7 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 	kfree_sensitive(buf);
 	return err;
 }
-EXPORT_SYMBOL_GPL(crypto_rng_reset);
+DEFINE_CRYPTO_API(crypto_rng_reset);
 
 static int crypto_rng_init_tfm(struct crypto_tfm *tfm)
 {
@@ -100,13 +100,13 @@ static const struct crypto_type crypto_rng_type = {
 	.algsize = offsetof(struct rng_alg, base),
 };
 
-struct crypto_rng *crypto_alloc_rng(const char *alg_name, u32 type, u32 mask)
+struct crypto_rng *CRYPTO_API(crypto_alloc_rng)(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_alloc_tfm(alg_name, &crypto_rng_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_rng);
+DEFINE_CRYPTO_API(crypto_alloc_rng);
 
-int crypto_get_default_rng(struct crypto_rng **result)
+int CRYPTO_API(crypto_get_default_rng)(struct crypto_rng **result)
 {
 	struct crypto_rng *rng;
 	int err;
@@ -136,19 +136,19 @@ int crypto_get_default_rng(struct crypto_rng **result)
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(crypto_get_default_rng);
+DEFINE_CRYPTO_API(crypto_get_default_rng);
 
-void crypto_put_default_rng(struct crypto_rng **rng)
+void CRYPTO_API(crypto_put_default_rng)(struct crypto_rng **rng)
 {
 	mutex_lock(&crypto_default_rng_lock);
 	*rng = NULL;
 	crypto_default_rng_refcnt--;
 	mutex_unlock(&crypto_default_rng_lock);
 }
-EXPORT_SYMBOL_GPL(crypto_put_default_rng);
+DEFINE_CRYPTO_API(crypto_put_default_rng);
 
 #if defined(CONFIG_CRYPTO_RNG) || defined(CONFIG_CRYPTO_RNG_MODULE)
-int crypto_del_default_rng(void)
+int CRYPTO_API(crypto_del_default_rng)(void)
 {
 	int err = -EBUSY;
 
@@ -166,10 +166,10 @@ int crypto_del_default_rng(void)
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(crypto_del_default_rng);
+DEFINE_CRYPTO_API(crypto_del_default_rng);
 #endif
 
-int crypto_register_rng(struct rng_alg *alg)
+int CRYPTO_API(crypto_register_rng)(struct rng_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 
@@ -182,15 +182,15 @@ int crypto_register_rng(struct rng_alg *alg)
 
 	return crypto_register_alg(base);
 }
-EXPORT_SYMBOL_GPL(crypto_register_rng);
+DEFINE_CRYPTO_API(crypto_register_rng);
 
-void crypto_unregister_rng(struct rng_alg *alg)
+void CRYPTO_API(crypto_unregister_rng)(struct rng_alg *alg)
 {
 	crypto_unregister_alg(&alg->base);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_rng);
+DEFINE_CRYPTO_API(crypto_unregister_rng);
 
-int crypto_register_rngs(struct rng_alg *algs, int count)
+int CRYPTO_API(crypto_register_rngs)(struct rng_alg *algs, int count)
 {
 	int i, ret;
 
@@ -208,16 +208,16 @@ int crypto_register_rngs(struct rng_alg *algs, int count)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(crypto_register_rngs);
+DEFINE_CRYPTO_API(crypto_register_rngs);
 
-void crypto_unregister_rngs(struct rng_alg *algs, int count)
+void CRYPTO_API(crypto_unregister_rngs)(struct rng_alg *algs, int count)
 {
 	int i;
 
 	for (i = count - 1; i >= 0; --i)
 		crypto_unregister_rng(algs + i);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_rngs);
+DEFINE_CRYPTO_API(crypto_unregister_rngs);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Random Number Generator");
diff --git a/include/crypto/internal/rng.h b/include/crypto/internal/rng.h
index e0711b6a597f..e4e4bbffc086 100644
--- a/include/crypto/internal/rng.h
+++ b/include/crypto/internal/rng.h
@@ -9,16 +9,27 @@
 #ifndef _CRYPTO_INTERNAL_RNG_H
 #define _CRYPTO_INTERNAL_RNG_H
 
+#include <crypto/api.h>
 #include <crypto/algapi.h>
 #include <crypto/rng.h>
 
-int crypto_register_rng(struct rng_alg *alg);
-void crypto_unregister_rng(struct rng_alg *alg);
-int crypto_register_rngs(struct rng_alg *algs, int count);
-void crypto_unregister_rngs(struct rng_alg *algs, int count);
+DECLARE_CRYPTO_API(crypto_register_rng, int,
+	(struct rng_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_unregister_rng, void,
+	(struct rng_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_register_rngs, int,
+	(struct rng_alg *algs, int count),
+	(algs, count));
+DECLARE_CRYPTO_API(crypto_unregister_rngs, void,
+	(struct rng_alg *algs, int count),
+	(algs, count));
 
 #if defined(CONFIG_CRYPTO_RNG) || defined(CONFIG_CRYPTO_RNG_MODULE)
-int crypto_del_default_rng(void);
+DECLARE_CRYPTO_API(crypto_del_default_rng, int,
+	(void),
+	());
 #else
 static inline int crypto_del_default_rng(void)
 {
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 816f255adcd3..b7d7ff59d6a5 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -9,6 +9,7 @@
 #ifndef _CRYPTO_RNG_H
 #define _CRYPTO_RNG_H
 
+#include <crypto/api.h>
 #include <linux/atomic.h>
 #include <linux/container_of.h>
 #include <linux/crypto.h>
@@ -57,8 +58,12 @@ struct crypto_rng {
 	struct crypto_tfm base;
 };
 
-int crypto_get_default_rng(struct crypto_rng **rng);
-void crypto_put_default_rng(struct crypto_rng **rng);
+DECLARE_CRYPTO_API(crypto_get_default_rng, int,
+	(struct crypto_rng **rng),
+	(rng));
+DECLARE_CRYPTO_API(crypto_put_default_rng, void,
+	(struct crypto_rng **rng),
+	(rng));
 
 /**
  * DOC: Random number generator API
@@ -87,7 +92,9 @@ void crypto_put_default_rng(struct crypto_rng **rng);
  * Return: allocated cipher handle in case of success; IS_ERR() is true in case
  *	   of an error, PTR_ERR() returns the error code.
  */
-struct crypto_rng *crypto_alloc_rng(const char *alg_name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_alloc_rng, struct crypto_rng *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
 static inline struct crypto_tfm *crypto_rng_tfm(struct crypto_rng *tfm)
 {
@@ -176,8 +183,9 @@ static inline int crypto_rng_get_bytes(struct crypto_rng *tfm,
  *
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
-int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed,
-		     unsigned int slen);
+DECLARE_CRYPTO_API(crypto_rng_reset, int,
+	(struct crypto_rng *tfm, const u8 *seed, unsigned int slen),
+	(tfm, seed, slen));
 
 /**
  * crypto_rng_seedsize() - obtain seed size of RNG
-- 
2.39.3

