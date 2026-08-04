Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5148366546;
	Tue,  4 Aug 2026 11:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785843472; cv=none; b=ADqlqCX78EpbrdKJH0+0nFp4+zM3fX8dUjit3Lmwu2fbvTkMu4zpJt106FjyEYEUu5apYDSnncWzQ3AVMnIPwCBgv72gu6cAjCkuhsng6KoRR0KmjLdKBpCCOf5kbHYljKSSx7NNL3BoW+Gm1tNS6NeT3dr5CqZGQQkLXcbzLQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785843472; c=relaxed/simple;
	bh=ts0XQmNOx7XtHue//tpOAU9G//jcEVC8cJ+sDvhsDFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez+qh6sM1KVxowPf6sgaiELdGfHdKKCvhNSUHju0ExqTk9X7EGWhMugsMn0xWNHq/rNnC/Sk86v04X6AvkCAoWvvpC8Y9OIA9J2cZxzGNH5d0AoWSwMj7xnAriQIZBWl6+NLMXeuHnqZAE3Pnqe9s+HlaDftleybnM14ubQAXak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=T5c2eXW3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="T5c2eXW3"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6748HUJS323443;
	Tue, 4 Aug 2026 11:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=XwGGfuvy4HLVO8e/x
	epTISc9Tht5d7q5k1aAnxJNsaU=; b=T5c2eXW332x3f4waFmiBuPcoL0FVvFK/A
	ugvN8hYjFWaqszYtV2HmqbsC2dr6MJFhsJf4mCEsNi7+WoDGneoBAqSZbqn78VQf
	6E7ZmTzaKh/945cQhlDSieHu8++kbc7YT6R5UEuNPws1zTFLItx27okyRuwD3EU2
	xWWOdbL1KOyKz1N/ZR/aCAXJdC2Y5JM8EDNNCA3b70c0RVHsGBvOfnlC+/VvxK2J
	0Aol5HUFkYuExoaQbzQby/gYJRwJEw5AXcLQod1HXWDQEbqZO3w79VdSSjdnCGS8
	YY4mlASe57PUx9AumhYX3v3PDDHjTAmxwyP0WoQERfHPOFt1UZ9dw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8h4wkbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 11:37:42 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 674BQLdg009806;
	Tue, 4 Aug 2026 11:37:40 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsvmh9neu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 11:37:40 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 674Bbapv44171696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Aug 2026 11:37:37 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D31AB2004B;
	Tue,  4 Aug 2026 11:37:36 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A33A12004D;
	Tue,  4 Aug 2026 11:37:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Aug 2026 11:37:36 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 1/3] s390/crypto: Rework ctr_aes_crypt() to remove conditional locking
Date: Tue,  4 Aug 2026 13:37:34 +0200
Message-ID: <20260804113736.1423667-2-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260804113736.1423667-1-hca@linux.ibm.com>
References: <20260804113736.1423667-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDA5MCBTYWx0ZWRfX++kZP1pquKVD
 t/t+37fCUXjFwXA+st3Jf3TrLXGhD6kwt7pwYCusagMk7KC8PclyNrOCz4sDEQvy3OmDsvQ6UXM
 NPTkJhqvSpNXdWazjIHdSt8H1/1vIVY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDA5MCBTYWx0ZWRfX4LLoEbkE4wCt
 /C9yvxyKERzL5IW292wYduCN+M1ehACuB4SMphO3d/PqeOT8gn2pnPLDx59XWkDljPhMrX911q/
 KBh9oSczuZ9H9Xor7TMkVfIW8eHneEE2WctQzpdm+nLfSuavSDpvP/N2rhfqryqiG7OJohcWAQ/
 gYXrAGM2ZXwBKdKWh84DkYy53lkyBBHWcr9GX0vx10OTC2bRALhKpstYTRo7wQ/C4TwSC2Z0cNJ
 2bs4TchJMIB5bHUkG8O7h69ru41H/UE1dDJdxfil7dZkMqyP0B8amCv+kAuO+7obOD5g0gw8ZFh
 UvHHgV04mRdKZsI/KlB0iB1/VPod1X0z8hYgiXI2nApJFJAgxqwpJNDxiFPUpc2IZerIdI9B0R3
 AIrhcsXhe3eecW2uDwcubohKGpMuyROFv8uQqEBLZ4agB9QE1qNsoWvub/mXAcNwz+aO2dbztLp
 hH+4n8ZVx8wU0dRFRXQ==
