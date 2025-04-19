Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC173594F;
	Sat, 19 Apr 2025 02:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745030540; cv=none; b=diQwgcWQUGBV7PqWJBinSFytWjc+Hjkupl/Ryr2y59gDe9hlxyuepWQgX+Bhjistvj+j37AvOq7kHpWMljzo3GXkEh8oY33hPBAB4fAoX1snhiTspG7pxd/1hQqq4V+smPBdModS4tTlcMJhP++nJKjIeGS4p+e1OE0y/AU6yo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745030540; c=relaxed/simple;
	bh=O70Fe4nWsPE5GrjuxU3+DdiZix3p9hrTKNu9yKAiNeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nO5DuzOvOutMeBDcMk8rv3LFZianWD97rF0Uk3QybiNbOJ8IliwDyS76lfTM3mga7a+aaomXzTbY1v+hCtYMhoQyR8ECLu9tHyrS2ifaN705obA1/7pmSlcVQiBzBkRh19BmeBQzCPqzQWr+DWv9T2HEJzqgv6MKqqE2xVMQuUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rj8qau1h; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rj8qau1h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VFh3etk7Y1gkSj0y1vBh9MGzQHxAzz6+0ZbtugdzeuQ=; b=rj8qau1hxx/U5JXwP97mOY6FdB
	NkEvutUn5BtmgJ9btQIkHxwZWSfqgnDFxFp/zMRt7hkJuIHU/RdXHhZn05ms4g+lElWGjzu3Lsqb4
	nYb6Ww18zQ5meWeiEL14div/C0YpKjO6iC7oBNdI1i1HQr4XynrQJXyKJLnVXq83hkJ6snLRnOsC2
	xsjLxJIxoEx6IuHbKf8kdsPL+zOg1Iy0BNb7ciLH7xjD+bhNnZAehnAyBr4makhZwNgXIWAHXZ1Fc
	rTn/3ylOR5zLXyuRdo+FeZ140qHhKf8lEt8v36ssyYot5Ay55VHBYzVEAi4Xz4nl6MzsSuENHgMv9
	RVCaq5eA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5y9l-00Gtvs-1f;
	Sat, 19 Apr 2025 10:42:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Apr 2025 10:42:13 +0800
Date: Sat, 19 Apr 2025 10:42:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <lkp@intel.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	oe-kbuild-all@lists.linux.dev
Subject: Re: [v2 PATCH 27/67] crypto: x86/sha256 - Use API partial block
 handling
Message-ID: <aAMNhS5RNb3ZRwbL@gondor.apana.org.au>
References: <90dc6c4603dbd8fa7ec67baa17471b441ae0ddb8.1744945025.git.herbert@gondor.apana.org.au>
 <202504190545.4Wh9NtX2-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202504190545.4Wh9NtX2-lkp@intel.com>

On Sat, Apr 19, 2025 at 05:56:52AM +0800, kernel test robot wrote:
> Hi Herbert,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on da4cb617bc7d827946cbb368034940b379a1de90]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-shash-Handle-partial-blocks-in-API/20250418-110435
> base:   da4cb617bc7d827946cbb368034940b379a1de90
> patch link:    https://lore.kernel.org/r/90dc6c4603dbd8fa7ec67baa17471b441ae0ddb8.1744945025.git.herbert%40gondor.apana.org.au
> patch subject: [v2 PATCH 27/67] crypto: x86/sha256 - Use API partial block handling
> config: x86_64-buildonly-randconfig-001-20250419 (https://download.01.org/0day-ci/archive/20250419/202504190545.4Wh9NtX2-lkp@intel.com/config)
> compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250419/202504190545.4Wh9NtX2-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202504190545.4Wh9NtX2-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    arch/x86/crypto/sha256_ssse3_glue.c: In function '_sha256_update':
> >> arch/x86/crypto/sha256_ssse3_glue.c:63:9: error: implicit declaration of function 'kernel_fpu_begin' [-Werror=implicit-function-declaration]
>       63 |         kernel_fpu_begin();
>          |         ^~~~~~~~~~~~~~~~

Thanks for the report, I'll fold the following fix-up into the patch.

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 7c5b498c1a85..367ce4830fa4 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -30,6 +30,7 @@
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
 #include <asm/cpu_device_id.h>
+#include <asm/fpu/api.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha2.h>
 #include <crypto/sha256_base.h>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
