Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8DE138490;
	Fri, 22 Nov 2024 14:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732286379; cv=none; b=baD39FtkNROlr/0VCEianx0fLRf6uNKc6LTstsh0WHh/XQz0iOtdR1wgFKsbptTQzZU1yvy/FTChN3mxqDstZM/pcxbUoRUi8UNZF77ALDDUK/j+HBK0cCXCUuItzhMbzgri53kTpAI1UCNdijXdkbFICT+PfoxBzSMKcrDMDV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732286379; c=relaxed/simple;
	bh=ADFRSAzm+tOB1BuB5MVG+obXR3rDsoHWpt6GfHSel0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3UXi8MQidQQmBQd2/oYvswpXuOzr2OHkNvaK9xxpcx2akYi972QU0Z+V/AHJSNQC0VokYwN5iKEUhD7c7A/Gj/oFI60W05+1swUlwFDsriGhtyvA+I+ImC4SK7kVyucvUyOHRx1Ony7+fcInQ2l98TwmbwD8/DWKllPY21Jxws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ljGVKkBV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ljGVKkBV"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AMCa6vS016849;
	Fri, 22 Nov 2024 14:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zqw2cRGCyNuHDcmTc
	mmMEA0nDM95Ca6wVjUxbwztkD0=; b=ljGVKkBVjcJsSZM4MOMiZAfrdVpztC4/R
	yofPVlZMgFEMGEuYMgENomBW723hqpWHuEttXKEmoeOzY+JjAMgR0TtcUh2Ra4na
	fVEnVt1zxoVDSUieHfy0Mr+ZEhXQpCVLCZaLo9spoU1I/NMS77/fiEzbENUAJPgg
	TZObPgzX5X2+8Sw8e8acfQfKLvaXb8e/XQwxyYBrypWvVF8ZTgDEbtbBaZKBYbhV
	iyKUbgV94WyPFY3Bxtxu6Nwv9y4Dv79EosL8Jcea7UD1suF7gHe7O0lJfD5OU8aC
	9bC1HywzKyjMLq6CA4uZ6kutX5aXFgtKyrhe9JyJIZxBB+v7GrpJA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42xgttsu1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 14:34:31 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AMAC2Hu021833;
	Fri, 22 Nov 2024 14:34:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42y6qn39r6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 14:34:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AMEYTIS56295900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Nov 2024 14:34:29 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDEC220040;
	Fri, 22 Nov 2024 14:34:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BAB712004F;
	Fri, 22 Nov 2024 14:34:28 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.82.52])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 22 Nov 2024 14:34:28 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v5 2/3] s390/crypto: Add protected key hmac subfunctions for KMAC
Date: Fri, 22 Nov 2024 15:34:26 +0100
Message-ID: <20241122143427.135682-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241122143427.135682-1-freude@linux.ibm.com>
References: <20241122143427.135682-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SpzeqeRKa8iovjHIvOI-GJr9dMTHwT4R
X-Proofpoint-ORIG-GUID: SpzeqeRKa8iovjHIvOI-GJr9dMTHwT4R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=584 adultscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411220122

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

