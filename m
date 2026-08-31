Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E903A3CF021;
	Mon, 31 Aug 2026 08:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165535; cv=none; b=lmQmnxI2smW5mh+mvhkhBbwGQrZSnlTzGcQYJOF4Ze7gv3YOC0Vu6ajMltV9QJO3LyS2tGPbYwkM9zvK+1q3+awYKX7PMU5kkmvjWbsxmr5rbQ6/R5egnWfHO1GGkUa9LhLYFi7xJJb9MMMSylAHMIpAOVlLSFWzz/u4j+UPC48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165535; c=relaxed/simple;
	bh=+33gNGwKE5Vfb81qF+s7VXNrNvdpmT3xAHiULICe3Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPIArafLG/cQF/CODNWVPeyy0N+Q+llA/R/pf6Ggk/V2QSIpqFtXGFDIzOHiG9EozZt+yBQEZTXZbms4ddMVToUgfuoquQY0XEtgJIQET2C0FfHUOp/9K/c7I/bDaiQbuVizURpYcTK2ugXB6kBXYjWweKSO0JRHq+iIbps4k7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Y2VObuSd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y2VObuSd"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V82Jmp1697520;
	Mon, 31 Aug 2026 08:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=o5aIIUYGN2Mc3/giK
	weSf0ePjWc+0yivRpqtaNNi1Rs=; b=Y2VObuSdJK9kNC2eHu0mFilBIWl+jeTwo
	++sjObXPwaI4QyLckEm7OxwD97ljLrLt8T+TK9SPnQCg0XQh+JZopLz+ezL4ZtQd
	L4b9NMdhBeoAqp9iftLCgCEER8NyDatsSN0NECuZs0A2O+k3HPSkRHCtnmofC8Yw
	yUc5QOsJnYOD8VSaOtz3TG63hiMHEJf2UcS99xyaHjL1JpK0/NWLg9Wjc9AxII3D
	8w9HWcUrGraIJ+6nCOFDo/nj73VEUyxX94u9MYvA8Mw6pzkDI9HQGxxn/WQwsYcX
	p5ibLHDHVnnVGJP8eCOgOUUoEEcO4r5z1/YpfCFsH21UtmVjeOzKg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq2syy28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:44 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QHSI024311;
	Mon, 31 Aug 2026 08:38:43 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcb8h4t1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8cdpY46465432
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:38:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89DF020043;
	Mon, 31 Aug 2026 08:38:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6693220040;
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
Subject: [PATCH v7 6/9] s390/crypto: Fix handling of EBUSY in PHMAC when req is pushed to crypto engine
Date: Mon, 31 Aug 2026 10:38:35 +0200
Message-ID: <20260831083838.3703-7-freude@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=bc1bluPB c=1 sm=1 tr=0 ts=6a953d94 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=qxvTYN98PGHahdRChkcA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfXzRvex3zC21wz
 h9xm3USXGs7LdKYp5vEbDfRjmf/z1Q/Rqz7uXo5kbI6IlAZgRHZ9e+vfxEVydKXyxU9IELE6vI7
 Kn6CCksOyzvF9njIxW62uV32HVSaxQU=
X-Proofpoint-ORIG-GUID: lKR2DRu5MWyxjWxggW-avV93cPf91R2q
X-Proofpoint-GUID: lKR2DRu5MWyxjWxggW-avV93cPf91R2q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX5y2ApZbSDchF
 zUmIeVsLWdLeGusbqtAsm3ZH0vvbP+J5kkiSjArBm5zgB9pc3Jhqk+q5YEyHLvcJGlTNIEl75TQ
 0mGe3/fwz/Jor6IX9PuiPTIGldgzeEUqcD/MPbxdrNr+QxLNP3LCO7jydGzXZnmC+D4VSKsEc0Q
 gUscxovMRzzYhfXLnH3TIIpoH89QV3bE1JtpUqo0bSaz8/WhUS/kNCu8riPP96ROm0r8CQ2LKcU
 qXF303HwPjjjIdcyHnba/8AIkxFtP3BpN614GJrfhCjuGDDhiaDxKDxmoDTi7p+QOEiAkT1mHyX
 CsTNANEI8fwfi2IUttKRPBeAwrts7nyTg2Coi7kG45NSF97d1gg2VZStUsXlWjs/Mwky5JvQ24O
 ZMb069zLVa53WVN1hgUKltM2z+5Z3wPwCxB5zS3SIPV2czCJ7SegC4Gx5i1IebqSeY81Yont3k+
 pK5Mv98XofTlsSVpTUQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310072

