Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58F7321F27;
	Thu, 15 Jan 2026 12:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768478436; cv=none; b=cqYCDZQkacZyMtOkN6gJwv+3mtlMxbE7wN/ub9sfkvO7uXKdJMztapJcW8Mft+Z7kN+UpgtOhWhnnS8VTm+4jTIcjImKrZLVl84k7aTEiXAO+xrp9dAdSmq/CM2UnIrpwnnYy/86ZV7vLL1nUZC6ZO9KMJmJ1RlFiis1pN0wMUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768478436; c=relaxed/simple;
	bh=d+1r1GRROQrG9STqBC2p0WVR7ajHM45+et2FwPQy+Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xcfd5UqfKQOFzIinVQRTWJ/21J9/LSvko5/s81274FADBBJxkcfPgCnQmfZFudvZloIvZEYWTHEqngm+4k+sMubEHSF8q1q+7opQtqxS6DqaQEP7HFobxGFNqtDuiRG3OfDa4cXmwOLclP/5Pycl/ANDJl9Y5r7uXgN0a3ixt74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NNCYkzB7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NNCYkzB7"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60EME8gr027854;
	Thu, 15 Jan 2026 12:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=VI1TSu/ZA0M/bIkZiO6zv16Zu8NR90zx3Q66eDRDC
	Q8=; b=NNCYkzB7XYt9jZ0+47bsvdWjpLhwukSAotS4xPbDVHfXAYQVICxMg+WNv
	5Y0rvVkjARA/0aIE282i0EZZ9RG70sB9zXFpVaykmFkaKw99sDtWr/Z+v5NLGWim
	vpQkhFtRVYPo5515/B/SP1eXvcDzFMGnBAYdkQbtipuDP85KPiqZrEJu3on80FR1
	+d2DamhXWGodjDeSNMYxWtwKcRQDEqo6QIdg7L74VdeRMcmlUIomjDtgTW+Rozi7
	NGGGhsJwhMp8ckXcjPn12EC+K6cs1iGsrDaI2uq28qrTtXQZU8frOqqKLDUoA3Pq
	TsmmiLirvUx5dqD20HSAJeBg+9b4w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkeg4paqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 12:00:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60FBmGM3014255;
	Thu, 15 Jan 2026 12:00:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm1fyfuut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 12:00:31 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60FC0RhG31195592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:00:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E38120040;
	Thu, 15 Jan 2026 12:00:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5F8E2004E;
	Thu, 15 Jan 2026 12:00:26 +0000 (GMT)
Received: from funtu2.aag-de.ibm.com (unknown [9.52.218.117])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Jan 2026 12:00:26 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [PATCH v2 0/4] Paes and Phmac: Refuse clear key material by default
Date: Thu, 15 Jan 2026 13:00:22 +0100
Message-ID: <20260115120026.4286-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA4NiBTYWx0ZWRfXxDUQm8JyY7pK
 p4T1WAYd9ehRtSc9lAkjN3mV1hjktgv+QgDkqm3DS0yyxXmwSRfPS3vTbXH6O8gEvLpZ3fg2vVI
 +XQCkZLGa3+trKr+V49D9Zdn3WV1mmh9D1mlYKKRCzKWRAFqrytkm4R3Cq/A5meQoLMIC4Y7UEJ
 ZNKOUCX3xRI6Vwytt+JAXxn/fkCR18L0WZKIEg2mXq0CdZUef5kU+YcifTs72PX+IckbYp/d8nO
 CgDyp/0NX22Qu1c9DGEPC0JqnVtIjyvPqGUxsR0TEcM/MTn2/9b2qDWnH8NvlzVhXUn1fIT4wvU
 1AScI35OnA6AmNmswot4LY18qoby4t1Sln9dirKWH6oO+vpy3GfDPSKwrgHad94HFtR/PTc4nwg
 QLoWtwV+u/rTH3tESMLi+EWa7/968xltuoDej5fQ0J2lYgVluWulPClb3eYBcTUeMGDRs3Elt/j
 /3vjCuz7GNPcRVt4nYw==
X-Proofpoint-ORIG-GUID: yD9r1Ek6pGDgdxnfOiYK86RVlWxJeDfx
X-Authority-Analysis: v=2.4 cv=B/60EetM c=1 sm=1 tr=0 ts=6968d6e0 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Xuth0BhI2LXagJz45AwA:9
X-Proofpoint-GUID: yD9r1Ek6pGDgdxnfOiYK86RVlWxJeDfx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_03,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601150086

The modivation of these patches is to disable clear key usage
of the protected key implementations paes and phmac by default.

With a new kernel module parameter "clrkey" this behavior can be
controlled. By default clrkey is 'N' but for testing purpose on module
load a true value (1, 'Y') may be given to accept clear key tokens.

Note that during selftest clear keys are always used and thus as long
as the algorithm is in larval state indicated by
crypto_skcipher_tested() clear keys need to be accepted. However, in
this state there is no way to establish an instance of the tfm other
than for selftest reasons.

Changelog:

v0: Initial version. Request for internal feedback and review
    Please note I assume that patch #1 goes via s390, whereas
    patch #2, #3 and #4 may go via Herbert Xu's Linux Kernel Crypto.
v1: Sequence changed and feedback from Ingo, Holger and Heiko
    integrated.
v2: Integrated the feedback from Holger and Ingo. First version
    going out to the linux kernel crypto mailing list

Harald Freudenberger (4):
  crypto: skcipher - Add new helper function crypto_skcipher_tested
  s390/pkey: Support new xflag PKEY_XFLAG_NOCLEARKEY
  crypto: s390/phmac - Refuse clear key material by default
  crypto: s390/paes - Refuse clear key material by default

 arch/s390/crypto/paes_s390.c       | 93 ++++++++++++++++++------------
 arch/s390/crypto/phmac_s390.c      | 29 +++++++---
 arch/s390/include/asm/pkey.h       |  8 ++-
 drivers/s390/crypto/pkey_cca.c     |  5 ++
 drivers/s390/crypto/pkey_ep11.c    |  5 ++
 drivers/s390/crypto/pkey_pckmo.c   | 12 +++-
 include/crypto/internal/skcipher.h |  7 +++
 7 files changed, 110 insertions(+), 49 deletions(-)


base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
--
2.43.0

