Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170AB463B6A;
	Wed,  5 Aug 2026 12:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785932942; cv=none; b=mJrj27w0NOSJ2UV8gMpKZFr5RgDzFOHWWmeMZyodALGroUoJCZ1wqftQG1jqEl3di9nbRwM6+oHxkO/QVZKf+96sfNsUYSMgfLYCxNWEEVxH75AZP/93Y54LJqS1Grz9dSXZImQrWJXIvJBnLb9VwUKit5ooscsYS9kcSOJUuPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785932942; c=relaxed/simple;
	bh=uByyTyoqt821iBq0mnM4LJQxnRr7u5BYxPxiRJjBTus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBbp0kCoo8PvQgNOzFUhG+N92ZVMT0s78QfSqV4pbmiLY9hXjEDObF1Z2ShvRI00SslAMGBJwzJGLEdHZ7Li1QZ/jtuydyLGPg2LQ2VY/bRJRvk5Ekxqo1hILrspueHY6jcBC749F4orQQRsgL6MoQyM31Q3wVJCgj6V4tstCHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PHv//lCb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PHv//lCb"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675CHcSW3825244;
	Wed, 5 Aug 2026 12:29:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qL5lOqqnjOVPlCc7x
	N0xKMLDk9Trd8SmY5xN0b/iO2o=; b=PHv//lCbAVLqoMGp/AhXUPa9JVHH/6w3t
	/E4Yat9LZvTHNs8a703CZdzh8LqHyo8+18sz0YtkwdRNrVP3kM6pQUPV4csMkVWk
	Rnu+SN/Fg28HYkQgir0a5zGdUEt0jOpQXfDBO5Or7TGe0+euv7xuStnFWCeTsyUH
	kuVp3VN5e2pAIvfNdAvojyhXUmG+7t6hUDLBFG68ocWq53nPmjxGo+SE1myjGroi
	Y4kw1etVeR/hp0MEiNiTd8I2eKWpAASmS6lg6n1KLQlkzA5JWmqgFVlvV/QC9f+F
	AUJyEcHOiqiMF/WZyi9aSEWqD+S1itJ+GwW51a+5BwHXZyzKtGAmw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8h52yh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 12:28:59 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 675CQJAh019708;
	Wed, 5 Aug 2026 12:28:58 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsvmhedt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 12:28:58 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 675CSshG33554912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 12:28:54 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F27220043;
	Wed,  5 Aug 2026 12:28:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28E8E2004E;
	Wed,  5 Aug 2026 12:28:54 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.168.79])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 12:28:54 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v1 1/1] s390/crypto: Fix return code handling at skcipher_walk_done in PAES algorithms
Date: Wed,  5 Aug 2026 14:28:53 +0200
Message-ID: <20260805122853.9677-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260805122853.9677-1-freude@linux.ibm.com>
References: <20260805122853.9677-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA5OSBTYWx0ZWRfX+sVthSSTZ2Zu
 UfDMVeVjWtVO0IqIG+kVhGthAaQpE29H8jQ0PlCSIdakOm6qlK6j7JHMdfvb0RRf8/I3h4/pS5B
 ge02VyASc0mlt89MM4LFairJyzUIhS4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA5OSBTYWx0ZWRfX+lqYbzczpVwl
 91ZRfBkOe54q73A/d5JfD5Hz11zkmOIbbSxR5gTQAfGlZuM43JkTWMWx+RJutNhUhn5evTEGnMZ
 YjO9eRAe4UdZu6cM8XYmTg94+w3y8ZrywpoiGd99e/rq3nritUFFQjxqFAQmx9XDPjM98HU5vHj
 FL77i1prQj5UryEhY7cwcqYEXEuams7LiDqRb1F9/KI/76xZ8JTIesSy4LX8DqWpknVAPPr4Mmn
 NgX+cb4X94WV7u4ftS70QkGKxDdh59mQYMRhf71egV3+lmJEu0MLaBZNISglptVw8750sbwlETx
 GtVutNvxySXj4ip8XdsLqchF8a0P8vmx4VpWqCUhjRz6JdR5URQUjNuO7omHrvIbSEFGelYUZCt
 fVO3uaejG8ZPt4pRn2uWV8v+Cl+bmJDl2jrNUBO/0YE1QjUNQCya3ZCLuUow5n62ivMvusxYU6Y
 hCxP4oBiGoI+9C0VgfQ==
X-Authority-Analysis: v=2.4 cv=SI1ykuvH c=1 sm=1 tr=0 ts=6a732c8b cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=Zj0htMs1W2VmWBhMzgAA:9
X-Proofpoint-ORIG-GUID: 6rlDU644IIRkqRBz3XDwdSLsbwU5mTLt
X-Proofpoint-GUID: 6rlDU644IIRkqRBz3XDwdSLsbwU5mTLt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_04,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050099

All the 4 PAES cipher processing loops were not checking the return
value of skcipher_walk_done() immediately after calling it. This could
lead to error masking when both the walk operation failed and a
subsequent key conversion was needed (k < n condition).

Add immediate error checks after skcipher_walk_done() in all main
processing loops (ECB, CBC, CTR, XTS modes) to ensure walk errors are
properly propagated and not masked by subsequent operations.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
---
 arch/s390/crypto/paes_s390.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 973436592318..7e5cc39d4bda 100644
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
@@ -690,6 +693,8 @@ static int cbc_paes_do_crypt(struct s390_paes_ctx *ctx,
 		if (k) {
 			memcpy(walk->iv, param->iv, AES_BLOCK_SIZE);
 			rc = skcipher_walk_done(walk, nbytes - k);
+			if (rc)
+				goto out;
 		}
 		if (k < n) {
 			if (!maysleep) {
@@ -968,6 +973,11 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
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
@@ -1283,8 +1293,11 @@ static int xts_paes_do_crypt_fullkey(struct s390_pxts_ctx *ctx,
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
@@ -1377,8 +1390,11 @@ static int xts_paes_do_crypt_2keys(struct s390_pxts_ctx *ctx,
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
-- 
2.43.0

