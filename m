Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395CC3F86FE;
	Mon, 17 Aug 2026 10:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786963331; cv=none; b=TF2xgZYEkSMWr9OnqysnAlXzNg/z9PU2z8Vy1yk0YFf4/WHkUVrwS8PcwKt2ebw6WFRXxSn1vKiwFNAbTF4m5yyraYukHASZ6vBmkhPSRtmFU9PMtNgumfBo1W5XssnWz3Wt3/RyLKL5XXAhyisi2Tjfn4jrOPeSAqtdaCcpA9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786963331; c=relaxed/simple;
	bh=q1gBV7Gl1/OzyggbSWKkmhWz2d/2YcTe03+L5jHqPJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AllKP9LydfOqJsyGHMEV11oEgCieEMYM+jXURpH4vBud22JzDNMmJaQvo7ys7eBGI+OMVJd0nFFQvR2WSRCwYwznODqMWyGFZ7rCkQ9gGQ8cyN2EdDNFJ0/uRG3rHa9VDvMI+b8VJjkfHBJl2odyrL24WL9ZtKezLtLMU1wHl7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=D/I2oOo4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="D/I2oOo4"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GLVror3636264;
	Mon, 17 Aug 2026 10:42:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=cRNB5XGswkr7Q7mM5
	MgTLFNS6OXniK53XUYv0tB8ci0=; b=D/I2oOo4qNA6y7ZQZn3+pFywPO6DEEgDn
	hu9bcCks4OnkmXtCd8o2LkR/auklj54oI2EEE1JpCGxDuyryaR4bwqYnRmRrrKzr
	wSyTEoJTubpZxeyRsTD/z+GUqhawjOckd1rFtVOoYeuyzQ4+1n7iINa2Q9hNFdLS
	1TUhSO0yM7l00mlhzBbEanW/hfU+ZGxvHPO1/QcLZqOIlvrw86U567BTu5cInYur
	2zf3fUWldFybUH05bd9DE7qqhsYswzSSF7yFUnyEOV3qw+O70SBrmBor+/5ah4ZG
	gStQe0647r18cXQXDoIN4D0W4389u4st4C0QbrrZx4RLgEB9xNrjA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2dhkssrp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 10:42:08 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HAfSac003952;
	Mon, 17 Aug 2026 10:42:08 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33ejwnvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 10:42:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HAg42c31392212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 10:42:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5AB9520040;
	Mon, 17 Aug 2026 10:42:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32CFD2004E;
	Mon, 17 Aug 2026 10:42:04 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.162.247])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 10:42:04 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 5/6] s390/crypto: Fix handling of EBUSY in PAES when req is pushed to crypto engine
Date: Mon, 17 Aug 2026 12:42:02 +0200
Message-ID: <20260817104203.74033-6-freude@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA3OCBTYWx0ZWRfXwMk97SHGOu+l
 HAvuThFEjr0a2e+CWJuHegk3XESH8Vf5u6nTpq2+fA+dKbhE0TucTnvjoWZ2ptYJ6xsze4n+pnH
 4AdHlc1aCFIKPPQ+Zt2Hiyi/9Pz36Hd5zd96abafOVdhUmLDnnMEqoUf+nfg0G851OQ1ZNSFnfO
 Y5RH1KXkGElg3t8xDG2RqDxgDMe8jLKF6q64BOcGnfjzj62Cn0VnXYKnzdsgOPR1LS5uCFdSTgW
 QkgKolAZJik6WmW5u/NVEezbKsGPho+0UmGc+8LqgioYO8RmhGZ8nHPYne8T+3W8FwlqHna634z
 pU9jEyLjHWlpkMHU+S8WRt7M6CKMCeD5IJ+wFwNSIPTQgh6ke8ObzvEPfIbd6SnbUm1eJhII0cz
 vgHcMugy1KV9Kupul+IPEizEBWarScXx3PxN1n1r0JRYYNZI32RE8E7hQLiDHsRiGzSOZHHeEgC
 sE+NbJ+9wb8M88qi4BQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA3OCBTYWx0ZWRfX37Qvrh9c0T5o
 Dj3rtRXxZOkSouBCLpuG26k4k2bRM0rHl6JjGz+X6anY/gWuVOyZcMdpBDIyW5f1dunadPrfoeu
 Ce+JOtd8zatpIYMGuH+9Ufp4VucSlig=
X-Authority-Analysis: v=2.4 cv=JKkLdcKb c=1 sm=1 tr=0 ts=6a82e581 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=uyJqPLbbXyVhWbHLFPsA:9
X-Proofpoint-ORIG-GUID: mvBiP1kwgoYVXthYBCK-JgSyZU7In5PZ
X-Proofpoint-GUID: mvBiP1kwgoYVXthYBCK-JgSyZU7In5PZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608170078

When a request is transferred to the engine via
crypto_transfer_skcipher_request_to_engine() there are two return
codes signaling a successful transfer: EINPROGRESS and EBUSY. However
the correct handling of EBUSY was missing and has been added as a
return code indicating a successful transfer to the crypto engine.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
---
 arch/s390/crypto/paes_s390.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 03446bfac37f..b60696c49fcc 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -494,15 +494,15 @@ static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc != -EINPROGRESS && rc != -EBUSY)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS && walk->nbytes)
+	if (rc != -EINPROGRESS && rc != -EBUSY && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
 	pr_debug("rc=%d\n", rc);
 	return rc;
@@ -763,15 +763,15 @@ static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc != -EINPROGRESS && rc != -EBUSY)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS && walk->nbytes)
+	if (rc != -EINPROGRESS && rc != -EBUSY && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
 	pr_debug("rc=%d\n", rc);
 	return rc;
@@ -1089,15 +1089,15 @@ static int ctr_paes_crypt(struct skcipher_request *req)
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc != -EINPROGRESS && rc != -EBUSY)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS && walk->nbytes)
+	if (rc != -EINPROGRESS && rc != -EBUSY && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
 	pr_debug("rc=%d\n", rc);
 	return rc;
@@ -1529,15 +1529,15 @@ static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long mod
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc != -EINPROGRESS && rc != -EBUSY)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS && walk->nbytes)
+	if (rc != -EINPROGRESS && rc != -EBUSY && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
 	pr_debug("rc=%d\n", rc);
 	return rc;
-- 
2.43.0

