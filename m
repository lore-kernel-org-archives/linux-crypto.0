Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794344793;
	b=hIVTnU2mG4iYXGM1zJ1ve07sq2qr2+raEDgsPooAViEMeiUim8t9Z4YPnS/D1WkEIKES
	 nETcG/d6JiUY2DZOgt0woCNkAa31BXJvGTXH1xScAo7Tphq2l0foWBNLLwfK4sTBzCZwS
	 8w+UJivujriZBSesaYz3LItJ1kDf3SxqHxnIApSgHhiHegyPCmr6IWT9lbjQcpH/YOnrq
	 B/fFjvkgwM9kPUvRvCm78GCw2zhtXpL7MGiq8uggLUDwENeUlI5I8tVy3LNvl+gd6qDh7
	 VIZCX37vQOsoAy/34VJn52HXaIe9aw7LyXhf6Os9CDUJ3+DuKBczJrbGg0LSI0AMXEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794344793;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=gvFWqio/V9hzEqiVCMxAfOwWWqkCgy+VVi7hZNerAjc=;
	b=TnUC/m+ojJeqAmi66pFOywkrZsUAcV4gOmmK+B/WJnQRjbQAeoTqmwKs8QFiEAv079m1
	 kkz6MEdGYuT3W/x2osbEorC0LA7dA8vDMC3O1Cs+MUN1ImULIwTd9Mmo89I5/ILbGegPI
	 k/in9Gf/32hx9Tafuf4cD2/xZglRc7xEaQ2SdpncuozKLycb/zkvb4maaiiXhvbdOu6t/
	 MAM+wOB726qKjd8XyZIl+p6c6tSlHaKXU+YU9C+Wxc9oLe7T/4aq4EWF/d5oWloWed8gF
	 zZcYctjMxjdZb/FPQvfvDsJmN8L1D3pSAJYXpa+B6GzenfA6Wk3d9LjISX/auS52upw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Usp3eWU6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266F8606A320
	for <linux-crypto@vger.kernel.org>; Tue, 10 Nov 2026 21:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Usp3eWU6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8371F0089F;
	Tue, 10 Nov 2026 21:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794344792;
	bh=gvFWqio/V9hzEqiVCMxAfOwWWqkCgy+VVi7hZNerAjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Usp3eWU6UCaumbGlTP32QlBGf+GrRTldOtRig70TjugpHeY9nDlP3haBpHeOAAeKc
	 N8bs87ku0ttil+ciVrMW6dzJY8GZ2xMlDdr0DAE0BJ3Ebk/w3m2Bh34WttA0eVu2Dv
	 1kDL1v1q2vtjfO189PwUm5jHY2xa1j7woDTftdsDwKqp1Kjf0MrS0kCoxrhmN2v59P
	 hMKuBec4p9xsmdBT/F0gPHu1aeGl4jkHJuT4M8CQkDRrFf1l80cKEnDjGqCwDtKKS3
	 WRE16CH4Tx5ckDc38CWDaFLDugl12jRnVP+/zAgwNMbi0IKs/CWlpgEWsNzHbdfCh5
	 FStqbYEV7nwng==
Date: Tue, 10 Nov 2026 13:06:30 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] crypto: arm64/ghash - Reduce boilerplate
Message-ID: <20261110210630.GA1907@quark>
References: <20261109164502.905237-2-u.kleine-koenig@baylibre.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261109164502.905237-2-u.kleine-koenig@baylibre.com>

On Mon, Nov 09, 2026 at 05:45:02PM +0100, Uwe Kleine-König wrote:
> Make use of module_cpu_feature_match() which expands to nearly the code
> that is typed out.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> ---
>  arch/arm64/crypto/ghash-ce-glue.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
> index eaf2932ceaf5..0884f812a315 100644
> --- a/arch/arm64/crypto/ghash-ce-glue.c
> +++ b/arch/arm64/crypto/ghash-ce-glue.c
> @@ -384,7 +384,8 @@ static struct aead_alg gcm_aes_algs[] = {{
>  
>  static int __init ghash_ce_mod_init(void)
>  {
> -	if (!cpu_have_named_feature(ASIMD) || !cpu_have_named_feature(PMULL))
> +	/* ASIMD is implied by PMULL, but better be safe than sorry */
> +	if (!cpu_have_named_feature(ASIMD))
>  		return -ENODEV;

The ASIMD check can be dropped too.  There's already other code that
assumes PMULL implies ASIMD.

- Eric
