Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0072147FB04;
	Wed,  5 Aug 2026 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785945306; cv=none; b=VO4rOKFTKCH8yfKL4b8ShKnRUfe6bN5c+qpn/hTgwixRoqVeYWaCLcBPrwGz8tCFab6EnsD1eRpddt0bybUlQLlGsuGvDzMYTGrlQLFQ3jn+pX5egW8GyOsH9lo1tp2ghyKGY3X3E8E2Tyt3tEzhrl7+HFdx3VThhCttEv1Np0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785945306; c=relaxed/simple;
	bh=3DjhGQToKc9w252L8k1OfX/rnBKb7lfmupvuwYC+li4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzLU9/egKd9iO0NmWFg0Exa6rX6Mr+1KN1W5j19c9lKATiC3/c7/y7LWQMIsWtyjS4JBL/C8ZRMDHL2M+/pzXGufUOPPjHPy7WKNHK0LC8116/xOqjyocQ0Yo9vmsFrnZE3y1dtRj3TSyUSb8aVStiq16ni1lVX8TgUFY6mzxbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Xxx3ExaS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Xxx3ExaS"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675Fli5j088681;
	Wed, 5 Aug 2026 15:55:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=RVwDfWsbGk4ba/8Zh
	fOFm3tZ9mKEsSQEnTQQUX33DWA=; b=Xxx3ExaSnzUiuUt6ZKfyTIpS+f2mx0SEf
	PIYZNvqCpIGk9rRs+e0oZPN9qZ5grNUXB5kd9BCJcz15fRqUIV/hKLCVjBj8vj07
	kYp4feceJaG3Wl+QG8uaZalbzoLt7uhLLlDKvOh6eBvtRGS/alOtAfMybGb2pgx3
	BBFfJOglpXOK6aa/9Ei0kjO+bOXSnkb+s2Yo9kTHG5iMCcbR0IZyWf6Z6M9l2qtD
	7KP1a3TxgpKGod2SIqDhnw0PJm3MeuBfZjl+/imsViqdHQftDL2Xq0OB9esF6FCi
	sIwLdTsUQG7/YUTBlMKMiU4ZUlhsaG+5aEBYq7Qs+ixs5v5sOwndg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8h53vm2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 15:55:03 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 675Ffn8u002235;
	Wed, 5 Aug 2026 15:55:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswbgf1c6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 15:55:02 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 675Fsxj241681200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 15:54:59 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 350502004B;
	Wed,  5 Aug 2026 15:54:59 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12CDA20043;
	Wed,  5 Aug 2026 15:54:59 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.168.79])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 15:54:59 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 2/2] s390/crypto: Explicit scrub temp buffer in PAES ctr mode algorithm
Date: Wed,  5 Aug 2026 17:54:58 +0200
Message-ID: <20260805155458.14925-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260805155458.14925-1-freude@linux.ibm.com>
References: <20260805155458.14925-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDEyOCBTYWx0ZWRfX16gi9ZpY4Ujs
 aAiDHOrS0aRuhBWC94O85mEySqiRgzLH4epooEDzCgMaDXmhpUF3VjVG5IGGpjhLEZ9hcDUdUGI
 UsFSAuKffztyqSb1P3PYeb978c6e2Bo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDEyOCBTYWx0ZWRfX8143CIJ+1C8c
 eqTb7IntQCbVVguRDhuJQFuzZHA4O4AFcfRBSomAioyicQtUhpwP32lR4on1lQ6UJciIE4yJ+ae
 fxBb80BDL8ovhbXlhiACKhIGzJPCRCHmHuf+jzEuc8Zqw7qCgvc/NKcccI9SqUAhTL2IvzWy/Cl
 6r5rTK662EUJMuTs77B0bRfUiouZ/bxEC9SirmO8Xwp9DzDi3PsyeSyXf2zhqCws4NR1KJYuljz
 JNG/YHV6IudjzVMEJ1ogiawGOpZAZrD/UZo45R+YmM9PqueU9+1LbDxXxl4vPl9cYIlK64OYbBK
 vMo37d5wyJTC/DbAkbUdLs+6CXREq+qy30IYqN2GfeogUYyZ44GJidx6xTzQbg/0In70bLovjVq
 grDD6W14h8GBlAnbpP/UAXmjTQK8a7F/NYMmADyfiOXR44bRIouzLywK41d3VXOAayVt+cCenKE
 mFyPeZGfgRK0SfYXNrw==
X-Authority-Analysis: v=2.4 cv=SI1ykuvH c=1 sm=1 tr=0 ts=6a735cd7 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=Bu01COFQdOgQPTRGaCEA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: _vLjuntxIrxlGmmQAyIvDC5813jfztuc
X-Proofpoint-GUID: _vLjuntxIrxlGmmQAyIvDC5813jfztuc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_05,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050128

In function ctr_paes_do_crypt() there is a buffer used to process
remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
thus could lead to expose of unwanted data.

On exit of the function unconditionally scrub this buffer to avoid
exposure of maybe sensitive data.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
---
 arch/s390/crypto/paes_s390.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 89785ab95e6b..c95cc80b4205 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -1026,6 +1026,7 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 	}
 
 out:
+	memzero_explicit(buf, sizeof(buf));
 	pr_debug("rc=%d\n", rc);
 	return rc;
 }
-- 
2.43.0

