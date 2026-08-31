Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A916D39B972;
	Mon, 31 Aug 2026 08:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165532; cv=none; b=q82BqXmS3Zaui4qqCcfE8BHKASmc/VUSdQBSgcyGAbXaXYHTBT5907TUIWefh9ll7G4wf1QGWEa0dbNsxeT/XCkZRAY+NSGPrXpdGbFvWnBS00bm1Z6EgSA+2lAynlQuyTCPnrSAy/TAW2eEk0CtrN+P9FVRhAQhTzUSAzCm3RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165532; c=relaxed/simple;
	bh=posjlTSQUYQyvrwtcA87gXq+dLZZjqLZYO2ebpyISQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWKXvkGE3TE8C14bILOnbL+i6yln9Ya/VrNo2pBf+T6sD5T3eUrJxx8c8NwNCpRxGB0qUFhBksGL7vnf65/MGAxj0lIflJfz0nK5qSJtRCGCwoNwiv648v8aWxN3k0z0Qf3klUMoNhIHeduyBwzpWmwrO0NW067tgVtA+T2M3dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EJYfHSDo; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EJYfHSDo"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V82GMf1530798;
	Mon, 31 Aug 2026 08:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=vLDvlmwAI+rnNRMbn
	HOsIzpQxK76eVP65/YGS7jwHYI=; b=EJYfHSDooQIK6QCcf/yVfuSmeonjnrXO2
	yqZyh455/TTzTnkGSB5cIhs0feDmf2wEeeA/VBtCyt/GsYpe9RcbeBHbboQ3exd3
	UPeAol2Jv8B95Y7cPYx400TSk7ijV/ArGPZqCWFbs1kQQHXw5O1uN2ihA9CZzNH6
	mUAAwCZi7fzIrHuD7s0BkA1fvLWa2tFxO3GVXOMuQYJ3D+3eBx3/QVbWx8iqM9Bw
	mSrZopnvB9jMZp1hsB7uFozOss/pdaZFUELYiCSf7rraueykprI0t+vR11R8+vdE
	5vkyvMrRL/gDJ/6Jg8ge6QduLdgfl02CLTRz+bV76y+esCn/TAvxw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbmuhga3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:44 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QI0U024589;
	Mon, 31 Aug 2026 08:38:43 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gca4vvy1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8cd2i42861028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:38:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5B422004D;
	Mon, 31 Aug 2026 08:38:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B69B12004F;
	Mon, 31 Aug 2026 08:38:39 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.165.38])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Aug 2026 08:38:39 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v7 8/9] s390/crypto: Map EBUSY to EIO when key conversion fails repeatedly
Date: Mon, 31 Aug 2026 10:38:37 +0200
Message-ID: <20260831083838.3703-9-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831083838.3703-1-freude@linux.ibm.com>
References: <20260831083838.3703-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3DchiwTinWXbPZPmsv6JD80L-CV4Lv6e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfXx72GXvzkLZjj
 dnQ/p1uKKgXk8fwEvf1MyDyjbSxT7tgYrJPzGEM8tBBxm27+Xq1gm7PQyweIXYzEgE2jd+tdpiZ
 Gfve/K8kC26c/7MRsLiyZ38yfe1oaTsbxFZf/C1ZGSI3bpc4SnneYXLsg7ZpfGyTyUxsa5dLw0k
 K6pQnamkZwXYtz8fKb5Rb/SfHZiESSldgjATTDV8+2cJytYnknHd8qfW5i+tPeD7em2DnXjZymt
 ZIDuL8iwGX/eFaWlodWpLBWLUCrICRAGd3VC15hRlScW81iNtemtoZ54N/Wf07e2GAiR9MQPfSh
 xJfgUrLabR7xorXjxKHQ2o9aFttTSMQ6Lb3O6lEiUD3PnnGGsjyZSlHc02X8VDgRYlZjIXaIO7u
 MlDlT6OzffPyOJcSn7HVqyNUM/e0v0vGX5uaffmmDW5blMpdXwpO+ATQRdBQEvuleKsdlzMw6U3
 RjOZi/8qHOOwFl1xgrw==
X-Authority-Analysis: v=2.4 cv=Osl/DS/t c=1 sm=1 tr=0 ts=6a953d94 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=Fr3jCehX831DqKRPnFkA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX9zfK7e/NHLNd
 VSZccEtRTobLNlFuVvCs6v3Gk3cLhnM/8HnMHhRxgCcnzTuoEz5iyk1+lcub8wd1PBtjzcuGpGv
 6X97zdZZ9a6XCxUrwccagkqJd93P1pk=
X-Proofpoint-ORIG-GUID: 3DchiwTinWXbPZPmsv6JD80L-CV4Lv6e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310072

When hardware persistently returns -EBUSY after exhausting retries,
the error propagates to crypto_finalize_*_request(). The crypto API's
completion wrapper treats -EBUSY as a queueing status and swallows it,
preventing the completion callback from firing. This causes callers
using crypto_wait_req() to block indefinitely.

Translate persistent -EBUSY to -EIO after retry exhaustion to ensure
proper error propagation and callback invocation.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
---
 arch/s390/crypto/paes_s390.c  | 4 ++++
 arch/s390/crypto/phmac_s390.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index bcaf1705e639..cf396f6018c2 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -220,6 +220,10 @@ static inline int convert_key(const u8 *key, unsigned int keylen,
 				      xflags);
 	}
 
+	/* But finally map -EBUSY to -EIO to indicate an IO failure */
+	if (rc == -EBUSY)
+		rc = -EIO;
+
 out:
 	pr_debug("rc=%d\n", rc);
 	return rc;
diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 89c5fa3dced2..44817c3d25cf 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -341,6 +341,10 @@ static inline int convert_key(const u8 *key, unsigned int keylen,
 				      xflags);
 	}
 
+	/* But finally map -EBUSY to -EIO to indicate an IO failure */
+	if (rc == -EBUSY)
+		rc = -EIO;
+
 out:
 	pr_debug("rc=%d\n", rc);
 	return rc;
-- 
2.43.0

