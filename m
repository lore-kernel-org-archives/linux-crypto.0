Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D752149C55;
	Wed,  7 May 2025 01:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746582123; cv=none; b=aBz3Vuzrdx4s58QjDG3pscCblSToyzfJNSGDYKg0K+E53U7IgKPtDu36LJM5gHwqpOHK0Pov9fgTwgf24UlXbhJc7VW5+D1xL3FaKslxseELTsixgCgKjnErLiUg+gEjBohFHrQvCtdLQlZhhHtxlmNQlIr5N9ceHMRJNtwWYgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746582123; c=relaxed/simple;
	bh=qs4Q9hRdyQqHCJ/m3kq7Qdz4g8t65SKuAV3aUXmA3RY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a235a5yMrCscu0aSrQBN93b4yO8DfIH8/v/gi4U8l4GQmTjgu/EpJRIFtKoKP1NEo7SFzuXlXOcEopgN+/PIg827umeOdz6QLFM2MIKDwMn+y72DxTAs33ZS8UcXAgeyDdCzxiGN3cfKtJJaYGrDW+FN2SvlzjsFnQ4Q3j1t6gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OddfQllT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OddfQllT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1LAjmB/BuVJhNma0CNS0ZtI4c20tsdSol77PmLcH6eY=; b=OddfQllTz1VCGdH1DC80AhtUTj
	U6FW8c5ZWAC7ure5nx1gtrPgd+TAmQb0hJHi3p6QbulxogVmqvMk2UcXWtJfcX5y/oitHXbM0ht7o
	uiGxNKho6OzxhM7bFJ03FWds1Ys8eMFKI3KE4B+8irwgZTkc20jajPvfTmf+tImmK6SZl8jVjhLC2
	wM4EsuTBCbDoLdpBCOmCm3ktcwHMZt5Anvx8qqwT1Tgeh9XJwRYEfVvukbDNjeb8wUgVDwwIiJswp
	P4XSNQD3c6JRR/QhO3nrFuu7q0YNaZNpJVa7FZKmITCdKoOT07xxZAffA4KrU6xiO24RjMviJhLgZ
	JKAxbzpQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uCTnD-0046hM-2g;
	Wed, 07 May 2025 09:41:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 May 2025 09:41:51 +0800
Date: Wed, 7 May 2025 09:41:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-crypto@vger.kernel.org, Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org
Subject: [PATCH] um: Include linux/types.h in asm/fpu/api.h
Message-ID: <aBq6X-UYlQG9HUQd@gondor.apana.org.au>
References: <202505070045.vWc04ygs-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202505070045.vWc04ygs-lkp@intel.com>

On Wed, May 07, 2025 at 12:25:45AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   9b9d4ef0cf750c514735bfd77745387b95cbddda
> commit: 5b90a779bc547939421bfeb333e470658ba94fb6 [50/70] crypto: lib/sha256 - Add helpers for block-based shash
> config: um-randconfig-001-20250506 (https://download.01.org/0day-ci/archive/20250507/202505070045.vWc04ygs-lkp@intel.com/config)
> compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250507/202505070045.vWc04ygs-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202505070045.vWc04ygs-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from lib/crypto/sha256.c:14:
>    In file included from include/crypto/internal/sha2.h:6:
>    In file included from include/crypto/internal/simd.h:9:
>    In file included from arch/x86/include/asm/simd.h:5:
> >> arch/um/include/asm/fpu/api.h:14:15: error: unknown type name 'bool'
>       14 | static inline bool irq_fpu_usable(void)
>          |               ^
> >> arch/um/include/asm/fpu/api.h:16:9: error: use of undeclared identifier 'true'
>       16 |         return true;
>          |                ^
>    2 errors generated.

I'll add this to the crypto tree if it's OK with the UML maintainers.

Thanks,

---8<---
Include linux/types.h before using bool.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505070045.vWc04ygs-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/um/include/asm/fpu/api.h b/arch/um/include/asm/fpu/api.h
index 71bfd9ef3938..3abf67c83c40 100644
--- a/arch/um/include/asm/fpu/api.h
+++ b/arch/um/include/asm/fpu/api.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_UM_FPU_API_H
 #define _ASM_UM_FPU_API_H
 
+#include <linux/types.h>
+
 /* Copyright (c) 2020 Cambridge Greys Ltd
  * Copyright (c) 2020 Red Hat Inc.
  * A set of "dummy" defines to allow the direct inclusion
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
