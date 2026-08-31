Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523212DB7B8;
	Mon, 31 Aug 2026 08:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165472; cv=none; b=aAApzZme4nKIio+C3yA9FnzXetQZ0Tl4sMP2AvBqKxGlpZ+RLAGHRAyOLHW3kvQNonLOi36sFQ39W16G1R/RuEGAys+couSgomB5E1tDI55FQY1EmrD8mCoy1AZsXQyZ/mlCkv0w0asVCg+SR04wMHBaNNYQ8bvA19LUPlbfX2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165472; c=relaxed/simple;
	bh=t7uRIekhHvXa8X5hCDhAeHrb9IBDcbEto6cSe1tuvIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/PJnPNvMJY3Nubmi7bKh5NhxRC0gfBl7BXYVs2RSCdxSf0hJXHBYw0bx30K4Z4+CgPVxCIGiWjc52/Qwa6z2diCtGAUK2l6JQ2qvPPO6ocp3NK06YNR2qK2zw07mPl2uVVdDC1C9lx8YDeuux40rtEfWuS1uhYiV7Y8M/5T3sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WsNiHgjh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WsNiHgjh"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V82Lul1697687;
	Mon, 31 Aug 2026 08:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=slY6Gi6tSmVr5p5pS
	i/jPpBJjojEF23u448vIqnc9iU=; b=WsNiHgjhV4CIo7nAfP3QTfDpwkXMl4zTl
	GPDYzOU+T7dWaL3XdHXud7Dqo5QI2/IM9eXtyZ3llGTfniwqgFNZTHqujGgWr6ug
	gtrqbGAUZ4E+nGjmyy1oYQa17pqcrbAcuh/4+Iu1GeqatE9gOyzZ4hFbGVuyhI3d
	5QDZcf4f17hntyAWK9/DXGw/hfER3ClS82I0C75JgGlV9hEBCCgvvqdXbVH638s6
	0l7RfAmxH8xWm4Hxfw84pj1AG4sMMWu0YGze00efAtYem5DdJy5huMdOHjr5Skfo
	er0Qf8DRWyQg/9yvEKdyoFnFo1KdLusY1aW/uLsmVq3PcuumSJNvA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq2syxxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:37:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QHWX009954;
	Mon, 31 Aug 2026 08:37:40 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcarjvvgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:37:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8baqD46596552
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:37:36 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10B712004D;
	Mon, 31 Aug 2026 08:37:36 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E59E62005A;
	Mon, 31 Aug 2026 08:37:35 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.165.38])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Aug 2026 08:37:35 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v5 2/3] s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm algorithm
Date: Mon, 31 Aug 2026 10:37:34 +0200
Message-ID: <20260831083735.3625-4-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831083735.3625-1-freude@linux.ibm.com>
References: <20260831083735.3625-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=bc1bluPB c=1 sm=1 tr=0 ts=6a953d54 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=GcIFfetOeEmlFWxA1S4A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX/taOYSTZzzaK
 KSo1kDOP2A/3z48TqVtlPkykgPD8P4ZNcEx7J++pDXKAfJGQ52loTIpJ/IVHHfmj/cBw3xyU8+V
 ngjkr/24XYHPvEdGP/YeFP6q/bYuFdM=
X-Proofpoint-ORIG-GUID: dYzm_gE9szwISSFdDzu8cSVxLhRknSEc
X-Proofpoint-GUID: dYzm_gE9szwISSFdDzu8cSVxLhRknSEc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX3JThsPcrXtHF
 Gz7gHgxPqNtiR/MPZnHZxFewNHFDxc59m0vBVL0vv5gdhwV8Te/unD5M0FapSIG31xGS4AUihG0
 5dYZsS5+YmI6W2ha5dStGDWL4ODy0CeAwENmsGjZxQJtudqpLyinhaEICCdb49zAejng01AJS9U
 mLfRq3GQgR1uw0+6+NHVy3Fz0eXdESRtIlt3JeNO+zr9IqZ5CLU48X5DnYXdX7REiWWM0uZKdy0
 XoYj/tCj53UnXUYPfJptaL8t47fj8UMYST9sbVj41N2B5DMarDwwsoby3QsqXKFWvMPf+iGv6OS
 FEQpuQ0z0eVG1vcM0ZhR2OnOhSAtBLEG/jZOVKL5vshi3X/MdXI+1mnRMAyXYhtT+/Lk7ervEGS
 YHKNJi8HKNk3qLZVjvZDiG8fxFCo3SxLwY5acMcO2DTu6prjQE3neHRMtozTp2h2ECjybu36Le2
 gMxrPIv+qQ+tPh4BRPw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310072

In function ctr_aes_crypt() there is a buffer used to process
remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
thus could lead to expose of unwanted data. When the buffer is used
explicitly scrub it at the end of the code block to avoid exposure of
maybe sensitive data.

In a similar way the function gcm_aes_crypt() hat an error path where
the CPACF param block was not scrubbed. Instead of return early now
these error paths go to end of function where explicit scrubbing is
done. Similar with the buffers which are part of the gcm_sg_walk
structs from the variables gw_in and gw_out.

Fixes: d07f951903fa ("crypto: s390/aes - Fix buffer overread in CTR mode")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.8+
---
 arch/s390/crypto/aes_s390.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 366ce22d3623..10561aa687c7 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -604,6 +604,7 @@ static int ctr_aes_crypt(struct skcipher_request *req)
 		memcpy(walk.dst.virt.addr, buf, nbytes);
 		crypto_inc(walk.iv, AES_BLOCK_SIZE);
 		ret = skcipher_walk_done(&walk, 0);
+		memzero_explicit(buf, sizeof(buf));
 	}
 
 	return ret;
@@ -895,10 +896,14 @@ static int gcm_aes_crypt(struct aead_request *req, unsigned int flags)
 			  gw_in.ptr, aad_bytes);
 
 		n = aad_bytes + pc_bytes;
-		if (gcm_in_walk_done(&gw_in, n) != n)
-			return -ENOMEM;
-		if (gcm_out_walk_done(&gw_out, n) != n)
-			return -ENOMEM;
+		if (gcm_in_walk_done(&gw_in, n) != n) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		if (gcm_out_walk_done(&gw_out, n) != n) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		aadlen -= aad_bytes;
 		pclen -= pc_bytes;
 	} while (aadlen + pclen > 0);
@@ -910,7 +915,10 @@ static int gcm_aes_crypt(struct aead_request *req, unsigned int flags)
 	} else
 		scatterwalk_map_and_copy(param.t, req->dst, len, taglen, 1);
 
+out:
 	memzero_explicit(&param, sizeof(param));
+	memzero_explicit(gw_in.buf, sizeof(gw_in.buf));
+	memzero_explicit(gw_out.buf, sizeof(gw_out.buf));
 	return ret;
 }
 
-- 
2.43.0

