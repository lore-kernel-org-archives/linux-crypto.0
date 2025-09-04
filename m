Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51B1281366;
	Thu,  4 Sep 2025 15:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001358; cv=none; b=Nan9bqUFt4JGmqfIV3y6yYqVaEya25GGNoBg5dVeBXOvud32l364jvqaWz9oJMSFg97eRCxiMVRfl+Sp6hhrsdAEkKMEKoKH4LxYAn0TUOX4Ca6veyyutJ3PXxgDdKZDYTLwjovdFYhJIBzVfN9KY/LzOhSRKAEqvujuJhX+5Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001358; c=relaxed/simple;
	bh=mlutIffgnb1gSzfnt/Z+ZPoKfPYaChYTKPO5dMatBr8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z67ij4U1ChEu8QgPhrkr4jAPuKoz8zeSqGdN/yMKTka3KmQreLsj/vD/XUFHnhmSrBM82GUk3vlAnHDHyhmeTZ9jTDLiHHWqm7yAFXGPbQDyNil7bBQDkb4FPeec5kfLdlhW+HUwMxoQkvOKgzuQOW1xtS6ixx1GIo8g/qMA2gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p/P9kS+T; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p/P9kS+T"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtiW6023800;
	Thu, 4 Sep 2025 15:55:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=D4W8o
	3ujSZ7g49n+RtLLZ7eOUsYuFvJWKhApWFM6EJo=; b=p/P9kS+TRD6IfGoAPH0Vk
	wwAmJajA46Yl5rPZ3vDSHCjcnrWrScL8316y25d7eGMr9sQt1tMfxi5pRBC5L8KX
	onAE2EiUO0SLEsXZyX3y8trVhQ8eYDem9LXLAL9jjTP2HK9d4PCOHn+6xS2aw5c2
	lzQ8jicUkq1Iwh+nUCopDjExzdEkB8LVWqKECk2LkptaidPDU45H12s97hq84qkm
	rslPSQ4Kj2GUexuPhHgXMXOWN1/HzY0DbzUWsKZgV8IxOD5b/IlS82N79EQ9/k2C
	gpurQ2+bFCUvkhlZKcCyGTpZMH46Je0cOj7OklywcEX7IJkqyXXWbRBDUs6Gejmx
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd020r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FbwjZ040252;
	Thu, 4 Sep 2025 15:55:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtmc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:42 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx56000707;
	Thu, 4 Sep 2025 15:55:41 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-11;
	Thu, 04 Sep 2025 15:55:41 +0000
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
Subject: [PATCH RFC 010/104] crypto/testmgr: make fips_allowed a bit set
Date: Thu,  4 Sep 2025 17:50:42 +0200
Message-Id: <20250904155216.460962-11-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX0kQG8ehX1zlm
 JyIPbSahemMRSOC3A8Y8va/3Egwbo9gXPvSK/RPhrLyLtugillZ6Nog+Wt3z1aE/koyH5rgZ2zC
 CVD91mxDVQcubUhaaTHWyHP8S++uECXJK6dS+T+swBhc5kCp0sws3REOs3qDvYeVXzwZzAOT6Ky
 JrHYovlP2aI/0SSSQbsI+FaS4HQTx3DtmcoEY1EInIm6Zn6DJy3cjeAWlGrFp3EN/C5G+7AAcC3
 GV1pZcAFzGUf6OTrte0OVNHsZmM7CuJZhgPFmwraQ1eF3YuvJfcVO5Bk1XxA5ohMMWX4oXmX0Uq
 +hifVmR8KWLjX+ONzEE3NZ5vS/wxnXszwpX5U0h51/Tma+6VAhTQBJ4lO9a19rgbvEpUWgJyYyo
 bEJtZ1xoOACPkOexOuSXEjLtZd2cyw==
X-Proofpoint-GUID: q93yQQJpDtjTxjt4hs7KhaXeT9qFEHTh
X-Proofpoint-ORIG-GUID: q93yQQJpDtjTxjt4hs7KhaXeT9qFEHTh
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b680 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=W2IuHgNVRA9FoEalUVQA:9 cc=ntf
 awl=host:12068

We'd like to distinguish between algorithms that are allowed by FIPS
due to being approved and algorithms that are allowed by FIPS due to
being non-cryptographic in nature (despite using the kernel's crypto
API).

Replace "1" with a named constant, FIPS_ALLOWED.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/testmgr.c | 218 ++++++++++++++++++++++++-----------------------
 1 file changed, 112 insertions(+), 106 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 47764fc879bb..4ca54cf6e244 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -142,12 +142,18 @@ struct kpp_test_suite {
 	unsigned int count;
 };
 
