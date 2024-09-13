Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382311DA63A;
	Fri, 13 Sep 2024 13:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726232753; cv=none; b=Mbbijp2QT8otMpVh4cr+FazLddObgGBkAovRuQ3ZHYZiznfsiUNnTL+bUEjWX7Uw7lWK2Fvo+gokOy9cxyDSsU689+v65CdrFLyEcADPIImfTioIOLJVzlJtmQQNnyuqjR+bwnnmpT9dr3um0EBGLwxfeJBaucaJzyx7EpUoPT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726232753; c=relaxed/simple;
	bh=XuYhqwU7zJfFWBBPFkJwQ+AWb6A0cRgb3KCbwUj0fkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvvspBKnVP7EzAgKXs0Lcg1ECNMq/j8p/HOg70iKeCABaJQBQYVQGyBnmnbPEsEdA8/TA9/TW6A1ZvqMDlgGTwkiJKI1i8MnM6NY6qR8H0//eFm9GTy7oDd8HoxeEuDru6D06tjaXH6bJ6wVE3Ba3+B711Vd+I7P6GnNY1Hp4HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=K9l8/rwl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="K9l8/rwl"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48D7nsSE013634;
	Fri, 13 Sep 2024 13:05:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=lLFW1eSbEh2sb
	EVG/GFtT5Z0LU4t4XDUY8zrqEjn5Lo=; b=K9l8/rwlF0nnL1TdaSHmiUGnUtHpi
	q0sJRAh3wDMtA6OJpoJguDIqL7ZYVINYqgU6f62kNFXZzAnAOVOVg6klDNo/HMSX
	QxmIyb0XZyq+vIDcBJd/3nOIUfhQPOKEeymunX7OQHiAKKUdfTPU2v3bQOFpXYuf
	Zz9fs8Leo9mdN4coSV8F16dVvCFasFjYykrwbfTndlWZJ9dKIZt0PHyZR77cDN0K
	BRJfT3pGRvS4YsyCCsS7G38iDz9g5D+Mmp/13L1XiQ3lo7vxTZxtGwKFWx+q5vKi
	63QgZEGAAASQ5bgvBiy2rPkPuesxihSt5l0um17zZzlAhHsy86sB8ItJQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gd8m1w4r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 13:05:50 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48DC1m5G032073;
	Fri, 13 Sep 2024 13:05:50 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41h2nn666k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 13:05:50 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48DD5kTR36372758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 13:05:46 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3D2F120040;
	Fri, 13 Sep 2024 13:05:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB9012004B;
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
Subject: [PATCH 5/7] s390/vdso: Allow alternatives in vdso code
Date: Fri, 13 Sep 2024 15:05:41 +0200
Message-ID: <20240913130544.2398678-6-hca@linux.ibm.com>
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
X-Proofpoint-GUID: GK6W9mLi6BybWCboA39Wm71uXlt-4Hxq
X-Proofpoint-ORIG-GUID: GK6W9mLi6BybWCboA39Wm71uXlt-4Hxq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_09,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 mlxlogscore=913 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130087

Implement the infrastructure required to allow alternatives in vdso code.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/kernel/vdso.c              | 19 +++++++++++++++++++
 arch/s390/kernel/vdso64/vdso64.lds.S |  4 ++++
 2 files changed, 23 insertions(+)

diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index 2f967ac2b8e3..8e4e6b316337 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -12,12 +12,14 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/time_namespace.h>
 #include <linux/random.h>
 #include <vdso/datapage.h>
+#include <asm/alternative.h>
 #include <asm/vdso.h>
 
 extern char vdso64_start[], vdso64_end[];
@@ -250,8 +252,25 @@ static struct page ** __init vdso_setup_pages(void *start, void *end)
 	return pagelist;
 }
 
+static void vdso_apply_alternatives(void)
+{
+	const struct elf64_shdr *alt, *shdr;
+	struct alt_instr *start, *end;
+	const struct elf64_hdr *hdr;
+
+	hdr = (struct elf64_hdr *)vdso64_start;
+	shdr = (void *)hdr + hdr->e_shoff;
+	alt = find_section(hdr, shdr, ".altinstructions");
+	if (!alt)
+		return;
+	start = (void *)hdr + alt->sh_offset;
+	end = (void *)hdr + alt->sh_offset + alt->sh_size;
+	apply_alternatives(start, end);
+}
+
 static int __init vdso_init(void)
 {
+	vdso_apply_alternatives();
 	vdso64_mapping.pages = vdso_setup_pages(vdso64_start, vdso64_end);
 	if (IS_ENABLED(CONFIG_COMPAT))
 		vdso32_mapping.pages = vdso_setup_pages(vdso32_start, vdso32_end);
diff --git a/arch/s390/kernel/vdso64/vdso64.lds.S b/arch/s390/kernel/vdso64/vdso64.lds.S
index 37e2a505e81d..fa02c6ae3cac 100644
--- a/arch/s390/kernel/vdso64/vdso64.lds.S
+++ b/arch/s390/kernel/vdso64/vdso64.lds.S
@@ -42,6 +42,10 @@ SECTIONS
 	.rodata		: { *(.rodata .rodata.* .gnu.linkonce.r.*) }
 	.rodata1	: { *(.rodata1) }
 
+	. = ALIGN(8);
+	.altinstructions	: { *(.altinstructions) }
+	.altinstr_replacement	: { *(.altinstr_replacement) }
+
 	.dynamic	: { *(.dynamic) }		:text	:dynamic
 
 	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
-- 
2.43.0

