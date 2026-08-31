Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F723D648F;
	Mon, 31 Aug 2026 08:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165534; cv=none; b=m5QVsKT06zY90oQaknex9r9ntW0prtitrfAQNLY2IpVJyB3ZNdwfTK0+28ZxqJ5+eqSakSNKgU4wTeFBmnbJ2HHtvXBBXPFHm+hRYHApHIPtsnuhQhS42lR1cC2lEgyGy7n4P9WXsSw0omVTzDNCXVOJ7e5Fjg4STxWArN5CoAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165534; c=relaxed/simple;
	bh=pCIL3wEZ2OAwgUFJZnVBDS//9gug9nBmNJ50nUGyrZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuJaM3K5JJIP36kfp8KThpIc6CfDdMJ5dOQEPhRQ7z7hDtHbeGal36Tgmg9GgisTWRf8wVBseeOtsvTRPe9tKYFbbVLfukOvhUKEEM+OPDViG4c9cPthghtlRXB682S2riB9AOVjPm73u/0XnJ0qLnx0YDmA7v9tD3pLTExCqRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=j18LLcI9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="j18LLcI9"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V82MEp1640459;
	Mon, 31 Aug 2026 08:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=8aGa6l8Bsk2G2/37h
	8qcZIxn3oTmC0KmpvQKxU9Le/o=; b=j18LLcI9pv+KnhZhluVPhDsCDqkvjQzzI
	P2gX3lFHroqI+oNBjVyooWbfizClJKocFgfqAlK6jnoRYjJduW6PWg5dDpghwkHq
	/1cSrpMGV8PMGlaPE52/HIELt9aTb99U16IZDSMkB5OUMXsyIIw9+iOdGvf7fVOQ
	WhpXYuHEvc7ssDvLRhgpQHDs4quLYKMv8pMqhM+YaORDISq04cQV2Q9mVUGOOcTk
	WAUO3huyhdPmH4BiyOHx+lqeGD1MWXRaJi2QqDC/T8wQ20UZ03DP7ECg6l4eO8uX
	VdDEvedBaVs5bzvsxy60m5T1T31NKIIpFy2OpnSsgMgKW4L6bo6Qg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbpx584sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:44 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QHNC007892;
	Mon, 31 Aug 2026 08:38:43 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gcbyg4pjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8cdVv42861024
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:38:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 61BA72004D;
	Mon, 31 Aug 2026 08:38:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3D30E20043;
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
Subject: [PATCH v7 5/9] s390/crypto: Fix handling of EBUSY in PAES when req is pushed to crypto engine
Date: Mon, 31 Aug 2026 10:38:34 +0200
Message-ID: <20260831083838.3703-6-freude@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=PPc/P/qC c=1 sm=1 tr=0 ts=6a953d94 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=-JHTZFwV513spj01isoA:9
X-Proofpoint-GUID: sHFc5W2qmSnkG6Jikprk2Iqs4hnYgQGB
X-Proofpoint-ORIG-GUID: sHFc5W2qmSnkG6Jikprk2Iqs4hnYgQGB
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX50iCVOdbSDam
 uVHghwafYzkMn0rONCqHUW4qYa+sNNB21uyOSRMIRpleRs+1UAfqcmso09nJPo6pEgSE2wK6hby
 bjMEDXHXUIkKv3MOw0i6dzJ7i4edN0Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX/i75QLn5zDpn
 0xI95iQa0LWUj54+UPmbbEfYmYGTidY451R0op1YWFxFJ48v3v825h18kX4YRkB2Hmx4MJ7jj3K
 KikAeb+go75Zil+pujwSIdxsflGCjn1ovu8CGALJ30H+RHdq9he/7INL+ZjhW5eUycSb0/8K+NO
 qDU7eLdbrXwGZZbINRnmOrtBeLwedEa1IueWs1dn3/Mv52t4hpDw7KF0d9i5d0gYtIl8MXyAU9e
 q4OBWmDpyrt33Rq0pLK+x453PZuhUYgu8Hhdkcp62ohdCSBS7x55RqHaKCySq6nWRCbzHq6qBIz
 0tdQieokpILEKx0ok9GSE+jEHdPDUpD/jTC8IylcBdcqwNURAFK4lMy43Z/ZVH3c9P+0cToMfOW
 u9ZjGPWGfdhaop9zLINF+AYrEsR6jTFihTUXJBEEyfYHiKi+oQkbxKGlAr1NiJUKr40quvxV6Gv
 nDmPEQ4pPvu+lMcDPGw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310072

When a request is transferred to the engine via
crypto_transfer_skcipher_request_to_engine() there are two return
codes signaling a successful transfer: EINPROGRESS and EBUSY. However
the correct handling of EBUSY was missing and has been added as a
return code indicating a successful transfer to the crypto engine.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
---
 arch/s390/crypto/paes_s390.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 9a20aebac6d1..1071a9d7dc07 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -463,6 +463,7 @@ static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
 	bool tested = crypto_skcipher_tested(tfm);
+	bool cleanup = true;
 	int rc;
 
 	/*
@@ -494,15 +495,17 @@ static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS && walk->nbytes)
+	if (cleanup && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (cleanup)
 		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
 	pr_debug("rc=%d\n", rc);
 	return rc;
@@ -732,6 +735,7 @@ static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
 	bool tested = crypto_skcipher_tested(tfm);
+	bool cleanup = true;
 	int rc;
 
 	/*
@@ -763,15 +767,17 @@ static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS && walk->nbytes)
+	if (cleanup && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (cleanup)
 		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
 	pr_debug("rc=%d\n", rc);
 	return rc;
@@ -1065,6 +1071,7 @@ static int ctr_paes_crypt(struct skcipher_request *req)
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
 	bool tested = crypto_skcipher_tested(tfm);
+	bool cleanup = true;
 	int rc;
 
 	/*
@@ -1095,15 +1102,17 @@ static int ctr_paes_crypt(struct skcipher_request *req)
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS && walk->nbytes)
+	if (cleanup && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (cleanup)
 		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
 	pr_debug("rc=%d\n", rc);
 	return rc;
@@ -1504,6 +1513,7 @@ static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long mod
 	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
 	bool tested = crypto_skcipher_tested(tfm);
+	bool cleanup = true;
 	int rc;
 
 	/*
@@ -1535,15 +1545,17 @@ static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long mod
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS && walk->nbytes)
+	if (cleanup && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (cleanup)
 		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
 	pr_debug("rc=%d\n", rc);
 	return rc;
-- 
2.43.0

