Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDA71E0DB2;
	Fri, 22 Nov 2024 14:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732286078; cv=none; b=GSPhIhepD9lG1LZS5Y2kjZ1MFbqh6Mh6kXEgEDnrGn+c8417obWdu5A93C/QW44UszgMm8vj45e2ndDldLDQSFZH04nMUeN8/ZImet1LGIpcZKBaW65xVPToUHk54ODkErrMg4A1bFZYvgJuGMqyz8Xv0r0gLESvVq6nn4UNqVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732286078; c=relaxed/simple;
	bh=HcRDTAQt784F6HXtvbTEYrL2Ax+mGjjUqslScqIg1ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqAq50lswcEiA6kz08OzH1tw2br/bzAz9TwwKHH0dvu/emFUNLbSsIrOKklTXYkkDjXGUPLT5NiPs8ZheZ0GxUBd35jDhkEXnfLjzTTf6ID6j1GcRD6oqtFFF9cMFUaozn9k+rU1eW7EBj0lewXOsn7rXL8I1qVF9k0NA+D0CiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oWB95GY2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oWB95GY2"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AMCR7Zw019014;
	Fri, 22 Nov 2024 14:34:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4RpvLuIzpZ7vreiHu
	RfsaXxPvgXmzzigTouDYZLHauo=; b=oWB95GY2HjXTJopWSjtn7DhEJUq7PQNa3
	Y6C3yH+YKyGEz/hlUXrlL5r+CpYF6zY8J0S8VWEwMAmmDGl4sEvXeujEPPk8Qd2n
	80xjboALG0Y/EANaPhxzFjE5gMlzzmqdS08NCqMbXq6Zbf0rGoC62bW3jwoHLNVy
	s50Ebdcs9vIjv9GAb6XnnSNLyuB+J7jtKm4NiNASuZLbIcs1ergtCKeiv38eLVin
	BxwouCGoZLSHdm2p2X46x10F0KtvGH9UaJCKsR/iSrhbYmpgtClgwsQ22uH/MxaH
	D13bEh7UE323mvSilYmo2K2OhXyqRS72flFf6LZnhWyzbn2XecVMQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42xk21hcag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 14:34:31 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AMBtrZd024618;
	Fri, 22 Nov 2024 14:34:30 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42y8e1k4yy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 14:34:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AMEYSOg63177130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Nov 2024 14:34:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9FF720043;
	Fri, 22 Nov 2024 14:34:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 772C82004F;
	Fri, 22 Nov 2024 14:34:28 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.82.52])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 22 Nov 2024 14:34:28 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v5 1/3] crypto: api - Adjust HASH_MAX_DESCSIZE for s390-phmac context
Date: Fri, 22 Nov 2024 15:34:25 +0100
Message-ID: <20241122143427.135682-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241122143427.135682-1-freude@linux.ibm.com>
References: <20241122143427.135682-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bYgb3fZlTHS25mc1TMb7bg9F4DbMxPuP
X-Proofpoint-GUID: bYgb3fZlTHS25mc1TMb7bg9F4DbMxPuP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411220122

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

