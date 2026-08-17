Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623403F86F8;
	Mon, 17 Aug 2026 10:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786963331; cv=none; b=Lh5iG1nRk6O1VHuE9OE63+UlY/QWMnEPbs1pyH6quMf3IkGiOwP1MRb+Bxr5PjTIDoLE5AZ+NZcxlXCWri+/YQUThEjKaXgpSALusWj7ihf6ez94EVRaqyIxWpzD4+bAGoJ3jv9RsTed20+zkker58eeGStHeVUPjaiHGWOYa5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786963331; c=relaxed/simple;
	bh=K1xCrHOIG3EScgzlhmtMoVK3pDxD3zo2wqyYu3JU0zw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WWdNCzkZKjomqVx8YNmjE6kNpAPVREcLBAo9tw0vF/SIOI70BDggoxuQH4oIbwW39n7SMA/0x8GzkNTiG6qeMywQmZbGLDUuCCQQzlks51CtdJqTpj8lUHe6uWfjWtqyDrH0XUqj9lEFUbiWzywHYh+RgCj/C+jsEUGJ02GWUz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rcymgOKk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rcymgOKk"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GLVqih3636259;
	Mon, 17 Aug 2026 10:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=NwYGvrLwVOa0ZNm7E12DnM6u6zXfX2xynvds55uLz
	LM=; b=rcymgOKkQi5TJ3Pii2Z7mynxpK9crAcLyHE2MYBerGhgVHD6rbDkCu/i6
	ywTnPh5VXOuZ6jNHqMlAbBlZ/PF93y14KEwErkhm8Dd9XPszi5u4YmNRiQLMBFzB
	qRc0qlVdo9wkFr+gElT8GVEPdw69qgYhWQtQv7DykB+Nw1eqKHeyf6M9tQ5Duze9
	2gEkYjSsVOfDvP9L+t5gs1GXQa4m5KxQ3tNeueqK4XiNCfc+O+2nk5se7nkiJTFG
	0vsl1fg3VTko8I4CSVxPyLohwpI7t0AG2Jmpo2671mFa51XWirLYlTcYHc93WnC5
	MtHMIrJ9XFtQ1fw5JP4WFqfIvfXDQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2dhkssrn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 10:42:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HAfL3l013442;
	Mon, 17 Aug 2026 10:42:07 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g32tvws7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 10:42:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HAg3RZ48693554
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 10:42:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78E3D20043;
	Mon, 17 Aug 2026 10:42:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 529B920040;
	Mon, 17 Aug 2026 10:42:03 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.162.247])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 10:42:03 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 0/6] Fixes and rework for paes_s390
Date: Mon, 17 Aug 2026 12:41:57 +0200
Message-ID: <20260817104203.74033-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA3OCBTYWx0ZWRfX3tkjQcQSG7J7
 87ckGqx4lL/OPmTo8Auvs+SPavIdTv/Lthk3XvRW5XtD87zzXtlrG06nSaab5rHKW0XSw8h98SY
 aW6xIcjMIV9cnyRkajQKB729xoOMe4VIiEaPvTgRJQxSIIGxl4KC9ngIzL/GKzUJ0fHPn/ur2Ef
 S2cDkHWcbgszkEhWpA5dphZDtcMO0PkB6VZr1ObOWojoTnqx26ZKjFN7rjcPwwI5/U+CUHpAGtt
 QeUqwv9jGTx18DdBe6rpgf25B0EELxIxF8z57qu+gBlFxEvzuGmaaE2DqckJA2qGPKkp9MoiFMd
 obyGnfa9xYNd9B3OKRNs0VZlpNSGQWTbvDRpXqkHTmj6uixRvf/k+lmInJEbTcP2wz4YJjfjR72
 2B1h+Sg5D7BxnVbkBtqgnykODf3fTJEUZByFYulvWVZhGJnBmlLWbCdy7D/3IJg09fqZfwdwcQp
 TV/0cHXZK/hXV1AU4hw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA3OCBTYWx0ZWRfXw0XBWLrnhUEa
 qmj7D2casnCRUurVq510PpZVBILml2d5Dc+vozWPRLy0JSfRZXVZWcWaaIpxDOSPEGOrnDX217B
 Ylv9FEWZ0vh04J7nLXdyGZP7BJMr+uU=
X-Authority-Analysis: v=2.4 cv=JKkLdcKb c=1 sm=1 tr=0 ts=6a82e580 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=g5o89Mr_ll_zXKoBrf8A:9
X-Proofpoint-ORIG-GUID: 1C8enpx8g80x-j91XkXeQ4DP4G54xtAu
X-Proofpoint-GUID: 1C8enpx8g80x-j91XkXeQ4DP4G54xtAu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608170078

Fix and rework some issues around arch/s390/paes_s390.c:

- Fix skcipher_walk return code handling in paes_s390
- Add scrub of some temp buffers
- Shift from using a mutex to using a semaphore in PAES CTR
  Surprisingly clang code analysis is able to deal with semaphores and
  thus the shift also fixes the issue with CONTEXT_ANALYSIS enabled.
- And some more fixes related to paes (see changelog).

For more details please see patch headers.

Changelog:

v1: initial version - however, all these patches are follow up patches
    from a similar patch queue for aes_s390.c
v2: - On one error path in the CTR implementation the scrubbing of a
      temp buffer could be bypassed. Also checked Sashikos claim about
      possible double free but this is not the case.
    - All paes algorithms did not set any base.cra_flags. So now set
      the ASYNC and the NO_FALLBACK flag.
    - If a request is pushed to the crypto engine there is another
      return code EBUSY also indicating success but the code handled
      this as a failure.
    - The very same was with the phmac implementation. So corrected
      the return code handling there as well.   

Harald Freudenberger (6):
  s390/crypto: Fix return code handling at skcipher_walk_done in PAES
    algorithms
  s390/crypto: Fix missing scrub of temp buffers with PAES algorithm
  s390/crypto: Fix use of mutex in atomic context in PAES
  s390/crypto: Fix missing cra_flags in paes_s390
  s390/crypto: Fix handling of EBUSY in PAES when req is pushed to
    crypto engine
  s390/crypto: Fix handling of EBUSY in PHMAC when req is pushed to
    crypto engine

 arch/s390/crypto/paes_s390.c  | 76 ++++++++++++++++++++++-------------
 arch/s390/crypto/phmac_s390.c | 14 +++----
 2 files changed, 56 insertions(+), 34 deletions(-)


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
--
2.43.0

