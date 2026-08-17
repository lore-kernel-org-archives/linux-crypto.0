Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509613F8709;
	Mon, 17 Aug 2026 10:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786963331; cv=none; b=mmqYsCX952lMs4BXlAZ4BK9w29SQiSxXkZ9xnQUsuikd9R11pshrnCnQ3E3gX2wY5ne2CnkWTvwFPSUILeXL9O89AjjkOSlrEV+CozkGRlRMql/As46kk0FSg7xx07+suYTYLmmKYRKUZL0f/j830q+o6XsTIaVnzUEkRPh2cYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786963331; c=relaxed/simple;
	bh=9QMvMa/mHrf/ByBeR9Cj+6fXiLo4jOsGK+ztbkdLleQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4TRZCAVTcIw/8ugUPmJekuDsvScfVGbHOQJvCZtQm514c9kGXHELw9WgE/HCAfM6yKAOtBi0U2MX4uibBcYly1n11FwKupIHv3fCizg+Fw6wI/FWgB6VAFP6MgeuCq5PsfBk58JqRHUqF4dAiqyEezcB8Yu180SQzb3xgyDglI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S8PHrIDL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S8PHrIDL"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GLViDI2629141;
	Mon, 17 Aug 2026 10:42:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Lwg08s9D9xnd8fwC7
	QWFv9u9lS9Cb15i3DZlzRAt3fs=; b=S8PHrIDLpS6Px6twkSUvAzyehqFuKTYb2
	9YU/Wxkc2YtAO2LGv6Ip0IeHNtK2AWzqkxbPlw1PEyssssoA8OGkWTlgi7q4kjxW
	fGMCH85c/ElKmxzzPeQDOOkwaQGYW5SBgj3P+Psmu2DTs2Gf9uBZWnA+vXtLhIMQ
	LHgoBolMfujFfKIA6tUn3Z0nLt8pc8j+uWZNk8KQ7+0qLMoIXd8foo4yrhUuyAHy
	8AnUYr3e4GWA34RrnS083bjuZrzdTCBfy+gPvwd+hcURaT6+xpfhxsAeFOJm7UQN
	/lw4qLFFVUhicUakClUnBf7HSWZ4q9nlABT3gnUoMNLgezKaLOgRA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2ehe1kv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 10:42:09 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HAfKK2013431;
	Mon, 17 Aug 2026 10:42:08 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g32tvws7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 10:42:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HAg4Vq31392214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 10:42:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83AB02004B;
	Mon, 17 Aug 2026 10:42:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5FCD020043;
	Mon, 17 Aug 2026 10:42:04 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.162.247])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 10:42:04 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 6/6] s390/crypto: Fix handling of EBUSY in PHMAC when req is pushed to crypto engine
Date: Mon, 17 Aug 2026 12:42:03 +0200
Message-ID: <20260817104203.74033-7-freude@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA3OCBTYWx0ZWRfXxZg3OPw/YKT5
 VI60Hzup+X7ZP4ACt6/PM8VGJ28n1dafQrut5WvPF3kJvYU6QXM9K/wfmFMf1ySWu0j2bP7xnyF
 rKty84xC1SEdNM/8+m/8begMGZPK8U7cFgpkM8kUqgdE6czDxIMtI4yN8Wv2PcIvv07INm/v3Xe
 Ji/EAWIiiHM7bKdoXcxQyf+PV8Y7aChyCF/xGHHNLvxwb5z4U8A0VwyrFcr+mRoRgKsbGXRhm/L
 t9XxTqKYO3whp2Tx6NAefB5+2/ciae3DS1ofL8RuOyxtk8076JHOGjJPOa5OswuaB7k9/O1jvhw
 B/XvCSnW/W2AGIwo4k2mZO28RqIAmU46gwD0iUo4CTUlbgyOLnVARZ0qYtYVr+9bCBs5o3x3wq+
 w0Ph6o2oR3MvVMrrn4AhFMAJlCBVlBRMY7iqnjgSwbO4YfFIbOokF9FO1NtZ6drZ7cFnr9RFUd6
 ORHMwSHbkLhSXsT/Lfw==
X-Authority-Analysis: v=2.4 cv=DY8nbPtW c=1 sm=1 tr=0 ts=6a82e581 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=B-V4zO6-lVdG3rMxPTUA:9
X-Proofpoint-ORIG-GUID: tBJiga-VoqiVQXVtAvKZD-WX8z5emMho
X-Proofpoint-GUID: tBJiga-VoqiVQXVtAvKZD-WX8z5emMho
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA3OCBTYWx0ZWRfX3E4eXOJlAmrE
 ZHK6CinhB3gwYHCC0XMctSAxAVjAP4VZkvycY2aw6V98yNJyCQD/87U648B9U4qomCodyhnBLQ/
 YzIWOSCIlpam/1XI6yGwJG5kdvSi5QM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170078

When a request is transferred to the engine via
crypto_transfer_hash_request_to_engine() there are two return codes
signaling a successful transfer: EINPROGRESS and EBUSY. However the
correct handling of EBUSY was missing and has been added as a return
code indicating a successful transfer to the crypto engine.

Fixes: cbbc675506cc ("crypto: s390 - New s390 specific protected key hash phmac")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.17+
---
 arch/s390/crypto/phmac_s390.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 03ca33ffe6cc..adf14553ad39 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -629,11 +629,11 @@ static int phmac_update(struct ahash_request *req)
 		req_ctx->async_op = OP_UPDATE;
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc != -EINPROGRESS && rc != -EBUSY)
 			atomic_dec(&tfm_ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS) {
+	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		hwh_advance(hwh, rc);
 		memzero_explicit(kmac_ctx, sizeof(*kmac_ctx));
 	}
@@ -667,12 +667,12 @@ static int phmac_final(struct ahash_request *req)
 		req_ctx->async_op = OP_FINAL;
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc != -EINPROGRESS && rc != -EBUSY)
 			atomic_dec(&tfm_ctx->via_engine_ctr);
 	}
 
 out:
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		memzero_explicit(kmac_ctx, sizeof(*kmac_ctx));
 	pr_debug("rc=%d\n", rc);
 	return rc;
@@ -716,15 +716,15 @@ static int phmac_finup(struct ahash_request *req)
 		/* req->async_op has been set to either OP_FINUP or OP_FINAL */
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc != -EINPROGRESS && rc != -EBUSY)
 			atomic_dec(&tfm_ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		hwh_advance(hwh, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && rc != -EBUSY)
 		memzero_explicit(kmac_ctx, sizeof(*kmac_ctx));
 	pr_debug("rc=%d\n", rc);
 	return rc;
-- 
2.43.0

