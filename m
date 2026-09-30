Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769A23AF674;
	Wed, 30 Sep 2026 05:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790747465; cv=none; b=Sp2OuRyf3MOWpIF1IKQWI4upqnRvihCeTM4D+5uy4g/GS1oDMjPkKnMasHx2gL2gitLb3hA7lJE8K9mfTIZxdGXRcImxaL71OE+l2wMRByvSHxyHeHtet/GVlKLMkDAsUkxaUSpF3LlzkN3zQRNEOoM56Cw4pp72GIjNX9j7ZNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790747465; c=relaxed/simple;
	bh=SBMQ5qrAZ5yu/0snOz+uE+yYBZur5j7xEmTmr+qRiks=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=rmJZ0VUaEQoyh9c2cu9w+hl6IaEPdI3Z1WOb7CZCaXrDvii3RsFTvchmEo66wyzOVtw9SqvjeKES4XXsUrhUh8yXsuXLqlHWFtKWRZQrzKR1iLOVWOi4Ga4G8rLwjWxodLvTzxLBPuZ+MxTmvZweF5B4qJe2nlfQzhsBs264xBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JRWQk1Yv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JRWQk1Yv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3BB1F00893;
	Wed, 30 Sep 2026 05:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790747464;
	bh=IHbXRYFtZI/bnUL44bF/j7F87IwMQs0LtRsynOSxKXI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=JRWQk1Yved9WLkp5iDT2l+W4Pxti1bacMKwdch8K67TADhlddurQ30A4A5F/8HISl
	 NoIv4ZyBMsAvyjdP0uOeaPFUy394ATqMpGt1f61VDPi5w5jWvTOclxnE24jNdc9H1A
	 kf5Fxji/LdIB5zXKbmz28H08NPCkE+pgbPr53EWUH9QHEFX3uMv1uueMhYR0UVCJOg
	 yUWsOvu3SNSZWp6dZpemY6E09U/F4vSsIuNuAvShMTseS6/wCe5CRXw9U7Kin4BRuj
	 OvcRVSzTYFoXCoUMDK+Txu2bXCL1+nv8uwmy0imbvn+RzvWBGiO519I5d1mCExDvZM
	 3zwP+/Y9yN4Ww==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id AB04D198003A;
	Wed, 30 Sep 2026 01:51:01 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 30 Sep 2026 01:51:01 -0400
X-ME-Sender: <xms:Q6O8ahG3cE6hJrrWPvOHOxJI_sj4cG0tKJ3gyTh1Rc01OIcj9A15Xw>
    <xme:Q6O8ahIMsgcBmKpDLhZ6VqJXmP3JOlRLqArFDaOIDAFepcnUnYWR059HrGs3Q1ujd
    _qvEUkn7HoFrqogAGprlfUrMI6-z9xB6nQ3vX11q_OtJxBZwUjoD6E>
X-ME-Proxy-Cause: dmFkZTFSJcrBtQWEbmdY9KpRSSoNya1P4NnDPRL0fhq6fme4Lw/QJwVgh+NPSHPIjqR4J/
    uLo7iJyY81KO5H0sJqBay6vB2ONbtDM0dIHPKbvJXcTXNb2DO2K89CdBmPVL9uuVr6U78i
    rqRZDe9K3iQJZCJEaOaeXRGcG63+UB9h/g4B6sOpgBK7xA5MzZnUimcHNlhBOR1UnbsXIC
    Jmb24i7auxNzjx5Q+/xyRaRfb6RPnfxQBd/xGlLacbRyfo8E7aKAC4SKPg7rgtgajQ0Owi
    rtSk1hTQRVoNJ5Ustc9qXMBOLS9tvhcVEaB7Z4KULJBcfZyyePN63Zsp+H9DI5D3FH66RA
    xVFWR9bi6DKxsbP+JMa+ISwENtr1o43QAaQvOrh/W6rQB7UqcJDuNoKK8kGOV8Yaut/VyL
    y6Eexmoh5i982aiwQXfhN7xRz5WK7CJ6K5ez1payzrbA9j/bXx2F+gAFmM2EEDPT8aTGGx
    g+PRK8WIEog+bmVvY3kQ5MG7RzXunWBRNHTxp3+NqXlTq2HGJVk151lWxcdDKd10YpaZ2w
    icyncgC32Wo+p0hnjT8ObOzkA9p/8L6HyhMoWDNcZYk4iJAQ8bWoTIR/TyTsNbd+4Bc+3x
    IvL/r2GTs1TeEOix/Z32LO8iMw8YC3dDduEMVbLUmxPG+4BGQQOvPFP+oQ1A
