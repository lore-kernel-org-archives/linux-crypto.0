Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D220028312F;
	Thu,  4 Sep 2025 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001479; cv=none; b=hKnVdoIjcJImGKiD3/Xe82NAkcIiMAQe+sqpXLVIxhgBpxEQ5sgrzpuJf1DWBaE7oVVJUUyQQH0BlpGtbtZ7MkroY2iF6IyWDe2jZ26F1mRaWzHTrdRD1+yaHGx9BFIoymgMKjwtvFTtaSF3Vv2GC5VWr+ZKzXSodgV5JxvWnHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001479; c=relaxed/simple;
	bh=zsLAtwbDogvz5smkttD08Ri7UxUZzOSEc9tk4BnbJKk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ej3e1FmMTCqKzg28vMheIlwuEmYcm9uUx7cH32Ag/Vptl8MY4iOcSttK4JaR9UQf8OcTRIhx+U4wD5iq4gmTynL6jX1L00P0GM0i6+NfQZMrloGoy5f+iQHywPol9Wqd26bea4NRUg4W7KV6nlic6mypq0RwhlfXl4cdJoq+iik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lHG0yReC; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lHG0yReC"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fuf1M004081;
	Thu, 4 Sep 2025 15:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=RcZXZ
	RQaDUlx/VwaMgScvqy7VWHbvpqjfNN/p8xOiF4=; b=lHG0yReC1qv5Kyw5ryw3G
	4fzD5lNRKYzOmfDIDmF4j+u3l/KLdmgZyQ/z4Z48MwBF4lq1IpB5rv94gKcr9aUv
	BzpWdeyn1hMKARfPVzb0DgWPY2YEVsu5wxeKdgxiUOPWGz3aa1mazRmqrnMmwsKu
	gnckYFpuZVAUHyXXoIUySLYH5+Cy5DV8RdJePK0cDvmg+e0iuXMQTqbt4CpFK6om
	Bg1jz3bN015bLSthX9ERd/+0ND+waXrIJisvey0DRpGsyBq+Jt3SQ8BB3BDlLun8
	ETko7nIKqmD0/fHES7uzvFC0P2RnFtuaoX1qWuHBOsBuQGUUemHpAqI2a2J+NF9l
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun001m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FDefg040212;
	Thu, 4 Sep 2025 15:57:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtp6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:44 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6I000707;
	Thu, 4 Sep 2025 15:57:43 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-46;
	Thu, 04 Sep 2025 15:57:43 +0000
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
Subject: [PATCH RFC 045/104] crypto: fips140: convert crypto/dh_helper.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:17 +0200
Message-Id: <20250904155216.460962-46-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: FHFTCO7uIRnwzQeCpD4am1w3InGjus5o
X-Proofpoint-GUID: FHFTCO7uIRnwzQeCpD4am1w3InGjus5o
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b6f8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=xdP06Dtb6clrNqNN04AA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX++Dt6pvg8uob
 Ogoo/757/GkkuW0w6B4p6ntSv3EZY/Oyv/eEnUBEP+PjpDvgIRqcJEjwzdvOoIHkm4TsRQkMVbZ
 9EC5PEQVD2CbwiFCgevBrN+BZDwMOfRaOtGTY5NKVmGx1A0thxLorT6Dbf+3AzHqxWRmv2gEJyS
 HLPyF3+JMKfe0vllQinPcIbkKtU1fhRBxd51AbI7gNtZ8C5Xu3Nha/8ht/5l7HwSCICv/+soG31
 QbleZoMbKButxceiyMDX5u9tf7Ykq44j05peXHPokTUgKKVL37bwzmKPk2QxJn7zbszpR4MDVkx
 1925QlgQ5iNi0rn3Wq6dy6LhGD9/n7RC69w5paoDSxQ/SnoY3oVyH5RSOA3Re+DEdAfAqXztDmP
 Fbf3Qs0j0H6U/4iqKDakmMvKVNkLEg==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_DH --source crypto/dh_helper.c --header include/crypto/dh.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/dh_helper.c   | 12 ++++++------
 crypto/fips140-api.c | 13 +++++++++++++
 include/crypto/dh.h  | 12 +++++++++---
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/crypto/dh_helper.c b/crypto/dh_helper.c
index 2d499879328b..d3001289d152 100644
--- a/crypto/dh_helper.c
+++ b/crypto/dh_helper.c
@@ -31,13 +31,13 @@ static inline unsigned int dh_data_size(const struct dh *p)
 	return p->key_size + p->p_size + p->g_size;
 }
 
