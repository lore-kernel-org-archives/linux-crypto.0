Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554ED3D412B;
	Mon, 31 Aug 2026 08:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165530; cv=none; b=rwjZWmz66V5FV+ito/gP/65EH4g8TkQocBjlnLWtYEMlhtnFCWMZC3u9n/+CqKdyqzDhj/l3wgr7pMuA99+Y9UgJqkpg/BVcu3FLz9AH8R2sN3HXTpp1veHnfpdrOk7kQu8hlTq1KlROPKsH+pdS1r0HGGCIbrnUoJV1ZHs8Y6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165530; c=relaxed/simple;
	bh=zIyPDXe8ZaWyu/9xFNZhYRNZewfvgq1MrlJ80+taAHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o/omgmXzIX8FbLmAyRa6MLLS8KjaDQKh7kwRcBwc++JCG6Wt3pC6aI2OgTGliYzI9N20fy2ZWVr2NDtgoPtuYE7Jzgc+u8PLuU2VJc8wxFP5PFnFXTGTPlfVrM8rqc2zkqsctl4lQ94ABiHY/Ri4hPTng755xKcCyU5hHIZeNVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=D+MarHDy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="D+MarHDy"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V825Ve1640128;
	Mon, 31 Aug 2026 08:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=GGKxhrC3Kjumkx1Mzt1c4YtziaAH3HopGcfZkiDE7
	Uw=; b=D+MarHDyNOfXSEj6BZrRd4hM5FQBzsDYJheYkrnPuABeywztyJFHLo087
	dKoN8Z2mYyFf3micxE0nHGKtDqFLbkeQ0lSBslx7SdrKuFSvyXirGZen2tRlIK6I
	wTYfbitwlkX/D4dPDZvt3mu21lElplg3S78JLTR2LmtKoATgIRxSOrnrpUvp6SLA
	wUt8yKSIvO6Y9uAKfBkI6PZoJANEuA8YFH67iRJLP+oykIShGl8fmJxpMri8wLkH
	jLIk/r2+Jh7RPkOGZuFPbmHA3+9bn0aa9S8AmSB5EGs5jIm8vI+yco86XxDYZBq6
	1oLRvx2dmmi4qCrcS2SGZH236hwVA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbpx584sp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:43 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QLGH023211;
	Mon, 31 Aug 2026 08:38:42 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gc9rq51mw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8ccl849021210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:38:38 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FEB72004B;
	Mon, 31 Aug 2026 08:38:38 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B6A720043;
	Mon, 31 Aug 2026 08:38:38 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.165.38])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Aug 2026 08:38:38 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v7 0/9] Fixes and rework for paes_s390 and phmac_s390
Date: Mon, 31 Aug 2026 10:38:29 +0200
Message-ID: <20260831083838.3703-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=PPc/P/qC c=1 sm=1 tr=0 ts=6a953d93 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=jDsoFWGkZLupzffnQz0A:9
X-Proofpoint-GUID: r7nthZuMAzC_QO0FYZDxWJXwzTTFPgAt
X-Proofpoint-ORIG-GUID: r7nthZuMAzC_QO0FYZDxWJXwzTTFPgAt
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX6vUkhuCGGnRx
 knR/YNHSFuD66km8ALgiGT/JESLhG1Lnlq/K0anFo5TuQeZKJ2rBRYuXUy9yYW29Qi65mi9hFRz
 gN+S5W1a2iYpyJ7H/L+eerpyku8fdDg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfXwCCahD1GhAAA
 qTkpJOvSez+C8TlQywTuUf4cL3dw3l0LDgjoFv0CAlUfpekqUSTjE8fTGMe4RvyyRmvOvee76Kk
 qH/11eFileQBvos0gIJAA3sNLn3k4sCPU20OTh5c0UKbsDylgXncU5ZP/KATAzZpsfmJvFgbDo5
 hXD8xXF35N6MaN25PHDFH24rKJgkBJKpdU79ymp5QcNwA9HIUFJmPeVu5/QKnbpfsdB5EUdctzy
 l44ztvdvT7atMwkKtfhmYgXtIBTDfaQFRvcCBmhjdG+wAoLYueHxYrPL5x1c+eq5fAqtjMRXY+M
 UHYd3imQxkZjF74y+TOuHv+6HHW89879+EbSKuD5VlvAnMYBZh3rnfoiHMiFWXnjQUaSRMILiq0
 humw5X1OnsuzxHvZiF3/uU1ZaSX5jvNORFL//0+pjdUkdQg/ALZwHliK5RIKF3OIPDAoU7U9n5w
 HyXyE/0EOTykpAUtJ/Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310072

Fix and rework some issues around arch/s390/paes_s390.c and
arch/s390/phmac_s390.c:

- Fix skcipher_walk return code handling in paes_s390
- Add scrub of some temp buffers
- Shift from using a mutex to using a semaphore in PAES CTR
  Surprisingly clang code analysis is able to deal with semaphores and
  thus the shift also fixes the issue with CONTEXT_ANALYSIS enabled.
- And some more fixes related to paes and phmac (see changelog).

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
v4: - Mapping EBUSY to EINPROGRESS is not the right approach. So
      reworked again more thoroughly.
    - There came another reply from Sashiko about a possible double
      processing maybe even double free as a result of wrongly
      returning a failure code in the callback functions back to the
      engine when a request has been completed. The callback must
      return 0 - so another patch for this.
v5: - Sashiko found a potential for a deadlock with phmac where a
      persistent key conversion failure results in an -EBUSY which is
      as such written into the request. However, -EBUSY is swallowed
      by the engine layer and thus the calling process never gets it's
      callback invoked and may wait forever. So map -EBUSY to -EIO in
      the conversion function when there is a persistent inability to
      convert a key - in the end this is an IO failure. 
v6: - Added Fixes and Cc tags to patch #8.
    - And finally picked Heiko's update on arch/s390/Makefile to enable
      context analysis for the clang compiler.
v7: - Reworked the mutex to semaphore patch by rearranging the code
      to get rid of the conditional locking as suggested by Heiko.

Harald Freudenberger (8):
  s390/crypto: Fix return code handling at skcipher_walk_done in PAES
    algorithms
  s390/crypto: Fix missing scrub of temp buffers with PAES algorithm
  s390/crypto: Fix use of mutex in atomic context in PAES
  s390/crypto: Fix missing cra_flags in paes_s390
  s390/crypto: Fix handling of EBUSY in PAES when req is pushed to
    crypto engine
  s390/crypto: Fix handling of EBUSY in PHMAC when req is pushed to
    crypto engine
  s390/crypto: Fix wrong return code to engine in asynch callbacks
  s390/crypto: Map EBUSY to EIO when key conversion fails repeatedly

Heiko Carstens (1):
  s390/crypto: Enable CONTEXT_ANALYSIS

 arch/s390/crypto/Makefile     |   2 +
 arch/s390/crypto/paes_s390.c  | 184 +++++++++++++++++++++-------------
 arch/s390/crypto/phmac_s390.c |  36 +++++--
 3 files changed, 142 insertions(+), 80 deletions(-)


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
--
2.43.0

