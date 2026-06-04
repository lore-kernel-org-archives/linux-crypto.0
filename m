Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73A43290AF;
	Thu,  4 Jun 2026 04:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.187.169.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780547637; cv=none; b=BcwbMLhb74krhfbGVX/EW5IRA+Fy+Z0NDKz0LmLAn4y0ewLEmvDzxUJdgD8/sJlpCyLN6r/aYuy4i0N4A6XUTTE6S7OhGYwd0HKT3rvP3jnmqRLTbgF/xjdmreqKUVkdJVAUYBkfY9a7Rul0nZR38YORfFHY7LYhdtXeCQtbGls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780547637; c=relaxed/simple;
	bh=vngcLxVTk3HXE3UDkEHwZD/sC8BJEgzZIwY2NhPZC2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=scIKW0ahgROsTlhyERu6ODbJ75qoFKUXfGhNOJCrWGoM0TTw4PCVt84/DCRaGQKMIlblLUwvt/asFg1huEgS75sCvcyzKvaQANvru/T9DCHkxHPaydk5ELXXjPf5EPFunjDtvUUEvuhqVU4/zLy129iJ2tQO/OtdIE4O0RQ5eDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de; spf=pass smtp.mailfrom=hogyros.de; arc=none smtp.client-ip=185.187.169.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hogyros.de
Received: from [192.168.1.28] (unknown [103.52.208.62])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by psionic.psi5.com (Postfix) with ESMTPSA id 388443F123;
	Thu,  4 Jun 2026 06:26:52 +0200 (CEST)
Message-ID: <23bbb3a5-2dc2-4416-9a3a-9c07fe414d4b@hogyros.de>
Date: Thu, 4 Jun 2026 13:26:49 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: talitos: replace in_be32/out_be32 with
 ioread32be/iowrite32be
To: Rosen Penev <rosenp@gmail.com>, linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 open list <linux-kernel@vger.kernel.org>
References: <20260603193300.7695-1-rosenp@gmail.com>
Content-Language: en-US
From: Simon Richter <Simon.Richter@hogyros.de>
In-Reply-To: <20260603193300.7695-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 6/4/26 4:33 AM, Rosen Penev wrote:

> Convert ppc4xx-specific in_be32/out_be32 and the setbits32/clrbits32
> macros to the portable ioread32be/iowrite32be helpers.

It doesn't do that. The setbits32/clrbits32 macros are unchanged.

If they had been adapted, there would have been no need to inline the 
macro definition before substituting the IO accessors.

This inlining makes the code harder to read, because it consists of 
nested function calls (which have very specific and annoying indentation 
requirements that you're not following), and also duplicates the address 
calculation.

> Add COMPILE_TEST for extra compile coverage.

> Assisted-by: opencode:big-pickle

I suspect these two lines are related in a horrible way, and this code 
has only been compile-tested on the wrong architecture as part of the 
feedback loop. COMPILE_TEST is not necessary for compile-testing with a 
cross compiler and an appropriate defconfig for the target platform.

> -		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
> -			  TALITOS1_CCCR_LO_RESET);
> +		iowrite32be(ioread32be(priv->chan[ch].reg + TALITOS_CCCR_LO) |
> +				    (TALITOS1_CCCR_LO_RESET),
> +			    priv->chan[ch].reg + TALITOS_CCCR_LO);

Wrong formatting, and either the parentheses around 
TALITOS1_CCCR_LO_RESET are unnecessary here, or

> -		while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR_LO) &
> -			TALITOS1_CCCR_LO_RESET) && --timeout)
> +		while ((ioread32be(priv->chan[ch].reg + TALITOS_CCCR_LO) &
> +			TALITOS1_CCCR_LO_RESET) &&
> +		       --timeout)

also needs them. The former is correct (macro definitions need to 
include parentheses if using them inside a calculation would give you 
unexpected operator precedence.

>   	/* set 36-bit addressing, done writeback enable and done IRQ enable */
> -	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, TALITOS_CCCR_LO_EAE |
> -		  TALITOS_CCCR_LO_CDWE | TALITOS_CCCR_LO_CDIE);
> +	iowrite32be(ioread32be(priv->chan[ch].reg + TALITOS_CCCR_LO) |
> +			    (TALITOS_CCCR_LO_EAE | TALITOS_CCCR_LO_CDWE | TALITOS_CCCR_LO_CDIE),
> +		    priv->chan[ch].reg + TALITOS_CCCR_LO);

These parentheses are likewise unnecessary. It's a big OR, no need to 
group them.

\> +#define DEF_TALITOS1_DONE(name, ch_done_mask) 
                          \
> +	static void talitos1_done_##name(unsigned long data)                                  \

Inconsistent backslashes, and does not improve the horribleness that was 
there before, only makes it longer and harder to read.

>   	if (!desc_hdr)
> -		desc_hdr = cpu_to_be32(in_be32(priv->chan[ch].reg + TALITOS_DESCBUF));
> +		desc_hdr = cpu_to_be32(ioread32be(priv->chan[ch].reg + TALITOS_DESCBUF));

Likewise, this is bad and unreadable in the current state, and this 
patch does nothing to improve that.

> -		dev_err(dev, "AFEUISR 0x%08x_%08x\n",
> -			in_be32(priv->reg_afeu + TALITOS_EUISR),
> -			in_be32(priv->reg_afeu + TALITOS_EUISR_LO));
> +		dev_err(dev, "AFEUISR 0x%08x_%08x\n", ioread32be(priv->reg_afeu + TALITOS_EUISR),
> +			ioread32be(priv->reg_afeu + TALITOS_EUISR_LO));

You can probably see how the formatting is worse than before.

I'm not going to bother checking if this introduces any bugs, as I have 
the strong suspicion that I would be the first person reading this code.

    Simon
