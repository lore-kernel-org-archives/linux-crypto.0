Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EC62D0289;
	Tue, 17 Jun 2025 13:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167892; cv=none; b=DH7cphLtq4K1ZrGGsYmTJuxPqna3dM3MAy7QPfWf8jxpVjaGgsScNbCAcp/E3I4vNFjeepOqA63n8SRmynUH9sQb3tCgGBs2N52o57dLiO9x7Vpfuk2UaeD/5KVlEV8PTshTwigsn8fgTvq0uoteJEsFE4/PzUZpUnar6lt6heE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167892; c=relaxed/simple;
	bh=DVP0B24WaA0ayIh7PXEP8/eFRvFZ2dO5ZEnopC90nPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGVvC1837qpDqAmRXswyCxDoWVPeY/wfHjb3mTEuSsU4h1x4iZLSPdAj+mR7iBoRKLu/uVbCbcJnPK7GgrFQo+sniT7KxdOQucXLjys3DtAGkJMy1JqtQCEipJ3wWW2jAmqEEcRvwHpJo0Cdx7J/pSLQqWqBQUO2AYVJNsbQ4F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KMNP0ZUy; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KMNP0ZUy"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55H7HcXk012683;
	Tue, 17 Jun 2025 13:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=DPP62IWxzB4L4Dd6R
	OlWgMCYzPObOd3oszDczqUbS64=; b=KMNP0ZUyQrB5G2ccvV6RRfVEpSw1tqtbx
	3kG6g/vXZT9ouvqSqrRQiRbAvlUPLQslHeSx0hLp2Nl/UEugZSy30keGJsokni+f
	n5fyQLWo6e5hpzecTpIhVwmzWlaqGNUthngnYZEuvNEFEMusHqRrUqiI8LuttpGw
	Vb8g/fD01DBMI32HAIyuOOIepdbN2dCsKkoZlPLRtHocKl8ZD3vI2vni8AE4njiK
	FPs+ZfvyASY6u6lyCWzK4NJ1XhQAZ7yvKZWgKUJvoFWqua7UeYm504EahdKKxMZW
	haWHujDYjTmDpYcqUvZcy9IBNUZm850OPCa0kWBk/mTmchbKp3VEw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4794qp7j26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 13:44:47 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55HCnbnv005514;
	Tue, 17 Jun 2025 13:44:47 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 479mwm3n4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 13:44:46 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55HDihLR37486992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 13:44:43 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 166E72004B;
	Tue, 17 Jun 2025 13:44:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B86BD2004D;
	Tue, 17 Jun 2025 13:44:42 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.111.71.86])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Jun 2025 13:44:42 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [PATCH v12 4/6] crypto: api - Add crypto_ahash_tested() helper function
Date: Tue, 17 Jun 2025 15:44:38 +0200
Message-ID: <20250617134440.48000-5-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250617134440.48000-1-freude@linux.ibm.com>
References: <20250617134440.48000-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T6kK0UuLaf1_Yp4fkVj50czvoE4wnibz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDEwNSBTYWx0ZWRfX77qs7gy2Y5vq Pg8Thz19o6BMddN6cdRkMEsy3QQPFEJMrof8mk8QhJo4JHXqV6D2KUKXe2Q4OoJ80Ok/OOjn3Q1 o2gW5e3JZuIymavIOt9OUxnalRt+uc0+erAmu5z+rcgbziX4EsYC53x9Zct01nXkmLg1juPvDUP
 qYvUCPV2BN8wmiqm8pQbL24tA2UansQuxWK7vHLTmYjN0ooMTP2t3hWZVy3+JXTFF8V0AImRo2R eAVPGQpxJrJwGcxnwgIK7iIZCoew8ZnAg3pwcjoM2AJjC3NYCCYmrm0hN5P3Ehb6LzuGCMljVVs 0pTb5w+FU3ko439phrrGZhs7YIOTgMbMjYmhi7rXqYh8amB9WcNvuzIrDEv4Z8oQz6EWaKp6Exf
 IBR8ajUNcldGw/zkiIH+EdtQFKnN3L/BpxR/ZRz+qfCqv01m9X3j1Rp3deX0it90MYCbt5GN
X-Authority-Analysis: v=2.4 cv=NYfm13D4 c=1 sm=1 tr=0 ts=6851714f cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=FNyBlpCuAAAA:8 a=fAWbGbKKMiNiYwnTCycA:9 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-ORIG-GUID: T6kK0UuLaf1_Yp4fkVj50czvoE4wnibz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_05,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=600 mlxscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506170105

Add a little inline helper function
    crypto_ahash_tested()
to the internal/hash.h header file to retrieve the tested
status (that is the CRYPTO_ALG_TESTED bit in the cra_flags).

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/internal/hash.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index ef573545c85d..8126254c9255 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -190,6 +190,13 @@ static inline void crypto_ahash_set_reqsize(struct crypto_ahash *tfm,
 	tfm->reqsize = reqsize;
 }
 
+static inline bool crypto_ahash_tested(struct crypto_ahash *tfm)
+{
+	struct crypto_tfm *tfm_base = crypto_ahash_tfm(tfm);
+
+	return tfm_base->__crt_alg->cra_flags & CRYPTO_ALG_TESTED;
+}
+
 static inline void crypto_ahash_set_reqsize_dma(struct crypto_ahash *ahash,
 						unsigned int reqsize)
 {
-- 
2.43.0

