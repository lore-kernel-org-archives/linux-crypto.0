Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70127422E25;
	Thu,  6 Aug 2026 08:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006199; cv=none; b=pDyS8xrDK2F+5IGGXHvFiYtI8l9Yut6Peyeyx1rJyZMiBgGJ0L6BqWuS5xvWrp+B9D3pqA/GT58LZ3H+choio/NAJhogx6lWUmBzmG2hHOHV59nOScyFTTzBem4MT3DcIBOrLSEO+61lqhrpQ1jyqoejG2a+lLbJJGd9DPkQY5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006199; c=relaxed/simple;
	bh=Krp5naZrw0hoJMPKA2Ta8jq/sej9oFxl0+iO+e/747g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwuvvhI2ZDTexbY+aWdjx2QGVK2i268bTDrby8k241mI9nvudw3l/YY1C+L3C8TvQXQEE9NO0zwS6JIX3Fsebk8puTHSYlCYPxr5tfHPHSFjWSyQ0zPl66XmBDfJwAIvV+DNaPd9KxymbvTx/CNZKS/PCTC9tPG9FNLnE7oC+Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UR0n7bOQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UR0n7bOQ"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675NltKX993845;
	Thu, 6 Aug 2026 08:49:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=l2QdY9RjCnDQLrLSK
	Mpk9jKXQ1KITu7sW6Hrp52u9/k=; b=UR0n7bOQSIF2QD+STz6TCj4l5NjqLxy1f
	R4WApKTiJtMa7g0mR2h0tAv4IGnn7DKDTit9aik05YnNUvi78CXBmdOTr9PS8PDR
	yt7SNk+dQJ9gomYQkw8e8Yxf1kYXUC2H+5kpq1dEACvQR0hCj7KRjf94xjV7/HDy
	rir3zZ/GUwGn3oCBW/Y/F+9eJqn9y/JHTrJI16HIIek93lAQtwJtkgx/PNQXV0of
	PDevHqw3cIhPB7zgM2Zb/Dj0CU7tBLGpM7668G8cInpfV4x15X4kmimx2tRRhmFu
	Hwo8UKzlXJhyFp9Az0THegcHydeSimFlxwobXMIaZI3gMEa3eCaOQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs67hxyq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 08:49:56 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6768fnTY002673;
	Thu, 6 Aug 2026 08:49:55 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswtyt6ta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 08:49:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6768npIq47710628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Aug 2026 08:49:51 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 769E920040;
	Thu,  6 Aug 2026 08:49:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 30EF72004D;
	Thu,  6 Aug 2026 08:49:51 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.145.185])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Aug 2026 08:49:51 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 2/2] s390/crypto: Explicit scrub temp buffer in AES ctr mode algorithm
Date: Thu,  6 Aug 2026 10:49:50 +0200
Message-ID: <20260806084950.17679-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806084950.17679-1-freude@linux.ibm.com>
References: <20260806084950.17679-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA2OCBTYWx0ZWRfX7ulM4YcufbKm
 guBgWU9nnw4SyeuBd70FQb85HVKLeskCt3pD9UbvPr/sq9qx7gjJUenQPxjI4p4V/cx/ojkGjZp
 16VEoVj5CQn4KwxpUcWEVhUVheC5Qco=
X-Authority-Analysis: v=2.4 cv=I7VVgtgg c=1 sm=1 tr=0 ts=6a744ab4 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=neRvl6_ouhKq_gAUosgA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA2OCBTYWx0ZWRfX6IAgIUUr0hyU
 OZ+roaTMEofTYmh+AgBJ5RVIDzWvVAxXyRn/ewWJ0HmWmzwPu6cyDUqVeVm2RtCAQXm5d1iDYg8
 QmXgLU+g2G1nbn/gDR6pyOPg4xwSvovA377yzUdyy0gPQ4Wdt4WAhbAeLE4AyLdrGh4rvDQQtGd
 LkKfRr1f0rB2T/NHYqLLv5zQTDkeZEpL1S0J5lgNRzQxaJU3Pbvpbg6cY+jqX2Mx8OFU53D0QNP
 srSpasqfn0fuz9ASzy2JDARJDg/nL60/+/gGxG/CYel/RyI84RQpjb6uDpAQxICPtJAi/SPCoOD
 Ry4hb5U89AUME250EH8M7cfXI+KVwss8GQZh8V0rHgR9itgTDuP54Ml+tFu2YIT5Qpjrg4Evhhe
 mk9/0BdIzjxtM2HYV2lYP5fQY39//4fuZheJWb8GW4paUtd9n+leWTJiwF+pS7LvBfYcIdIactZ
 ajKHddqHQQt7Ovjcaug==
X-Proofpoint-ORIG-GUID: nr2Amv27krXOjk5iOC41ynP96NhXAQqQ
X-Proofpoint-GUID: nr2Amv27krXOjk5iOC41ynP96NhXAQqQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060068

In function ctr_aes_crypt() there is a buffer used to process
remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
thus could lead to expose of unwanted data.

When the buffer is used explicitly scrub it at the end of the code
block to avoid exposure of maybe sensitive data.

Fixes: d07f951903fa ("crypto: s390/aes - Fix buffer overread in CTR mode")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.8+
---
 arch/s390/crypto/aes_s390.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 366ce22d3623..f52c612ae9cb 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -604,6 +604,7 @@ static int ctr_aes_crypt(struct skcipher_request *req)
 		memcpy(walk.dst.virt.addr, buf, nbytes);
 		crypto_inc(walk.iv, AES_BLOCK_SIZE);
 		ret = skcipher_walk_done(&walk, 0);
+		memzero_explicit(buf, sizeof(buf));
 	}
 
 	return ret;
-- 
2.43.0

