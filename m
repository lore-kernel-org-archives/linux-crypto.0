Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C2E22DF95;
	Fri, 16 May 2025 08:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747385186; cv=none; b=aOOFlQb6yU6TpqEfov09tR7tfUJUfcLJ70scLUAImxYIeJbIFt9pI8eVIDcvsUbYWg5Zu5cSFXl9sjZc5doPglGDis0zyvC2wVVbGIJ5wACYOxGJgHryQFJuPXxnN4vulbmIOzSYMfbth27S3n094t5EDUmZbXPWlWp0XhCO1eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747385186; c=relaxed/simple;
	bh=SkjQSxNeU2OHOXF+ESEbWRVOyvYvbZPEB7pgJ4QXGcA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKgNPtCOD3nHarGnItU1a6rr1f038E4Bn0K+qlpwYHNNimrs0TmxABc/6xJDL6HLZSrBWPGGQoba4pa63jZ9H2Hmqc+EwNsLJOH0eYJ4pz1DmnbfnanDNitWxyJKTePHlLuJNavGssUCn5axg7hSiOIMWQGKKJCZQmjjTMrDGk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=c3sNC6+d; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="c3sNC6+d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=632mvGumOaKkY1p9t4Qs3NLLv5XO+fTtmBWPXtqhGQc=; b=c3sNC6+dF6eci78NbJHi/7PQwf
	Ivk7Iz5nrHYp9Z4TUZ4Jut7lIBPRH/8a8ngd6RzQOP6Br7KbC0BZwvQATxMxAc63oCr1cvWigLVtT
	HH+tp6+9IsNpUlJC/LkPh/p9Bzlm8PkXDopxAwFwjqpRp6VEMMATRsaDNCH8xZmT0WaZpMzJuFgym
	4uHJ2SNeKmcg3aAa5R882fEAXG3tPtRA2HXqK4OF8nF9a6aYpzyDEsZiqlvxjmiuI10IMNcBM9kzE
	jwrFI5vbr2Q+g3+SLQ6jofSNFSVnVCjpA/IF6cpJaFsIBgCyP+3oqoqJ7eR34aPoJSrGewT8apHFk
	ATnzgf2g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFqht-006XZO-06;
	Fri, 16 May 2025 16:46:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 May 2025 16:46:17 +0800
Date: Fri, 16 May 2025 16:46:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Danny Tsen <dtsen@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] powerpc: Add gcc 128-bit shift helpers
Message-ID: <aCb7WW2gRrtEmgqD@gondor.apana.org.au>
References: <202505152053.FrKekjCe-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202505152053.FrKekjCe-lkp@intel.com>

On Thu, May 15, 2025 at 08:06:09PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   484803582c77061b470ac64a634f25f89715be3f
> commit: c66d7ebbe2fa14e41913adb421090a7426f59786 [10914/11408] crypto: powerpc/poly1305 - Add SIMD fallback
> config: powerpc64-randconfig-002-20250515 (https://download.01.org/0day-ci/archive/20250515/202505152053.FrKekjCe-lkp@intel.com/config)
> compiler: powerpc64-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250515/202505152053.FrKekjCe-lkp@intel.com/reproduce)

Thanks for the report.  This patch should fix the problem.

---8<---
When optimising for size, gcc generates out-of-line calls for 128-bit
integer shifts.  Add these functions to avoid build errors.

Fixes: c66d7ebbe2fa ("crypto: powerpc/poly1305 - Add SIMD fallback")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505152053.FrKekjCe-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

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
index 000000000000..79afef2d8d54
--- /dev/null
+++ b/arch/powerpc/lib/tishift.S
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2025 Herbert Xu <herbert@gondor.apana.org.au>
+ */
+#include <asm/ppc_asm.h>
+#include <linux/export.h>
+
+_GLOBAL(__lshrti3)
+	cmplwi	r5,63
+	ble	1f
+	addi	r5,r5,-64
+	srd	r3,r4,r5
+	li	r4,0
+	blr
+1:
+	subfic	r7,r5,64
+	srd	r3,r3,r5
+	sld	r6,r4,r7
+	srd	r4,r4,r5
+	or	r3,r3,r6
+	blr
+EXPORT_SYMBOL(__lshrti3)
+
+_GLOBAL(__ashrti3)
+	cmplwi	r5,63
+	ble	1f
+	addi	r5,r5,-64
+	srad	r3,r4,r5
+	sradi	r4,r4,63
+	blr
+1:
+	subfic	r7,r5,64
+	srd	r3,r3,r5
+	sld	r6,r4,r7
+	srad	r4,r4,r5
+	or	r3,r3,r6
+	blr
+EXPORT_SYMBOL(__ashrti3)
+
+_GLOBAL(__ashlti3)
+	cmplwi	r5,63
+	ble	1f
+	addi	r5,r5,-64
+	sld	r4,r3,r5
+	li	r3,0
+	blr
+1:
+	subfic	r7,r5,64
+	sld	r4,r4,r5
+	srd	r6,r3,r7
+	sld	r3,r3,r5
+	or	r4,r4,r6
+	blr
+EXPORT_SYMBOL(__ashlti3)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