X-Authority-Analysis: v=2.4 cv=SI1ykuvH c=1 sm=1 tr=0 ts=6a71cf06 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=WSDBmxW9uEwFgrZJePAA:9
X-Proofpoint-ORIG-GUID: g0gSl_rI6OLYr8Oncl10UV8EXrqj3Chh
X-Proofpoint-GUID: g0gSl_rI6OLYr8Oncl10UV8EXrqj3Chh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_02,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040090

Clang's compiler based static context analysis does not work with locks
that are conditionally taken like in ctr_aes_crypt():

arch/s390/crypto/aes_s390.c:585:13: warning: mutex 'ctrblk_lock' is not held on every path through here
      [-Wthread-safety-analysis]
  585 |                 ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk.iv;
      |                           ^

Given that code which takes locks conditionally can be considered
suboptimal rework ctr_aes_crypt() to get rid of this.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/crypto/aes_s390.c | 54 ++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 62edc66d5478..4b7e47423e89 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -562,37 +562,53 @@ static unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes)
 	return n;
 }
 
+static int __ctr_aes_crypt(struct s390_aes_ctx *sctx,
+			   struct skcipher_walk *walk, bool locked)
+{
+	unsigned int n, nbytes;
+	int ret = 0;
+	u8 *ctrptr;
+
+	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
+		n = AES_BLOCK_SIZE;
+		if (nbytes >= 2 * AES_BLOCK_SIZE && locked)
+			n = __ctrblk_init(ctrblk, walk->iv, nbytes);
+		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk->iv;
+		cpacf_kmctr(sctx->fc, sctx->key, walk->dst.virt.addr,
+			    walk->src.virt.addr, n, ctrptr);
+		if (ctrptr == ctrblk) {
+			memcpy(walk->iv, ctrptr + n - AES_BLOCK_SIZE,
+			       AES_BLOCK_SIZE);
+		}
+		crypto_inc(walk->iv, AES_BLOCK_SIZE);
+		ret = skcipher_walk_done(walk, nbytes - n);
+	}
+
+	return ret;
+}
+
 static int ctr_aes_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_aes_ctx *sctx = crypto_skcipher_ctx(tfm);
-	u8 buf[AES_BLOCK_SIZE], *ctrptr;
 	struct skcipher_walk walk;
-	unsigned int n, nbytes;
-	int ret, locked;
+	u8 buf[AES_BLOCK_SIZE];
+	unsigned int nbytes;
+	int ret;
 
 	if (unlikely(!sctx->fc))
 		return fallback_skcipher_crypt(sctx, req, 0);
 
-	locked = mutex_trylock(&ctrblk_lock);
-
 	ret = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
-		n = AES_BLOCK_SIZE;
 
-		if (nbytes >= 2*AES_BLOCK_SIZE && locked)
-			n = __ctrblk_init(ctrblk, walk.iv, nbytes);
-		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk.iv;
-		cpacf_kmctr(sctx->fc, sctx->key, walk.dst.virt.addr,
-			    walk.src.virt.addr, n, ctrptr);
-		if (ctrptr == ctrblk)
-			memcpy(walk.iv, ctrptr + n - AES_BLOCK_SIZE,
-			       AES_BLOCK_SIZE);
-		crypto_inc(walk.iv, AES_BLOCK_SIZE);
-		ret = skcipher_walk_done(&walk, nbytes - n);
-	}
-	if (locked)
+	if (mutex_trylock(&ctrblk_lock)) {
+		ret = __ctr_aes_crypt(sctx, &walk, true);
 		mutex_unlock(&ctrblk_lock);
+	} else {
+		ret = __ctr_aes_crypt(sctx, &walk, false);
+	}
+
+	nbytes = walk.nbytes;
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
-- 
2.53.0

