Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795517918;
	b=1oTA4x5mAnFuArWcenMN4KPFbxSEwpiC/Laur7nXuGSc+LG26/cttg3mb73iKy0sG4oW
	 YTYQEOuin5d8rNf7w2XTiktNesf1DJOlMdbiPDAi9b8WcwtjmsF/3MjxWpTLqEtQzuMQg
	 toK6/2yzyMGMvgZW6Iq0e9rbBQDs79KbHg5mQ6Gy55QwrIGuBLr4E2Pgb8UC6nLEgJVVD
	 s+7LRDvH7ck6UvIuKe2vT6i0/2plnqKsizR6/9q/ZaGVJlUQasxoJ9zuQY9ngPmT4Vya3
	 J2auUxkKTr/6xiHCof509ddCBCqPNoz9JO8oHHCiqzl3sd4efBy+9guIJWuGjKvfLQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795517918;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=telwXPSmHt0TRmghy29HQqKNCR1TzK5o4q7TV7L7srs=;
	b=y9xuyC/Rn9jFcrzvsY4cPAnxsew/Jk44VwJisTXpv6bwNE10FCN7HatVtgNtKOwcOVB/
	 mgl024NgUnllsVcYe/JP+nX0gCEa035plBghi9WuI/qFRIBQyXjfTJt/w+EEIzTvx0CdG
	 FIm1d9zpS6b14Y7frrJU5E/kq5mlZgCkeUvyQ6cCu/rvXC+pfzUaYJa0YRn+7/l0izaRO
	 VrLhFuKchQFc4NkL1ornw8WkFHn1P8R4Rf0Xnfjf/W0XGjmhY92NpkCB6yNodEFsksVOO
	 sa77TkO3MMq1Tzca14Pp64L8zSAlsudQZZ/8C+NNWP18jw/MiiD2x0VB5y9guxdqxrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iWx2UYrP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B260606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 10:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iWx2UYrP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BEE1F000CA
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 10:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795517917;
	bh=telwXPSmHt0TRmghy29HQqKNCR1TzK5o4q7TV7L7srs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=iWx2UYrPf/LLvC0G64VVaqT2RESfdoQBSfAcND7TZ0PqusHlpDx4pDBNfFMInldN1
	 zJfgfkmOVk8up3vdEJWBjtPW53143Ly2BlbQkMEVHs8cHIyJtUQ+yDTkFZZQ+KpaOU
	 mHe4QKW9xfUwssvPACsddcHcE2CjXH3dDRrdEugH+TV1E76pU/lxJr+OmIQ1JOsVh2
	 NfsIdhEi+7xxecB2+lEIa1m0IEhRfrxy3Jz//sizJwHp7rEUW9hkGMnT7mXsdG+v/W
	 VOpp2Ghj9W2nK2/5i7fhlivo8BfRUqOJGxRLaDFX3aQ+exFT/pgFaDE8/OiVVCMU1T
	 Zad2932U0dJ8g==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7746E198003A;
	Tue, 24 Nov 2026 05:58:35 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 05:58:35 -0500
X-ME-Sender: <xms:2W0FazRNDf6o_M2u-bKdhc12lTt2t5BBJrTIrG_TG_nm4LaHdOfezg>
    <xme:2W0Fa_lqhT4KW6RW9R_DDn4J5s_O5aWNP08Eenfd4hdeUhzf-2NEC0HTNST_HNd8o
    V1kPZhwjEt9AK3KcJ7M1YKKzONoefFYj7rpTI8ZkyRKw0WWQVx6H6M>
