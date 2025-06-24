Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7392D1F61
	for <linux-crypto@vger.kernel.org>; Tue, 24 Jun 2025 14:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750774512; cv=none; b=jOhrvIOFeB+BAr3sjR/5gdd8y7Dspl80xUgSAaslRgmUo6McM9i8ayZPA7olbdBKCVsdRIFGItwl2NjEXMyOsC2ZnwTbk+U1e8TOxJNWVxbWMZJhRzBx4VTVsaxjLNawrXLDLbjvpVstALDt1KAfWqOdNLT5r0OaxgykPf/3yo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750774512; c=relaxed/simple;
	bh=NenpkRFaUs6pHuwiVm6rdXmo9FxWRIGAoXDGPEXRKZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Onz/6sI7LSJt8DhuAuv2wY0P9cYakw6DhPZ6aU8mIhKL7Z5oob3wx0QYmm40+QlAq5wiLqN/P+u7MRIM+xfX0qZmdlbMkvP6UYXBODuVaGfpkMLFALm8GLBlzgEaBjwKLGdZaNAmv/7azaXlIL9Pu9f8YSOeuYUi1tOQc4XO5Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z35GlG05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z35GlG05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BADAC4CEE3;
	Tue, 24 Jun 2025 14:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750774511;
	bh=NenpkRFaUs6pHuwiVm6rdXmo9FxWRIGAoXDGPEXRKZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z35GlG054GUKP8usJF8po1mgwBc6gCGoEykcLW2m0Ouo7UxOyAOm0XBn8lLnMtdeD
	 qaW85lFF8lGyg+jnApMRQtCRMMekNjN80yRS/aRaBH/OhIdywQpie6V2V8s9EKw2vc
	 +9BY0QMBex5XKtxH2lGKvET2mB/eYTuTQQIzkmhtv7wclJtWmY1WErJDhalf+WJ9XU
	 rSF7uxZdx3IUK0wj6784dxvA4DgDITq1C58rTcmFfY3dtoq566jdKoNl/2qQxmqFbz
	 MnV2l3mvq3hzDTzRApOspenHC2K0u5t++l6IXfm5h06AJVtKyqa8btVktazlDpIBrI
	 OPdZRo25WSEgA==
Date: Tue, 24 Jun 2025 07:14:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: Re: CI: another regression on linux-next with s390 sha384/sha512
Message-ID: <20250624141437.GA1215@sol>
References: <9e33c893-2466-4d4e-afb1-966334e451a2@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e33c893-2466-4d4e-afb1-966334e451a2@linux.ibm.com>

On Tue, Jun 24, 2025 at 01:38:54PM +0200, Ingo Franzki wrote:
> First of all sha512_s390.ko is no longer there. I guess that intended.

Yes.

> However, /proc/crypto does show
> 
>    name         : sha256
>    driver       : sha256-s390
>    module       : kernel
> 
> and
> 
>    name         : sha224
>    driver       : sha224-s390
>    module       : kernel
> 
> but no -s390 driver for sha512 and sha384. It only shows 
> 
>    name         : sha512
>    driver       : sha512-lib
>    module       : kernel
> 
> and 
> 
>    name         : sha384
>    driver       : sha384-lib
>    module       : kernel
> 
> The -lib variants are also shown for sha224 and sha256, but those also have the s390 variants.
> 
> So it looks like the s390 optimized sha384 and sha512 are now missing ? 
> 
> Similar, the -generic variants are only available for sha256 and sha224, but not for sha384 and sha512:
> 
>    name         : sha256
>    driver       : sha256-generic
>    module       : kernel
> 
> Can this please be fixed? We really want to keep the s390 optimized versions of all digests! 

sha384-lib and sha512-lib are s390 optimized (when the kernel is built for s390
and the CPU supports the CPACF_KIMD_SHA_512 instruction).  Please see
lib/crypto/s390/sha512.h.

So, SHA-384 and SHA-512 are still fully optimized for s390.

Yes, I'll be making the same change to SHA-224 and SHA-256 so that it's
consistent.  Sorry about the temporary inconsistency.  Note that sha224-lib and
sha256-lib are already s390-optimized as well; the difference is just that the
unnecessary sha224-generic, sha256-generic, sha224-$(ARCH), and sha256-$(ARCH)
algorithms are still being registered.  The *-lib ones just do the right thing,
and they are all that's needed.

- Eric
