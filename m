Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793610957;
	b=i1k3yqxiMmztdADzv7sIdhgaOahjkufOSbAS4C6STYEm2tmC69ghEeG7e0/M02G2Ur+d
	 +g03MtB2U+mse1ANIJO7Voq/KqxlcPH6qloAFI6URXXrfpG3UQcu7T2m0EDB0PCcTOcQ4
	 TpVnbeoaWICs4F4Itf79MuLiglFSC5IwMqEekmXRBri5dPINmjsneeLFE1JI6jS+mFe6a
	 4TUp2R14aakhdP/+8L0lvcbD2wCHqhKpB1DMNJIT27SgsHW6nf6V1vUcgH5P7eYYDavO3
	 sS5kw9eKFC2TfciAcTyrnIY6VAII2iJPCp56y6/Eazj5jj2/wrG9iof/1qxiUhtrn4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793610957;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=O08l4ELgs0AyAsYDBm6q/NWvRMOcCqrZ6eyVH6rwCZs=;
	b=qY8Cv40UYuiAXlNDNgBB5Cxe+FxVOYZ7CKEJHZZk0etb5HHGlf7KkO/Fd5scHXOd1ygJ
	 s7igN3HgdTvVuUSVCBNmPQoPITjjfEw6yvdByEShv0Mkxx7quvQ2BfW4irymmhP9SnU5u
	 Ra//N3CrfXRmHJFWcD4FQ1BHu/Og4oI2FbuSW1cBFYEyO2IgURS3lOaFV549F+ZncaAr3
	 Vfro51g8y17uBx97/07J6lzWamVQmOQPc+UpY4VBFcIguWJxR+r9Y+k4/SmUdN8fdBMZN
	 YVU5/SghGr9M6yU5lm7XaV7FjaqqTrNei0Y2LUuLIImh10He4j8Tc3D2oNp8hObQ1wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R8V+4BDZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EDC606A327
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 09:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R8V+4BDZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4971F0093A;
	Mon,  2 Nov 2026 09:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793610956;
	bh=O08l4ELgs0AyAsYDBm6q/NWvRMOcCqrZ6eyVH6rwCZs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=R8V+4BDZimhdx8DyOCpd7Ft6Ev5yEcOcYswRMk4r3soYnzKucor6bPRRwZ5so5v7z
	 R3CCaDo9d+PMNmsdB/utSZjM2FtYDq6MzlgwOXjAEe/yv2mQO6X/NJ2Ma4fZWixvh5
	 HznjSMp+YgZaODTGBGSZQgIid4qQ130KqQ75NluiaeoJYf0OsEYIgiIXNGDsfqx028
	 dfHPyeborE0xQyTIjzAuBqo/oteJjQgdrGkX1wcWN5yObQBGvuIAOuFYnew5N3PRng
	 PQbpY9iqylk4TKT3Q8iR0WX0ZqLhaG218wBn0AW3RYYVwhXC9PsI93wZj3dBzvM08G
	 gpX8fXofx9Urg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 58888198003A;
	Mon,  2 Nov 2026 04:15:54 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 02 Nov 2026 04:15:54 -0500
X-ME-Sender: <xms:yVToalmd1pNHw_N0rgQ5TEBcuzdG8wAEoZ1v_k-QkwYI4-05rz94sw>
    <xme:yVToarrIWduXSHkArHdmL2_J8cOLRRF_awwuesWtMAwARp3U-c2vrA3F1HPRi85Hw
    buWASN63bxJl54eegAOTiKCdOIdYRzzE6rIQHayWKcXSjYL4FDC9ZUM>
