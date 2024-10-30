Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45821213120
	for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 16:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730305667; cv=none; b=rRYk2LI1dJOfaKJOalfvyhWFFueDGwJY4Y1mbHQLyrKV7vImWC5HmjDqXtb7kYtzbZ7pnKk7rVfdl/NFW+PgoDPjoHjROsThpIPALQuP57N3FIpy5wykisawrcPpJ4NSN19dUU945RJzbbXKjYA7ZU1MT9/IlyJEX0MgpUGpKCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730305667; c=relaxed/simple;
	bh=gH4dIYL4smVNrIm8Pdjp4brdNjsA/oQnwMKxP2RFcZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zg9zwrTbmDqbNwvbF0hAHo+d59/ZMhtjwjveH2thh0TsrzNgRIo1mZ2UlCrYLCbtEVl2PTx62E1tTz+L/Sa2zWP87wm83C2+9vESApavGrAUBFja5ehDp7r1dcw/jJq1k/T4f0AM9nIsm6CyuJCrivCs/Qf9jLNz886GKI2lUQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G2fhZqFJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G2fhZqFJ"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UDw5Zk027181;
	Wed, 30 Oct 2024 16:22:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=l5r3kwngCMWGn5ldS
	oa+J014Fb6wpHm1WsLP5AH2/fU=; b=G2fhZqFJlwG4Qafr3zcrHIoIxli8uQHd7
	jLjLajL9EJtmNp0biIoV8gEmnXZgptPn+NsWeGXyCA0MxWrGgfhKZfm1V5gG5Hfl
	yynSrfiWOI8AWij4eQ6n6H5LA4P+I7r/c9KElfTaqUaJxZeIU4ah4rUQbI96N6Bq
	F1pdSFlYaH4MTcG4i/zK9MtO+JMdzEox1LxnQEZFqU0zdB3hinuLAAnhLt+wBjvr
	8dMoDxAZtddvJmKmYvSS7hkOSz5tadi3HfaocXKGL9kgEaDcebkBced3qve2/O98
	QY+pemMUsSuttY7/e1ajj0uBJSMcQl+692su4g4HLgxlY5AI7k0tg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j43g882q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 16:22:41 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49UCjOR3024716;
	Wed, 30 Oct 2024 16:22:40 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42hcyjgj3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 16:22:40 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49UGMauW22020406
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 16:22:36 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC19C20040;
	Wed, 30 Oct 2024 16:22:36 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52E8E20043;
	Wed, 30 Oct 2024 16:22:36 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.179.18.237])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Oct 2024 16:22:36 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com
Cc: linux390-list@tuxmaker.boeblingen.de.ibm.com, linux-crypto@vger.kernel.org
Subject: [PATCH v1 1/3] crypto: api - Adjust HASH_MAX_DESCSIZE for phmac context on s390
Date: Wed, 30 Oct 2024 17:22:33 +0100
Message-ID: <20241030162235.363533-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241030162235.363533-1-freude@linux.ibm.com>
References: <20241030162235.363533-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FRO6EOxUHrwcfOQlmgURtLkwJ5n_e2Rs
X-Proofpoint-ORIG-GUID: FRO6EOxUHrwcfOQlmgURtLkwJ5n_e2Rs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1011
 adultscore=0 mlxscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410300123

From: Holger Dengler <dengler@linux.ibm.com>

The phmac context exceeds the generic "worst case".
Change this define to cover the s390 "worst case" but
only for arch s390 build.

Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 include/crypto/hash.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 2d5ea9f9ff43..92f878270a87 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -158,11 +158,18 @@ struct shash_desc {
 
 #define HASH_MAX_DIGESTSIZE	 64
 
+#ifdef CONFIG_S390
+/*
+ * The descsize for phmac on s390 exceeds the generic "worst case".
+ */
+#define HASH_MAX_DESCSIZE	384
+#else
 /*
  * Worst case is hmac(sha3-224-generic).  Its context is a nested 'shash_desc'
  * containing a 'struct sha3_state'.
  */
 #define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 360)
+#endif
 
 #define SHASH_DESC_ON_STACK(shash, ctx)					     \
 	char __##shash##_desc[sizeof(struct shash_desc) + HASH_MAX_DESCSIZE] \
-- 
2.43.0

