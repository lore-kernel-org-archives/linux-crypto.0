Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4781F60A;
	Mon, 24 Feb 2025 03:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740367744; cv=none; b=IOOny9Mul6pr/GiMttGQBw+ErJ4CXHvkqQR9fe3kU9EHnRamKrnssE29k0xRFvM74qYQezZkXDVu2/Kq8NL5dGpJ4he+yjHyVFcnXDYsCjjqwA7y+5rGlrKdi2t/K6VMGa/WRIzjqbzCHzgRrZL6Vf7jkNiLDzwpqMMt5VeUUWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740367744; c=relaxed/simple;
	bh=2mqKbcc+CSbHaEe5AIwCO0kQq0wY33vfEcIZFDx2NrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CuRoaMIgcZr+xagTLSDCVjtwgNqiCh1XjhUA8FSFl+Bd8L8RzrDoYBgHoRs5RgJsVv8VkXL3YZCZp4iFmrhEGpA0wg7O0C5gvbs9HX5HD4WHHmR6T12EGcfdfUoK5TIEi+qLhZmzh/wZS5NgniejdigffF6hIvXN64hiOejRH5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fWZi0lnb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fWZi0lnb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lmP2ZYdiXnCYtSypWQcLeVaulSsOYWP7qbwMULUDULE=; b=fWZi0lnbkMqDM2dYcOzbwYPrv1
	2RsBRX4G2HwujqYbEk7dSuTZT9XN/vt00guYYUgIILJCIoM7E7NkVcd6uyC43Fg4mwkuOAAGI48IZ
	CX5NoX1BLMbpwYmpBJ6R/e/8GkFcelxvlnMRh8Vu76531vxPR1xEm1jfvll/xbyw4Gqm1pO+0sxZJ
	O6vQZ8XSw4Z6kgmq93X/SDP7NqDUf9hg7ewzI7CVV8GuFDzLj17oTtdGQJeqL2yy23SfRAKC4zlpq
	kYSzj4TpYQTgzfN2QH5abH3UJbnjruZp2TNoEgLIuZJtKjvaX9xaobo7ZEmmEalGnz7SbptUF3ezu
	j/LxfSFw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tmP9K-0018nc-28;
	Mon, 24 Feb 2025 11:28:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Feb 2025 11:28:54 +0800
Date: Mon, 24 Feb 2025 11:28:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: lib/Kconfig - Fix lib built-in and modular failure
 for arm64/mips/s390
Message-ID: <Z7vnduYJbRqcQEdm@gondor.apana.org.au>
References: <Z6woN4vgdaywOZxm@gondor.apana.org.au>
 <202502232152.JC84YDLp-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202502232152.JC84YDLp-lkp@intel.com>

On Sun, Feb 23, 2025 at 09:54:55PM +0800, kernel test robot wrote:
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on herbert-cryptodev-2.6/master]
> [also build test ERROR on herbert-crypto-2.6/master linus/master v6.14-rc3 next-20250221]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-lib-Kconfig-Fix-lib-built-in-failure-when-arch-is-modular/20250212-125048
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> patch link:    https://lore.kernel.org/r/Z6woN4vgdaywOZxm%40gondor.apana.org.au
> patch subject: [PATCH] crypto: lib/Kconfig - Fix lib built-in failure when arch is modular
> config: s390-randconfig-r072-20250223 (https://download.01.org/0day-ci/archive/20250223/202502232152.JC84YDLp-lkp@intel.com/config)
> compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250223/202502232152.JC84YDLp-lkp@intel.com/reproduce)

Thanks for the report.  I missed a few architectures in the patch:

---8<---
Some architectures were missed in the ARCH_MAY_HAVE patch, do
the same for them to stop build failures involving modular arch
code and built-in generic code.

Note that this isn't actually a regression since the same build
failure was also possible on these architectures before, just with
a different set of initial configuration options.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502232152.JC84YDLp-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 5636ab83f22a..3d90efdcf5a5 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -29,7 +29,7 @@ config CRYPTO_POLY1305_NEON
 	tristate "Hash functions: Poly1305 (NEON)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
-	select CRYPTO_ARCH_HAVE_LIB_POLY1305
+	select CRYPTO_ARCH_MAY_HAVE_LIB_POLY1305
 	help
 	  Poly1305 authenticator algorithm (RFC7539)
 
@@ -190,7 +190,7 @@ config CRYPTO_CHACHA20_NEON
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_CHACHA_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CHACHA
 	help
 	  Length-preserving ciphers: ChaCha20, XChaCha20, and XChaCha12
 	  stream cipher algorithms
diff --git a/arch/mips/crypto/Kconfig b/arch/mips/crypto/Kconfig
index 7decd40c4e20..cbeb2f62eb79 100644
--- a/arch/mips/crypto/Kconfig
+++ b/arch/mips/crypto/Kconfig
@@ -5,7 +5,7 @@ menu "Accelerated Cryptographic Algorithms for CPU (mips)"
 config CRYPTO_POLY1305_MIPS
 	tristate "Hash functions: Poly1305"
 	depends on MIPS
-	select CRYPTO_ARCH_HAVE_LIB_POLY1305
+	select CRYPTO_ARCH_MAY_HAVE_LIB_POLY1305
 	help
 	  Poly1305 authenticator algorithm (RFC7539)
 
@@ -55,7 +55,7 @@ config CRYPTO_CHACHA_MIPS
 	tristate "Ciphers: ChaCha20, XChaCha20, XChaCha12 (MIPS32r2)"
 	depends on CPU_MIPS32_R2
 	select CRYPTO_SKCIPHER
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CHACHA
 	help
 	  Length-preserving ciphers: ChaCha20, XChaCha20, and XChaCha12
 	  stream cipher algorithms
diff --git a/arch/s390/crypto/Kconfig b/arch/s390/crypto/Kconfig
index b760232537f1..6f7495264943 100644
--- a/arch/s390/crypto/Kconfig
+++ b/arch/s390/crypto/Kconfig
@@ -112,7 +112,7 @@ config CRYPTO_CHACHA_S390
 	depends on S390
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_CHACHA_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CHACHA
 	help
 	  Length-preserving cipher: ChaCha20 stream cipher (RFC 7539)
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
