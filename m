Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795517934;
	b=T7bhLBYcPekVD10gk5x7n9IhTeZ0Bn/0OIP6ia/wjR3DOt3ughaoupvAetq4oCeiZNhi
	 tZBEhrFRr0d530ckZRx3rlph3lMHdNmeqGNj/4+BuSxIZrHhkqB1ZQFzb8IyfN7uiJuEy
	 lPqC//iNHsuenzE+/t4uetAkfuVaVJh97kI60ReoHuR6LDURF4z/ZFL+7I9CI5/R0uSYb
	 QB7uTetm4BP9JS7VuFWT5xSVSFnyoqGsDZ1oo4nrZ9xtLY3m8KkcGITWZJoqtbJnkRALv
	 mtXEKi7pEShOFyCMC6w5tBc8iMfCGr5QG4UBDgkeEeilyYj4e6Sp84Iu9FVQg157j5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795517934;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=loJgnBThAPP7N9gK2bTD7cedCyKni6kPmCoczoBNmQk=;
	b=tMmkgHWaRa0rcS+HzF9gfQR2w6/wP0soxm/Gl4z1OB1V+Q+e/Mntx0y9uAJ2xDo1hPn2
	 S1qtItER2lj3AXa1JupLGxRTpyBuOSnayaLN46j7Q90xXZ5d1/AgHUje8etkMdKoEEB6L
	 /VVdbz29jBu0Tuh/kJXH50MtTK+neDYo7MFlWKp7DrfIRmaTeEZpwmA1+RJczFlmpN0QO
	 NFphDjqZ1GCTX0bIlLeV3x0a9yyj0QE05H3NE71YXyymihx3BYcdJITsNCPADnA0jgWqD
	 i2nsYE4bhW3mMr5H8P8dcWKl7BNBL79yWJuojhrnZE60Zpp6/05jLU33lhyPzUsAccg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KLUxjEC4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11509606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 10:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KLUxjEC4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487041F000CF;
	Tue, 24 Nov 2026 10:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795517933;
	bh=loJgnBThAPP7N9gK2bTD7cedCyKni6kPmCoczoBNmQk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=KLUxjEC4J0oaKXw5azKBug8KwEqlF8TcdD4CBz/xy45e0z8oM8bdx83foysdU5QkN
	 btWuGItxKXQX2g7BM2jDM4Esm/6cPAwIxZDLhn01NKRKdBNcxi8whTC1UJiOnxUTiw
	 40XqO/1JGl8kfU2/E10X6sSSZNnc5vdjIfXu/e4acytyKhwC1gMUCZO9vGyJX9xcJA
	 pGAw/Ed0JCdLviY5fWyrgx7Vvml8q2ELrw/Y6evwozmriF+i60R8Ep+OPMe7fhsGkz
	 TEMxArHFGrZd2y2LQAWVolJ0YJJyW/9q1npCfzQ+7U3NgapmZEgkjxI3rH3KEyBTuA
	 EI4vnqrOdVAwg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id C00CE1980047;
	Tue, 24 Nov 2026 05:58:51 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 05:58:51 -0500
X-ME-Sender: <xms:620Fa3_xI0oly7yEcWYGf7LuG-Qas8Lxa-9D9CmL-loGu4LXenm0Rg>
    <xme:620Fa-jA6HrQoclKRKB2u5BT_PxVwJL3xggbGespPTUiAnFFWZ3iTZ_PKbIGZca4e
    dMvQKYXeKCnM2X0FeU7n444dvvKGO6e0cz4s2G8e8JGuCmuxliMPK8>
