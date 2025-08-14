Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7444C341AA;
	Thu, 14 Aug 2025 02:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755139276; cv=none; b=EcksqHYMO13mB4b6a/eJCMry1x0iIXMiQFUfoz7eBiXNn9rI4r42Q8T3Ia10Fgmo3IuUfmOwbf1hVyW/F/2LoOFyfF+Na4FyN4HjcWrdBhjK5gms2XkOsIA0KFR20BgX3YAz+EUXJladCq8JerAB2Apt3eSsaQUeSv1wp/euF8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755139276; c=relaxed/simple;
	bh=L59CXZefwhrH5q1FHmL+4aKZFmV6u0sSqUpurTk9jhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jejP45zR/qBJt6udbS805ptdq5dmlIVebypNuYnnLoDTSNrsYB6qkfP5zs+N7tsf2e9METsrOlhLV7idmS56aYTjAgC5JOuCX49PyQKdWqBxNubjRRZK2g27AKWGfs8yf+osjz6MuYXJWhH+ptL97KvlD87FscCWWHL4eSUTLos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LZmMRdCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LZmMRdCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6D4C4CEEB;
	Thu, 14 Aug 2025 02:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755139276;
	bh=L59CXZefwhrH5q1FHmL+4aKZFmV6u0sSqUpurTk9jhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LZmMRdCOFCbIepOK26Ntp4tGHYKBctPJao2xJvLXF/xkH7D/dS/AE7tiJ4Q0AolOh
	 wnwAbzW5MrSwrdqM2a5hDV4hUTNNC4MonYpUXt8VvTbELFMSdnAegpV1rSy14ZFdfp
	 /l1dxnHqBrHNMovXKgNlX+BUGrFiY4otrc6IMk421IxpVARc4zQqMISdlbp+6Pvy50
	 qWg8/XH43YsN8WOvR9jlvziMYtHOcnr1dpi21zhyo2FpdAUq9+8W9FJIKVVcxhk35o
	 yD38/Ws7eW+4d6yewfk+agTLh8U60OJLS45jOklRsR/WmHs52yjUDx2/piEv6tmPCu
	 DJHNjowCYG4UQ==
Date: Wed, 13 Aug 2025 19:40:12 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: ensure generated *.S files are removed on
 make clean
Message-ID: <20250814024012.GA1296@sol>
References: <20250813-crypto_clean-v1-1-11971b8bf56a@columbia.edu>
 <CAKha_srSRA9HftM+zLeRVrONKmPdtm-wTXq3n2NC60Gynuvwyw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKha_srSRA9HftM+zLeRVrONKmPdtm-wTXq3n2NC60Gynuvwyw@mail.gmail.com>

