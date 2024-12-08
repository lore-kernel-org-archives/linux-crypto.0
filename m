Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF7913B2B6;
	Sun,  8 Dec 2024 16:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733674464; cv=none; b=N95rygR/kLoVnlUrxVjshBmoJ55Ldeo/w1jyN/Jic0bJX8bI+k/uX4uWRkRg82SZDletTvAsDO6VHBOxjTVXOU9keXQqh3q4vls3fUZvqdbVC+Q8prYUl34j2gYGCFqirAokzTZthQqqXrTUYQ2zKikfxEhh38NHEeNhk32U5Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733674464; c=relaxed/simple;
	bh=vnwcCe2ZgqUbS/kiLKPWcHHWXUGcgF3v9h+PdjefYss=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Mr4Z+vH2Uni6FIZzgLxDDb3Y51yjuPpCpZsDzSpy9oKDmJ2N+9e5/gAGSdFkBYywFXNwSCxVYJIiUHSz1QPAuSA01g4aklUd4S5pIIzLzump8DJ65gO//ZY6fAntzgpy1RfZl0ncvjJMTx4G1MzJx+lTG1Zvnh5g2O/dd3gaZAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=B8tRM+wr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B8tRM+wr"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B7LjHH0001930;
	Sun, 8 Dec 2024 16:13:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=g//DOMBk9wa2wTE0pbS/qymWIXk4
	SKEw1NT4Br8mbqg=; b=B8tRM+wrkRpMycdxDyVZiufSEL5iGg1eyI7Wsw0wuzA4
	7LP+oQTkxXdMU2/dNbWiqVcyiF/C12kwBmueTKiLfSQ242hRh5V18zF6VN9RtRXd
	RX3uFt1iaTdPnSfRJuNjluceWqK1LejmvFxoudv0qWO70ItPhwZCaKdb8GZ6yhhX
	/SlPAtsCU0HXQJI/qH+udwEjguMo+5KxaBaUseaXoGKXd921URBUEci3xyxkH73N
	TKQqxioCX7g27pUvROAf38uRj6XUPaKz4LaSlVZX7tPoj0LzkblEUsbQwPwCfJr7
	S7IxLrJmvaltnaiXKPUiXPSTBxfHVfi3VJuNxU3AbA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cbspw17q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Dec 2024 16:13:38 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4B8GDbip005103;
	Sun, 8 Dec 2024 16:13:37 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cbspw17k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Dec 2024 16:13:37 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B8FALYi016910;
	Sun, 8 Dec 2024 16:13:37 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43d12xttkh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Dec 2024 16:13:37 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B8GDZHu30475006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 8 Dec 2024 16:13:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 040002004E;
	Sun,  8 Dec 2024 16:13:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 095DA2004B;
	Sun,  8 Dec 2024 16:13:32 +0000 (GMT)
Received: from li-c9696b4c-3419-11b2-a85c-f9edc3bf8a84.ibm.com.com (unknown [9.179.1.228])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  8 Dec 2024 16:13:31 +0000 (GMT)
From: Nilay Shroff <nilay@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Nilay Shroff <nilay@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        briannorris@chromium.org, yury.norov@gmail.com, kees@kernel.org,
        gustavoars@kernel.org, nathan@kernel.org, steffen.klassert@secunet.com,
        daniel.m.jordan@oracle.com, gjoyce@ibm.com,
        linux-crypto@vger.kernel.org, linux@weissschuh.net
Subject: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for gcc-13+ and FORTIFY_SOURCE
Date: Sun,  8 Dec 2024 21:42:28 +0530
Message-ID: <20241208161315.730138-1-nilay@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: DqrFVQTVQ6NP6GX0_xqKsOcnzt-gePX0
X-Proofpoint-GUID: IlUYqlsDqfcJ3aB3UlZHeT5aCduI93as
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 clxscore=1011 phishscore=0 impostorscore=0
 suspectscore=0 spamscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412080133

While building the powerpc code using gcc 13.x, I came across following
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

The above error appears to be false-positive:
From the distro relevant config,
    CONFIG_PPC64=y
    CONFIG_CC_IS_GCC=y
    CONFIG_GCC_VERSION=130301
    CONFIG_NR_CPUS=2048
    CONFIG_FORTIFY_SOURCE=y

From the source code,
unsigned long name[BITS_TO_LONGS(bits)]
...
typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
typedef struct cpumask cpumask_var_t[1];
...

