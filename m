Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C81367F4D;
	Tue,  4 Aug 2026 11:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785843472; cv=none; b=T+s7eqENNP/BUD3UIwgXUeF556JhNp2iDd5F7mP5sqxS+oRdgJOGe8Ekbi5LousZwUpWPVl4rGFC1KZPCj/D5bpJf9bLniyLb0yEWRVjOres7gacHIBIzgBoQQBuw0YHlErfoFypf6t2JOvVu+c6Y4K9OFuWwGjCukheLO5KLRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785843472; c=relaxed/simple;
	bh=FHe6+bniTGIA6/te60tBkTNFsSqn4CNCtlsDLMXxwNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YN1auuXwOs5NA/iviajW6mu1YxQIiGZfezN5RPWK2RLDOOj9WcyL5srErbjhWQFDxHmZO1uN+7WGO9Vqv7/tPwChtc16fa98Jc9DO0jsPRZwTpdW+IYZ9I5CzNwPfraJ8haQKYb8zYRNgCOn8ZVclhiKr9VsdndYEiSub83kFkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LwG52kne; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LwG52kne"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6748HgLC296047;
	Tue, 4 Aug 2026 11:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=okt/xT/2stioj7MuG+YNK9GugJ3bLhUtObiKopWZa
	ZE=; b=LwG52kneBXApYx0KKg772O37Q0mwe5b6aMZMQjGG8QRWcYLX7zzA4kBK8
	Vz4PLO9S/8QkLP9XDoWAzTxi/lDd8wQMGONKe0DKKD38IxSnenX0iOBf7P6d7nwF
	oJcsjsGcGmQpYDa5o7aouExhml/I/RVFtbnZpa3NxXbhIBzhzkBJspA6jjzE4hy/
	wN8HzxZNZlr/dtvM+RvTGRwvvyWWw0yvTbAMaakyu31wmy9TJic2OxYTVgUYrKWM
	WcoeTRTGhmYcot8xno457aK0P1MsZwt1HxYOPfCSU1GJ1WBWsupqIlrBWGLHq+3e
	/kfN1OdBs3/RheYtQtkGNsPQcP0WA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8a3wk0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 11:37:41 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 674BBKXm020855;
	Tue, 4 Aug 2026 11:37:40 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugw1tpt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 11:37:40 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 674Bbae644171694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Aug 2026 11:37:36 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D11F2004B;
	Tue,  4 Aug 2026 11:37:36 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6196D20043;
	Tue,  4 Aug 2026 11:37:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Aug 2026 11:37:36 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 0/3] s390/crypto: Enable CONTEXT_ANALYSIS
Date: Tue,  4 Aug 2026 13:37:33 +0200
Message-ID: <20260804113736.1423667-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=E6P9Y6dl c=1 sm=1 tr=0 ts=6a71cf05 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=jW6YlCM5X9v_IRLvDUIA:9
X-Proofpoint-ORIG-GUID: Xc_gt_hdy2Ufr2ErK1x_ajEsoNSdOLYc
X-Proofpoint-GUID: Xc_gt_hdy2Ufr2ErK1x_ajEsoNSdOLYc
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDA5MCBTYWx0ZWRfX1IhkfubYQON+
 XgP2ypyda8mzJcD16isyUFQkuVUkRNSg/KXSpxjLnqCrNzEhteqtzysrfM7xxFbq2Buk/5dzqAZ
 yCbFalR8WAsGqiFJMKFgaSZ8KjSKVCs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDA5MCBTYWx0ZWRfX2fc/XMLYp9to
 7tYs57pcaU73PZqV0515Oj9uJ9+rnCd/9Iwok4jPb/J+JUhfdfbcVopUqKrBW+f1s2XoV6LBpLg
 WRGHb5GbLDi8TO1mP57KdN3y+mCvmHR9vvcBLHxXmk0SbJVcLgSW0mB5tjsKQ2vSyVoKmXZiC0i
 +XlkzqkNk0LN/rfhOacqoEMygW2q9e+k94ckhscVqkXxs9M1LCO94eFT7G9De45OSJNP0kUEcjo
 mBuJHLNlyVF1XXHjhSLaNbe6doyHepL/aUfekYFZv7XH5eXXZW6HHA/6TDVR0uD/Sw6codBw0Vp
 oaLiRrVdnurL5KqcOJ3T7EZXIZ5pNMQ9sXKJD6tA4MbGsLf8b2pnJ0H4rOjkGBGe1ZBSAZIvORt
 iWWgMzycDEyJAPS0a8cWsYg08agOliU/fPIMuV5DNQivRePJ7QXG8jKPho0qxKw8CvImS9EE9/G
 ZAGaShRXbc8908Fg/qw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_02,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040090

Enable CONTEXT_ANALYSYS for s390's crypto code.

Static code checking for acquiring and releasing locks used to be done
with sparse. That was removed with [1] and replaced with a clang based
approach [2]. The new approach requires that each subsystem needs to be
explicitly enabled for checking.

Do that for s390's crypto code. In order to avoid false positives the
code has to be slightly reworked, since conditionally acquiring and
releasing locks does not work with the checker (besides that this is
sub optimal coding style).

[1] 5b63d0ae94cc ("compiler-context-analysis: Remove Sparse support")
[2] 3269701cb256 ("compiler-context-analysis: Add infrastructure for Context Analysis with Clang")

Note:

- "Pre-existing issues" reported by AI will not be addressed in the
  context of this series

Heiko Carstens (3):
  s390/crypto: Rework ctr_aes_crypt() to remove conditional locking
  s390/crypto: Rework ctr_paes_do_crypt() to remove conditional locking
  s390/crypto: Enable CONTEXT_ANALYSIS

 arch/s390/crypto/Makefile    |   2 +
 arch/s390/crypto/aes_s390.c  |  54 +++++++++++-------
 arch/s390/crypto/paes_s390.c | 104 ++++++++++++++++++++---------------
 3 files changed, 97 insertions(+), 63 deletions(-)

-- 
2.53.0

