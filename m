Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DB231A89;
	Thu,  5 Sep 2024 02:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725503959; cv=none; b=iuMSTOpAsz8ySAyGohtCUCPHvF8hAHEyUuM2BySLCLdXP1xOYhBPfUfv6mbSH9BxpLSPAsXBqnqmakSWzPhIjLN19yvOZ6mIXSGjPToSU7PViT7WQ7TpnI2ycIzn8qdVD20U/NHcDgtUOIloEKVTpO8SmtZqyGdqPr4nqiKQkE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725503959; c=relaxed/simple;
	bh=t5gUN35NyAQwJ+VAaM9GAaq6Wc8eeeUyKamvEH7jRFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzZZ56C2QUjvxv+u+u1vDINzq2IKclcK3ZaguwgqQU0bfd/Bt09FfE+3GEIwFLgGW4Ai+UiEWaULiFq/Ms6EUzZRxWlYWUZaYUBs9jQbyrJ6k5d+NkcHc6biy2rMScIix3Z/CSEkDTBMfGk/84THJ+AT7DsGDT5eou6do1yaRss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sWFdpdyE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sWFdpdyE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=C7UaHnFcfniqQHIyC+R8XhyfgLVAne22VB9LaJURPcc=; b=sWFdpdyEafedT2UGJdR/z9PBVg
	qXERqE0XXZAy24H8J9MN60yaM/yA4ZiaaopipyZ6Y/H2NItu3BIzH3dJ1no2cABcqZFwtTmKHCj+/
	USDY6DC3T69sm+jb87l60HaZyNeIuQ5GlVhkR/j2rA1I/fvoh3qVudTtSFsZB++r/X+rJ/V9OxTL5
	7JnOVSDyNQgaWdqbhmbL3B7fTnfwIwjqkr2zM7WJvdnQ+bjfvtLpoZR6NlmzOVHACplRXg4vKvb1D
	sypwOT8ISGkStDLbtWO7B6h/LwcUM9nINLHCO96XXrOYu3A5w2qBjPi8f+SMrkKtThlqwb+SdYoUh
	DqOIiP/Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sm1yB-000DLc-1D;
	Thu, 05 Sep 2024 10:21:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Sep 2024 10:21:49 +0800
Date: Thu, 5 Sep 2024 10:21:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: octeontx* - Select CRYPTO_AUTHENC
Message-ID: <ZtkVvQfNrtZvmbsm@gondor.apana.org.au>
References: <202409042013.gT2ZI4wR-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202409042013.gT2ZI4wR-lkp@intel.com>

On Wed, Sep 04, 2024 at 08:22:57PM +0800, kernel test robot wrote:
>
> All errors (new ones prefixed by >>):
> 
>    s390-linux-ld: drivers/crypto/marvell/octeontx/otx_cptvf_algs.o: in function `otx_cpt_aead_cbc_aes_sha_setkey':
> >> otx_cptvf_algs.c:(.text+0x1daa): undefined reference to `crypto_authenc_extractkeys'
>    s390-linux-ld: drivers/crypto/marvell/octeontx/otx_cptvf_algs.o: in function `otx_cpt_aead_ecb_null_sha_setkey':
>    otx_cptvf_algs.c:(.text+0x1e12): undefined reference to `crypto_authenc_extractkeys'

---8<---
Select CRYPTO_AUTHENC as the function crypto_authenec_extractkeys
may not be available without it.

Fixes: 311eea7e37c4 ("crypto: octeontx - Fix authenc setkey")
Fixes: 7ccb750dcac8 ("crypto: octeontx2 - Fix authenc setkey")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202409042013.gT2ZI4wR-lkp@intel.com/

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index a48591af12d0..78217577aa54 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -28,6 +28,7 @@ config CRYPTO_DEV_OCTEONTX_CPT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH
 	select CRYPTO_AEAD
+	select CRYPTO_AUTHENC
 	select CRYPTO_DEV_MARVELL
 	help
 		This driver allows you to utilize the Marvell Cryptographic
@@ -47,6 +48,7 @@ config CRYPTO_DEV_OCTEONTX2_CPT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH
 	select CRYPTO_AEAD
+	select CRYPTO_AUTHENC
 	select NET_DEVLINK
 	help
 		This driver allows you to utilize the Marvell Cryptographic
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
