Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8514A340DB8;
	Thu, 13 Aug 2026 15:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786636461; cv=none; b=FJ91PGh6W/Kvz/eX+6VaHkOOX7rvE7dpoiA4JnVtnQDyK5+CJoYcoZ6DQDdJ6Kyj80PN7wLMQrUyH8iKgXQSrYxlvf+QE1Q/GNpHpCw7roEwCSGkxRWMaFBemYdI0Hdlbbfl6Wthc+SC+6d6rNGhxJPS9LDnlMedwNZFaNLp7NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786636461; c=relaxed/simple;
	bh=IYw1kexUbqDc3aQobgX0w+w7Fkzw4pFsLTlyXWFOR4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xx2uTzSzv4cIlq+4Zut1KYYtvcTDStfHCKIWm3TSvwKK3BrM//9K14lumndao08W/4pYNgusd40oVIVxrGgHByF8e/9UgsyvzFicvSVMY+cFnYGLJdfg9RSfOra/xNL3G7Xl9olq5Ok7GIA2wuAie9d1rJdMbKvSmCPTNRuQ+gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mEjyj146; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mEjyj146"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67DFWliO2737038;
	Thu, 13 Aug 2026 15:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=5vdxpTy+PYD5S8jNJ
	u6iGjo6dQdMv6qKRad1C8mv3N0=; b=mEjyj146UH9WT/2XEGiZo1rsxjHK5Y2c2
	FHxYswQGeqpGkjgu0UHVdaa4vHT5KYyu+pE+9zU3dpyuN9sFzHG92rSVmrlRuYgc
	SWmbvjqwc3LqYL1FTwXngkejOcjWn36nV8fMfEyemUqNPchP1TadGUHWDJXbAlnt
	bZeJTUN5tFIwLvbWIi4gEM0wbVgVw48Mc/7zAYOKSuQ67n2gAgO2vB2NYZLj7aAQ
	cxD19flq/GGthCvtc8sNmokhe8UOfN+iZXQih29EBN1vAOpnmbNGqrPg+zXS+tBf
	F4jopCAY+mxzPyPT0OCF5oxiM/x0w26Vid4cE79qovFTi/wpkczrw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvma0rxd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 15:54:12 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67DFflPg014777;
	Thu, 13 Aug 2026 15:54:11 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxhfybdj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 15:54:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67DFs7f141157004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Aug 2026 15:54:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7BB2320040;
	Thu, 13 Aug 2026 15:54:07 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 586F42004B;
	Thu, 13 Aug 2026 15:54:07 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.193.32])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Aug 2026 15:54:07 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 3/3] s390/crypto: Rewrite AES ctr mode to be prepared for context analysis
Date: Thu, 13 Aug 2026 17:54:06 +0200
Message-ID: <20260813155406.50051-4-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813155406.50051-1-freude@linux.ibm.com>
References: <20260813155406.50051-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDExMSBTYWx0ZWRfX0fQBiFZ5zdUm
 K6XuryYhoyWcpQK7IRgjj8h8cB1ppO5mKLs7XSaHC5kBggEPbxM37NjTKOiftSOsU87Sy138Bbk
 JdzQ+z0BywzM18Z72lKRy4twRjt2jNp6Llu+7xgo03kJ5KNHZT/Tq9ccgyly01x5CJ/7jzfFDku
 irwp3CHdyAqH5tRhLBfKQikH4iUM2tcF3vFth5B2E3Ygg5rfz+og2hjRe4eeY9+yQWjq/tZpUdu
 vIrx0PPTlgdfZ2aHCYmjPf9Sqyl0oeiciOS1NzJb+8l8M45WBZl67bh8cSf+fifVaqwVCKX5gxL
 Blir531p7CNu84ILw4ceayLk61vNIBJbxwXpYRls7UW8wJTR9niEhtsaBJils+3XNjAXJL48weV
 g74j4cIsl4tN135L0Bt8eZEQYFIgy/c9coAw0GPQ6+CeSrXXhlvoRXA7dq6MIylz2s/nuHNYA3i
 e11+0YPX8nsfGpbgLEQ==
X-Proofpoint-ORIG-GUID: 2HTq1IJi6eNyLl6aYw9bUHrgVzJN2XW6
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDExMSBTYWx0ZWRfX+xR81q+2rDL/
 Rhp4NtV/wYed6qOhVXI1+8kzr1jBaZzjS//9RTlVd/Ah4I04WDFCy3QjzQJcLNtUyVBzo4Sc1RK
 CBFXaXwECs9Hzp2p5ewIMBloKtGMVPU=
X-Authority-Analysis: v=2.4 cv=IfK3n2qa c=1 sm=1 tr=0 ts=6a7de8a4 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=e91DsxHqfR-orwYc_R4A:9
X-Proofpoint-GUID: 2HTq1IJi6eNyLl6aYw9bUHrgVzJN2XW6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608130111

The AES ctr implementation produces a warning when used with clang and
CONTEXT_ANALYIS enabled:

arch/s390/crypto/aes_s390.c:585:13: warning: mutex 'ctrblk_lock' is not held on every path through here [-Wthread-safety-analysis]
  585 |                 ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk.iv;
      |                           ^
arch/s390/crypto/aes_s390.c:577:11: note: mutex acquired here
  577 |         locked = mutex_trylock(&ctrblk_lock);
      |                  ^

Rewrite and reorganize the code such that the clang compiler's needs
are fulfilled with keeping the compatibility, performance and
correctness of the crypto algorithm.

Also cover a finding from Sashiko about that the mutex_trylock() may
be invoked from a softirq context. So add a check to make sure only in
process context try to lock the mutex.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/crypto/aes_s390.c | 60 +++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 10561aa687c7..8295cb3fc56c 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -562,46 +562,62 @@ static unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes)
 	return n;
 }
 
+static int __ctr_aes_crypt(struct s390_aes_ctx *sctx,
+			   struct skcipher_walk *walk, bool locked)
+{
+	unsigned int n, nbytes;
+	int ret = 0;
+	u8 *ctrptr;
+
+	while (!ret && ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE)) {
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
+	int ret;
 
 	if (unlikely(!sctx->fc))
 		return fallback_skcipher_crypt(sctx, req, 0);
 
-	locked = mutex_trylock(&ctrblk_lock);
-
 	ret = skcipher_walk_virt(&walk, req, false);
-	while (!ret && ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE)) {
-		n = AES_BLOCK_SIZE;
+	if (ret)
+		return ret;
 
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
+	if (in_task() && mutex_trylock(&ctrblk_lock)) {
+		/* process context and mutex acquired */
+		ret = __ctr_aes_crypt(sctx, &walk, true);
 		mutex_unlock(&ctrblk_lock);
+	} else {
+		ret = __ctr_aes_crypt(sctx, &walk, false);
+	}
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
-	if (!ret && nbytes) {
+	if (!ret && walk.nbytes) {
 		memset(buf, 0, AES_BLOCK_SIZE);
-		memcpy(buf, walk.src.virt.addr, nbytes);
+		memcpy(buf, walk.src.virt.addr, walk.nbytes);
 		cpacf_kmctr(sctx->fc, sctx->key, buf, buf,
 			    AES_BLOCK_SIZE, walk.iv);
-		memcpy(walk.dst.virt.addr, buf, nbytes);
+		memcpy(walk.dst.virt.addr, buf, walk.nbytes);
 		crypto_inc(walk.iv, AES_BLOCK_SIZE);
 		ret = skcipher_walk_done(&walk, 0);
 		memzero_explicit(buf, sizeof(buf));
-- 
2.43.0

