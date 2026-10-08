Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F0B44838A;
	Thu,  8 Oct 2026 10:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791456773; cv=none; b=Hh3jZv2PXgOorSmN7whieJg7RSxYPkBv4m2RFA4IagD3PWJ5GkcwueaCgyWIoYwJ80ZBHiDJxqB4Zw1pYZONMgLuFyD6/hcUJ32zBudrpMNDgCNX3UTAK9DxR4lxICKS7UklHutV3tyV2CFGkhnpLAPjFEejq1OdXVHpuDkWRI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791456773; c=relaxed/simple;
	bh=pevulhAuJXl+PpU53FSYuwRVDw9ICSRdwmFmilBYCJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aH4xCBzJSKYHXYW1paTT0ebu342nNAdqVp7Kg9T9i48Bd4CxzOmwrjJpWsjmCx3RS6tM9g/bz9ogfj8uv0Dal1DEao/X2CLYgGHSy9qZ5vXqOjPExhnfMekYV8L50k+dgWIITaohAamGslG7OPpo2hgqXxWlQu1IE3+iTU1f4vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qgFf/HZS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qgFf/HZS"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698Acmut4082570;
	Thu, 8 Oct 2026 10:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=dhinvxJ8K6n5BaA7Z
	VxWxm3NRui3YYboljiFboAr1bI=; b=qgFf/HZSpvQcVhYbLyCvx3Yotxk3yh9gH
	8EsS0uHtaCI3SxXII3bhUv9X2rbDeL+nKR+eFwLcwfbB0pOHttUlK81dxVhXo+4T
	Mg9jO8/L3ENO3s4otbkLkdQZ65KlKsQlSID+FzoZ2TiFe7zWoOcv+/6l8hr/m/Mw
	zsPI8WmwsugmyiwJY1/hAgeBELTmkmDs7gIqFIjAdN0oXkrAjG6I0atkoxZ91f+2
	j/9FsDv8pEAGwSPVuaAjyWHw/8EIjMcI698aG4VCsDm2FUo8LgfOVNWajn34UsOc
	bdD0LXfC6RL+YW1UXpZtM5R/PjbAYDO1f1WJ/FL8dYoAygGmJHR9A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xk1at9j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 10:52:48 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 698AlahI3379019;
	Thu, 8 Oct 2026 10:52:47 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h5a6dppyh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 10:52:47 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 698AqhDw48431378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Oct 2026 10:52:43 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BEB0120043;
	Thu,  8 Oct 2026 10:52:43 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 871022005A;
	Thu,  8 Oct 2026 10:52:43 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.224.94.37])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Oct 2026 10:52:43 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 2/2] s390/crypto: Handle cpacf_kma() return code
Date: Thu,  8 Oct 2026 12:52:42 +0200
Message-ID: <20261008105242.20730-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008105242.20730-1-freude@linux.ibm.com>
References: <20261008105242.20730-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=YtCa1IYX c=1 sm=1 tr=0 ts=6ac77600 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=_ealZ5zhq6rR3i9ucnoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MiBTYWx0ZWRfX0l+7kavtW11M
 6JnVhgChx+eu3y0hP7vbd59tSWCpBLAtfK5warTwiPUZac4iu7gaOsWJ2do08Lrr3EnDAxr2x5x
 M+E5oFdZHDmuf3fL8psmSurXxmROB3jv9vr8S07sNWgSa8TMXWEQaF3Wjd3ILZZjqayNpUyrPAo
 GJWMw3lRtcNqwQGKGpeOjUUYWxNFu+j1e+ocd1NT0qu3tNaW15Erjrtrjr8YCnEfbfOcckgLdAb
 MY1GwBe6IYCahfAkCmQ20fqCKLVwODQ4ygZtsNJ7K/od1bdsASKS3yyw2zxx88htx8obZEcqu5f
 nXhKFfXUnI1lyWWtcvbPI9YkaKjJa7KDbnRgxirimrLxjEMhIdnVnBc5rtg7II8Kj/EA0nHfcNA
 5ixgvLdpM6zx/aCp0glix7GIRNDBDrDyxA0fJ3HxiCjbV7Oo0xjM1gvCCeeaA2svUdiPQctsbYO
 fqSwTqtyEclzAKqGoiQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MiBTYWx0ZWRfX2Zc5EumEU6wS
 V+qJkUD0Oeh9bMl1Y76SJRRmWraKikEvsSLw/6F6vJxipafpw0ZqU+By7gcLAY3ZKYJMbFjhC8R
 tUK0XoC4+CLQaO646SQisQnHrBWRnEw=
X-Proofpoint-GUID: s-yq1mkwl_JCmuYU30dLqw-lFdwuQRXT
X-Proofpoint-ORIG-GUID: s-yq1mkwl_JCmuYU30dLqw-lFdwuQRXT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080042

Now that cpacf_kma() returns the condition code, check it and bail out
with -EIO on any non-zero result. In practice CC 1 and CC 2 cannot
occur: the GCM function codes are clear-key only, and the scatterwalk
loop ensures block-aligned chunks with LAAD/LPC set on the final call.
However, it is a defensive improvement, not a bug fix.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
---
 arch/s390/crypto/aes_s390.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 62edc66d5478..0e35cca35914 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -889,10 +889,13 @@ static int gcm_aes_crypt(struct aead_request *req, unsigned int flags)
 		if (aad_bytes > 0)
 			memcpy(gw_out.ptr, gw_in.ptr, aad_bytes);
 
-		cpacf_kma(ctx->fc | flags, &param,
-			  gw_out.ptr + aad_bytes,
-			  gw_in.ptr + aad_bytes, pc_bytes,
-			  gw_in.ptr, aad_bytes);
+		if (cpacf_kma(ctx->fc | flags, &param,
+			      gw_out.ptr + aad_bytes,
+			      gw_in.ptr + aad_bytes, pc_bytes,
+			      gw_in.ptr, aad_bytes)) {
+			ret = -EIO;
+			goto out;
+		}
 
 		n = aad_bytes + pc_bytes;
 		if (gcm_in_walk_done(&gw_in, n) != n)
-- 
2.43.0

