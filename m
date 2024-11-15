Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6246D1CEE92;
	Fri, 15 Nov 2024 14:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731682357; cv=none; b=Hj+yq9kNF61kFvVzECrc+y4Ht0OXI5F/Pw9SROgcVZNar7sHxPKCujV14xHFWpvnXE+CKnRbM0vGPouFyuiHqXYGNYQVhWPw8Y9f43Urvcrn9VJNukwnL8hpnZeuuN3lLgk1SoWWcuHJojxDf0pS7Iq6ayeZVWuZ28MJEz0IXWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731682357; c=relaxed/simple;
	bh=HcRDTAQt784F6HXtvbTEYrL2Ax+mGjjUqslScqIg1ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRSYhXAf9A1ZqYkiBhpURGUAeQLGYqvl1drEc1hVsWvyek8yxiUfUpuVsQxVqLQKaatzBRvulckwyEom9xCxoOQC6myBnoaz8MrxxPcPLU8zV5a9gmdjPOredLzTaW66ngkUeyoJb0DYSdz7O5eHeTwop/2XixsDr668bgCho24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WDwZ0eS4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WDwZ0eS4"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFAYeul003851;
	Fri, 15 Nov 2024 14:47:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4RpvLuIzpZ7vreiHu
	RfsaXxPvgXmzzigTouDYZLHauo=; b=WDwZ0eS45vXcm7zOelXAWsAAt9b7bZScv
	Xde55czQhP2stxBMv6nw60rrOga/+wlGCayYvEphUYanQLmgxTxFPjkUwmPTc51s
	qveyEaAiNStjaijclOmEF3IvUti7pTLJnlKHLWbmSg8p8RQOe+6oDKFCSeCTQJT5
	SG5Zr3MlChS+zmgm346rENAYa34qunLk5YEkyzJkpG4cCq1XU9h35fNdOtgDVmrH
	fwlaspjR1V+P2hn7n/49gGxBn1uT7n5foQ99VHOZdwV0w4h0oQeXtpDpX7dBg9JD
	x3AT/5sS/1+5cgdFsFuPK/wV2ZRMEFjeGXCQvbSgxJpojWfRxzJnQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42wuy1kmxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 14:47:31 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFDu6C6029753;
	Fri, 15 Nov 2024 14:47:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42tkjmtm5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 14:47:29 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AFElQlO44827050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 14:47:26 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECEEF2005A;
	Fri, 15 Nov 2024 14:47:25 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A07502004E;
	Fri, 15 Nov 2024 14:47:25 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.73.203])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 15 Nov 2024 14:47:25 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v4 1/3] crypto: api - Adjust HASH_MAX_DESCSIZE for s390-phmac context
Date: Fri, 15 Nov 2024 15:47:22 +0100
Message-ID: <20241115144724.12146-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241115144724.12146-1-freude@linux.ibm.com>
References: <20241115144724.12146-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0oABm7dwCZ9_8-Q6x-NsOr1gNR2l-zRq
X-Proofpoint-GUID: 0oABm7dwCZ9_8-Q6x-NsOr1gNR2l-zRq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 clxscore=1015 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411150124

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

