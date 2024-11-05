Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626911D6DB9;
	Tue,  5 Nov 2024 14:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730815424; cv=none; b=tJhJdLcq330pCYrufr+zgQ/5DEDGAZCvpWHj/FKufjTFD1/lwBcgpMqsT2O9b1ISiWn5wfFa7fqtGMyaMDJsklUk3UhD33HD91MxSjVpvrCqYZaBwZh8n+GQ2DzbsCDl89pfFDigBLcPd0FVCNi8YFNosA5u5sKJP+GRjVg18Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730815424; c=relaxed/simple;
	bh=HcRDTAQt784F6HXtvbTEYrL2Ax+mGjjUqslScqIg1ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBSdg7M5v4RxKwOa6XPAEmlyP5J6HOHyEWsQFPf99kvVdfDJJx11eKunEe3HQDfQu4+eJehDBqXl7tjB4/byQIDg2C5RlSVOba3ye6NX/aH/p1x8s7jBtnLV+g6aYLmCNdvtG44kqtjEG2dh6yhu24GnAoltycooDDOb9z3CJHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Pe8X3vzs; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Pe8X3vzs"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5DehT3031826;
	Tue, 5 Nov 2024 13:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4RpvLuIzpZ7vreiHu
	RfsaXxPvgXmzzigTouDYZLHauo=; b=Pe8X3vzsuNDGTn+pTUNL7lKWogDHALJq8
	qhCpnv9VoqAWoLabMCW1xFFK51jnUv8ETUDOoW/zKbz6QBKsZYVr7zL+JFmTjLz5
	KVdkkquMTLAvW+0afVPVPeIFFJee4MDNf7i8RSpR3n5MEx/0zotpnv/ozbFO5uSb
	fv6I8+oUz2GoemSaZqdxlx8kKTxw40brh+rYOKhCbdfEawkf7tCd54ZQxWuvM41j
	uQq7iGH2W1CsV41JNMqnlQVp7w+vXDqWuodn54CscjVWAmu12c4nX3raSEnvVlPj
	m5VBKNo6kQtiK2NVHcsJS6Njwfaut/ymfOIGKX26jfrbhsiRT9v8A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42qmeu03h0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Nov 2024 13:58:38 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5DGiSG024261;
	Tue, 5 Nov 2024 13:58:37 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42nxsy90dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Nov 2024 13:58:37 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A5DwXEs34210460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Nov 2024 13:58:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C105720040;
	Tue,  5 Nov 2024 13:58:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B1F12004B;
	Tue,  5 Nov 2024 13:58:33 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.152.224.229])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Nov 2024 13:58:33 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v2 1/3] crypto: api - Adjust HASH_MAX_DESCSIZE for s390-phmac context
Date: Tue,  5 Nov 2024 14:58:30 +0100
Message-ID: <20241105135833.391957-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241105135833.391957-1-freude@linux.ibm.com>
References: <20241105135833.391957-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YR7u_FPBfjV0FymFSB3tGcokYW9yhuba
X-Proofpoint-ORIG-GUID: YR7u_FPBfjV0FymFSB3tGcokYW9yhuba
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411050105

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