extern unsigned int nr_cpu_ids;
...
static __always_inline
void bitmap_copy(unsigned long *dst, const unsigned long *src, unsigned
int nbits)
{
        unsigned int len = bitmap_size(nbits);

        if (small_const_nbits(nbits))
                *dst = *src;
        else
                memcpy(dst, src, len);
}

static __always_inline
void cpumask_copy(struct cpumask *dstp, const struct cpumask *srcp)
{
        bitmap_copy(cpumask_bits(dstp), cpumask_bits(srcp), large_cpumask_bits);
}
...
static int __padata_set_cpumasks(struct padata_instance *pinst,
                                 cpumask_var_t pcpumask,
                                 cpumask_var_t cbcpumask)
{
...
        cpumask_copy(pinst->cpumask.pcpu, pcpumask);
        cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
...
}

So the above statements expands to:
memcpy(pinst->cpumask.pcpu->bits, pcpumask->bits, nr_cpu_ids)
memcpy(pinst->cpumask.cbcpu->bits, cbcpumask->bits, nr_cpu_ids)

Now the compiler complains about "error: ‘__builtin_memcpy’ reading
between 257 and 536870904 bytes from a region of size 256". So the
value of nr_cpu_ids which gcc calculated is between 257 and 536870904.
This looks strange and incorrect.

Later similar errors[1] were also observed on x86-64 platform using 
gcc-14. Apparently, above errors menifests using gcc-13+ and config 
option CONFIG_FORTIFY_SOURCE=y. Moreover, I don't encounter above 
error when,
- using gcc 11.x or gcc 12.x or LLVM/Clang compiler
or
- disabling CONFIG_FORTIFY_SOURCE option

So for now, silence above errors globally while using gcc-13+ and
CONFIG_FORTIFY_SOURCE=y. We may later revert this change when we
find root cause of the error. Per this  discussion[2], GCC developers
are working to add extra diagnostics and context when this error
menifests and that might help to find the root cause.

[1] https://lore.kernel.org/all/2024120757-lustrous-equinox-77f0@gregkh/
[2] https://gcc.gnu.org/pipermail/gcc-patches/2024-October/666870.html

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: briannorris@chromium.org
Cc: yury.norov@gmail.com
Cc: kees@kernel.org
Cc: gustavoars@kernel.org
Cc: nathan@kernel.org
Cc: steffen.klassert@secunet.com
Cc: daniel.m.jordan@oracle.com
Cc: gjoyce@ibm.com
Cc: linux-crypto@vger.kernel.org
Cc: linux@weissschuh.net
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
---
Changes from v2:
    - Globally disable -Werror-stringop-overread while using gcc-13+ and
      FORTIFY_SOURCE (Yury Norov)
    - Updated the patch subject line to make it clear that this is
	  possiblt gcc error and not related to cpumask.
Changes from v1:
    - Fix spell error in the commit message (Brian Norris)
    - Add commentary around change to note that changes are needed to
      avoid false positive on gcc 13+ (Brian Norris)
    - Add the kerenl/padata.c file maintainers (Brian Norris)
---
 init/Kconfig               | 8 ++++++++
 scripts/Makefile.extrawarn | 1 +
 2 files changed, 9 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index a20e6efd3f0f..ff2f54520551 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -920,6 +920,14 @@ config CC_STRINGOP_OVERFLOW
 	bool
 	default y if CC_IS_GCC && !CC_NO_STRINGOP_OVERFLOW
 
+# Currently, disable -Wstringop-overread for gcc-13+ and FORTIFY_SOURCE globally.
+config GCC13_NO_STRINGOP_OVERREAD
+	def_bool y
+
+config CC_NO_STRINGOP_OVERREAD
+	bool
+	default y if CC_IS_GCC && GCC_VERSION >= 130000 && GCC13_NO_STRINGOP_OVERREAD && FORTIFY_SOURCE
+
 #
 # For architectures that know their GCC __int128 support is sound
 #
diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 1d13cecc7cc7..1abd41269fd0 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -27,6 +27,7 @@ endif
 KBUILD_CPPFLAGS-$(CONFIG_WERROR) += -Werror
 KBUILD_CPPFLAGS += $(KBUILD_CPPFLAGS-y)
 KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUNDS) += -Wno-array-bounds
+KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERREAD) += -Wno-stringop-overread
 
 ifdef CONFIG_CC_IS_CLANG
 # The kernel builds with '-std=gnu11' so use of GNU extensions is acceptable.
-- 
2.45.2

