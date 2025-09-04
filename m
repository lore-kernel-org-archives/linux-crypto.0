Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928A128315D;
	Thu,  4 Sep 2025 15:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001419; cv=none; b=aHeKFuJMpCkCR3TO/YEsTCNY/v7xvVcwjR0yiF4npLEkwF251g4BKO4RMGZDsQZ6ftWECzWuJxc7NQwCULNDH6YD1y3ZtHZlVAUmwLxp/ZeZcH991nR/FRobryVlzA6CPDbZ+3zuAt/4xF1/Zg9CP/FE6gM6hEVQFYaL3/u5E9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001419; c=relaxed/simple;
	bh=KEwrqE3CcSACdGDU6qsUk5exumtrjmnG+9Ku2c2l9Cc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XJ7mut2WTGL/2wJiLTqx3ij69pDGcnzFHNk1MSz7muYmvWWxbfQt4tjt5+pbJ9oAYolPtoA/BS2HuDJXGqqkt+8MSupD+/j0E9esMze05+N004a68e6Xsre1FgskZY9svchf0o6p0p2nfhx3gKi8jE3z/RbTx/2zrQJg+w5S89w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KqWlO13q; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KqWlO13q"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtmEp023970;
	Thu, 4 Sep 2025 15:56:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=ry9bZ
	FoEhWflkAluk72IoWDld4b+Vj78DhwGX79EfgI=; b=KqWlO13qVYyKSrw+3i90p
	anlNGITzOUIlK1Nu1U1koPjAxmgqmClAQ5u/HCcvVofcVw3TyvzKFGztWUtq6sD8
	KP7OXRw0O/c0dPM7cxq5t1pbcTqSZ9jwpp9mKI31YVkvNMuzLcGeZISvRDuE0QpM
	z/GiraTjYZRdNr0GkMcm2MhoJSBvnP/1kNpClFyNz+EZXB8YNB95tA6BdCu/IWe9
	wHRW4krRK9Gl6qi/VGf82gLJlMsK7iYuDtBtaTdhqdWLtQlrUeZc/Gvu9OF0JOcg
	3MHhQwEg4Wz2jSQdz7gjuYrYGhsN33hYeKWkSTICVNgRmjn+wJ2kpSxq8+Dm9sWK
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd0244-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584F7Qo7040109;
	Thu, 4 Sep 2025 15:56:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtnb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:45 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5i000707;
	Thu, 4 Sep 2025 15:56:45 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-29;
	Thu, 04 Sep 2025 15:56:45 +0000
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
Subject: [PATCH RFC 028/104] crypto: fips140: convert lib/crypto/utils.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:00 +0200
Message-Id: <20250904155216.460962-29-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX14b4tNsknKZ+
 4S5OJjhmsOH3bBMAAV1wC/gZ7B50b95qBwv0DwfY6zeGlSFaYZhaWVUEm/OYgaclAmpK1WSJ5fI
 +D5NlUQg6J6ELB5xTV+xBI9FvTFIgzZ8ZQXghYA4+LTxfSFPNISGS2viJfSTcfyb9CmkhwwdgYY
 9SLa6AejpBeomG/yguAfWJdMzLGNSnDup9GZUS3buhbTvvZlJ0lFmvyVHQQt31lAaAOU7QzNBcD
 dHicHn/4HKYPm6Tz8Z73F9k/Yu/ZrDFiK3uj1RpdE5f5q3SsU+WUlzXK4lyCJCaFQxU7S0wME5K
 51j74yTxiso5gGHhPT78fSd0NMeWxyBXPcYCgeILVa5fYVvynPW38rjTldQ2e/Ib59u4BRelYLd
 Df47A8+0T2kHaKueanUAU+Ict7R62Q==
X-Proofpoint-GUID: MoaHk06yObUEM6gsn1MzcML1NyJmm4uW
X-Proofpoint-ORIG-GUID: MoaHk06yObUEM6gsn1MzcML1NyJmm4uW
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b6be b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=4eI07gA6wZ689gDU0lAA:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_LIB_UTILS --source lib/crypto/utils.c --header include/crypto/utils.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c   | 11 +++++++++++
 include/crypto/utils.h |  4 +++-
 lib/crypto/utils.c     |  4 ++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 13148a3d3519..6caef4827a53 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -116,3 +116,14 @@ DEFINE_CRYPTO_API_STUB(hmac_sha512_usingrawkey);
 
 #endif
 
+/*
+ * lib/crypto/utils.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_LIB_UTILS)
+
+#include <crypto/utils.h>
+
+DEFINE_CRYPTO_API_STUB(__crypto_xor);
+
+#endif
+
diff --git a/include/crypto/utils.h b/include/crypto/utils.h
index d7c3dae79138..996435707260 100644
--- a/include/crypto/utils.h
+++ b/include/crypto/utils.h
@@ -12,7 +12,9 @@
 #include <linux/compiler_attributes.h>
 #include <linux/types.h>
 
-void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int size);
+DECLARE_CRYPTO_API(__crypto_xor, void,
+	(u8 *dst, const u8 *src1, const u8 *src2, unsigned int size),
+	(dst, src1, src2, size));
 
 static inline void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
 {
diff --git a/lib/crypto/utils.c b/lib/crypto/utils.c
index dec381d5e906..276519171e1c 100644
--- a/lib/crypto/utils.c
+++ b/lib/crypto/utils.c
@@ -15,7 +15,7 @@
  * (which may alias one of the sources).  Don't call this directly; call
  * crypto_xor() or crypto_xor_cpy() instead.
  */
-void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int len)
+void CRYPTO_API(__crypto_xor)(u8 *dst, const u8 *src1, const u8 *src2, unsigned int len)
 {
 	int relalign = 0;
 
@@ -84,7 +84,7 @@ void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int len)
 	while (len--)
 		*dst++ = *src1++ ^ *src2++;
 }
-EXPORT_SYMBOL_GPL(__crypto_xor);
+DEFINE_CRYPTO_API(__crypto_xor);
 
 MODULE_DESCRIPTION("Crypto library utility functions");
 MODULE_LICENSE("GPL");
-- 
2.39.3

