Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06C1463B63;
	Wed,  5 Aug 2026 12:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785932942; cv=none; b=nsUQwG131q+6oq+9hQiSSHfMrjzfF11RIYWuZVrPCv9+MVAgGW5efIOUxK+ootQrvPNVvAkSKb6M9f8DxMcu2Poh2VxwT1cOVD1J90rfFZE3NTRITbaW+0onaQG+BFOePmOXMWXeSKJU0FfZkHcopoO+TmCkM4vVdAZDNbQlKws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785932942; c=relaxed/simple;
	bh=aWArA6f0Eli5lGIP4dE/vfTvEbNthnNyqqbRBtQsebg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cK90BoqrgcY3xJKc1CiLbUm5DVv1RpIhqgXVFC3g74uA/DpD15TC2h/xqPas9E+ez+dB9KsB3IVIq90FN5h0rCmwNux91IVk2oE4SHlUN/5oRvqJc/QuVufWjq2eJsv5c0r1H4dzCdGJ7j3gU3stdxMLu7saR1aF0NMHzUse0xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BCorKdlv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BCorKdlv"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675CHds93725276;
	Wed, 5 Aug 2026 12:29:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=ZubI4ceAzO7FBsCxjro0bfFvXTcU0I4fWOv06u3nh
	1I=; b=BCorKdlv+qYyOpQekdSs5GggRzwEwA9Y1bSJosxoA3KH6SlG18kwrvpBo
	mxFahOYWsbCKP/Cd7BjUZPBmxoeLPGt4lXBJ5HoHCJHDRow5lboQb80dswYA7qPh
	8bxLnqs34SMZ44YAo020Hkn+DqWJIMFhiB5ZFdWEGCRywFtEJXfjKYHrUKZbieP3
	CvWFu67U9Nc2UQrqv/rkiZajGAWmtH9lIu7ruEP+NzUVdknDFz78gURwAfWNKXdP
	B0zSOtX1Sc2lWaIqpx/kcDNC2f3Z2mgH3ya83zzBZAEltSaDPktwAXv6NXDvoDpJ
	lEhu71rH1uLJKXmJio41aSYE/+/ZQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs67htr8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 12:28:59 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 675CQGsn012366;
	Wed, 5 Aug 2026 12:28:58 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugw6kmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 12:28:58 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 675CSs6533620388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 12:28:54 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 231142004D;
	Wed,  5 Aug 2026 12:28:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE6C32004B;
	Wed,  5 Aug 2026 12:28:53 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.168.79])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 12:28:53 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v1 0/1] PAES - Fix rc handling at skcipher_walk_done
Date: Wed,  5 Aug 2026 14:28:52 +0200
Message-ID: <20260805122853.9677-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA5OSBTYWx0ZWRfX14RO2wupZLfc
 8SPWgE19hlyMdxrmpo6Lf1SRJ16aY4J8ov0cH1o7ufDciVo9dLNvkQDX+12guOhrVLh5MFuG6jr
 TLhTdxCUxbceogxsvPfe1X5p3yY0kkU=
X-Authority-Analysis: v=2.4 cv=I7VVgtgg c=1 sm=1 tr=0 ts=6a732c8b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=n7-019tIh6JZ3u0UmBEA:9 a=zgiPjhLxNE0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA5OSBTYWx0ZWRfXwlk6nx9m4kRu
 xmfjmFi0zC/dln81Cq9ms2yBvDx/8EpYg9CzVLLC9Tx0CLccnqdZIEgGN6pPOzcOHaM5B3y/wHt
 cCsEpvPEj4ysOxVY0+7RaIPr3YgJlLrf/OHc6fdlhn1mrXRAfKX2L0zRE4BSfdvH0Dfe6BuB24j
 H+l1DQ3pkmzCt00A9VGn/+Qfx7/uXPJ0NyxrsMfXyQxxqwpY/2dEz8/Ikw410lH4cybXo8vsRMA
 2GNEMxc4ga3uHfVAMhFWcUU1y4D/LesYoWekghMf4rNVOr9mHZYgP7wPTp2PSWMIxhutel9Cx29
 WFi+HrTISFCZ8zV96bNPXhzVEt2Ey7pkhmmiKf3xE0CExfwRBkVHxOGLQFNPFeS1P/a+u13AUmA
 9l4HXFkkJYNxH0hDGr+kc/nzudsVTjg38Bnmhd4p4HP6T1DFE3RF5TQRZDvC/6JohSAb4tscGIY
 dULW1Quh1S0nzAK4EJA==
X-Proofpoint-ORIG-GUID: NnS_DSY3m_twzHeOevfb-D4VWwT1DwnU
X-Proofpoint-GUID: NnS_DSY3m_twzHeOevfb-D4VWwT1DwnU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_04,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050099

All the 4 PAES cipher processing loops were not checking the return
value of skcipher_walk_done() immediately after calling it. This could
lead to error masking when both the walk operation failed and a
subsequent key conversion was needed (k < n condition).

Add immediate error checks after skcipher_walk_done() in all main
processing loops (ECB, CBC, CTR, XTS modes) to ensure walk errors are
properly propagated and not masked by subsequent operations.

Changelog:

v1: initial patch

Harald Freudenberger (1):
  s390/crypto: Fix return code handling at skcipher_walk_done in PAES
    algorithms

 arch/s390/crypto/paes_s390.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--
2.43.0

