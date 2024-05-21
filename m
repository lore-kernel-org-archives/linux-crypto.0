Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35FC7F48D;
	Tue, 21 May 2024 17:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716312990; cv=none; b=ttkvjaMdwtR3iqZy8SCD1ND49CgOT4++r3PgJJI1I9hSfPOHmMf+pvaSpNAPuq+iFvbuVJsd7LDrPq22p6W1rle1OxMlru2L8Bww0n3jEAGDmjfXoaFpQpST016jvpbZ0RjtFDAKzJ7wbe2UDdYT/g7qXRxzz704YrmXAX4pxWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716312990; c=relaxed/simple;
	bh=UUgYo1pJjsln1cMSgisDH1/jsYW8CqI5x6WXoM4b6NE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pvuohXim8vj1nyKe2hruwtcpj5NBKbnN3F0RUFHEMzqPq5a6TULyguDfTNcQNB4zB4PRpHhLGkmhs/RSrsgHwzbX2+2fBLfo8gV2CfdbLmmTVQ9yqzPvk3jqKHaFzCne/HiJBberjKVCdf4GX2iWe8mSLgpyTQkamHQ1bW56qqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FRiFGX5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FRiFGX5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36CCC4AF0A;
	Tue, 21 May 2024 17:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716312989;
	bh=UUgYo1pJjsln1cMSgisDH1/jsYW8CqI5x6WXoM4b6NE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FRiFGX5Y+SAZYXmQNh1/2GZKEhPgQwEK78NgJS1H2n/EqyuF9+aA0v2OMp7eYVYBe
	 qhFyV37j1zZE0XMIZZoRrfvHw3WaMHPBuER8PUpDmXEQBNt8+HGDWeTzgqfXRKrF4A
	 tTu3xYnBEd7PFj2LmrwrXSx8KKlaDclDK3lRMjnf+OvJ/Fma+15J6b51g/arzFWbTD
	 Qj+WmtWlJdmu7A0t1EvQEODSAIlxm/GjssM3WduZeeIm7dIvPoxzwQr3BWNvrkvryl
	 wvlIceP3l25SaY0ipwEMhM3AzsePJPDLR+Skcz7zsw4UBMjVQkjHPSgeKFI71DOI61
	 NHZ2wTBc+TeWQ==
Date: Tue, 21 May 2024 10:36:27 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v6 01/49] crypto: x86/aes-xts - Switch to new Intel CPU
 model defines
Message-ID: <20240521173627.GA50837@sol.localdomain>
References: <20240520224620.9480-1-tony.luck@intel.com>
 <20240520224620.9480-2-tony.luck@intel.com>
 <20240521172202.GFZkzYOh0pET7B1SFW@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521172202.GFZkzYOh0pET7B1SFW@fat_crate.local>

On Tue, May 21, 2024 at 07:22:02PM +0200, Borislav Petkov wrote:
> + Herbert as an FYI that I'll pick up this one and the next for 6.10 as
> it is a fix for a regression that got discovered.
> 
> Thx.
> 
> On Mon, May 20, 2024 at 03:45:32PM -0700, Tony Luck wrote:
> > New CPU #defines encode vendor and family as well as model.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/crypto/aesni-intel_glue.c | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> > index 5b25d2a58aeb..ef031655b2d3 100644
> > --- a/arch/x86/crypto/aesni-intel_glue.c
> > +++ b/arch/x86/crypto/aesni-intel_glue.c
> > @@ -1223,14 +1223,14 @@ DEFINE_XTS_ALG(vaes_avx10_512, "xts-aes-vaes-avx10_512", 800);
> >   * implementation with ymm registers (256-bit vectors) will be used instead.
> >   */
> >  static const struct x86_cpu_id zmm_exclusion_list[] = {
> > -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_SKYLAKE_X },
> > -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_ICELAKE_X },
> > -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_ICELAKE_D },
> > -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_ICELAKE },
> > -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_ICELAKE_L },
> > -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_ICELAKE_NNPI },
> > -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_TIGERLAKE_L },
> > -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_TIGERLAKE },
> > +	X86_MATCH_VFM(INTEL_SKYLAKE_X,		0),
> > +	X86_MATCH_VFM(INTEL_ICELAKE_X,		0),
> > +	X86_MATCH_VFM(INTEL_ICELAKE_D,		0),
> > +	X86_MATCH_VFM(INTEL_ICELAKE,		0),
> > +	X86_MATCH_VFM(INTEL_ICELAKE_L,		0),
> > +	X86_MATCH_VFM(INTEL_ICELAKE_NNPI,	0),
> > +	X86_MATCH_VFM(INTEL_TIGERLAKE_L,	0),
> > +	X86_MATCH_VFM(INTEL_TIGERLAKE,		0),
> >  	/* Allow Rocket Lake and later, and Sapphire Rapids and later. */
> >  	/* Also allow AMD CPUs (starting with Zen 4, the first with AVX-512). */
> >  	{},
> > -- 

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
