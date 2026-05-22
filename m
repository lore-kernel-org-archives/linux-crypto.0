Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677D31DF980;
	Fri, 22 May 2026 02:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779418648; cv=none; b=ZnxzM9AA9y+ywHj3DbRJ8VuEnkJjT99TITiO+p2Kql0jQCqLoWQRrmhBQzgBFDdoa593ctBszzcc5vXSLgQLUC4L8k7wLfBWkoyYOhdJ2XJqziP+t0GgkVNd27O2rjko5Q6672nd3KK/Xv87VaZt7a370q9VEQP7DZsUv3rmD68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779418648; c=relaxed/simple;
	bh=DKf3juvMpqD/waSkpELIlU0TdFuAAoghZySBlpi4YC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TikzXH36OF7hFL4ic7rbbwqOiGdcGm0+LRzTW3412XxqYaN7uRm4b0MP8LLQtkL984zYPWvm3uOFCWZpMJPCJGtI4RCiVUK/5Cwj8MbtYCSd7vhblmUGilJgsy1uPL5AcUr1lsUVvq3LYabADFfGJ1RBG1V5F1PfbYyCwX4s3Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gz0xfL45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gz0xfL45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6971F000E9;
	Fri, 22 May 2026 02:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779418645;
	bh=yZn5jyvzabExK7ufv7Zum8uTuQpF/N9lSuNGk+1/FOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gz0xfL459BN0vMo82SDLC7s4hY3uIggljk+DYcGidR6BWC9I/eGGvXXDmTlpvj1nL
	 fHJIhGgw17CJvzeFJASm3iLEEHMgTWKl77nqJ5337PXKUEx6Io8HUrI9xd64RNu1wD
	 DH9DTcqMy1Mz+S4Q3T5p89209SRDe/e8JhQURJyq3HVnRv/CQog5StLU7qYty0/Dih
	 meExi90pT3EmgKAN2QMUSyFMBcTK3abwz+bv+FQFRSqFxubZjq8QBSlC8crbErZvpY
	 QBF9UfykO4o0wDhQpUUvqr4WU4S7ZFI4bdmJQZEECC52gKZgNtmR1Li4h4h8kcrKco
	 LqjmSHRahQKUA==
Date: Thu, 21 May 2026 21:57:22 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>, Lee Jones <lee@kernel.org>,
	kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: loongson - Select CRYPTO_RNG
Message-ID: <20260522025722.GD5937@quark>
References: <20260522022525.12976-1-ebiggers@kernel.org>
 <CAAhV-H5cDnWKxBobwRErRyvG8671e6VXsBe6w1RkX9rfn7CVFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhV-H5cDnWKxBobwRErRyvG8671e6VXsBe6w1RkX9rfn7CVFA@mail.gmail.com>

On Fri, May 22, 2026 at 10:52:42AM +0800, Huacai Chen wrote:
> On Fri, May 22, 2026 at 10:26 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > This driver registers a rng_alg, so it requires CRYPTO_RNG.
> >
> > Fixes: 766b2d724c8d ("crypto: loongson - add Loongson RNG driver support")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202605201622.qWOiiZTV-lkp@intel.com/
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
> >  drivers/crypto/loongson/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> >

By the way, do any of the loongson people have any comment on what they
think the point of this driver is?  It's not registered with the actual
hwrng subsystem, but rather the pointless crypto_rng system which no one
uses.  So if it was intended to provide entropy for /dev/urandom etc.,
that isn't what it's doing.

Can we just delete this driver?

- Eric
