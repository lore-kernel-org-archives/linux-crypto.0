Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F632CA9;
	Sat, 17 May 2025 01:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747446657; cv=none; b=GWQAAdOMyslV+BbZfkONpDtm7ONh3ARHHvm/cvX1LQcYFB8NZm6/BDZUPt6O8Rit2kvdylGRoJphjDca5s5yg50+rMp+6MjlrXxev8n46JuEs0xpn8p+p8S6jkluORjbEgmu0m4tTEs8VebbfdBpLVRimsBFOfqQ7TzHi3np96U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747446657; c=relaxed/simple;
	bh=kWEqnvh96du7d+Zs/PEPLq24WcirQFult4+44G9wPEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BXOj5wcwbPojGrfwFa+HIPr9Ex/m7+Av2jzZpIXDTPo4qgufi3G7Odqj9SXs4LjCxdXXHZxTw1cTqxQoOLddc+Irg/6+nLC2Yep5mIqeojKT9vx4ZZ5lIwvzx5gFBa0cy/YStaEPJtOGQpWJr7s8lWmDWZpVT/r/hJWDmM712dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZIgGx0Lm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZIgGx0Lm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UXb6LPirWZPeGfwUPWZJ+mkDqLNt13DgEKjkP7gfTRg=; b=ZIgGx0LmludT6ZEHkKfmw0k6Cj
	lF4lirTVzW1/mMBvBxIFSEPn41NBWfVLh7z684v/EAtddcfiBBwNP8VTyCJ0NFq1ixC9uqIZGaXHl
	BCszg06h0eEOhMfRYUz6RLMcl9OBZrfSpIMa4kgCO1MJ8fILcF/JavJhEJsAdSTXHKBuR7W/qoTxF
	258OwDuRSVw0Hou1pjj1BXW8KY/u1HplLmuJLUcXAmu0q4WWsxYAZpnHVQALgbtTLO4wj6jZ+LTM/
	vZvzmFoHKqqI7Lff64IIkaL2J5BMYMPpQ9puhhgyRsp0IUaNlYikcrvjjuAbayBhxRelDPFnV0jXp
	QQl4luiQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uG6hE-006jky-08;
	Sat, 17 May 2025 09:50:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 May 2025 09:50:40 +0800
Date: Sat, 17 May 2025 09:50:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gabriel Paubert <paubert@iram.es>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Danny Tsen <dtsen@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [v2 PATCH] powerpc: Add gcc 128-bit shift helpers
Message-ID: <aCfrcNFYIWJruP4G@gondor.apana.org.au>
References: <202505152053.FrKekjCe-lkp@intel.com>
 <aCb7WW2gRrtEmgqD@gondor.apana.org.au>
 <aCccToR_71ETmPd-@lt-gp.iram.es>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCccToR_71ETmPd-@lt-gp.iram.es>

On Fri, May 16, 2025 at 01:06:54PM +0200, Gabriel Paubert wrote:
> 
> It won't work for big endian, nor for 32 bit obviously.

Good catch, I will restrict the Kconfig option to little-endian.
The accelerated crypto code which uses this is already restricted
to little-endian anyway.

The Kconfig option is also dependent on PPC64 so 32-bit shouldn't
be a problem.

> Besides that, in arch/power/kernel/misc_32.S, you'll find a branchless
> version of these functions. It's for 64 bit shifts on 32 bit big-endian
> but it can easily be adapted to 128 bit shifts on 64 bit processors
> (swapping r3 and r4 depending on endianness).

Nice.  I've replaced the shift code with one based on misc_32.S.

> Several functions of kernel/misc_32.S should arguably be moved to lib/.

I'll leave that to someone else :)

Thanks,

---8<---
When optimising for size, gcc generates out-of-line calls for 128-bit
integer shifts.  Add these functions to avoid build errors.

Also restrict ARCH_SUPPORTS_INT128 to little-endian since the only
user that prompted this poly1305 only supports that.

