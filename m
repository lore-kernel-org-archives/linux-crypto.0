Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792966338;
	b=AiDP5207Qn9xuzLKm1aFL+Lpie2ZWIjiY/vf6STlkN3BanVnKBwKjzE01ktKI+jNzeFJ
	 IYNYleCt6UCVcQHQTzBl+2MJcqUhlW0Eu2Dcz/L4S4WKyRJvLF1SQkms/OzRyI921HvQ8
	 qP1CLh6q31aBq63EQWCu/0IFOVO7yxUwu85H82QD0S9PnRXPppJHKs4TyUKRzwpyyLBrE
	 s2pQX30kGUUbmdN55GpjISKvgMmWXrGTQW2H9zCs9xeeia3BPDTv4bHe5M6NZeJ9VkB+/
	 5mZciLAzLBP5LIhKLuBFvS6Gh1a2B9l+kPPLPM+lhmXP58LvO83xD7bWyCUJq7uJWHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792966338;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=45zEXmXvaCwGiEjHLcqUSFd6TDFCJExN7G8pg6wAz7M=;
	b=APJg/ww8YXCYECpFiln4CARKeLjPZ2lbzywqpZcRejdygkmbcX7O4SrWHLrQelYSoXeL
	 MRqoB1chLtEsf/1wXqRTMHMRrjTPgcQdKwXNUSSCCadtH+PdJHUmQDpVyN2U9f7V79wjP
	 3Q0g1mFZrbKzEupFtgacAVaAsCg+Vq8uUsQXmxDto/RFzVSEUf/kGwSbOfFlOOCFlYbwB
	 EIAXj0hqlGHS4uV8C4orSIeFz8g1hQsET/P0JpscAfN79GzzEx4kiCvIfSeMwZwpfs+/A
	 o5zflRaWY1qaorYZF2vvnbbLbbaOj0VGXHPXQT511R3KDPgNwOkrQeizNh4namCqb2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UHVquz64;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E1D1E606A31A;
	Sun, 25 Oct 2026 22:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UHVquz64
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ECDA11F01828;
	Sun, 25 Oct 2026 22:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792966337;
	bh=45zEXmXvaCwGiEjHLcqUSFd6TDFCJExN7G8pg6wAz7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UHVquz6439XbChAAwhx2q8HNZG6yoYonJoCHl2PpXKVGn3SMU9q0v1UmRbNg9tlP1
	 10tkWu/TcftxZpn4jix+Zflcf4HBT6ZUOOggg0FocedH0AnTm1kwY6he4ebBh3TrDZ
	 9eTuEHyGouyeYvuzUH1bR5TamnkDzV6Kp5fum63CCfF1+70TFrN0PGt0KsgMFWAMPM
	 QhIVtjIErGRqzjhof0Udc0zdM7c+1hZVDOC/OiFG94iThUydAc7HewWl98Pl1sI0ln
	 4bZcjK7M/V+keN4N4kawISK1zTs+XC76zM7OF4cG7BeL1Cgvdi8nGKc5FnwrsKMN9o
	 X74o9KXQZv3rQ==
Date: Mon, 26 Oct 2026 00:12:13 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Check return value of crypto_kpp_set_secret()
Message-ID: <at5-ve5Ap7Oyp1Fo@kernel.org>
References: <20261025211119.138277-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025211119.138277-1-ebiggers@kernel.org>

On Sun, Oct 25, 2026 at 02:11:19PM -0700, Eric Biggers wrote:
> crypto_kpp_set_secret() can fail, for example if the kernel is booted
> with fips=1 and the broken-by-design FIPS RNG used for ECC private key
> generation doesn't feel like generating random bytes at the moment.
> Check for error, cancelling the TPM session creation rather than
> proceeding with a zero or uninitialized private key.
> 
> Fixes: 699e3efd6c64 ("tpm: Add HMAC session start and end functions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  drivers/char/tpm/tpm2-sessions.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
> index ca1e2bf424e14..2aaaad69760dc 100644
> --- a/drivers/char/tpm/tpm2-sessions.c
> +++ b/drivers/char/tpm/tpm2-sessions.c
> @@ -527,7 +527,9 @@ static int tpm_buf_append_salt(struct tpm_buf *buf, struct tpm_chip *chip,
>  	}
>  	crypto_ecdh_encode_key(encoded_key, buf_len, &p);
>  	/* this generates a random private key */

Could you delete this comment while at it? It's not helping with
anything.

> -	crypto_kpp_set_secret(kpp, encoded_key, buf_len);
> +	rc = crypto_kpp_set_secret(kpp, encoded_key, buf_len);
> +	if (rc)
> +		goto err_free_kpp;
>  
>  	/* salt is now the public point of this private key */
>  	req = kpp_request_alloc(kpp, GFP_KERNEL);
> 
> base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
> -- 
> 2.56.0
> 

[1] https://lore.kernel.org/linux-integrity/asQdZiv7uktfyRWU@kernel.org/

Br, Jarkko
