Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E35D1D0492;
	Sat, 14 Sep 2024 17:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726335777; cv=none; b=oqyH7lyHzBmw64Ei+7hdD5U5Vbad11wDxuJVoeU5goOkIwpAHAP+0vi6mj19nztlfS3yBRe3zzbq+t04rpSEJUyq0Ilu8IPF7Hon4L16JZjtRXNTV7hMgswyonIUQDK1DTuk0PhgDf0TDvNzUbvaN1yGuSeriqZAyKRu9pSBkvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726335777; c=relaxed/simple;
	bh=uQstSLTVghrRz3Hp0SSvpuHfpaluhuyPOLKq+qY5whU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCbg4ETSZs7xkxQgunbkp1egLKfl4XR7NcdCOBE6MSABexXImz5W5r1Riy57iE/mG/xtU5VgCwpntTtOYz5TlCU3DDV8a14gI8+nsJkn2FcIdppygECOlilTjBous2APX3tvHDtyWIhDy+wvyaTBVXm4lxg1okqOSMqE9bkJM1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=L1htHe4x; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="L1htHe4x"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48EDRC3a018796;
	Sat, 14 Sep 2024 17:42:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=U76+Y92+6cnP9XFTsniXm+oVV04
	feYHa4KALmWM53C8=; b=L1htHe4xiPjUW2QZHub0vijPUTnrqeZqme3ThfN96qC
	hmOtDR0KY/wNdKFT/0kv7ziDSxvgvQpMtDWZk7MN71eQtcT9OMslArhlG6sFkRKC
	0EzwEJG45UH6En6Us7aC1UBR5xLZexVy7qMKiq/Z/EQVriG7VAh44w6fcrwncDqo
	8xIG3EnlLsA2bcr/7NeV13on5GNqhYhaH23Dhvkku1KdkDJoX2D9wnPiaXgALchH
	KDGU55tXLoPZR8SDTbmDlr6wGB6flAR12WbWKVKzR4RgS0GcG1Z/wxCUEe/Q2hbN
	Sj3CeGl68TJlXOqKh7wWojsj+MTFdJfrM5c/RKx8zdA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vna827-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 14 Sep 2024 17:42:52 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48EGsulT032355;
	Sat, 14 Sep 2024 17:42:52 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41n3xqaseu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 14 Sep 2024 17:42:51 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48EHgmn947448518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Sep 2024 17:42:48 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F4FC20043;
	Sat, 14 Sep 2024 17:42:48 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A023820040;
	Sat, 14 Sep 2024 17:42:47 +0000 (GMT)
Received: from osiris (unknown [9.179.13.161])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sat, 14 Sep 2024 17:42:47 +0000 (GMT)
Date: Sat, 14 Sep 2024 19:42:46 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 7/7] s390/vdso: Wire up getrandom() vdso implementation
Message-ID: <20240914174246.8394-A-hca@linux.ibm.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <20240913130544.2398678-8-hca@linux.ibm.com>
 <ZuRWmJTWqmD92D8d@zx2c4.com>
 <ZuRYoVIrg28kBKqb@zx2c4.com>
 <20240913173206.30385-C-hca@linux.ibm.com>
 <ZuSRKLFdYI1gCHh9@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuSRKLFdYI1gCHh9@zx2c4.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: B2CQxQX1rtAf2iSdA3GJe8w-ZW1zjE1L
X-Proofpoint-GUID: B2CQxQX1rtAf2iSdA3GJe8w-ZW1zjE1L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-14_09,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409140123

