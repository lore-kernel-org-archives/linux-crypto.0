Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1342367AC;
	Wed, 17 Dec 2025 23:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766015117; cv=none; b=VfEIf8++9DQ1/j8JsS9V1jugdvzQTb77u5bRy+j4jrKHmIvMV0KHJ7jjxAEnw7xt2e5QXXG8cqDE4IfzeGjWB7Fr0gMZrcQrPhywP9YSuIdI+sEJBRpfLWZN0wTcjvy4Nd7924p5BNmR7Vp1qEniSqJltXRCqI2lYIhexNl32Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766015117; c=relaxed/simple;
	bh=FSAWjKfiYlIaOFKkJJMQ0DwcxDZ2QuCkAongut8bT3k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MyJXzab+uJtdt432FeXzhIiVRk8+T1WvJfPDPa2K89FftLsjUE9UwVRbAWnL/3j/fJN0tXD56GqnaLDfxng4ellYa9tsFmLyiKttRNcvpV8rRWXYnkXGDuZ2FnzbMY2X8LMMYjYfqTwWlHDsaC+uWt1xezYKvTeDHNixzOdbnZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f2BYzEhB; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f2BYzEhB"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BHMNQur3691296;
	Wed, 17 Dec 2025 23:45:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=pRlZxKN6cZjMLf7FsCjeQ5Zsys1UM
	vhS1bG0w8it7ow=; b=f2BYzEhB7irzwEZJjNDsq+5C4rowVpvqDT0XGxGKTRlqJ
	cJspcxEzZM+RwnvbOz9eWxbYEiG1eT5uHAimfedvhQ1nU8QSS8s1EZm/w87EnFw6
	juKDcWaeVuZVUCKp4yk8f0PZOnPN2Gb135UveOEb0BzIygBuvXRFDpTHiX3Bfgha
	uN7tWMRZTEqv43FT2ieDWqlNb9/IyQpCmP+BPAAdn3tbEBQ97xBarRgHUgcm9UhS
	lJTERi4+9pt0+rKWD/XhMJEs1KS+s/V1BjIWGAWD24cE+nI7yutime1xIK35z0b/
	V2T0Yaf9jI4ypnpYBeFRs6cruHNh/S+1nBuPXtdJw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xja6xnf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 23:45:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHN21rO022487;
	Wed, 17 Dec 2025 23:45:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkn7bxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Dec 2025 23:45:08 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BHNj8SZ012536;
	Wed, 17 Dec 2025 23:45:08 GMT
Received: from bur-virt-x6-2-100.us.oracle.com (bur-virt-x6-2-100.us.oracle.com [10.153.92.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkn7bx4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Dec 2025 23:45:08 +0000
From: Ross Philipson <ross.philipson@oracle.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, Jason@zx2c4.com, ardb@kernel.org,
        ross.philipson@oracle.com, dpsmith@apertussolutions.com,
        kanth.ghatraju@oracle.com, andrew.cooper3@citrix.com,
        trenchboot-devel@googlegroups.com
Subject: [PATCH] crypto: lib/sha1 - use __DISABLE_EXPORTS for SHA1 library
Date: Wed, 17 Dec 2025 15:38:26 -0800
Message-ID: <20251217233826.1761939-1-ross.philipson@oracle.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170191
X-Authority-Analysis: v=2.4 cv=TbWbdBQh c=1 sm=1 tr=0 ts=69434085 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=t1JBmMD2VwWszxNfJCEA:9 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDE5MCBTYWx0ZWRfXwajUwJnimeTz
 2kCmjj2cUMXwGHCq/8lU16x7nDAMOOvIE9b7mhR+222PBip+blksfxISJtBqX/WCcygZwUgxftz
 x+QpwPovzND6pqLHYPIQD3hZBuD+NOZoxnVSsgM9xa6zxZgB4g2aLCVZ3TVHcDgCt6d68uocm7j
 TdVXe7DfoNGxXRlLBHsyED+YmCHtd9E/AJTd/L2K8bFKo1k6qxiYVnSAhNRyfhZhBDMDoQ2dpSC
 hfu98dvfZUI5/syNqDlXfHhjzaNagkxmTGjHNN2p48d/jauMZNJRVFJP8nOOaC1Zvwy/D/zlgL0
 2b69leMhB0z38rOcKM4eU9wKRmY9zMDmz/gXgvKTgXO+Ux5gnmlWpgI2bsvOUJXdvIuYuab04gi
 IkFF59GMPK3HwkONRFv6wfMPhCiKpX0Euot84gCwoYDyCeW9U/Q=
X-Proofpoint-ORIG-GUID: 8os9z9u9h2oAFAbiPOZJL5GZhoqq5Bsl
X-Proofpoint-GUID: 8os9z9u9h2oAFAbiPOZJL5GZhoqq5Bsl

Allow the SHA1 library code in lib/crypto/sha1.c to be used in a pre-boot
environments. Use the __DISABLE_EXPORTS macro to disable function exports and
define the proper values for that environment as was done earlier for SHA256.

This issue was brought up during the review of the Secure Launch v15 patches
that use SHA1 in a pre-boot environment (link in tags below). This is being
sent as a standalone patch to address this.

Link: https://lore.kernel.org/r/20251216002150.GA11579@quark
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ross Philipson <ross.philipson@oracle.com>
---
 lib/crypto/sha1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
index 52788278cd17..e5a9e1361058 100644
--- a/lib/crypto/sha1.c
+++ b/lib/crypto/sha1.c
@@ -154,7 +154,7 @@ static void __maybe_unused sha1_blocks_generic(struct sha1_block_state *state,
 	memzero_explicit(workspace, sizeof(workspace));
 }
 
-#ifdef CONFIG_CRYPTO_LIB_SHA1_ARCH
+#if defined(CONFIG_CRYPTO_LIB_SHA1_ARCH) && !defined(__DISABLE_EXPORTS)
 #include "sha1.h" /* $(SRCARCH)/sha1.h */
 #else
 #define sha1_blocks sha1_blocks_generic
-- 
2.43.7

