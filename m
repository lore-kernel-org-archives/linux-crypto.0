Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E4848032F;
	Wed,  5 Aug 2026 15:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785945306; cv=none; b=OD1oh8Ud/JjSI69C70G0dLQAtTgaBsIxruB3n3kRQwVUP3CtHzO8T0nbJFf0sNZSD8oFw0nJotRv8dzmxIYs36sw71ZVNtCCPjaPaFtb0P1NAkX/HeZIWeuTQTNkso7tpq5d3uvUGDwuqfiPzoBBiqnMRtUFuvVN88BxJSL5FRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785945306; c=relaxed/simple;
	bh=TJme7cPMWmJcr35wNU9allweQHbTldsR4nBFhFD5ENQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbfNCBN1SyrIbDpjqATBYRdpHG0sKhec39KsW+Dub/55lgxjzamP04GcPLedx1FZ5wbXF8jEQC7GYRDZBCibLbRKnoK2PNQHVqQ+KCskiAK/4O/O7UTXpwe0hWb5WHZkVKTHLhNugzd3swsL9FQ3uSudiStDmDodHgtA+52Y3KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G4jjkrOH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G4jjkrOH"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675Fldbo057833;
	Wed, 5 Aug 2026 15:55:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qax1nAQyoLXndVSeb
	iJUpBYptC6mgckxWmLFI0FSLAE=; b=G4jjkrOHUmqg+trdfsS1Q7H+imG6ONcyb
	QOh2/GmKLkm9g7LmvZYg+zMtwE6XAlhYTxN7CynRykSz5rXnBWYjWjKAsce0TaAk
	UyOvFcPzDc7+CisUuLJ7F+DFqxZeYzp0ZfVIck4e7FbklAlM37wLwb2vS949gJHk
	iDl9A85fb+Q9JMXq6jYLC6PW+IDjV8gZunR0/Pc26fMRVD6dsOCvK/FmT8uxxECx
	Qjs18cPhmwnRG+h6V5c+vefZ4nTPUj1kXzf+JoOvDWBH4NzW9PWza4YplM0uYvHx
	bTriotZGySpVE/LHbuyOm/lumgix8v8KGX0SrV2mFXW1fBYwg6k/A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8a43v7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 15:55:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 675Ffeio017968;
	Wed, 5 Aug 2026 15:55:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugw7aud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 15:55:03 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 675FsxdG41681198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 15:54:59 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E95F20040;
	Wed,  5 Aug 2026 15:54:59 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D69D52004B;
	Wed,  5 Aug 2026 15:54:58 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.168.79])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 15:54:58 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 1/2] s390/crypto: Fix return code handling at skcipher_walk_done in PAES algorithms
Date: Wed,  5 Aug 2026 17:54:57 +0200
Message-ID: <20260805155458.14925-2-freude@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=E6P9Y6dl c=1 sm=1 tr=0 ts=6a735cd8 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=Kf6iHLwmcxHLPf87NV8A:9
X-Proofpoint-ORIG-GUID: nDJVhR1rGeh0D5U7ffVgMwc-J95McYIV
X-Proofpoint-GUID: nDJVhR1rGeh0D5U7ffVgMwc-J95McYIV
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDEyOCBTYWx0ZWRfXxfeDaRfR2nkg
 8CZZafZeu51PrqEf4Xr37GiebdI5R8n+asuai0ItvuSiZb538HPluN0+BxoyrMBjKPqJNFw02Wz
 1cNm7U/RDZ/qmhna5DX3x+Bwv77h6F8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDEyOCBTYWx0ZWRfX3tOfAX6jlGLt
 UHmJ+/6Q5zu53FlGhsLhCqUo6+EPF0XPzQBhN2mp8EjNEkSxGH2F2EVKnxBjkykjHPG5snPshLN
 W88ZB0DyFkqA+pkpQTh/Mi4lEhMS3YWZmVJ3J18oVm9TP9IAiPp29Bxbi2kJP5Trf7qf0buAFof
 c/ByJUwraCT50njOwX8sHoBbNR6tcr6Bk5jnR8Fqh60Rfi/uZ3lbr0tSJ+Zdfv4rIEMno4L1uGg
 x2p1piDfXjaYBsZErrTuXQ3uxmXRQDBKVcuGkDQmxJmGW/F6lgLQxzFYzT1CbgkHq87T7dRwfKW
 dE92zF4zWeGH+Ii5Wq7w3NjRMlduS5GU43MYezN/jMQBoTZxJkxb8abaTgOSXf7Xz9pmA/nCmlW
 i7lQJQa8xfp/KCMtbXLR/pDYI8XgHoTGJrNzTnNlfxQzeybEeQremHhYqsqrKiOJ8tA7oRZjWar
 iePGDv0IlLU5sDVWQiQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_05,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050128