+/*
+ * Allowed algorithms are those which can exist inside a
+ * cryptographic module without making the module non-compliant
+ */
+#define FIPS_ALLOWED		1
+
 struct alg_test_desc {
 	const char *alg;
 	const char *generic_driver;
 	int (*test)(const struct alg_test_desc *desc, const char *driver,
 		    u32 type, u32 mask);
-	int fips_allowed;	/* set if alg is allowed in fips mode */
+	int fips_allowed;	/* see FIPS_* constants above */
 
 	union {
 		struct aead_test_suite aead;
@@ -4234,7 +4240,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "authenc(hmac(sha256),cbc(aes))",
 		.generic_driver = "authenc(hmac-sha256-lib,cbc(aes-generic))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.aead = __VECS(hmac_sha256_aes_cbc_tv_temp)
 		}
@@ -4255,7 +4261,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha256),ctr(aes))",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "authenc(hmac(sha256),cts(cbc(aes)))",
 		.generic_driver = "authenc(hmac-sha256-lib,cts(cbc(aes-generic)))",
@@ -4266,7 +4272,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "authenc(hmac(sha384),cbc(des))",
 		.generic_driver = "authenc(hmac-sha384-lib,cbc(des-generic))",
@@ -4284,7 +4290,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha384),ctr(aes))",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "authenc(hmac(sha384),cts(cbc(aes)))",
 		.generic_driver = "authenc(hmac-sha384-lib,cts(cbc(aes-generic)))",
@@ -4295,11 +4301,11 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha384),rfc3686(ctr(aes)))",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "authenc(hmac(sha512),cbc(aes))",
 		.generic_driver = "authenc(hmac-sha512-lib,cbc(aes-generic))",
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.test = alg_test_aead,
 		.suite = {
 			.aead = __VECS(hmac_sha512_aes_cbc_tv_temp)
@@ -4321,11 +4327,11 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha512),ctr(aes))",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "authenc(hmac(sha512),rfc3686(ctr(aes)))",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "blake2b-160",
 		.test = alg_test_hash,
@@ -4357,7 +4363,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "cbc(aes)",
 		.test = alg_test_skcipher,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.cipher = __VECS(aes_cbc_tv_template)
 		},
@@ -4415,7 +4421,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		 */
 		.alg = "cbc(paes)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		/* Same as cbc(sm4) except the key is stored in
 		 * hardware secure memory which we reference by index
@@ -4443,7 +4449,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 #if IS_ENABLED(CONFIG_CRYPTO_PAES_S390)
 		.alg = "cbc-paes-s390",
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(aes_cbc_tv_template)
@@ -4465,7 +4471,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "ccm(aes)",
 		.generic_driver = "ccm_base(ctr(aes-generic),cbcmac(aes-generic))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.aead = {
 				____VECS(aes_ccm_tv_template),
@@ -4490,7 +4496,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		},
 	}, {
 		.alg = "cmac(aes)",
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.test = alg_test_hash,
 		.suite = {
 			.hash = __VECS(aes_cmac128_tv_template)
@@ -4517,7 +4523,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "crc32",
 		.generic_driver = "crc32-lib",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(crc32_tv_template)
 		}
@@ -4525,14 +4531,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "crc32c",
 		.generic_driver = "crc32c-lib",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(crc32c_tv_template)
 		}
 	}, {
 		.alg = "ctr(aes)",
 		.test = alg_test_skcipher,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.cipher = __VECS(aes_ctr_tv_template)
 		}
@@ -4584,7 +4590,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		 */
 		.alg = "ctr(paes)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 
 		/* Same as ctr(sm4) except the key is stored in
@@ -4613,7 +4619,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 #if IS_ENABLED(CONFIG_CRYPTO_PAES_S390)
 		.alg = "ctr-paes-s390",
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(aes_ctr_tv_template)
@@ -4622,7 +4628,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 #endif
 		.alg = "cts(cbc(aes))",
 		.test = alg_test_skcipher,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.cipher = __VECS(cts_mode_tv_template)
 		}
@@ -4632,7 +4638,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		 */
 		.alg = "cts(cbc(paes))",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "cts(cbc(sm4))",
 		.test = alg_test_skcipher,