On Fri, Sep 13, 2024 at 09:23:20PM +0200, Jason A. Donenfeld wrote:
> > > >   CC       vdso_test_chacha
> > > > /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/arch/s390/vdso/vgetrandom-chacha.S: Assembler messages:
> > > > /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/arch/s390/vdso/vgetrandom-chacha.S:147: Error: Unrecognized opcode: `alsih'
> > > > 
> > > > Any idea what's up?
> > > 
> > > Looks like I needed `-march=arch9`. I can potentially rebuild my
> > > toolchains to do this by default, though, if that's a normal thing to
> > > have and this is just my toolchain being crappy. Or, if it's not a
> > > normal thing to have, do we need to add it to the selftests Makefile?
> > 
> > That needs to be fixed differently, since the kernel build would also
> > fail when building for z10. Could you squash the below fix into this
> > patch, please?
> 
> Done.
> 
> > So for the kernel itself including the vdso code, everything is
> > correct now. But similar checks are missing within vdso_test_chacha.c.
> > I'll provide something for that, so that the test case will be skipped
> > if the required instructions are missing, but not today.
> 
> Okay. I would assume no rush there, because it's unlikely there are
> those machines part of kselftest fleets anyway?

There was another surprise waiting for me: the ALTERNATIVE macro
within the tools header file is defined in a way that it omits
everything. So I was just lucky that the s390 chacha assembler code
worked, since even without the alternatives the code is working, but
executes code for newer CPU generations, which it shouldn't.

So below is a diff which fixes both:

- Add an s390 specific ALTERNATIVE macro that emits code that is
  supposed to work on older CPU generations, instead of no code

- Add a hwcap check to make sure that all CPU capabilities required to
  run the assembler code are present

It probably makes sense to squash this also into
"s390/vdso: Wire up getrandom() vdso implementation".

Please feel free to change the code in whatever way you like.
If you prefer separate patches, I will provide them.

diff --git a/tools/include/asm/alternative.h b/tools/include/asm/alternative.h
index 7ce02a223732..68dc894c0892 100644
--- a/tools/include/asm/alternative.h
+++ b/tools/include/asm/alternative.h
@@ -2,8 +2,18 @@
 #ifndef _TOOLS_ASM_ALTERNATIVE_ASM_H
 #define _TOOLS_ASM_ALTERNATIVE_ASM_H
 
+#if defined(__s390x__)
+#ifdef __ASSEMBLY__
+.macro ALTERNATIVE oldinstr, newinstr, feature
+	\oldinstr
+.endm
+#endif
+#else
+	
 /* Just disable it so we can build arch/x86/lib/memcpy_64.S for perf bench: */
 
 #define ALTERNATIVE #
 
 #endif
+
+#endif
diff --git a/tools/testing/selftests/vDSO/vdso_test_chacha.c b/tools/testing/selftests/vDSO/vdso_test_chacha.c
index e81d72c9882e..f1eace68a63b 100644
--- a/tools/testing/selftests/vDSO/vdso_test_chacha.c
+++ b/tools/testing/selftests/vDSO/vdso_test_chacha.c
@@ -5,11 +5,34 @@
 
 #include <tools/le_byteshift.h>
 #include <sys/random.h>
+#include <sys/auxv.h>
 #include <string.h>
 #include <stdint.h>
 #include <stdbool.h>
 #include "../kselftest.h"
 
+#if defined(__s390x__)
+
+#ifndef HWCAP_S390_VX
+#define HWCAP_S390_VX 2048
+#endif
+
+static bool cpu_has_capabilities(void)
+{
+	if (getauxval(AT_HWCAP) & HWCAP_S390_VX)
+		return true;
+	return false;
+}
+
+#else
+
+static bool cpu_has_capabilities(void)
+{
+	return true;
+}
+
+#endif
+
 static uint32_t rol32(uint32_t word, unsigned int shift)
 {
 	return (word << (shift & 31)) | (word >> ((-shift) & 31));
@@ -67,6 +90,8 @@ int main(int argc, char *argv[])
 	uint8_t output1[BLOCK_SIZE * BLOCKS], output2[BLOCK_SIZE * BLOCKS];
 
 	ksft_print_header();
+	if (!cpu_has_capabilities())
+		ksft_exit_skip("Required CPU capabilities missing\n");
 	ksft_set_plan(1);
 
 	for (unsigned int trial = 0; trial < TRIALS; ++trial) {
