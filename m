Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20FE3F8253;
	Mon, 17 Aug 2026 10:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786963331; cv=none; b=jnQqAo6eXjKSpxqakT5m4BhSZmoqZeXnsB2YiVI645fGhXf0ie2/JqIFtpTMvkHYlfigEN2faeoQR7k715YV3F7rGluYF7YF8xVf+dwac7+DQwkoft8SDhPHHJekvWVv2PQ0Qz4Prjy0TsZ/5PEDU+Walf2i4gNqfUVhawo8Azs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786963331; c=relaxed/simple;
	bh=S9Ql/RC5Ogd5Fob7ddHx0Jhl2G79Y+HKX89ctxnfkDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWSASHU8LqNVChWO2Ar4pjNDi10q5J9kx3nmGkA1iC1kHV64s6jJBEakdDZ5zY8d9sRNhrLZUToQ6meHuP7mFPLTYo+UrT1vWbmfVYbOWK2yqPzGLoFpqZbJ0JwofoedoiACk1P0Ezxusn9th+zljeXKx/JuyQo2+e07y1Lxl8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=quNf2XZh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="quNf2XZh"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GLWCZm2629964;
	Mon, 17 Aug 2026 10:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zp1cpujK1aAiX1sxZ
	J5BCHFiYFh6r8NNAksoPbhqLZ0=; b=quNf2XZhiC2wkLV6Z43j4Xys/nuiC0gLf
	k0ew6TCxwloNaB6YguXsNvpYPiX+bfG9AySIyQCXVP83O0OAGxlE7QAW+O4Tqunp
	N1PSGgAcY3XfQp+nQrDfWXe/76JOZcEnOxNbHfgU5ljmUag5jNI5fW9GBQEYsc2q
	K/E1eYKwiHojFEvXMgQ0roduVE5EOpuffwGPloZs19JRrFxfeZMn2Gooz8l4DuVy
	rQgs1mkG+rs+WNKLTk4OZAd4bJbHcPp+sNWsa85GCfv01UbJgF2FsegXn7rlKBz2
	BWkJW2Ny8h9SBNz8f7T5WNeXbi/OEP+YtI3DkyXRE46eo7ehxTh5w==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2ehe1kv3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 10:42:08 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HAfJFB010081;
	Mon, 17 Aug 2026 10:42:07 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33xgwm5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 10:42:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HAg34K46465448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 10:42:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A53C920040;
	Mon, 17 Aug 2026 10:42:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D9F32004B;
	Mon, 17 Aug 2026 10:42:03 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.162.247])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 10:42:03 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 1/6] s390/crypto: Fix return code handling at skcipher_walk_done in PAES algorithms
Date: Mon, 17 Aug 2026 12:41:58 +0200
Message-ID: <20260817104203.74033-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260817104203.74033-1-freude@linux.ibm.com>
References: <20260817104203.74033-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA3OCBTYWx0ZWRfXwWfgfoUVLUxt
 JhKG26IoYRrs5Wo2A/zESCJStIItupRG79H/kv28+XA14mQPNEdeGVfyomSfM8Kx4exBRP4r5CX
 +wNoHmbSsPYrid+q+T3rzIJK73UitVg5vFaURCYvotBrxiiJpmF/8kxcsnEuiGTVrJ8t5t0XFIZ
 OhsNC0ua+r0xlCUblxr61WEFQ4NBdLpbzTH+ON/mZfM68ZFpvi9rGtLtsUbsyIphdHfmRkJQ/ja
 TTc3GJ+X5UrKNnKo6TLzpuv9t2rGzFG47Ld4Hyq/HO75DprEAHBBOAzOXOkwh8wVGJiMG+EBodm
 BV5+Zt1Y1HgeWwEtO3Z/gqJ/D1nhxl5Rr2J42ayNN9SxRsAZQjYZP2oqNRMJ2jGAsIpQGW1ZcBp
 KVMsnqQNY+4akCBjDYa9UTRNmM0roe+KyBD8H050tovWuWTu8sd+X0gFmRUcU8cdWujs1HhQQJO
 /ooE9fC6rM8ElXA45jw==
X-Authority-Analysis: v=2.4 cv=DY8nbPtW c=1 sm=1 tr=0 ts=6a82e580 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=Kf6iHLwmcxHLPf87NV8A:9
X-Proofpoint-ORIG-GUID: 8-tBFvB20zLg4Im4q4tkXpSILFH9QxSf
X-Proofpoint-GUID: 8-tBFvB20zLg4Im4q4tkXpSILFH9QxSf
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA3OCBTYWx0ZWRfX2d14lSDa2T1B
 hSErYJXYpelA0Z6w5v8UowuJBnz5I8gMQZXI9hrEg58SqukeiZJxfIOgIKhlhbMB9hVQsTi9VCP
 alToWgoIN5QaF1T3Oun5z3opAZzMMUY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170078

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

