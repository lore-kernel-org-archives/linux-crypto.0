Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C591281366;
	Thu,  4 Sep 2025 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001366; cv=none; b=Ms0c6aIiA0o/7Ba6GuD6WnwexW8JxSJbOqmh/teD+hIBMXKGdrsJv7/7V4lTx8lqQOJcJ9u9NAUjTauHQaEL8cLfIGy+ECGMG8r2rbgX4kwJEYqmZBUL29sA+HcqtrYO5ni5p+oduWv0R0xXWuruGGctZRFg8VgE6IXhNDwGanQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001366; c=relaxed/simple;
	bh=4wFRuqJmZPlzyc7mJoe4XeT6K5vywJjUGa6wIuvKq6M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M1JNxDIF3InsyCITrjuG7CHbgzZFAIilw8wL7POp3KnKSfQ/vkGSHKEDUX5rOpOSB7l+3JTdpC+EuSj9RLpyIJMypdrzV89Ih6bHHdNZJyNJvC+cuCmb+nUt+dLEvQfGbNtdBEdjlIBUjNmp2q50rVVNHkGke9CIJkfI12mQe2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ya4z3ftl; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ya4z3ftl"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtlWr027733;
	Thu, 4 Sep 2025 15:55:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=nWNea
	3gciSoxILTBXgx0Jt+G5lP6dVMf8+uOPoffXeo=; b=Ya4z3ftl1uY3s5m21PYe6
	hquQGi0XgKDJiUU2IlGtPKbGyDZQz8N4biKOYn2qTpZMrtEXMuYkBV+egmu0tuK/
	v6BNf+i/SUxh1YNzPVKAXT7G7mCigFEmmE2WxIAjbyteN4Jw0wulWtxTwmkO2wXC
	eocCiWacalC4p8fDqeyVNwurj80mvLCbX1lIKvmFUM5Rs1wKHdQ7NdRREpbfKCAi
	TTuv9BpZWKs+FsiURt8UWZTad8VY/jCgGufzTkSGzPYxAFChTDRVyJh+mKDXemQ5
	SOC9X8YR0WZdnhnkP086NQn+0wfBJbDoYU92tid1ODSN6iiShpvRlRNtzCSHB0/M
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ycgn06wd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FTLPM040133;
	Thu, 4 Sep 2025 15:55:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtmck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:45 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx58000707;
	Thu, 4 Sep 2025 15:55:45 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-12;
	Thu, 04 Sep 2025 15:55:44 +0000
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
Subject: [PATCH RFC 011/104] crypto/testmgr: mark non-crypto algorithms
Date: Thu,  4 Sep 2025 17:50:43 +0200
Message-Id: <20250904155216.460962-12-vegard.nossum@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=evbfzppX c=1 sm=1 tr=0 ts=68b9b683 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=E-7bE6040NvcOGHhay4A:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: TcOGL_1I2CRgvL4obiCkNVPtvLGcr0Ru
X-Proofpoint-ORIG-GUID: TcOGL_1I2CRgvL4obiCkNVPtvLGcr0Ru
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0MiBTYWx0ZWRfX/capjJe1lSNx
 AHx0w5F8L1QsMJ/iZWMJNe+2yPTHylB+tD5jsPj9WAFNQSBDUWa2S2+G52e6q4TRLVuVYFjbdUj
 6BiQqSPDgD8HfQymwBRA313Kw37M8cJfGf5+iqgrGIIIIDxoKW5nCyfN8rmvCBV5QuUcBd3G7+q
 j8XLUzQVOuexDpseuKdyNRB7KT1gVWnb0rx12xFqbs5ruXo+nrLQRPj2XNgYT7B1vaOkU7fTRxq
 f41PRyT4ZbXbxZ5YSKj1wohg5t0fZgn0dyBfKCRi3z3Mq0W+BxXR6lUENS3RlWSykv0HOKmRBvH
 8F1B7WvDV58UPgD18mTUwOIF5qsx50UPxlOt28XpYs2Z+aixYQLstc3d/UZdUJDxa+eQwK4R8tH
 WKVm7hD+F/Nf+OOZfOOQRFl5aJI2DQ==

