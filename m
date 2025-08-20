Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.4.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9073213E6D;
	Wed, 20 Aug 2025 15:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.80.4.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755704275; cv=none; b=anYLCun9AcWZfjxE/z2qYzyFTSLyu1RquzWUxn+ALAK+WCsT9lk2Z99so8bOVSuDTTi4cp0bZOea9qVqqf8I4OpBaU8jNMZjD+rbkC5+rYYsfkAiQQMZd5vjuSrbUh3y2nNlZB0SgmL0tlQHt9KEKvlZDSV9a7X7/zSFOTp03Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755704275; c=relaxed/simple;
	bh=tYvTZy0bYiaZpkHh2cl/jkMfUGMcOXG2vzebLIEmYEk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=bWa4bVeRk8C00xcZHGzHs4A3U3UOuzsuUqHm1ZVzw3wbetxoIF8mhR2Cp8gfdypcAN1QCfvwj/16k5xzccigh6O5Gtx6vorQ09xxzJaBkPRwF+zt6l7qFZDK7yC+zppbfryQjhARVLQupYxdvU+C7MwROrJmcxaeFD57FeW9iuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniroma2.it; spf=pass smtp.mailfrom=uniroma2.it; dkim=permerror (0-bit key) header.d=uniroma2.it header.i=@uniroma2.it header.b=bhFP+2Gp; dkim=pass (2048-bit key) header.d=uniroma2.it header.i=@uniroma2.it header.b=HLDDTQaD; arc=none smtp.client-ip=160.80.4.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniroma2.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniroma2.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=uniroma2.it header.i=@uniroma2.it header.b="bhFP+2Gp";
	dkim=pass (2048-bit key) header.d=uniroma2.it header.i=@uniroma2.it header.b="HLDDTQaD"
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
	by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 57KFbCF1024314;
	Wed, 20 Aug 2025 17:37:17 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
	by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 53C5F120497;
	Wed, 20 Aug 2025 17:37:07 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
	s=ed201904; t=1755704227; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x9/s2xzb/me85lzEEWaqZKaMJPHuvgxbFuxCDRpRqQ0=;
	b=bhFP+2Gpw2WVhtOXolH9Z4eVBubYUg0ZPefGmJz8m5S12qnFaWuJYwkiPCUT0GA+3zo7Z+
	vQ7urGEYpNwI+/AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
	t=1755704227; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x9/s2xzb/me85lzEEWaqZKaMJPHuvgxbFuxCDRpRqQ0=;
	b=HLDDTQaDyFPoFWZNYx5qgFjKhcdAyQJu3X9ET095NOmah6ZZgIAN67XAb8Oqrz2Ld+VYoG
	AU1AiQu7n5ILE1Ha5a5M9ViVl1q4Jv9Y7wWX4LeOI4ptLaw6z0bRQrheZqsDLk/uj1ISLd
	i74njCpmujShx1oXfUXa3OVxsxTTdSHsXg2HriOKJ4xH68oPkF8B4W53HCtZRbG/CVMhZd
	mCSmvii8/yM9XJ8lde8vWb2XiNGZacuws2/2Hrnt2py1+DDy4Gg/1s3IsyYBF3sf9Xn6rf
	mcSYczmN/cmKYjSyROLJVFUyEUEQd5+IsrGYfGBMlrjRKgiRHFUK/nDrWwHTJw==
Date: Wed, 20 Aug 2025 17:37:06 +0200
From: Andrea Mayer <andrea.mayer@uniroma2.it>
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        David Lebrun
 <dlebrun@google.com>, Minhong He <heminhong@kylinos.cn>,
        stable@vger.kernel.org, stefano.salsano@uniroma2.it,
        Paolo Lungaroni
 <paolo.lungaroni@uniroma2.it>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [PATCH net v2] ipv6: sr: Fix MAC comparison to be constant-time
Message-Id: <20250820173706.6cd7d8848513e3082112fa06@uniroma2.it>
In-Reply-To: <20250818202724.15713-1-ebiggers@kernel.org>
References: <20250818202724.15713-1-ebiggers@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean

On Mon, 18 Aug 2025 13:27:24 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> To prevent timing attacks, MACs need to be compared in constant time.
> Use the appropriate helper function for this.
> 
> Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> v2: sent as standalone patch targeting net instead of net-next.
> 
>  net/ipv6/seg6_hmac.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

The fix looks good to me. Thanks!

Ciao,
Andrea

Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>

> diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
> index f78ecb6ad8383..5dae892bbc73b 100644
> --- a/net/ipv6/seg6_hmac.c
> +++ b/net/ipv6/seg6_hmac.c
> @@ -33,10 +33,11 @@
>  #include <net/ip6_route.h>
>  #include <net/addrconf.h>
>  #include <net/xfrm.h>
>  
>  #include <crypto/hash.h>
> +#include <crypto/utils.h>
>  #include <net/seg6.h>
>  #include <net/genetlink.h>
>  #include <net/seg6_hmac.h>
>  #include <linux/random.h>
>  
> @@ -278,11 +279,11 @@ bool seg6_hmac_validate_skb(struct sk_buff *skb)
>  		return false;
>  
>  	if (seg6_hmac_compute(hinfo, srh, &ipv6_hdr(skb)->saddr, hmac_output))
>  		return false;
>  
> -	if (memcmp(hmac_output, tlv->hmac, SEG6_HMAC_FIELD_LEN) != 0)
> +	if (crypto_memneq(hmac_output, tlv->hmac, SEG6_HMAC_FIELD_LEN))
>  		return false;
>  
>  	return true;
>  }
>  EXPORT_SYMBOL(seg6_hmac_validate_skb);
> 
> base-commit: 715c7a36d59f54162a26fac1d1ed8dc087a24cf1
> -- 
> 2.50.1
>
