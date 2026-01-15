Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA513491C4;
	Thu, 15 Jan 2026 12:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768478440; cv=none; b=fXhPd/pGCinSMbaZjpAIGUbPS/y9Be4s5ebcd5FYdQ0ZVCDatbgQn2Vht7nApFIImelJr1cyjUU6KG9sgzDxEndr5yLUOA2LZTcmeNlbHNfcE+Uy1XDJxOnE8Z//299koeAzKYlW7y8RP1KJHOwU4rDSf4DDn8NgN8FOQ4zM1/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768478440; c=relaxed/simple;
	bh=Z5Mgz1UhmF9fZl+OEmYekEBAJrXMBKnOT+RNIUcVmRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VngXcQcrTE0oI5RCKln6Q74EHqD+iCs4bAt0ZOYA6qAYdVKAgFzhkl26yU0nKcUvnTgN2wQvUVvgQ0suUNOkyE4zxfAjtuG9FHTRSkkItEo4ERcDJr2QQ2czfoE7t4kH1byNEaW7D8zwqZdDzO5nhK+e35SnLjOdo+9ncSeTfuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=M7YgaeK+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M7YgaeK+"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60F6ltEl012373;
	Thu, 15 Jan 2026 12:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=kwNLrTXCDaKQvdgRf
	cQgQ6aDrZvNM3kETzZ4hGQRH7o=; b=M7YgaeK+DXNKpVvFDnLsYMGOqD30pNUpW
	mDsLfgBR23L0gF62q4jX87NPSj61uav6dL8TD9dIJ1abjUJAF6ZBde5jql4D2Qag
	/KGOWlFXFOSDLcpRxrWT0i+npHtLUbCNZUvIGqVVMwlnqvkAu0ihXtcEKjRBNPzb
	IsLHCgbthv+KnRhrZ1ki7iAtH7018cVGrQPTa8+wCWt3086WMn3YPbeoIDlZkRzN
	1FrYGPG0WohwtXyJRXx+E41eSw1yAeI7q/AgdPr45peEdC2zhrW1cAH4IASYCIS7
	T97Ql2FIytLgspyA9vyLENbIXlK6yXO6O15LStK/YMue9tkHqAnYA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkc6he2jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 12:00:31 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60FBbvFh025866;
	Thu, 15 Jan 2026 12:00:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm2kkqs7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 12:00:31 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60FC0Rap31195594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:00:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F6A620043;
	Thu, 15 Jan 2026 12:00:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12EF32004B;
	Thu, 15 Jan 2026 12:00:27 +0000 (GMT)
Received: from funtu2.aag-de.ibm.com (unknown [9.52.218.117])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Jan 2026 12:00:27 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [PATCH v2 1/4] crypto: skcipher - Add new helper function crypto_skcipher_tested
Date: Thu, 15 Jan 2026 13:00:23 +0100
Message-ID: <20260115120026.4286-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260115120026.4286-1-freude@linux.ibm.com>
References: <20260115120026.4286-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: psVtrmfJSDsX6y2u4JhofCHNQ0bzKyzt
X-Proofpoint-ORIG-GUID: psVtrmfJSDsX6y2u4JhofCHNQ0bzKyzt
X-Authority-Analysis: v=2.4 cv=TaibdBQh c=1 sm=1 tr=0 ts=6968d6df cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=fAWbGbKKMiNiYwnTCycA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA4NiBTYWx0ZWRfX6kEwqn7ROV47
 71/tvOizMlmInozzt3hJbSf3EHmkOw/ZvwwMlud+pRisLdQ8A0KMVMfpqvNamCo5Y6omTZGp6PM
 NUDR0yZvz8dF4VUgg0s44C9b9dL80/VbEVqT7hZh509TqGlRHmtUsn7Ukvz6D6hYL6L1CwMbze6
 +or34M+njVhvOxX/6VW+fdVAEiK6VS2x/6zZ2zhbo2dr7fvAyjrRri6N0MeWgvYIeK9qNgSVR7P
 o1r9QW3KPC8ZoiOsVAWB6aHFnc2plUi/HCcoSuc+GnvYH89THNzFIutPRrfJ7CItT7J24SI9K+S
 RBXIs18cX3ETOgqKYWhu8xDcUr3F5bIEZ8B4TLJF7cvclPYCPx7Xzn9lVDV5ZEkFqRVwEMSlvWI
 1FvhmNDEs7sUulj0XFxTVG8YsTi4cUqLiUXXGZVJ1srFcoqD+eXP2LI3kfkQHsyRjlUqcolBCZG
 1Z+ainq+t1p+rIM/SQQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_03,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601150086

Add a new helper function crypto_skcipher_tested() which evaluates
the CRYPTO_ALG_TESTED flag from the tfm base cra_flags field.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
---
 include/crypto/internal/skcipher.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 0cad8e7364c8..a965b6aabf61 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -242,6 +242,13 @@ static inline void *crypto_skcipher_ctx_dma(struct crypto_skcipher *tfm)
 	return crypto_tfm_ctx_dma(&tfm->base);
 }
 
+static inline bool crypto_skcipher_tested(struct crypto_skcipher *tfm)
+{
+	struct crypto_tfm *tfm_base = crypto_skcipher_tfm(tfm);
+
+	return tfm_base->__crt_alg->cra_flags & CRYPTO_ALG_TESTED;
+}
+
 static inline void *skcipher_request_ctx(struct skcipher_request *req)
 {
 	return req->__ctx;
-- 
2.43.0

