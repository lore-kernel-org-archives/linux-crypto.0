Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C5D2ED84C
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 09:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765358555; cv=none; b=m70eBZvYFZOKTV6RNu6PPVzRDpKQErnolIr96rDo/6K01GheWhKknsGKUnQZ6d/MxDzuodj4fmMgLo4TpB2FnNa8o1l8KMbHYXYbAs2dKgCikExjLuvEo8Q5hVb1AWWgcyUxLdKJwB97hJRc89AHeZOMvs754YZsq2bqD2oAfYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765358555; c=relaxed/simple;
	bh=xDn6vgH0y+81dV1xaEzoN5dR3FfdGbOvHNtaRBpYzz8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=TCmwrWiMAsz0u34JV7+wTtaGk7YIys5Kr9I6IWZc0XYd+MesMylekj5ORIUHLZ5N3j1/GSr7pOnmrF8nMG/OyJzcVFdY2oJ2hm9SGY89wgwhzDjnrmS1bjXRNLDuY/8GFn22rQAyoDt08fgQTuw50kzzqthHKf+nPrYmGG92FOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com; spf=pass smtp.mailfrom=cknow-tech.com; dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b=WRWSPyLe; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b="WRWSPyLe"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow-tech.com;
	s=key1; t=1765358541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PklN9qjVdwXRT0hpbQhT8EuFAzT1yIiMNZYzqBnPsj4=;
	b=WRWSPyLejzpcnsjbUS08zjmJcLC7hMYcMhs/SL9T6pBBLDpre9306yWY4ZjEpr9h/NvvSR
	R8lfjIeYm5jwRb+9NMQqme1ADcMJ14BBnEXRTSCA8WUD3g20jXDNuS8TYQW8+WMYrl0XSN
	rGw6LAcn0QbZQPjeW9wUmrBDEX9gBEDCx2diLWpqH12+PuKUYQmrWNdRUeD1L5x4LG3WZS
	xIVvfOicoUi7UXQn1EW2NL58PN9XRSthDATP82JQtOodLZjootXhCdaHr7GAvNuZ9A8d4w
	TysBhi/Rk4lS6OlUG2WCKMTD2hU6Nn37kW5aYYHLqE8XnxKYM05y8lYrvS9hOQ==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Dec 2025 10:22:19 +0100
Message-Id: <DEUFDH7FJURL.3J0FN5I19VV8F@cknow-tech.com>
Subject: Re: [PATCH] crypto: arm64/ghash - Fix incorrect output from
 ghash-neon
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Diederik de Haas" <diederik@cknow-tech.com>
To: "Eric Biggers" <ebiggers@kernel.org>, <linux-crypto@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, "Ard Biesheuvel" <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, <linux-arm-kernel@lists.infradead.org>,
 <stable@vger.kernel.org>, "Diederik de Haas" <diederik@cknow-tech.com>
References: <DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com>
 <20251209223417.112294-1-ebiggers@kernel.org>
In-Reply-To: <20251209223417.112294-1-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue Dec 9, 2025 at 11:34 PM CET, Eric Biggers wrote:
> Commit 9a7c987fb92b ("crypto: arm64/ghash - Use API partial block
> handling") made ghash_finup() pass the wrong buffer to
> ghash_do_simd_update().  As a result, ghash-neon now produces incorrect
> outputs when the message length isn't divisible by 16 bytes.  Fix this.

I was hoping to not have to do a 'git bisect', but this is much better
:-D I can confirm that this patch fixes the error I was seeing, so

Tested-by: Diederik de Haas <diederik@cknow-tech.com>

> (I didn't notice this earlier because this code is reached only on CPUs
> that support NEON but not PMULL.  I haven't yet found a way to get
> qemu-system-aarch64 to emulate that configuration.)

https://www.qemu.org/docs/master/system/arm/raspi.html indicates it can
emulate various Raspberry Pi models. I've only tested it with RPi 3B+
(bc of its wifi+bt chip), but I wouldn't be surprised if all RPi models
would have this problem? Dunno if QEMU emulates that though.

Thanks for the quick fix!

Cheers,
  Diederik

> Fixes: 9a7c987fb92b ("crypto: arm64/ghash - Use API partial block handlin=
g")
> Cc: stable@vger.kernel.org
> Reported-by: Diederik de Haas <diederik@cknow-tech.com>
> Closes: https://lore.kernel.org/linux-crypto/DETXT7QI62KE.F3CGH2VWX1SC@ck=
now-tech.com/
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> If it's okay, I'd like to just take this via libcrypto-fixes.
>
>  arch/arm64/crypto/ghash-ce-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-=
ce-glue.c
> index 7951557a285a..ef249d06c92c 100644
> --- a/arch/arm64/crypto/ghash-ce-glue.c
> +++ b/arch/arm64/crypto/ghash-ce-glue.c
> @@ -131,11 +131,11 @@ static int ghash_finup(struct shash_desc *desc, con=
st u8 *src,
> =20
>  	if (len) {
>  		u8 buf[GHASH_BLOCK_SIZE] =3D {};
> =20
>  		memcpy(buf, src, len);
> -		ghash_do_simd_update(1, ctx->digest, src, key, NULL,
> +		ghash_do_simd_update(1, ctx->digest, buf, key, NULL,
>  				     pmull_ghash_update_p8);
>  		memzero_explicit(buf, sizeof(buf));
>  	}
>  	return ghash_export(desc, dst);
>  }
>
> base-commit: 7a3984bbd69055898add0fe22445f99435f33450

