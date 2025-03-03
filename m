Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3073D7D07D;
	Mon,  3 Mar 2025 03:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740971353; cv=none; b=DBlXRhr/vvR9IL6TnH7crJIszei0pTVyAy4WBy1p6sY1ge008VC3AzD6a9YehgmU9JIt0l8pYbQmWg19WES+D5ZnVQ+61h0pAZcztle6Nq35s0/83DdtC62QowOdfwv3J88COW5PH/VwBR0tXLTnvWOr+RlNIKPITPuKmIZnlw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740971353; c=relaxed/simple;
	bh=mmSdeK7rq8zzv6mvWcYfCdQ5gn8CB90QPE8DeZbS2NM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i2O864/Pp1iGL5D+exn6MW02IRVTtibl6HBPPRccDmaOaxS5eIZsh2DBJmRLDAms17ehw09oVI4Dyj5rQJ1KKONtDvfUPoFnFG1J0S2P/Y6dNrVWKVNg9thtKdIvGjkBQDeLj+PVq6F8SaCcAuc98SX+p6P4YSJDo8inZmO9coE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MsCvzKqc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MsCvzKqc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kY8SnBFX/nVMFquTrAknc4uVv/ftwrr+N6hxU4RK6zA=; b=MsCvzKqcPKeFcMEhchuCsS87KP
	Z5bA5UFGeSmMq3qStEM9sEPi8YOaGdA2bhGg8ioXM2lAgwHxpVrdY9/DUUd10d0Zh4+W+NOGRcRQX
	wddgFzrvTY0B4UepQm639zWs9mQAsEdi3cC/VXXqRpw8JS2Dq/JasUsmlAjax+8onZnLBKRyYFBv3
	W+UOyZl3+Mpz8sPChKxGcMZEBaPJpXWoAyxGVskkMlEqaYmJpcJ2hxGXrY/sohsmV+Dphp8LwVhfO
	JsubmE/MvuTww4awn4VIMegWE7bn3uqz92B744X8FNy6J3WjCSE0QgHS3Bxp6XFbTbmZFjxR3VUyG
	jiZBybYQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1towB0-003Ac0-0r;
	Mon, 03 Mar 2025 11:09:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 03 Mar 2025 11:09:06 +0800
Date: Mon, 3 Mar 2025 11:09:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: Kconfig - Select LIB generic option
Message-ID: <Z8UdUoaKtDKzgPph@gondor.apana.org.au>
References: <202503022113.79uEtUuy-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202503022113.79uEtUuy-lkp@intel.com>

On Sun, Mar 02, 2025 at 09:24:49PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   17ec3e71ba797cdb62164fea9532c81b60f47167
> commit: 17ec3e71ba797cdb62164fea9532c81b60f47167 [80/80] crypto: lib/Kconfig - Hide arch options from user
> config: arm-randconfig-002-20250302 (https://download.01.org/0day-ci/archive/20250302/202503022113.79uEtUuy-lkp@intel.com/config)
> compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project 14170b16028c087ca154878f5ed93d3089a965c6)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250302/202503022113.79uEtUuy-lkp@intel.com/reproduce)

---8<---
Select the generic LIB options if the Crypto API algorithm is
enabled.  Otherwise this may lead to a build failure as the Crypto
API algorithm always uses the generic implementation.

Fixes: 17ec3e71ba79 ("crypto: lib/Kconfig - Hide arch options from user")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503022113.79uEtUuy-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202503022115.9OOyDR5A-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 80f18db4d02f..e7118dc32b44 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -320,6 +320,7 @@ config CRYPTO_ECRDSA
 config CRYPTO_CURVE25519
 	tristate "Curve25519"
 	select CRYPTO_KPP
+	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_LIB_CURVE25519_INTERNAL
 	help
 	  Curve25519 elliptic curve (RFC7748)
@@ -618,6 +619,7 @@ config CRYPTO_ARC4
 
 config CRYPTO_CHACHA20
 	tristate "ChaCha"
+	select CRYPTO_LIB_CHACHA_GENERIC
 	select CRYPTO_LIB_CHACHA_INTERNAL
 	select CRYPTO_SKCIPHER
 	help
@@ -939,6 +941,7 @@ config CRYPTO_POLYVAL
 config CRYPTO_POLY1305
 	tristate "Poly1305"
 	select CRYPTO_HASH
+	select CRYPTO_LIB_POLY1305_GENERIC
 	select CRYPTO_LIB_POLY1305_INTERNAL
 	help
 	  Poly1305 authenticator algorithm (RFC7539)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
