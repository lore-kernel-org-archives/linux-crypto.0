Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E681A0732;
	Tue, 10 Dec 2024 16:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733847304; cv=none; b=ajtzpWGA1NF9F1eqeIr2DtH2JGt8t6iwomRh4BF5aveA3VvYm747XLVQqyEx44ZX+1njBUmCb8AvnVKkY1TH6W7Gq7Zo1iNzvMYDZ1kdWc5fmCEa4rmAcI19qWacvKrssfrNUCd7DzrTAJZycX0ciwV4h6ZL40LlqZuNiu8gTEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733847304; c=relaxed/simple;
	bh=kG6+VH1Fq8TC4oAn5+9FCYdYFnloGzXmm+vqfIkitPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=etBRDaKSzZ88VYWPXipmBck0jSlsWHqEhTHlHbKGgX/vPuuKTJgBaJl5DW/pBoRU7ZkGrOuJA7yew+ZuuJP60Ty0zxv3Q95YSc2jal7p4D3QZydnuJFc5f3V278q/HwdZs6PdrNyEObGlYw5+LiHAefOqOat+uCAYtad6a+Cyzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlVzcJ/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlVzcJ/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED5EC4CEDE;
	Tue, 10 Dec 2024 16:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733847303;
	bh=kG6+VH1Fq8TC4oAn5+9FCYdYFnloGzXmm+vqfIkitPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WlVzcJ/ddPEfMG5IxIb+gAHncdPiLO2gsO0aM9yGnlFtLCD+qAkrgCimoapC62yuo
	 m0ZhRxJeKjqAGGPAmHfdTHkKUuNXipPAJ1Wwj3vnjwWyBNAVbeJqBCSSoYypmpXE76
	 LVa7NBiPWwInSe53IZ++GtPs9bxQaIQc/idMubE5b1vgBWvv3v2TOieuO0neECOOQb
	 i1GFCfpBNyWj+80iENvqizcz61MPlgaKS4iKIwYK/TeHK9qwwJljrMOAda3gI4XwLX
	 Ed00lN/n3WS1TXCf0IvEZQ6AIuLy4jfu7JXQ+hIC5H5V4gV4pby6v4CX12TuGZ0xOh
	 NcZjuNE4BsUHA==
Date: Tue, 10 Dec 2024 09:14:58 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	briannorris@chromium.org, kees@kernel.org, gustavoars@kernel.org,
	steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	gjoyce@ibm.com, linux-crypto@vger.kernel.org, linux@weissschuh.net
Subject: Re: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for
 gcc-13+ and FORTIFY_SOURCE
Message-ID: <20241210161458.GA1305110@ax162>
References: <20241208161315.730138-1-nilay@linux.ibm.com>
 <Z1XkhhBqFYtbvQYp@yury-ThinkPad>
 <20241209193558.GA1597021@ax162>
 <2d9f4b56-3a8f-4fd7-a356-022f973da5e0@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d9f4b56-3a8f-4fd7-a356-022f973da5e0@linux.ibm.com>

On Tue, Dec 10, 2024 at 01:58:00PM +0530, Nilay Shroff wrote:
> Okay so I think you (and Greg) were suggesting instead of disabling 
> -Wstringop-overread globally or tuning it off for a particular source
> file, lets disable it on gcc-13+ while we invoke bitmap_copy() as shown
> below: 

I cannot speak for Greg but yes, this is generally what I had in mind, I
have a few comments below.

> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index d0ed9583743f..e61b9f3ff6a7 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -139,6 +139,18 @@
>  #define __diag_GCC_8(s)
>  #endif
>  
> +#if GCC_VERSION >= 130000
> +#define __diag_GCC_13(s)       __diag(s)
> +#else
> +#define __diag_GCC_13(s)
> +#endif
> +
> +#if GCC_VERSION >= 140000
> +#define __diag_GCC_14(s)       __diag(s)
> +#else
> +#define __diag_GCC_14(s)
> +#endif

You do not need to add __diag_GCC_14 because __diag_GCC_13 covers
GCC 13 and newer.

>  #define __diag_ignore_all(option, comment) \
>         __diag(__diag_GCC_ignore option)
>  
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index 9278a50d514f..6885856e38b0 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -836,7 +836,23 @@ void cpumask_shift_left(struct cpumask *dstp, const struct cpumask *srcp, int n)
>  static __always_inline
>  void cpumask_copy(struct cpumask *dstp, const struct cpumask *srcp)
>  {
> +       /*
> +        * Silence -Wstringop-overead warning generated while copying cpumask
> +        * bits on gcc-13+ and CONFIG_FORTIFY_SOURCE=y. The gcc-13+ emits
> +        * warning suggesting "we're trying to copy nbits which potentially
> +        * exceeds NR_CPUS. Apparently, this seems false positive and might be
> +        * a gcc bug as we know that large_cpumask_bits should never exceed
> +        * NR_CPUS.

I think the last sentence needs to be either dropped entirely or needs
to have more assertive language. While this might be a false positive, I
think it is entirely unreasonable to expect GCC to know that
large_cpumask_bits when it is nr_cpu_ids is bounded by NR_CPUS because
it does not have the definition of nr_cpu_ids visible at this point and
even if it did, it is still a global variable, so it has to assume that
value could be anything in lieu of an explicit bounds check.

Maybe something like this for the full comment?

/*
 * Silence instances of -Wstringop-overread that come from the memcpy() in
 * bitmap_copy() that may appear with GCC 13+, CONFIG_FORTIFY_SOURCE=y, and
 * and CONFIG_NR_CPUS > 256, as the length of the memcpy() in bitmap_copy() will
 * not a compile time constant. Without an explicit bounds check on the length
 * of the copy in this path, GCC will assume the length could be 0 to UINT_MAX,
 * which would trigger an overread of the source if it were to happen. As
 * nr_cpu_ids is known to be bounded by NR_CPUS, this copy will always be in
 * bounds.
 */

> +        */
> +       __diag_push();
> +       __diag_ignore(GCC, 13, "-Wstringop-overread",
> +               "Ignore string overflow warning while copying cpumask bits");
> +       __diag_ignore(GCC, 14, "-Wstringop-overread",
> +               "Ignore string overflow warning while copying cpumask bits");

This __diag_ignore() can be dropped as well.

> +
>         bitmap_copy(cpumask_bits(dstp), cpumask_bits(srcp), large_cpumask_bits);
> +
> +       __diag_pop();
>  }
> 
> Does the above change look good to everyone?

I think this seems reasonable to me, but it might be good to get some
feedback from the hardening folks.

Cheers,
Nathan
