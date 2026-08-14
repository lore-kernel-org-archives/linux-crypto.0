Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D0B46D09E;
	Fri, 14 Aug 2026 12:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786711047; cv=none; b=lw0XKYhoZSfqaVR9KxPlAjR6eJ0IRphlQUZ6D8Y+sllXN5ZFHzBgDPEM25b5yz6TA95ps2qALXdWtmHbEeXzMvfJ+0Vj/793TFN3F3AOTXeNhAYB8ZvBi178ONS1QEMp8z8BvoO34peAeOC8vlvSGbp4qORVS1gUhmzvStzmLuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786711047; c=relaxed/simple;
	bh=bKWLSPb8c26nywhU1m3opT+LO87RJJrhlUJV/tDxMpY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JzDkm8sY2ksTFkegGxRB7i/nz4+J9GqZ6i8gzI3k6IFW5kZb3fqBOcDa/0MQ5rxXvwObl03mS1Tb9f/cbE8LRsBK013iHmFYNafzGmXulgmWd1IZt09+b6quMFo1o83RPFSaoSwdYWdKECUXalyTRYWntSXiul6JXySr7xfFQx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mhIkLpZ+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mhIkLpZ+"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EB1jvU4037487;
	Fri, 14 Aug 2026 12:37:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=zetjEkqtjih34Q1wcdyTIKyKqvNaCYQ4LJWbIN8+w
	/Q=; b=mhIkLpZ+4+78+BXDHk3x2tdBvnivY5H3YcQ7AQGorTGPwK7x5weWxYJUa
	5ZRgJKx8ZN3rrIL6BqZv7h8cg1JzBqk6vuCPhEReN5bklS60qIMrJp9dhwIhjXzX
	t/34C8m/OoryDX/66cItINn2xmHIJzJgV2x23qIGNkn2pRjripwTJyakw92U8ZYb
	c6DCJZQoLU3sNb0+mYkAggNmuVV0gb3kX1PM+JtqdSTCcD+UqjvWuWo5Dab5Aj7e
	eOb+cPH9InWW4Ser3cRiukaCbD+mX66O8qFtT4XbCTDEu5Gt5Re42vcCGth5dv5/
	fHxLYk4Wl03T8PyqDel00zf+psDyQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fyb244y5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 12:37:16 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67ECQREZ027269;
	Fri, 14 Aug 2026 12:37:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxfsk78pd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 12:37:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67ECbCOK44499368
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 12:37:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04E1D20049;
	Fri, 14 Aug 2026 12:37:12 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D431A20040;
	Fri, 14 Aug 2026 12:37:11 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.129.52])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 12:37:11 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v4 0/3] Fixes and rework for aes_s390
Date: Fri, 14 Aug 2026 14:37:08 +0200
Message-ID: <20260814123711.61145-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XqfK/1F9 c=1 sm=1 tr=0 ts=6a7f0bfc cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=ThbNtLrIaRZL5PN1bA0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDA5NSBTYWx0ZWRfXxP4YmVDPMvDl
 OqdZLPvz4JbD+ZZwgSxxPC9KWA3/5Tq52gRH5UaehVrgEYSRJSJcW/SgM6xdGudKXFC27fpXU7E
 fyCq+0XOtz1gxbbkcB12LOvdtCtjuiBM83jpbLbfMPraiYggs9jS1Ck+CVcqWpczEZXmUSiYn6h
 PifuSOnNKvjnUx8egF9DYG4ZOYHUA9qWT2vTTKedv/cqkJji+Ei/PMrfd2dml5xcf/ZsJPL1RN0
 sbsZHFTEk0Cq5mMECCCSEiltligmG4bDbFmMjU4yhFHMtBIW+GLXxVgWr0w7aBT636HV0oeGKEN
 hPhPFuR/2k1o7Cpo/Z6xFb2hzR1vxn4F9JMunZaOrHbk2zt8lI/Ilz4cR7OWy1jUG5EEM30yDt5
 p0dgUCSDjWdEjM/8PqwypGgDYTAQzwQ2c0uU82x2GrEtYd+gVgTFEC8TsK15KCLTyIC0l5KaVmh
 q3JZvuWXM7xkMqZzh1A==
X-Proofpoint-ORIG-GUID: qK1dzVCYmIcH70bM5Z6UqzmWoqv4sH9R
X-Proofpoint-GUID: qK1dzVCYmIcH70bM5Z6UqzmWoqv4sH9R
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDA5NSBTYWx0ZWRfX5Prf7UzPE9oo
 f6lgzU03KkntP2vbsDa2ALbdUkvOxKDV537CeinNdP5D/2ST+cwGpn+ZdbxJBkr2LJJaoaiX7wD
 F/Kt5A3ekmVx+/oXUcvuYmnLe823ZSA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140095

Fix and rework some issues around arch/s390/aes_s390.c:

- Fix skcipher_walk return code handling in aes_s390
- Add scrub of some temp buffers
- Shift from using a mutex to using a semaphore in AES CTR

For more details please see patch headers.

Changelog:

v1: initial version
v2: Fix missing scrub on a temp buffer used to process left over bytes
    in CTR mode.
v3: - Yet another buffer scrubbing was missing. Added to the 2nd 
      patch and rephrased commit header.
    - Added patch to fix one warning with context analysis regarding
      the handling of a mutex with the AES CTR implementation.
v4: - Sashiko found yet another buffer which was not scrubbed.
    - New patch #3 which shifts from using a mutex to using a
      semaphore in AES CTR as this algorithm may be invoked in
      atomic/interrupt context.
    - With the shift to a semaphore now clang is able to do the
      context analysis. So the patch from v3 which reworked the CTR
      implementation is not needed any more. Note that paes still has
      the issue with clang context analysis, but this will be
      addressed in another patch series.

Harald Freudenberger (3):
  s390/crypto: Fix skcipher_walk return code handling in aes_s390
  s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm
    algorithm
  s390/crypto: Fix use of mutex in atomic context

 arch/s390/crypto/aes_s390.c | 39 +++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 15 deletions(-)


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
--
2.43.0

