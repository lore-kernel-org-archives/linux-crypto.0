Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E649216C854;
	Tue, 10 Sep 2024 09:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725960643; cv=none; b=mpRtg8obUlT7yoryXI1jAPUTFpmot4LtcC0Lh4A73NnvFFldg32Zrr9G7XfoasuC2Q5e0oQRNlwjMyFuOXtjuf4t8aHCUZsKDsAP3o5Dm3VhozW7wLni2L/TPKn22/X2X4m1ACoAB+N2zMmtHMFVidyiF2voBc1Sjo08q+slhW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725960643; c=relaxed/simple;
	bh=P22qfW3/nowovXkhFrt2C3XOu/zwhHSpH61Vp/lcy5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ok9EouKP6dUC8CGb5dvczfaii5bzJv7W7qPBMW/yohpp8VJX56FG8I1cNiO7gTkNyXtmu0HWhWB5U/LGDpYVqSmegaf0rND+CHU+cQ0I4kv45vRNSERluk4Rjg1g3DbKCAVbi+tjsHazLKShkA9XIz2rQH6hH0JUZCNvuldSfiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DuF+t3xd; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DuF+t3xd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7vTWtWLYV3y3lWPAmfSRMP2q53xf73IcQM16aSUWQ5w=; b=DuF+t3xdILUKaI4/h4AjD4rLaH
	N7VzbRg3QcFMDJrd2QsTc6ShZU/2CexWQAzfNZfB/1m+9OOTjQFwisRLZFtyH/TR0h9KKAKJQpxyX
	t/UBz/I3QHtUNHkEvDuh+2kTaaejgTUamOnmTDFBndZ/qCOg5lmDwZG95cG5EnD2eqkhmYxWTJUO5
	Bj66gRkSkW2zlIyC6xt1cevazFJpc2e2i2F0OBPSxixZA9ftcQ8zo9jjfXH4mrHEc/QryOwlbc8ox
	jTFiK36ulK4M58cvcRq08RX2SKI8NmaXL4hk5N9XvA5t5VqyY//n4k8iCHPhtqHJsbTxzdbSWtOIR
	xuXtPqzw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1snx2g-001Oow-1x;
	Tue, 10 Sep 2024 17:30:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Sep 2024 17:30:24 +0800
Date: Tue, 10 Sep 2024 17:30:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: n2 - Set err to EINVAL if snprintf fails for hmac
Message-ID: <ZuARsOuhqFvIZkc0@gondor.apana.org.au>
References: <ae2cfe53-7d2a-408b-8b18-af880d1974cc@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae2cfe53-7d2a-408b-8b18-af880d1974cc@stanley.mountain>

On Tue, Sep 10, 2024 at 12:17:45PM +0300, Dan Carpenter wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   89f5e14d05b4852db5ecdf222dc6a13edc633658
> commit: 8c20982caca4b10ca79aea8134a16ea98989ca03 crypto: n2 - Silence gcc format-truncation false positive warnings
> config: sparc-randconfig-r071-20240908 (https://download.01.org/0day-ci/archive/20240909/202409090726.TP0WfY7p-lkp@intel.com/config)
> compiler: sparc64-linux-gcc (GCC) 14.1.0
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202409090726.TP0WfY7p-lkp@intel.com/
> 
> smatch warnings:
> drivers/crypto/n2_core.c:1406 __n2_register_one_hmac() error: uninitialized symbol 'err'.

---8<---
Return EINVAL if the snprintf check fails when constructing the
algorithm names.

Fixes: 8c20982caca4 ("crypto: n2 - Silence gcc format-truncation false positive warnings")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202409090726.TP0WfY7p-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index f4022d845393..eeef285277ed 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1375,6 +1375,7 @@ static int __n2_register_one_hmac(struct n2_ahash_alg *n2ahash)
 	ahash->setkey = n2_hmac_async_setkey;
 
 	base = &ahash->halg.base;
+	err = -EINVAL;
 	if (snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "hmac(%s)",
 		     p->child_alg) >= CRYPTO_MAX_ALG_NAME)
 		goto out_free_p;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
