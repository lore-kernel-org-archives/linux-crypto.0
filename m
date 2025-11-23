Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AC148CFC;
	Sun, 23 Nov 2025 20:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763929696; cv=none; b=J36UOe4iEXkBW3vOeLBt6hBMlpm6xRyaiEQHAlIKvnAg49aQToRfvx8O97VvLmKHShuFJ/CgnKy7CDCby8hb4GxEdHtD5D74eugn76za4H+QRrete0Evj+7AzUnsThJyAe93Eyw70a1AgohLb0++fDNudaIHAaN4QWrFRDpi4wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763929696; c=relaxed/simple;
	bh=a0vRSAImbtgva1MAxsvi4dY+rJeQk+4s00Sg74aq6Wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fIhw87d4QhS+OMwVhDWjSbgQKBo19yGDu1XnSAjAfKcqfnl0PDHw2ei/9ftgKzkg0Vz785aik/0/Fs3uQ/AmkcrEaKfpZlX38+RykCmk7MBkCQOQggdqtkAEOgPdkjYOQSnZvuvSInnAvpwFDbRi1xtiOclUCEwWzTGNGv39rR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awMQyvqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awMQyvqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8401CC113D0;
	Sun, 23 Nov 2025 20:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763929695;
	bh=a0vRSAImbtgva1MAxsvi4dY+rJeQk+4s00Sg74aq6Wo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=awMQyvqZp5+kRZ2BP9yEay6nO+u4dVqKBW+WbRVtNZHC8hAVaZQzQ/oeYqKznkB/J
	 Bp4AB6GstSt0fTxeZvCpwcA27LPyHujAA5aFlzz+8BiIv+piKCEm2MVyi1r3GFp4XM
	 bk3b/bwsP62QffCMxhObqxfC3lKA0aX6RGiRWkCBmTZMT6BOcjqo+/iQ8VxhjVNT/0
	 p3C8cl16r4lbVIuNIw0CTuC4g+X42/WcjoIGDnXmjnpVHZzFOn2X9blzxV/6zA9apq
	 hDQuZup0tpQkryS165PbCn4Okn/TrSnHaYyq1O/mZctVR6un2XLjdSlCYSzdM0oBzy
	 PYc5P2OhbcDKg==
Date: Sun, 23 Nov 2025 12:26:29 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: david laight <david.laight@runbox.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: blake2b: Limit frame size workaround to GCC
 < 12.2 on i386
Message-ID: <20251123202629.GA49083@sol>
References: <20251122105530.441350-2-thorsten.blum@linux.dev>
 <20251123092840.44c92841@pumpkin>
 <0EA9C088-D1B1-4E6E-B42F-EFE9C69D1005@linux.dev>
 <20251123185818.23ad5d3f@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251123185818.23ad5d3f@pumpkin>

On Sun, Nov 23, 2025 at 06:58:18PM +0000, david laight wrote:
> On Sun, 23 Nov 2025 18:00:01 +0100
> Thorsten Blum <thorsten.blum@linux.dev> wrote:
> 
> > On 23. Nov 2025, at 10:28, david laight wrote:
> > > On Sat, 22 Nov 2025 11:55:31 +0100
> > > Thorsten Blum <thorsten.blum@linux.dev> wrote:
> > >   
> > >> The GCC bug only occurred on i386 and has been resolved since GCC 12.2.
> > >> Limit the frame size workaround to GCC < 12.2 on i386.
> > >> 
> > >> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > >> ---
> > >> lib/crypto/Makefile | 4 ++++
> > >> 1 file changed, 4 insertions(+)
> > >> 
> > >> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> > >> index b5346cebbb55..5ee36a231484 100644
> > >> --- a/lib/crypto/Makefile
> > >> +++ b/lib/crypto/Makefile
> > >> @@ -33,7 +33,11 @@ obj-$(CONFIG_CRYPTO_LIB_GF128MUL) += gf128mul.o
> > >> 
> > >> obj-$(CONFIG_CRYPTO_LIB_BLAKE2B) += libblake2b.o
> > >> libblake2b-y := blake2b.o
> > >> +ifeq ($(CONFIG_X86_32),y)
> > >> +ifeq ($(CONFIG_CC_IS_GCC)_$(call gcc-min-version, 120200),y_)
> > >> CFLAGS_blake2b.o := -Wframe-larger-than=4096 #  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105930
> > >> +endif # CONFIG_CC_IS_GCC
> > >> +endif # CONFIG_X86_32  
> > > 
> > > Isn't that just going to cause a run-time stack overflow?  
> > 
> > My change doesn't cause a runtime stack overflow, it's just a compiler
> > warning. There's more information in commit 1d3551ced64e ("crypto:
> > blake2b: effectively disable frame size warning").
> > 
> > Given the kernel test robot results with GCC 15.1.0 on m68k, we should
> > probably make this conditional on GCC (any version). Clang produces much
> > smaller stack frames and should be fine with the default warning
> > threshold.
> 
> But if anyone tries to run the kernel they'll need space for the '3k monster stack'.
> So changing the limit is 'fine' for a test build, but not for a proper build.
> (Yes this has been wrong since Linus did the original patch in 2022.)
> 
> Does allmodconfig set COMPILE_TEST ?
> If so that could be included in the conditional.
> 
> A more interesting question is whether the change can just be removed.
> I'd guess no one is actively using gcc 12.1 any more.

How about we roll up the BLAKE2b rounds loop if !CONFIG_64BIT?

- Eric
