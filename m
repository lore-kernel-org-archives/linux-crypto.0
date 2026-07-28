Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17AB45107A;
	Tue, 28 Jul 2026 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785251071; cv=none; b=jCICNREHjgSd0JoM3BkSSHc1DeGKAlTw/JolR2Jn3wVBRlbwG2yWzMP8h8c/swJWLv68pLQIMIidI74kVBf1SXzE89q9btf0dhRQnIzZ3SAvv+luND7fIqlDF/ivKwR+Zup4zpwtFI42n0dns9itT/0rQYayGh9rqePitCLkl9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785251071; c=relaxed/simple;
	bh=jgW/rwtjTdi2iRiSs+IoDYkwAcSnlS+jYsueyUJy/Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aNhNkJEHBR3HgfaDPf8ADecyd9upXLqgWDrSq5trVNly8BuL+PfFLDzdjZEzLq10Iu5K0ro1rmSS/JY++80B+X8EQCq5BYzKUUXoB+2lm6SDLuGzMGjXOyI1sKCNQAn07Cq73f1N6dCe+n44xWtlGSkGsXd5fEyDuM63stV/8R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fZGML3Mj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fZGML3Mj"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SEljrU1459403;
	Tue, 28 Jul 2026 15:04:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Yr4s/IYPZxY2qWzQSMJ6aoI2I97bggQAstgmnNQk5
	Fs=; b=fZGML3Mj4nHMCp2T6wQcogE/g9clKvxEPFQo2pB5KWkKuKYH+DvOA0CRc
	dJisfC6ai47YRVz/KUan4BX5Bh1DSK7zbDjn3B78/CHd1SBS3viXWl/zFRHpcY2H
	asR3zOzEG0bUGsgr/XLwUeK2rOmbSCKUo3k/IxJlGdQD2zpLS0p5+t3MGvgmAaX5
	Xlp7lIFkQf3MUsgsuE6UMkRsN0H1V3RQu6K2JFmpI+TPqyYMePs8X23JV27aVjQv
	JP+dvVML9rgWWALkQuxnuWQHJg+KR062Wl7lxlqANYgTe/YAzb/IbxxqqkhoDRQK
	YGcPo0fpXOxbR3/9M4f3ALwNlTSWQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuw7dw1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 15:04:18 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66SEuIHE029118;
	Tue, 28 Jul 2026 15:04:17 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8fk2dfy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 15:04:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66SF4CqQ29163970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 15:04:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9BA02004E;
	Tue, 28 Jul 2026 15:04:12 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A03BB20043;
	Tue, 28 Jul 2026 15:04:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jul 2026 15:04:12 +0000 (GMT)
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
Subject: [PATCH v2 0/4] s390: Remove or replace cond_resched() calls
Date: Tue, 28 Jul 2026 17:04:08 +0200
Message-ID: <20260728150412.3893933-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8zh8w7_myis3vN-7SN8qt95E3lbMEHgO
X-Proofpoint-ORIG-GUID: 8zh8w7_myis3vN-7SN8qt95E3lbMEHgO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDEzMiBTYWx0ZWRfX+tLRTBiNhGqC
 P9QMUHor8BPrMim9fUeCGXGVNzNsPdLP/nRfFy3Osj61Uros8d9rKE8IIYMZq7Q3JIKc3U6Rc0W
 +j9W/epy+JfUi1BIhF9uh+dHYUyVTQhORCReKozhm+3Ucy3JDpHdcAQs8KxGz9MWw56xgzi9PJp
 Rp+06qk5CEaRNZk2kwhOdCW7L3Qc2wyN6f0ovQMPB7nGLgqAqmRNlw5uWLbC5hIPEO/JAFTDDkQ
 zfhihARtpI2LkHHKpwthq6OQuZZ2oi5bKNoPZJBTG8uazPEtYuVVBoFYEjv3mJW5a/lXmxnJG5i
 OMNC2vWkKBmhdlrnWdhrrsu9s0XK8M4DXZZ6cfJu9zszBsXa92gK5RtYtn0+LrcoBCML65EH5A/
 QQvht3Z2Bjwgwkd8A9W7PulGJ7FWqRzdtCTjFt0knDz1/lcHsLAyuFosYb3E6Sh6xPhw53qvUiH
 0LKTl4OrI8Lui3lkM7w==
X-Authority-Analysis: v=2.4 cv=SKFykuvH c=1 sm=1 tr=0 ts=6a68c4f2 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=Fs_qYlmMC0Zql47DM_AA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDEzMiBTYWx0ZWRfX7XbFWybbvR4Y
 OP2iIYiXCoFV51u59duEeNOsqu44mXKUwoZnmC32ToBDZv/zxv1xnIbaZjpZKEtaWkNjA4dzaV5
 DF9FOekC8x3nDFn+yQCeQJKlM+k9/o0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1011 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607280132

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

Heiko Carstens (4):
  s390/crypto: Replace cond_resched() with msleep(1)
  KVM: s390: Remove cond_resched() calls
  s390: Remove cond_resched() calls
  s390/cio: Remove cond_resched() calls

 arch/s390/crypto/paes_s390.c    | 8 ++++----
 arch/s390/crypto/phmac_s390.c   | 4 ++--
 arch/s390/include/asm/uv.h      | 1 -
 arch/s390/kernel/perf_cpum_cf.c | 1 -
 arch/s390/kvm/gaccess.c         | 8 ++------
 arch/s390/kvm/gmap.c            | 4 ----
 arch/s390/kvm/kvm-s390.c        | 1 -
 arch/s390/kvm/pv.c              | 1 -
 arch/s390/kvm/vsie.c            | 1 -
 arch/s390/mm/cmm.c              | 2 --
 arch/s390/mm/gmap_helpers.c     | 1 -
 arch/s390/mm/pageattr.c         | 5 -----
 arch/s390/mm/pgalloc.c          | 1 -
 arch/s390/pci/pci.c             | 4 +---
 drivers/s390/cio/css.c          | 8 --------
 15 files changed, 9 insertions(+), 41 deletions(-)

-- 
2.53.0

