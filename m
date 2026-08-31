Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC53A3D9550;
	Mon, 31 Aug 2026 08:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165533; cv=none; b=quwq1s8+fPiR3+ZTPQAulXGjyyOl5dBl/U/9qU1o7CQKQpYWdbx5DpxTaotAtlgIfiMWOizbAWYTDwEf2gBrtvEtx70RaCGvSdgJ778j1iQzXlaoVgRn64uvoL0b53HwJvVne31DaizFnS9MqoimGulsm6zDBgrCFJ+ACmywh+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165533; c=relaxed/simple;
	bh=LUFJcedcUarmZ/aWuqtUQw1wgDu44yRqq5Df7k1kJh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCbJsGMfAJVLpw7YBGyYbV9QwAOvjP3IULfSIWU43yGhe8zFuFa1HVH4wanzYCwbsVBLaGe3us8bWAY3hTc/7ODdMqB/meR8RaFdA7PK3gDXODaXAD1c1cJU09NGQB0Dv8gkuAxJAeT3E4aCN3hjl3dZXccZU+cWkSWEkeJNnIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qJkHTbQ+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qJkHTbQ+"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V82EWu1640285;
	Mon, 31 Aug 2026 08:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=71sbkMOMz+2dfj4fp
	ebeowJL8APGigbmWCPvl5qD1tc=; b=qJkHTbQ+US/EI9p6y57L5BvlyKFtcw+Pq
	Zt5eWuyBU9GvhCXB/h17IPUZE4f6blXKKvGVnllc7FZt7CipeR105BPus/2vtgCB
	aTWg6sAHvFWd9gOyZnPcgE424LIHHjx67iuIMW2VdRwBtcH3Eep+nhXHw8jBLqgT
	PvupkWgkTwj7LwmjBrMs0OtocwQaIQ3NBaXn2SW0IAc30GtCslVNLuvyxgR2AudP
	AAJ+mqREcLAv+YqjPbVvXEf1XgLrw2uLDMBrWChcAJiU076APNkXMcqWnE72FZl4
	WHS51M6q4k9tvR5y6Wg7LaCLVuDEWnAarjPury6e3wdjthCOVwWtg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbpx584sq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:43 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QMYE024793;
	Mon, 31 Aug 2026 08:38:42 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcb8h4t1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8ccHs50004228
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:38:38 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C66CF2004B;
	Mon, 31 Aug 2026 08:38:38 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A2AB220040;
	Mon, 31 Aug 2026 08:38:38 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.165.38])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Aug 2026 08:38:38 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v7 2/9] s390/crypto: Fix missing scrub of temp buffers with PAES algorithm
Date: Mon, 31 Aug 2026 10:38:31 +0200
Message-ID: <20260831083838.3703-3-freude@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=PPc/P/qC c=1 sm=1 tr=0 ts=6a953d93 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=xgcJR-P8mceqExzzGMoA:9
X-Proofpoint-GUID: hGo0LFYBtV1uc_gnjA32n7r5cD2Y0u4N
X-Proofpoint-ORIG-GUID: hGo0LFYBtV1uc_gnjA32n7r5cD2Y0u4N
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfXxNCd4kUsKG0j
 /qCUkEyvNq9eOcQWXpcV6M8lVDcZG10tI4j0YbF1O5utHujpjixNMgsA/ncGoQXVW1eteiJQTmd
 Gt50X3BUrnBIMY6avW+uZcj4nN5CAYY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX5b2+4lD1YyQR
 r+gt511CJQ3ebKfqsbbgM8/uWTQ4DBLZ3ieYAVAl4pzGaXmSXueaulfWT8gh79dOC3CWjHu0ROV
 S8teGPl3MgfxVcqnqF/9oOlzUs0E2CdY6F7a9spGGUmhJ3hwAbnmokn1K2lLM4xafTIL2cgew5A
 3XIpD4pCrtuD5c9SP2F8VpE6pgQP8UXmKsQ7zUZNGfNaCbiyXSnV3P5iQeMMnEnY0Z+Z0bP4PLl
 1hf3qprkvCEPWxGygkEaAXX2S3/xGD1JBk2AI0+4oUwpLawd/pgfnZz4DaK0+5ulU1Kq2o5nXL6
 PT3QCxSRZPI0fTI2VovhX+FRCCT6j0OkDJqV3pwLMg9lQ6tA9w7QX2UUD8BsF+7JDG8IUO6/4AE
 l6rOZlIjy10PO+lhVgznx1SjaWG2PPvJmXPd4ooluwDNTvhQPK6BOvYnzh36mOad5LJNLdrMO1L
 ff0DDURdU4vTgQvZa9Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310072

In function ctr_paes_do_crypt() there is a buffer used to process
remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
thus could lead to expose of unwanted data. Rework the code to
explicitly scrub the buffer at the end of the function to avoid
exposure of maybe sensitive data.

In function __xts_2keys_prep_param() change the existing scrub to
clean the whole param block instead of just the key field.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
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

