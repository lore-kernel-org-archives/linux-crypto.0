Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38F3319864;
	Tue, 19 Aug 2025 09:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755597140; cv=none; b=UFB0ecx+GvNN2kK8f6i2FvxJmJSfIdB9MzxYvZwC7/mtTOIHd6KCTT3kwPiLf5oXU6NdenXW0t32/xr5E2RSPGdH3igHQuLNSTxRgIpP88IXv2BEqqdg3rgEL+MlH06XX/PoKKAzmMOFIJaWO+wRSFhGRquVbsAAMbLcqT6fq9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755597140; c=relaxed/simple;
	bh=riyx5Ui2N1PjGHdmsYpqvNLW0AbU3uXrVdjJ7B6FCjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZcST7Ik4DWEs0V0m/RW4SRejbnKqEjNN06LxmFfc4HlB1gskXw3poIPxAmfEo0gZooVVD5vJG8WImyeEB2E2VuZNrtfL52dptft9IUwAm6hT2mMpvqT+ZpWnEx1NgQV7/JY5Awfoo+tzfyKxyfnnel9bpgBABtWRqphLnFM++IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=RGuLPRxu; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="RGuLPRxu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BFDDBKJL6wdCWr7VRZwLXGClqERBpii1/Q8Tp26reZg=; b=RGuLPRxuQWsWguzaQfk2hXE1CH
	HUTcgTHWi4S73T5EmfDjQjBvMDzu3oEWhPk30n/8hc176ZT+dzJ68NpAakQausxtf48yPXbp4ddF9
	ssvKHrGys/vIiHc7UMiP/PFUblLQmARs10zEK2vLa31CJzuSZLHNht06NTFpTuUEgQX3J+ZGKF/pA
	RFE9Yd7rc9ucyCMWm+PLak2qGSg+BatNn6p0opfXn8iAWwElTGvY0LmtTVuDBndozfmFN30MDhFA4
	Wlnh540rbSr5ZN3RO2hOKYhDX8dl7IDKVffeUxPy/yW3+V1bZgvP4jE3o2t0uq4OCjyJOyumejQe0
	1HaYWuPg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uoIlJ-00FTfK-2u;
	Tue, 19 Aug 2025 17:52:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 19 Aug 2025 17:52:10 +0800
Date: Tue, 19 Aug 2025 17:52:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] crypto:x86 - Remove CONFIG_AS_GFNI
Message-ID: <aKRJSrdfDC6k1cwp@gondor.apana.org.au>
References: <20250819085855.333380-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819085855.333380-1-ubizjak@gmail.com>

On Tue, Aug 19, 2025 at 10:57:49AM +0200, Uros Bizjak wrote:
> Current minimum required version of binutils is 2.30,
> which supports GFNI instruction mnemonics.
> 
> Remove check for assembler support of GFNI instructions
> and all relevant macros for conditional compilation.
> 
> No functional change intended.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/Kconfig.assembler               |  5 -----
>  arch/x86/crypto/Kconfig                  |  2 +-
>  arch/x86/crypto/aria-aesni-avx-asm_64.S  | 10 ----------
>  arch/x86/crypto/aria-aesni-avx2-asm_64.S | 10 +---------
>  arch/x86/crypto/aria_aesni_avx2_glue.c   |  4 +---
>  arch/x86/crypto/aria_aesni_avx_glue.c    |  4 +---
>  6 files changed, 4 insertions(+), 31 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