@@ -4648,7 +4654,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "deflate",
 		.test = alg_test_comp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.comp = {
 				.comp = __VECS(deflate_comp_tv_template),
@@ -4658,7 +4664,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "deflate-iaa",
 		.test = alg_test_comp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.comp = {
 				.comp = __VECS(deflate_comp_tv_template),
@@ -4677,28 +4683,28 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "drbg_nopr_ctr_aes128",
 		.test = alg_test_drbg,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.drbg = __VECS(drbg_nopr_ctr_aes128_tv_template)
 		}
 	}, {
 		.alg = "drbg_nopr_ctr_aes192",
 		.test = alg_test_drbg,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.drbg = __VECS(drbg_nopr_ctr_aes192_tv_template)
 		}
 	}, {
 		.alg = "drbg_nopr_ctr_aes256",
 		.test = alg_test_drbg,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.drbg = __VECS(drbg_nopr_ctr_aes256_tv_template)
 		}
 	}, {
 		.alg = "drbg_nopr_hmac_sha256",
 		.test = alg_test_drbg,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.drbg = __VECS(drbg_nopr_hmac_sha256_tv_template)
 		}
@@ -4709,18 +4715,18 @@ static const struct alg_test_desc alg_test_descs[] = {
 		 */
 		.alg = "drbg_nopr_hmac_sha384",
 		.test = alg_test_null,
-		.fips_allowed = 1
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "drbg_nopr_hmac_sha512",
 		.test = alg_test_drbg,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.drbg = __VECS(drbg_nopr_hmac_sha512_tv_template)
 		}
 	}, {
 		.alg = "drbg_nopr_sha256",
 		.test = alg_test_drbg,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.drbg = __VECS(drbg_nopr_sha256_tv_template)
 		}
@@ -4728,31 +4734,31 @@ static const struct alg_test_desc alg_test_descs[] = {
 		/* covered by drbg_nopr_sha256 test */
 		.alg = "drbg_nopr_sha384",
 		.test = alg_test_null,
-		.fips_allowed = 1
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "drbg_nopr_sha512",
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.test = alg_test_null,
 	}, {
 		.alg = "drbg_pr_ctr_aes128",
 		.test = alg_test_drbg,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.drbg = __VECS(drbg_pr_ctr_aes128_tv_template)
 		}
 	}, {
 		/* covered by drbg_pr_ctr_aes128 test */
 		.alg = "drbg_pr_ctr_aes192",
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.test = alg_test_null,
 	}, {
 		.alg = "drbg_pr_ctr_aes256",
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.test = alg_test_null,
 	}, {
 		.alg = "drbg_pr_hmac_sha256",
 		.test = alg_test_drbg,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.drbg = __VECS(drbg_pr_hmac_sha256_tv_template)
 		}
@@ -4760,15 +4766,15 @@ static const struct alg_test_desc alg_test_descs[] = {
 		/* covered by drbg_pr_hmac_sha256 test */
 		.alg = "drbg_pr_hmac_sha384",
 		.test = alg_test_null,
-		.fips_allowed = 1
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "drbg_pr_hmac_sha512",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "drbg_pr_sha256",
 		.test = alg_test_drbg,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.drbg = __VECS(drbg_pr_sha256_tv_template)
 		}
@@ -4776,15 +4782,15 @@ static const struct alg_test_desc alg_test_descs[] = {
 		/* covered by drbg_pr_sha256 test */
 		.alg = "drbg_pr_sha384",
 		.test = alg_test_null,
-		.fips_allowed = 1
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "drbg_pr_sha512",
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.test = alg_test_null,
 	}, {
 		.alg = "ecb(aes)",
 		.test = alg_test_skcipher,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.cipher = __VECS(aes_tv_template)
 		}
@@ -4834,7 +4840,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ecb(cipher_null)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "ecb(des)",
 		.test = alg_test_skcipher,
@@ -4868,7 +4874,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		 */
 		.alg = "ecb(paes)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "ecb(seed)",
 		.test = alg_test_skcipher,
@@ -4914,7 +4920,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 #if IS_ENABLED(CONFIG_CRYPTO_PAES_S390)
 		.alg = "ecb-paes-s390",
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(aes_tv_template)
@@ -4929,14 +4935,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ecdh-nist-p256",
 		.test = alg_test_kpp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.kpp = __VECS(ecdh_p256_tv_template)
 		}
 	}, {
 		.alg = "ecdh-nist-p384",
 		.test = alg_test_kpp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.kpp = __VECS(ecdh_p384_tv_template)
 		}
