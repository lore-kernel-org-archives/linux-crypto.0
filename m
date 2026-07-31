Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4877C2DC76A;
	Fri, 31 Jul 2026 16:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785516621; cv=none; b=LIMzNYLY2t1Vs6pzXVML57ns2Ib4S6o+arI1ksQZKYeu7/wH6ZIiwO9buOnVJKNRSkCnoGGAy+m3QQPu5c/I6CIF5WYr8floKavUjD5VkW//4MklxDX/co8lXv7xhH3HVkvBG1kKjc30pYcl3S01rYiaxgTNxyI8b8m9ksyojgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785516621; c=relaxed/simple;
	bh=Z97yF8Q1u1qO0m1GpK36D4aBK0XPxOUrAVghs980lbg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GYCi0Tkerbl7BhPLDgVsbMDnMzMyCR3plPWi9XoCGcYDcUuJ5sykCMQDWfjEISZlKgr1yfLUdDPI+38f/2Fr8ocOR50lgn2HfWYiiTKuhMmO8PQD/+hPxL6gbRcUxpzIE5PQqV2J+kc6mFT1yaAwgufaxrbXUgf2wzmt4gziCdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kA2OOXZq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kA2OOXZq"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VFlrTs2192683;
	Fri, 31 Jul 2026 16:50:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=TkQuuD9IGExAR+KBkwqv143fCtYGlXzTpxflQFPrO
	Qo=; b=kA2OOXZq/3kzTrJJcewMK2Ry+JKX5ubJ1II7Rgr4Ioi3GA5VPCVq1ImOu
	YHS8FpbqL8GUdYa+25Q/ztQIeZp7mxy2DK0aBwsQrVSPK1n2D42pdcMLYUDGKJNj
	ipiMi+jJuZExU1zJgv84XLjoG3VETrJLByKP8CvLdH+UFoffvzZ/JUVkhjyDXncU
	WqWkp7oQjSTz6zHxt40JFpB484bQAz6N4lWzqvN+LZTx26NJ/9oEu+6TCTHmVnw9
	5myZcq96UjLTJC6i0wnBCAuNweeAZhvHbUSl0QMb79FZ1qzlQrrDiwVsTQABSQNN
	ONqU34g/FphKiSYEnPJIbs1R050Qw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyjn1y7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 16:50:10 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66VGfKun002896;
	Fri, 31 Jul 2026 16:50:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yhrnbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 16:50:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66VGo5cw41419234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 16:50:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A9F320040;
	Fri, 31 Jul 2026 16:50:05 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB4F02004B;
	Fri, 31 Jul 2026 16:50:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jul 2026 16:50:04 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v4 0/4] s390: Remove or replace cond_resched() calls
Date: Fri, 31 Jul 2026 18:50:00 +0200
Message-ID: <20260731165004.2758105-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEyOCBTYWx0ZWRfX9AT27oST34ca
 oifnWOlzBXVcELBB4ClGvxlDR/nM2Y46//Maqp8e9a2SY8uNRqA7v4c1UPs4vhjRvDmHsf2VSjX
 s5WD/D+fBqEcG97F0C0Sh6wrSDRhgI8=
X-Proofpoint-GUID: p7y0sIaGKDtF8SoCUC21G9VmDrvNYYV-
X-Proofpoint-ORIG-GUID: p7y0sIaGKDtF8SoCUC21G9VmDrvNYYV-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEyOCBTYWx0ZWRfX1YMx7NPxOecg
 REqjq9dR6G8b03Egf5KqMt4Ujr9umEtvXkQ33+BlAUxVRs6in7cdePLVrXT9i2mLc7AV3XMeBLj
 vq+RNvXHkxw9se2XH/ygTfbZ0Qycvahm+eH7/vLStPQNc8P/Vw6porVo3E/EokjvlycdUMeDuI6
 TlzOfT+GJOok0dMDS0hWe/5RRqRFXWsFwfPCnF83jdL+ZBPGtHekdQrFroJ4qOE3yX9gkXsXwb9
 BIwiV7WFKBqhF333r6tbwij5MQGI5sQUANh7RDp0O9JPz9RnYmQFCNmqj0v+diRcGg5xDGXt+sk
 PrNhGCSSPC5w+itR5l7GCdqwZzA0aQ2J8D8/rdB6ghQ0hJTb3orhhzDXHwSn6tK2qse5eDhTd5m
 hmmSmxNHFj2z0f7qfvzJsJbxgrN/cPnj/U5cG17hEkX7vaqS+8PZbqpaXz1kO1snwVZ9U17ZhPW
 7SX1onVorkW/Qeq5hBA==
X-Authority-Analysis: v=2.4 cv=X5Vi7mTe c=1 sm=1 tr=0 ts=6a6cd242 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=Fs_qYlmMC0Zql47DM_AA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607310128

v4:
- Replaced first patch with version from Peter Zijlstra

v3:
- Drop uv_call_sched() [Claudio Imbrenda]

v2:
- Use msleep() in crypto code (Holger Dengler)
- Add Reviewed-by tag from Peter Oberparleiter

v1:
Since [1] it is only possible to select the PREEMPT or PREEMPT_LAZY
preemption models for s390. This has caused some minor problems, but
everything has been addressed.

Given that for both preemption models cond_resched() is a no-op remove
or replace it everywhere.

[1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")

Heiko Carstens (3):
  KVM: s390: Remove cond_resched() calls
  s390: Remove cond_resched() calls
  s390/cio: Remove cond_resched() calls

Peter Zijlstra (1):
  s390/crypto: Replace cond_resched() with msleep(1)

 arch/s390/crypto/paes_s390.c    | 44 +++------------------------------
 arch/s390/crypto/phmac_s390.c   | 25 +++----------------
 arch/s390/include/asm/pkey.h    | 16 ++++++++++++
 arch/s390/include/asm/uv.h      | 16 ++----------
 arch/s390/kernel/perf_cpum_cf.c |  1 -
 arch/s390/kernel/uv.c           |  2 +-
 arch/s390/kvm/gaccess.c         |  8 ++----
 arch/s390/kvm/gmap.c            |  4 ---
 arch/s390/kvm/kvm-s390.c        |  1 -
 arch/s390/kvm/pv.c              | 11 ++++-----
 arch/s390/kvm/vsie.c            |  1 -
 arch/s390/mm/cmm.c              |  2 --
 arch/s390/mm/gmap_helpers.c     |  1 -
 arch/s390/mm/pageattr.c         |  5 ----
 arch/s390/mm/pgalloc.c          |  1 -
 arch/s390/pci/pci.c             |  4 +--
 drivers/s390/char/uvdevice.c    |  6 ++---
 drivers/s390/cio/css.c          |  8 ------
 18 files changed, 37 insertions(+), 119 deletions(-)

-- 
2.53.0