When a request is transferred to the engine via
crypto_transfer_hash_request_to_engine() there are two return codes
signaling a successful transfer: EINPROGRESS and EBUSY. However the
correct handling of EBUSY was missing and has been added as a return
code indicating a successful transfer to the crypto engine.

Fixes: cbbc675506cc ("crypto: s390 - New s390 specific protected key hash phmac")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.17+
---
 arch/s390/crypto/phmac_s390.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 03ca33ffe6cc..30c8a59af1a4 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -62,8 +62,10 @@ static inline int hwh_prepare(struct ahash_request *req,
  */
 static inline int hwh_advance(struct hash_walk_helper *hwh, int n)
 {
-	if (n < 0)
+	if (n < 0) {
+		hwh->walkbytes = n;
 		return crypto_hash_walk_done(&hwh->walk, n);
+	}
 
 	hwh->walkbytes -= n;
 	hwh->walkaddr += n;
@@ -606,6 +608,7 @@ static int phmac_update(struct ahash_request *req)
 	struct phmac_tfm_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
 	struct kmac_sha2_ctx *kmac_ctx = &req_ctx->kmac_ctx;
 	struct hash_walk_helper *hwh = &req_ctx->hwh;
+	bool cleanup = true;
 	int rc;
 
 	/* prep the walk in the request context */
@@ -629,12 +632,15 @@ static int phmac_update(struct ahash_request *req)
 		req_ctx->async_op = OP_UPDATE;
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&tfm_ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS) {
-		hwh_advance(hwh, rc);
+	if (cleanup) {
+		if (hwh->walkbytes > 0)
+			hwh_advance(hwh, rc);
 		memzero_explicit(kmac_ctx, sizeof(*kmac_ctx));
 	}
 
@@ -649,6 +655,7 @@ static int phmac_final(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct phmac_tfm_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
 	struct kmac_sha2_ctx *kmac_ctx = &req_ctx->kmac_ctx;
+	bool cleanup = true;
 	int rc = 0;
 
 	/* Try synchronous operation if no active engine usage */
@@ -667,12 +674,14 @@ static int phmac_final(struct ahash_request *req)
 		req_ctx->async_op = OP_FINAL;
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&tfm_ctx->via_engine_ctr);
 	}
 
 out:
-	if (rc != -EINPROGRESS)
+	if (cleanup)
 		memzero_explicit(kmac_ctx, sizeof(*kmac_ctx));
 	pr_debug("rc=%d\n", rc);
 	return rc;
@@ -685,6 +694,7 @@ static int phmac_finup(struct ahash_request *req)
 	struct phmac_tfm_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
 	struct kmac_sha2_ctx *kmac_ctx = &req_ctx->kmac_ctx;
 	struct hash_walk_helper *hwh = &req_ctx->hwh;
+	bool cleanup = true;
 	int rc;
 
 	/* prep the walk in the request context */
@@ -716,15 +726,17 @@ static int phmac_finup(struct ahash_request *req)
 		/* req->async_op has been set to either OP_FINUP or OP_FINAL */
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&tfm_ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (cleanup && hwh->walkbytes > 0)
 		hwh_advance(hwh, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (cleanup)
 		memzero_explicit(kmac_ctx, sizeof(*kmac_ctx));
 	pr_debug("rc=%d\n", rc);
 	return rc;
-- 
2.43.0

