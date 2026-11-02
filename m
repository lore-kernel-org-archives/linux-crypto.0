Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793611016;
	b=Gi6oyaat7VKB/rV4XfjINTxUiQv7wBjbKuF6mujIXoOgT2jbwnwzekjfV/09jtt8Xd1u
	 JB7cVFEpSFB/ycMiUdh9l+Obc3M/7PUaxuR2EWqPp8KJtsZpWLUUORtpwnMVAJ4qYcGBf
	 G+C4xtfCUweuKzWdgesAxob/y/UGlr7dQeqcDRvn3YHypYQHHRUbUwp8QSkEkb3TzhgoR
	 KtSqVqqDjtlt92oYyYrGIal9gJkYpwNGduQYMgyZkS/tC7OmDAbC/uBP0U8N13GVtQz5d
	 RTorsP+3lYtlZvGO+4cj4lwHMRrlx4ecWYFraTqsb+iNXOU++rNCrJFL3YCWvZ/ncMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793611016;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=fEH04FadFLQr70qSIXqkoae8wjtrp3fBYKrHpNz6edo=;
	b=NGtoaS0x6jtJEG+fcM05nz0+BbrIp7/MKF8bvPtboGJPiLW55tEsFODKozt7MAFpzOAL
	 8aBlbzhe5tdP4B48SnZluspr8RG9FQB0BEBKVC/w7N7xv0M9WUwkxqvo31UUF4bIGWv96
	 YMMNh7o77n8it6EpTTyZz0nT9xlZm6qKFlh/l8WuKJzxRwedbF1HiYpV61oE/HQWg8Gvg
	 ICGQXLLMbbwqXDWTE2i+6q/xqWdvzzHQaiqeEJor4yPUtE5R9duuc4eKmXjv0ZgjaSXCe
	 JnF3MnhEkfsJ7Zs3u60C9KXtdwK3pFkEAdGR+wN2JtQCuNEXon5tTyxBqVWXSde5XnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CK48mHEu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C057606A324
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 09:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CK48mHEu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAD61F000C1;
	Mon,  2 Nov 2026 09:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793611016;
	bh=fEH04FadFLQr70qSIXqkoae8wjtrp3fBYKrHpNz6edo=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=CK48mHEuAw2z5AiPE195/y1wZdBnYnfifL1/2380Ahq0UzIj0reYpdTO2v1bj0MWY
	 q5BafRGaFQRI/UhDkyb7J4pwIcXT+jsThwZByampTjKBY3UQV1GxS78bEZTEz/TJl9
	 cHYLaodFY3iO/hDjt1ZILxDXTJQOQKQA9LpvYiO52Ypi/600JT3xGRTw/c6e9aSa7T
	 ayBG4rMXFMIKb4DmejSoRhvH5dibMc8B10WCwKhSTlt4AxzEGDPv8aA/csteXGevuL
	 f7fughsTKPn1KzMLBCTqmcVWbYhRNlvDDFZjUipiDnndIAfp7ooqK/MAnxhhAWgz6h
	 LXBquBpWKodQg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id DA40B198003A;
	Mon,  2 Nov 2026 04:16:53 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 02 Nov 2026 04:16:53 -0500
X-ME-Sender: <xms:BFXoamLnvbGyrU59mAcCHmqGQ7N9zoHX93Ag6I9XL2E3dSs-EOkNbg>
    <xme:BFXoao9kpHGLBq78vGV_2okHthv-yVOg5k9bIrSKQUJSJDcjXHPrzkqkYl3PrjT6X
    3I73wThezmk3m57oGChRIU-pMZ6nXHtdgrR_N87q_Mr678TeNjuOyG0>
