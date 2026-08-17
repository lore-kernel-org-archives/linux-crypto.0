Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773FB44239E;
	Mon, 17 Aug 2026 14:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976223; cv=none; b=U/AuzN3NAF9pKvDwo824kX+rVoHP8ps8rwn8UzPeHB2cfP+SNuo4YtqesmH23q4Ke8bCppWrIcQt+zqy5xHC1COsogoFsqFmYjlNGtWfeoeCCfjSe2WwHf5pbigMwZlOXKtf/eCXx3HKcVgAYiqnbcRgXMw8hbU8+4HewwNIMOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976223; c=relaxed/simple;
	bh=viIm1mCSm961/qq0FjooHRM5t9Zcas0s8L8bLKVafD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VC2bQA6UTWJ5Y32y71oEJqDa8kh/FtrcMrTrG/moDNDosIrvhUDQ+Z6jfNTPFtvB+lje5ZePbBPIkQR3vuzZE6rx9wTIf2pljDEsRsk72xJ9ZWu6csqGaVG79/PvKAKOpCbepU7dQJoMUJct0gW5vGhPR/9i2sTldhemKVNhMjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YOFd5GH2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YOFd5GH2"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HCVqrW287928;
	Mon, 17 Aug 2026 14:17:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=GA39shm5IYF4+kYnz
	Nx17fm2gCTgbso2Vq4wCYWZPI4=; b=YOFd5GH2CFz82DVWwtbLW2HGXakrlj4yY
	46fZ8hrNbebGFPihsVw2ZGCGEUjB3LlGtifjjiGLB+/xoakXp0jzxaswllvKS8sU
	05jd+O1FFr9xzc6VxR+N7+4VWfO3NqBUDkctyd81wTZJqk5TScjXxSNVuPqIHttN
	Uz+DFKwEk/NuVeW930Fm2nKTjrqIyL1KGeTrCc2Zd2QGsNTQgs4txATIkQmZKpqB
	qX+eXiTRq9rFB8EATHgq2uCSXuiU8XpJGGOQkAnlVGukczCTvvDIqHUcEbdgTqRe
	94j0ExCcVQ8F7IbUw0KGzg5Of9xqRydEypJP1Hsf0tjI6EtV5/jWA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2ehe2ewj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:17:00 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HEBO1K032233;
	Mon, 17 Aug 2026 14:16:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g354y636a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:16:59 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HEGtoO51184052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 14:16:55 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E75B2004B;
	Mon, 17 Aug 2026 14:16:55 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CDD220040;
	Mon, 17 Aug 2026 14:16:55 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.162.247])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 14:16:55 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 6/6] s390/crypto: Fix handling of EBUSY in PHMAC when req is pushed to crypto engine
Date: Mon, 17 Aug 2026 16:16:54 +0200
Message-ID: <20260817141654.77940-7-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260817141654.77940-1-freude@linux.ibm.com>
References: <20260817141654.77940-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDEwNyBTYWx0ZWRfX3mRFmnbka2ub
 5xZtTWlQkAf43q1AyKQIKNfqpuNVbGGSHT3alDxq1D+sguogpklh6ihmdUaAFz0N21mCabl64zo
 JE3q4MrFOncIUs4XKrhm5QcKmLpaOOObuIWsgizeDx5d+iUc3skLSMUV5kIKFOcEm4r/vPRZ02q
 PaT+1l96J8fJ86Qhx+2PghhM0Bt2VMUj3NY6ZCYlGMbXLoPhiv6Unt1D/d8aFA+3sNb9f6feD1V
 IOrwwAbmuOyYcBkVi6Nv1dcpfU2RpV/K7YsKBAK2jEYfXmJ/DPOryGThcZ3NjyPSUPeoIR6fMwl
 zEdMxcmXJfbSNnUNIcGWWoVwqNDD3B/AbRoHhQe7LP9jK5esmdbT4OGxF2g/eC4kNM0tBk//2L/
 vqviRtwyWLFMognW4d3nJ8WiRyhzhbLvgXCJO42axvd5SwYC+AH3lT7v1/Zpxkm9QBYY0rhljbK
 VhrBXySPqYlImlSLf1g==
X-Authority-Analysis: v=2.4 cv=DY8nbPtW c=1 sm=1 tr=0 ts=6a8317dc cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=owEb1khIhW2YEDzqnSIA:9
X-Proofpoint-ORIG-GUID: 2IVIqAG1wnAjZ77sfqnWo-DvGpvgV5dt
X-Proofpoint-GUID: 2IVIqAG1wnAjZ77sfqnWo-DvGpvgV5dt
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDEwNyBTYWx0ZWRfXwwrLE+7lXghF
 Wlc8k1wKcIjI0Ci0GD0RE9apv9jaOLT8FdBqtPu0bTT2+6KDmEWu1PFDvffBxPwvwubcV8lTCYy
 739ROJHY0zKOzHwylTn0uooDmQhbIUY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170107

When a request is transferred to the engine via
crypto_transfer_hash_request_to_engine() there are two return codes
signaling a successful transfer: EINPROGRESS and EBUSY. However the
correct handling of EBUSY was missing and has been added as a return
code indicating a successful transfer to the crypto engine.

Fixes: cbbc675506cc ("crypto: s390 - New s390 specific protected key hash phmac")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.17+
---
 arch/s390/crypto/phmac_s390.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 03ca33ffe6cc..9d77198b22ff 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -629,6 +629,8 @@ static int phmac_update(struct ahash_request *req)
 		req_ctx->async_op = OP_UPDATE;
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
+		if (rc == -EBUSY)
+			rc = -EINPROGRESS;
 		if (rc != -EINPROGRESS)
 			atomic_dec(&tfm_ctx->via_engine_ctr);
 	}
@@ -667,6 +669,8 @@ static int phmac_final(struct ahash_request *req)
 		req_ctx->async_op = OP_FINAL;
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
+		if (rc == -EBUSY)
+			rc = -EINPROGRESS;
 		if (rc != -EINPROGRESS)
 			atomic_dec(&tfm_ctx->via_engine_ctr);
 	}
@@ -716,6 +720,8 @@ static int phmac_finup(struct ahash_request *req)
 		/* req->async_op has been set to either OP_FINUP or OP_FINAL */
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
+		if (rc == -EBUSY)
+			rc = -EINPROGRESS;
 		if (rc != -EINPROGRESS)
 			atomic_dec(&tfm_ctx->via_engine_ctr);
 	}
-- 
2.43.0

