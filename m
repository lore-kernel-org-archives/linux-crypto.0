Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BBC48F840;
	Thu, 13 Aug 2026 15:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786636464; cv=none; b=O6wbXX1oOdkNNPS0prUspSuXRGb7MCb+r5mUSCJn8xpQDydpxJa6ID7AFe9axBlTrCXEBfvQy+LBXvqIh6GLpRxrLnLd76/+ypaMTVbs3tDzSV5HemMEbmK+NXv3CjJKy6IX95Vooe1YQlcGZWe/OV8hzZI3mrhVaPwyQtYjc1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786636464; c=relaxed/simple;
	bh=5YIVEGivZ/P7T+XUgaHcb6bQi+E+VRL/o1E6Y+9PZrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I9jW15CWxrlcJd3fopc0pmckl8BTkGCYvwgGmIvV9+ciECfobuTd7G5RpsfTMJXqOgZtgTOC7KssbtDKvgk5H2bTak5ILimndzPuxBWdyBi4k2Cvrrat6Dy8nNtB5QMdOJ5qVBtNDr7Fd2v5sud8kbZRJ8vacC+pLIfgI9r7cp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=U5HqBTB3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U5HqBTB3"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67DFWmYQ860983;
	Thu, 13 Aug 2026 15:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=xGScsWuzcS3SHYq6DOKGtyh7yO1RJJSPwi6SfrnQm
	5Y=; b=U5HqBTB3iY7lvBknGYzxYTHRFQHX80jNCowDD7dmAluQM+SIRd+eTgBkN
	CR1Z1ibjlsNQ0fBFjEHe9ZbGfeGFtEuqDqE4DYSDRqQWlpkajoEnR5z7dh4wezCQ
	6PsF4O13qW4Mzi4zyKLvCFuIxNrLgTjyn7Ok0WQOYIHbAWNWTKIprh28yvVqZcwB
	mFT8U/uAEGjMyWTrBkotszDpOd5jEE0q/FhJch/WV3TdCyxc9V0b8cw0pW+Qzwjj
	POubyyZucIyQ8qzTbwDKLIoiBnyYu6NddGbOT0ph+fP8eVTY+i34bIWBKoUj04qC
	5s1F6ZZ+BIAbEJBICgCyyDUAWuGPQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvk08pfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 15:54:11 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67DFfljF025579;
	Thu, 13 Aug 2026 15:54:11 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxesqbrun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 15:54:10 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67DFs7Gx29164020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Aug 2026 15:54:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F2D2820043;
	Thu, 13 Aug 2026 15:54:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9C8420040;
	Thu, 13 Aug 2026 15:54:06 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.193.32])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Aug 2026 15:54:06 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 0/3] Fixes and rework for aes_s390
Date: Thu, 13 Aug 2026 17:54:03 +0200
Message-ID: <20260813155406.50051-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDExMSBTYWx0ZWRfXx7mpRrHv+8Uy
 unAGQVBP4JSDPvJRCvOgkB3hSlL9AHkSv87Awdniczat4tqqDwD39OLoYJtdRaCTk/kZehyHemw
 ynhdzUdEfHP8ZFEq6XBeBfRFUJSGnezCZD+5EFTksvtPJC4hpx58qJg/k4kXJZ3WtAT6326QDip
 wZCjVI171SyUCyCkmpciOyP6suIPLtmoz8SbUhM4wOE9x7vk/zm7q8u+hGoPfSuWs3kbzfdjfQa
 zknIX/T5x+WKrtgOgrFvJ6M8/Pm6cKVGpAfhhnO2a5xkmnyNRXJgO2iARSLjwGjC/RJHcpf+v+R
 k3Zn3/DwdeJgyRL2f4ry0A+99YYSQVBFB3eUZklWyhcvZwwjQnaoqRfsNOWSTR94A7rXBfARHZH
 BAZ/rzvC4A7+wEFXexK0iyHENksAzsSJj1VkLzejJmbG0hNL6Ig+1Fcjkgwsk9RA+uwh+XGEkDm
 uXg3bb0GM7naeuKNcxA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDExMSBTYWx0ZWRfX2iESCwvCtMQl
 Z0qqDaj4ecBoy9IV3yEa963cazEB/ecTk5nu8Mi5LKPlj7uIKYqh1NC+jJgoMaVhMryNiMfK9EB
 xkFm3qazo5rlY6gL7ETfOOn+2M1xwjE=
X-Authority-Analysis: v=2.4 cv=RqD16imK c=1 sm=1 tr=0 ts=6a7de8a3 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=qyTEqAoi-3Pn3Uo7ykoA:9
X-Proofpoint-GUID: -sMaR-oceuePraoO_x0iIh4uEykKKrCW
X-Proofpoint-ORIG-GUID: -sMaR-oceuePraoO_x0iIh4uEykKKrCW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608130111

Fix and rework some issues around arch/s390/aes_s390.c:

- Fix skcipher_walk return code handling in aes_s390
- Add scrub of some temp buffers
- Rework AES CTR to be prepared for context analysis

For more details please see patch headers.

Changelog:

v1: initial version
v2: Fix missing scrub on a temp buffer used to process left over bytes
    in CTR mode.
v3: - Yet another buffer scrubbing was missing. Added to the 2nd 
      patch and rephrased commit header.
    - Added patch to fix one warning with context analysis regarding
      the handling of a mutex with the AES CTR implementation.
v4: - Sashiko found two unscrubbed buffers in two variables in the GCM
      implementation. So handle them with memzero_explicit().
    - Added one condition to check for the CTR algorithm to invoke
      mutex_trylock() only in non-interrupt and non-atomic
      context (which comes down to process context only).

Harald Freudenberger (3):
  s390/crypto: Fix skcipher_walk return code handling in aes_s390
  s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm
    algorithm
  s390/crypto: Rewrite AES ctr mode to be prepared for context analysis

 arch/s390/crypto/aes_s390.c | 84 ++++++++++++++++++++++++-------------
 1 file changed, 54 insertions(+), 30 deletions(-)


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
--
2.43.0

