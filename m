Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD92367B71;
	Tue,  4 Aug 2026 11:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785843473; cv=none; b=aT7lr8vmSTAWQw+xp13Td5yl1S4ons8oNaNJN0n7PlpiviScGIAtQfh3vzH5AnQKt4SN3n2frJGpU8+7/j9r1u1CUSWMvpu8zKWLU+v9oDGMr2nYfcYOe/T/0IoJ0Vuexg9/qIczFAsw4/055xKw5ZlAywLRDKVJGay4u++Pw8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785843473; c=relaxed/simple;
	bh=eJNjEQmcOcwt1zVIh2UcoddTj0ZphN8gmeoJRMgY8Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhLu08AVi+CE38YSlalHZCWXq4nrFicvXGH6x5m+VN7J6VdTJ+S/1MiRrpLf/noqrk/NxObDuUidbBGrapGoTpNKfawGkwcXTmDo166/5/FcH0YHkppFSM14n2Z7aZPyVBqXjRbhxcz05rAKxfEe8FGoeKZFrY7eZY3Lj1FNf4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OIdPia8W; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OIdPia8W"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6748HYmS323765;
	Tue, 4 Aug 2026 11:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=n1tP/Wb6I+V56lc0X
	H0QW++tQ4IYzSXAzAfvoyTkBNU=; b=OIdPia8WDA/8DLlNHha6BPbSjMK9vHTbH
	zjajGSYGFreK0ZVs4yWE9X/PNk457Jg26r7l6X7/aZi9gTleE7TqdRjHGdaPZqq7
	cmApXA1nD8jdbPI0AR0wWJ1az/mpdx4jSW4qEonFcLYnr+1RSSD7U+xGNBmJLcTW
	hMWudTPIbkwQmwEUvg2Mn2VG9W0GQ6TuZjcbkyX2mAOT9EqRZPR4XfLBuwfNyqgE
	VYHj125xbUIr+uafEu6xAKFUr0xrxCAb2QW4+IXdiQxUjjpcZW2vPYesplbh1OhF
	8nwFFbwPVD6JJNgR2goD7Xw4urcDAF+bsntBPNJ8WXDJqzj2fgYww==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8h4wkbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 11:37:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 674BBIwR020840;
	Tue, 4 Aug 2026 11:37:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugw1tpx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 11:37:40 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 674BbbfE32702914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Aug 2026 11:37:37 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1293E2004B;
	Tue,  4 Aug 2026 11:37:37 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8FFC2004E;
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
Subject: [PATCH 2/3] s390/crypto: Rework ctr_paes_do_crypt() to remove conditional locking
Date: Tue,  4 Aug 2026 13:37:35 +0200
Message-ID: <20260804113736.1423667-3-hca@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDA5MCBTYWx0ZWRfX5UTDsrJJ/twB
 i5Pb6MxsxqeLmniVTcw0QV4Lp43OWAegeGaPqnSnNScG23PjZkKE5RhlXzQOmYkMJecgXwttuxq
 8M+lPn52e9Cha9kWAbT3jXp6NkRoy34=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDA5MCBTYWx0ZWRfX+mjVJjigqzfa
 LUPGRRZLH7d7IcOCLvMkxvvmAUBq+KVpac0tmdOzARRV9T8TYr6e/fflsDQNLjwFG31rmFDU+4d
 iqibXlE9cV+nuW0G5gUVqxi4eBMRmooCVWBau+affFtYYMFamGXt8lyAibSE0uJHYpF19gX44IB
 VrcCR9+5QmVxMKsyKloEy35iivmzDoJM3lQAuuCeh25wr3khYxQERILBlT2+LyK2+XRFNOYmnwU
 IpzVtmnJZz6o5Z6AnjmESGQU5O49dOJ3Q7tRT4WquEecbnB3m/OiQHFew8q2w+oWopIYVbe3P32
 HCajjYPFxs82Nm6OT9yux8U0+oE1rs5ccYeS99efqJZ5/grAHeHhopQZhz7czRCW7+McFHlxUTJ
 PIvwxLACXT7LCRp2ZG31Z97T/3xufA0ej7STiUazylOZG/PvHaACyQX+UWJucchRX5wCL4nUNAJ
 jhsAuP0MI16hICnRr5A==
X-Authority-Analysis: v=2.4 cv=SI1ykuvH c=1 sm=1 tr=0 ts=6a71cf06 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=AK4rZKg6osCYkldYSQwA:9
X-Proofpoint-ORIG-GUID: OO4eJjJwJLK-S0tn5yVjK-kuFCn6o1jk
X-Proofpoint-GUID: OO4eJjJwJLK-S0tn5yVjK-kuFCn6o1jk
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
that are conditionally taken like in ctr_paes_do_crypt():

arch/s390/crypto/paes_s390.c:980:13: warning: mutex 'ctrblk_lock' is not held on every path through here
      [-Wthread-safety-analysis]
  980 |                 ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk->iv;
      |                           ^

