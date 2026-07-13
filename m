Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9CE21883E;
	Mon, 13 Jul 2026 02:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783908932; cv=none; b=WciButPTHMs/x2bMXd8gxDIqLPuHTjfasFP5Dmxh53T/clHSMxIJfNQ4UgHepSCKW++KvfyE2seMXZsmcaNE4sTtq3h0jyrPOZtwjwtx/RWVpb3Z322GIHD0etL5r7XRw26HZwMRsuiQFNJ2tNXlg9R9ybvDCb7I+vS9a2PUWrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783908932; c=relaxed/simple;
	bh=MqYD6XtPyh/IjlNYKeybkImoFzI6oxVbHfCCaskJRzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGyAvjjmKvuvWEE9VPogG18i9LVWyxbfqmFDd5oGb8zmZNXaYKVRSQ1OrC0uE50HiucO/TL6kjq7Bgm64+TswVO3rrOq6YNF0eBGPLYP2uoH3aa3+4YnMY666MZJgCpY8Y6w+4s6bGbgTMjdZMTkyRadmO9e5y9uqg2EzVWKfXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=crhGRaOt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="crhGRaOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0841F000E9;
	Mon, 13 Jul 2026 02:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783908931;
	bh=7k0Lzgbjrzc0jwcGLOrgGZCu8dbATW+NlNDQQlTcaWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=crhGRaOtAUi1Dt5grB5AbQXJhQ3+UHpXpziWHU/nyTUufAY+syvELCbHQR1zTvFct
	 kuu4F7BoWhJFLb06EgBYxK49qJLb3qxJk3E+irjTybQrvQMtcqOJHJAIE6t2r5U3F+
	 /TPdnRcDbWgoOZdlgrvNkUhJDlz6Tj1Bt1mbN5fg1Evz3ynjycEx1g0bGN0eOUlF8s
	 7O/XVs3QehjQS7a5PFu3/+C8LG4x1+kVBxJ/mK+Hv4mN4Yiernj0fA+VddkWzM97cp
	 sUEhORijMMQNICwB7R098396W/U+L3MEQ8zyd+q+A/sH28K6DIUrQ7ETILDIV9o7KI
	 fqazt1zmvVYig==
Date: Sun, 12 Jul 2026 22:15:29 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: aes - Fix conditions for selecting MAC
 dependencies
Message-ID: <20260713021529.GD4362@quark>
References: <20260709022954.45113-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709022954.45113-1-ebiggers@kernel.org>

On Wed, Jul 08, 2026 at 10:29:54PM -0400, Eric Biggers wrote:
> Starting in commit 7137cbf2b5c9 ("crypto: aes - Add cmac, xcbc, and
> cbcmac algorithms using library"), the aes module (CRYPTO_AES) supports
> CBC based MACs using the corresponding library functions.
> 
> To avoid including unneeded functionality, that support honors the
> existing CRYPTO_CMAC, CRYPTO_XCBC, and CRYPTO_CCM kconfig options.  The
> dependencies are selected if at least one of those is enabled.
> 
> However, the select statements don't correctly handle the case where
> CRYPTO_AES=y and (for example) CRYPTO_CMAC=m.  In that case the
> dependencies get selected at level 'm', due to how the kconfig language
> works.  That causes a linker error.
> 
> Fix this by changing the selection conditions to use '!= n'.
> 
> A similar issue also exists for CRYPTO_LIB_AES's conditional selection
> of CRYPTO_LIB_UTILS.  The same '!= n' would work, but instead just make
> CRYPTO_LIB_AES always select CRYPTO_LIB_UTILS.  CRYPTO_LIB_UTILS is
> lightweight, and it's needed by most AES modes and many other things.
> 
> Fixes: 7137cbf2b5c9 ("crypto: aes - Add cmac, xcbc, and cbcmac algorithms using library")
> Fixes: 309a7e514da7 ("lib/crypto: aes: Add support for CBC-based MACs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