X-ME-Proxy: <xmx:RaO8ahmjwdKSKPOOT5txvlsyRBH7wyx9hsm3N4fc1vwLmkq3fASShw>
    <xmx:RaO8ao3lvp5JRqaPWHXwB50mzLKN3v5G5aWvThT3RfqNpJPAq9n2wA>
    <xmx:RaO8ap27Q4DSgEebLq8jZhzBqClz246rb9KCQaFX6470Gch2i76yvw>
    <xmx:RaO8airQ1cT0-wurEpBpIwsaGgKZkatGkZSpHCAGgwRsgPDIgumSNA>
    <xmx:RaO8atgy5cH95NBmzqhWGG5Fk_VXrnY_fNvoaH526uy4sRHgqMOq_mhG>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 511E2F80086; Wed, 30 Sep 2026 01:50:59 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 30 Sep 2026 07:50:39 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, "Stian Halseth" <stian@itx.no>,
 sparclinux@vger.kernel.org
Message-Id: <2b9f2387-924a-4a3a-bb35-32a8a7cfef5d@app.fastmail.com>
In-Reply-To: <20260929222752.36427-1-ebiggers@kernel.org>
References: <20260929222752.36427-1-ebiggers@kernel.org>
Subject: Re: [PATCH v3] crypto: aes - Fix undesired override of some optimized AES
 modes
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 30 Sep 2026, at 00:27, Eric Biggers wrote:
> The new library APIs for AES encryption modes were wired up to the
> traditional crypto API via crypto/aes.c.  However, for now the kernel is
> still in a transitional state where various architectures still have
> architecture-optimized implementations of AES modes in arch/*/crypto/,
> wired up to the traditional crypto API only.  Because of that, the
> crypto/aes.c algorithms were given a cra_priority of only 110 to prevent
> them from overriding arch/*/crypto/ in the traditional crypto API.
>
> However, because of how the traditional crypto API works, the
> cra_priority trick doesn't work in cases where the relevant algorithm
> isn't directly implemented by arch/*/crypto/ but rather is provided by a
> template instance using other code in arch/*/crypto/.
>
> For example, x86 doesn't have its own "ccm(aes)" but rather relies on
> the "ccm" template constructing it from the x86-optimized "ctr(aes)".
> The existence of the library-based "ccm(aes)" prevents that, even though
> its priority is lower than what the template would produce.
>
> Thus, "ccm(aes)" ends up using the slower single-block AES code.
>
> Therefore, skip wiring up the relevant library-based code to the
> traditional crypto API on architectures where this problem can occur, as
> determined by what exists in arch/*/crypto/ for each architecture.
>
> This is ugly, but it's also temporary: these conditions will go away as
> architecture-optimized implementations of AES modes are migrated into
> the library.  But until then, we need to prevent performance regressions
> by ensuring that the optimized code continues to be used.
>
> Fixes: 20df21a482aa ("crypto: aes - Add CBC and CBC-CTS support using library")
> Fixes: 8ca62072faa1 ("crypto: aes - Add GCM support using library")
> Fixes: f70ad727d1d6 ("crypto: aes - Add CCM support using library")
> Fixes: 94efa0c9fb36 ("crypto: aes - Add XTS support using library")
> Closes: https://github.com/sparclinux/issues/issues/106
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is intended to taken through libcrypto-fixes
>
> v3: Also suppress xts(aes) on SPARC, and improved comments
> v2: Fixed PowerPC config option, and resent as standalone patch
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>