X-ME-Proxy-Cause: dmFkZTFMI47ttLy+k0OQK3vUtEIYVuULnQr52PyFYw9FGe164xcBCCE05vl5x/7SjHfwMw
    xMN0n95AsVDEB2xRkfUt2BjnL1sMKRTMGbG6zLszHUgzZB9hc7bTCypYPnYzxm68TB94an
    KafAXTBctALDeNOLymrWtvdMz5V6fslFt8I6ayJ7IKtLgnvZBLzRrv26qiHgNtmCzmeOhz
    UIO2LJedD7YOlxKO0pC7UL46O1Db23hvHu4wN04YaltC7v6/99l7O9ZO8h4QCvwxd438or
    INwePNOm2nhuBFtR+BKLAVqjqdp9yNg36M1CWddm1BXr/gsXjXDsIwCk9CKjeCm1TbtPSS
    5xhN7tmP0dRt02wNWkuEu3KOu+qND3ohtK9KZQWQqA4277QaU/aNiYGDMfHMnhJTv3798b
    kOVv14BMCwgOX6D9DUiwbM4HsMNvW7FWsfGcKOXbWacWijfVY7ApiKn4oTwyl0HQOGFVa5
    R1y2kZlkxkZmin6sjpZKm0f3qB2jgCmP+6LP4uYH7337M8BM716BcZQfCLMpmoHxUCEAxs
    j2iBR4DEqxU84/fGglc14FSxpmHVlfJapqmi+00sdyiokZAJOQGVpp7duP7bXTUpfH9ITQ
    vV0388JzM54CbghR1jNbmnSkfHj8ywury2maJWehew800xeOULzFlSEMxkIQ
X-ME-Proxy: <xmx:ylToanRYHSi7Zk3Guqh4YmC3jZk8xEqy0S96gtiYSZqfZZdX90SjaA>
    <xmx:ylToavrHE7DLT6-7VjgJPqQqcySWHjl4Wex1pzJE0-KvcAhKbhex4Q>
    <xmx:ylToalJUoYe-bKx0ojDSkysbiDOa_0yPZ0zM555_-FwV3nCwgYrMVg>
    <xmx:ylToaiq9qw5aljzg32tbWBN9K8YNquu_a10wqwCLUIMB0b7BlOWlVw>
    <xmx:ylToatwD4Y5PNZY7QwOslAf9qUOUw6H3yfwRNH_A8qSEcOe45_CrBgok>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 0E81CF8008E; Mon,  2 Nov 2026 04:15:53 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 02 Nov 2026 10:15:32 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <a112eb15-ecf7-4383-b022-f965592b676a@app.fastmail.com>
In-Reply-To: <20261031052053.201779-1-ebiggers@kernel.org>
References: <20261031052053.201779-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: aes-cmac: Hide selection mask value from compilers
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 31 Oct 2026, at 06:20, Eric Biggers wrote:
> Hide selection mask values from compilers, so that they cannot see that
> they are used to select between two values and potentially generate a
> secret-dependent branch.  This is not known to be happening here, but we
> might as well be extra careful.
>
> Since the selected values are only 0x87 and 0 here, change the type of
> the mask to 'unsigned long' so that the compiler is not forced to
> materialize it in a register pair on 32-bit architectures.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/aes.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> index e1c191551736..1d26fd8be028 100644
> --- a/lib/crypto/aes.c
> +++ b/lib/crypto/aes.c
> @@ -578,7 +578,7 @@ static void aes_cbcmac_blocks(u8 h[AES_BLOCK_SIZE],
>  int aes_cmac_preparekey(struct aes_cmac_key *key, const u8 *in_key,
>  			size_t key_len)
>  {
> -	u64 hi, lo, mask;
> +	u64 hi, lo;
>  	int err;
> 
>  	/* Prepare the AES key. */
> @@ -596,9 +596,11 @@ int aes_cmac_preparekey(struct aes_cmac_key *key, 
> const u8 *in_key,
>  	hi = be64_to_cpu(key->k_final[0].w[0]);
>  	lo = be64_to_cpu(key->k_final[0].w[1]);
>  	for (int i = 0; i < 2; i++) {
> -		mask = ((s64)hi >> 63) & 0x87;
> +		unsigned long mask = (s64)hi >> 63;
> +
> +		OPTIMIZER_HIDE_VAR(mask);
>  		hi = (hi << 1) ^ (lo >> 63);
> -		lo = (lo << 1) ^ mask;
> +		lo = (lo << 1) ^ (mask & 0x87);
>  		key->k_final[i].w[0] = cpu_to_be64(hi);
>  		key->k_final[i].w[1] = cpu_to_be64(lo);
>  	}
>
> base-commit: 2a500a04d6f969318c05f46aedb6e73fc1963a00
> -- 
> 2.56.0
