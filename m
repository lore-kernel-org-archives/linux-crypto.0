Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AC914D45E;
	Thu, 16 May 2024 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715872826; cv=none; b=M5C/QsTb2kY9n00jAMy5pqTmDPncfwLbRRkOuK2e0o6SxCQaauo5x8BLBX+NJ8WNL4JRexM71/i72gR8LNYrHlymg1BToDSeEd5GRvCE+Wvez+1+FKOUx4aJNGyRJtYHBXG+iEYW3pKuuybtX1ZPECWJyyOMjy8/wd2FwaJtETg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715872826; c=relaxed/simple;
	bh=DwwO1s19angZnpfVZnhLVaPJ2gA2nRu5OBCzD1YtfMk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KyVqQAO++9ipjA8ELgeGKe8PvN/yBhylhyR9FpL4ZXp8bA8/wx4GsY2bWoD7Pb9NR5h0JOV3rw5M7MMKeYCTI6jQUz6cHX1ID3YIh7dthq73g20hWzGOkXY4JbLsJyEGl3Siz3NgQvVjm0fcll0Rv6nSgO1u5xC2g0EdsUlh5aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dJij+bKi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dJij+bKi"
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44GDEIhu030613;
	Thu, 16 May 2024 15:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5nMelTmMbO56bSQrp6/Ccu6IA7pxu29++FFJZKkFP4U=;
 b=dJij+bKi7kBQOHgGxhLbhz2xsJmhQRTSgasK+VeKofOBTS/b5WKGEt6jR+tNi7FWksy3
 T3Oipu+qBvcvCqgKRTXkyLlw/Hff9eTsjMdMhEm5LAHvqmln1IvzlQyg0mk2wrHBBKOV
 wZ68PWPmJh3OV3qdsPjHfL/vadtrBkKWaaSjtBx3sjcpfSqXPjw84+yfpbaAAtuGTHP1
 KqUrQ/9ZwBH0XzHiN6/zWWZ31eJxW70b6zGTuIjckBRcke2YAUE0kJMhVj+n/7JER/M8
 9P9QUsy6Ib44oXh3MPjHRL7MO5Igk6YbwWueftxbBcUTCYsv9U2GGycEwbk3clwi68dB sQ== 
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y5ju60bdf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 15:20:10 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44GC3Bk8029599;
	Thu, 16 May 2024 15:20:08 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y2n7m29fx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 15:20:08 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44GFK56V39059846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 May 2024 15:20:07 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D98CE58078;
	Thu, 16 May 2024 15:20:03 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A0FFD5806B;
	Thu, 16 May 2024 15:20:03 +0000 (GMT)
Received: from ltcden12-lp3.aus.stglabs.ibm.com (unknown [9.40.195.53])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 May 2024 15:20:03 +0000 (GMT)
From: Danny Tsen <dtsen@linux.ibm.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
        appro@cryptogams.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com,
        Danny Tsen <dtsen@linux.ibm.com>
Subject: [PATCH v2 3/3] crypto: Update Kconfig and Makefile for ppc64le x25519.
Date: Thu, 16 May 2024 11:19:57 -0400
Message-Id: <20240516151957.2215-4-dtsen@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240516151957.2215-1-dtsen@linux.ibm.com>
References: <20240516151957.2215-1-dtsen@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MP_AHtOf1pFp6RPU5qSUDGVev9rTglGp
X-Proofpoint-ORIG-GUID: MP_AHtOf1pFp6RPU5qSUDGVev9rTglGp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-16_07,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=678 suspectscore=0 phishscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405160108

Defined CRYPTO_CURVE25519_PPC64 to support X25519 for ppc64le.

Added new module curve25519-ppc64le for X25519.

Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
---
 arch/powerpc/crypto/Kconfig  | 11 +++++++++++
 arch/powerpc/crypto/Makefile |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index 1e201b7ae2fc..09ebcbdfb34f 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -2,6 +2,17 @@
 
 menu "Accelerated Cryptographic Algorithms for CPU (powerpc)"
 
+config CRYPTO_CURVE25519_PPC64
+	tristate "Public key crypto: Curve25519 (PowerPC64)"
+	depends on PPC64 && CPU_LITTLE_ENDIAN
+	select CRYPTO_LIB_CURVE25519_GENERIC
+	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
+	help
+	  Curve25519 algorithm
+
+	  Architecture: PowerPC64
+	  - Little-endian
+
 config CRYPTO_CRC32C_VPMSUM
 	tristate "CRC32c"
 	depends on PPC64 && ALTIVEC
diff --git a/arch/powerpc/crypto/Makefile b/arch/powerpc/crypto/Makefile
index fca0e9739869..59808592f0a1 100644
--- a/arch/powerpc/crypto/Makefile
+++ b/arch/powerpc/crypto/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_CRYPTO_AES_GCM_P10) += aes-gcm-p10-crypto.o
 obj-$(CONFIG_CRYPTO_CHACHA20_P10) += chacha-p10-crypto.o
 obj-$(CONFIG_CRYPTO_POLY1305_P10) += poly1305-p10-crypto.o
 obj-$(CONFIG_CRYPTO_DEV_VMX_ENCRYPT) += vmx-crypto.o
+obj-$(CONFIG_CRYPTO_CURVE25519_PPC64) += curve25519-ppc64le.o
 
 aes-ppc-spe-y := aes-spe-core.o aes-spe-keys.o aes-tab-4k.o aes-spe-modes.o aes-spe-glue.o
 md5-ppc-y := md5-asm.o md5-glue.o
@@ -29,6 +30,7 @@ aes-gcm-p10-crypto-y := aes-gcm-p10-glue.o aes-gcm-p10.o ghashp10-ppc.o aesp10-p
 chacha-p10-crypto-y := chacha-p10-glue.o chacha-p10le-8x.o
 poly1305-p10-crypto-y := poly1305-p10-glue.o poly1305-p10le_64.o
 vmx-crypto-objs := vmx.o aesp8-ppc.o ghashp8-ppc.o aes.o aes_cbc.o aes_ctr.o aes_xts.o ghash.o
+curve25519-ppc64le-y := curve25519-ppc64le-core.o curve25519-ppc64le_asm.o
 
 ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
 override flavour := linux-ppc64le
-- 
2.31.1