>  crypto/aes.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 47 insertions(+), 4 deletions(-)
>
> diff --git a/crypto/aes.c b/crypto/aes.c
> index 94791f481e98..51eee78396ea 100644
> --- a/crypto/aes.c
> +++ b/crypto/aes.c
> @@ -637,7 +637,18 @@ static struct skcipher_alg skcipher_algs[] = {
>  		.decrypt = crypto_aes_cbc_decrypt,
>  	},
>  #endif
> -#if IS_ENABLED(CONFIG_CRYPTO_CTS)
> +	/*
> +	 * Don't register library-based "cts(cbc(aes))" on architectures where
> +	 * it might block a "better" implementation from being instantiated 
> via
> +	 * the "cts" template.  These exclusions are temporary and will go 
> away
> +	 * as the arch-optimized AES code is migrated into the library.
> +	 */
> +#if IS_ENABLED(CONFIG_CRYPTO_CTS) && \
> +	!(IS_ENABLED(CONFIG_ARM) || \
> +	  IS_ENABLED(CONFIG_ARM64) || \
> +	  IS_ENABLED(CONFIG_PPC) || \
> +	  IS_ENABLED(CONFIG_S390) || \
> +	  IS_ENABLED(CONFIG_SPARC))
>  	{
>  		.base.cra_name = "cts(cbc(aes))",
>  		.base.cra_driver_name = "cts-cbc-aes-lib",
> @@ -687,7 +698,13 @@ static struct skcipher_alg skcipher_algs[] = {
>  		.decrypt = crypto_aes_xctr_crypt,
>  	},
>  #endif
> -#if IS_ENABLED(CONFIG_CRYPTO_XTS)
> +	/*
> +	 * Don't register library-based "xts(aes)" on architectures where it
> +	 * might block a "better" implementation from being instantiated via 
> the
> +	 * "xts" template.  This exclusion is temporary and will go away when
> +	 * the library AES-XTS is optimized for SPARC.
> +	 */
> +#if IS_ENABLED(CONFIG_CRYPTO_XTS) && !IS_ENABLED(CONFIG_SPARC)
>  	{
>  		.base.cra_name = "xts(aes)",
>  		.base.cra_driver_name = "xts-aes-lib",
> @@ -980,7 +997,20 @@ static __maybe_unused int 
> crypto_aes_ccm_decrypt(struct aead_request *req)
>  }
> 
>  static struct aead_alg aead_algs[] = {
> -#if IS_ENABLED(CONFIG_CRYPTO_GCM)
> +	/*
> +	 * Don't register library-based "gcm(aes)" and "rfc4106(gcm(aes))" on
> +	 * architectures where they might block a "better" implementation from
> +	 * being instantiated via the "gcm" and "rfc4106" templates.  These
> +	 * exclusions are temporary and will go away as the arch-optimized AES
> +	 * code is migrated into the library.
> +	 */
> +#if IS_ENABLED(CONFIG_CRYPTO_GCM) && \
> +	!(IS_ENABLED(CONFIG_ARM) || \
> +	  IS_ENABLED(CONFIG_ARM64) || \
> +	  IS_ENABLED(CONFIG_PPC) || \
> +	  IS_ENABLED(CONFIG_RISCV) || \
> +	  IS_ENABLED(CONFIG_S390) || \
> +	  IS_ENABLED(CONFIG_SPARC))
>  	{
>  		.base.cra_name = "gcm(aes)",
>  		.base.cra_driver_name = "gcm-aes-lib",
> @@ -1012,7 +1042,20 @@ static struct aead_alg aead_algs[] = {
>  		.chunksize = AES_BLOCK_SIZE,
>  	},
>  #endif /* CONFIG_CRYPTO_GCM */
> -#if IS_ENABLED(CONFIG_CRYPTO_CCM)
> +	/*
> +	 * Don't register library-based "ccm(aes)" on architectures where it
> +	 * might block a "better" implementation from being instantiated via the
> +	 * "ccm" template.  These exclusions are temporary and will go away as
> +	 * the arch-optimized AES code is migrated into the library.
> +	 */
> +#if IS_ENABLED(CONFIG_CRYPTO_CCM) && \
> +	!(IS_ENABLED(CONFIG_ARM) || \
> +	  IS_ENABLED(CONFIG_ARM64) || \
> +	  IS_ENABLED(CONFIG_PPC) || \
> +	  IS_ENABLED(CONFIG_RISCV) || \
> +	  IS_ENABLED(CONFIG_S390) || \
> +	  IS_ENABLED(CONFIG_SPARC) || \
> +	  IS_ENABLED(CONFIG_X86))
>  	{
>  		.base.cra_name = "ccm(aes)",
>  		.base.cra_driver_name = "ccm-aes-lib",
>
> base-commit: 93f51579e7df248780214094418f205253383cc5
> -- 
> 2.55.0
