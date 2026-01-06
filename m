Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF014306B11;
	Tue,  6 Jan 2026 06:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767681391; cv=none; b=MRq4kSiR1L67lNn4F+GQK0tpbm1VftERs5aIadP+RL+e2tVQTcAWXWFAZ2oNw2dTQCFTa5rk8Tg/nvo/Lge3LC5F33loRZhlH1uJGQx1jqPf+G3eqMbD5KMwvLM/odNqU252VDBgm7M/7HlSzPYbVf/lo/ACiuM8K7foKfgC0PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767681391; c=relaxed/simple;
	bh=rdREKMSltpuBRXrhF+R1a8MfGIPmnymt3Sxftd/Knsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CT1dwm8zRKUXNm0y4Av8o5/5aNh2SD8G9R1DvQmEhS8GW7PIF8RWMF9I7je0auERiBAtMq8Q+JdAI9nZ1JvUDwEWW4kfOQIVEsSHOVBkzLENEOLuomKwiB3sze0IG8vB9JNa8F6+Q4nddvQLNoin1cP9k5bj4hQ542gRSlJK41E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3JAZfQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3JAZfQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65CAC116C6;
	Tue,  6 Jan 2026 06:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767681391;
	bh=rdREKMSltpuBRXrhF+R1a8MfGIPmnymt3Sxftd/Knsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S3JAZfQTQkdf3Szw+a/pV9YfijdR5VYyedZ8Y6EdU3MWnO6UcihH1xnxeFDL1x09k
	 ZuoY6of7XUhlA3+YlMbCj1sUISpfaSaDiYIPWaDNs04OrAKL/rFfQrs73OU/8w0Kl2
	 tN6ULSVQtHvDFxYzKonJ6O4zblqc4nITcveRLbcvhNvaXZCCa4WYKx86yFx2eaUVF2
	 rgU+tOAD76DU2buz1IUO0oCZoA11dXmKVoQHu4XmEXiIQtHyLHF3xalYdx+IVPWyrD
	 nm+cR6SrwOhHH9zKliIG8/CYHUjE571e9edTX4FLKyzXL8KAvjz6s5pLAlRkHgwdT3
	 U863fAfhVXoKg==
Date: Mon, 5 Jan 2026 22:36:12 -0800
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
Subject: Re: [PATCH 02/36] lib/crypto: aes: Introduce improved AES library
Message-ID: <20260106063612.GA2630@sol>
References: <20260105051311.1607207-1-ebiggers@kernel.org>
 <20260105051311.1607207-3-ebiggers@kernel.org>
 <20260105074712.498-1-dqfext@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105074712.498-1-dqfext@gmail.com>

On Mon, Jan 05, 2026 at 03:47:12PM +0800, Qingfang Deng wrote:
> On 4 Jan 2026 21:12:35 -0800, Eric Biggers wrote:
> >  extern const u8 crypto_aes_sbox[];
> >  extern const u8 crypto_aes_inv_sbox[];
> > +extern const u32 __cacheline_aligned aes_enc_tab[256];
> > +extern const u32 __cacheline_aligned aes_dec_tab[256];
>  
> __cacheline_aligned puts the array in ".data..cacheline_aligned"
> section. As a const array, it should be in ".rodata" section, so
> ____cacheline_aligned (note the extra underscores) should be used
> instead.
> You can also apply the same to crypto_aes_sbox and crypto_aes_inv_sbox
> while at it.
> 
> Regards,
> Qingfang

Good catch!  So the result is that MMU protection isn't applied to the
const data as intended.

I guess I'll change these to the four-underscore ____cacheline_aligned.

Though, I'm tempted to instead just do __aligned(SMP_CACHE_BYTES), to
stay well away from this footgun.

- Eric
