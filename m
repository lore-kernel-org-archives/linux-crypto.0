Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395303F86F9;
	Mon, 17 Aug 2026 10:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786963331; cv=none; b=PbnZRwDjwzRvBWclR1iBFBc1qeebgV/ac8Wxyvop2VS7gaAvwdLCGtFqpqLzim/Hv5rQ5xdOsHdklQWjm4J+wp1Hp9THkrlWcVPP3Hl6s2sy+LxN8xr8LiE1wxYAHsvah+z1qtqgqRns0p+YcINYJvwb2HWNkeWD+nAN2D3iDC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786963331; c=relaxed/simple;
	bh=cdyzfu8JsQ8OKkyZMmK1XPYbOu6ge2Ro8gF0flXyikI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbQJ2TWtRDFmqnCst+xbp7QU0VOI93ZXbXAt4fCNhPJ/hEiElhKCR0mtWwD+OTJ5sp9bG2aRMYSqnlanm23Kpv61ARJn/dMq27Dne5eJv8N55C+uRigrsEhOj5B+RJ0SApoQfrlD14Qb2BsYWx1+TqSV779hYzdrpJ5Sai3CHe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nkpIvWUD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nkpIvWUD"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GLVr1i3780595;
	Mon, 17 Aug 2026 10:42:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=TOjCOUltd8N4eJE7i
	bAuetwCBVITtHctakNAeAnZjoU=; b=nkpIvWUDO2ejKmEdpmOAp43fEhsFreB5m
	Ly3QMdW3Fj9qWU4ydi1OGj+kwR3AxNOTE40L5IacWYBf0Zq133auJh0VA7z5rHzu
	8mDX/OmAAa8WggfxMZgT2Xt9vNFsClaULjOyGDnFUU6E6bd/2iZi5MvYhnT3y18w
	4G5VYqaDLs31appfTbR9ZWmy+GFej3xNn5vmYpxufoTXfcyF0opQwWkSBG83q65z
	C9tkAGTlLIqO6/atpvXO+Shewv4dqJeSnfIOPaYc899sQYS3lIgnw0+gfOZEstnz
	6JKghpV2LNkX23Vu/BM7hHPh4G4/6Z2KGGwKUEumEkcrAUhfOtpmQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2frt1eeg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 10:42:08 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HAfJFC010081;
	Mon, 17 Aug 2026 10:42:08 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33xgwm5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 10:42:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HAg49N31392210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 10:42:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DD382004B;
	Mon, 17 Aug 2026 10:42:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 09C5920043;
	Mon, 17 Aug 2026 10:42:04 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.162.247])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 10:42:03 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 4/6] s390/crypto: Fix missing cra_flags in paes_s390
Date: Mon, 17 Aug 2026 12:42:01 +0200
Message-ID: <20260817104203.74033-5-freude@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=OfaoyBTY c=1 sm=1 tr=0 ts=6a82e580 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=LGQ5mng98TkiZO--HCkA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA3OCBTYWx0ZWRfX93zBnnubDYyt
 zlV1rD18pkWWGUvvM8WpGIXdgymtZ8JJXbPa9BvOwfqfB+t0zsmBWnkTR5g/2gSoT7uqJirs6CI
 d+SQLKiBXJAAR2sCFabMwWjtgoblaOo=
X-Proofpoint-GUID: Epd8a8fEN2zVAQYA6UWqlHPTPrgMep4i
X-Proofpoint-ORIG-GUID: Epd8a8fEN2zVAQYA6UWqlHPTPrgMep4i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA3OCBTYWx0ZWRfX515jZ6DXT/0X
 FlHv4HGioTNcVM+AhYn11kGGkhN7WESneG7mTaY/nXl09/YCOVNdsaTjhSaejvJLyjk0W3Tz9DH
 1RQ0hpoQs70++wBpLYtDIYdyR1wZOvjoLgiY+D6PNCwLj+UQNEFVTRneHcWRc7SE0uY3sK17dMh
 T3Hl6Q6IQh0TtBQAbtDF4K/zvEKdpftRLuJEkNG+zIYspzIkGUP/3rOzXwTWN5u0Y8p5yZTv6ih
 D1zcPRHRP9RP1ZrLIumOsNS+oGAL6Cmp1+eyxJ7f2qHKmzLmgcH4dk0OOREr/MF3fzB07mOqtv7
 kts42x4J7rUWp85DcPsQ2C1qAylUVa+2g9MTQ1BvikZ1YDqAXOs9LI/zOgyb66lrVj3oXVhkwFh
 lTVErG1QdpAw5ILzehwJCIZckNg1G3EkGUkKxZ0r9lkpXAwSTvUhFwpQjhDseBTvfq7XHPiK7eK
 rdHvQCwtIKUNzPR+pVQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170078

The 4 algorithms implemented in paes_s390 never had any cra_flags
set. So add code which sets the cra_flag to CRYPTO_ALG_ASYNC and
CRYPTO_ALG_NO_FALLBACK.

Fixes: 4ccd065a69df ("crypto: ahash - Add support for drivers with no fallback")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.17+
---
 arch/s390/crypto/paes_s390.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index e8bbfc376ebb..03446bfac37f 100644
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
@@ -1162,6 +1164,7 @@ static struct skcipher_engine_alg ctr_paes_alg = {
 		.base.cra_name	      =	"ctr(paes)",
 		.base.cra_driver_name =	"ctr-paes-s390",
 		.base.cra_priority    =	402,	/* ecb-paes-s390 + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   =	1,
 		.base.cra_ctxsize     =	sizeof(struct s390_paes_ctx),
 		.base.cra_module      =	THIS_MODULE,
@@ -1611,6 +1614,7 @@ static struct skcipher_engine_alg xts_paes_alg = {
 		.base.cra_name	      =	"xts(paes)",
 		.base.cra_driver_name =	"xts-paes-s390",
 		.base.cra_priority    =	402,	/* ecb-paes-s390 + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   =	AES_BLOCK_SIZE,
 		.base.cra_ctxsize     =	sizeof(struct s390_pxts_ctx),
 		.base.cra_module      =	THIS_MODULE,
-- 
2.43.0

