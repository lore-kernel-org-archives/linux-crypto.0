Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3F046EC95;
	Fri, 14 Aug 2026 12:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786711047; cv=none; b=f0ixdnTRyWbLzgPrz2hifnz+S4IJZo/BwFuQEJ8RFeAa+RYuAwn9Hrz0hdn9mCN9dSs2T53u+ctbigOm+X0AwBikgT0BJ71pV0ziGdDKkpVvO4jZE9L0UnS1vDUUKw2skbZ2TiIBV3KoWgVSxQuRwbCELER76ztmF2krbKhjRBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786711047; c=relaxed/simple;
	bh=TnhvjgQ+Napyf0PkgUQSG8OwkfMCu8KVyYlywY/C8GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qk5kQr4JZ5NMCI5SUNPFQKfegnqI9o1QQcD2W6T+Dx9kkCqZOhnq/B0QvIG6DKBEYauiret+EUnmnTpQC6M9KoHaxhTUNq6VSrvPuoTQz8GW+oFCQ73bMs4QRnif4LldliRUNYuHfKuGLV70olUBK+uZe53rlSj4sFVwe/+ozus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Yi3Ef/b1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Yi3Ef/b1"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EB1cAF860099;
	Fri, 14 Aug 2026 12:37:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=OZ11EtV2mZPb2QIVq
	17a/epK2LrZ4cxZ64YassYOTyY=; b=Yi3Ef/b1FP/gngmXGld+atnHINyzlbBjt
	5xJti+iaKjWSNCp5Ms2/oLqm7S77bPKq7q+z4XaHc7F7qYTInpctosZJ/q70DFJD
	ER56TwFUfMHFPNLD2S6W551Kcgi9AwQp2pJxNzp/ubrT4epeuqG3/21HKJo0L6Pc
	v6fTqfT3bYYdugJXvsdO5auQk4B6cBs/3CAomeahohyn7aZQHKpNnhVH7aj4FuxA
	xyS63KpWuWj/lxSH0O803oIhpPUnjLIl9E7YNCrD5daCRyL6j98P6iyCMQ0F572A
	UErn8h2qwsrcqoPiRi5ccmL7qYDeDrhzqgnNio1mwiW0u5rsqND5A==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvp3bkwg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 12:37:16 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67ECQdfW006867;
	Fri, 14 Aug 2026 12:37:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxh0gq575-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 12:37:15 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67ECbCSH44499370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 12:37:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D9EB20040;
	Fri, 14 Aug 2026 12:37:12 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 09DEC2004B;
	Fri, 14 Aug 2026 12:37:12 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.129.52])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 12:37:11 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v4 1/3] s390/crypto: Fix skcipher_walk return code handling in aes_s390
Date: Fri, 14 Aug 2026 14:37:09 +0200
Message-ID: <20260814123711.61145-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814123711.61145-1-freude@linux.ibm.com>
References: <20260814123711.61145-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=AMtp2X5w c=1 sm=1 tr=0 ts=6a7f0bfc cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=CBD_y4w3mMu2BuU9sPoA:9
X-Proofpoint-GUID: LZSnMwzotIE3LYVs-Fpur2k-oTmF6HHN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDA5NSBTYWx0ZWRfXxANTz6J7/xTZ
 yuymA/JpLBhgkSyZ0QSJIa1+gnHgyrDVDC3r8REszPzd+amJ3B2iK2i6iaLln4m19nghVFOznio
 PGle+yoZ65DVh7ggHf3kW1n2gMycY3G/mb8DvOiJSMGSzNp+L0J/e4CQPBS9SGQGuG9vZ0jqqTe
 NntRjPYffCbPksknQ1kGz8cUm4pJB4vQde0++3XgI4Nr/gHn/ai8g9+1smhwXRM7EQHCksU09K/
 GIu0uF9WyvRJbskelAM8uWn5ht6nMOSoZMUbO03Ny3Uy0A0LI5+IicXUGvpDwlgciJMykoP6Hem
 6978ZG56WpcZ4IcdGQBsuog7AQh6aetK34144yMIIZ1rwUpuknqX3iO+53pG/MDiuigpLlAauDi
 Hi7KBODPc5ocx9FdQsCC4vww8zVRs8uf6h/PXpIPUxUNukdKiEqvdA6pEAhVlv82XEX1Kl2vYLk
 LGATdrN7WKoIu1nsicQ==
X-Proofpoint-ORIG-GUID: LZSnMwzotIE3LYVs-Fpur2k-oTmF6HHN
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDA5NSBTYWx0ZWRfX5dYqAfdDfPec
 J7SPeCxPbIhLNmh6AGtUyuE3HITWIKvc4IQiflB+bGdpffqu0ebrxxC0qDlHcA+nQN2HxTsu5PE
 QfvaiHIPmMhaxxXByL6blpD1CW0Clok=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608140095

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

