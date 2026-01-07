Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D30B79DA;
	Wed,  7 Jan 2026 04:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767758509; cv=none; b=NniaL3hiuhhUFiAeqrEDdkynvx8PCJ5sQhr6vzKPV6Vu2n3PqhlfQrtBHwW8GROnN5qg1Usm5hcCdkumfXphuUJQBihjamC4ILSDtd0hvVw/vqhaiH4ZjDbovid0p709FDixoj6TjN2fQ4EFXq9+T665hMOD4KZ9whfe8V4B/TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767758509; c=relaxed/simple;
	bh=pzuDTI1gGeG5Smd+gX1gaxHlzMDNl358rd8Qrwf1tqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FRIdYaBVLBd0/3UeYpqnvDRzDDcNoewQffl6nEy5YZgvtfAE/wHFrjO6VuOgfWuAbIGtz7dHHCod5dZzGlPJiwY5LjKZvI+Hf5j4gaVTigroEYgWTAhX0lWBu/9KcqwekmaNqXRNiskqdXhZHAeDgEpKeFVjBWiTduxHLUxlHvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7u/AAYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7u/AAYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3E2C4CEF7;
	Wed,  7 Jan 2026 04:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767758508;
	bh=pzuDTI1gGeG5Smd+gX1gaxHlzMDNl358rd8Qrwf1tqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N7u/AAYT3DDEUXzlTMGjqZuODkOKrqMuB9CcWWnECwJA8nhYty4M3NEe4VKElptV2
	 eGGGvgXAHnfGpC43Cofx6mA0tHqObs3mTQeRxkriecrKIxi1mBUL8I2Kfpo6FR+fnX
	 BeqLvKAFPHraFwq3GT2AswyWHkWVv/KYfbBi6xqXwW3+AwM/XCLWXwk3sM4kkY13CZ
	 1UnjB+Z2DT2LjzeUvp14Siz8RA606HwynIlEGPAWB5gSeTXswi5YEYTKJZXUhzUohP
	 KTTtdS4vQ8wiIHUbm6MfVPEndmvnAyhVGNc5aQQ77O+H8+/xB0DWa/LbwJOpZ7Ae/v
	 wkVi0bNORnAoQ==
Date: Tue, 6 Jan 2026 20:01:28 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Qingfang Deng <dqfext@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>
Subject: Re: [PATCH 30/36] crypto: inside-secure - Use new AES library API
Message-ID: <20260107040128.GC2283@sol>
References: <20260105051311.1607207-1-ebiggers@kernel.org>
 <20260105051311.1607207-31-ebiggers@kernel.org>
 <20260107034834.1447-1-dqfext@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107034834.1447-1-dqfext@gmail.com>

On Wed, Jan 07, 2026 at 11:48:33AM +0800, Qingfang Deng wrote:
> On Sun,  4 Jan 2026 21:13:03 -0800, Eric Biggers wrote:
> > --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> > +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> > @@ -2505,37 +2505,35 @@ static int safexcel_aead_gcm_setkey(struct crypto_aead *ctfm, const u8 *key,
> >  				    unsigned int len)
> >  {
> >  	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
> >  	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
> >  	struct safexcel_crypto_priv *priv = ctx->base.priv;
> > -	struct crypto_aes_ctx aes;
> > +	struct aes_enckey aes;
> >  	u32 hashkey[AES_BLOCK_SIZE >> 2];
> >  	int ret, i;
> >  
> > -	ret = aes_expandkey(&aes, key, len);
> > -	if (ret) {
> > -		memzero_explicit(&aes, sizeof(aes));
> > +	ret = aes_prepareenckey(&aes, key, len);
> > +	if (ret)
> >  		return ret;
> > -	}
> >  
> >  	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
> >  		for (i = 0; i < len / sizeof(u32); i++) {
> > -			if (le32_to_cpu(ctx->key[i]) != aes.key_enc[i]) {
> > +			if (ctx->key[i] != get_unaligned((__le32 *)key + i)) {
> 
> "key" is big-endian. Casting it to __le32 does not seem correct.
> Did you mean "get_unaligned_le32", which also convert the endianness?

No.  Previously, in this driver the 32-bit words of the AES key went
from little endian in their original byte array in 'key', to CPU endian
in 'aes.key_enc' (via the get_unaligned_le32() in aes_expandkey()), to
little endian in 'ctx->key' (via the cpu_to_le32() in this function).
Note that ctx->key is an array of __le32.

Those two conversions canceled out.  So I've simplified it to just grab
the little endian words of the key directly.

- Eric
