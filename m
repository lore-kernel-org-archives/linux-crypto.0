Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403B936F917;
	Fri,  7 Aug 2026 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786110897; cv=none; b=swZGwhOv03nNp1tw3Ho86NrupRU95Fl0FBT/hrsMg5YO9ylEruE+J8bYgfXuMMrWoqyoZ6xpbxLuDPEejDHlIFvn1xZ1t8qAmu/Ro16VBku0DlSd2qfszGY9YH1/gU7/4GFRYejd+1TC4bD1f0y0L1/VzGVDE3WUyasQ1h/RuNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786110897; c=relaxed/simple;
	bh=WBwK2un5KE8sVd5dx5UNDT3g7MHDaeQo9PiJQDovZGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDADplrCKVFayx1PVJx708NPKhirCkEnZKuCWiJYh+/vdSmU1lFmxgQk7hOihqbgQ31VPD2wZ3d0JGqfRfLdSIWci+RB6ow/4ErXMvhIqEOjKtFcqbVEea4sKE8ZNtWbnwD7J8ont7ro9ki6SXAiRcPiw1EL9Bgcv8zNBfz9xiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JsODq6Fy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JsODq6Fy"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 677CllhC1514165;
	Fri, 7 Aug 2026 13:54:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=cYz8X6JhD/xoZOufW
	WFxDpFStL6bRVUjf0LZKO1QPZE=; b=JsODq6Fy3uMYG3nOaUaBk0qAr0xl8P6zR
	uADzmKRrfn9HKVF3aIZPFH+qQxBiy547TmVANqMLoxKFsPPfSP4V8+KuHra/NzHy
	zhqw5xVdvJ/Lw73CX3KUB6W+e9HR6s5TvulJy2OqcQoy9cT0uyWCLL5hGkk3gDIX
	yc0/HlUBF/Lx5/b92wpwPfbcexjnRAWVLSUncv/Trdk8m+U/epSFZvkB72klWXPF
	cUeysCAM9alVZQOkz6mqeIdG6IpJOYl0kIfDZtX3jzJaBS9PRs/kjBcf1jJ/gbIS
	HYf0/cmrNbj13j0O+ghgldI+x4xB+4cZZ9zDR6+G4rJ64RdjRxUow==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fvxyyv63q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 13:54:46 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 677DQKcX013784;
	Fri, 7 Aug 2026 13:54:45 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugwg184-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 13:54:45 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 677Dsff030867942
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Aug 2026 13:54:41 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8765F2004E;
	Fri,  7 Aug 2026 13:54:41 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6545820043;
	Fri,  7 Aug 2026 13:54:41 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.146.84])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  7 Aug 2026 13:54:41 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 3/3] s390/crypto: Rewrite AES ctr mode to be prepared for context analysis
Date: Fri,  7 Aug 2026 15:54:40 +0200
Message-ID: <20260807135440.35888-4-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260807135440.35888-1-freude@linux.ibm.com>
References: <20260807135440.35888-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=SYrHsPRu c=1 sm=1 tr=0 ts=6a75e3a6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=e91DsxHqfR-orwYc_R4A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDEwOCBTYWx0ZWRfX9Yvs8RrGa7RV
 t5M7keJes+ZEEIIx08sckcQKfpMQYENlITGIVpB/t2aG5YlFwzsl4yFMZI6VGPHmPH6AM17MJqZ
 5Dz5E2y86QH4od29l7i2+DfL6e6gLhY=
X-Proofpoint-ORIG-GUID: dnNd51RSBILM66zw_6cnCx65P8RF0rqh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDEwOCBTYWx0ZWRfX7YUSYYz5KKEW
 cVAnP71X/jN1w0n4b0zmB1yEA4YkHhpgb5HMWsm7/Pu8DJCcBo2lNeruH2jzvuh5Tn8jdbM7xyh
 kt8/3T11wokfIFPknvLuV+Aack9Vh5qPZ01+iCC1OC48YPXRPEtSVGOETDH+ooNRYN2sArHwLxG
 mKBJZmla1pszpVh8s73lIJV2TVr/LbnW3yDMQIw2CH7gDGeS9Sq8Ixbn+R8FPAQYjaBkLbtTqds
 JPbJ8hd4m3uPflUSYkQ4tmovxsD12eOg+/cGpFrWPBRxj31d+BBLyxeHMAwwmV+t0TRIvkYJISJ
 9WWCXrd/mnOTFLzjG5pJQXtYJ9cWSUhR36HrNLbzfal508uQqGD2y/tGhYldfaXNXiv5ot/9vDt
 ET7UsGFkULZgOoCqIdVh+ojDqWWBBSoQxtCHQIlnQPZxawgDP6MMnFdA6KRQFIpDBaBNVVTfNY5
 4X4tfb46FQbmQ2OUlDg==
X-Proofpoint-GUID: dnNd51RSBILM66zw_6cnCx65P8RF0rqh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608070108

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

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/crypto/aes_s390.c | 60 +++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 976f6f7257d5..e75f41e2bcb7 100644
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
+	if (mutex_trylock(&ctrblk_lock)) {
+		ret = __ctr_aes_crypt(sctx, &walk, true);
 		mutex_unlock(&ctrblk_lock);
+	} else {
+		ret = __ctr_aes_crypt(sctx, &walk, false);
+	}
+
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