X-ME-Proxy-Cause: dmFkZTGCX0N6H7KhKgqKQhDlzfItW1w9KNhKDzJbkrMT/DQHgi3aIFzD8P9nPHmX0Emt8h
    i4I2xheuVqajyk+qZX8plCzSJ0wxYAAiMJEFh25XW4XUG3n5wsOqi9r3e0JUYRIXoUjean
    t3EW4y/5RlZVBQJY5ltZjP38npZHK1DYyO/KmNVJVQdARf7L+I1vvU+J73Qny0bsOJJ0av
    OZz/72/I9urF3bYhL2SURnO5dUXDnfA/FSYUjHmWqVm93zifS94TB80d9XaSN73vC0cvMR
    PT8wt7gLTMrRKmz3WHkbf0M0NV5lVk5Ucp08zuNr9cZZ9Wf3vs91pUWRHaAl4wQ2adEmXd
    SSm48TedEeT44WAuRaFNGlVP901TbWx7rnQEZ4ER3vQ9JUD3a/9/WJZ8IVj3OH4FE2LQqU
    TH3ZRXF5jY362zQzDdvMVYWmuHUi6HIzchNQ/BGM27tp9kfxLTEp4mRaUaazOAB1cit8wk
    14nE8SddSF2KNTNua01FJTio1yh/vjNUuuNnlUja/XS0JdXiqGHLZGa1IFXndTXVunDevT
    7t8Yjw4wvg3ipADjWP4jIA/trtAQDf8MpDGX/pxfMOUsI8mGKSMxIrPccPyzKZ8kJZcuYj
    QzgmH0FG8PptXjUzLunQGfC0aQkeCjaAt8OfrpvDlkiikJ8PXUAlqdlGRY6w
