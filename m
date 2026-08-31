Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97663D6CA3;
	Mon, 31 Aug 2026 08:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165532; cv=none; b=EdCxR+uqs2D5QSfNofbAV4F1vOZ29irXZn9XOZtLgIt1VMvqsNKYehIEpygsW8h+/jdMvVUjChBmBolemRjAYKU8fCClvhDUgaT7CZzqIWXGMEikk++2Y5ZiQQOcDVJ9KtHoqL6RSgqfq5SuNAdKu8Mcc9xdy/ZJfgLJucrRMlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165532; c=relaxed/simple;
	bh=nrE80P/WY39UbVUMXR5cge8lhF4EWqeIaOju8Rxk4lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwVKasLOT7IcvCHijE0oEoOqY3FqmneuVVb/cwHvCtzL8XUeH2sdzn8LElBCiNKInE/BGAwSvgaOFF4sJxfcc1b9j5zpShcHKsQpDr0DDYA3ksdU18eM/Q+XZEqOc+H5+PtBF6F9Agcq6L73GennHH/gBn2DdyGKO/kI15/3Bw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YvwIuV21; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YvwIuV21"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V82P111640487;
	Mon, 31 Aug 2026 08:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=SLcDAoa7w+IWs3JKK
	+c+ds+RtvMPzq5wmU39eICxttg=; b=YvwIuV21T4X17Ds4fRF1STOGrdwNLU6Gl
	9AGhCHElTSnzi54GQ8pGD0rQm3DHfmeo17Y7TZjdSSj3RlwPMwSUSt1jUt3Ko8/g
	RRIBObl05guCXGNtQ8u/ZeNZtHhKgHCXz3v8Ent+1lTmO/r3+qRcLySPQB0GIk8K
	QzR79nHaBtpoDXvyxnAKjbsfX2x0qDs0x5JCVcqaTCNhjOrDVnz547nLlpEQKBq4
	8NPtraH1MoYtHl4rGKuYQ2svaypB52TKVUjs/kls7wNLwdHunuST6wn4ZkDEBWqL
	kSOcnyLeq/beSJXfdUuA+Ybw7vcijXrvxP9vSI7Y5iruUmimCltYg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbpx584st-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:44 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QJ18004683;
	Mon, 31 Aug 2026 08:38:43 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gccexvn62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8cd4c42861026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:38:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B213520040;
	Mon, 31 Aug 2026 08:38:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E4F72004E;
	Mon, 31 Aug 2026 08:38:39 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.165.38])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Aug 2026 08:38:39 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v7 7/9] s390/crypto: Fix wrong return code to engine in asynch callbacks
Date: Mon, 31 Aug 2026 10:38:36 +0200
Message-ID: <20260831083838.3703-8-freude@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=PPc/P/qC c=1 sm=1 tr=0 ts=6a953d94 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=1dj2bPP-jMAkdeiF44cA:9
X-Proofpoint-GUID: GSOgTpBgB84Q-BGDLwBoRYFniqtYA15j
X-Proofpoint-ORIG-GUID: GSOgTpBgB84Q-BGDLwBoRYFniqtYA15j
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfXy2R3wDH0ai9p
 DaV2xEhupChfbf8LwpgfPd3JTd/tXI2mpoocJlNKyA8ZxbnQaTfpejDuds62tmMpJS29P8eR5as
 +YD0Q7hgBLkz7iFc88JmtZWIYKNRh0M=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX++i8+fr8ndpk
 do7tflJWlRC+hHj8PfHOZK2OPumcNKRXpOV/XKBhoS94cViguDwkftAlUpBxcKRtaox9eng4CkU
 NannALLO6mEqZJtw5bl4U4g+qFWjOJvOhbf0o1ShizkgYoLd7nSEEkCogMCSu1rdhryOZkbnWt3
 tkcQyfmgiRgzmRjVqq1ImSrsPIuJslj0y0NBaXtTaJUTHaOor7IdHbpeQKHatucgajuDmjNpNyk
 Vhj6z3J7V3Dmhc0SYMx57nmuFe8L7+eBWk4vC7L2uC+mgOC88xpvM91hnEjxbGm7Rj6TwgKBOcy
 4TD1qJhPv34kNWNEJACqxucGZsT8lw44krVl/BjmNuvENH/MHtT5/ywkzUzH77Xjzk7PCE8xBT4
 2c//aqeyw6c1r/ONSQxfmUm56+6N3NVAb4iW2mLxQxSJaHGtQHAfZJlt629aE00oitpq844FGxw
 gTTKpfvfTQWxDAbW/4A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310072

When crypto_finalize_hash_request() or
crypto_finalize_skcipher_request() explicitly completes a request, the
do_one_request callback must return 0 to indicate successful
handling. Returning a negative error code causes the crypto engine to
assume the driver failed to take ownership and triggers a second
completion via crypto_request_complete(), resulting in a double
completion. This pattern occurs in paes_s390.c 4 times and once in
phmac_s390.c.

Fixed in phmac_do_one_request() and all four paes do_one_request
callbacks (ecb, cbc, ctr, xts) by returning 0 after explicit
finalization instead of propagating the error code.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
---
 arch/s390/crypto/paes_s390.c  | 8 ++++----
 arch/s390/crypto/phmac_s390.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 1071a9d7dc07..bcaf1705e639 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -574,7 +574,7 @@ static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	atomic_dec(&ctx->via_engine_ctr);
 	crypto_finalize_skcipher_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 static struct skcipher_engine_alg ecb_paes_alg = {
@@ -846,7 +846,7 @@ static int cbc_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	atomic_dec(&ctx->via_engine_ctr);
 	crypto_finalize_skcipher_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 static struct skcipher_engine_alg cbc_paes_alg = {
@@ -1171,7 +1171,7 @@ static int ctr_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	atomic_dec(&ctx->via_engine_ctr);
 	crypto_finalize_skcipher_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 static struct skcipher_engine_alg ctr_paes_alg = {
@@ -1624,7 +1624,7 @@ static int xts_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	atomic_dec(&ctx->via_engine_ctr);
 	crypto_finalize_skcipher_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 static struct skcipher_engine_alg xts_paes_alg = {
diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 30c8a59af1a4..89c5fa3dced2 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -945,7 +945,7 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 	atomic_dec(&tfm_ctx->via_engine_ctr);
 	crypto_finalize_hash_request(engine, req, rc);
 	local_bh_enable();
-	return rc;
+	return 0;
 }
 
 #define S390_ASYNC_PHMAC_ALG(x)						\
-- 
2.43.0

