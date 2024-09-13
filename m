Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF7F1DA633;
	Fri, 13 Sep 2024 13:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726232753; cv=none; b=VKz0K74/PvaWQeUmPFC24aCYZsk1V31fChG1TZz1/D+/1xpL+5dJiITlYOJdgUmF9LOPzoe2103WXgMrBTN5Au8eB+6PXoGu+xRu5JWJPuOiMwx8jzeLxkeM2ZfDZZH6ri5SecgHD4fLolm1mAC95WiMx6SNvV1n22why/MV/bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726232753; c=relaxed/simple;
	bh=ZeSBXGnKWmELJd9VKFcca2xHwEh3bOM2Y8tNSdtl5A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQOUT/ZbPyCtODR24p3B5sr4YM4kn6uPW9iGvxgaWeMObtQJdesvJE+o+HhZMeUdd3SDyph1UoL07uk+7hiPuLTL3dblw5UZ5qTbLj+k5RZnjN2jBU68r/HA/fFI22iPraKnPtaEYtmmj9JU0E0ArmFrFy09l9DJ6MgJpCizKNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=U5voN1IV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U5voN1IV"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48D69d0v017485;
	Fri, 13 Sep 2024 13:05:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=8G8U5MZwRX6WH
	tIt0vxDGdxnDdLkEPMl63e5SJO3lbo=; b=U5voN1IV2nc5iybd99Bspnz8NMW1N
	xjXcWMA2e1Sf6zRLp4HnNWO3V9J+pGl904ysfJUUKCPxp5CRPg6Y7oZ/kC2lpY5C
	ZnfSxCaofDcUdHqkvWy9aH+/SiQWlcj5JQ8Bp3bbVD7bjXN3jnbxzbIHRVJwhJpt
	L5TALSK3/ykxBjgwiRw5we2fHYuIF08EBtOjYP+Tkch9go0gkTbFqlV/H5Qy2Y5k
	C9aFUJYhodEj9qMnCqSHGxtcAbiBf3APuwJjof+ojlhLGfgbxAsM42nnHPimKZg6
	UZ6a8Os7Nx1AINthg3dYiE9SfuuCISZhywuLt0P3ZlNHtV4G85eAP2F4Q==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gejb2521-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 13:05:50 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48DCFWEH010793;
	Fri, 13 Sep 2024 13:05:49 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41kmb71vj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 13:05:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48DD5jOO10944802
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 13:05:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87E4020040;
	Fri, 13 Sep 2024 13:05:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4166F2004B;
	Fri, 13 Sep 2024 13:05:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 13 Sep 2024 13:05:45 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 3/7] s390/facility: Let test_facility() generate static branch if possible
Date: Fri, 13 Sep 2024 15:05:39 +0200
Message-ID: <20240913130544.2398678-4-hca@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240913130544.2398678-1-hca@linux.ibm.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AwyVxn2EB-Vs-6MZ-XBh0ZU2WUv0a4uJ
X-Proofpoint-GUID: AwyVxn2EB-Vs-6MZ-XBh0ZU2WUv0a4uJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_10,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=737 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409130091

Let test_facility() generate a branch instruction if the tested facility is
a constant, and where the result cannot be evaluated during compile
time. The branch instruction defaults to "false" and is patched to nop
(branch not taken) if the tested facility is available.

This avoids runtime checks and is similar to x86's static_cpu_has() and
arm64's alternative_has_cap_likely().

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/facility.h | 37 +++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/facility.h b/arch/s390/include/asm/facility.h
index 65ebf86506cd..715bcf8fb69a 100644
--- a/arch/s390/include/asm/facility.h
+++ b/arch/s390/include/asm/facility.h
@@ -14,7 +14,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/preempt.h>
-
+#include <asm/alternative.h>
 #include <asm/lowcore.h>
 
 #define MAX_FACILITY_BIT (sizeof(stfle_fac_list) * 8)
@@ -39,30 +39,51 @@ static inline void __clear_facility(unsigned long nr, void *facilities)
 	ptr[nr >> 3] &= ~(0x80 >> (nr & 7));
 }
 
-static inline int __test_facility(unsigned long nr, void *facilities)
+static __always_inline bool __test_facility(unsigned long nr, void *facilities)
 {
 	unsigned char *ptr;
 
 	if (nr >= MAX_FACILITY_BIT)
-		return 0;
+		return false;
 	ptr = (unsigned char *) facilities + (nr >> 3);
 	return (*ptr & (0x80 >> (nr & 7))) != 0;
 }
 
+/*
+ * __test_facility_constant() generates a single instruction branch. If the
+ * tested facility is available (likely) the branch is patched into a nop.
+ *
+ * Do not use this function unless you know what you are doing. All users are
+ * supposed to use test_facility() which will do the right thing.
+ */
+static __always_inline bool __test_facility_constant(unsigned long nr)
+{
+	asm goto(
+		ALTERNATIVE("brcl 15,%l[l_no]", "brcl 0,0", ALT_FACILITY(%[nr]))
+		:
+		: [nr] "i" (nr)
+		:
+		: l_no);
+	return true;
+l_no:
+	return false;
+}
+
 /*
  * The test_facility function uses the bit ordering where the MSB is bit 0.
  * That makes it easier to query facility bits with the bit number as
  * documented in the Principles of Operation.
  */
-static inline int test_facility(unsigned long nr)
+static __always_inline bool test_facility(unsigned long nr)
 {
 	unsigned long facilities_als[] = { FACILITIES_ALS };
 
-	if (__builtin_constant_p(nr) && nr < sizeof(facilities_als) * 8) {
-		if (__test_facility(nr, &facilities_als)) {
-			if (!__is_defined(__DECOMPRESSOR))
-				return 1;
+	if (!__is_defined(__DECOMPRESSOR) && __builtin_constant_p(nr)) {
+		if (nr < sizeof(facilities_als) * 8) {
+			if (__test_facility(nr, &facilities_als))
+				return true;
 		}
+		return __test_facility_constant(nr);
 	}
 	return __test_facility(nr, &stfle_fac_list);
 }
-- 
2.43.0

