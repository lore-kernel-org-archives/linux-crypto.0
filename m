Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D442FD1BF;
	Thu,  9 Oct 2025 16:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025682; cv=none; b=sDeQzkrWOWgLl+ElkjYp2nCwofh0iDPENoRphgdqwipRJ9cbdE8tWjPWagjahdoSgubfSNB0rj6Digjcq1pvgZnmX78wSINgBas1iuyr9cxdVdOEiUYZzKmUsPAFvP4u8gRuyCvndvEjxLYBaM9DONgmvn/WhHcTveksW8iizis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025682; c=relaxed/simple;
	bh=nvT3bqqmd/ZTVgzoChwcHAwDuko6MgdkW9yhsZ+nFlM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=egDz1cd5bBepHQ8KVSBaR4a2Si9Pxmc+PvYN+3UZbABWB7G9DodcA0CJnClo0kT2z4Am7fgI/DBqK0wuzy9NI+bJJI/n+XEodhQElCDSgz2JaHsxImVKaw0krnfiJBOSAvjJakfhEDDAqyII3IeKpXLdHieTPK0Dc4tddhn22k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H+wivxW/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H+wivxW/"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 599CT8FE014348;
	Thu, 9 Oct 2025 16:01:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=ATbopCDDnMzuxqFTGxMo1lciLR2hOpEsRiTtlhpcH
	Ss=; b=H+wivxW/ujj7kXPrvP4wqzns6R23JID/xmDqKYNMzJnOEOeSo5ytp4bwZ
	ZxQKfT9W+0Eq7xMFl7vAKDpGo1zz8yucqU53M1ZVrTYN/iVH+vr2KfBzu82iPckl
	al50EGKnY70XIVWbuCVfQGOxvH3HwODyyIpGc7JeFcr34czOg4cp6dBrWhWgAM8p
	6Qq4YCnGrSRNuE3k7oGIdbNdzwEMvPSVLEdm4kci18n99T6X2wsfvuoXgaUdvHoe
	O94Vlwzd77elLKAvdhue8miSJJpo/pqfJpizN/IEhfugwnmQdpyt/6X7+7KvwTIK
	RW5Rp61JrqkMcwuQK3A4IeqKIcGpw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv84nt4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 16:01:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 599FWK9u026009;
	Thu, 9 Oct 2025 16:01:14 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49nvamncuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 16:01:14 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 599G1AcG37617970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Oct 2025 16:01:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6934420043;
	Thu,  9 Oct 2025 16:01:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E30820040;
	Thu,  9 Oct 2025 16:01:10 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.166.239])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Oct 2025 16:01:10 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, ifranzki@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        herbert@gondor.apana.org.au, mpatocka@redhat.com
Subject: [PATCH v1] crypto: s390/phmac - Do not modify the req->nbytes value
Date: Thu,  9 Oct 2025 18:01:10 +0200
Message-ID: <20251009160110.12829-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=HKPO14tv c=1 sm=1 tr=0 ts=68e7dc4b cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=x6icFKpwvdMA:10 a=VnNF1IyMAAAA:8 a=qGRyj5zWsW19h7j0xN0A:9
X-Proofpoint-GUID: _BHN1m-2-Tv0-HfLQCoZW1RO1Ekj3I8y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX/E4boZ8hxPda
 Xzn7pbEZgVNkPyEYyRDfG2ZGlGaSWCUy83ZF2CZnCVxvv+Debxfy84Psdk2CGwPh2oGpR8/pNbY
 kmexLqNADPx8ywbFL6/LIXTX8z9+j26jYGaiPuh1SknmTMRi7x0dXELIOLJmJkc5tfJnml32FtB
 aPEbtxd+UozuId2gXvKNkqXoQXaNedGquy567sSqAy7gYmWOKZAy6d4H+p3nhzxiumCpKP61jTX
 7XjJ15y2ExkQys9mJBSzczgfQauAYBTK5OAOUEGLQxgy+neKocG8dPB+ZghlnmyhSaK3naeThV7
 SDvMRPloydbfEdwvqXNRCUlJNuRJZW9pmxDGc9+VT44s6gWM0NBwXFHpSKC6KfwW1nA2LWtJdf1
 jnLhVEMC2ijsvNsov/ha5XAEdDzxRw==
X-Proofpoint-ORIG-GUID: _BHN1m-2-Tv0-HfLQCoZW1RO1Ekj3I8y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121

There was a failure reported by the phmac only in combination
with dm-crypt where the phmac is used as the integrity check
mechanism. A pseudo phmac which was implemented just as an
asynchronous wrapper around the synchronous hmac algorithm did
not show this failure. After some debugging the reason is clear:
The crypto aead layer obvious uses the req->nbytes value after
the verification algorithm is through and finished with the
request. If the req->nbytes value has been modified the aead
layer will react with -EBADMSG to the caller (dm-crypt).

Unfortunately the phmac implementation used the req->nbytes
field on combined operations (finup, digest) to track the
state: with req->nbytes > 0 the update needs to be processed,
while req->nbytes == 0 means to do the final operation. For
this purpose the req->nbytes field was set to 0 after successful
update operation. This worked fine and all tests succeeded but
only failed with aead use as dm-crypt with verify uses it.

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
index 7ecfdc4fba2d..5d38a48cc45d 100644
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
+	int async_op;
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

