Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447612BE630;
	Thu, 30 Jul 2026 23:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785455265; cv=none; b=Il1qSiKHP7bNNLbunPBMkWeIbrg1S/s4fficnCExDA58n0WZK+U0DDUHzdN3k8BRIT+X6g6IQs9OQ2Wko6dJ787yqxFFGL3V8jd9+Jb7no2Ivem+oWFhHrsqB4wrYEUEWU4CryfHXiVaPkZUhSVNThniZXZAa3P5WcDSp2XYtiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785455265; c=relaxed/simple;
	bh=gihVaoDGpHN2F7D82bkgGqPlZ5S7QS7QLifAONKyodo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9iz0i0Fg4XqkLfyrnkUVAzb4lc3vzQa0tXlpX4/hW0j6kpHKPKxJ1upIPbkatbCsYjCY7p4ef7C6f+fnHIB3/ODKmJyDK32+Q56b73TcAUb1DsCv3HIk4m+UjAYxKOi3ZEIGFgjvJRaLaRCk0YFEdehAgFN03XI3cBWjT21ZzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j5x42nHU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j5x42nHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9642F1F000E9;
	Thu, 30 Jul 2026 23:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785455263;
	bh=xrsrA5hdxEbnY/PY6miFkgtDkZsZTMS1qxp1CY3BX8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j5x42nHUUyiMogr8sLB2u9ZNYiotqMJ+M3F/nZEy8Xq2PuolTkw3FqmAvzLkIxJVd
	 lHg3hw9tOoNVWCNgLSCz6FLZaAwail6I4WikbcqJFnxZ4zi8alu6gUJCfh/U2AK92b
	 7GPnlHQM6AAciDE048HukSJnVKuV6DkRPmSHezpSEPV+OYeVfY6tel24cuf7y563+6
	 3ZO9ANYnDMJGCqYzy9T3dNq8AiMco2GwKmwDYcakuMUzZq5KMwk0neRO5nRipzyq7+
	 v6pFZunylM1y7cJWZtm9oGLVj+tyAjOSnldR5gcaLMEi0reFh+v7VYRyi4j+jW8BGW
	 9WxnWPId8u6dQ==
Date: Thu, 30 Jul 2026 23:47:42 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/8] lib/crypto: x86: Stop using cpu_has_xfeatures()
Message-ID: <20260730234742.GB2459987@google.com>
References: <20260728021603.79870-1-ebiggers@kernel.org>
 <20260728021603.79870-5-ebiggers@kernel.org>
 <20260730231944.GLamvcEBNkNIXjQt26@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730231944.GLamvcEBNkNIXjQt26@fat_crate.local>

On Thu, Jul 30, 2026 at 04:19:44PM -0700, Borislav Petkov wrote:
> On Mon, Jul 27, 2026 at 07:15:59PM -0700, Eric Biggers wrote:
> > Checking both boot_cpu_has() and cpu_has_xfeatures() has never really
> > been needed in practice, and it's never been universally done (e.g.,
> > lib/raid/ omits cpu_has_xfeatures()).  Nevertheless, both x86 and UML
> > now explicitly clear the AVX and AVX-512 flags if their xfeatures are
> > missing, which should remove any remaining doubts.
> > 
> > Thus, remove all the calls to cpu_has_xfeatures().
> > 
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >  lib/crypto/x86/blake2s.h  | 4 +---
> >  lib/crypto/x86/chacha.h   | 3 +--
> >  lib/crypto/x86/nh.h       | 4 +---
> >  lib/crypto/x86/poly1305.h | 7 ++-----
> >  lib/crypto/x86/sha1.h     | 4 +---
> >  lib/crypto/x86/sha256.h   | 4 +---
> >  lib/crypto/x86/sha512.h   | 3 +--
> >  lib/crypto/x86/sm3.h      | 3 +--
> >  8 files changed, 9 insertions(+), 23 deletions(-)
> > 
> > diff --git a/lib/crypto/x86/blake2s.h b/lib/crypto/x86/blake2s.h
> > index f8eed6cb042e4..0f7c51f055c8f 100644
> > --- a/lib/crypto/x86/blake2s.h
> > +++ b/lib/crypto/x86/blake2s.h
> > @@ -55,8 +55,6 @@ static void blake2s_mod_init_arch(void)
> >  	if (boot_cpu_has(X86_FEATURE_AVX) &&
> >  	    boot_cpu_has(X86_FEATURE_AVX2) &&
> >  	    boot_cpu_has(X86_FEATURE_AVX512F) &&
> > -	    boot_cpu_has(X86_FEATURE_AVX512VL) &&
> > -	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
> > -			      XFEATURE_MASK_AVX512, NULL))
> > +	    boot_cpu_has(X86_FEATURE_AVX512VL))
> >  		static_branch_enable(&blake2s_use_avx512);
> >  }
> 
> You could add a patch at the end or I can do it which does
> 
> 	s/boot_cpu_has/cpu_feature_enabled/
> 
> as latter is the interface we use now everywhere.
> 
> But yeah, it should be a separate patch.

cpu_feature_enabled() turns into an alternative (code patching), which
doesn't make much sense in any of the places you're asking for it to be
used, as they just check the features once at module init time to toggle
static keys.

I suppose that the static keys that are conditional on only one CPU
feature can be replaced with cpu_feature_enabled(), which should be
equally efficient.  However, many of the keys are conditional on two or
more features.

After that, there would be a mix of both versions.  So sure, it could
make sense to use cpu_feature_enabled() everywhere anyway, even when not
helpful.  I'm not sure it's clearly better than the status quo, though.

- Eric
