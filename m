Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A159743F4BA;
	Thu,  8 Oct 2026 10:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791456771; cv=none; b=egTErfxyc2nXW2srxMJjvFSQbk8zSXB7jJMDbZFbGyB9fEAgKnQsJ1hg/VNUXvNswEDQ8JFfbN8lXeyG0akaxWZr1GM3j6JhVdkDasTRrClj1RuyqMM2IPtK2FsDuTXaNn9sHuue0GZE0cTzW9UAKjupUQtKRXohZ/JRCvP63ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791456771; c=relaxed/simple;
	bh=ZzneI4HJw9HivCqJ6BXZ9EaoEOtf4Z5AxLsGYJUJuC8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MPyPF1rDsBkzUgcv+zghTuQz7iaFsCwUZfOaT+SmHYOL0J5YCC9fKK8G8GKxmPtm+4RkGxZoNXEblqEfArGHkBHLVKxlp2Xtr9pPb9DT6r75ALEa6bs4vmUykhllRrN9ql5HuXLSHzoQUl8w2LE6/Tv0kM9sxGIVd/8xImzqdg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YSc9qkB7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YSc9qkB7"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698AbhHg3492196;
	Thu, 8 Oct 2026 10:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=GucJJ/OfLhvUjMgfza0yOpLSfDOuy3kMBs9zzYPXK
	e4=; b=YSc9qkB7U8xfXcFqpz3tw0Ev2dWCCfdOCTougTuVUqz9E3ZRsfmDnivr4
	YoPb2be19GOjeYq4Y3lRZ28agw0kdXPdNWDzZHao8OU48EYSpyPWUngX4TcZ+zuQ
	m8UzjynFBoXcaXQmwNWnnMXXXcPKmRRCBbPsOVjno/hlVBgVd/OFPxz/ilZx1czL
	SiutBBdGBAhBduWxHTSqJ7TeM4xdy9R2YQ1P3UXnYdp2C44CXepcJNRq35LMKQlU
	MSp+1GOvM0tdyyttq6pg1nf9BdPbGNUK5yPvlBgTSxcdm5nqF/CJgtBrG3tUXtcI
	sOJoyv0iiieiKe9yj7+rXkih7vylA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xjw332r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 10:52:48 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 698Als1d3319390;
	Thu, 8 Oct 2026 10:52:47 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h58d5q2gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 10:52:47 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 698Aqh8737814666
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Oct 2026 10:52:43 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 381EB2004E;
	Thu,  8 Oct 2026 10:52:43 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F14DD20043;
	Thu,  8 Oct 2026 10:52:42 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.224.94.37])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Oct 2026 10:52:42 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 0/2] Rework cpacf_kma() function
Date: Thu,  8 Oct 2026 12:52:40 +0200
Message-ID: <20261008105242.20730-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jvLHlj8G7HrojnsToH9AdP6s9IAw6SMH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MiBTYWx0ZWRfX5obZvPNRkcMB
 71JXRaUfBPwu9hy3TIlyCBQ3VV8XMirN4Xy4Af4SSkg0kjQqdzHMYS48I+fdmrG+MJoxrxtOK51
 SuUT66jhqWYJo4ulSJrWUqLJ4Mk8XkfASknB7XDqtmlaOs0ZbMw2rduSExu9LphqEZex+Y2X3Oy
 Z2UWNZNtXwwKbn3hVRG8aep6N8+9N4dthRwcyiVbBscw/YRPdZho9VPmStU0HdxZoc54pjnXDtE
 B1tLzQzZZ5IVRaoD/AnfjZyZAiAnsR1xJbW655fECvUIBfF1+2We0MdaAla4KOtgMHsdhm12nAC
 RqPb2f0Yp4IobAUL+sQruCCugLuuYV1j9XW4g69JRaMmboLx+cYr9dueCK+L+jjfceu+92m4BAG
 pfPW+kqKrR7WgS6Jya9nx35ssJ6wqea7r0F2vp5jqPcLDOlKd4+HgPSXcyU2H7BZpVnKyjwexcM
 qskGD2Wxj+8tmmNWK7g==
X-Authority-Analysis: v=2.4 cv=cIt1IVeN c=1 sm=1 tr=0 ts=6ac77600 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=fOsJ3xpZECLwqP2RnqUA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MiBTYWx0ZWRfXyp65lOprk0nn
 6Gn7sv/cPt5EVtf1FUk+bMB/cHOqhkFKSli2xWKutw/UIhplRmy5g0DRPtTnQwboo+XtlkFZWBa
 qbdGPDBzxjnmFzhrI4iHkCqivsFyTr8=
X-Proofpoint-ORIG-GUID: jvLHlj8G7HrojnsToH9AdP6s9IAw6SMH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080042

The CPACF inline function cpacf_kma() has return type void thus
indicating no direct information about success or failure. The
majori of the other CPACF inline functions do return either
failure/success or the number of bytes processed.

Rework the CPACF inline function cpacf_kma() and the only caller - the
AES GCM implementation in arch/s390/crypto/aes_s390.c to return the
value of the condition code set on completion of the instruction.

@Herbert Xu, @Heiko Carstens: As the main change is in cpacf.h and the
slight rework in aes_s390.c is petty simple I would go with delivering
this patches via s390 subsystem.

Changelog:
v1: initial version
v2: Added Holger's RB - no code changes.

Harald Freudenberger (2):
  s390/cpacf: Rework cpacf_kma() to return condition code
  s390/crypto: Handle cpacf_kma() return code

 arch/s390/crypto/aes_s390.c   | 11 +++++++----
 arch/s390/include/asm/cpacf.h | 24 ++++++++++++++++++------
 2 files changed, 25 insertions(+), 10 deletions(-)


base-commit: df2908090cda368b01ff43709f51890076c56157
--
2.43.0

