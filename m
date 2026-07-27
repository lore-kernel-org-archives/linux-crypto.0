Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8F63A4F50;
	Mon, 27 Jul 2026 18:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785176715; cv=none; b=QC++OXkmfm+st5K3Qs481BtLx/V0h1wetztmpO3OSVt/ckz94snjHC/EkEY0Co2Dw8zoEnr6X0XBWOVFxXnjJ6PfTPTqNatj/EK0jeY5cqiNE2wla4+1/3J7uYGuPcpdY/mR2UQ+1Ni3sYlNFhNBYpAXEg0Kw7ChFX/H6hTmm9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785176715; c=relaxed/simple;
	bh=DQ2ITuiWEvEMLpfg+7UStgyJnHGr6BeNIjZdWox/kU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d5yPzvP84ZjcYzRuutlL4cibp/MX7DZMDrtPjBku1DXDkwanAZ6oeHjfnD3vVFP2mmqluzjBrU1y5VnuqdXNzgRK26EnSxs5Hs3GUFKkzww25u2gvVXgEUWbKoFRNEE68SSD2Oeane0l/99hZi+bViHEn0XFWCuPdxa/KaVpHRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BbOIW9BV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BbOIW9BV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2081F00ADF;
	Mon, 27 Jul 2026 18:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785176714;
	bh=I/bNX7RBDaISvqjoCPT9UJ85r1BXji/otpf0xFEPpZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BbOIW9BVpfpHjSviHHsnyL+sN5lQx9oE6czEP7dHE1rDqkMTQFZpkzOxHqIk8L1n9
	 4KqUqh3Zr4sW1fRCfKnvo4c2jVOAqMFxsSvj7R+Lvm4qgDw6EUd6nDyh+/tq3a21Ng
	 7Rva8PW1pGTPFfpRi1aFZjlDO61F/fAV6T+EYFTE50Tfsg74F3EAixcn/5yh5249H0
	 ZyqiNbAgsEGQ4jnSJ97ie7b9WgAjQAsnj3G6Om+jZKdLQ43BbXzHxFx31A6hHEKLEs
	 jrL4Sy6M8JD5YxeIuGL7r2thaYjzd8B9l9OibW/zcPMNVt/GAm+yYxzMYZAY4dOHs2
	 OTttSTiL8o7+A==
Date: Mon, 27 Jul 2026 18:25:11 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	demiobenour@gmail.com, davem@davemloft.net,
	herbert@gondor.apana.org.au, upstream+linux@sigma-star.at
Subject: Re: [PATCH] crypto: af_alg: Allow cbc(paes)
Message-ID: <20260727182511.GA1021387@google.com>
References: <20260726192716.2351505-1-richard@nod.at>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726192716.2351505-1-richard@nod.at>

On Sun, Jul 26, 2026 at 09:27:16PM +0200, Richard Weinberger wrote:
> Commit 7524070f26d8 ("crypto: af_alg - Drop support for off-CPU cryptography")
> breaks a special use case.  The cbc-paes-caam driver implements the
> algorithm cbc(paes), it offers a way to use AES in CBC mode with key
> material unknown to userspace.  Instead of an AES key a CAAM BLOB is
> passed to the kernel.  So, this crypto operation cannot be
> implemented in a userspace library and needs always help from the
> kernel.
> 
> Explicitly allow this use case.
> 
> Cc: Demi Marie Obenour <demiobenour@gmail.com>
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Fixes: 7524070f26d8 ("crypto: af_alg - Drop support for off-CPU cryptography")
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  crypto/algif_skcipher.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index df20bdfe1f1f..035fed7db81f 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -32,6 +32,7 @@
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/net.h>
> +#include <linux/string.h>
>  #include <net/sock.h>
>  
>  static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
> @@ -309,7 +310,12 @@ static struct proto_ops algif_skcipher_ops_nokey = {
>  
>  static void *skcipher_bind(const char *name)
>  {
> -	return crypto_alloc_skcipher(name, 0, AF_ALG_CRYPTOAPI_MASK);
> +	u32 mask = AF_ALG_CRYPTOAPI_MASK;
> +
> +	if (strcmp(name, "cbc(paes)") == 0)
> +		mask = 0;
> +
> +	return crypto_alloc_skcipher(name, 0, mask);
>  }

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

I'll note that this overrides userspace's request if they call bind()
with salg_feat=0 && salg_mask=CRYPTO_ALG_KERN_DRIVER_ONLY, expressing an
intent to exclude algorithms that have CRYPTO_ALG_KERN_DRIVER_ONLY set.

However, it doesn't make sense to request that with "cbc(paes)".  Also,
salg_feat and salg_mask seem to be de facto unused anyway: the only
supported flag has ever been CRYPTO_ALG_KERN_DRIVER_ONLY; alg_bind()
returns -EINVAL on anything else.  And it isn't even declared in a UAPI
header.  I think every use of AF_ALG I've seen uses salg_feat=0 &&
salg_mask=0, usually by leaving those fields default-zero-initialized.

So we could go a bit further and integrate this correctly with the
salg_feat and salg_mask.  But I wouldn't consider it essential.

- Eric
