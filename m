Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937D51DA0E4;
	Fri, 13 Sep 2024 12:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726230683; cv=none; b=rd+galx5vKj5tCdQ+GsQc7FDOlCSPtP1rzXDXjMA/iLCVGBYKxASaqaItyPaZwpbzFvGBc/dsEgMxjn0sCh18j2lr4FweNnonB/xwraJdjIgBEDrw62hwmxMdMNIS6YOlekDMPNt6NNlgpQyXeeLcm3HcO2WeWtYX/91SFZccdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726230683; c=relaxed/simple;
	bh=E1neStRKpDV1ybNDML73uIi6mzKFNyw5RvgMSwRZ8vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WZPv5dcfWbqZjua4khIL+iMomBgcXai/61OIOQAhQNEzkEvXL9x/4lKwruc6qiI+EnATjRzkhdNzD1XmAskHYpUDPMhju+weoSWh1CgTI3XOTQCV5AEaMzSGbEQnJc2pwT9C4/f4Zq/k0uuWCb/vIMC7HzfVOr8cNtWgFoYjNMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tj3oRyoe; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tj3oRyoe"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48D5v5xx027443;
	Fri, 13 Sep 2024 12:31:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=XWboUu/QhdmpUYTzcZAlK6rwdL
	NtbtFc5AGbr7j7R3w=; b=tj3oRyoeXkKjt2dKlMYdVDZtxCMuhfK2AZuKOqkwuB
	jR2O2PxGJ0ts5GI2KuWHZAwnve61TK3iPEJeW/yi3PcRLZu9MdnbN8uAytfEdzVC
	Aj6IkCN8GuNA9bBk4d5chOOida42MVHYgRyOO2hok0oByZOY24uh8XwffxqIUDWy
	+5WlN3ZRS5YQpOfk6RWa97MkPaXjJAsnxPL+pK4IUdM/OSYHk+u00N9sEQWg2ZF6
	fW37OpPiUiNiSH3uxBCngMLJhgT2sX8S0n4qwK8m+6Uzdt6YV0uGKeboIqaMtoMc
	cn6AQ8iY+fiWH153+Rf9xIQ3/MON77v6oNjDs+kota3g==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gejb1yde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 12:31:07 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48D9cdKf027328;
	Fri, 13 Sep 2024 12:31:06 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 41h3v3nt0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 12:31:06 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48DCV4VN27853388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 12:31:04 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5AEE758056;
	Fri, 13 Sep 2024 12:31:04 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 21C5A5805A;
	Fri, 13 Sep 2024 12:31:04 +0000 (GMT)
Received: from ltcden12-lp3.aus.stglabs.ibm.com (unknown [9.40.195.53])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 13 Sep 2024 12:31:04 +0000 (GMT)
From: Danny Tsen <dtsen@linux.ibm.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
        appro@cryptogams.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com,
        Danny Tsen <dtsen@linux.ibm.com>
Subject: [PATCH] crypto: Removing CRYPTO_AES_GCM_P10.
Date: Fri, 13 Sep 2024 08:30:43 -0400
Message-ID: <20240913123043.1636183-1-dtsen@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -293XIbKKSlAq5Y-fjJeetFTX0HxSbLJ
X-Proofpoint-GUID: -293XIbKKSlAq5Y-fjJeetFTX0HxSbLJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_09,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409130084

Removing CRYPTO_AES_GCM_P10 in Kconfig first so that we can apply the
subsequent patches to fix data mismatch over ipsec tunnel.

Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
---
 arch/powerpc/crypto/Kconfig | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index 09ebcbdfb34f..96ca2c4c8827 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -105,22 +105,22 @@ config CRYPTO_AES_PPC_SPE
 	  architecture specific assembler implementations that work on 1KB
 	  tables or 256 bytes S-boxes.
 
-config CRYPTO_AES_GCM_P10
-	tristate "Stitched AES/GCM acceleration support on P10 or later CPU (PPC)"
-	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
-	select CRYPTO_LIB_AES
-	select CRYPTO_ALGAPI
-	select CRYPTO_AEAD
-	select CRYPTO_SKCIPHER
-	help
-	  AEAD cipher: AES cipher algorithms (FIPS-197)
-	  GCM (Galois/Counter Mode) authenticated encryption mode (NIST SP800-38D)
-	  Architecture: powerpc64 using:
-	    - little-endian
-	    - Power10 or later features
-
-	  Support for cryptographic acceleration instructions on Power10 or
-	  later CPU. This module supports stitched acceleration for AES/GCM.
+#config CRYPTO_AES_GCM_P10
+#	tristate "Stitched AES/GCM acceleration support on P10 or later CPU (PPC)"
+#	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
+#	select CRYPTO_LIB_AES
+#	select CRYPTO_ALGAPI
+#	select CRYPTO_AEAD
+#	select CRYPTO_SKCIPHER
+#	help
+#	  AEAD cipher: AES cipher algorithms (FIPS-197)
+#	  GCM (Galois/Counter Mode) authenticated encryption mode (NIST SP800-38D)
+#	  Architecture: powerpc64 using:
+#	    - little-endian
+#	    - Power10 or later features
+#
+#	  Support for cryptographic acceleration instructions on Power10 or
+#	  later CPU. This module supports stitched acceleration for AES/GCM.
 
 config CRYPTO_CHACHA20_P10
 	tristate "Ciphers: ChaCha20, XChacha20, XChacha12 (P10 or later)"
-- 
2.43.0

