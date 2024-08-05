Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9528469;
	Mon,  5 Aug 2024 20:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722890979; cv=none; b=en1Z5F39h1z2YdjL8s5RLTl6PqAJp9o63YzStUpFKVdykowYP+ahXPglFd5x2t1+exTtGIJBFTMdK6Xib6AKWBa4uYg6DzSnpr7TCyh8voB9f06Cym8ecg0MX33n61u6CLMe0nFv0TAjiWxl7QvX8n1LgodzhBlmSTlyathQWDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722890979; c=relaxed/simple;
	bh=uR3QWvC/dCvKhnSqtxoK8Gmo30P/OnSTpnlVHGvk6hA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Adr5TUNA/4xO/HcPLn69rBAR7Cc+SNgLNlBHZRO3odbTNy9aBvyNsxoSb73lffB9x/yi7ZzfHUAJh/QWOhtUing/EZx+NPaqPNATgEpL29yGHjwA7tPosyYymPWUPyM4XvepNv3tcD5bbUW+OT6BzHjLI1+j2vF85/jw7BakDY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jUIXBkxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jUIXBkxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204DEC32782;
	Mon,  5 Aug 2024 20:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722890979;
	bh=uR3QWvC/dCvKhnSqtxoK8Gmo30P/OnSTpnlVHGvk6hA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jUIXBkxlkEKYYh4/9F6yLFIa/yI3RzorcQSPMSeY4wfCwf1vjoqACY0xsyKuLxbw/
	 i7Q34r8qM+sVnbiRISn1oa7Gvzdr7Kb2WREyrlFVoyIl3os0JZUXkAcoEh9D9fJfXx
	 CcHx+IA558EUV2xI2ECfu4BgGIllEQOr9WySvuB/0ZDcx2v4BX3kh0JfYilAbA58Gw
	 MNQcthnQTUWT50gKAeQ0oCYbhhQKXNmLtHqRuUcXbjKe6GjPsv4b0Ud9kVNXn+j5zh
	 MaLskzX8NwheiTG1ELmthbhz4aEzAGo2sgqmttVBUt19KaM53HcNrj9W4wQgUBJhL8
	 Vs+Sm9qJGVpkQ==
Date: Mon, 5 Aug 2024 13:49:38 -0700
From: Kees Cook <kees@kernel.org>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, gustavoars@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: chacha20poly1305 - Annotate struct
 chachapoly_ctx with __counted_by()
Message-ID: <202408051344.140B713E4C@keescook>
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
> Add the __counted_by compiler attribute to the flexible array member
> salt to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE.
> 
> Use struct_size_t() instead of manually calculating the struct's size.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
>  crypto/chacha20poly1305.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
> index 9e4651330852..b37f59a8280a 100644
> --- a/crypto/chacha20poly1305.c
> +++ b/crypto/chacha20poly1305.c
> @@ -27,7 +27,7 @@ struct chachapoly_ctx {
>  	struct crypto_ahash *poly;
>  	/* key bytes we use for the ChaCha20 IV */
>  	unsigned int saltlen;
> -	u8 salt[];
> +	u8 salt[] __counted_by(saltlen);
>  };

AFAICT, all the allocations of struct chachapoly_ctx set "saltlen" before
using "salt".

Reviewed-by: Kees Cook <kees@kernel.org>

>  
>  struct poly_req {
> @@ -611,8 +611,8 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
>  				       poly->base.cra_priority) / 2;
>  	inst->alg.base.cra_blocksize = 1;
>  	inst->alg.base.cra_alignmask = chacha->base.cra_alignmask;
> -	inst->alg.base.cra_ctxsize = sizeof(struct chachapoly_ctx) +
> -				     ctx->saltlen;
> +	inst->alg.base.cra_ctxsize = struct_size_t(struct chachapoly_ctx, salt,
> +						   ctx->saltlen);
>  	inst->alg.ivsize = ivsize;
>  	inst->alg.chunksize = chacha->chunksize;
>  	inst->alg.maxauthsize = POLY1305_DIGEST_SIZE;

My instinct is to use struct_size_t() as little as possible (compared
to normal struct_size), since I prefer to use it where a thing is being
allocated. (In this case, it's "far away".) So given Eric already thinks
this part should be dropped, I would agree: leave this as is.

-- 
Kees Cook
