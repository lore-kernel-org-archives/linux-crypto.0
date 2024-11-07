Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20061DFDB8;
	Thu,  7 Nov 2024 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730991332; cv=none; b=ehiNCZ0Q2y/cWt27hKnb4QV3qapAgSxOGEDahprOPQSZ/raYRpuEA9G151DQayqu4xVqI/38vcp6Ge+bIAxj/278K7+/Jjk2CnOT6k8MwN8yN9P5f2Q7txGJxQlA15UzKnMoZB2EaeQH48B9ICev9lAHycRyWkP42a4MIhE16wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730991332; c=relaxed/simple;
	bh=HcRDTAQt784F6HXtvbTEYrL2Ax+mGjjUqslScqIg1ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTNH0oJwAXod3EYglYcqvCiKDmmFtmYet61pXcyAMAJhYvLGPU6ulu8a1YE1V0QfoD2DDtXqwkB1LBmAQxWpD9fruRyQ+pQ4PSDqgIJY3Tb3hO8r9bxJY+6IYySMZnuEGBTvbbBgHLE6RcrArsx+qeEF10ri4vFh/rBnzVOhrXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QekwZVCw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QekwZVCw"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7EeHA6027762;
	Thu, 7 Nov 2024 14:55:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4RpvLuIzpZ7vreiHu
	RfsaXxPvgXmzzigTouDYZLHauo=; b=QekwZVCwuVGjEaHAckUt63yi/k/r8bEVF
	3ZWhcjQsBRRd3n0ak0QwSiO2d/KLiUXo9W2M6olsspdLE6eD579b+tHnKhXa1ioq
	6wbeMy/Js6p7Nen8rMQemwyoh4fP7tfSmT4zHdgzou/Ui1hXyKLs1ilDige9b+5K
	hQ3v5xA1wiim8MrlXoXrfNgVjY52YrExakFOhw/oxr34Ejp/H4eq8lufrON4nLB4
	v1+o4UYknbOsqA6k+x5Of/1zUegkks+o5KUsaIIqGIkKGfX8aeaGIu0YZrEg+yJk
	kgXvrcoWgheSvbdVVrv0cdnk297/+HshW1hJEh1JDNye8++zaGqqA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42rygs82d5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 14:55:28 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7EVanS023983;
	Thu, 7 Nov 2024 14:55:26 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42nxsyyrph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 14:55:26 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A7EtMXi50725226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Nov 2024 14:55:22 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F0312004F;
	Thu,  7 Nov 2024 14:55:22 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 372EE20040;
	Thu,  7 Nov 2024 14:55:22 +0000 (GMT)
Received: from funtu2.boeblingen.de.ibm.com (unknown [9.152.224.229])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Nov 2024 14:55:22 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v3 1/3] crypto: api - Adjust HASH_MAX_DESCSIZE for s390-phmac context
Date: Thu,  7 Nov 2024 15:55:19 +0100
Message-ID: <20241107145521.424769-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241107145521.424769-1-freude@linux.ibm.com>
References: <20241107145521.424769-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: obR9Rbs8O6Vqx3eXu0etN5hB8c1Ob0eF
X-Proofpoint-GUID: obR9Rbs8O6Vqx3eXu0etN5hB8c1Ob0eF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2411070114

From: Holger Dengler <dengler@linux.ibm.com>

The phmac context exceeds the generic "worst case".
Change this define to cover the s390 specific 'phmac(sha512)'
which is a "protected" key hmac-sha2 implementation.

Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 include/crypto/hash.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 2d5ea9f9ff43..5b724dd7c5a7 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -159,10 +159,9 @@ struct shash_desc {
 #define HASH_MAX_DIGESTSIZE	 64
 
 /*
- * Worst case is hmac(sha3-224-generic).  Its context is a nested 'shash_desc'
- * containing a 'struct sha3_state'.
+ * The max case is currently the s390 specific shash 'phmac(sha512)'.
  */
-#define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 360)
+#define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 376)
 
 #define SHASH_DESC_ON_STACK(shash, ctx)					     \
 	char __##shash##_desc[sizeof(struct shash_desc) + HASH_MAX_DESCSIZE] \
-- 
2.43.0

