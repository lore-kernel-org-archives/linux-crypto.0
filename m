Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8B91D47C1;
	Fri, 15 Nov 2024 14:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731682056; cv=none; b=lChZEaQbF8lrZDE408u+Kxbue8rs8+Dw8qlF59Y6DYIVHs0DN2MLXyc56Es8xpWF8aOdppqhrqbVmbBF6hHPKeentzyEFZFsRmRLldEMZ4GbI5xK3Ka4kDsWIhtZlQF3MYlAFEZPQKDDDnt3vbzBMfKcmMEpACR4wMlkAqBuLoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731682056; c=relaxed/simple;
	bh=ADFRSAzm+tOB1BuB5MVG+obXR3rDsoHWpt6GfHSel0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wpo5NjHrJ0edFW82PuhM8OHwdUa/vJCQCrTwU8ToI5DwNyZzPcxhPcMZiNrrkIfziLOz7Ta/1yD3OF5UCuTjDG/pjKJdFPcFhL1NDc+3IOEOCgZHort0EvezKw9fScDz9uwPXW+xGrfue5ewdakI2G7pCWgTapNpMY1LtUX1/+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ciKlvMMj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ciKlvMMj"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFAYiEH008607;
	Fri, 15 Nov 2024 14:47:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zqw2cRGCyNuHDcmTc
	mmMEA0nDM95Ca6wVjUxbwztkD0=; b=ciKlvMMj2to3Z/+D5m6BQwvMmKAT+w8/9
	FkjTsE+/LNXYoN6qRA2xHv8hnNjwhF4KBjT8c2w/fzkVUZ5HT2Cd8YzrdPkVghM8
	eRTVJdRcS6AbGfYBY5J1VIhA4Wpl9EPB2B+RVDA2YIxz2jcqBlRFBnKo0vTlBDbf
	R1Lmhge++lf+6fK7kj6WZSQdMp18mLPta6ny8bsnCFp/husIBi5s8/m/2WONC9pT
	u1FhhporW41MJFngdEqymtl1eyMG9LmvPOy97WLrmYwJse/m4ttgHbN93w+r5lwH
	JwJywHtemOk+vsRLt9xNZWOCrta+JNw4L7A4PTrus30aOKQnC/6Aw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42wt6wbvsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 14:47:30 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF42RIL010859;
	Fri, 15 Nov 2024 14:47:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42tm9jjdj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 14:47:29 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AFElQxQ44827052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 14:47:26 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 57D912004E;
	Fri, 15 Nov 2024 14:47:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 096722004D;
	Fri, 15 Nov 2024 14:47:26 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.73.203])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 15 Nov 2024 14:47:25 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v4 2/3] s390/crypto: Add protected key hmac subfunctions for KMAC
Date: Fri, 15 Nov 2024 15:47:23 +0100
Message-ID: <20241115144724.12146-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241115144724.12146-1-freude@linux.ibm.com>
References: <20241115144724.12146-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FP0g6b1KJOvg7w0qx98taEfk1PKjf4Dv
X-Proofpoint-GUID: FP0g6b1KJOvg7w0qx98taEfk1PKjf4Dv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=618 lowpriorityscore=0 clxscore=1015 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411150124

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