X-ME-Proxy-Cause: dmFkZTEGuTs347uE1l326fUoY9XVM2teM7miInQD8/2T3S2SZxx4Y4ZkIYo63FTkItv5dH
    j9xwQxn1IeInhs0cUss0gbVSMJTA0wqsPtz9Q/rRmvEy+5Qip4zKDVL0WNZr5hECebULgB
    rAuuHcdG/HzlrG9gHd7wK22CoYBSJAPdH1oUjuI7QQueY6KqXQ2MEZNfwWD9bRbUjZjPsX
    v96y1tjwOU1PgCO4n4WvvYt2WuME8iNzTV9EqZmTr7vFnHuRMhGtrTeUFCuQvp/PcfVFho
    zLlnLlAhqVVepagsF5jFQHE9Mgb3N40Uh6oH8jj9w9HbSQlTsDtgIf8yeXAx2eZuys8wp9
    A02TwVv0CtJz5hQgA+zoa3dJMbFeTl+5Txu2+s1L8/ATEhT5jpRAQedXiOrGIbOw0JKPmt
    l0u8YWhHq4SV3GRLHg5mULkSNRK+ojstWKyBjjcv0jL8nBMlgNCwSuqZ+8BeJYuGIswfe8
    Mhc1FqPvRAZkpiLMA0iuOTdbHJFhdpvB14uLiVhaUjxUJLu39Y8x+FGZt0MPWiqsLFQWFH
    IDiqpGigezlqTHxISFa44UnBBXaW5O8CXqFM1C/35b2dM38S8SlmMb5plRd45dt9UqeVjx
    qZv2BsePBDIPC83JRUrqWTHpZHlfKnVz52x9/3ATu3IYY7d3aAGU+REbs5mg
X-ME-Proxy: <xmx:BVXoav1ax-9TnN0UREBNr8_RO5SZiutHtOAoWQk6wajBqKnd40R3fw>
    <xmx:BVXoak_yCZZNEyzJmy-clxFHfHGRDgeBbh4_4AmFOHXXNMY7Jma6dA>
    <xmx:BVXoaoO41Vf3j36ovcO-fuPxe0aFsRqTlKyLTL5eTzWOX56OE4el0w>
    <xmx:BVXoagdsKqJIzE1_GuG4kGCcPk0E1H6guWh0cMZCjL7SoqZS818NYg>
    <xmx:BVXoavUFqAaYk3O7nLmdtkmzj9GUlfcpJGOlMzehhv9TzY_fwMH6K1M3>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 9DFF9F8008E; Mon,  2 Nov 2026 04:16:52 -0500 (EST)
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
Date: Mon, 02 Nov 2026 10:16:32 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <bea12ae0-ac2d-40f9-b5a9-8836e3be4122@app.fastmail.com>
In-Reply-To: <20261031042637.68815-1-ebiggers@kernel.org>
References: <20261031042637.68815-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: poly1305: Hide the mask value from compilers
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 31 Oct 2026, at 05:26, Eric Biggers wrote:
> poly1305_core_emit() does a constant-time select between h and h - p,
> where h is the accumulator and p is the Poly1305 prime of 2^130 - 5.
>
> The mask used in this select isn't hidden from the compiler, though, so
> the compiler can infer that it's either all 0's or all 1's.
>
> In theory, the compiler could then use that to recognize the select, and
> "optimize" it with a branch.
>
> Fortunately, in practice, I couldn't find any gcc or clang options that
> made that happen.
>
> Regardless, add OPTIMIZER_HIDE_VAR() to "hide" the value of the mask for
> safety against any future compiler optimizations.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/poly1305-donna32.c | 1 +
>  lib/crypto/poly1305-donna64.c | 1 +
>  2 files changed, 2 insertions(+)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crypto/poly1305-donna32.c 
> b/lib/crypto/poly1305-donna32.c
> index 5977785cd76e..73fe9181296c 100644
> --- a/lib/crypto/poly1305-donna32.c
> +++ b/lib/crypto/poly1305-donna32.c
> @@ -167,6 +167,7 @@ void poly1305_core_emit(const struct poly1305_state 
> *state, const u32 nonce[4],
> 
>  	/* select h if h < p, or h + -p if h >= p */
>  	mask = (g4 >> ((sizeof(u32) * 8) - 1)) - 1;
> +	OPTIMIZER_HIDE_VAR(mask);
>  	g0 &= mask;
>  	g1 &= mask;
>  	g2 &= mask;
> diff --git a/lib/crypto/poly1305-donna64.c 
> b/lib/crypto/poly1305-donna64.c
> index d0e4234c1c4c..402a3459ca49 100644
> --- a/lib/crypto/poly1305-donna64.c
> +++ b/lib/crypto/poly1305-donna64.c
> @@ -152,6 +152,7 @@ void poly1305_core_emit(const struct poly1305_state 
> *state, const u32 nonce[4],
> 
>  	/* select h if h < p, or h + -p if h >= p */
>  	c = (g2 >> ((sizeof(u64) * 8) - 1)) - 1;
> +	OPTIMIZER_HIDE_VAR(c);
>  	g0 &= c;
>  	g1 &= c;
>  	g2 &= c;
>
> base-commit: 2a500a04d6f969318c05f46aedb6e73fc1963a00
> -- 
> 2.56.0