X-ME-Proxy-Cause: dmFkZTGWvcBw4rr8XO6BETQ/FW55jRiPh50MCqF6K8Ckk5IFL1Il5xunlxbkXd+x9YEZjN
    i2ot02usby8/T116ZoxV5eGUiyzlckjc0WLx6wWYmidjiMiMKbSGSO+4XmBBRXJZVRyJ8k
    SpSdP1fHKChCu9HBXPZHC2nb05dyLqiQfO/XxUYdY/7s2I4d3E+ho5bCrb4Xg/P+3ndqZx
    bZZvWs1ubdWVmTy0oZcUy/7Py+qA3UCgGBO+s1n6kBHxezE+xigih6C8by8O73MfsqQFY+
    NbSA/kUTbiHHIi0iGS4JQvqAviHJEXb4dX8xQYEpfv74K3IPLnIvC6bikWtzeyRQ7uBffR
    Xi387P1E/PTyzyui2uR8dvuag064+I5y9MACpRh1SQrXEVjczrt3C0GqGAIJODxD777WNA
    unkPkwIsg8cblEEDCIYYDbVhmtBTkHlZngYHVGP3cH7zFP+w+wZW62QnKPi+ARnufTWNEX
    WEBM3OL3F0yCYADgBpmxgGWT7FpCOClDNDLn0N9yU4DUAdVs0D7VIkqg9BjKAPOMsS8wjw
    OO312fePXetxk0B6Frku2D3264cgs3uX6wqA2O69Ljpd9TwR5eIIYsXUEJhPvgW7XyyStd
    9RApS2YoqFXvS4MKSSVjK3/bXcIUiLeqjGd2k+DeNRgIt3u9Z/yWH82StmUA
X-ME-Proxy: <xmx:620FayRoJ26qnVtaLRALwhNSKb57WRa7E52rBQYFRBeQ6VmsjoaSUw>
    <xmx:620Fa7fw-H7gVjFyXXgCCDziasWW754ahd93XzKvaU9cZHv3UDcFxA>
    <xmx:620Fa5pCupt4UP1EEFyv_ycCl_uc9DT5wYtuawUyZeRrDt5_3qgbSQ>
    <xmx:620Fa08nCnwwyZi8P1WnqJ2Zvx_8Ads5jdkQ8lj3FWsEsX_iw0vFPQ>
    <xmx:620Fa9eF7RS8CRAZAy6Tnfr2ZHNryFtWRuWvVNkmefmO_WshAumNXbFc>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 108D5F8009A; Tue, 24 Nov 2026 05:58:51 -0500 (EST)
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
Date: Tue, 24 Nov 2026 11:58:30 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org
Message-Id: <708e7bb2-88f0-4ddc-9e4b-a66a95ae8025@app.fastmail.com>
In-Reply-To: <20261124083736.247567-1-ebiggers@kernel.org>
References: <20261124083736.247567-1-ebiggers@kernel.org>
Subject: Re: [PATCH v2] lib/crypto: x86/sm3: De-bloat sm3-avx-asm_64.S
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 24 Nov 2026, at 09:37, Eric Biggers wrote:
> sm3_transform_avx() previously unrolled all 64 rounds, resulting in 9567
> bytes of .text and making it currently the second largest object file in
> lib/crypto/x86/.  Additionally, all 64 round constants were inlined as
> immediates, despite the fact that all round 0-15 constants are rotations
> of one value, and all round 16-63 constants are rotations of one value.
>
> Therefore:
>
>   - Roll up rounds 16-63 into 4 iterations, each doing 12 rounds.
>
>     12 is chosen because it's the least common multiple of the 4-round
>     rotation period of the scalar state registers and the 6-round
>     alternation period of the two XW stack slots.
>
>   - Generate the round constant for each of rounds 1-15 and 17-63 by
>     just rotating the previous round constant.
>
> This requires one extra GPR (KREG) for the round constant, which also
> serves to terminate the rounds 16-63 loop when it reaches the "round 64"
> value.  Free up %rdx for KREG by replacing RNBLKS with an end-of-data
> pointer stored on the stack, terminating the block loop when RDATA
> reaches it.
>
> The .text of sm3-avx-asm_64.o shrinks from 9567 bytes to 4257 bytes, a
> 56% reduction.  Performance is unchanged to within 0.2% on AMD Ryzen 9
> 9950X (Zen 5), measured using the benchmark in sm3_kunit.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> v2: Avoided spilling RDATA and RNBLKS to the stack by using different
>     methods to terminate the loops.
>
>  lib/crypto/x86/sm3-avx-asm_64.S | 236 +++++++++-----------------------
>  1 file changed, 68 insertions(+), 168 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