Given that code which takes locks conditionally can be considered
suboptimal rework ctr_paes_do_crypt() to get rid of this.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/crypto/paes_s390.c | 104 ++++++++++++++++++++---------------
 1 file changed, 60 insertions(+), 44 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 8cfe6166c193..d4a9108d39f5 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -932,15 +932,63 @@ static inline unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes
 	return n;
 }
 
+static int __ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
+			       struct s390_pctr_req_ctx *req_ctx,
+			       bool tested, bool maysleep, bool locked)
+{
+	struct skcipher_walk *walk = &req_ctx->walk;
+	struct ctr_param *param = &req_ctx->param;
+	unsigned int nbytes, n, k;
+	u8 *ctrptr;
+	int rc = 0;
+
+	/*
+	 * Note that in case of partial processing or failure the walk
+	 * is NOT unmapped here. So a follow up task may reuse the walk
+	 * or in case of unrecoverable failure needs to unmap it.
+	 */
+	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
+		n = AES_BLOCK_SIZE;
+		if (nbytes >= 2 * AES_BLOCK_SIZE && locked)
+			n = __ctrblk_init(ctrblk, walk->iv, nbytes);
+		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk->iv;
+		k = cpacf_kmctr(ctx->fc, param, walk->dst.virt.addr,
+				walk->src.virt.addr, n, ctrptr);
+		if (k) {
+			if (ctrptr == ctrblk) {
+				memcpy(walk->iv, ctrptr + k - AES_BLOCK_SIZE,
+				       AES_BLOCK_SIZE);
+			}
+			crypto_inc(walk->iv, AES_BLOCK_SIZE);
+			rc = skcipher_walk_done(walk, nbytes - k);
+		}
+		if (k < n) {
+			if (!maysleep) {
+				rc = -EKEYEXPIRED;
+				goto out;
+			}
+			rc = paes_convert_key(ctx, tested);
+			if (rc)
+				goto out;
+			spin_lock_bh(&ctx->pk_lock);
+			memcpy(param->key, ctx->pk.protkey, sizeof(param->key));
+			spin_unlock_bh(&ctx->pk_lock);
+		}
+	}
+
+out:
+	return rc;
+}
+
 static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 			     struct s390_pctr_req_ctx *req_ctx,
 			     bool tested, bool maysleep)
 {
-	struct ctr_param *param = &req_ctx->param;
 	struct skcipher_walk *walk = &req_ctx->walk;
-	u8 buf[AES_BLOCK_SIZE], *ctrptr;
-	unsigned int nbytes, n, k;
-	int pk_state, locked, rc = 0;
+	struct ctr_param *param = &req_ctx->param;
+	u8 buf[AES_BLOCK_SIZE];
+	int pk_state, rc = 0;
+	unsigned int nbytes;
 
 	if (!req_ctx->param_init_done) {
 		/* fetch and check protected key state */
@@ -966,49 +1014,17 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 	if (rc)
 		goto out;
 
-	locked = mutex_trylock(&ctrblk_lock);
-
-	/*
-	 * Note that in case of partial processing or failure the walk
-	 * is NOT unmapped here. So a follow up task may reuse the walk
-	 * or in case of unrecoverable failure needs to unmap it.
-	 */
-	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
-		n = AES_BLOCK_SIZE;
-		if (nbytes >= 2 * AES_BLOCK_SIZE && locked)
-			n = __ctrblk_init(ctrblk, walk->iv, nbytes);
-		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk->iv;
-		k = cpacf_kmctr(ctx->fc, param, walk->dst.virt.addr,
-				walk->src.virt.addr, n, ctrptr);
-		if (k) {
-			if (ctrptr == ctrblk)
-				memcpy(walk->iv, ctrptr + k - AES_BLOCK_SIZE,
-				       AES_BLOCK_SIZE);
-			crypto_inc(walk->iv, AES_BLOCK_SIZE);
-			rc = skcipher_walk_done(walk, nbytes - k);
-		}
-		if (k < n) {
-			if (!maysleep) {
-				if (locked)
-					mutex_unlock(&ctrblk_lock);
-				rc = -EKEYEXPIRED;
-				goto out;
-			}
-			rc = paes_convert_key(ctx, tested);
-			if (rc) {
-				if (locked)
-					mutex_unlock(&ctrblk_lock);
-				goto out;
-			}
-			spin_lock_bh(&ctx->pk_lock);
-			memcpy(param->key, ctx->pk.protkey, sizeof(param->key));
-			spin_unlock_bh(&ctx->pk_lock);
-		}
-	}
-	if (locked)
+	if (mutex_trylock(&ctrblk_lock)) {
+		rc = __ctr_paes_do_crypt(ctx, req_ctx, tested, maysleep, true);
 		mutex_unlock(&ctrblk_lock);
+	} else {
+		rc = __ctr_paes_do_crypt(ctx, req_ctx, tested, maysleep, false);
+	}
+	if (rc)
+		goto out;
 
 	/* final block may be < AES_BLOCK_SIZE, copy only nbytes */
+	nbytes = walk->nbytes;
 	if (nbytes) {
 		memset(buf, 0, AES_BLOCK_SIZE);
 		memcpy(buf, walk->src.virt.addr, nbytes);
-- 
2.53.0

