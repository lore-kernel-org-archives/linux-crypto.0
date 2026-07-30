Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11D83B059D;
	Thu, 30 Jul 2026 05:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785389364; cv=none; b=OOay67FmWaIG74qANelqKMrF3w1JeejRMHQTjew7muBufD0JY9KTLPRWLerLHCHj9FSn0g8t/KpnAu+w/FEz8aXPi+qps5uyY9etvRPaSn16ImgrLnkYQj8i/o6EfxPPWWJjuHsU++XwG9dGb4i3KuQRg/HW53pOdJo+iy4Y9ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785389364; c=relaxed/simple;
	bh=Yi1xch+SXn4if6nzlHVgUrGyfsGk0uNnBJ27DOcff9M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BLE0DkKBFNizoNigqy3L4hxpzfmbBTCUwUUrcQLJ1zTjv1F8wuI3ZaKsad7Z7OFZ1UnWnwaoZNJkPgfuj2cgyyPvGj1FPgRTHyiXZhROdkEALxOnvGSrFQBXSFKffjWtqHq6nN6uK5qkbmRLv4Oz73klcAD7t7U3yAL1FtwomIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qPripIW5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qPripIW5"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U3mXh9039480;
	Thu, 30 Jul 2026 05:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=fBEUmljbIcYMHkB/5FjHf4gQDwnxThzydcL2ilzHf
	No=; b=qPripIW5HbxGH6ccwYDq3RFHHtxohZvyzYSbvjhTTjqkLEZ/r4MpF1+GE
	2pvnlYxyah7c0iF07tNPB6/GK8igEkEmURVWtH3pO6x0pe26PQiUG9ogPB61YUyL
	PD5qV0VelCymh9+2YrPKtjsVwt/VnaR8dZS5ypuHfZwYYra8QUqiypm5dACud7pD
	pxtEB27zfEKwcje2qiGS4s2zAsQ/SYBfgKaYu+wb/ss6r2vRwUxeoCSfZN48ljOf
	cJTBNpB1sze3vBUb8Z+XvHUSHvv0xpi/8PVguXQuAdgZuURkgUIFlnsA5Zm1qa7b
	cCS1YyO6vt+PFyczJXL8wmSEDKp+A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuycp378-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 05:29:13 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66U5BT4r023728;
	Thu, 30 Jul 2026 05:29:12 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn7uwa13e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 05:29:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66U5T7N830736730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 05:29:08 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB78B20043;
	Thu, 30 Jul 2026 05:29:07 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA3E620040;
	Thu, 30 Jul 2026 05:29:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 05:29:07 +0000 (GMT)
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
Subject: [PATCH v3 0/4] s390: Remove or replace cond_resched() calls
Date: Thu, 30 Jul 2026 07:29:03 +0200
Message-ID: <20260730052907.2607026-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 38bPFaJZsH1Bwgcb6nMPiEoIFMI0Ffyc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAzMyBTYWx0ZWRfX01cE1H459gWL
 a6pv2Dg8DQfmlIeJ9kg/cwOUuLv3SeijPeXYoqUM7hL7cTlZqy883h+LU3nEmmzJntyKjcIfOeU
 gI8+KGM4x2hCVrtR0YRnsQLvGiXGgkQ91U14R2qEblR3Vwcyp85NGY9FWAAQrc4JSYJECwLuhCT
 rqQhzzY/b/PcPfFntcQclzBJ51nI9BhF5gJ6Mrp6z4GsUrd1mj+B8eFY87DR0jGpHzYLanrJ3s6
 H2k/VPy6nlgrVU4xh7Xv19dzcAvnrs9Y17diZ/FUbmUerhWAHyQ30BpC4Jkp3Hlod893nD37L+4
 BZsbV8uLFfrCcEc4oOYUmGbaZqeFm2PwNk3rolB+nn008ZkgTy4RTXKP1s/0u8RzeAl7UP9b/nh
 zmE6xzsUQh0/EUH7o//CuvyIG1Pah8z84LtiipBHJGw+DTFTfN9kbiXLhMMlF94MHb7MHq+9duj
 fwU9a7emGN7i3LZpCbQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAzMyBTYWx0ZWRfX6xOvEkD3QjIs
 r8RAF9P0WIbO5cnL+/OsWGwMvLHijWDsDaHd36mnauX89AOoR7/aPBz5h7PLYKhGJzPQAGVcV+E
 LERS5jnp1vKCo21RERfR5S9VvkwbZFY=
X-Authority-Analysis: v=2.4 cv=AZeB2XXG c=1 sm=1 tr=0 ts=6a6ae129 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Fs_qYlmMC0Zql47DM_AA:9
X-Proofpoint-GUID: 38bPFaJZsH1Bwgcb6nMPiEoIFMI0Ffyc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_01,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300033

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

Heiko Carstens (4):
  s390/crypto: Replace cond_resched() with msleep(1)
  KVM: s390: Remove cond_resched() calls
  s390: Remove cond_resched() calls
  s390/cio: Remove cond_resched() calls

 arch/s390/crypto/paes_s390.c    |  8 ++++----
 arch/s390/crypto/phmac_s390.c   |  4 ++--
 arch/s390/include/asm/uv.h      | 16 ++--------------
 arch/s390/kernel/perf_cpum_cf.c |  1 -
 arch/s390/kernel/uv.c           |  2 +-
 arch/s390/kvm/gaccess.c         |  8 ++------
 arch/s390/kvm/gmap.c            |  4 ----
 arch/s390/kvm/kvm-s390.c        |  1 -
 arch/s390/kvm/pv.c              | 11 +++++------
 arch/s390/kvm/vsie.c            |  1 -
 arch/s390/mm/cmm.c              |  2 --
 arch/s390/mm/gmap_helpers.c     |  1 -
 arch/s390/mm/pageattr.c         |  5 -----
 arch/s390/mm/pgalloc.c          |  1 -
 arch/s390/pci/pci.c             |  4 +---
 drivers/s390/char/uvdevice.c    |  6 +++---
 drivers/s390/cio/css.c          |  8 --------
 17 files changed, 20 insertions(+), 63 deletions(-)

-- 
2.53.0

