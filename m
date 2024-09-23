Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710E619993B;
	Mon, 23 Sep 2024 13:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727098270; cv=none; b=a4flBj/Dnb+E2xuWqthSf4Yiywkf5ucEsR6lfREc3t4uE1CI2MDcNEREPXsVIcwZENvqEfBOKBFQuImtZmn0kctQ3IyosqlwCtu0+M5KHyRXHoT6c35kpC/N+g6/+nC42DeZhfgqv1w+AD+pCSi2Z0B1xib0MsScqePqT0jbK7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727098270; c=relaxed/simple;
	bh=Ss/EtoccCyESZ7ERJmnmcrAqXBKWTB53fXWkCP6srxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swJkpcwMPKHP7SuwE4OTf7sDYhMSnKi6Xe+G6sGk1cZjN0VwG0XuJxqTE3jXUbQFAOd3nZ++nYw8ImdZJtZMsGFTrzw03222ogX97veNmCxvRd6r4IREQsa3PHQxxM1VcDKndypn/MbRRKwktBwfkyyaw7sU1NJ7uFja/BxGkV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hg9wFZ6R; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hg9wFZ6R"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48N1qrBw022199;
	Mon, 23 Sep 2024 13:30:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=u7k5SwI6chCIk
	sCZz8Hi2DUWn3zMg3MUHqjtPjnnnwI=; b=hg9wFZ6Rd1sP01JpFDlNGN2PJ51ZU
	bKCifHe2jBfpBc6+baLTY2cvHfl+vZbmWn2OfMPELbLatvzSlue1TGrHqlRLN3WO
	UiW863CvPoUVDAwI7NXNrozA7zKqecGtiqZ+sSWm8bGyfwhXX0y/6kloCbE1Bp2W
	7XWgBVU18ykMTAvWv7nwuXcP9TaUtHUtCtkMB2GT1o9dxUErrDMUnCsTtAGuympY
	6K1pqZ29fYHRHpl/RCWzlJfhbfCJX1oHyDTDVXqiqgiPdAXLQ867nZp8IZ4uZJ2r
	Kty9flSJmqOBehZNEhyQa1cn2/0gHSIcEbLdH9XsPeGR71w29wZvg6gaw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41sntw46ek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Sep 2024 13:30:54 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48NAwTQn008701;
	Mon, 23 Sep 2024 13:30:51 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41t8v0xww8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Sep 2024 13:30:51 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48NDUnGh33489364
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 13:30:50 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C16FD5805A;
	Mon, 23 Sep 2024 13:30:49 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D6985805C;
	Mon, 23 Sep 2024 13:30:49 +0000 (GMT)
Received: from ltcden12-lp3.aus.stglabs.ibm.com (unknown [9.40.195.53])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 23 Sep 2024 13:30:49 +0000 (GMT)
From: Danny Tsen <dtsen@linux.ibm.com>
To: linux-crypto@vger.kernel.org
Cc: stable@vger.kernel.org, herbert@gondor.apana.org.au, leitao@debian.org,
        nayna@linux.ibm.com, appro@cryptogams.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com,
        Danny Tsen <dtsen@linux.ibm.com>
Subject: [PATCH 3/3] crypto: added CRYPTO_SIMD in Kconfig for CRYPTO_AES_GCM_P10.
Date: Mon, 23 Sep 2024 09:30:40 -0400
Message-ID: <20240923133040.4630-4-dtsen@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240923133040.4630-1-dtsen@linux.ibm.com>
References: <20240923133040.4630-1-dtsen@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VMTLlQ3Y2GYVfKo8jqx_hYOZoqfcDzAQ
X-Proofpoint-GUID: VMTLlQ3Y2GYVfKo8jqx_hYOZoqfcDzAQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-23_10,2024-09-23_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=864 bulkscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409230099

Added CRYPTO_SIMD for CRYPTO_AES_GCM_P10.

Fixes: 45a4672b9a6e ("crypto: p10-aes-gcm - Update Kconfig and Makefile")

Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
---
 arch/powerpc/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index 46a4c85e85e2..951a43726461 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -107,12 +107,12 @@ config CRYPTO_AES_PPC_SPE
 
 config CRYPTO_AES_GCM_P10
 	tristate "Stitched AES/GCM acceleration support on P10 or later CPU (PPC)"
-	depends on BROKEN
 	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
 	select CRYPTO_LIB_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_AEAD
 	select CRYPTO_SKCIPHER
+	select CRYPTO_SIMD
 	help
 	  AEAD cipher: AES cipher algorithms (FIPS-197)
 	  GCM (Galois/Counter Mode) authenticated encryption mode (NIST SP800-38D)
-- 
2.43.0

