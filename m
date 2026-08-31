Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C1A3D3CE3;
	Mon, 31 Aug 2026 08:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165536; cv=none; b=ltbid17OWBsuI1sWviwSvZtsufw2NctlCcMwxj4fjauqmY9pRuPP0tHFeNh8bBQUFPc7QKsVSRE59J7yTQi53sHiwQFpHLjjK0i8AnybbqkyqE3/WSKMvKWNk48H6ZpsdLsk9H1gNJkZ/V6k+P8YZZl3su8kj8CbIPBK2uBcRkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165536; c=relaxed/simple;
	bh=8QEUVaEVZyThVXj+1LSvtsGgXSsslTmmM/sg/n/CcoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQJoorqByz9mO0WOYsChg5RsNu77Aiu+cCFhStARWwuIsTfq54UtPGWF6WmyHf2cI5+Ks37Is0K3dJ0/ocwHLiUeZaNkf2HUqGiueWNG5KGxyMtqiVswFimk8jqolPpLyTI/3u4nV3uZeuTJ0LVVoxfb/30BhEqSpLfIWuvqSas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fbpXTzmk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fbpXTzmk"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V82lG6512910;
	Mon, 31 Aug 2026 08:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=KZCJw/c/gT1C7R+84
	S7RMaay12eUV4wbEyMP/DTXZYY=; b=fbpXTzmkJSTlItHUkwxMFIW6Z7ZcRnx5M
	gQdHhejbj1a1vst83MzjRiMDO233Vd5LS1YpyBy24RHzCUuv3DzFmaHSJ4w1GFBF
	kGfaQQjDHoQQphP8mnOghE66wUxpz9MWCBgt5IRVXWK4F3TBmDW214Ov/scZQ6K9
	dGPqaoEMIDAClipqzdDAHBtBZe14s7dht4IjU8YdpcyRbWzinMnptAj93QTgeEDR
	0SsFa89My/wMOPJARSyLfsmeLSuxVUJXSf6MYx1DKCmB1rxMVqieD+tQu2qXzRmM
	JfVUN+7QPz5kdSuEBlpUbvFJevayN5HW/HkwD1OS/6VRYlsDmPKTg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbnudg4t6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:43 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QK0U024603;
	Mon, 31 Aug 2026 08:38:43 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gca4vvy19-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8cdaY41877930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:38:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3718D20040;
	Mon, 31 Aug 2026 08:38:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0EAB2004D;
	Mon, 31 Aug 2026 08:38:38 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.165.38])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Aug 2026 08:38:38 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v7 4/9] s390/crypto: Fix missing cra_flags in paes_s390
Date: Mon, 31 Aug 2026 10:38:33 +0200
Message-ID: <20260831083838.3703-5-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831083838.3703-1-freude@linux.ibm.com>
References: <20260831083838.3703-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4ovTOyccyXRsFhn3ZkTLbiPzfbFTWZfM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX/keIUyxkZxUf
 N5VvshePDrr4C5cyaAcWzQ5l33SxPFjAG/RBP7fBRGB7hnk2QbhIKFjRVN5LJ2lSjFqWSHh4iL8
 c3UcB078akxuQ/UnwI7zc9zXBOdBKyIovD0O2jhuxcJ4Z7/GdIYFDBEbDGSC8iezxM1Vx0Mjzf1
 hO7bGZdtHit4lJoT0m40OkxIAYX2xk7PPDeaM8PZI00EezgXc9a+KhHK3L6QLfanAxRHjrUOHk2
 //8quweMnWnKOjTAtR4V21s7fLRV8yTslM5CoEfry4OLUiARVZUT2Hi25XSPph45FZVEKvqufvz
 xUml3I5M2MPlKeNwmCemA87Y+m5tPCgic4NotVniW2QDefy4fIt8PqNjaeCFVZqYXqWzZwWWS9Q
 +fWKhvFmJcdpWFk/u5zemyMzm7SgGrXDJ09fZv7wISYlJNit4DmgnTfmz/EobAFXNPjzLYJVBOl
 pbG5Qo9xThmHh7o2gwA==
X-Proofpoint-ORIG-GUID: 4ovTOyccyXRsFhn3ZkTLbiPzfbFTWZfM
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX4QVOumBMkAUM
 S9cdCjutRe5hrbn1x9i9geIjC8RNWvMBHrnAGdfeNw/UKLjT+G8lUOxuwgK7iM/OnocsSMHVnsH
 dfpmPbltR+mYot29PrHKwNVhV/PMw7s=
X-Authority-Analysis: v=2.4 cv=B92JFutM c=1 sm=1 tr=0 ts=6a953d93 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=LGQ5mng98TkiZO--HCkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 clxscore=1015 suspectscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310072

The 4 algorithms implemented in paes_s390 never had any cra_flags
set. So add code which sets the cra_flag to CRYPTO_ALG_ASYNC and
CRYPTO_ALG_NO_FALLBACK.

Fixes: 4ccd065a69df ("crypto: ahash - Add support for drivers with no fallback")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.17+
---
 arch/s390/crypto/paes_s390.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 10d1c56a049d..9a20aebac6d1 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -579,6 +579,7 @@ static struct skcipher_engine_alg ecb_paes_alg = {
 		.base.cra_name	      = "ecb(paes)",
 		.base.cra_driver_name = "ecb-paes-s390",
 		.base.cra_priority    = 401,	/* combo: aes + ecb + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   = AES_BLOCK_SIZE,
 		.base.cra_ctxsize     = sizeof(struct s390_paes_ctx),
 		.base.cra_module      = THIS_MODULE,
@@ -847,6 +848,7 @@ static struct skcipher_engine_alg cbc_paes_alg = {
 		.base.cra_name	      = "cbc(paes)",
 		.base.cra_driver_name = "cbc-paes-s390",
 		.base.cra_priority    = 402,	/* cbc-paes-s390 + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   = AES_BLOCK_SIZE,
 		.base.cra_ctxsize     = sizeof(struct s390_paes_ctx),
 		.base.cra_module      = THIS_MODULE,
@@ -1168,6 +1170,7 @@ static struct skcipher_engine_alg ctr_paes_alg = {
 		.base.cra_name	      =	"ctr(paes)",
 		.base.cra_driver_name =	"ctr-paes-s390",
 		.base.cra_priority    =	402,	/* ecb-paes-s390 + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   =	1,
 		.base.cra_ctxsize     =	sizeof(struct s390_paes_ctx),
 		.base.cra_module      =	THIS_MODULE,
@@ -1617,6 +1620,7 @@ static struct skcipher_engine_alg xts_paes_alg = {
 		.base.cra_name	      =	"xts(paes)",
 		.base.cra_driver_name =	"xts-paes-s390",
 		.base.cra_priority    =	402,	/* ecb-paes-s390 + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   =	AES_BLOCK_SIZE,
 		.base.cra_ctxsize     =	sizeof(struct s390_pxts_ctx),
 		.base.cra_module      =	THIS_MODULE,
-- 
2.43.0

