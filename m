Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADA85474C;
	Wed, 15 Jan 2025 16:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736958161; cv=none; b=eXTwELL/A+2NymDLy/r9bflhFzPVh1RJov4EvWKSACnLHUQFG3t0AarSLQ7cztGd6ky+zXmX2/Yj7HP7ZVfU/H6PlA2cCmg1KlmaGlQQI74HMqZAqT0nmo+6xa5RpaiiW7EluwGhPYNsGpfeA+LrarTLQI64Ia/uvvhsGkeUDmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736958161; c=relaxed/simple;
	bh=+WwJ8F6ZFB+Y70Rh+IBXqJkbTupGeGbqbv7vhgoQdc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REsT8ofN3Ntnxa/t7V71LjvuFw9G+32Qc5bRZs9htPwbVYM/3pArxpcv4n+0+zfEiT/dL760mLtM3v/vljUx0sbyQOojFsitfhUW6wxO1SbcMf5Lm1zQ5TGNwho/ApaVcVv/QXF5i9Y5CtuoM8qPdnelrTwaWXftudYiXV0NFH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WgdQmKbv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WgdQmKbv"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FGK8LU031748;
	Wed, 15 Jan 2025 16:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=04ZoER5a9xXXtppa1
	hsb1VYkbpO6YQBoFgrNvXDygSQ=; b=WgdQmKbvZTNu6Ff+6BvJJ00COW+7NsK36
	3q5z4jVituLCbST05K5UfUubj3Bc8YHhIamvyt7d074Ax/4dY4h+qwBNRjqmBFXc
	bC088yp6iMHSx1KEAkRXUwJJclIrsaxg/VCpkRcKwhRYVarvfMokwrQUCSKUx/pB
	9fivzmO+V9cBEinZ466FtvS/EHiFxQGhtTLJFk6P5JYY/8oasZd0Xi1RUnWP3hqb
	Ei8T244wQAVywpsbi8nt3p4zx1/Q8G+akLD+Uh5IwQqAxRGhRj4n2CChH90pPZOS
	XSZzJW/JgzrmUEH5WfJLoOxLjEeXjONKTJ6ucy1UR036dkXG2kt+A==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4465gbu9nk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 16:22:37 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FEfONK017014;
	Wed, 15 Jan 2025 16:22:36 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fk965g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 16:22:35 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FGMYH68388904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 16:22:34 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B38D20040;
	Wed, 15 Jan 2025 16:22:34 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB71120049;
	Wed, 15 Jan 2025 16:22:33 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.28.131])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Jan 2025 16:22:33 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v10 5/5] crypto: testmgr - Enable phmac selftest
Date: Wed, 15 Jan 2025 17:22:31 +0100
Message-ID: <20250115162231.83516-6-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250115162231.83516-1-freude@linux.ibm.com>
References: <20250115162231.83516-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GtqRcsAQuDJdU0T6VFSCbEt2ktPLeJyV
X-Proofpoint-ORIG-GUID: GtqRcsAQuDJdU0T6VFSCbEt2ktPLeJyV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_07,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 adultscore=0 mlxlogscore=973 phishscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501150119

Add phmac selftest invocation to the crypto testmanager.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 crypto/testmgr.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1f5f48ab18c7..e753a68be861 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5539,6 +5539,36 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.cipher = __VECS(fcrypt_pcbc_tv_template)
 		}
 	}, {
+#if IS_ENABLED(CONFIG_CRYPTO_PHMAC_S390)
+		.alg = "phmac(sha224)",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(hmac_sha224_tv_template)
+		}
+	}, {
+		.alg = "phmac(sha256)",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(hmac_sha256_tv_template)
+		}
+	}, {
+		.alg = "phmac(sha384)",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(hmac_sha384_tv_template)
+		}
+	}, {
+		.alg = "phmac(sha512)",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(hmac_sha512_tv_template)
+		}
+	}, {
+#endif
 		.alg = "pkcs1(rsa,none)",
 		.test = alg_test_sig,
 		.suite = {
-- 
2.43.0

