Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F26532E141;
	Fri,  7 Aug 2026 13:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786110896; cv=none; b=EIs8SdxIDj1X5cQm0BTKjhjspnVVep2QvKgRO01LFzOkxoxNR2DEguiG8KieakgXARu7UF8n/CP4IksFtMfSCkiJ8PTXlQbmSO2Mz/908dGEVIMUO/t0kElAhAYAhKbK5IwnR4w++WyQpPjlRPsfTUBeExXlbc5I7AGiBXqgYIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786110896; c=relaxed/simple;
	bh=oH8rNkENLKgeLaspgnuBprU2rml31ZP9+y4DfmlVZwY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CpdHd1BoRiZOuoXYfDXCwsSAcrslzqNTPJdkql66EgMNEwtG5ObOzmzWmFHXR9nGNY1DUOHuF5nGIk3GcGo3ZLi0LJBcLmaRsL2CBREyCtlrblRveCQsJXwg0AdibnMOyeooHy7gLjUB4y1v/5aoazr5Dt7R59kuDmuD25opD+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ewNrYacG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ewNrYacG"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 677ClgIZ1412025;
	Fri, 7 Aug 2026 13:54:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=cIvFVYNCi90SAhBArLMHsZMnkKkNdOQJR6pkK15vC
	Xs=; b=ewNrYacGbftzZjoFyQMl4yGfwKPq2xI+6ftsCwxuu20WmxSUH3zpMrcOs
	DDV/5fVjoedE9EidNw9tSNton+vj2OQOWJCjjzg7nQYxiaW4c5d1rQtrBslxc834
	/D0NnIeQP1J+o1JObYm49uFd9IHxLxRzwNeS+X0aM2Z2u/y/Lxcpg/mIDrkPxmtk
	vBEo035o7lUO4AV/3uJ/9cJrQI7RMPauP+T3p2CTmNgoSRYSqwPYz4mDmpgx8cDe
	ddVH2EZmCxeYUOUpCGM8aL3RtTEHYge+BM77QLCuFBtO7QOph2KnullBHqIzWpfL
	V8nCctW+kKuwI2PasSBywsy9KzG1w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fvy02c2ca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 13:54:45 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 677DQGW4013729;
	Fri, 7 Aug 2026 13:54:45 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugwg183-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 13:54:45 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 677DsfPY34931180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Aug 2026 13:54:41 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0EB7520040;
	Fri,  7 Aug 2026 13:54:41 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DCA8D2004B;
	Fri,  7 Aug 2026 13:54:40 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.146.84])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  7 Aug 2026 13:54:40 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 0/3] Fixes and rework for aes_s390
Date: Fri,  7 Aug 2026 15:54:37 +0200
Message-ID: <20260807135440.35888-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=G6ws1dk5 c=1 sm=1 tr=0 ts=6a75e3a5 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=qyTEqAoi-3Pn3Uo7ykoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDEwOCBTYWx0ZWRfX0J9WikQEetnA
 TTFS2wHIovn//n5/ZqQ18Am2PqOP0MlArzdlakEVhyTMjywKgz48tFbWV7OkAIqbLc8ccbUd1dq
 Z+VRqUgtxuWMRSh6UIslw5o11OuPMzmcfrlgOjATntvsW1VfZsfqNVw2sUViC1xr3f3dcjOiO3A
 ssmfl9XnYF9Fn8OsspSvATsx8BqihW5JoBfuz9O3G11fPFC7tJdDFAHaN78jnPtrMFcdvvJ9bRa
 KyQObK0S/s8QmxZYQ8dBTN6bXYMLcGW1bN2MaXw0/X79aVhS5NMs9wmExx8L4BfZjYkD9VPAcBT
 UbxlTbW2UvcCqE736A6IaH7s6Jy4SBvkQ4OZi5gDnMPMYukXNJwqaJRTGnesiGhK+bEgWH2vUTS
 x+N+cPpw9s1pUTqwB798LgLQHLujsfYRIJuJtXeIO09kt5mxhMorN7pUNpF19B9X0wmiw8d4QUs
 GEus75o7+Pffk/RBqqA==
X-Proofpoint-ORIG-GUID: p20AFmE-lvtjxQRN4XWjNCTVbmyAX3aM
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDEwOCBTYWx0ZWRfX4/oXks3ghXgj
 9AXQkKPmKWdtEQCP32PdEFKxKctdO2yfJmef0QS4wmiKttdud+LdHh31JnUNKdiGR9yqgHgD4H9
 YqkPKhoCiQu4hCYuFfEis1k4bdTwvYE=
X-Proofpoint-GUID: p20AFmE-lvtjxQRN4XWjNCTVbmyAX3aM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070108

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

Harald Freudenberger (3):
  s390/crypto: Fix skcipher_walk return code handling in aes_s390
  s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm
    algorithm
  s390/crypto: Rewrite AES ctr mode to be prepared for context analysis

 arch/s390/crypto/aes_s390.c | 82 +++++++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 30 deletions(-)


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
--
2.43.0

