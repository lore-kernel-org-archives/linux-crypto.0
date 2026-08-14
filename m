Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61A63BCD17;
	Fri, 14 Aug 2026 14:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786717339; cv=none; b=nER9tJbUSwpDYxFdBFCon5fCUyxPA0NWkNFhQycjSe7WKuT/GpvCMZuwqbPOaUpqdoaZ49E2EOTxhNT8n2u6NPgctZgIBsr8PH0D7qcavOVDdx6Dl5e6dpjYkn7EMF2CPLpNrlCnIHYJfdM6dy/8IRhdzFMMGUeXMuZqO7HzJpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786717339; c=relaxed/simple;
	bh=KTU1mxyD/R1/sqdJYUr3yXKQtkPnp+aOlV0E0rY/jXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KW//d0v/AWNz4RQt3PoilTtmtyG21iZlb8MwbBNkhunScDfLt2ewiaKm+iCjNSLbKEan+hEIJv8lHqCXbG+M+0z5P458p9k0+1kB23wKdt7xBFzmtPzBpdMbsDGO1/oRfsabKNuOv2SFpm4yXpdg7Z8YQUyIkyT1xk24rqWsKWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ANRZFQ/P; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ANRZFQ/P"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EE5gku1342873;
	Fri, 14 Aug 2026 14:22:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=29u26kcdzNof9wdTL
	DEb9IDMvltO1Km9uc9J7aQM7Ts=; b=ANRZFQ/P9XOJKQHqwQj+s/GSJNag5KaSy
	hKC0aU953rGc+gTOLgW2tfz/AqGaUXOV92IfoxOKryg5lTbWIiZNQvT+NsTHXEFk
	X9rFMtKx586zs6QRDTIl/vKMD7Rhqs040apAIh9ow7PlXVamOWUovL4LB9SIyehI
	MChQ8mLX8VC/KjQeiyCuSCxIQH+4h7ShJIeFPPZyPpYQujAKpNslGI8CPsTcpfXy
	CnPrIy+qrSlKmLUtxWIWNo+C0+gqUr1k2Bfsv2wEjkOZHHqyvCxVwolSS+6tDsJR
	GiuSUgD3R67o0IakBNLijVJhubzn19sP0DzeRLVoiFS5W6tCevO/w==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvma58e4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 14:22:06 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67EEBjqY014731;
	Fri, 14 Aug 2026 14:22:05 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxg9hfhh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 14:22:05 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67EEM1Qe50528572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 14:22:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 787262004B;
	Fri, 14 Aug 2026 14:22:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5EB2320049;
	Fri, 14 Aug 2026 14:22:01 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.129.52])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 14:22:01 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v1 2/3] s390/crypto: Fix missing scrub of temp buffers with PAES algorithm
Date: Fri, 14 Aug 2026 16:21:59 +0200
Message-ID: <20260814142200.65821-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814142200.65821-1-freude@linux.ibm.com>
References: <20260814142200.65821-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDEwNyBTYWx0ZWRfX/TRRks9BhKmd
 J6tPf3s8M9ZgFSEzGKHTU+fb0Es4Y9iS8svKRB3OqLD9oCyHtwzfSmvKfusOfgpa6oBTcozOjeD
 GEpFSK+dk0vgqIp7ZVOoPKZYGV7sfcsEEVVnZ71Om+nYBw86qKrTemvZWrD9X1xnwe67QZTXdZ2
 Mfyb5p1wtUUkpGBFoySZeQ9BzYVrW3lZggVhwTTERYZ7LFDSkhB8rTn7+6Vyg6g1M5psCkjW8dD
 PHaqtHuVXSMNWLlLqXCQ9qF1yPkWyMxuqMEWPRccPTA/7r9gi58ZMZxLhUrgw5JDFR4h5NvFnut
 QR6Rd4993XQfHx6kUvMExPLoANSp6OOBVu7LYyojF6abZqoXFe2uMuSKLJiVlLIHdvutPqYXi7S
 k1h0UHB1CRH5ynedv6t2Y2ZvqE5uu+ezmU+HX7y3ztzdpzHE0d349oLMpSNf0BzPr7A00K8JYrZ
 Rv0R0Qqj14+3EnCYbwg==
X-Proofpoint-ORIG-GUID: LMKIso4WhmUavyyQO_y3deEuKmJEH40U
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDEwNyBTYWx0ZWRfX1n1JI8CB4oiO
 UhH+MwFQDc/Bc15uCM+/1RWMwgChRBQP0tSVcXyoTPP1ryJPHvAfTTmRbtt/2eUbG3HRTGXuaRT
 0zOBoLZKL08+z+WAnlu1zQwwqEp8zTM=
X-Authority-Analysis: v=2.4 cv=IfK3n2qa c=1 sm=1 tr=0 ts=6a7f248e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=VrNCSV0xjbOqwGpxUKQA:9
X-Proofpoint-GUID: LMKIso4WhmUavyyQO_y3deEuKmJEH40U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140107

In function ctr_paes_do_crypt() there is a buffer used to process
remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
thus could lead to expose of unwanted data. When the buffer is used
explicitly scrub it at the end of the code block to avoid exposure of
maybe sensitive data.

In function __xts_2keys_prep_param() change the existing scrub to
clean the whole param block instead of just the key field.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
---
 arch/s390/crypto/paes_s390.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index ccc7da106c3a..5a7dc4651885 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -1041,6 +1041,7 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 		memcpy(walk->dst.virt.addr, buf, nbytes);
 		crypto_inc(walk->iv, AES_BLOCK_SIZE);
 		rc = skcipher_walk_done(walk, 0);
+		memzero_explicit(buf, sizeof(buf));
 	}
 
 out:
@@ -1377,7 +1378,7 @@ static inline int __xts_2keys_prep_param(struct s390_pxts_ctx *ctx,
 		memcpy(param->init, pcc_param.xts, 16);
 	}
 
-	memzero_explicit(pcc_param.key, sizeof(pcc_param.key));
+	memzero_explicit(&pcc_param, sizeof(pcc_param));
 	return rc;
 }
 
-- 
2.43.0

