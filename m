Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633591FDE02;
	Wed, 19 Feb 2025 18:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739988400; cv=none; b=qK6v5yQRu/4mTVRF91tHbBZyX/2IvDzd4EHqjQ2KDOxzo0vMiYEMpsHsvEIw9lcO7it4VQEXPO5XXfqZ4FpeU0/h3/Mv5EO0RFLn32K77eYgPff4ShCWwIqm2aRjX2t9lLB91gVSounDrClbEeFlt6vTxnfLLsQARTbnyeH9mj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739988400; c=relaxed/simple;
	bh=6ogUIgrAUfVQXMcIl58LWYrJq8u3rq5wF2TdTmhQk90=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=GXiw3KTbs/5DmQG6dHZFVuBsYWObnRmZWWSD5ZVA3LlCkfz1F1Bk03PrsdbGUFJzWvQVypiGbVScEIPlTn3beMVEUsdm5jIdrMlT3hXFcD5g8RQYpXEWeBM61p4ltmkgK2SiGNz8hBc81Z+1sMBljB48Idl1QA2XhDYx0sHIjrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=VEb/nLBH; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="VEb/nLBH"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1739988390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cF7ELyOX8wQ6lDtEFZ09lHtUbLqKTiasQBuB9+dFHQ8=;
	b=VEb/nLBHJtl/OA/zYaEUzJ6xb1LyjwgYiBnKB5wpv06Yhs0Na3UY5KRHVT0wUEgeXsr8bC
	iUuyxiEUqfEQ+yhjP18ojQ92tKkd2lM8Mahk3BkAo9rsSJI+0C0n4Ni+/V11sPqpYA7uE8
	Zca2RVZM5BWlyTL42UlEHLxfn8xLRRWJD1MMWudQG7/IfKGJmB7s8ZIrV60fzfhqE79Z5L
	wAoFdz/yIqJrfRvhNhLLqCT2PfZeFwNMC5Ntu41fl9WsE+Y8AcYWSfo9pmhq40ZyLIhsYt
	oHONwfPR9kKT5znsTmf5k9oemaRVWQ4tYv7kfbAquyp9P4wNK+ZmHHjI1cHUXA==
Date: Wed, 19 Feb 2025 19:06:26 +0100
From: Dragan Simic <dsimic@manjaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: Fix indentation of HW_RANDOM_CN10K help text
In-Reply-To: <54eae580e3ee5686db692dd6c0927b23134a1cec.1739977165.git.geert+renesas@glider.be>
References: <54eae580e3ee5686db692dd6c0927b23134a1cec.1739977165.git.geert+renesas@glider.be>
Message-ID: <c94a6961491f59d5c81c607530976136@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Geert,

On 2025-02-19 16:03, Geert Uytterhoeven wrote:
> Change the indentation of the help text of the HW_RANDOM_CN10K symbol
> from one TAB plus one space to one TAB plus two spaces, as is 
> customary.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> While commit 67b78a34e48b9810 ("hwrng: Kconfig - Use tabs as leading
> whitespace consistently in Kconfig") fixed some indentation for the
> HW_RANDOM_CN10K symbol, it did not fix everything...

Oh, I totally missed that, my bad.  Thanks for the patch, and
please feel free to include

Reviewed-by: Dragan Simic <dsimic@manjaro.org>

> ---
>  drivers/char/hw_random/Kconfig | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/hw_random/Kconfig 
> b/drivers/char/hw_random/Kconfig
> index 1ec4cad1e210a2ac..c67de9579664c762 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -583,11 +583,11 @@ config HW_RANDOM_CN10K
>  	depends on HW_RANDOM && PCI && (ARM64 || (64BIT && COMPILE_TEST))
>  	default HW_RANDOM if ARCH_THUNDER
>  	help
> -	 This driver provides support for the True Random Number
> -	 generator available in Marvell CN10K SoCs.
> +	  This driver provides support for the True Random Number
> +	  generator available in Marvell CN10K SoCs.
> 
> -	 To compile this driver as a module, choose M here.
> -	 The module will be called cn10k_rng. If unsure, say Y.
> +	  To compile this driver as a module, choose M here.
> +	  The module will be called cn10k_rng. If unsure, say Y.
> 
>  config HW_RANDOM_JH7110
>  	tristate "StarFive JH7110 Random Number Generator support"
