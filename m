Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBBC1DA62F;
	Fri, 13 Sep 2024 13:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726232754; cv=none; b=h9PmflSNOx8fAFLEVIBndJK+E94DY2xRciPsD0hokg67lyAYFDL2Hy6d3bbmL+0hMGGknvPIg/NrXGoobdg8aCfX9gZfSPYWbk7GZMhyVJF4FCkroMu5jlkdzGBASk0G2iMHKHRFVgSHkmSQu+fDQT/sibsTiyKL5ITa5taTEJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726232754; c=relaxed/simple;
	bh=oEl36+voz+qtTGEMNvzWqOVzXnXDCugeAkPm19j4gFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2TFODYZNaQE0kmMQcJnqba7eggcqOrYifYpbuCzkdqqAvmiD8GCXxvaiWzepI+sY8Cox/8mXyM3SjUAzG2ATs2sU6Rc+fQQsq8a3WB5kRrL7ybG50UEg9JbnOT5AG7SaVAmRqXQnRiV1w4bynuSBmANFVT8M0hO5rup6JekzAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=a92qGqf1; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a92qGqf1"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48D6GP55019737;
	Fri, 13 Sep 2024 13:05:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=HuklU5+6a/WK1
	HB92pTW2oH1NQRKsayz43JC79nFsRg=; b=a92qGqf1PubJc5b1e2nelnoWH2ZnU
	NIwIDwyo+B+PSUuqVaXT+mWkcsVCaqL/7hrxI/g347jW4+FMjF3dwdhbPXXVfWBT
	8CL/2TV7yDBPrRoRhFm6z0pBNiWQ5Uo153ZrBL3Eu/mZfQ5GSYpay67WNmTNTsCh
	NWOr1LVGylnNjLOfaNewyKyk2GC2zVOVDoO80oXJlStsFe0vy1Z3vSWv8gVihNUT
	usc+Y1oe3f6glzgTM4G4VaD54HOJnsS3iZe7mbMXoEtUnOO+fMkERqacJ7QxxtNI
	ekRzsVJxRFZ09oingpIPqJgNslzHu3MecvDtIzaNXe9I/LAgTBYsyJODg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gebat3hh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 13:05:49 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48DB04Xc003123;
	Fri, 13 Sep 2024 13:05:48 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 41h15uedrm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 13:05:48 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48DD5jcP31457842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 13:05:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36DA220040;
	Fri, 13 Sep 2024 13:05:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E435420043;
	Fri, 13 Sep 2024 13:05:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 13 Sep 2024 13:05:44 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 2/7] s390/alternatives: Remove ALT_FACILITY_EARLY
Date: Fri, 13 Sep 2024 15:05:38 +0200
Message-ID: <20240913130544.2398678-3-hca@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240913130544.2398678-1-hca@linux.ibm.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jv36OOvX-Fhkyxh3JKZDyR-8Gt1ihtNo
X-Proofpoint-GUID: jv36OOvX-Fhkyxh3JKZDyR-8Gt1ihtNo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_10,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=715 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409130091

Patch all alternatives which depend on facilities from the decompressor.
There is no technical reason which enforces to split patching of such
alternatives to the decompressor and the kernel.

This simplifies alternative handling a bit, since one alternative type is
removed.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/alternative.h | 6 +-----
 arch/s390/kernel/entry.S            | 2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/alternative.h b/arch/s390/include/asm/alternative.h
index de980c938a3e..73e781b56bfe 100644
--- a/arch/s390/include/asm/alternative.h
+++ b/arch/s390/include/asm/alternative.h
@@ -39,11 +39,7 @@
 #define ALT_TYPE_SHIFT		20
 #define ALT_CTX_SHIFT		28
 
-#define ALT_FACILITY_EARLY(facility)	(ALT_CTX_EARLY << ALT_CTX_SHIFT		| \
-					 ALT_TYPE_FACILITY << ALT_TYPE_SHIFT	| \
-					 (facility) << ALT_DATA_SHIFT)
-
-#define ALT_FACILITY(facility)		(ALT_CTX_LATE << ALT_CTX_SHIFT		| \
+#define ALT_FACILITY(facility)		(ALT_CTX_EARLY << ALT_CTX_SHIFT		| \
 					 ALT_TYPE_FACILITY << ALT_TYPE_SHIFT	| \
 					 (facility) << ALT_DATA_SHIFT)
 
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 749410cfdbc0..269436665d02 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -42,7 +42,7 @@ _LPP_OFFSET	= __LC_LPP
 
 	.macro LPSWEY address, lpswe
 	ALTERNATIVE_2 "b \lpswe;nopr", \
-		".insn siy,0xeb0000000071,\address,0", ALT_FACILITY_EARLY(193),		\
+		".insn siy,0xeb0000000071,\address,0", ALT_FACILITY(193),		\
 		__stringify(.insn siy,0xeb0000000071,LOWCORE_ALT_ADDRESS+\address,0),	\
 		ALT_LOWCORE
 	.endm
-- 
2.43.0

