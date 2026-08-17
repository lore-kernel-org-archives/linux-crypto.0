Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE7E3C661A;
	Mon, 17 Aug 2026 14:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976221; cv=none; b=WXGdhc3Wrc4L42LhS0ATdaO00pMZQ248NcvrA4lvD4XdY58UqYkgP2DtE4+7f/FvYT5gcI5hwMw5swOk2XyagwW9NmWziYTheUZtRwP8SBKXGeoLtdhFR5dfgwxYERtHIW1pn2j11A7Z/U+5qiji4pR+Rw3g4XqAl6xKAmnlem8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976221; c=relaxed/simple;
	bh=S9Ql/RC5Ogd5Fob7ddHx0Jhl2G79Y+HKX89ctxnfkDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+Dbhq/6R8RtPv/KYe66Qy2g80iHlsONz4jz8N/sqQqkUaBooL+ubJCwf54hYXAz0sSdDhTHjiwgbdEcHoIpzLFWCKzpfLwHVj8Hk8/HLfseGcxlKAVkU4zOYVnyeEZt3CESm5r6s6qNfoSJQ8EACMmk+4XbiuSQonRicjSWpXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Jv18kIM3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Jv18kIM3"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HCW2nE3722386;
	Mon, 17 Aug 2026 14:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zp1cpujK1aAiX1sxZ
	J5BCHFiYFh6r8NNAksoPbhqLZ0=; b=Jv18kIM3IwmtEnblrNJOy+6dVAUHWnWg3
	IoilcT7CrHwWb1ZtM2MEkdOj+zWQj62Q/u54PvTacUxvvHXyMsP4k8qKud/fUcT5
	tt4kE+Up7iak9pNMVL1aCUKsiRibZ9Csg+9+KYje673KdKdaWAXH1U8AZ7EobsPu
	an2gCJhH6SHKNIEdjA300s8ClQoDxeqZG23RqndAFANZRmOww2nVb2P/6lW3pWwN
	iMCkRrohv7OnUCR9roxhuWa2Z8VkWsEzp9CZJSbU41WXZKgFIhkcw0WqSXUg2l+M
	X2kurgwHoFq1PSo/I57JGhn1A+yd91HAOLAHHZb3jojfLHlBbcjvw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fsqjnqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:16:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HEBSsD006895;
	Mon, 17 Aug 2026 14:16:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g32epxgxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:16:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HEGsDr11796812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 14:16:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCE4720040;
	Mon, 17 Aug 2026 14:16:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9980E2004B;
	Mon, 17 Aug 2026 14:16:54 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.162.247])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 14:16:54 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 1/6] s390/crypto: Fix return code handling at skcipher_walk_done in PAES algorithms
Date: Mon, 17 Aug 2026 16:16:49 +0200
Message-ID: <20260817141654.77940-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260817141654.77940-1-freude@linux.ibm.com>
References: <20260817141654.77940-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDEwNyBTYWx0ZWRfX/9+W/zKN22FA
 Lqmbac7bQcu5fLBxqNGwJYei+ggR9U/11f2sfSjyRZJyS6cz9UeIdP/QekjsjxkY9j4w5uiN30X
 uG46UMpD1MznoAgpYbPIPxPw7zV9KHEGOGJGy/YS+5C/2KODM7OiV6i0kVSTyHbpNlcjPuA6s+9
 2deH40mDLQLeYCJaA0E1lZrCsSXtb6ZmsjbHzCR4tIj8CQh1G01+DTgpLT4qkKEmhNcTtLKYjG2
 lZRANC3eXSkiVi/PVohBTlf0MnRHcpOOFPM18T418LoGP5h71zF8uSxkgFSW7w5XUYgaUtA7NPk
 hIM9UMsv8365UIcQhV2DMshCKvbPv8VR1vYX0IMzscS3bCfQE7I/LpKWPSKSX1F0hIV2j/AR57x
 j5tAFPRJlHcoLoyiMv39wZ0gXXQwTDgd/Djfq16t0DC8svHnnFiY5uqlASQ2lkmviksvRUuXMQP
 5AUuxUlfeZ8mQGG/rfg==
X-Proofpoint-ORIG-GUID: fwJWDp11bLhr7yaBaPCz4IyKeyCzSLcK
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDEwNyBTYWx0ZWRfX0HqOhZXD93n0
 MdRDuiuJqpumEbUZYBSGqzsaqZhomgEdKXnsk63J+3pA7ocJKsbWEhfW7e6LB5hYW5aLqwrMXQ2
 Bc57YpXjMvjOPNK90sS596TBIbOOQOU=
X-Authority-Analysis: v=2.4 cv=DJe/JSNb c=1 sm=1 tr=0 ts=6a8317db cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=Kf6iHLwmcxHLPf87NV8A:9
X-Proofpoint-GUID: fwJWDp11bLhr7yaBaPCz4IyKeyCzSLcK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170107

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