X-ME-Proxy: <xmx:220Fa88RKI-UUo-qWS6Zb0DPrIi1O4kCD4lfgunxAjMliHljn4v72A>
    <xmx:220Fa7l1EPzB33bbHj6jqx_mE4npqRenvtgmI7uwKCd2aaNYzHSW7g>
    <xmx:220Fa6XoZLTLrQGjASPO_Jp0wRzw37r425nF3sZbVmhHvo3-zqqmfQ>
    <xmx:220Fa4F2uIsujqVrZPGGZAnUo7DtzAF4Ari4hlJ0NxYf_5pp7-AZNQ>
    <xmx:220Fa-cXBIqXa2GcT3oEG1PUqtgfi9sVm5kZMKFP-vWkfTI2_qLyH_2F>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id C2F24F80093; Tue, 24 Nov 2026 05:58:33 -0500 (EST)
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
Date: Tue, 24 Nov 2026 11:58:13 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <2dbbfa1c-14e0-4f32-9de9-940f517a13a9@app.fastmail.com>
In-Reply-To: <20261124085914.268803-1-ebiggers@kernel.org>
References: <20261124085914.268803-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: sm3: De-bloat sm3_block_generic()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 24 Nov 2026, at 09:59, Eric Biggers wrote:
> sm3_block_generic() previously unrolled all 64 rounds, resulting in
> 13049 bytes of .text in lib/crypto/sm3.o, plus a 256-byte K[64] round
> constant table even though all round 0-15 constants are rotations of
> one value and all round 16-63 constants are rotations of one value.
>
> Therefore, roll up rounds 16-63 into 3 iterations of 16 rounds each, and
> generate the round constants on the fly via rotations.
>
> This reduces the .text size of lib/crypto/sm3.o from 13049 bytes to 7843
> bytes (a 40% reduction) and removes the 256-byte K[] table.  A benchmark
> of this code showed no significant change in speed.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/sm3.c | 143 ++++++++++++++++-------------------------------
>  1 file changed, 48 insertions(+), 95 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crypto/sm3.c b/lib/crypto/sm3.c
> index 23059347b4493..42198c724c49a 100644
> --- a/lib/crypto/sm3.c
> +++ b/lib/crypto/sm3.c
> @@ -22,25 +22,6 @@ static const struct sm3_block_state sm3_iv = {
>  	},
>  };
> 
> -static const u32 ____cacheline_aligned K[64] = {
> -	0x79cc4519, 0xf3988a32, 0xe7311465, 0xce6228cb,
> -	0x9cc45197, 0x3988a32f, 0x7311465e, 0xe6228cbc,
> -	0xcc451979, 0x988a32f3, 0x311465e7, 0x6228cbce,
> -	0xc451979c, 0x88a32f39, 0x11465e73, 0x228cbce6,
> -	0x9d8a7a87, 0x3b14f50f, 0x7629ea1e, 0xec53d43c,
> -	0xd8a7a879, 0xb14f50f3, 0x629ea1e7, 0xc53d43ce,
> -	0x8a7a879d, 0x14f50f3b, 0x29ea1e76, 0x53d43cec,
> -	0xa7a879d8, 0x4f50f3b1, 0x9ea1e762, 0x3d43cec5,
> -	0x7a879d8a, 0xf50f3b14, 0xea1e7629, 0xd43cec53,
> -	0xa879d8a7, 0x50f3b14f, 0xa1e7629e, 0x43cec53d,
> -	0x879d8a7a, 0x0f3b14f5, 0x1e7629ea, 0x3cec53d4,
> -	0x79d8a7a8, 0xf3b14f50, 0xe7629ea1, 0xcec53d43,
> -	0x9d8a7a87, 0x3b14f50f, 0x7629ea1e, 0xec53d43c,
> -	0xd8a7a879, 0xb14f50f3, 0x629ea1e7, 0xc53d43ce,
> -	0x8a7a879d, 0x14f50f3b, 0x29ea1e76, 0x53d43cec,
> -	0xa7a879d8, 0x4f50f3b1, 0x9ea1e762, 0x3d43cec5
> -};
> -
>  /*
>   * Transform the message X which consists of 16 32-bit-words. See
>   * GM/T 004-2012 for details.
> @@ -48,6 +29,7 @@ static const u32 ____cacheline_aligned K[64] = {
>  #define R(i, a, b, c, d, e, f, g, h, t, w1, w2)			\
>  	do {							\
>  		ss1 = rol32((rol32((a), 12) + (e) + (t)), 7);	\
> +		(t) = rol32((t), 1);				\
>  		ss2 = ss1 ^ rol32((a), 12);			\
>  		d += FF ## i(a, b, c) + ss2 + ((w1) ^ (w2));	\
>  		h += GG ## i(e, f, g) + ss1 + (w1);		\
> @@ -70,19 +52,20 @@ static const u32 ____cacheline_aligned K[64] = {
>  /* Message expansion */
>  #define P0(x) ((x) ^ rol32((x), 9) ^ rol32((x), 17))
>  #define P1(x) ((x) ^ rol32((x), 15) ^ rol32((x), 23))
> -#define I(i)  (W[i] = get_unaligned_be32(data + i * 4))
> -#define W1(i) (W[i & 0x0f])
> -#define W2(i) (W[i & 0x0f] =				\
> -		P1(W[i & 0x0f]				\
> -			^ W[(i-9) & 0x0f]		\
> -			^ rol32(W[(i-3) & 0x0f], 15))	\
> -		^ rol32(W[(i-13) & 0x0f], 7)		\
> -		^ W[(i-6) & 0x0f])
> +#define I(i)  (W[i] = get_unaligned_be32(data + (i) * 4))
> +#define W1(i) (W[(i) & 0x0f])
> +#define W2(i) (W[(i) & 0x0f] =					\
> +		P1(W[(i) & 0x0f]				\
> +			^ W[((i) - 9) & 0x0f]			\
> +			^ rol32(W[((i) - 3) & 0x0f], 15))	\
> +		^ rol32(W[((i) - 13) & 0x0f], 7)		\
> +		^ W[((i) - 6) & 0x0f])
> 
>  static void sm3_block_generic(struct sm3_block_state *state,
>  			      const u8 data[SM3_BLOCK_SIZE], u32 W[16])
>  {
> -	u32 a, b, c, d, e, f, g, h, ss1, ss2;
> +	u32 a, b, c, d, e, f, g, h, ss1, ss2, t;
> +	int i;
> 
>  	a = state->h[0];
>  	b = state->h[1];
> @@ -93,73 +76,43 @@ static void sm3_block_generic(struct sm3_block_state *state,
>  	g = state->h[6];
>  	h = state->h[7];
> 
> -	R1(a, b, c, d, e, f, g, h, K[0], I(0), I(4));
> -	R1(d, a, b, c, h, e, f, g, K[1], I(1), I(5));
> -	R1(c, d, a, b, g, h, e, f, K[2], I(2), I(6));
> -	R1(b, c, d, a, f, g, h, e, K[3], I(3), I(7));
> -	R1(a, b, c, d, e, f, g, h, K[4], W1(4), I(8));
> -	R1(d, a, b, c, h, e, f, g, K[5], W1(5), I(9));
> -	R1(c, d, a, b, g, h, e, f, K[6], W1(6), I(10));
> -	R1(b, c, d, a, f, g, h, e, K[7], W1(7), I(11));
> -	R1(a, b, c, d, e, f, g, h, K[8], W1(8), I(12));
> -	R1(d, a, b, c, h, e, f, g, K[9], W1(9), I(13));
> -	R1(c, d, a, b, g, h, e, f, K[10], W1(10), I(14));
> -	R1(b, c, d, a, f, g, h, e, K[11], W1(11), I(15));
> -	R1(a, b, c, d, e, f, g, h, K[12], W1(12), W2(16));
> -	R1(d, a, b, c, h, e, f, g, K[13], W1(13), W2(17));
> -	R1(c, d, a, b, g, h, e, f, K[14], W1(14), W2(18));
> -	R1(b, c, d, a, f, g, h, e, K[15], W1(15), W2(19));
> -
> -	R2(a, b, c, d, e, f, g, h, K[16], W1(16), W2(20));
> -	R2(d, a, b, c, h, e, f, g, K[17], W1(17), W2(21));
> -	R2(c, d, a, b, g, h, e, f, K[18], W1(18), W2(22));
> -	R2(b, c, d, a, f, g, h, e, K[19], W1(19), W2(23));
> -	R2(a, b, c, d, e, f, g, h, K[20], W1(20), W2(24));
> -	R2(d, a, b, c, h, e, f, g, K[21], W1(21), W2(25));
> -	R2(c, d, a, b, g, h, e, f, K[22], W1(22), W2(26));
> -	R2(b, c, d, a, f, g, h, e, K[23], W1(23), W2(27));
> -	R2(a, b, c, d, e, f, g, h, K[24], W1(24), W2(28));
> -	R2(d, a, b, c, h, e, f, g, K[25], W1(25), W2(29));
> -	R2(c, d, a, b, g, h, e, f, K[26], W1(26), W2(30));
> -	R2(b, c, d, a, f, g, h, e, K[27], W1(27), W2(31));
> -	R2(a, b, c, d, e, f, g, h, K[28], W1(28), W2(32));
> -	R2(d, a, b, c, h, e, f, g, K[29], W1(29), W2(33));
> -	R2(c, d, a, b, g, h, e, f, K[30], W1(30), W2(34));
> -	R2(b, c, d, a, f, g, h, e, K[31], W1(31), W2(35));
> -
> -	R2(a, b, c, d, e, f, g, h, K[32], W1(32), W2(36));
> -	R2(d, a, b, c, h, e, f, g, K[33], W1(33), W2(37));
> -	R2(c, d, a, b, g, h, e, f, K[34], W1(34), W2(38));
> -	R2(b, c, d, a, f, g, h, e, K[35], W1(35), W2(39));
> -	R2(a, b, c, d, e, f, g, h, K[36], W1(36), W2(40));
> -	R2(d, a, b, c, h, e, f, g, K[37], W1(37), W2(41));
> -	R2(c, d, a, b, g, h, e, f, K[38], W1(38), W2(42));
> -	R2(b, c, d, a, f, g, h, e, K[39], W1(39), W2(43));
> -	R2(a, b, c, d, e, f, g, h, K[40], W1(40), W2(44));
> -	R2(d, a, b, c, h, e, f, g, K[41], W1(41), W2(45));
> -	R2(c, d, a, b, g, h, e, f, K[42], W1(42), W2(46));
> -	R2(b, c, d, a, f, g, h, e, K[43], W1(43), W2(47));
> -	R2(a, b, c, d, e, f, g, h, K[44], W1(44), W2(48));
> -	R2(d, a, b, c, h, e, f, g, K[45], W1(45), W2(49));
> -	R2(c, d, a, b, g, h, e, f, K[46], W1(46), W2(50));
> -	R2(b, c, d, a, f, g, h, e, K[47], W1(47), W2(51));
> -
> -	R2(a, b, c, d, e, f, g, h, K[48], W1(48), W2(52));
> -	R2(d, a, b, c, h, e, f, g, K[49], W1(49), W2(53));
> -	R2(c, d, a, b, g, h, e, f, K[50], W1(50), W2(54));
> -	R2(b, c, d, a, f, g, h, e, K[51], W1(51), W2(55));
> -	R2(a, b, c, d, e, f, g, h, K[52], W1(52), W2(56));
> -	R2(d, a, b, c, h, e, f, g, K[53], W1(53), W2(57));
> -	R2(c, d, a, b, g, h, e, f, K[54], W1(54), W2(58));
> -	R2(b, c, d, a, f, g, h, e, K[55], W1(55), W2(59));
> -	R2(a, b, c, d, e, f, g, h, K[56], W1(56), W2(60));
> -	R2(d, a, b, c, h, e, f, g, K[57], W1(57), W2(61));
> -	R2(c, d, a, b, g, h, e, f, K[58], W1(58), W2(62));
> -	R2(b, c, d, a, f, g, h, e, K[59], W1(59), W2(63));
> -	R2(a, b, c, d, e, f, g, h, K[60], W1(60), W2(64));
> -	R2(d, a, b, c, h, e, f, g, K[61], W1(61), W2(65));
> -	R2(c, d, a, b, g, h, e, f, K[62], W1(62), W2(66));
> -	R2(b, c, d, a, f, g, h, e, K[63], W1(63), W2(67));
> +	t = 0x79cc4519;
> +	R1(a, b, c, d, e, f, g, h, t, I(0), I(4));
> +	R1(d, a, b, c, h, e, f, g, t, I(1), I(5));
> +	R1(c, d, a, b, g, h, e, f, t, I(2), I(6));
> +	R1(b, c, d, a, f, g, h, e, t, I(3), I(7));
> +	R1(a, b, c, d, e, f, g, h, t, W1(4), I(8));
> +	R1(d, a, b, c, h, e, f, g, t, W1(5), I(9));
> +	R1(c, d, a, b, g, h, e, f, t, W1(6), I(10));
> +	R1(b, c, d, a, f, g, h, e, t, W1(7), I(11));
> +	R1(a, b, c, d, e, f, g, h, t, W1(8), I(12));
> +	R1(d, a, b, c, h, e, f, g, t, W1(9), I(13));
> +	R1(c, d, a, b, g, h, e, f, t, W1(10), I(14));
> +	R1(b, c, d, a, f, g, h, e, t, W1(11), I(15));
> +	R1(a, b, c, d, e, f, g, h, t, W1(12), W2(16));
> +	R1(d, a, b, c, h, e, f, g, t, W1(13), W2(17));
> +	R1(c, d, a, b, g, h, e, f, t, W1(14), W2(18));
> +	R1(b, c, d, a, f, g, h, e, t, W1(15), W2(19));
> +
> +	t = 0x9d8a7a87;
> +	for (i = 0; i < 3; i++) {
> +		R2(a, b, c, d, e, f, g, h, t, W1(0), W2(4));
> +		R2(d, a, b, c, h, e, f, g, t, W1(1), W2(5));
> +		R2(c, d, a, b, g, h, e, f, t, W1(2), W2(6));
> +		R2(b, c, d, a, f, g, h, e, t, W1(3), W2(7));
> +		R2(a, b, c, d, e, f, g, h, t, W1(4), W2(8));
> +		R2(d, a, b, c, h, e, f, g, t, W1(5), W2(9));
> +		R2(c, d, a, b, g, h, e, f, t, W1(6), W2(10));
> +		R2(b, c, d, a, f, g, h, e, t, W1(7), W2(11));
> +		R2(a, b, c, d, e, f, g, h, t, W1(8), W2(12));
> +		R2(d, a, b, c, h, e, f, g, t, W1(9), W2(13));
> +		R2(c, d, a, b, g, h, e, f, t, W1(10), W2(14));
> +		R2(b, c, d, a, f, g, h, e, t, W1(11), W2(15));
> +		R2(a, b, c, d, e, f, g, h, t, W1(12), W2(16));
> +		R2(d, a, b, c, h, e, f, g, t, W1(13), W2(17));
> +		R2(c, d, a, b, g, h, e, f, t, W1(14), W2(18));
> +		R2(b, c, d, a, f, g, h, e, t, W1(15), W2(19));
> +	}
> 
>  	state->h[0] ^= a;
>  	state->h[1] ^= b;
>
> base-commit: 7c5ec98f7bcf658cbc7d0094e4a762f6a9c2f159
> -- 
> 2.56.1
