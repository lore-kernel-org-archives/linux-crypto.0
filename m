Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A524B3D8128
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 08:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165469; cv=none; b=KjSXaN3qeJq2N9iLSv2W9TeSHWrOgCK/EhmI+9natR+IAIY/chVAydo6GcivWjYkBaLft0a11MaWED4167XTH8Q2xLvueuoaS6kWumUwAeJalVd2Zq7O5HvE2/y1Erdaeg440rVgOAbXJVw526ZRTz8inDzQhOHfTTJ8nfRDKOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165469; c=relaxed/simple;
	bh=1W5QgFEP7Cd/+cEKXixmrYbUov60LFH+I5FuffFr09k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzUlTPhS5olsxu5Zhj3SeJRRYxRJORkow0e9X50PB5fOKUF1uo+H7n8NbVlcIjkfdqKvtkWHXiVVYMczTlTbQzEa3lG49cpSGAQ0fUFteIG3xaCYvU8g2xx/v5lBFejz1wnjz6LI3hLUeYvyO+DiK+xCwKTNC9CQc375ZakQjcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WhKJ/Wtg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WhKJ/Wtg"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V82KdH1697632;
	Mon, 31 Aug 2026 08:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=a2PgjeejAoiq/71C+
	uNbSGF+XshiQL7GB4Ethv5qB5w=; b=WhKJ/WtgO5ZPyT7TYuvoFA/+BppgsDPaL
	/fbkh39ysPIjH4kvtk4QdDGb3LbfS192HnOoxshL7djYNRqrxmUwlZkpSmYQW7Eg
	LPR08lU3XFJFQ/6Zj9RlB5my/8d+NK27xxzHQU7IsHx66JqEC7AJN3eJBCFghhCN
	oUGCyj8BWp33li8+d6+QDPWLoX843ov88KMcOXfU0uCRQxXqnyYFJXUhAHNXhxNz
	k3VIcQNc0rXlrJgf+f494qnVW/9e33MvYMj34kP146Y1+cq9DeXake1AF3hbY9D5
	HlAGb71RUyZA+OxS8OmqT3bstw6Kj8RGgbBaZBinXWaFfsolCsMDg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq2syxxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:37:40 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QHp7023187;
	Mon, 31 Aug 2026 08:37:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gc9rq51jn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:37:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8ba3p47383038
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:37:36 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E18022004F;
	Mon, 31 Aug 2026 08:37:35 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C07E02004E;
	Mon, 31 Aug 2026 08:37:35 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.165.38])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Aug 2026 08:37:35 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v5 1/3] s390/crypto: Fix skcipher_walk return code handling in aes_s390
Date: Mon, 31 Aug 2026 10:37:33 +0200
Message-ID: <20260831083735.3625-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831083735.3625-1-freude@linux.ibm.com>
References: <20260831083735.3625-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=bc1bluPB c=1 sm=1 tr=0 ts=6a953d54 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=CBD_y4w3mMu2BuU9sPoA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX9Qk7c9au1bMD
 H/Xg4BYrmdJMe9/1IZBV1/l7EwI8oLYAkyd0MNcOIF9OwnbS4IoYThN+eHsshDR6xamFLBiPd/b
 gYTkYnOedrmXThQNg61oClGeTNTqQXA=
X-Proofpoint-ORIG-GUID: onl5jOAZVnkUkDPI7V6zbDx2TPsm_dM-
X-Proofpoint-GUID: onl5jOAZVnkUkDPI7V6zbDx2TPsm_dM-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX0/TQ5SZyLOss
 dA5Gb33LcxmrAS6u86TegRTfrX2SgZC7zy0aj1KPMHdx7optaIW7Z4yUWQqP66Q1LPjbwMOG+Aq
 oQ6R5kbQaPhc8txYS69ca8ZDcwGIQZOu14JT+YSP6Ue+IWP0wsoyC+538vEGfc5FPU8jOcWasXk
 1LgM1FphIUJrYZH6AoE0apDUdNH3ctasdcptZsatq+53vfdsQB4FPZND+e8sNfzJydI3avbRHud
 y0RQm0U3i2zoMUaR4UgPGz2T51tczBk9DVzO9oxKVeRf0ZMnX9/LSJmvRScfO3uAWIwewyV4MFC
 fQFvT8Iln+mYjN6qLLBAPMP3phEt+fDA9a5oWDj3iY7DT+kTQlN+ys77JUoOFcoQKAoq11mtNUc
 9p9S+c8tRYbLV3htclyEklOgVtA5c/ftlobRNwF+QLu+rbROdRv3DIdkbXx4YK12qz7473q7R5i
 kypK+9U2U1UdDSVmPGA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310072

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
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
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