-unsigned int crypto_dh_key_len(const struct dh *p)
+unsigned int CRYPTO_API(crypto_dh_key_len)(const struct dh *p)
 {
 	return DH_KPP_SECRET_MIN_SIZE + dh_data_size(p);
 }
-EXPORT_SYMBOL_GPL(crypto_dh_key_len);
+DEFINE_CRYPTO_API(crypto_dh_key_len);
 
-int crypto_dh_encode_key(char *buf, unsigned int len, const struct dh *params)
+int CRYPTO_API(crypto_dh_encode_key)(char *buf, unsigned int len, const struct dh *params)
 {
 	u8 *ptr = buf;
 	u8 * const end = ptr + len;
@@ -61,7 +61,7 @@ int crypto_dh_encode_key(char *buf, unsigned int len, const struct dh *params)
 		return -EINVAL;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_dh_encode_key);
+DEFINE_CRYPTO_API(crypto_dh_encode_key);
 
 int __crypto_dh_decode_key(const char *buf, unsigned int len, struct dh *params)
 {
@@ -91,7 +91,7 @@ int __crypto_dh_decode_key(const char *buf, unsigned int len, struct dh *params)
 	return 0;
 }
 
-int crypto_dh_decode_key(const char *buf, unsigned int len, struct dh *params)
+int CRYPTO_API(crypto_dh_decode_key)(const char *buf, unsigned int len, struct dh *params)
 {
 	int err;
 
@@ -117,4 +117,4 @@ int crypto_dh_decode_key(const char *buf, unsigned int len, struct dh *params)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_dh_decode_key);
+DEFINE_CRYPTO_API(crypto_dh_decode_key);
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 816a55809f4a..600c759cbc5e 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -350,3 +350,16 @@ DEFINE_CRYPTO_API_STUB(cryptd_free_aead);
 
 #endif
 
+/*
+ * crypto/dh_helper.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_DH)
+
+#include <crypto/dh.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_dh_key_len);
+DEFINE_CRYPTO_API_STUB(crypto_dh_encode_key);
+DEFINE_CRYPTO_API_STUB(crypto_dh_decode_key);
+
+#endif
+
diff --git a/include/crypto/dh.h b/include/crypto/dh.h
index b5891c21cfe0..f876d46b16d6 100644
--- a/include/crypto/dh.h
+++ b/include/crypto/dh.h
@@ -50,7 +50,9 @@ struct dh {
  *
  * Return: size of the key in bytes
  */
-unsigned int crypto_dh_key_len(const struct dh *params);
+DECLARE_CRYPTO_API(crypto_dh_key_len, unsigned int,
+	(const struct dh *params),
+	(params));
 
 /**
  * crypto_dh_encode_key() - encode the private key
@@ -65,7 +67,9 @@ unsigned int crypto_dh_key_len(const struct dh *params);
  *
  * Return:	-EINVAL if buffer has insufficient size, 0 on success
  */
-int crypto_dh_encode_key(char *buf, unsigned int len, const struct dh *params);
+DECLARE_CRYPTO_API(crypto_dh_encode_key, int,
+	(char *buf, unsigned int len, const struct dh *params),
+	(buf, len, params));
 
 /**
  * crypto_dh_decode_key() - decode a private key
@@ -79,7 +83,9 @@ int crypto_dh_encode_key(char *buf, unsigned int len, const struct dh *params);
  *
  * Return:	-EINVAL if buffer has insufficient size, 0 on success
  */
-int crypto_dh_decode_key(const char *buf, unsigned int len, struct dh *params);
+DECLARE_CRYPTO_API(crypto_dh_decode_key, int,
+	(const char *buf, unsigned int len, struct dh *params),
+	(buf, len, params));
 
 /**
  * __crypto_dh_decode_key() - decode a private key without parameter checks
-- 
2.39.3

