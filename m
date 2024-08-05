Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1176117F4F5;
	Mon,  5 Aug 2024 17:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722880774; cv=none; b=c2RMdGno8FfqLpWn+1Xi0z/5vPrL0O+ljwBRi6cz9N3ZT2bqMjzHSNT/k7skCSjnT1fsaFaryjBWizEqMX7jNRD9G2BH4C5abyHmhyp+PxR1FI7hd7lgaEl4bTOJvSYJdNX2Au31FSYkthtnFGJ08PVuh94Jf+BEyegU1NW0v/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722880774; c=relaxed/simple;
	bh=s9KUap0e3/fEUWXQ+ELq1Mh+lDEEjV8bsf8t9hXJmIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=roRn+qo063czE9gC7yfyWxnRaSRiiXAMs9lZDxKSynoBfxgPvIt/Uxm0tbQJqIIcdWx0LhZFUoWzGnvDcjjBLjRucC+D5pnObhk0nzJD+MqLLMOyxpNUeuLu5/KPdc/MyTrbwLwglVO4Gr+cVHDVdpHA89sssCKbNNl1K3WUPIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+9s073m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+9s073m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD73CC4AF14;
	Mon,  5 Aug 2024 17:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722880773;
	bh=s9KUap0e3/fEUWXQ+ELq1Mh+lDEEjV8bsf8t9hXJmIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D+9s073mDIRdwPeUFLIzVGpc4wErx8itwb18VsRnf/x8YMTHFdn4a4FXkDEPw9t1N
	 Oum860VnYFbOVwcRwuAaJQfMPW/w7OLUGaMYgLCnsfWshGy4HD/dopz3njI8a9LUPZ
	 zqdz0UqYI3Koaj/6fkf1wRxdZdeBQm7/19YzMqnatgOYlO7puEQwQh8hHqbnBpqbHj
	 ByZJi/goFu8VfOZi0b/I9LX6ocFEBvJkFAZpF8qZ8yoyu7bt6JNI6Tzp1jU/CBwWZ5
	 EqC+FmX1rhdtczRcBWDHg8lPEoSlelJaYWEnB7IKZWS/yOLSu3Brw40uXgrwIQHfTC
	 zLk8ZGt+a0idQ==
Date: Mon, 5 Aug 2024 10:59:32 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, kees@kernel.org,
	gustavoars@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: chacha20poly1305 - Annotate struct
 chachapoly_ctx with __counted_by()
Message-ID: <20240805175932.GB1564@sol.localdomain>
References: <20240805175237.63098-2-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240805175237.63098-2-thorsten.blum@toblux.com>

On Mon, Aug 05, 2024 at 07:52:38PM +0200, Thorsten Blum wrote:
>  struct poly_req {
> @@ -611,8 +611,8 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
>  				       poly->base.cra_priority) / 2;
>  	inst->alg.base.cra_blocksize = 1;
>  	inst->alg.base.cra_alignmask = chacha->base.cra_alignmask;
> -	inst->alg.base.cra_ctxsize = sizeof(struct chachapoly_ctx) +
> -				     ctx->saltlen;
> +	inst->alg.base.cra_ctxsize = struct_size_t(struct chachapoly_ctx, salt,
> +						   ctx->saltlen);

What was wrong with the more straightforward code it had before?

- Eric
