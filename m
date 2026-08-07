Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61FD312807;
	Fri,  7 Aug 2026 13:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786110900; cv=none; b=mTKJPf1TXS9K2BDnLcbiJI4NZGrdnnnDLelpVqctr54IUAWuZMFTivGIpH1HNKqSL/WC3QVENW2JYGiNUlS7MQ6te6XdeppL2VT6jHw8vrB0z0Mj9IMGdRV3IJ31l4L6Q+kAzvZ4XH9oTbntE9JUrrKGd6Sl6qx4jemKdbhkyeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786110900; c=relaxed/simple;
	bh=5fPeMVE6IVnGcdRVMtJLlYev/QGDP0OqfZXlXyfjxIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QV7KiIHIZY1/Vnfnw1uH0aF4GTBL/nr0WwL6sIjP1a7kSW+WhzprO0jhjPfvucb68AZ7j8X+VA8wJ8aijS1PTwyhSjxxlWzX3an4s2bL/niq2yxe00Hpfzepkworquyph+IlC2VEKlFxKkClboczCLbeY4Am33xxSKKah9sDSn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GQrrQh+m; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GQrrQh+m"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 677Clgxv1485129;
	Fri, 7 Aug 2026 13:54:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+xGHYC+fGkdNvY7mb
	nVy5rIe2YrBb4bVudcw6Mgd5/c=; b=GQrrQh+mRooSUy37gju+o+q/w+6QKwjko
	m9wY5jFA2m7OrhmXRz4dZGVAi9VrOga78qdLsnj7BH41PInTtTcKj3GQOWSVNsMj
	wMLH6Lcc2S3wCNyRmBCW1IjkjrjEn5zycCOlmEl/eSPCb1i6fhya2dJduCffeGjE
	WfZ44OR7TRjWFTUOgSF209Ef+t+ht2wTTEdDy4zwY9YVOYj8J99fDeaCgWfZRWX3
	U4I8Xoa7uC4ktSkmguIsTnDfH0AxQJGPNU5Eefq6ErbXYgpB5ET6z765VThekLON
	sJ2CxBWGwOiq7jMurBNEalQkHcaoYVU0Uu1l1VzPvKq+hfYpXa2fA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fvy04464v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 13:54:46 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 677DfICO024686;
	Fri, 7 Aug 2026 13:54:45 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsv4kfxnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 13:54:45 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 677Dsf8130867938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Aug 2026 13:54:41 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55F1320040;
	Fri,  7 Aug 2026 13:54:41 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3CC9320063;
	Fri,  7 Aug 2026 13:54:41 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.146.84])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  7 Aug 2026 13:54:41 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 2/3] s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm algorithm
Date: Fri,  7 Aug 2026 15:54:39 +0200
Message-ID: <20260807135440.35888-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260807135440.35888-1-freude@linux.ibm.com>
References: <20260807135440.35888-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDEwOCBTYWx0ZWRfX8MnglMA9S06d
 M788PSqno64dyn0YGsqtcUJtovBirDV1z9xTlCfg0O7PmF3byQESqh4SoBywyivnFb3fmKsn9vW
 ZaYG5gCT6tM7SdouVy7kLNkdUvsjLX4awQcePR5Rc1TemCByj6PwscRxBkJ2GlFrJ3dXBEcllHG
 AfchvJWghsiuZrm6DeQUqUAAGmDT21kzxDX7nL81cetjgsGWeVE/g2Pt4nQ3mKsRWBsEBEFpJ9P
 NyMz/y1JnzloEnABo26WAhs25MgaxGw6LMuyHWRtNFw0jZU2X3V6VVHh8+oYrbrjcD0vNb7Jzod
 rUvjLbYeqqgrXO71wpo0g9WW2jeamZwtdVTeyTVI7+CWbIPJLIyodlE5H/lCI93EvFGParYb+Z8
 YloBo+8wMOpPv94pqkELNVhI2IUEWd6WqlqYDV+adSqbIQZ2wJTN6S4zulahuS9a4RWesTP3a9v
 94qbXSO0FFdoM23H6BQ==
X-Proofpoint-ORIG-GUID: 4_DrnaZHERhX6yRlvB3iyZpcY5BPEgLc
X-Proofpoint-GUID: 4_DrnaZHERhX6yRlvB3iyZpcY5BPEgLc
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDEwOCBTYWx0ZWRfX6KdvTJ+EXPpO
 QGEwqs8YMijMu6p47dFLOsPutsif0X90dhRTlpRM94mgFWONjmXNrSRjjkcD2D3UDe5+hQxrAQO
 F44YKL8z7cULZ0gIjknVH269H5xQvoc=
X-Authority-Analysis: v=2.4 cv=WLpPmHsR c=1 sm=1 tr=0 ts=6a75e3a6 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=VrNCSV0xjbOqwGpxUKQA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 phishscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070108

In function ctr_aes_crypt() there is a buffer used to process
remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
thus could lead to expose of unwanted data. When the buffer is used
explicitly scrub it at the end of the code block to avoid exposure of
maybe sensitive data.

In a similar way the function gcm_aes_crypt() hat an error path where
the CPACF param block was not scrubbed. Instead of return early now
these error paths go to end of function where explicit scrubbing is
done.

Fixes: d07f951903fa ("crypto: s390/aes - Fix buffer overread in CTR mode")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.8+
---
 arch/s390/crypto/aes_s390.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 366ce22d3623..976f6f7257d5 100644
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
@@ -910,6 +915,7 @@ static int gcm_aes_crypt(struct aead_request *req, unsigned int flags)
 	} else
 		scatterwalk_map_and_copy(param.t, req->dst, len, taglen, 1);
 
+out:
 	memzero_explicit(&param, sizeof(param));
 	return ret;
 }
-- 
2.43.0