@@ -4949,21 +4955,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ecdsa-nist-p256",
 		.test = alg_test_sig,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.sig = __VECS(ecdsa_nist_p256_tv_template)
 		}
 	}, {
 		.alg = "ecdsa-nist-p384",
 		.test = alg_test_sig,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.sig = __VECS(ecdsa_nist_p384_tv_template)
 		}
 	}, {
 		.alg = "ecdsa-nist-p521",
 		.test = alg_test_sig,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.sig = __VECS(ecdsa_nist_p521_tv_template)
 		}
@@ -4977,7 +4983,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "essiv(authenc(hmac(sha256),cbc(aes)),sha256)",
 		.generic_driver = "essiv(authenc(hmac-sha256-lib,cbc(aes-generic)),sha256-lib)",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.aead = __VECS(essiv_hmac_sha256_aes_cbc_tv_temp)
 		}
@@ -4985,7 +4991,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "essiv(cbc(aes),sha256)",
 		.generic_driver = "essiv(cbc(aes-generic),sha256-lib)",
 		.test = alg_test_skcipher,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.cipher = __VECS(essiv_aes_cbc_tv_template)
 		}
@@ -4993,35 +4999,35 @@ static const struct alg_test_desc alg_test_descs[] = {
 #if IS_ENABLED(CONFIG_CRYPTO_DH_RFC7919_GROUPS)
 		.alg = "ffdhe2048(dh)",
 		.test = alg_test_kpp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.kpp = __VECS(ffdhe2048_dh_tv_template)
 		}
 	}, {
 		.alg = "ffdhe3072(dh)",
 		.test = alg_test_kpp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.kpp = __VECS(ffdhe3072_dh_tv_template)
 		}
 	}, {
 		.alg = "ffdhe4096(dh)",
 		.test = alg_test_kpp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.kpp = __VECS(ffdhe4096_dh_tv_template)
 		}
 	}, {
 		.alg = "ffdhe6144(dh)",
 		.test = alg_test_kpp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.kpp = __VECS(ffdhe6144_dh_tv_template)
 		}
 	}, {
 		.alg = "ffdhe8192(dh)",
 		.test = alg_test_kpp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.kpp = __VECS(ffdhe8192_dh_tv_template)
 		}
@@ -5030,7 +5036,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "gcm(aes)",
 		.generic_driver = "gcm_base(ctr(aes-generic),ghash-generic)",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.aead = __VECS(aes_gcm_tv_template)
 		}
@@ -5085,7 +5091,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "hmac(sha224)",
 		.generic_driver = "hmac-sha224-lib",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(hmac_sha224_tv_template)
 		}
@@ -5093,35 +5099,35 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "hmac(sha256)",
 		.generic_driver = "hmac-sha256-lib",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(hmac_sha256_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha3-224)",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(hmac_sha3_224_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha3-256)",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(hmac_sha3_256_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha3-384)",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(hmac_sha3_384_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha3-512)",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(hmac_sha3_512_tv_template)
 		}
@@ -5129,7 +5135,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "hmac(sha384)",
 		.generic_driver = "hmac-sha384-lib",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(hmac_sha384_tv_template)
 		}
@@ -5137,7 +5143,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "hmac(sha512)",
 		.generic_driver = "hmac-sha512-lib",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(hmac_sha512_tv_template)
 		}
@@ -5161,7 +5167,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "jitterentropy_rng",
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.test = alg_test_null,
 	}, {
 		.alg = "krb5enc(cmac(camellia),cts(cbc(camellia)))",
@@ -5205,7 +5211,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "lz4",
 		.test = alg_test_comp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.comp = {
 				.comp = __VECS(lz4_comp_tv_template),
@@ -5215,7 +5221,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "lz4hc",
 		.test = alg_test_comp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.comp = {
 				.comp = __VECS(lz4hc_comp_tv_template),
@@ -5225,7 +5231,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "lzo",
 		.test = alg_test_comp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.comp = {
 				.comp = __VECS(lzo_comp_tv_template),
@@ -5235,7 +5241,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "lzo-rle",
 		.test = alg_test_comp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.comp = {
 				.comp = __VECS(lzorle_comp_tv_template),
@@ -5272,18 +5278,18 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "p1363(ecdsa-nist-p256)",
 		.test = alg_test_sig,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.sig = __VECS(p1363_ecdsa_nist_p256_tv_template)
 		}
 	}, {
 		.alg = "p1363(ecdsa-nist-p384)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "p1363(ecdsa-nist-p521)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "pcbc(fcrypt)",
 		.test = alg_test_skcipher,
@@ -5294,28 +5300,28 @@ static const struct alg_test_desc alg_test_descs[] = {
 #if IS_ENABLED(CONFIG_CRYPTO_PHMAC_S390)
 		.alg = "phmac(sha224)",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(hmac_sha224_tv_template)
 		}
 	}, {
 		.alg = "phmac(sha256)",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(hmac_sha256_tv_template)
 		}
 	}, {
 		.alg = "phmac(sha384)",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(hmac_sha384_tv_template)
 		}
 	}, {
 		.alg = "phmac(sha512)",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(hmac_sha512_tv_template)
 		}
@@ -5329,38 +5335,38 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "pkcs1(rsa,sha224)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "pkcs1(rsa,sha256)",
 		.test = alg_test_sig,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.sig = __VECS(pkcs1_rsa_tv_template)
 		}
 	}, {
 		.alg = "pkcs1(rsa,sha3-256)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "pkcs1(rsa,sha3-384)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "pkcs1(rsa,sha3-512)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "pkcs1(rsa,sha384)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "pkcs1(rsa,sha512)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "pkcs1pad(rsa)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "polyval",
 		.test = alg_test_hash,
@@ -5370,7 +5376,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "rfc3686(ctr(aes))",
 		.test = alg_test_skcipher,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.cipher = __VECS(aes_ctr_rfc3686_tv_template)
 		}