Fixes: c66d7ebbe2fa ("crypto: powerpc/poly1305 - Add SIMD fallback")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://urldefense.com/v3/__https://lore.kernel.org/oe-kbuild-all/202505152053.FrKekjCe-lkp@intel.com/__;!!D9dNQwwGXtA!TSuOAutxjuD3Hp-RC0Fw9dTNuagdCKeNLTN71tv_OmhUxyAPLfIfwwpZop5pKFXgS4Jfkt830_tEMkbo7rsvYg$ 
Suggested-by: Gabriel Paubert <paubert@iram.es>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 651e0c32957a..7a7d39fa8b01 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -173,7 +173,7 @@ config PPC
 	select ARCH_STACKWALK
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC	if PPC_BOOK3S || PPC_8xx
-	select ARCH_SUPPORTS_INT128		if PPC64 && CC_HAS_INT128
+	select ARCH_SUPPORTS_INT128		if PPC64 && CC_HAS_INT128 && CPU_LITTLE_ENDIAN
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF		if PPC64
 	select ARCH_USE_MEMTEST
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 1cd74673cbf7..a41c071c1652 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -87,3 +87,5 @@ obj-$(CONFIG_CRC_T10DIF_ARCH) += crc-t10dif-powerpc.o
 crc-t10dif-powerpc-y := crc-t10dif-glue.o crct10dif-vpmsum_asm.o
 
 obj-$(CONFIG_PPC64) += $(obj64-y)
+
+obj-$(CONFIG_ARCH_SUPPORTS_INT128) += tishift.o
diff --git a/arch/powerpc/lib/tishift.S b/arch/powerpc/lib/tishift.S
new file mode 100644
index 000000000000..f63748b5e1c5
--- /dev/null
+++ b/arch/powerpc/lib/tishift.S
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 1995-1996 Gary Thomas (gdt@linuxppc.org)
+ * Largely rewritten by Cort Dougan (cort@cs.nmt.edu)
+ * and Paul Mackerras.
+ * Copyright (c) 2025 Herbert Xu <herbert@gondor.apana.org.au>
+ */
+#include <asm/ppc_asm.h>
+#include <linux/export.h>
+
+_GLOBAL(__lshrti3)
+	subfic	r6,r5,64
+	srd	r3,r3,r5	# LSW = count > 63 ? 0 : LSW >> count
+	addi	r7,r5,-64	# could be xori, or addi with -64
+	sld	r6,r4,r6	# t1 = count > 63 ? 0 : MSW << (64-count)
+	srd	r7,r4,r7	# t2 = count < 64 ? 0 : MSW >> (count-64)
+	or	r3,r3,r6	# LSW |= t1
+	srd	r4,r4,r5	# MSW = MSW >> count
+	or	r3,r3,r7	# LSW |= t2
+	blr
+EXPORT_SYMBOL(__lshrti3)
+
+_GLOBAL(__ashrti3)
+	subfic	r6,r5,64
+	srd	r3,r3,r5	# LSW = count > 63 ? 0 : LSW >> count
+	addi	r7,r5,-64	# could be xori, or addi with -64
+	sld	r6,r4,r6	# t1 = count > 63 ? 0 : MSW << (64-count)
+	rlwinm	r8,r7,0,64	# t3 = (count < 64) ? 64 : 0
+	srad	r7,r4,r7	# t2 = MSW >> (count-64)
+	or	r3,r3,r6	# LSW |= t1
+	sld	r7,r7,r8	# t2 = (count < 64) ? 0 : t2
+	srad	r4,r4,r5	# MSW = MSW >> count
+	or	r3,r3,r7	# LSW |= t2
+	blr
+EXPORT_SYMBOL(__ashrti3)
+
+_GLOBAL(__ashlti3)
+	subfic	r6,r5,64
+	sld	r4,r4,r5	# MSW = count > 64 ? 0 : MSW << count
+	addi	r7,r5,-64	# could be xori, or addi with -64
+	srd	r6,r3,r6	# t1 = count > 63 ? 0 : LSW >> (64-count)
+	sld	r7,r3,r7	# t2 = count < 64 ? 0 : LSW << (count-64)
+	or	r4,r4,r6	# MSW |= t1
+	sld	r3,r3,r5	# LSW = LSW << count
+	or	r4,r4,r7	# MSW |= t2
+	blr
+EXPORT_SYMBOL(__ashlti3)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
