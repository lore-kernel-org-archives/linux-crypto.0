Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88941155726;
	Fri, 29 Nov 2024 11:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732878668; cv=none; b=lOph8aWHa8wMUbcLVo7j7CDoH81Jzo0oEupX+fbZLuA/Ixxl46MuGdnvBE9CPyd6NF48ebdTs1uA4HyiLurIqo11HOh7Ew7h2eqek9Fa8QCeZb6aex1ox/dQVaI1x+C0lj6otwS9agsU7Kc+mMYyAp1eoJUVJ2SnFOiER5mKz9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732878668; c=relaxed/simple;
	bh=ADFRSAzm+tOB1BuB5MVG+obXR3rDsoHWpt6GfHSel0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7VaPM7L4K6kXpWH2X1sKYor5PeauYFWD0xyVkMwtKyLF5+6cnzSGwawaKaCGjlHyXAXEwdrxra3gbqD5HnNGCZaHtGheqKLQFqxhESGDisuvEDtkWG2Ray+c9jL/A5rEYswyAnOCcY+CmSpaPV6KYrUQx/IyI0VL4SbgALFmig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qyqvdYjy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qyqvdYjy"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AT539Vq003054;
	Fri, 29 Nov 2024 11:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zqw2cRGCyNuHDcmTc
	mmMEA0nDM95Ca6wVjUxbwztkD0=; b=qyqvdYjyHZtn2qSbnHeKc7gVydD1CJuS6
	T+Snqe8oKeSywk/YPnhht1V6EGwi97PNl+u/J74Hh99cRJlGz1Mwm6GBIpEQPITY
	oMMIb/sg0OUFO5d2G6LW4SH4JFMCFzK325bQ3QCGaRqhgCpBvugNpGu3QCceKccK
	At/yXs+OF0hNdV0YXGV/a//5z6UouC36dM9bxDR4tLaVDP/WhQGJiZ8uI4l7mORh
	0WcH3lmHMQrCKuWb6BMS/UTHODP+3nkzSpQcbSu3sACgOY8AIB8jWTN1hkYj/ZZ2
	WzbPB9VoGqHLicDldA/+Ra9gHk7ZKkHJ83964JhVLD2VFUXn2dFiw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 436tbecvqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 Nov 2024 11:11:03 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4ATA5Hud009323;
	Fri, 29 Nov 2024 11:11:02 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43672duqkq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 Nov 2024 11:11:02 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ATBB0lt36372988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Nov 2024 11:11:00 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1AC5B20040;
	Fri, 29 Nov 2024 11:11:00 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC0EE2004D;
	Fri, 29 Nov 2024 11:10:59 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.44.200])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 29 Nov 2024 11:10:59 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v6 1/2] s390/crypto: Add protected key hmac subfunctions for KMAC
Date: Fri, 29 Nov 2024 12:10:57 +0100
Message-ID: <20241129111059.303905-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241129111059.303905-1-freude@linux.ibm.com>
References: <20241129111059.303905-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gAetbsLitNRYDa3tm86s5SzKTTNxXs7p
X-Proofpoint-ORIG-GUID: gAetbsLitNRYDa3tm86s5SzKTTNxXs7p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=655 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2411290090

From: Holger Dengler <dengler@linux.ibm.com>

The CPACF KMAC instruction supports new subfunctions for
protected key hmac. Add defines for these 4 new subfuctions.

Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 arch/s390/include/asm/cpacf.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/include/asm/cpacf.h b/arch/s390/include/asm/cpacf.h
index 59ab1192e2d5..0468dd5c4690 100644
--- a/arch/s390/include/asm/cpacf.h
+++ b/arch/s390/include/asm/cpacf.h
@@ -129,6 +129,10 @@
 #define CPACF_KMAC_HMAC_SHA_256	0x71
 #define CPACF_KMAC_HMAC_SHA_384	0x72
 #define CPACF_KMAC_HMAC_SHA_512	0x73
+#define CPACF_KMAC_PHMAC_SHA_224	0x78
+#define CPACF_KMAC_PHMAC_SHA_256	0x79
+#define CPACF_KMAC_PHMAC_SHA_384	0x7a
+#define CPACF_KMAC_PHMAC_SHA_512	0x7b
 
 /*
  * Function codes for the PCKMO (PERFORM CRYPTOGRAPHIC KEY MANAGEMENT)
-- 
2.43.0