Add a new constant FIPS_NON_CRYPTOGRAPHIC and add it to all the
algorithms that are allowed by FIPS due to their non-cryptographic
nature.

This will include CRC32* and all compression algorithms.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/testmgr.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4ca54cf6e244..a216cb8b8caf 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -148,6 +148,13 @@ struct kpp_test_suite {
  */
 #define FIPS_ALLOWED		1
 
+/*
+ * Algorithm is not considered a cryptographic algorithm from
+ * a FIPS point of view and may be used for non-cryptographic
+ * purposes.
+ */
+#define FIPS_NON_CRYPTOGRAPHIC	2
+
 struct alg_test_desc {
 	const char *alg;
 	const char *generic_driver;
@@ -4523,7 +4530,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "crc32",
 		.generic_driver = "crc32-lib",
 		.test = alg_test_hash,
-		.fips_allowed = FIPS_ALLOWED,
+		.fips_allowed = FIPS_ALLOWED | FIPS_NON_CRYPTOGRAPHIC,
 		.suite = {
 			.hash = __VECS(crc32_tv_template)
 		}
@@ -4531,7 +4538,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "crc32c",
 		.generic_driver = "crc32c-lib",
 		.test = alg_test_hash,
-		.fips_allowed = FIPS_ALLOWED,
+		.fips_allowed = FIPS_ALLOWED | FIPS_NON_CRYPTOGRAPHIC,
 		.suite = {
 			.hash = __VECS(crc32c_tv_template)
 		}
@@ -4654,7 +4661,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "deflate",
 		.test = alg_test_comp,
-		.fips_allowed = FIPS_ALLOWED,
+		.fips_allowed = FIPS_ALLOWED | FIPS_NON_CRYPTOGRAPHIC,
 		.suite = {
 			.comp = {
 				.comp = __VECS(deflate_comp_tv_template),
@@ -4664,7 +4671,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "deflate-iaa",
 		.test = alg_test_comp,
-		.fips_allowed = FIPS_ALLOWED,
+		.fips_allowed = FIPS_ALLOWED | FIPS_NON_CRYPTOGRAPHIC,
 		.suite = {
 			.comp = {
 				.comp = __VECS(deflate_comp_tv_template),
@@ -5211,7 +5218,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "lz4",
 		.test = alg_test_comp,
-		.fips_allowed = FIPS_ALLOWED,
+		.fips_allowed = FIPS_ALLOWED | FIPS_NON_CRYPTOGRAPHIC,
 		.suite = {
 			.comp = {
 				.comp = __VECS(lz4_comp_tv_template),
@@ -5221,7 +5228,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "lz4hc",
 		.test = alg_test_comp,
-		.fips_allowed = FIPS_ALLOWED,
+		.fips_allowed = FIPS_ALLOWED | FIPS_NON_CRYPTOGRAPHIC,
 		.suite = {
 			.comp = {
 				.comp = __VECS(lz4hc_comp_tv_template),
@@ -5231,7 +5238,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "lzo",
 		.test = alg_test_comp,
-		.fips_allowed = FIPS_ALLOWED,
+		.fips_allowed = FIPS_ALLOWED | FIPS_NON_CRYPTOGRAPHIC,
 		.suite = {
 			.comp = {
 				.comp = __VECS(lzo_comp_tv_template),
@@ -5241,7 +5248,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "lzo-rle",
 		.test = alg_test_comp,
-		.fips_allowed = FIPS_ALLOWED,
+		.fips_allowed = FIPS_ALLOWED | FIPS_NON_CRYPTOGRAPHIC,
 		.suite = {
 			.comp = {
 				.comp = __VECS(lzorle_comp_tv_template),
@@ -5679,7 +5686,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "zstd",
 		.test = alg_test_comp,
-		.fips_allowed = FIPS_ALLOWED,
+		.fips_allowed = FIPS_ALLOWED | FIPS_NON_CRYPTOGRAPHIC,
 		.suite = {
 			.comp = {
 				.comp = __VECS(zstd_comp_tv_template),
-- 
2.39.3

