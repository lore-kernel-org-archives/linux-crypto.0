Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B932D25A33B;
	Thu,  6 Mar 2025 17:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741281132; cv=none; b=Kh/PBzQcvkO0A5I+3aU9eqbNSNiQHeXjNLfg2y5cj/epW+leGgPv/cEcelapOUDb1GlYKAHB+jXR8BHM702POrGqKuV4d6yW1casDOW6aCuA4doVeq8EtGku53C71oSMNNPbMJ3EbhM3nx/7wkrvN4onEIefo0p016e0Y5sZqOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741281132; c=relaxed/simple;
	bh=Emc62FNKKIXYt5DVZJX0OEhE553d0lO8KqF1brJEdkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s20CY+LFcjnuIf17HsHMo+njmmtWHRNwoyuIeHhopsQZImGBECfb6589YFI3rluizgXKQWH703LYkZ73qhhKPWXj5TjjtZPEmwRIaGdJBI+FWPKS1T/+NMSnbiF/ruekkrz3IQ0NFF0Kc5uXzPPBdWXouTwmjclokI5ZfyPZQ0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=azLRiw7x; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="azLRiw7x"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 526DWT8b023980;
	Thu, 6 Mar 2025 17:12:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=On0/Wm6cAb1ILCOoQidqS/MAfNGc9wBhiWRsDfX7Y
	KU=; b=azLRiw7xf2eoxcOX4qwK0lbNAanAE3M6aCV0FzO+GL2a2gWTbiv1p1mXc
	Pq1FIbAeDGBbI0ZfoQmiLFcSW4ZyBOYG+U61qFSUNCdU35pNG8utYNOJXyMZokuX
	mv8fRerBhVSS3aJ3MjWePgtDA1bDIDuMlORt+qUSKChSbH0nw5w21ODlvhD+2tq8
	1GjBzrVeLWr1tRJLNmn4OBWj64noIlVAqYyRCi7UwfIxE98G5/1hzaXmedKJVmae
	D/+Qqk1PGhrNGbdyPRJ9voemXBKnbwiYHojjiR/waCsBaIkOZrvD441ppEhHxKmY
	kI7al43Bv6lV6+5zlsnKTTPlSDuuA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4574393w58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Mar 2025 17:12:06 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 526FCqni031827;
	Thu, 6 Mar 2025 17:12:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 454cjta5wb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Mar 2025 17:12:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 526HC2Ec57344310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Mar 2025 17:12:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC6532004F;
	Thu,  6 Mar 2025 17:12:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A24512004B;
	Thu,  6 Mar 2025 17:12:01 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.179.2.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Mar 2025 17:12:01 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com,
        fcallies@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 0/1] Rework protected key AES for true asynch support
Date: Thu,  6 Mar 2025 18:12:00 +0100
Message-ID: <20250306171201.17961-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6CKga6i6hPvY7xaLw3aRQn8C68GxPOP_
X-Proofpoint-ORIG-GUID: 6CKga6i6hPvY7xaLw3aRQn8C68GxPOP_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-06_05,2025-03-06_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=634 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503060129

This is a complete rework of the protected key AES (PAES) implementation.
The goal of this rework is to implement the 4 modes (ecb, cbc, ctr, xts)
in a real asynchronous fashion:
- init() and exit() both are synchronous, don't allocate any memory and
  do not sleep.
- the setkey() function initiates an asynch work to convert the key
  material via pkey interface into a protected key. setkey() does
  not allocate any memory and does not sleep. The asynch work is
  done in an own workqueue (so not congesting any system work queues).
  For the pkey API see more below.
- the encrypt/decrypt functions first try to do the job in a synchronous
  manner. If this fails, for example the protected key got invalid caused
  by for example a guest suspend/resume or guest migration action, the
  encrypt/decrypt is pushed into the workqueue for asynchronous processing.
  These asynch triggered workqueue functions of course may run again into
  a still not converted key or the key is getting invalid. If the key is
  still not converted, the job pushes itself into the workqueue for later
  processing. If the key needs re-convert, the conversion is invoked
  via pkey API. The asynch workqueue functions do not allocate any memory.

The pkey API used here - the function pkey_key2protkey() - uses
a new version of this in-kernel-API. A new flag PKEY_XFLAG_NOMEMALLOC
tells the PKEY layer (and subsidiary layers) that it must not allocate
any memory causing IO operations. Note that the patches for this
pkey/zcrypt/AP extensions are currently under review and yet not
upstream available. SO THIS PATCH DOES NOT COMPILE YET.

This patch together with the pkey/zcrypt/AP extensions should
toughen the paes crypto algorithms to truly meet the requirements
for in-kernel skcipher implementations and the usage patterns for
the dm-crypt and dm-integrity layers.

Changelog:
v1 - first version. Applied and tested on top of the mentioned
     pkey/zcrypt/AP changes. Selftests and multithreaded testcases
     executed via AP_ALG interface run successful and even instrumented
     code (with some sleeps to force asynch pathes) ran fine.
     Code is good enough for a first code review and collecting feedback.

Harald Freudenberger (1):
  s390/crypto: Rework protected key AES for true asynch support

 arch/s390/crypto/paes_s390.c | 1482 +++++++++++++++++++++++-----------
 1 file changed, 1015 insertions(+), 467 deletions(-)

--
2.43.0

