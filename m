Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794558514;
	b=5kzNuXF/VV0rCBzq+d6xy0dPDDJ0XH1vQ8yOQ9mGSYSnwKswkMAxHQD3sVHniyolDkqR
	 rCFHfPZC+fV1OXK0EciNjzKXvisyBcdvYTVYWbuyGikaiphSmYqmRmEYWqhqttNN0O+ij
	 URYboFYAx3cjehPQIVIh5JfeE5yjyBeMSVajfCkYabye3KtHbWVQ0XZkBmwqIq2WEyVS/
	 A6Oz2KybvhimD4rYDPRSi9PmY8m67OI9qWwb1K/qzqefiJT6qwqRFmMPI0n/aEb+5EOZj
	 v6w35JTxYsyjINgaLgAGXDKI/bxpg2t7np39CJscWet34wC4erfF7gdfhHUje0Phj0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794558514;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=fuDL3S12UYHvSEgi8AxvtQqUqHtjhdGn1HZBqKZTGs4=;
	b=B+ltyjhWPVuTOX0RjM0j2gaFYiHkzBQEEhonpB1MevrmLe7S8LgptFGZjyrSD2yHggIW
	 HRTuGHY485huMZNsJBbGyDdOX/ZnFqi94Ht3+XofP9Nt2hdGg8gkMjXucn/IbMPgzUSoU
	 eRwXIiumc1O8QklVs4Kg5sOCTGz6rGLqPoybSZySdG1CZDqwq3LfOcS4QvkDLBChmtTUO
	 XDokmlSqZ7m9Vb0YFSxH4ELHRz5l+ivtqWBJzqhKLx/kbfMTgiB5ZjfO0CF1arbfCg74k
	 Bzpc4TogEc+WRe13dWb7e5eQ+hnuAmueSaLKiubm9tO4/wJSglfWohJBbCaCA60Vo8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gdNSvlEg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F16606BDF3
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 08:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gdNSvlEg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9DA1F000C5;
	Fri, 13 Nov 2026 08:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794558514;
	bh=fuDL3S12UYHvSEgi8AxvtQqUqHtjhdGn1HZBqKZTGs4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=gdNSvlEghsPu/LAVH36iPPqosPMj+tz8hIrq2eL6tNpWt14kihtFftXNnZjQdOdJH
	 4a8VT2Jfee/Lb1CqadFK7rnLfoyM3IdjYDjf9KOHQThOpuzd9ud0v17Mwq3bTMkIq5
	 7MA6IbVYeVgDeAwrIixPYg3xiUnxJkGnC3Gqb52U2bxzMN8JQaQP8QBz/XM6vfFdAH
	 yBsdnfwH6C90aH9nh5/bhJ4kb8K2r/jwUXj27DK3i+Ro4UQqDoOQbCFh35hFssNmsv
	 XH0uHATVbdc7EdBy8qurcyE6lJwi2+AW/yFJa85WKejB8B34xYc3yLnkLfRWHrku6Y
	 SQE2+7XGWbWIg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id C66D61980058;
	Fri, 13 Nov 2026 03:28:31 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 13 Nov 2026 03:28:31 -0500
X-ME-Sender: <xms:Lsr2agKNmPT54fYiYIkUmNsV7PhtfvuNsIXMHBc8tijMrKi6cxeUPA>
    <xme:Lsr2aq-pCskGRrhknyC16YbHvB8F-M0FBhUHLPkn1o8M4rILkowdnCReBzHsYrRjX
    LiMBx3m1XtIdEZtHEs_XWO39_9_73rKQXZvVx2gIE6eLAonY2s7PxRS>
X-ME-Proxy-Cause: dmFkZTEz/52GajNiRCmeDtGUShuAAwqCKp6vZLJhpLLLL9+g59qJfJIn7B5pSvLagvRasy
    z4VGAxktn8j0TuS0pnLJWUFLYHwf92AFUDad7R5tUokdARfJA1sPxM51ryaLXAZDPDAVRA
    jORP9yUMorrH2Keh9ntrMp0jx/XndDzX/P4em+fesd8/D8KAh8u/F6C5pA6ZRKcYY0UcvO
    +UmZmzfFfUWvwjw76lEUMLpSQXnkwmq9aZr1gyFBhieu95KeMf9Y51z9iTjoLweVItiUyQ
    pRPKBHznEQ3Y/MCrCMilNqPvWK7cCJSVu17zw1zNlKZbCXOAe4yhDxN5Abmj/e3YqOs3HW
    ZlW8nX7Jg5/z5Y5XvXe6XFDKXKOAi/7cu+RQnJqvx4Ex8hDR7CpHpG65PLXv6lZD19XIrf
    s/ZcmTJ19gqVE79vPqfKvrH9bT4JJbX97L3rpWo6JheaKFMw9Juv3Tm3AMCOUqDQNAoYBG
    sHuAGJWbHz36zYiFD/1Lh2mNBLhHNzHf0VO9Zf/0Ym/oC5ho4erktT9/E/0hSXHw5ErlRE
    bLmOdydq+DMr28kcVNIR08pePjbCnTGM1y4D2pr9kDARTthaezHjgk9JRQZZaBdg2DupdO
    SuJzGmBBR+CgZdCMA+ETCL3SaEs1dk7j0mFzw/zza03Xu+/gheOuhZeXFr0A
X-ME-Proxy: <xmx:L8r2ap1QBUoFB9OOvaJRG4gtN2-OWS2VoZuEX91VmMikEV8VfSIGQw>
    <xmx:L8r2am9HmdwOZ52yL1MeN5wTqk7c-rkL3gNCIbZXoQJ7CRwKko1DUw>
    <xmx:L8r2aiO312LK42efNJEyav0SrlGw-8xQ-PRLk8IiAjaGDBzq7fcfcA>
    <xmx:L8r2aieWR5jt1zjaaH_4UFxgrOp7bilgkgP_nAB2bX3IGpPNerNj_Q>
    <xmx:L8r2apW1a5qlid91dS7tKUsadQUScdS0gQsOgdz5CNNPD2lMYrLbU5mW>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 824A4F80096; Fri, 13 Nov 2026 03:28:30 -0500 (EST)
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
X-ThreadId: AUERiS3a28FB
Date: Fri, 13 Nov 2026 09:28:10 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <03d006e0-e7a6-4211-8b8e-3f09e9c50ec1@app.fastmail.com>
In-Reply-To: <20261112042513.59919-1-ebiggers@kernel.org>
References: <20261112042513.59919-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: x86/blake2s: Permute original message words in AVX-512
 code
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 12 Nov 2026, at 05:25, Eric Biggers wrote:
> Each round of BLAKE2s takes a different fixed permutation of the message
> words as an input.  For each round, blake2s_compress_avx512() applies
> that permutation on the message words in %ymm6-%ymm7, writing the
> permuted words to %ymm8-%ymm9 where they are used for the round.
>
> Oddly, though, it also copies the permuted words back into %ymm6-%ymm7.
> That means the next round has to apply the previous round's inverse
> permutation, then the next round's permutation.  Which it does, by using
> the 'sigma2' table which has the permutations precomposed in this way.
>
> However, this is not necessary at all, as we can simply do each round's
> permutation on the original message words, using the 'sigma' table which
> is already present in the file for blake2s_compress_ssse3().
>
> Do that instead.  This eliminates 160 unnecessary bytes of rodata, two
> unnecessary instructions per round, and a loop-carried dependency.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/blake2s-core.S | 18 +-----------------
>  1 file changed, 1 insertion(+), 17 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
