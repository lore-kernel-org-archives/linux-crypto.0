Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E142D641D;
	Fri, 17 Oct 2025 12:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760704383; cv=none; b=Iny49IcMJ/NJQ7fa7TQlJXAr+u1SkIU6ljQIzFnIJSSVQhwSaVjmJsROC8SkLmbbDqCXnrjztvH9YxF3pAyzUYsCvPg9eisFaEV/4gm8ai5nEMcUVP8Lg1hJnB4oxHe+VzC1Dok0o0rsRw1F9SaQ58S6GpkzN971b8LRSyfx+9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760704383; c=relaxed/simple;
	bh=rj/rVvX8Y6+2oqmhQGdBhxdIPpHp46oUjOWLECRX/sc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LjBj3hdzSaz8jvh3I1ElgpJ1euWIjJCsnw3pdd7qBbpBjtMFYA7zR50YvgNNmzLconZYAebjzJxHnDJt61EyZmqeV9L2GrjfmiXif7ToyvcqOCbAPpCh3cVNkXbW++/VW8jqC1lIG/gen3AiPTY1IfvN7YgKTy4LU4Pt+5Wc6Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ltd811Ol; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ltd811Ol"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HAlkuu012300;
	Fri, 17 Oct 2025 12:32:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=1BBG0X7k7miIzzq9SKlBFBaTbG/NUUKBIRhUBteX/
	98=; b=ltd811OlpppWPoiEyqFAA2tEIcRmdAlEB0TtScUUxnpsNpzqpNv2QBCGT
	g8k7kC5nxxXLtSEtT5ZkE9ATChE29ZUScM2J622kjAZqnnmR50YCmtLyvEH4XbhP
	cMWJMJbuHWYJfJ7ZZo7o3HlnMdPjVgXyGFgL/B+NyYA65JbQkr4+a5flhSs7DIpK
	DOnPB8fF1zJU1XFzbx+rdQeaCot6JVhZfo2sDMFN3ga+sQkz/gtskaMSepAnlGgn
	IhehY9Gtwpc+HjH9C1tnpf/EdLQdqdCYOTMjfwM0FU2p4xHgKyrdZCsoPHaiWnAm
	6B+tObn+tRpjOruR1opBpmncoFfXw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qcnrsgra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 12:32:57 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59HBaqkI018823;
	Fri, 17 Oct 2025 12:32:56 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r2jn58gg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 12:32:56 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59HCWspq59310474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 12:32:54 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACE9520102;
	Fri, 17 Oct 2025 12:32:54 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 906F720101;
	Fri, 17 Oct 2025 12:32:54 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.134.111])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Oct 2025 12:32:54 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        mpatocka@redhat.com
Subject: [PATCH v3] crypto: s390/phmac - Do not modify the req->nbytes value
Date: Fri, 17 Oct 2025 14:32:54 +0200
Message-ID: <20251017123254.140080-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=M5ZA6iws c=1 sm=1 tr=0 ts=68f23779 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=qGRyj5zWsW19h7j0xN0A:9
X-Proofpoint-GUID: mcDnSsg0FUhspUFXvyfRaQ3nUu8ZFH_L
X-Proofpoint-ORIG-GUID: mcDnSsg0FUhspUFXvyfRaQ3nUu8ZFH_L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEwMDE0MCBTYWx0ZWRfX7nCJBkq1mRMb
 aKWWxMyMeJZPc4k772tHApR5E61uaAeIgUx3ReyC9Jic1KVUvQ7b0cEKS4GxmOuNx56OlGK2fTr
 MxZf89KFoZaEZv08vl9nfIGLn5GlseLZI/FbPbq9Dt9lVD+58WHi5y2/ccLVdjCIoGWjlguE4ah
 zF5KUAKSBER+22cqL044UWyl57av1vSyg0EyteLH56lNBu75DWLGUirewPtW73g/l8Zo4MphK2Q
 Pm+S/pp3UMFj1wlNLev7J57MfxYHzVEUmGRvIzvE3LDoKQLt2fL6f0GU+KsfOeKUQlqYBUXnsGl
 6b5HCAp1hUDgSj8u0E/rSj0mD41X9IQauxYDDgDxHiTKl+hLtgQFi9aSW0vF7REMKlHSz79ziwn
 SPn8m0Gb2VYzpMzGJXLZZUL/bieXqA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1015 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510100140

The phmac implementation used the req->nbytes field on combined
operations (finup, digest) to track the state:
with req->nbytes > 0 the update needs to be processed,
while req->nbytes == 0 means to do the final operation. For
this purpose the req->nbytes field was set to 0 after successful
update operation. However, aead uses the req->nbytes field after a
successful hash operation to determine the amount of data to
en/decrypt. So an implementation must not modify the nbytes field.

Fixed by a slight rework on the phmac implementation. There is
now a new field async_op in the request context which tracks
the (asynch) operation to process. So the 'state' via req->nbytes
is not needed any more and now this field is untouched and may
be evaluated even after a request is processed by the phmac
implementation.

