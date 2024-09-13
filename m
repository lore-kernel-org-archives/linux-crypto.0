Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8331DA631;
	Fri, 13 Sep 2024 13:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726232754; cv=none; b=gJOvEQr2Mj2sUXvp4txnZ+FhOWOU0OxOqU6UxKB6pG95JL0fxwfGv/sV2HTjqYFhxu9Fn7DZrBn2HlabT9vawugKyHacxyb9ViNCYVb2OLPdGd07kPQI/KXch8BJZROueAdwEUkm1/BM83kocX65cwYpdhDyBxxxgahM5x50wgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726232754; c=relaxed/simple;
	bh=tk7+gVZLeLXU7t+66s8i13HI1nku9D8W8bICtBD60gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPzBTxxsVsorukNjzQhM1+HeGhWEz+sU/FvWgLJDeUNrPRobEcibkb3FicVacB2Ni1SvGp3uma5eckrsR+O0GxzsaBvxNrIK4ObyDHITKqUDCRaf2g+xsBLG3It1MpRjsU1k7y+9GzFSTinZrmTV3eu7jSf8p7hZ6PDUQ5YYyTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gixD29Vp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gixD29Vp"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48D8CDa9021760;
	Fri, 13 Sep 2024 13:05:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=uaXYr7IRkkEcw
	gpPxsCQAfW/yt2dgirIHku/Is3oCQ8=; b=gixD29Vpsn5GJygQRNZrOy4VuMQ88
	KEn+gs5Wz4uZC59Tk58IiG2+8d+ToCGTRcne22dmOr6JHCqW6Mv/gG9pDRYCaJrR
	tqNruoOiExOPYrI5eGYGkT3T0SULYmgiRQrJ1dUBBv7PoKK4P8RV0KMyuNvjG65T
	+LBSYRzptTQKjtGN2XlW1d4KvG6N8O7DBuZvnCXXUzjtOVzAPIdAvElxqCXb69kL
	dJpsUPirdnpEzvCUfBfID1ujfBrnQZed+HFE2RYh/+F8h7eH9qGqI4q3dgI1E9qR
	YdSiJa1oRpyziw/X3IHmUlMDfaPs8PO2NvpVpKR+EN1g2YU0GmXNsltHA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gc8qtamk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 13:05:50 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48DC5KWD032099;
	Fri, 13 Sep 2024 13:05:49 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41h2nn666j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 13:05:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48DD5jDb10093024
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 13:05:46 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E145420040;
	Fri, 13 Sep 2024 13:05:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 923AB20043;
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
Subject: [PATCH 4/7] s390/module: Provide find_section() helper
Date: Fri, 13 Sep 2024 15:05:40 +0200
Message-ID: <20240913130544.2398678-5-hca@linux.ibm.com>
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
X-Proofpoint-GUID: qdAT7z5y4BsTCTJ4ZyG4GIw5S5GdtQPL
X-Proofpoint-ORIG-GUID: qdAT7z5y4BsTCTJ4ZyG4GIw5S5GdtQPL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_09,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 clxscore=1015 mlxlogscore=606 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130087

Provide find_section() helper function which can be used to find a
section by name, similar to other architectures.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/module.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/s390/include/asm/module.h b/arch/s390/include/asm/module.h
index 9f1eea15872c..916ab59e458a 100644
--- a/arch/s390/include/asm/module.h
+++ b/arch/s390/include/asm/module.h
@@ -38,4 +38,18 @@ struct mod_arch_specific {
 #endif /* CONFIG_FUNCTION_TRACER */
 };
 
+static inline const Elf_Shdr *find_section(const Elf_Ehdr *hdr,
+					   const Elf_Shdr *sechdrs,
+					   const char *name)
+{
+	const char *secstrs = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+	const Elf_Shdr *s, *se;
+
+	for (s = sechdrs, se = sechdrs + hdr->e_shnum; s < se; s++) {
+		if (strcmp(name, secstrs + s->sh_name) == 0)
+			return s;
+	}
+	return NULL;
+}
+
 #endif /* _ASM_S390_MODULE_H */
-- 
2.43.0

