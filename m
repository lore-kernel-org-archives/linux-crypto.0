Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0692426C393
	for <linux-crypto@vger.kernel.org>; Wed, 21 May 2025 12:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747832193; cv=none; b=boVSRuCJS6ohAEZnwHpY8g248n+fyWAjyOHJUW7iyqM6YyHwFEYWVtNU6zQQXFqFWnJW5LczDCoYiYHGNqgYmWf+i5tmMW028Wo7isvUv3m5N0fqf9tH1rFNYIJkdjr1EBZWdSByCgeUsmRhaT8FdPZ0rwo3aM1IBsAJPkmxViM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747832193; c=relaxed/simple;
	bh=jqFh6OLy009sVDrIEZvFgfEAz7W9TfG0E1Id0rNgjYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uB+l7AuLS3I4lGz7DbVVECIWjdGBSdJBlrlSyxacUdMlvuASvdPbbcdIlFaB0TpExD/tBb84LfURlMLv2GFiZrqoLuPxHu9PcKmMVlLMu9kS6G3fdGPzeQkwBEdvWxupMZpaAyfivr20RE3ZHIy81i1AoriHEAxVM/QrS8P6aRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UF5yLWte; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UF5yLWte"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54LCqWMr018023;
	Wed, 21 May 2025 12:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=1Dl3/w2twWEy/ihWLMjI0xKdu/iRo
	OYbHs0xJY7lumc=; b=UF5yLWteKhtS1nsDAkOFh+pMQLZqWB41yT+iBh7rOXlPW
	H2pyIBeIMZUGuJjSFLkUylN/5x14jcRZSouafh0N/07ZXR2TKqd+sVPTmBViraoU
	T6MNK5NtaTfuobCLj3WUegfBhk5zirPObF4FdA5skFVOEOGMlbQcYYjiuFxoyl4R
	CetIKiJfVNZo3dDb+5GR3nsXmKsn8ocPAn9juMIXN+Kap9pO0MVwwAfxmkWgirux
	52EH2T9GHVDC4ZPX3prSWRpi9BqBEdEbUCkIuU8h12X730FmsZYcWQyFA3gR0oX2
	4D3kMo8Fsni6UHYf+k/PBtTkhRnEkhTE2Xg9zgQ9A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46sf7c80bh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 12:55:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54LCF7wk020313;
	Wed, 21 May 2025 12:55:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46rwetths6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 12:55:56 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54LCttq0027436;
	Wed, 21 May 2025 12:55:55 GMT
Received: from localhost.localdomain (dhcp-10-154-214-60.vpn.oracle.com [10.154.214.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 46rwetthqq-1;
	Wed, 21 May 2025 12:55:55 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Stephan Mueller <smueller@chronox.de>,
        Marcus Meissner <meissner@suse.de>, Jarod Wilson <jarod@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        John Haxby <john.haxby@oracle.com>
Subject: [PATCH] crypto/testmgr.c: desupport SHA-1 for FIPS 140
Date: Wed, 21 May 2025 14:55:19 +0200
Message-Id: <20250521125519.2839581-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_04,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505210125
X-Proofpoint-GUID: _txlVD8LC1PCe4sONhgPBgTgNoC75U8l
X-Proofpoint-ORIG-GUID: _txlVD8LC1PCe4sONhgPBgTgNoC75U8l
X-Authority-Analysis: v=2.4 cv=OZ2YDgTY c=1 sm=1 tr=0 ts=682dcd5d b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=dt9VzEwgFbYA:10 a=PYnjg3YJAAAA:8 a=20KFwNOVAAAA:8 a=vmLDa1wCAAAA:8 a=yPCof4ZbAAAA:8 a=SVbLyAKZ51KGVHrPys8A:9
 a=h8Bt5HTj68qkN2fS7gvA:22 cc=ntf awl=host:13207
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDEyNSBTYWx0ZWRfX+rZgte3CDKtW WInwIaciv7vsvUlj1AtLNX68CXLiF00+J9jJ9xreLjW5MfG05/+mUr48h+fpEa9z/kO6ErWzPjZ H9jSY37b9C+ZGHwNPQu6QAhudC+BvYJZ9HASuWNYaOvWwjj63PUb4qNRZSIfjVBBFbOEqsFIKCZ
 qYZZqSi8zShwflrSeSEmqE5xx4ywXF0oG7mm80EnPWg4h+ACjiVsxa58dfrA6pfCWSigF8Yi4OP tjdiOTkL9WqoFNDbasmRAKsLlgNiGYvOQDSvpkkCQBCcXQ6TetF0jA5ImFjj93bd9uM3z/9QYvR p+zIO2pM/OcN0zKT/sEEFURB4c3bngYW13vIWuaHHWt5iLpL0P/NtYxq5MPLct2NgVZx5sNFncP
 1L9/KBg8h4e/PsaIQQmMlumuhbhyeOonxPHsNwduhtR91uborIwonyyA43QH555B57dNnjnP

The sunset period of SHA-1 is approaching [1] and FIPS 140 certificates
have a validity of 5 years. Any distros starting FIPS certification for
their kernels now would therefore most likely end up on the NIST
Cryptographic Module Validation Program "historical" list before their
certification expires.

While SHA-1 is technically still allowed until Dec. 31, 2030, it is
heavily discouraged by NIST and it makes sense to set .fips_allowed to
0 now for any crypto algorithms that reference it in order to avoid any
costly surprises down the line.

[1]: https://www.nist.gov/news-events/news/2022/12/nist-retires-sha-1-cryptographic-algorithm

Acked-by: Stephan Mueller <smueller@chronox.de>
Cc: Marcus Meissner <meissner@suse.de>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: John Haxby <john.haxby@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/testmgr.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 82977ea25db39..797613daf7e33 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4285,7 +4285,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha1),cbc(aes))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(hmac_sha1_aes_cbc_tv_temp)
 		}
@@ -4304,7 +4303,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha1),ctr(aes))",
 		.test = alg_test_null,
-		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha1),ecb(cipher_null))",
 		.test = alg_test_aead,
@@ -4314,7 +4312,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
 		.test = alg_test_null,
-		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha224),cbc(des))",
 		.test = alg_test_aead,
@@ -5156,7 +5153,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "hmac(sha1)",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(hmac_sha1_tv_template)
 		}
@@ -5498,7 +5494,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "sha1",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(sha1_tv_template)
 		}
-- 
2.34.1

