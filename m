Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4AD193432;
	Thu, 19 Sep 2024 11:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726746133; cv=none; b=owCFj4iuOLg+2OQl47BbZ0roKlOLKgV0fGIQkBjIfkula0uymk/mJJMuultzfjPPPJFUUOML8VItSEJnmonYwlLpNE9/NoQWqLt4BfQGZGNvG5l47rZvOzJonc99pYAvT/SqxRDb31cFVXV3CcEdlw2WdnVP0qWgWooF7uWbwME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726746133; c=relaxed/simple;
	bh=rru9U71LlZqwPY0JY1GK2L/XSmtbmZoDialzHi1gztQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QQeAGCLZkRZvbAtDxPpmdubSkaAgjHolwDaFZ1p7+vNVeVTfrBTL4DJX98PYVbZh+qQkKMVKVSX1OSCQQiGs+eVLaYPt8/UYQf5cY9R+ZBn5j6mNC0Oe6/X+RHfZ8wH7KYJmLNFrkQNa/7m/5t0er45JyTR4qqK+Ic5CuR9QUWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ojXqOjCb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ojXqOjCb"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JA0LOj032380;
	Thu, 19 Sep 2024 11:36:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=QteISjsPvSYtQj+xdyh7B2a2F3
	0QM/xnGWrnO7sCxH0=; b=ojXqOjCbLu3PN/O3M+WKEPeiXcsNM7mgOfb5Vo2E/I
	fegUkrgrXj+OUFo5W+rojY7rZnjkXz8fSyAGKpC3LDTyX9Anb3vWdYUk5/465yrb
	KCrjvlKBZmGcWyrQpH9X84rmpXHAfpekob+YfeDteu8I/QmWpQ6jWIYbf1UOsZ77
	9gDC7wD4u1FHvqjkX5ktOIjIgYWH3dCF8be+DHZ5py+uFZ7YgqmqZTbpIfstVxvJ
	owtqyeocvFlrMnbFhQsle/nGRgnBkFetDb7iEal/agcWcssTENJxsfZNU6smq4a6
	pzdIchvuHgjLKaeLf0jlF2TGBC8ZcCGhhMMemnbhFkLw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vp4av4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Sep 2024 11:36:51 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48JAHWqu030656;
	Thu, 19 Sep 2024 11:36:50 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41npanh1y1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Sep 2024 11:36:50 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48JBanNS46268824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 11:36:49 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C60C58052;
	Thu, 19 Sep 2024 11:36:49 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C866658064;
	Thu, 19 Sep 2024 11:36:48 +0000 (GMT)
Received: from ltcden12-lp3.aus.stglabs.ibm.com (unknown [9.40.195.53])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Sep 2024 11:36:48 +0000 (GMT)
From: Danny Tsen <dtsen@linux.ibm.com>
To: linux-crypto@vger.kernel.org
Cc: stable@vger.kernel.org, herbert@gondor.apana.org.au, leitao@debian.org,
        nayna@linux.ibm.com, appro@cryptogams.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com,
        Danny Tsen <dtsen@linux.ibm.com>
Subject: [PATCH v3] crypto: Removing CRYPTO_AES_GCM_P10.
Date: Thu, 19 Sep 2024 07:36:37 -0400
Message-ID: <20240919113637.144343-1-dtsen@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qAO453QM_JcoyMgrevBjlyXeYulnrA0z
X-Proofpoint-GUID: qAO453QM_JcoyMgrevBjlyXeYulnrA0z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_08,2024-09-18_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=837
 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409190071

Data mismatch found when testing ipsec tunnel with AES/GCM crypto.
Disabling CRYPTO_AES_GCM_P10 in Kconfig for this feature.

Fixes: fd0e9b3e2ee6 ("crypto: p10-aes-gcm - An accelerated AES/GCM stitched implementation")
Fixes: cdcecfd9991f ("crypto: p10-aes-gcm - Glue code for AES/GCM stitched implementation")
Fixes: 45a4672b9a6e2 ("crypto: p10-aes-gcm - Update Kconfig and Makefile")

Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
---
 arch/powerpc/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index 09ebcbdfb34f..46a4c85e85e2 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -107,6 +107,7 @@ config CRYPTO_AES_PPC_SPE
 
 config CRYPTO_AES_GCM_P10
 	tristate "Stitched AES/GCM acceleration support on P10 or later CPU (PPC)"
+	depends on BROKEN
 	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
 	select CRYPTO_LIB_AES
 	select CRYPTO_ALGAPI
-- 
2.43.0