All the 4 PAES cipher processing loops were not checking the return
value of skcipher_walk_done() immediately after calling it. This could
lead to error masking when both the walk operation failed and a
subsequent key conversion was needed (k < n condition).

Add immediate error checks after skcipher_walk_done() in all main
processing loops (ECB, CBC, CTR, XTS modes) to ensure walk errors are
properly propagated and not masked by subsequent operations.

With that comes a slight rework around the skcipher_walk_done()
invocation. It is now necessary to check if the walk has already been
finalized (walk->nbytes is then 0) or not to avoid double
de-allocation of resources held by the walk.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
---
 arch/s390/crypto/paes_s390.c | 38 +++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 973436592318..89785ab95e6b 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -432,8 +432,11 @@ static int ecb_paes_do_crypt(struct s390_paes_ctx *ctx,
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		k = cpacf_km(ctx->fc | req_ctx->modifier, param,
 			     walk->dst.virt.addr, walk->src.virt.addr, n);
-		if (k)
+		if (k) {
 			rc = skcipher_walk_done(walk, nbytes - k);
+			if (rc)
+				goto out;
+		}
 		if (k < n) {
 			if (!maysleep) {
 				rc = -EKEYEXPIRED;
@@ -495,7 +498,7 @@ static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
@@ -549,7 +552,7 @@ static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	rc = ecb_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
 		return pkey_handle_expired();
-	} else if (rc) {
+	} else if (rc && walk->nbytes) {
 		skcipher_walk_done(walk, rc);
 	}
 
@@ -690,6 +693,8 @@ static int cbc_paes_do_crypt(struct s390_paes_ctx *ctx,
 		if (k) {
 			memcpy(walk->iv, param->iv, AES_BLOCK_SIZE);
 			rc = skcipher_walk_done(walk, nbytes - k);
+			if (rc)
+				goto out;
 		}
 		if (k < n) {
 			if (!maysleep) {
@@ -752,7 +757,7 @@ static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
@@ -806,7 +811,7 @@ static int cbc_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	rc = cbc_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
 		return pkey_handle_expired();
-	} else if (rc) {
+	} else if (rc && walk->nbytes) {
 		skcipher_walk_done(walk, rc);
 	}
 
@@ -968,6 +973,11 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 				       AES_BLOCK_SIZE);
 			crypto_inc(walk->iv, AES_BLOCK_SIZE);
 			rc = skcipher_walk_done(walk, nbytes - k);
+			if (rc) {
+				if (locked)
+					mutex_unlock(&ctrblk_lock);
+				goto out;
+			}
 		}
 		if (k < n) {
 			if (!maysleep) {
@@ -1061,7 +1071,7 @@ static int ctr_paes_crypt(struct skcipher_request *req)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
@@ -1105,7 +1115,7 @@ static int ctr_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	rc = ctr_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
 		return pkey_handle_expired();
-	} else if (rc) {
+	} else if (rc && walk->nbytes) {
 		skcipher_walk_done(walk, rc);
 	}
 
@@ -1283,8 +1293,11 @@ static int xts_paes_do_crypt_fullkey(struct s390_pxts_ctx *ctx,
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		k = cpacf_km(ctx->fc | req_ctx->modifier, param->key + offset,
 			     walk->dst.virt.addr, walk->src.virt.addr, n);
-		if (k)
+		if (k) {
 			rc = skcipher_walk_done(walk, nbytes - k);
+			if (rc)
+				goto out;
+		}
 		if (k < n) {
 			if (!maysleep) {
 				rc = -EKEYEXPIRED;
@@ -1377,8 +1390,11 @@ static int xts_paes_do_crypt_2keys(struct s390_pxts_ctx *ctx,
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		k = cpacf_km(ctx->fc | req_ctx->modifier, param->key + offset,
 			     walk->dst.virt.addr, walk->src.virt.addr, n);
-		if (k)
+		if (k) {
 			rc = skcipher_walk_done(walk, nbytes - k);
+			if (rc)
+				goto out;
+		}
 		if (k < n) {
 			if (!maysleep) {
 				rc = -EKEYEXPIRED;
@@ -1485,7 +1501,7 @@ static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long mod
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
@@ -1539,7 +1555,7 @@ static int xts_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	rc = xts_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
 		return pkey_handle_expired();
-	} else if (rc) {
+	} else if (rc && walk->nbytes) {
 		skcipher_walk_done(walk, rc);
 	}
 
-- 
2.43.0

