Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876553E172E;
	Mon, 31 Aug 2026 08:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165470; cv=none; b=LuXf/3ThKHF/KkFoiNNz0Nly1HOp0xSPimwEGcF7KCg/Hy4R4mCcmjD2ktsm+DRPmrqWGW9MHeVQ9frN40MGLT661NjDoY87tui4zxKX2WuqGLoSFhFqt6fW01HOfdzxJ3Vhucijv4BI8QiKsAB8GQvDbYkXnh0AaRCyZYvvWYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165470; c=relaxed/simple;
	bh=+Kj2kaFLRSwVGm4IRnbqNSBB6Zw0tW3a6RGUPEtH0Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lkhUF5F7F83FjkEvrp/eFQiwoY+hsZwz+r/hdnya3hodCAAZh7UQMDWuEU0UPoYVRAjYF5cKgeMmNTzDqrbjQsDc+cWJU4iVHWpmJIyVGKaQQcZ8MNHl3X4nJ0uSFBvbTg24yTNSreZRrad97YNEPnkZ6i8SLyceEMBM8AstXSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ABlFxkF5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ABlFxkF5"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V82GxC1530786;
	Mon, 31 Aug 2026 08:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=fxMCve/s4aIGx1NOCV5XdP0EX1ukXa9oguWTujuNy
	FY=; b=ABlFxkF5coftQYAErbmHAlRVyoSbx+qbRXTpjNyIV8lBSsGWs5Djl/tLM
	offqqn12Bhurdnf6o202P5p9Y04t8Hxk0PzmvmCrk830kizH5CL3d5Y8ah5aYf2n
	/YcIFMTEOmcxEipbGif+LNWlNMF27VLcm7XbougqClKs4dbFoFAkzl0/jB8ZcX3t
	Tl4faZiVgN/eub7DbE/knr9XfjbeJdIfe+YCAlQiGriarTOMjnF0VUH7iTsETixK
	l8MxDM16/Lmlz9odkH1D+TC8MX32YQFRUcaWR+KF+P40/HZ3A5NLGMTjQE92IOlV
	uV8gbwE83JFsFOYxQayGana5yd05g==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbmuhga04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:37:40 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QiPl023369;
	Mon, 31 Aug 2026 08:37:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gc9rq51jm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:37:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8bZn340108308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:37:35 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9847D2004E;
	Mon, 31 Aug 2026 08:37:35 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78F012004D;
	Mon, 31 Aug 2026 08:37:35 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.165.38])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Aug 2026 08:37:35 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v5 0/3] Fixes and rework for aes_s390
Date: Mon, 31 Aug 2026 10:37:31 +0200
Message-ID: <20260831083735.3625-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jyRtFK-k3IceqhvDzkzMHLcDfWCkJqUZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfXyEUlq9+HLIys
 8uJ7NTghz0t1DFSajy/RZesV2MaYbQFdZO1QQsZ04VFsEzga8pASKWbjjU3QySF+uYrjkgLONqJ
 vXpaqlEABW3ZXZRR2CmjVDo47DjW1RHfiWQuHQx0mH57wbamaj/kJZpWnM1woxewrs5v74CRPXl
 iGc/Fnif0zDe4+yFRJWQUv5YeTMEV+9iVoOYysJc1YGWEhne6ZJpw1atoHtlWRepndaYiVnUzaS
 ElPQaIRlbgD+jjkt5iUbzSowWYIkSlfaz5lSunNtMQyQzf6obqQZ+3ouMclvmuZYPdrG7Mc/05h
 f9vUCTvLw7Q6oRsUgwbZhQaRNKxs9Q6c+1LhllPSAchbMbVL6ZlqRN1EqqC91bKuD6RZJBoxk8H
 7C1g47Zmb1PF+0ARNX59JO7SIMxlWBpRtC248EOBkyrVfFTKlFHdldHqKbTB3tN7mdEv8HHGl2+
 TBX/EcChjODL5/a2Cxw==
X-Authority-Analysis: v=2.4 cv=Osl/DS/t c=1 sm=1 tr=0 ts=6a953d54 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=ThbNtLrIaRZL5PN1bA0A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfXyAcGTkTt+LIp
 KqYWkh8kmLgPLocOBU0TtaqJPhi2IAhVfA0DZG8hEFm2cm/Lic7gtk/8HN3eJUV3f8ll30fXD6E
 FGqUTw6V8ARLKjCHe+ichbIlHWVpZao=
X-Proofpoint-ORIG-GUID: jyRtFK-k3IceqhvDzkzMHLcDfWCkJqUZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310072

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
v5: - Added R-Bs
    - Reworked the mutex to semaphore patch to also cover the need to 
      get rid of the conditional locking.

Harald Freudenberger (3):
  s390/crypto: Fix skcipher_walk return code handling in aes_s390
  s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm
    algorithm
  s390/crypto: Fix use of mutex in atomic context

 arch/s390/crypto/aes_s390.c | 87 +++++++++++++++++++++++--------------
 1 file changed, 55 insertions(+), 32 deletions(-)


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
--
2.43.0

