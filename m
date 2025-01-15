Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2025F14D2B9;
	Wed, 15 Jan 2025 16:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736958160; cv=none; b=qjLVmcInTwlnniFfMmLtgeFDafb4jNEFXZjZA5/gj29K6hwHxY/+TGH7rF5zj2AIUizWewgfqJvsBtMq3YAhZrIXHlR9BFc8lLoO7jOsBq/xBK5ZvUe7kZqdk/ENDyFN3Ao5Ns3b+xybFgh56b2q78m1gG2FBhaiKbUqb5gx+r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736958160; c=relaxed/simple;
	bh=ADFRSAzm+tOB1BuB5MVG+obXR3rDsoHWpt6GfHSel0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLocQ1lmI3xkyJ0+MU/Awcyn2BREGW7EelCdUPFZxq70dweM4TupE+stzQceVD1zrkEmJ+b1bKVPLAc5PO1CM42+3eBKwnejub10jH/rTJquKj8geKxIGqCN4K1jFAv7CXBYK91c13bclaxm11jb5wt12xfVkArjCNAHb9PJsCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nfch8q12; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nfch8q12"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FGK98k025951;
	Wed, 15 Jan 2025 16:22:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zqw2cRGCyNuHDcmTc
	mmMEA0nDM95Ca6wVjUxbwztkD0=; b=nfch8q12uY7P2zqM/vX+xP2NSN7GrMDoK
	ViGe+rl95UbtP7NDL+6OwzA9me/CU6SOh2lapjAme5lC7pUtLHxQ15c0CgZJyGb2
	TefT45UuhVjgkUOqbNgiZQdcJctBKomhBQ7jR1K+GLh7vcwFmJt+KqogrLgPyr1K
	XODZdaXifUwJE5zZkYRGsgONJT7MXe5VPD7SJx8kK3WBZqa6xKNhCAEtg9VRSVBp
	giqDgXbJIFRaA6OGyGrqF+RRF8gVBiVDdP4gjV4GKALsDoaIGkxl2CV88laMHTV3
	EH6k9rNoyVCUCfWTrTjJM7Ee+9E9I6V8WIRa7Kz0E5hYJH6YWfqtg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4469732ata-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 16:22:35 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FFW6C9016512;
	Wed, 15 Jan 2025 16:22:34 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4445p1rwdf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 16:22:34 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FGMWbf14090656
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 16:22:32 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C354A20040;
	Wed, 15 Jan 2025 16:22:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77FB12004D;
	Wed, 15 Jan 2025 16:22:32 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.28.131])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Jan 2025 16:22:32 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v10 1/5] s390/crypto: Add protected key hmac subfunctions for KMAC
Date: Wed, 15 Jan 2025 17:22:27 +0100
Message-ID: <20250115162231.83516-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250115162231.83516-1-freude@linux.ibm.com>
References: <20250115162231.83516-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EiR_98JeJGFiiNKA89paq8DmeeuM1upA
X-Proofpoint-GUID: EiR_98JeJGFiiNKA89paq8DmeeuM1upA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_07,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 suspectscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=590 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150119

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

