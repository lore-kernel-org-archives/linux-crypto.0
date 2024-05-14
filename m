Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937401802AA;
	Tue, 14 May 2024 17:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715708347; cv=none; b=jIFU70ybIZInIruBHnDCneREcl7lx6yEoLWoNDsqqzPrqVXBwXl3sZ8xtpqETpNPnLSnKpUVeEoc4qDM1E/NPvbgJLxqkl/TRHN7Tpkbmai8O7YTP1P9I6spXBHh8JHErz5kctyCaCRNSnuAaTkczcvdS/5Sk4ni+QifsH3WBvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715708347; c=relaxed/simple;
	bh=DwwO1s19angZnpfVZnhLVaPJ2gA2nRu5OBCzD1YtfMk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OY7sNWsc/+ZVP9ETSk/PV723NlZAQ/Vnoi2NIQhQATk/lgyK567W4NDaCvpGCvT6tYbGQX4klCE7awV2cAF0aUacR5Xew1DCDj7bz8Obbe14xtxVIZGEF2tYuAS2+tBMFs583TeTyzrqQsl/FuUeLX+Kiv+1+3dPozs5pXekn/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MTzZoUNh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MTzZoUNh"
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44EGt7X6029947;
	Tue, 14 May 2024 17:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5nMelTmMbO56bSQrp6/Ccu6IA7pxu29++FFJZKkFP4U=;
 b=MTzZoUNh9YXVb2zbET9ufRrd321boIEDHr3ieK8djYMKd3QfCBcOf+DLXgkbjQ9z4JlI
 RhANubjf6KII5jU7yxs0OAqCB2MUbN5AJHl/0jVPX3llGKbC/hJyi7YS0I1vw/RmKKBD
 37UpuMt7iDVBMfokaJKbn7RSvYF/Byq2i+HpsNDmd4N70S/2U513C8SEzZ6GFHl4PHMT
 i9n0fqtJM2sUmNzYf/WjYbBFImhwTE4E1hEiFd0d5jxATS1Vym9WlmWFSNADaKSU3Y1D
 CoTopZ/0c2PUX5bXaKWtfYGVbXbQcAsgymI7DeNOKFM2Nc2IIuUnh9RC/GTKzl/0gdRC LA== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y49xw8ej4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 May 2024 17:38:49 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44EEdg1X020385;
	Tue, 14 May 2024 17:38:48 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y2kcyxw6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 May 2024 17:38:48 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44EHciqt57213284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 17:38:47 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D841D5805D;
	Tue, 14 May 2024 17:38:44 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9009A58068;
	Tue, 14 May 2024 17:38:44 +0000 (GMT)
Received: from ltcden12-lp3.aus.stglabs.ibm.com (unknown [9.40.195.53])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 May 2024 17:38:44 +0000 (GMT)
From: Danny Tsen <dtsen@linux.ibm.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
        appro@cryptogams.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com,
        Danny Tsen <dtsen@linux.ibm.com>
Subject: [PATCH 3/3] crypto: Update Kconfig and Makefile for ppc64le x25519.
Date: Tue, 14 May 2024 13:38:35 -0400
Message-Id: <20240514173835.4814-4-dtsen@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240514173835.4814-1-dtsen@linux.ibm.com>
References: <20240514173835.4814-1-dtsen@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oK-3OgBslUkL7l-hUg4is-GPpWnq1JHg
X-Proofpoint-ORIG-GUID: oK-3OgBslUkL7l-hUg4is-GPpWnq1JHg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-14_10,2024-05-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 mlxlogscore=685 impostorscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405140124

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

