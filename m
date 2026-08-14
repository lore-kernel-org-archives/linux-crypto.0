Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE882F9984;
	Fri, 14 Aug 2026 14:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786717339; cv=none; b=a+ArGYrhZ5whjosK/Jw07DOGDrv4Kg+XcB16GileSBTzx9VbZt42m7Et2tKHjvFanxUi62HUpesFkPBxJSUZOeMDE9ZPiSA0bbrE/YMVMkarxaDrSQru4C54SKL6Xk+fdzg+4KByGDQ18pWdk+UgbDZ+sIePLj0WRRKHW0cBxEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786717339; c=relaxed/simple;
	bh=S9Ql/RC5Ogd5Fob7ddHx0Jhl2G79Y+HKX89ctxnfkDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cf99DdAZeqSOyQtjAcbGFvI7XDYxUbOgvazUwzSZdOp9kuDoAgDVg+agpUQHttWoqzq3m5+hk+6cRzp3jN2gOKY8IeuEOKSmGGR7/BGZmRjsB/9a2ZgVW/D+8upFDvcjxI4lUuAoprgaGq7ZU/ZYiZlF//DPkw6fGry+4SH6Mes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=d0agrjKZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="d0agrjKZ"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EE61se1248914;
	Fri, 14 Aug 2026 14:22:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zp1cpujK1aAiX1sxZ
	J5BCHFiYFh6r8NNAksoPbhqLZ0=; b=d0agrjKZzJS5Ff9GZjjH5wkZM4/7rC9OZ
	PEpnRP653nAJkqdjfiLPMyrKW6yQgJdzuKzSbD/ljPZbdDtGrnp/EE8x4724x1pF
	XEz2kKGARPlckjPruBA6ckMc1ItAlEZr5FqH30J7IbCTqnlJCMKgZjky1oNj1iW5
	+Ue9driDefaxGfwctNkRvcax7EhpG3EqMbUgoNXxtM0NrRo0MYC7CEEpgLcurTPs
	SrH+zyCq5OthviyouJFGkvP8+LvJkygXVdLgqf20GQ+7sdZLEmMMoUugcwANvh9k
	mrkDsrFYv04hTllUVLwEPO4V9C4fWDZcUhKFhPp6czKH34BH5aQfQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvp3c0me-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 14:22:05 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67EEBm8b032003;
	Fri, 14 Aug 2026 14:22:05 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxf5wfpu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 14:22:05 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67EEM1Vv50528570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 14:22:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 263B220049;
	Fri, 14 Aug 2026 14:22:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C30F32004F;
	Fri, 14 Aug 2026 14:22:00 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.129.52])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 14:22:00 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v1 1/3] s390/crypto: Fix return code handling at skcipher_walk_done in PAES algorithms
Date: Fri, 14 Aug 2026 16:21:58 +0200
Message-ID: <20260814142200.65821-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814142200.65821-1-freude@linux.ibm.com>
References: <20260814142200.65821-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=AMtp2X5w c=1 sm=1 tr=0 ts=6a7f248d cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=Kf6iHLwmcxHLPf87NV8A:9
X-Proofpoint-GUID: XVwr58bPpgtoMYNt9boXDJSSGqbYQdfr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDEwNyBTYWx0ZWRfXzAwpRooISkmO
 RxhB7ZrZ7wzoaFQfNgyXMPMlr0Z8I0jiVSAaAbNMRGNJh3It+oyprjHIwanPODI1HDSoBB8CaWJ
 5gtZOifa2LA1CNHTjVvsJ0r8UC9Arvupp24lohYKe4PQ9kktedWxkQkUc0QUm/WUCPYs6c+p0IA
 hoEyKqyXg+oWNYwEsLvgxK04iYEPI9U7jGKE7P0mJyC+sniPEJRDiUCDvCJEUo4zQm7lRh5/taB
 AXogzRCJMsdh0CBEYt8m5MPClzLmZBVlXtc4UJTBd0zKItcQQm8duTbLhmKF57SJP6G1snR1AFi
 gcQjtwgZq9QRQR1nluLSCTGh6Zj25C2qpIqGwyKdyAsnYaMu2hJkRvxL3NV3guj3KUh/+0erfwS
 UcE5VySK9m5kT7NAFU79AWZb+6L2bOFy4IViPkMhlsP2BBMSW/uDoEY55UegIQT2bg7z1G+cPeB
 3aTgPevzG6HSyK8vpHw==
X-Proofpoint-ORIG-GUID: XVwr58bPpgtoMYNt9boXDJSSGqbYQdfr
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDEwNyBTYWx0ZWRfXyBgTwB61LgZ5
 twUcDTmSPazUC53011R4Od+wjZ3LsKEFi4B/Ss2rPrPP176FVc8Hp3I0OUqC+0i761rcd0JzeO9
 7GX5/uPGhLq4DWzAHdFBjSVx2OJIt+I=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608140107

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
index 8cfe6166c193..ccc7da106c3a 100644
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
@@ -558,7 +561,7 @@ static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
 		cond_resched();
 		pr_debug("rescheduling request\n");
 		return -ENOSPC;
-	} else if (rc) {
+	} else if (rc && walk->nbytes) {
 		skcipher_walk_done(walk, rc);
 	}
 
@@ -699,6 +702,8 @@ static int cbc_paes_do_crypt(struct s390_paes_ctx *ctx,
 		if (k) {
 			memcpy(walk->iv, param->iv, AES_BLOCK_SIZE);
 			rc = skcipher_walk_done(walk, nbytes - k);
+			if (rc)
+				goto out;
 		}
 		if (k < n) {
 			if (!maysleep) {
@@ -761,7 +766,7 @@ static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
@@ -824,7 +829,7 @@ static int cbc_paes_do_one_request(struct crypto_engine *engine, void *areq)
 		cond_resched();
 		pr_debug("rescheduling request\n");
 		return -ENOSPC;
-	} else if (rc) {
+	} else if (rc && walk->nbytes) {
 		skcipher_walk_done(walk, rc);
 	}
 
@@ -986,6 +991,11 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
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
@@ -1079,7 +1089,7 @@ static int ctr_paes_crypt(struct skcipher_request *req)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
@@ -1132,7 +1142,7 @@ static int ctr_paes_do_one_request(struct crypto_engine *engine, void *areq)
 		cond_resched();
 		pr_debug("rescheduling request\n");
 		return -ENOSPC;
-	} else if (rc) {
+	} else if (rc && walk->nbytes) {
 		skcipher_walk_done(walk, rc);
 	}
 
@@ -1310,8 +1320,11 @@ static int xts_paes_do_crypt_fullkey(struct s390_pxts_ctx *ctx,
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
@@ -1404,8 +1417,11 @@ static int xts_paes_do_crypt_2keys(struct s390_pxts_ctx *ctx,
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
@@ -1512,7 +1528,7 @@ static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long mod
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
@@ -1575,7 +1591,7 @@ static int xts_paes_do_one_request(struct crypto_engine *engine, void *areq)
 		cond_resched();
 		pr_debug("rescheduling request\n");
 		return -ENOSPC;
-	} else if (rc) {
+	} else if (rc && walk->nbytes) {
 		skcipher_walk_done(walk, rc);
 	}
 
-- 
2.43.0

