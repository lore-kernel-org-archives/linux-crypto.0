Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB77C1DA635;
	Fri, 13 Sep 2024 13:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726232754; cv=none; b=kzGQuR471Pqw/lQAJBf+tVyFXngfZ1U+dBqKu+lVCVB2Q6pjmJk/DfnSOnBhB1+BA+mF7inW2WlkfIKs9dkTOo80RAZNYvrShoSpZDQ/nAEy7toRh2bpkqM6sRheZFT5U3o44VnF8YKiz+E1fkP6Ppl8Uc/1ZCXdSHyZaJ61nmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726232754; c=relaxed/simple;
	bh=EVF+GTWRRa4IiloDcCWCijgTOo2QAa/+19abAkf0b+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmonTIeSG/IpytUHbETo690DyPWk/kdZIfZWMZM0zmzV3q2fXr2meQ7dote7NiuPzONJfp14fehGKTT/31/XSrmqvn35xj7SLuKfBZiR2ab2ct6WJbJbbA1Q67Hm4b74VFAyNLiXvERTLs+RMokJ743LSkoOViY3s4DlbTjqYUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bjfZCh4U; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bjfZCh4U"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48D4hPck009974;
	Fri, 13 Sep 2024 13:05:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=GfF1GseNxNmkt
	16Ag2Kldh2DY6cuIObZVMznUa/oTVY=; b=bjfZCh4U5DMXw7LGFblCpI1dWCh4t
	ghR9q5JLf7HDPxPzKqRF0p9mWpg23ZldINC8ctMtuOIPc1FW287EHAKAZ38Gii2G
	e2Winf49V3+064nM+BZkln8Qz6UiM2G9Zm+OAe1cdKoulz3BwiuuwaMEDEqqXy4U
	5KRoT0a7kLoXMlUW4yaIv40Y4vJEGtTQel/N9Mxki3tJ0cwdLzBHJt9G0AWS1InR
	tCBCKvtDUsW/RjLYmbla6lE/5velgqeSPCxKBObWorZlz9IMC3RvToSvxW06QAA5
	MZ40EQ4i+hAFBqoPjjMhnG05sl6BtpLXCZKRp9HiuAnhxE9FMai+5ivYQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gegxa4hj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 13:05:50 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48DAN7Y6027315;
	Fri, 13 Sep 2024 13:05:50 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 41h3v3nxuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 13:05:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48DD5kn436372760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 13:05:46 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D45920040;
	Fri, 13 Sep 2024 13:05:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4784A20043;
	Fri, 13 Sep 2024 13:05:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 13 Sep 2024 13:05:46 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 6/7] s390/vdso: Move vdso symbol handling to separate header file
Date: Fri, 13 Sep 2024 15:05:42 +0200
Message-ID: <20240913130544.2398678-7-hca@linux.ibm.com>
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
X-Proofpoint-GUID: yHpXC42-ulIeCzViaUjVIcceMkaX2wrx
X-Proofpoint-ORIG-GUID: yHpXC42-ulIeCzViaUjVIcceMkaX2wrx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_10,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=933
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130091

The vdso.h header file, which is included at many places, includes
generated header files. This can easily lead to recursive header file
inclusions if the vdso code is changed.

Therefore move the vdso symbol code, which requires the generated
header files, to a separate header file, and include it at the two
locations which require it.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/vdso-symbols.h | 17 +++++++++++++++++
 arch/s390/include/asm/vdso.h         | 12 ------------
 arch/s390/kernel/compat_signal.c     |  2 +-
 arch/s390/kernel/signal.c            |  2 +-
 4 files changed, 19 insertions(+), 14 deletions(-)
 create mode 100644 arch/s390/include/asm/vdso-symbols.h

diff --git a/arch/s390/include/asm/vdso-symbols.h b/arch/s390/include/asm/vdso-symbols.h
new file mode 100644
index 000000000000..0df17574d788
--- /dev/null
+++ b/arch/s390/include/asm/vdso-symbols.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __S390_VDSO_SYMBOLS_H__
+#define __S390_VDSO_SYMBOLS_H__
+
+#include <generated/vdso64-offsets.h>
+#ifdef CONFIG_COMPAT
+#include <generated/vdso32-offsets.h>
+#endif
+
+#define VDSO64_SYMBOL(tsk, name) ((tsk)->mm->context.vdso_base + (vdso64_offset_##name))
+#ifdef CONFIG_COMPAT
+#define VDSO32_SYMBOL(tsk, name) ((tsk)->mm->context.vdso_base + (vdso32_offset_##name))
+#else
+#define VDSO32_SYMBOL(tsk, name) (-1UL)
+#endif
+
+#endif /* __S390_VDSO_SYMBOLS_H__ */
diff --git a/arch/s390/include/asm/vdso.h b/arch/s390/include/asm/vdso.h
index 53165aa7813a..91061f0279be 100644
--- a/arch/s390/include/asm/vdso.h
+++ b/arch/s390/include/asm/vdso.h
@@ -6,18 +6,6 @@
 
 #ifndef __ASSEMBLY__
 
-#include <generated/vdso64-offsets.h>
-#ifdef CONFIG_COMPAT
-#include <generated/vdso32-offsets.h>
-#endif
-
-#define VDSO64_SYMBOL(tsk, name) ((tsk)->mm->context.vdso_base + (vdso64_offset_##name))
-#ifdef CONFIG_COMPAT
-#define VDSO32_SYMBOL(tsk, name) ((tsk)->mm->context.vdso_base + (vdso32_offset_##name))
-#else
-#define VDSO32_SYMBOL(tsk, name) (-1UL)
-#endif
-
 extern struct vdso_data *vdso_data;
 
 int vdso_getcpu_init(void);
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index 1942e2a9f8db..5a86b9d1da71 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -24,11 +24,11 @@
 #include <linux/tty.h>
 #include <linux/personality.h>
 #include <linux/binfmts.h>
+#include <asm/vdso-symbols.h>
 #include <asm/access-regs.h>
 #include <asm/ucontext.h>
 #include <linux/uaccess.h>
 #include <asm/lowcore.h>
-#include <asm/vdso.h>
 #include <asm/fpu.h>
 #include "compat_linux.h"
 #include "compat_ptrace.h"
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index 6c2cb345402f..e48013cd832c 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -30,9 +30,9 @@
 #include <linux/compat.h>
 #include <asm/ucontext.h>
 #include <linux/uaccess.h>
+#include <asm/vdso-symbols.h>
 #include <asm/access-regs.h>
 #include <asm/lowcore.h>
-#include <asm/vdso.h>
 #include "entry.h"
 
 /*
-- 
2.43.0

