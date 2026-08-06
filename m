Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70078422E11;
	Thu,  6 Aug 2026 08:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006199; cv=none; b=sx82E4xdvesPZDYD1IRo12VMzLzG72O64UjreexCoOBUTFbl8hOE1rHIghcvEMDslks1qzIbhoKfaI6hXJblQy0Cz1aD1muyk7VD371rGVXhp59m+nnpkxdKAB7j79l0g4Xz8DbC1FyjDzFdkz2sNQBc6hY7/xBsiq7fwUPM5RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006199; c=relaxed/simple;
	bh=TnhvjgQ+Napyf0PkgUQSG8OwkfMCu8KVyYlywY/C8GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/PT1rwwc8e1S4ujGrtZ3AtIq19M6sc7AyJxdeO7xgS7k8AoXQF5ZN+OslUfANpSbHUbJN1b6DqjA/1tLbfDWrmcaDKiAl2THsytMgzNTguXCgwYuYL6xrpl16NlXb+WL+PK9leaZSEZzEm47CS/lUDI6taHX+t3cSfVBjmf5F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lzzquxUx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lzzquxUx"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675NllTh993265;
	Thu, 6 Aug 2026 08:49:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=OZ11EtV2mZPb2QIVq
	17a/epK2LrZ4cxZ64YassYOTyY=; b=lzzquxUxpWVbpU5j1yXJPDLPQWjWHgNow
	IBJCpb7nf7NB1OBjAkbP3dPJCylJX5005Iu+eYntTKzNhd3UX30iV50ReR/JLwuA
	7BqlpGrGJsv7pp9/wxE7Tv0cDu+HQe5Drf3CYlrlqy3bhGWInBYFYta9tnoRht6G
	8JMSOPBnnzD6oyZcGnnyPoWhxfyjZgHpUBKoZho6E63Ld9RopNJUG97hraT58EFB
	nENfFVakwD2urQ0oTdS5Cr9tqMbQ9eUxC8+ouYpFopteXwF8CQBfTftRb2RLnbf0
	KrEmB4+TzIWd+P1zWse6Mod5sOG0S4GIrS4nq579Vs6JbqGVa3TFw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs77getes-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 08:49:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6768fHWm018555;
	Thu, 6 Aug 2026 08:49:55 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsvmhjbg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 08:49:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6768npcw32309694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Aug 2026 08:49:51 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 224952004B;
	Thu,  6 Aug 2026 08:49:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C73B82004E;
	Thu,  6 Aug 2026 08:49:50 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.145.185])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Aug 2026 08:49:50 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 1/2] s390/crypto: Fix skcipher_walk return code handling in aes_s390
Date: Thu,  6 Aug 2026 10:49:49 +0200
Message-ID: <20260806084950.17679-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806084950.17679-1-freude@linux.ibm.com>
References: <20260806084950.17679-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA2OCBTYWx0ZWRfX/BTlQqI+eb5T
 MV4WaIY2jWBxd1jodBrNEVR5Ay+XehTDi6u/PfThpbgW+0vAYZFmmROwZaif0+S17aiWGRFDQrX
 T3UwBv1/OmSsf7n7d5mcU51M0g/IaVPFFzxe5FKHasapIuHNAfzc+NwbsZrnMqldvSVXLn4k0oO
 sijk/wbkQ5qvEs6pe1ejXOtFnbN7nLbO1trVXCFYmc2yH5dSNv/8SvfoZ/1Qaq4VvbxiHQZ/D4L
 beYYq2BNvjx9urIDIMMZTQYoV1Df+lvV6hUXUfC1ESGYh4oB5cXIE0s1gY27DSaLCqysB5wWZpk
 9zuLaPXpkh93z5bXYdNHhysqmut84Vhj/AzyrcRFwYkvzLntvPhhGFhvMLaI2XHtCHqjLQdrAnz
 BTj3670xpi04BF6BxjkU0p6qtSzlWSZLtQLmUiA42e2qLDNtSj/5PEwCmJfJIa39DL4z8JYakCL
 P4uKBrVC293H3SLVP6w==
