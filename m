Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2553EDE40;
	Mon, 17 Aug 2026 14:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976222; cv=none; b=pJ5q9uiGmgShJYBijDZF+mVN10B7U0LEi/QpGZOWP2XGur7Y1wWJAVq9ZwiFlPXOYTWRVE/cYAEtbP4Svvi+jAyS6HZyzrVlzUjMeSnVRSPgMDzqi9TMvwdeG/jSzW+m9AfPaQbn93RX2+O5JJOooRNAVQWsDLvBXKTo6dpArXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976222; c=relaxed/simple;
	bh=FNmwmWNQyAHslhDKxqV32Aqce792sl9B+qA6OMmmCXI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R+vDR5iXC/XYK2hP/c1CyIo4VdBxM5SUG8tHgbR5tgI1Bm0rGs/IOGafR1CD1PXn3u79Ve8/oJNaPkILsKfQ2OHYKyXlTGQ8Oz5iqtSDLljO8OMPJiw9ZYibXV3Sfj1HLTvtnRHykVXN0rH6PKod6mcCD5BziTa7ap3dXfyl/Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GDhevpds; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GDhevpds"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HCVp1s287922;
	Mon, 17 Aug 2026 14:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=+8TUmfKvtPqhJid3coNsoi19s3sn0WE1QhzaMJutw
	xk=; b=GDhevpdswpDfrAyevko31VVMBePezzvvMfYJRczVra9I3j35ErkteW4+D
	L/UKySHiy2f0QkTcPShguXZ75USKW/oYSqIAgSvia85EJduU3ZRg27iexdwTQhO0
	K4uedVARa6K1yiN9kXtcHP4I6nTE/j7nDht7hC7yx2a2Xz9BUBwoYx0yHpX2F4jt
	bLgbA0FVWlnHsGP0QhKxJWL1kzk6M4Uqa31pYTlUdqIyoIIt6PIGWS95/xELRwBP
	GCI4HZYAQt0TxZSgocVjxRnq27YpqDYRS0EwijDW/CqtrR8HbTLov2SlMdG8P4e3
	JUmjDSSnrRmhheM7n/rHzBGZ9/Fpw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2ehe2ewe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:16:59 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HEBOJ0003808;
	Mon, 17 Aug 2026 14:16:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g34ng64yq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:16:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HEGsf126608304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 14:16:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9460A20043;
	Mon, 17 Aug 2026 14:16:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FFDE20040;
	Mon, 17 Aug 2026 14:16:54 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.162.247])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 14:16:54 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 0/6] Fixes and rework for paes_s390
Date: Mon, 17 Aug 2026 16:16:48 +0200
Message-ID: <20260817141654.77940-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDEwNyBTYWx0ZWRfXxr8YgjJfgV1O
 HULvDz3g5IIkPcy4IlFVYWwkIe2WqGGfHd1V1icNhHGjqSKtYH/8TCxl6hkltT1dGRcjroznkEl
 BvKHhgfGrT6OT7fQgPgOOULj7EsB7BhAwknZRhKoy71gt7f7g14pzOMy8GSPGAKdILO3aHTljbS
 R9NViRwDcHe0Go2F0xaCjrVSVoxRV+NHcrdWUrh52PX2x9jn/cxm9QSzI0aezhWbelHYvYNQJkt
 bjwiLn/gDLxELmRmjdKeF7gtn0ObQZM17GxJ2wjYjf5ZbTLdSbg5QFUs0/oo9oDLVdNMaSsphBk
 84p2W5AsMAH2aE1RF2dqA1oAzUNT3Jfk1x1Cd6+7da9bZwHHbQpwJoU2NnDnI0eObpSZ9KlziPb
 V1RWP1T/YjLJyM6L+yLYPPuiOODKu2NYw+6AeDJIIjrxP+hlnaqGnNY/SIX+AR5n7XNJfDcvDLL
 GAT8HtG3qBpxRdov9Ww==
X-Authority-Analysis: v=2.4 cv=DY8nbPtW c=1 sm=1 tr=0 ts=6a8317db cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=bXAP_PYkuvYdcVEYZgwA:9
X-Proofpoint-ORIG-GUID: b3cdyFPfQ61tE9gJm_AQHGeSCnoisXOW
X-Proofpoint-GUID: b3cdyFPfQ61tE9gJm_AQHGeSCnoisXOW
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDEwNyBTYWx0ZWRfXy4XreQ8uABsQ
 0TKXLQn+AL8aLKDrE7Rel1Xwwxuy4Hha3IOcCA8TXeFPqDaY53sxib+rxKAKPCIE+nPmwVtWTzI
 qk4FUkw7JpZeIQ0ABpjMrMldWQm6CWw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170107

Fix and rework some issues around arch/s390/paes_s390.c:

- Fix skcipher_walk return code handling in paes_s390
- Add scrub of some temp buffers
- Shift from using a mutex to using a semaphore in PAES CTR
  Surprisingly clang code analysis is able to deal with semaphores and
  thus the shift also fixes the issue with CONTEXT_ANALYSIS enabled.
- And some more fixes related to paes (see changelog).

For more details please see patch headers.

Changelog:

v1: initial version - however, all these patches are follow up patches
    from a similar patch queue for aes_s390.c
v2: - On one error path in the CTR implementation the scrubbing of a
      temp buffer could be bypassed. Also checked Sashikos claim about
      possible double free but this is not the case.
    - All paes algorithms did not set any base.cra_flags. So now set
      the ASYNC and the NO_FALLBACK flag.
    - If a request is pushed to the crypto engine there is another
      return code EBUSY also indicating success but the code handled
      this as a failure.
    - The very same was with the phmac implementation. So corrected
      the return code handling there as well.   
v3: - Reworked the -EBUSY handling in paes and phmac again. The
      synchronous path could have emitted -EBUSY also and would have
      triggered the failure handling. So map -EBUSY to -EINPROGRESS.

Harald Freudenberger (6):
  s390/crypto: Fix return code handling at skcipher_walk_done in PAES
    algorithms
  s390/crypto: Fix missing scrub of temp buffers with PAES algorithm
  s390/crypto: Fix use of mutex in atomic context in PAES
  s390/crypto: Fix missing cra_flags in paes_s390
  s390/crypto: Fix handling of EBUSY in PAES when req is pushed to
    crypto engine
  s390/crypto: Fix handling of EBUSY in PHMAC when req is pushed to
    crypto engine

 arch/s390/crypto/paes_s390.c  | 68 +++++++++++++++++++++++++----------
 arch/s390/crypto/phmac_s390.c |  6 ++++
 2 files changed, 55 insertions(+), 19 deletions(-)


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
--
2.43.0

