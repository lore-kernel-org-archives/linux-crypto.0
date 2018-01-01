From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/3] crypto: salsa20-generic - cleanup and convert to skcipher API
Date: Mon, 01 Jan 2018 15:04:47 +0100
Message-ID: <1634837.0VVt3iBXeX@positron.chronox.de>
References: <20171231234642.22621-1-ebiggers3@gmail.com> <20171231234642.22621-2-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:44334 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751088AbeAAOEu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jan 2018 09:04:50 -0500
In-Reply-To: <20171231234642.22621-2-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 1. Januar 2018, 00:46:40 CET schrieb Eric Biggers:

Hi Eric,
> 
> -static void salsa20_wordtobyte(u8 output[64], const u32 input[16])
> +static void salsa20_block(u32 *state, u32 *stream)

Shouldn't stream be __le32? This could get rid of the type casting further 
down.

>  {
>  	u32 x[16];
>  	int i;
> 
> -	memcpy(x, input, sizeof(x));
> -	for (i = 20; i > 0; i -= 2) {
> +	memcpy(x, state, sizeof(x));
> +
> +	for (i = 0; i < 20; i += 2) {
>  		x[ 4] ^= rol32((x[ 0] + x[12]),  7);
>  		x[ 8] ^= rol32((x[ 4] + x[ 0]),  9);
>  		x[12] ^= rol32((x[ 8] + x[ 4]), 13);
> @@ -95,145 +73,135 @@ static void salsa20_wordtobyte(u8 output[64], const
> u32 input[16]) x[14] ^= rol32((x[13] + x[12]), 13);
>  		x[15] ^= rol32((x[14] + x[13]), 18);
>  	}
> -	for (i = 0; i < 16; ++i)
> -		x[i] += input[i];
> -	for (i = 0; i < 16; ++i)
> -		U32TO8_LITTLE(output + 4 * i,x[i]);
> -}
> 
> -static const char sigma[16] = "expand 32-byte k";
> -static const char tau[16] = "expand 16-byte k";
> +	for (i = 0; i < 16; i++)
> +		stream[i] = (__force u32)cpu_to_le32(x[i] + state[i]);
> +
> +	if (++state[8] == 0)
> +		state[9]++;
> +}
> 
> -static void salsa20_keysetup(struct salsa20_ctx *ctx, const u8 *k, u32
> kbytes) +static void salsa20_docrypt(u32 *state, u8 *dst, const u8 *src,
> +			    unsigned int bytes)
>  {
> -	const char *constants;
> +	u32 stream[SALSA20_BLOCK_SIZE / sizeof(u32)];

dto, __le32?

Ciao
Stephan