@@ -5384,7 +5390,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "rfc4106(gcm(aes))",
 		.generic_driver = "rfc4106(gcm_base(ctr(aes-generic),ghash-generic))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.aead = {
 				____VECS(aes_gcm_rfc4106_tv_template),
@@ -5396,7 +5402,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "rfc4309(ccm(aes))",
 		.generic_driver = "rfc4309(ccm_base(ctr(aes-generic),cbcmac(aes-generic)))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.aead = {
 				____VECS(aes_ccm_rfc4309_tv_template),
@@ -5440,7 +5446,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "rsa",
 		.test = alg_test_akcipher,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.akcipher = __VECS(rsa_tv_template)
 		}
@@ -5455,7 +5461,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "sha224",
 		.generic_driver = "sha224-lib",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(sha224_tv_template)
 		}
@@ -5463,35 +5469,35 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "sha256",
 		.generic_driver = "sha256-lib",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(sha256_tv_template)
 		}
 	}, {
 		.alg = "sha3-224",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(sha3_224_tv_template)
 		}
 	}, {
 		.alg = "sha3-256",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(sha3_256_tv_template)
 		}
 	}, {
 		.alg = "sha3-384",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(sha3_384_tv_template)
 		}
 	}, {
 		.alg = "sha3-512",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(sha3_512_tv_template)
 		}
@@ -5499,7 +5505,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "sha384",
 		.generic_driver = "sha384-lib",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(sha384_tv_template)
 		}
@@ -5507,7 +5513,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "sha512",
 		.generic_driver = "sha512-lib",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(sha512_tv_template)
 		}
@@ -5556,21 +5562,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "x962(ecdsa-nist-p256)",
 		.test = alg_test_sig,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.sig = __VECS(x962_ecdsa_nist_p256_tv_template)
 		}
 	}, {
 		.alg = "x962(ecdsa-nist-p384)",
 		.test = alg_test_sig,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.sig = __VECS(x962_ecdsa_nist_p384_tv_template)
 		}
 	}, {
 		.alg = "x962(ecdsa-nist-p521)",
 		.test = alg_test_sig,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.sig = __VECS(x962_ecdsa_nist_p521_tv_template)
 		}
@@ -5608,7 +5614,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "xts(aes)",
 		.generic_driver = "xts(ecb(aes-generic))",
 		.test = alg_test_skcipher,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.cipher = __VECS(aes_xts_tv_template)
 		}
@@ -5632,7 +5638,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		 */
 		.alg = "xts(paes)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 	}, {
 		.alg = "xts(serpent)",
 		.generic_driver = "xts(ecb(serpent-generic))",
@@ -5657,7 +5663,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 #if IS_ENABLED(CONFIG_CRYPTO_PAES_S390)
 		.alg = "xts-paes-s390",
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(aes_xts_tv_template)
@@ -5666,14 +5672,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 #endif
 		.alg = "xxhash64",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.hash = __VECS(xxhash64_tv_template)
 		}
 	}, {
 		.alg = "zstd",
 		.test = alg_test_comp,
-		.fips_allowed = 1,
+		.fips_allowed = FIPS_ALLOWED,
 		.suite = {
 			.comp = {
 				.comp = __VECS(zstd_comp_tv_template),
-- 
2.39.3

