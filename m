Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE221A2398;
	Thu,  2 Jan 2025 09:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735811185; cv=none; b=kDyoE23M7y5wmJJtz9VXXoMhpUKMT+iBhfmJaIw9hLCnlNVxdhSO06m5TCvs/awch9W6S7uJ92nWmduokaqPG/C/pRyJ2o+Z8WCIwpY2UDDVUqq87kG7KOFur5i5RupWcLMooHdzrNek+q/d43N67P4s68NZdSBQcf6To8APZ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735811185; c=relaxed/simple;
	bh=ADFRSAzm+tOB1BuB5MVG+obXR3rDsoHWpt6GfHSel0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9+wpCmEsKtQ87Jldq+GhAf8WT74I0JbQukECseaDdvfMQevw7uemwbHhBmsSU/I82c161wdd6D0OmnZ/+zzXxACBQJKAL61QpIIEOJlepgSsVnM8DeBSaesz4nxLDqz+bkrpVlvKD7Qkf5xZGOFe+aMFLYKhNDrKjSf4R4FTRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZK6HOOvH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZK6HOOvH"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5023sO2T004767;
	Thu, 2 Jan 2025 09:46:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zqw2cRGCyNuHDcmTc
	mmMEA0nDM95Ca6wVjUxbwztkD0=; b=ZK6HOOvH79FStNvSCBKNiUlEVFtafnRyh
	uBJjM+2Ehis0diXometWIQko0JQ0zaG9fA02ka71Ez2cpUzS5RYZGWuAhY7Bov1D
	7KarEiP5y+6Gc/AeKf+oOxkVe1Pi6/fv3XAPwMUGL4YHMT0ikW4M6HdPDytKOO3i
	P/WjAoclyw0o5l1odEFCMLA8Jd01u2v7sgQ+hQ5b3m4Do/Ip/TEWdJR9BLZHS9/J
	VSoIJIx/yzOqD9w6Z6v4kard1d1wg/u3NxJALRzPMjVnDIyrjHj6PasRVtu+q9y9
	iNJJplFZUu+6GvksIOeRhPs/nVONVI/+WoclHfbyiDhPZUzJxYpIQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43wk9b93cw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Jan 2025 09:46:20 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50254XA1016711;
	Thu, 2 Jan 2025 09:46:18 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43tw5khfkn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Jan 2025 09:46:18 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5029kGTJ48496908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Jan 2025 09:46:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A64B220043;
	Thu,  2 Jan 2025 09:46:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E1312004B;
	Thu,  2 Jan 2025 09:46:16 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.11.208])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Jan 2025 09:46:16 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v9 1/3] s390/crypto: Add protected key hmac subfunctions for KMAC
Date: Thu,  2 Jan 2025 10:46:13 +0100
Message-ID: <20250102094615.99181-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250102094615.99181-1-freude@linux.ibm.com>
References: <20250102094615.99181-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0B_FaZcCg1OQLDVAYkV2CzDs6v6r726X
X-Proofpoint-ORIG-GUID: 0B_FaZcCg1OQLDVAYkV2CzDs6v6r726X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxscore=0 clxscore=1015 mlxlogscore=595
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501020081

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

