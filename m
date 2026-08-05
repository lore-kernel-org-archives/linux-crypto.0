Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0062A47D446;
	Wed,  5 Aug 2026 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785945306; cv=none; b=SeD7nUFhTbiylnUmYmnlrGvQPLhvXOpSCt950Gkby/otP2jqQT/iMwXXET1ZdjeLoYJerZaz9JxoltTwCaFW9IohsDfWWmJkEc+mXCzAZtfdSjEZJtT7Xh9Sy9Q1ElbvpbFO8+jKCG8I9kEFSo54msivANDD1G0HqtM+TCoXzZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785945306; c=relaxed/simple;
	bh=fcblMyp+W6SFY/riWgj8SG/SFIF49wrgzXuodMJo/ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SHSqNwNrjfRD0Ty+lTFP79spFx8wBhG/aRb0mv6VPAbC4Y5sN+XgDRfdpgiGG+XSKAJMJqQrGq6Ab48Hf2rKCFx1RIWG27a3/BdYJYGQ9QDnbMplBZLIbiAydxV5KYN9GZrkfKXey3OKtCvla8FBF6TveGE+zAmNtV8fb8m00KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ATERNads; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ATERNads"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675FlfFw2397876;
	Wed, 5 Aug 2026 15:55:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=W7p1Q1CQbn6tanA2YI3nmoeb7v13O1IkJQl446TF2
	0Y=; b=ATERNadsJmlwDsUYGsycr66EXPRMw8ouqxROyLzSywAoqwVEnbI/dD/ig
	o/aTpVJZAy1n/oqZ1wSZKttLakpIbPdcJo1WBnjaUUnxlPZxaUZdr0UnDWqIWZCr
	wcneh/izcOE3UA6noSbAWCFcwBaDNodbGQvqqedplqoMdPZr2Hk/cRhKMmW/oOOH
	wSFzwmbI3Q5VKp1A3T5yCuVcYFxGGwM2NdaTZxU3vSkSIvi9FBCR3EhBi2vSFgjd
	DGgVMmjLVRLuJqYLBhUyp1UKESnFKso49LBLD62tvqCCTutT90v3HSAJF8Qbp4t6
	HT6ZPKrYFtDpsVfKnJwEhtAju/kzQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8fquskf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 15:55:04 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 675FfbBt006574;
	Wed, 5 Aug 2026 15:55:02 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsv4k77ef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 15:55:02 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 675Fswcq26673436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 15:54:59 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D156A20043;
	Wed,  5 Aug 2026 15:54:58 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA9B920040;
	Wed,  5 Aug 2026 15:54:58 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.168.79])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 15:54:58 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 0/2] PAES - Fix rc handling at skcipher_walk_done
Date: Wed,  5 Aug 2026 17:54:56 +0200
Message-ID: <20260805155458.14925-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jgaH6iYIVUZXZwQvpQjCUqVAJNwSmBHH
X-Proofpoint-ORIG-GUID: jgaH6iYIVUZXZwQvpQjCUqVAJNwSmBHH
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDEyOCBTYWx0ZWRfX0L4Nn7sLw/VJ
 YGbgE8WCwFttnGKwk14ucPhhCJF4GTjSi74dmZCyIFtOj589Xgri1BiYjsRs2VZPAh8GT5rDYvZ
 p5QId0+HHBoeajo5p26FnrKMwtejE24=
X-Authority-Analysis: v=2.4 cv=K8cS2SWI c=1 sm=1 tr=0 ts=6a735cd8 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=M1ubknUnFNj-0SV-jeoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDEyOCBTYWx0ZWRfX2zad8uGwZkgr
 h9thbPFAwmpDd1/Sj44ZbSXON7CWykP7agqZacerir7DvuOPcQKG1lnTKOoRviOy8thDv42KXz4
 ldrKWLqijKKt0piHp5hNLkYZuATcC8uZZO/hUZace6/JR3KcDHFKib/omP7XKc6N7mUJ5IlfJMx
 kLPhz6tnMOxbwhagGWu2PY1kMzPjz0uTJJEB2BE1mWBgyshRQAEh479qDI1doBHmmwGpUGnB1Hz
 g5k3mVxTluksqR8lehqGzAH6rkgGkbSPX4OXJvhXL17xMp2trFIF14qbDRQB06stFt98QY5O27K
 0xxyHE4AzuAHArAP+jpPiN11Qq61UP2iQgWvNDEGOrH5FDsg+4lv6Ay7hn6MRnCdNq8kmT6IXPy
 Nhtp/sPmGC/YdxWA5uD4dnF2xUKVnVOL/Dn6mMdXvWHS61m3rxXCIaapqNrbBzWWQ3ujp8NqajP
 yh0Rj0Gh/SFCT8FOXeQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_05,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050128

All the 4 PAES cipher processing loops were not checking the return
value of skcipher_walk_done() immediately after calling it. This could
lead to error masking when both the walk operation failed and a
subsequent key conversion was needed (k < n condition).

Add immediate error checks after skcipher_walk_done() in all main
processing loops (ECB, CBC, CTR, XTS modes) to ensure walk errors are
properly propagated and not masked by subsequent operations.

Patch #2 deals with a not scrubbed temp buffer.

Changelog:

v1: initial patch
v2: - Sashiko found that now there is a possibility to double
      de-allocate resources held by the walk. So another check if the
      walk has already been finalized is now part of the patch.
    - Sashiko also stumbled over a not scrubbed temp buffer with the
      PAES ctr mode implementation. So another patch added which
      scrubs this buffer.   

Harald Freudenberger (2):
  s390/crypto: Fix return code handling at skcipher_walk_done in PAES
    algorithms
  s390/crypto: Explicit scrub temp buffer in PAES ctr mode algorithm

 arch/s390/crypto/paes_s390.c | 39 ++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 11 deletions(-)

--
2.43.0

