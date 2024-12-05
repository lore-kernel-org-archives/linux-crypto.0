Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3C51D9A7E;
	Thu,  5 Dec 2024 12:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733402117; cv=none; b=VjxpdXfGrHMb9lft9kv7tprmSnNZ/lJSgZz15Xj6gkgbIDolzOS4wRRc1mH1nV2dnpM63ylR64ZkLyZ0iHGmBnCl6AT1qEIaFokISAVzjrAweZlDfhD3xAF4+Xov31h8/0KKmiGdvZ2784H9KX+P88JF07C58SXWYhK+csHhciA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733402117; c=relaxed/simple;
	bh=zj6tJ578R9wh6dp3werHB9qDADY1T5Li+Nx+FU8aJw8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TcTNIMxlWyf6lIsYSXIPxgpL09Gc+a3oBO2g/DrowzbBbYoFkbRmT+aRH4rIe0Y2LfKcqpInkM471Dg8XIyI0wW5uVYSlNozdxPwUEjJcFbO9rVt8zEAVoRrQdqCblMJPMsdAVqaBUI3OVKcFgakkRSESFyxUJX5trHu5pgy0nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VouiHd6D; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VouiHd6D"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B592o98014509;
	Thu, 5 Dec 2024 12:35:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=U2fIygBF4x6Pt+Rni7BztUXH/oPF
	ROEK9PYbYqfJr3o=; b=VouiHd6DBxvn13XsWgBcqeoXQ1Tjhpc4CRcF8g/nx/i6
	KCxsWIK5BpyXDb4ogNM8kWG5N+tXCjlfCcYFYJw8VRPrlRusHzIf9qnyayWWIQhT
	R8VjUfJfjLpdS3jO9NeKCIVk5mDAPUH8xkF64baAHhVkJNanY9A97AVDnPMNkAwz
	0qBc2lSLm5jJLpRhDU+LQE5YT/YC5xMZsweZaxCVod7bjkHoF50oqbLXJT9D4EBo
	HoGeRDcvVkxMRLwVejbDrEdQgUC3cFZJiZgBfjT6rFtOBZudOQbyUwfJwPn7VAo0
	JR//r5SD7KD6Ik0m0xDYIYQHaufGmFB7wsYjK+AEug==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 437tbxw9cf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 12:35:06 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4B5CZ52q010806;
	Thu, 5 Dec 2024 12:35:05 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 437tbxw9cc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 12:35:05 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5BAT5j023634;
	Thu, 5 Dec 2024 12:35:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 438e1n8t5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 12:35:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B5CZ3rN20316524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Dec 2024 12:35:03 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAFDB20040;
	Thu,  5 Dec 2024 12:35:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D504320049;
	Thu,  5 Dec 2024 12:34:59 +0000 (GMT)
Received: from li-c9696b4c-3419-11b2-a85c-f9edc3bf8a84.in.ibm.com (unknown [9.109.198.241])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Dec 2024 12:34:59 +0000 (GMT)
From: Nilay Shroff <nilay@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Nilay Shroff <nilay@linux.ibm.com>, briannorris@chromium.org,
        kees@kernel.org, nathan@kernel.org, yury.norov@gmail.com,
        steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
        linux-crypto@vger.kernel.org, linux@weissschuh.net, gjoyce@ibm.com
Subject: [PATCHv2] cpumask: work around false-postive stringop-overread errors
Date: Thu,  5 Dec 2024 18:04:09 +0530
Message-ID: <20241205123413.309388-1-nilay@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GcK8_Kxy7R5GmRzrur814ZPhoJ1XsabR
X-Proofpoint-GUID: QSKJ51AB-5YuxaLZqJTASMV__SCsY58l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 phishscore=0 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2412050090

While building the powerpc code using gcc 13, I came across following
errors generated for kernel/padata.c file:

  CC      kernel/padata.o
In file included from ./include/linux/string.h:390,
                 from ./arch/powerpc/include/asm/paca.h:16,
                 from ./arch/powerpc/include/asm/current.h:13,
                 from ./include/linux/thread_info.h:23,
                 from ./include/asm-generic/preempt.h:5,
                 from ./arch/powerpc/include/generated/asm/preempt.h:1,
                 from ./include/linux/preempt.h:79,
                 from ./include/linux/spinlock.h:56,
                 from ./include/linux/swait.h:7,
                 from ./include/linux/completion.h:12,
                 from kernel/padata.c:14:
In function ‘bitmap_copy’,
    inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
    inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
  114 | #define __underlying_memcpy     __builtin_memcpy
      |                                 ^
./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
  633 |         __underlying_##op(p, q, __fortify_size);                        \
      |         ^~~~~~~~~~~~~
./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
  678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
      |                          ^~~~~~~~~~~~~~~~~~~~
./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
  259 |                 memcpy(dst, src, len);
      |                 ^~~~~~
kernel/padata.c: In function ‘__padata_set_cpumasks’:
kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
  713 |                                  cpumask_var_t pcpumask,
      |                                  ~~~~~~~~~~~~~~^~~~~~~~
In function ‘bitmap_copy’,
    inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
    inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
  114 | #define __underlying_memcpy     __builtin_memcpy
      |                                 ^
./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
  633 |         __underlying_##op(p, q, __fortify_size);                        \
      |         ^~~~~~~~~~~~~
./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
  678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
      |                          ^~~~~~~~~~~~~~~~~~~~
./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
  259 |                 memcpy(dst, src, len);
      |                 ^~~~~~
kernel/padata.c: In function ‘__padata_set_cpumasks’:
kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
  713 |                                  cpumask_var_t pcpumask,
      |                                  ~~~~~~~~~~~~~~^~~~~~~~

Apparently, above errors only manifests with GCC 13.x and config option
CONFIG_FORTIFY_SOURCE. Furthermore, if I use gcc 11.x or gcc 12.x then I
don't encounter above errors. Prima facie, these errors appear to be false-
positive. Brian informed me that currently some efforts are underway by
GCC developers to emit more verbose information when GCC detects string
overflow errors and that might help to further narrow down the root cause
of this error. So for now, silence these errors using -Wno-stringop-
overread gcc option while building kernel/padata.c file until we find the
root cause.

Link: https://lore.kernel.org/all/7cbbd751-8332-4ab2-afa7-8c353834772a@linux.ibm.com/
Cc: briannorris@chromium.org
Cc: kees@kernel.org
Cc: nathan@kernel.org
Cc: yury.norov@gmail.com
Cc: steffen.klassert@secunet.com
Cc: daniel.m.jordan@oracle.com
Cc: linux-crypto@vger.kernel.org
Cc: linux@weissschuh.net
Cc: gjoyce@ibm.com
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
---
Changes from v1:
    - Fix spell error in the commit message (Brian Norris)
    - Add commentary around change to note that changes are needed to
      avoid false positive on gcc 13+ (Brian Norris)
    - Add the kerenl/padata.c file maintainers (Brian Norris)     
---

 kernel/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/Makefile b/kernel/Makefile
index 87866b037fbe..03242d8870c7 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -120,6 +120,10 @@ obj-$(CONFIG_CFI_CLANG) += cfi.o
 obj-$(CONFIG_PERF_EVENTS) += events/
 
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
+
+# Silence the false positive stringop-overread errors on GCC 13+
+CFLAGS_padata.o += $(call cc-disable-warning, stringop-overread)
+
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
-- 
2.45.2

