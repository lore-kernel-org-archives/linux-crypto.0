Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF193D34B5;
	Mon, 17 Aug 2026 14:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976221; cv=none; b=bnj4S0dZSUIytQIB/XYVYzcLcLW8kBu1Zx2LPHS1/WkZNS8F8z2jbYXIm8WI2yJb4eu6NKZqh4TajODmGzf9Wi/JIypePRSOUUmPD4r27IqXoF8U0hyfpxKIXAbVCLfAWVyKmOWMGCYzMWM2fk7k/9dAhMx7HKvD13B+z2NOrrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976221; c=relaxed/simple;
	bh=qULzV9u+qRSyv4WoxVK9iJak2fNxLU9M7FJNGd3YkNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qu73awlahSc1N8CGAKuzPrMMquII9ONefVQX7bZvG4Jrp9Cu3Aaf36k/FT8vw88qPoSt2IMM4/71Qy+qAm/AUnQmeg3wDOMpC2JPmyZX4bKQcg4KRTRlsiECRdGUcYIiXZg6ztTzWWTaNt8f5JBWmTkMnH4acTbGNbRCdDgblQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VXkthRX8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VXkthRX8"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HCVqel3722079;
	Mon, 17 Aug 2026 14:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+oFLPO0ZghUs8lUu+
	N86MdL5BjRX+Dz2LnrVmNWYPXc=; b=VXkthRX8+C6hhiX0qz0iJhnFZHuAdo65/
	RoeF1WGDrSZV5yrkeHFcpIDcRI5dgBlFdWd0RVziu+Uf/F+IBpvD5vvwxFOJw+WP
	QSvXUKwkRen/nTAjEc0cQKyHkVLcsfQm/IUQqRL0JTjbNBDlhEgSv3D0DTKUZ0Dl
	lw00NL4M0h/m3cAxn0hqrDt9I0e7pwDPtQDti/h4dzFj9EAZdjce9Tupz2QbR7+/
	tb7ZF/VE29JTgg7mU/ziaUTvusv03jpEuqMEazzmT5uVP1YFDr2YPHCBa1I5RCyd
	tg5K/P9bc7ahu8GPjWgMoJzfDKbvxP1TP1bJR3yEL8KtfXEZRE0hA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fsqjnqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:16:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HEBHgp006821;
	Mon, 17 Aug 2026 14:16:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g32epxgxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:16:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HEGtNI51184044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 14:16:55 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E662B20043;
	Mon, 17 Aug 2026 14:16:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C28C42004D;
	Mon, 17 Aug 2026 14:16:54 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.162.247])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 14:16:54 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 2/6] s390/crypto: Fix missing scrub of temp buffers with PAES algorithm
Date: Mon, 17 Aug 2026 16:16:50 +0200
Message-ID: <20260817141654.77940-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260817141654.77940-1-freude@linux.ibm.com>
References: <20260817141654.77940-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDEwNyBTYWx0ZWRfX4qORtNHkcrCi
 aqI04HHKM4QxuJCzxtLCXUQp4C1semZrgngKj8yLqxqTeZJVo03GZ5v8+4dVFqvYhL+d+XodZhV
 +PzwO1nQwYpl6oj0sdmyO5weNWIHlt1O9AaA7OcUr1iGPuDLJbmS1V8YyLRZze4p1J6Krq9wWm9
 ILAPJtEQK8m104K+Jrk588UyTpGWB7mBXXj2JGUtI5LZ1yRmpF7WWvGxlD3aDx4U3brqDjjM6jQ
 oTFgQtGwrvNBrtMIW90v7ubqeAbry/IhH7gu4hlXDrsQOsWKjR2HjiOskqjbNsOd/VQl0KhRk5l
 wWYoQYVDj3bo6YNKZ7uVTfUaKyD9vinYvID09vylQ6iKF9wXDyqMvte2M9Rz7XTmqhXNvwTXCm2
 /K181D9P2yBJgPhSi5noJ9sNWKbPHgx5VG8fBCGchD8zeTPhMjGSA87znUoyUIZhdF98RlT94Zu
 eE4hRPp28d/uJPaRvxQ==
X-Proofpoint-ORIG-GUID: 0UAyCixMZu1ZSOywSYCXahus3YRbbRaX
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDEwNyBTYWx0ZWRfXxRfIl+j34Tbt
 fG3p/69CyxYWB3oSs5SUaqocLXRXz7Ho4fsYmcU3IV/mU8upfH82FsXlsdrgOqC+8WX2vI3+V8A
 NZD06F4UqjAFqvMlu9HEwtkOK5uXtuU=
X-Authority-Analysis: v=2.4 cv=DJe/JSNb c=1 sm=1 tr=0 ts=6a8317db cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=tEttCOHk-VZC1F-mwysA:9
X-Proofpoint-GUID: 0UAyCixMZu1ZSOywSYCXahus3YRbbRaX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170107

In function ctr_paes_do_crypt() there is a buffer used to process
remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
thus could lead to expose of unwanted data. Rework the code to
explicitly scrub the buffer at the end of the function to avoid
exposure of maybe sensitive data.

In function __xts_2keys_prep_param() change the existing scrub to
clean the whole param block instead of just the key field.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
---
 arch/s390/crypto/paes_s390.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index ccc7da106c3a..d075b0241f1f 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -1044,6 +1044,7 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 	}
 
 out:
+	memzero_explicit(buf, sizeof(buf));
 	pr_debug("rc=%d\n", rc);
 	return rc;
 }
@@ -1377,7 +1378,7 @@ static inline int __xts_2keys_prep_param(struct s390_pxts_ctx *ctx,
 		memcpy(param->init, pcc_param.xts, 16);
 	}
 
-	memzero_explicit(pcc_param.key, sizeof(pcc_param.key));
+	memzero_explicit(&pcc_param, sizeof(pcc_param));
 	return rc;
 }
 
-- 
2.43.0

