Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386164A49BB;
	Thu, 24 Sep 2026 17:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272154; cv=none; b=nmUPynlOGenJO+Bn6vqkhq5z7j0tXT86AJOt6HAom8VXuvEcG4+zhQ7NCQRVpwRsR9ijCJwBvQPSiMO93wjtwgyjfctcCvX3BVLaGjna18CoTjSMDEaFy7Cc4HZ1lfrHRYyCXlo6absaUI/4wvKyevOvO1rqrwbk8lzieZ7/G5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272154; c=relaxed/simple;
	bh=onMjdp9pKyut8cOXm4a7zlpc+OxWYiDBcLEg1y0FHms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X0bNjH+EV3TrlftTkdFWz7xeGzpil/QxaKSafmyktUX3u3wcnFlILjWVzarQrxVRye4eZJAZlCdlSnmyLwo/bpwHyxZiNXJsWsc658QxbD560dYoSYQy9P2hktZTvCVoGCISSxXU2fQ78jBLP7jxAulh9SvqHyYiH8zYb+W8j38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UGVH6f8i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UGVH6f8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BF81F000FF;
	Thu, 24 Sep 2026 17:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790272153;
	bh=Sah/XlRCLobNvxZBNoECbt8dQSeCaU767fqOZJLPHF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UGVH6f8iMf0GaYkZUuWUg6Bfx3MgWKEAaYEXbNwduGKGvqxTxzm6HIPgq6D8FED4R
	 HlP9+Qz2b2zg00lL6ttYX127r/ieade2sbUeEV4R0K0hesZnkONEXma2hgyYTbArjU
	 KZS2DESXQq4MyJW0lnSuloU5KEdJN86lAkmT8EbIdR84ZtEECK9P2ygU8hOHKY9kld
	 yL8Vht2KKFmF4ZCpdcn4RzajNCxKNdpUJtvMa5h1hjY9wLS0GKiJECscwqzWIosOeC
	 hVXg8kpNvjflYPMkyGuKiUlzuYp0n/DYXKTBbjlg+Qb3ynOC3z/sAW/JMPpfOcQ9JK
	 dhUKRebhSNAxA==
Date: Thu, 24 Sep 2026 10:49:11 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Thomas Huth <thuth@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [PATCH v4 11/13] lib/crypto: sha2: Provide functions for
 zeroizing SHA2 hmac_sha* structures
Message-ID: <20260924174911.GA1978@sol>
References: <20260916095022.604354-1-thuth@redhat.com>
 <20260916095022.604354-12-thuth@redhat.com>
 <20260924145806.GA1949494@ax162>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924145806.GA1949494@ax162>

On Thu, Sep 24, 2026 at 10:58:06AM -0400, Nathan Chancellor wrote:
> Hi Thomas,
> 
> On Wed, Sep 16, 2026 at 11:50:13AM +0200, Thomas Huth wrote:
> > In certain cases crypto code functions need to zeroize their local SHA2
> > hmac_sha*_key or hmac_sha*_ctx structures after use to avoid leaking
> > sensitive material on the stack.
> > Provide hmac_sha*_zeroize_key() and hmac_sha*_zeroize_ctx() helper
> > functions that can be used with __cleanup() to automatically zeroize
> > the structure when it goes out of scope.
> > 
> > Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
> > Signed-off-by: Thomas Huth <thuth@redhat.com>
> > ---
> >  include/crypto/sha2.h | 73 +++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 73 insertions(+)
> > 
> > diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
> > index 7bb8fe169daf2..22fbc37ae8407 100644
> > --- a/include/crypto/sha2.h
> > +++ b/include/crypto/sha2.h
> > @@ -7,6 +7,7 @@
> >  #define _CRYPTO_SHA2_H
> >  
> >  #include <linux/types.h>
> > +#include <linux/string.h>
> 
> I am seeing a build failure with CONFIG_CFI=y after this patch landed in
> -next as commit 09eb210b7deb ("lib/crypto: sha2: Provide functions for
> zeroizing SHA2 hmac_sha* structures").
> 
>   $ printf 'CONFIG_%s=y\n' CFI KEXEC_FILE >kernel/configs/repro.config
> 
>   $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 mrproper defconfig repro.config arch/x86/purgatory/
>   ld.lld: error: undefined symbol: __memset
>   >>> referenced by string.c
>   >>>               arch/x86/purgatory/purgatory.ro:(__UNIQUE_ID_addressable___memset_5)
> 
>   ld.lld: error: undefined symbol: __memmove
>   >>> referenced by string.c
>   >>>               arch/x86/purgatory/purgatory.ro:(__UNIQUE_ID_addressable___memmove_6)
>   make[6]: *** [arch/x86/purgatory/Makefile:80: arch/x86/purgatory/purgatory.chk] Error 1
>   ...
> 
> This comes from the instances of KCFI_REFERENCE in
> arch/x86/include/asm/string_64.h. Maybe __DISABLE_EXPORTS should be set
> for the full purgatory to avoid this? I am juggling a lot of stuff at
> the moment so just this report instead of a full patch.

To fix linux-next, I dropped patches 10-12 of this series.  Thomas,
please resend just those once there is a solution.

We know that sha256.c (which is already built into purgatory) already
includes <linux/string.h> and uses memzero_explicit() with no problem.
So as a last resort we could make the new functions out-of-line, as that
will work.  But there should be a way to keep them in the header.  I
suspect purgatory.o (which includes <crypto/sha2.h>) just needs to be
built with the same -D__DISABLE_EXPORTS and -D__NO_FORTIFY flags as
sha256.o already is.

- Eric