Fixes: cbbc675506cc ("crypto: s390 - New s390 specific protected key hash phmac")
Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Tested-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
---
 arch/s390/crypto/phmac_s390.c | 52 +++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 7ecfdc4fba2d..89f3e6d8fd89 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -169,11 +169,18 @@ struct kmac_sha2_ctx {
 	u64 buflen[2];
 };
 
+enum async_op {
+	OP_NOP = 0,
+	OP_UPDATE,
+	OP_FINAL,
+	OP_FINUP,
+};
+
 /* phmac request context */
 struct phmac_req_ctx {
 	struct hash_walk_helper hwh;
 	struct kmac_sha2_ctx kmac_ctx;
-	bool final;
+	enum async_op async_op;
 };
 
 /*
@@ -610,6 +617,7 @@ static int phmac_update(struct ahash_request *req)
 	 * using engine to serialize requests.
 	 */
 	if (rc == 0 || rc == -EKEYEXPIRED) {
+		req_ctx->async_op = OP_UPDATE;
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
 		if (rc != -EINPROGRESS)
@@ -647,8 +655,7 @@ static int phmac_final(struct ahash_request *req)
 	 * using engine to serialize requests.
 	 */
 	if (rc == 0 || rc == -EKEYEXPIRED) {
-		req->nbytes = 0;
-		req_ctx->final = true;
+		req_ctx->async_op = OP_FINAL;
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
 		if (rc != -EINPROGRESS)
@@ -676,13 +683,16 @@ static int phmac_finup(struct ahash_request *req)
 	if (rc)
 		goto out;
 
+	req_ctx->async_op = OP_FINUP;
+
 	/* Try synchronous operations if no active engine usage */
 	if (!atomic_read(&tfm_ctx->via_engine_ctr)) {
 		rc = phmac_kmac_update(req, false);
 		if (rc == 0)
-			req->nbytes = 0;
+			req_ctx->async_op = OP_FINAL;
 	}
-	if (!rc && !req->nbytes && !atomic_read(&tfm_ctx->via_engine_ctr)) {
+	if (!rc && req_ctx->async_op == OP_FINAL &&
+	    !atomic_read(&tfm_ctx->via_engine_ctr)) {
 		rc = phmac_kmac_final(req, false);
 		if (rc == 0)
 			goto out;
@@ -694,7 +704,7 @@ static int phmac_finup(struct ahash_request *req)
 	 * using engine to serialize requests.
 	 */
 	if (rc == 0 || rc == -EKEYEXPIRED) {
-		req_ctx->final = true;
+		/* req->async_op has been set to either OP_FINUP or OP_FINAL */
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
 		if (rc != -EINPROGRESS)
@@ -855,15 +865,16 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 
 	/*
 	 * Three kinds of requests come in here:
-	 * update when req->nbytes > 0 and req_ctx->final is false
-	 * final when req->nbytes = 0 and req_ctx->final is true
-	 * finup when req->nbytes > 0 and req_ctx->final is true
-	 * For update and finup the hwh walk needs to be prepared and
-	 * up to date but the actual nr of bytes in req->nbytes may be
-	 * any non zero number. For final there is no hwh walk needed.
+	 * 1. req->async_op == OP_UPDATE with req->nbytes > 0
+	 * 2. req->async_op == OP_FINUP with req->nbytes > 0
+	 * 3. req->async_op == OP_FINAL
+	 * For update and finup the hwh walk has already been prepared
+	 * by the caller. For final there is no hwh walk needed.
 	 */
 
-	if (req->nbytes) {
+	switch (req_ctx->async_op) {
+	case OP_UPDATE:
+	case OP_FINUP:
 		rc = phmac_kmac_update(req, true);
 		if (rc == -EKEYEXPIRED) {
 			/*
@@ -880,10 +891,11 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 			hwh_advance(hwh, rc);
 			goto out;
 		}
-		req->nbytes = 0;
-	}
-
-	if (req_ctx->final) {
+		if (req_ctx->async_op == OP_UPDATE)
+			break;
+		req_ctx->async_op = OP_FINAL;
+		fallthrough;
+	case OP_FINAL:
 		rc = phmac_kmac_final(req, true);
 		if (rc == -EKEYEXPIRED) {
 			/*
@@ -897,10 +909,14 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 			cond_resched();
 			return -ENOSPC;
 		}
+		break;
+	default:
+		/* unknown/unsupported/unimplemented asynch op */
+		return -EOPNOTSUPP;
 	}
 
 out:
-	if (rc || req_ctx->final)
+	if (rc || req_ctx->async_op == OP_FINAL)
 		memzero_explicit(kmac_ctx, sizeof(*kmac_ctx));
 	pr_debug("request complete with rc=%d\n", rc);
 	local_bh_disable();
-- 
2.43.0

