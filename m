Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71FD3CB576;
	Mon, 31 Aug 2026 08:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165532; cv=none; b=Y1oV+jJnGk13uwnVvDnqO8CvGEqPZ9fcd/lUB+8l1kh+s8Ga5lNgFUUvv1eUxi+uS7/ATTpFax7XaW5mxFXAy/JbOQ8jQnLFPhiAZJoem7CoWfKpPRZD2yayCsl64C2RbgV7Tf18tlyL9HONiIoqDKW7npeW73Hh2Lwx+w/6eGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165532; c=relaxed/simple;
	bh=UQVa9RdNpOO43MjQcKrxrSIdLYU/RsclRTRJ3plc2xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnrrcMkXq1+mU37YGMb/IswDfhERYgpG28p0aW2HtktZmzzWB6qoNACHcBAC+G22yXwEd8l0g/Cf31Lpt6tDXsLj5h2yH8MneDKYWkgdJrOd+tRnc5A9DBP33w5jspq8JE35GkRxJfGuf5RYt/w5nj5m+u6+M5GyI9Stp+59O3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=heJtxl0Y; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="heJtxl0Y"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V8204R1639035;
	Mon, 31 Aug 2026 08:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=jf2d6MAk2b4zlXWvY
	0N1KX9txewljsiz7otbklBrVRQ=; b=heJtxl0YI0utMCGrGNlmPZSANPB5UG9+n
	0zA/GqaEAmIeHIsvqwvz4KL5zQjX2N2sm7AgZP1/Xmf4a8EILulawHL9w4Ccia5u
	HwGsogQzOnOuhNSUqrfrUk4uAVwZKOVsE8BRyDdE07x8kQuDnDFi+Ga2/iOyyLt7
	qYJBUwkcr3VY3iVpplXohnxMLgFHzHq6PUZcWyo/reNvjyqNKbEES8oOluN6rrUt
	GA3+gOo4/hL3WD432eU2a01Z+LXh8R7dqKgXMb9zwsAjX3ReYEbyOgALMlKV+y5w
	soM0m3/fpXEO/RWRbccPpCB23zE6qkytKUXTARAqvu6pNeyy0gISg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq54g3qq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:43 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QGdX007882;
	Mon, 31 Aug 2026 08:38:42 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gcbyg4pjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8ccfb49021212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:38:38 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CC8C2004E;
	Mon, 31 Aug 2026 08:38:38 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 759C32004D;
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
Subject: [PATCH v7 1/9] s390/crypto: Fix return code handling at skcipher_walk_done in PAES algorithms
Date: Mon, 31 Aug 2026 10:38:30 +0200
Message-ID: <20260831083838.3703-2-freude@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfXwhMJbQxFZdrT
 R4UrII74ygdAs/xF+d7chUeC1+Ntq64NiCtXBr36vqHytJUQE/olTGRlqPAC15rHLzOwKaq9nhZ
 1xOSFnv3SNJzBOqoTbcwJ5EK8vdahpk8mzh1rmIbV2LXLsSXAcxN9bY8IriqMku3OVgzykQ0Obx
 i4tOIqjSlwfxz0ZHuPNkztt0bGPDxnPZQLhbEHo1+/UNbYehVXC/m2rTj6TmaNHlhCNxNT0chwb
 SgeirEWb6SEdotaLFIn2uPu/0cDpo77yAjsLDBXglc9K2FwbkBa1W8tosIxmkdc6sViigVkRMDd
 DmxuQNVUyIvPTYsf07knwjWo84/4p1MMMxtKplYd3X7sOt6TJoUeZaMC9QQjntSbw70smFu25VR
 2gWljsNO4WTtzE778bLUFbe262oBuvycKf0NxzJyR7gw3Qv8+AVEuIq8hVu6C8OOpyBkrF0hVrS
 ybVGylsGH7n7WQ+Fkhw==
X-Proofpoint-ORIG-GUID: yeqtlTRNlTKAU42vcB-ELKlkyFwDLWMl
X-Authority-Analysis: v=2.4 cv=CNgamxrD c=1 sm=1 tr=0 ts=6a953d93 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=Kf6iHLwmcxHLPf87NV8A:9
X-Proofpoint-GUID: yeqtlTRNlTKAU42vcB-ELKlkyFwDLWMl
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX2MkJ4Sxx1a5f
 Cs5MfnjVuUm4WoQw18L38y8fyUenGc9ohNtv05OUdTWzBJTKbMjHCbfeZshggE/i28IcpYJ48t+
 mTtgI+LPatN+rhu+XB6vjR1lZ39jB+s=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310072

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
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
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

