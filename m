Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D04935C683;
	Fri, 14 Aug 2026 14:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786717239; cv=none; b=EW2j2DRGqjBpvKA0cZfCqst1ac1ZLr3H0ReRwcK+Us/XN1ARww0pMdHR2gX06Qt0nkPPTYaErl8arXm5PAa6iYtL1A0nW2vup3iTYjN6j2Exw3Dd53XH9tJ2k09vPn9k9ZIcTd9c79gjFmKhgfrnKDpNtlsOrdJC1oWKyDTnNqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786717239; c=relaxed/simple;
	bh=9TaXT0TGFb4E48im/77qDXEc7Egz0lt6eTH60qW+RYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHSwSU0O46tI1gGPpIBpjtV8HtfnxP4fC+9H5xlJ515ba1QpGXmxNGNh4wb81XdJnYqwR+BPU9eorgjEzOPXE1tWbW1k/K+gmjmKEYgz5OMUSwxKSFlKmttZ0GwdayaFz7TI4hB9n7hWGYKHoum5qD1FGJB80IaFqdGtYQSea4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=msn7grBA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="msn7grBA"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EE5jOL1370431;
	Fri, 14 Aug 2026 14:20:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=SIZ2QJMuuroOTH9O+
	zJYJyVm1b+8IY+AoHh4qontoOU=; b=msn7grBAm8dLcmYCAp1Rb7xJbKI/NXnDW
	0DTr6his+e7BdbQ+5BMrkGYCAQbxGSLbk5TUqOykcV5J0TQoFH7bFZbI3INbMhhE
	Hwzo9/fksTh5eOtbqkQXjueXwKv+pa4iky7sJKCK7NkDavTMk6oYu8LEC1JG/+Qe
	oXHGIZR8/Gt6D53vrGZuDCbmEYnWX+FFY7FW4Tdjp6LjmrjcR7grtNhQXW3VofDW
	S/HpZBb4Zu1IGKv+qvFmsmDlDxIPwYlx4pED/aOsYCQmrHLH01V1u1FtdWaadR8V
	blAXrJwiqm8i+XCh0A9wpa85n8clHF4vB/CIjs5TOLL0ZSU0ujbJw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvnwm01p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 14:20:16 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67EDuO9Z012860;
	Fri, 14 Aug 2026 14:20:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxh0gqfgs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 14:20:15 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67EEKCFs40436070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 14:20:12 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 120822004F;
	Fri, 14 Aug 2026 14:20:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B1022005A;
	Fri, 14 Aug 2026 14:20:11 +0000 (GMT)
Received: from ibm.com (unknown [9.111.74.75])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 14:20:11 +0000 (GMT)
From: Holger Dengler <dengler@linux.ibm.com>
To: Harald Freudenberger <freude@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: dengler@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        ifranzki@linux.ibm.com
Subject: [PATCH v1 1/1] s390/crypto: Generate intermediate CV for API partial block handling
Date: Fri, 14 Aug 2026 16:20:10 +0200
Message-ID: <20260814142010.259918-2-dengler@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814142010.259918-1-dengler@linux.ibm.com>
References: <20260814142010.259918-1-dengler@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=RsP16imK c=1 sm=1 tr=0 ts=6a7f2420 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=EzrveUIq3cTPK2vlegIA:9
X-Proofpoint-GUID: PBfmAq86EmmKmOmYO82l4occ9fWQYBvs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDEwNyBTYWx0ZWRfX83GlV5+YvjPT
 kij7Yh/f11dI7kmUQ/eBwyPxw4e4Cp3KFXJFCxOr4PiJfSutpwjRRHhC1sV8mW0wA9xJlRBcHQW
 yOb16cXaOFRF3ULeCMt9eL9hAaLmohZV0qnjEg4+jbb8serK6hKgt6uhkUidz3QNsD6qFxxDZCq
 APLIX9tzGtjs8TOUBIGKFrFCX3BVYlSjNNBLLoKw+cQXrGp+e2/icPcorLkIIVp7KfqrkT2+vI7
 3E/XciRpaRZgZkJ7BkS7cWRmkb2+CWOOyahaGoXuS8F7Zdwy3hnVbeMwU6LhyoQsEXnl9YH0EpU
 cfJ0Yrzl3XVCCB+pbnOUzV9EmdU4tIveC+lzE7G1LQ5TltujSQlIHT5BFQir96kRPdPojlvV1rs
 cYsxEd7cqMmSZR5vkFg4K6n0zPENNaYtqy2EJiNXh3o1Ay94LTcgO/eq58D9adXjLLAp2q1yfi9
 +h01C6/g20sOpsIMzIw==
X-Proofpoint-ORIG-GUID: PBfmAq86EmmKmOmYO82l4occ9fWQYBvs
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDEwNyBTYWx0ZWRfX/bYHJVW4LBnD
 lNelSE3tmHpadoeslZIcEDSY3HpgG5PRId92yL+q30+0/Xe/iJFCLt3T4qA6fCVLBiOV4PN3D+0
 5XXIjoLsR7YXELT+iTybtQXyDWkAWpI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140107

The API partial block handling requires a intermediate chaining
value (CV). The internal function hash_data() sets the function code
correctly, so also call cpacf_kimd() instruction for intermediate CV
generation, as cpacf_klmd() always generate the final hash value.

Cc: stable@vger.kernel.org # 6.15+
Fixes: 08811169ac01 ("crypto: s390/hmac - Use API partial block handling")
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
---
 arch/s390/crypto/hmac_s390.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/crypto/hmac_s390.c b/arch/s390/crypto/hmac_s390.c
index f8cd09f341d4..445fa7bbd958 100644
--- a/arch/s390/crypto/hmac_s390.c
+++ b/arch/s390/crypto/hmac_s390.c
@@ -150,7 +150,10 @@ static int hash_data(const u8 *in, unsigned int inlen,
 
 #undef PARAM_INIT
 
-	cpacf_klmd(func, &param, in, inlen);
+	if (final)
+		cpacf_klmd(func, &param, in, inlen);
+	else
+		cpacf_kimd(func, &param, in, inlen);
 
 	memcpy(digest, &param, digestsize);
 
-- 
2.55.0

