Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6BC2E0939;
	Tue, 14 Oct 2025 10:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760439210; cv=none; b=Te+/Qniw6KR9A2lZn1cAiAG+9lH6+C3JD9bfozqan0s7qJ+WhZFEhlVFWzOw6OVywodI+hVZ0f5dhJhcqMkUBia2q20z3ptTmXZgRgx+RIsTqqtEE2Dl/HY8b0EwOv3Sxa70qwMT0NR/oKmBovR2/ofd8t3klfUqXc7wQZwgJnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760439210; c=relaxed/simple;
	bh=MV2XLm72ugPlqB/X+0h1V/gPIX2PcgAxEscEl7as7vM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C2woG3t02zK7KUX4HdecUu9cypc68MSGmaLGzlzd8O5wbyUGX3CchNYZnbn8GZYM5GAyws4NVHmi5ZB+8AERiSUlcGD0I8kao/TmTARuMEFZ6XjTVLdvnXm/+2CBcI1QlTFD4RQp7r1yu9oDlKyGU4TaacAcIwrrwiPyiAJ4fUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Zh/c1+Ma; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Zh/c1+Ma"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59E4Rhjl020942;
	Tue, 14 Oct 2025 10:53:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=rkUn46lmbNM8ujLiBGX1J29a3g1OpIe1oMYI9Riyh
	aE=; b=Zh/c1+MafwFHAr961pAN8GTWpoS4RYB/qKA/uNTJqFv6jQ9HIcY1v8xcq
	L+Ss6rDkSP8htYmYIMT40KER3OQVxpxX/gV65hkR+81w/WbaBvadVDkZ4PIxETMi
	wNhLK/gMLpctXBoH6mg5GqiXUIdqaQD/JF67zQYf6IF3WcFHd9TIxR5UU3z69f1c
	4jPZg6sQ/SuCPQyA29nq00Tp+Ff983fQDVmyo14N0kqSkDifZoHBhxkigiwsWuRm
	7oamEdyicbBeDfPzffVxgAH2/kRjM42TJ2P1IAmpViUWagiYDeco2Ixgmy6z3vhX
	3HmbiC6sVswb9vbQ2ZsWpmFGPINjw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qey8p4tm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 10:53:23 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59EA4tuf003709;
	Tue, 14 Oct 2025 10:53:22 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r1xxtkp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 10:53:22 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59EArILU33817054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 10:53:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 74F3A200BC;
	Tue, 14 Oct 2025 10:53:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56C21200BD;
	Tue, 14 Oct 2025 10:53:18 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.201.106])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Oct 2025 10:53:18 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        herbert@gondor.apana.org.au, ifranzki@linux.ibm.com,
        mpatocka@redhat.com
Subject: [PATCH v2] crypto: s390/phmac - Do not modify the req->nbytes value
Date: Tue, 14 Oct 2025 12:53:08 +0200
Message-ID: <20251014105308.27663-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q-06CdNV6xqlUt2lP0cw-EMVJSM0vKkg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMSBTYWx0ZWRfX7fav7RZ5MpOG
 yk45BPFZ5bmJwS41MucImRIuoHT67fwthgEm0xrzHQBhn9SH3wc/4HbwQMba72Tthw7egC/pR1l
 RnR4FrXI3VlufSPfmUyDafXajqYtMvwkKA26gIM706pHF3CVCncVOP4oE+a/+BIMKqbmh8Z7D3x
 7VeT031AudHYi5zZp4kN2XhnioxchBrVGBKcGBAZy0F2RqVlniS8uUmVJx288itA3tTy+sxDezn
 kqmFcQmmpgrzBSeyd2tQvqgJglSQLqBWuw6xH4oNcNSZb+E9PmJOz2KwBBmwcl5nPBTjbB5CupB
 BogttopNFWESbNFf0MrffZmO2BMRbic4Tw0BXjqyD4PABjqzxYxh4yX+iUcezqGiQT7cP6tGQHR
 bqS/Uyh3aketfeg68M72HxdB4aVl3w==
X-Proofpoint-GUID: Q-06CdNV6xqlUt2lP0cw-EMVJSM0vKkg
X-Authority-Analysis: v=2.4 cv=QZ5rf8bv c=1 sm=1 tr=0 ts=68ee2ba3 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=qGRyj5zWsW19h7j0xN0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110011

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

