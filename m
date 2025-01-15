Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B196686348;
	Wed, 15 Jan 2025 16:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736958161; cv=none; b=jA5GzFRHJHjn78MuljBPmsNWi3dKJeB2lzcwyN0NP7hOBfz7vIxmTpMgUvM/uyhp87ruQbtI6qWZj/DzYTDdHI86psfbOOiDl2rteRCrI6Le2Tb2Hy2p7roT5IDUbK6NO52cpDgiXDqzjztOw7/6o5obggyAAttD22/5HZ6n6OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736958161; c=relaxed/simple;
	bh=A3z6j+fkdV4BAojk6viwkJSKja55R83Ja6SscZTL6rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJPy33dXBCVhnkhV94tpqVzO8ubjIyZnx9GNsWH3elf4/SBdULTrjA6yxoASyfECkcShqW3hsvA/LpgibOzhbU6pY/3y3chaejeTXnzt/6Sheyrr4qvckqdfrE5YhPwPonOdRVmCPj2jvQhp7x8PNzuqbMINQK5E5sf/SdJlUIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XKLUar5+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XKLUar5+"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FGK8Yg020082;
	Wed, 15 Jan 2025 16:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=DfZdLU74MgekTvz1V
	r/xGJNwtHeoMIRggJ3r2aMl5jA=; b=XKLUar5+mIE5SAvNGNt+4/4QAd0bePeJE
	YYqEFde0kFx0AM5O9A273LJZ30FyJLA6649rDHGm09Mwf89cEl43WfCA8XPYZJ5X
	fSPrgc5sGfd1j58WaWkE73B9QHszN/I0GoA7ZyXlaJ1g6L3henhKNrWP55IsKuHY
	2bzUpy6tsF3tkE802uSRaUXLfhScLaiaGxfnopp4FCsnaIuzxxdx2v+fNBv7dH/u
	pHEBs0/xd2aLpXEA+yGODCe3D6Rk1pYzWQBNRt5NUX4jKCvz2JR9A4BJ1HfmCCnh
	Lus+ocv9m9dki5fRQhpjs6RLe5IoYfa9TAmkI/DQ9A61CI5F2XzoQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446eg5rs6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 16:22:35 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FFkYEl016485;
	Wed, 15 Jan 2025 16:22:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4445p1rwdj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 16:22:35 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FGMXKM56558010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 16:22:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 76E7A20040;
	Wed, 15 Jan 2025 16:22:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E9E72004B;
	Wed, 15 Jan 2025 16:22:33 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.28.131])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Jan 2025 16:22:33 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v10 3/5] crypto: api - Add crypto_tfm_alg_get_flags() helper inline function
Date: Wed, 15 Jan 2025 17:22:29 +0100
Message-ID: <20250115162231.83516-4-freude@linux.ibm.com>
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
X-Proofpoint-GUID: HV8pXH4XtBkgBEBJQjtzF0gwSWkIjXh8
X-Proofpoint-ORIG-GUID: HV8pXH4XtBkgBEBJQjtzF0gwSWkIjXh8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_07,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 clxscore=1015 phishscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=609
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150119

Add a little helper inline function
    crypto_tfm_alg_get_flags()
to the crypto.h header file to retrieve the alg flags.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 include/linux/crypto.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b164da5e129e..8b37d381cd97 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -472,6 +472,11 @@ static inline unsigned int crypto_tfm_alg_alignmask(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_alignmask;
 }
 
+static inline u32 crypto_tfm_alg_get_flags(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags;
+}
+
 static inline u32 crypto_tfm_get_flags(struct crypto_tfm *tfm)
 {
 	return tfm->crt_flags;
-- 
2.43.0