On Thu, Aug 14, 2025 at 03:47:05AM +0300, Tal Zussman wrote:
> On Thu, Aug 14, 2025 at 3:39 AM Tal Zussman <tz2294@columbia.edu> wrote:
> >
> > make clean does not check the kernel config when removing files. As
> > such, additions to clean-files under CONFIG_ARM or CONFIG_ARM64 are not
> > evaluated. For example, when building on arm64, this means that
> > lib/crypto/arm64/sha{256,512}-core.S are left over after make clean.
> >
> > Set clean-files unconditionally to ensure that make clean removes these
> > files.
> >
> > Fixes: e96cb9507f2d ("lib/crypto: sha256: Consolidate into single module")
> > Fixes: 24c91b62ac50 ("lib/crypto: arm/sha512: Migrate optimized SHA-512 code to library")
> > Fixes: 60e3f1e9b7a5 ("lib/crypto: arm64/sha512: Migrate optimized SHA-512 code to library")
> > Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> > ---
> > An alternative approach is to rename the generated files to *.s and
> > remove the clean-files lines, as make clean removes *.s files
> > automatically. However, this would require explicitly defining the
> > corresponding *.o rules.
> > ---
> >  lib/crypto/Makefile | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> > index e4151be2ebd4..44f6a1fdc808 100644
> > --- a/lib/crypto/Makefile
> > +++ b/lib/crypto/Makefile
> > @@ -100,7 +100,6 @@ ifeq ($(CONFIG_ARM),y)
> >  libsha256-y += arm/sha256-ce.o arm/sha256-core.o
> >  $(obj)/arm/sha256-core.S: $(src)/arm/sha256-armv4.pl
> >         $(call cmd,perlasm)
> > -clean-files += arm/sha256-core.S
> >  AFLAGS_arm/sha256-core.o += $(aflags-thumb2-y)
> >  endif
> >
> > @@ -108,7 +107,6 @@ ifeq ($(CONFIG_ARM64),y)
> >  libsha256-y += arm64/sha256-core.o
> >  $(obj)/arm64/sha256-core.S: $(src)/arm64/sha2-armv8.pl
> >         $(call cmd,perlasm_with_args)
> > -clean-files += arm64/sha256-core.S
> >  libsha256-$(CONFIG_KERNEL_MODE_NEON) += arm64/sha256-ce.o
> >  endif
> >
> > @@ -132,7 +130,6 @@ ifeq ($(CONFIG_ARM),y)
> >  libsha512-y += arm/sha512-core.o
> >  $(obj)/arm/sha512-core.S: $(src)/arm/sha512-armv4.pl
> >         $(call cmd,perlasm)
> > -clean-files += arm/sha512-core.S
> >  AFLAGS_arm/sha512-core.o += $(aflags-thumb2-y)
> >  endif
> >
> > @@ -140,7 +137,6 @@ ifeq ($(CONFIG_ARM64),y)
> >  libsha512-y += arm64/sha512-core.o
> >  $(obj)/arm64/sha512-core.S: $(src)/arm64/sha2-armv8.pl
> >         $(call cmd,perlasm_with_args)
> > -clean-files += arm64/sha512-core.S
> >  libsha512-$(CONFIG_KERNEL_MODE_NEON) += arm64/sha512-ce-core.o
> >  endif
> >
> > @@ -167,3 +163,7 @@ obj-$(CONFIG_PPC) += powerpc/
> >  obj-$(CONFIG_RISCV) += riscv/
> >  obj-$(CONFIG_S390) += s390/
> >  obj-$(CONFIG_X86) += x86/
> > +
> > +# clean-files must be defined unconditionally
> > +clean-files += arm/sha256-core.S arm/sha256-core.S
> > +clean-files += arm64/sha512-core.S arm64/sha512-core.S
> 
> Sorry this is broken, needs the following fix on top.
> I'll fix in v2.
> 
> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> index 44f6a1fdc808..539d5d59a50e 100644
> --- a/lib/crypto/Makefile
> +++ b/lib/crypto/Makefile
> @@ -165,5 +165,5 @@ obj-$(CONFIG_S390) += s390/
>  obj-$(CONFIG_X86) += x86/
> 
>  # clean-files must be defined unconditionally
> -clean-files += arm/sha256-core.S arm/sha256-core.S
> -clean-files += arm64/sha512-core.S arm64/sha512-core.S
> +clean-files += arm/sha256-core.S arm/sha512-core.S
> +clean-files += arm64/sha256-core.S arm64/sha512-core.S

Hmm, interesting.  So 'make clean' works in kind of a unique way.  It
looks at $(ARCH), but not .config.  And though no CONFIG_* options are
set for it, it still processes all the subdirectories like
'obj-$(CONFIG_FOO) += subdir/'.  But it doesn't process the contents of
'if' statements conditional on $(CONFIG_FOO).  I guess it couldn't
really work in any other way, but it's a bit unique.

Yes, just defining the clean-files unconditionally looks like the best
option here.  Please go ahead and send out v2 with the corrected
filenames.  Thanks!

- Eric