X-Authority-Analysis: v=2.4 cv=WIFPmHsR c=1 sm=1 tr=0 ts=6a744ab3 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=CBD_y4w3mMu2BuU9sPoA:9
X-Proofpoint-GUID: Kpox3DJGYqhrgvH3PDqmKFBaKj_4eBrQ
X-Proofpoint-ORIG-GUID: Kpox3DJGYqhrgvH3PDqmKFBaKj_4eBrQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA2OCBTYWx0ZWRfX711JWU4ezIwA
 m5oloev/La/E76xJTy2ZFlCI4rrWRxSnX/sG3OBKyLCie+UaZPQe8PEjqlWkxaPaUHzyKvZfzKJ
 PtVJCJgt7YkXOskAOyyCAUG2d4VhxDY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060068

The return codes from skcipher_walk_virt() were not properly checked
before entering the processing loops in ecb_aes_crypt() and ctr_aes_crypt().
If skcipher_walk_virt() fails, the walk structure may be in an undefined
state, and attempting to process data could lead to incorrect behavior
or accessing uninitialized memory.

Add proper return code checking to ensure correct handling of the walk
initialization and walk advance and eventually return to the caller
with that return code.

Fixes: 7988fb2c03c8 ("crypto: s390/aes - convert to skcipher API")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 5.5+
---
 arch/s390/crypto/aes_s390.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 62edc66d5478..366ce22d3623 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -129,7 +129,7 @@ static int ecb_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 		return fallback_skcipher_crypt(sctx, req, modifier);
 
 	ret = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) != 0) {
+	while (!ret && ((nbytes = walk.nbytes) != 0)) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_km(sctx->fc | modifier, sctx->key,
@@ -233,7 +233,7 @@ static int cbc_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 		return ret;
 	memcpy(param.iv, walk.iv, AES_BLOCK_SIZE);
 	memcpy(param.key, sctx->key, sctx->key_len);
-	while ((nbytes = walk.nbytes) != 0) {
+	while (!ret && ((nbytes = walk.nbytes) != 0)) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_kmc(sctx->fc | modifier, &param,
@@ -359,7 +359,7 @@ static int xts_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 	memcpy(xts_param.key + offset, xts_ctx->key, xts_ctx->key_len);
 	memcpy(xts_param.init, pcc_param.xts, 16);
 
-	while ((nbytes = walk.nbytes) != 0) {
+	while (!ret && ((nbytes = walk.nbytes) != 0)) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_km(xts_ctx->fc | modifier, xts_param.key + offset,
@@ -487,7 +487,7 @@ static int fullxts_aes_crypt(struct skcipher_request *req,  unsigned long modifi
 	memcpy(fxts_param.tweak, req->iv, AES_BLOCK_SIZE);
 	fxts_param.nap[0] = 0x01; /* initial alpha power (1, little-endian) */
 
-	while ((nbytes = walk.nbytes) != 0) {
+	while (!ret && ((nbytes = walk.nbytes) != 0)) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_km(xts_ctx->fc | modifier, fxts_param.key + offset,
@@ -577,7 +577,7 @@ static int ctr_aes_crypt(struct skcipher_request *req)
 	locked = mutex_trylock(&ctrblk_lock);
 
 	ret = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
+	while (!ret && ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE)) {
 		n = AES_BLOCK_SIZE;
 
 		if (nbytes >= 2*AES_BLOCK_SIZE && locked)
@@ -596,7 +596,7 @@ static int ctr_aes_crypt(struct skcipher_request *req)
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
-	if (nbytes) {
+	if (!ret && nbytes) {
 		memset(buf, 0, AES_BLOCK_SIZE);
 		memcpy(buf, walk.src.virt.addr, nbytes);
 		cpacf_kmctr(sctx->fc, sctx->key, buf, buf,
-- 
2.43.0

