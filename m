Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFCF38D3EE;
	Fri,  2 Oct 2026 21:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790977344; cv=none; b=gwisFylrGFFiFb/jJux9VlT/T6UgrDFrNyZICfuIPT7p8RFTLEJtoxa2BNj9gmaCmww3TH3CA0ztm5U9WHgJYnOrtiR76++VdJwV/BUSwQ5kWFv7gmjtfwtTW8NKBztKlDefzaHMQnfduIn+eer+1sb1SjAc3KCfb8fwQvnJng0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790977344; c=relaxed/simple;
	bh=fA/3yP/tycw897VAux1o4UhlIS6ZiMpS/cNFCDaRGLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvd+Dmmiz4tt8S1X+T4Ru1IRuNLU2FIv3LwXEO4pTUNqa0T3CyoFFBkAVtLhLZ+LOUvL6zKa2DXwggooaoeDjottAiD6fmsOo+v8M0bDlxOcNl0qX/FX7G46CcE1Ai6ZlcvfkxCFckNkrzYuVlQA+6Gq7P3xb8XMNGT7LQwOzSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WakhPxcW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WakhPxcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F81F1F000FF;
	Fri,  2 Oct 2026 21:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790977342;
	bh=0UceBJ6mv2L+WxafCqYm+U6/5kEBJSxYHlW2E86WhGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WakhPxcW6ud7Bo8GMLTMxHtWf+WsgZAF1nmajon8oZCyX+fCZBZktWmuRnynd472N
	 2e+Et2SffG5Lk4KY0F2qpZPaahPsRQQzjAfKGoBbNLY0giOFcd9g0PRja2O7gBFdu0
	 QEmNxB7BCPyv4DQgLXLVdO+asvuQ1xCkvAhCUVx8ftWMA7VBCMhd/D1RSJ0rex638V
	 zdPyoUl/fs/oGdm6t15MCoYmXVMEPBLwHge+cnAyIs2wGhW7UaTFDya3hkNjBaHr+N
	 1Q5JN07QYYgcsd+CQmCgMhWrtEu/WQJBeTJsLe54LgOruShn9X+AersaDU65MdQNy3
	 dvEZvWsqN+CPA==
Date: Fri, 2 Oct 2026 14:42:03 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH 0/3] AES library fixups
Message-ID: <20261002214203.GA3006@quark>
References: <20260930170542.140403-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930170542.140403-1-ebiggers@kernel.org>

On Wed, Sep 30, 2026 at 10:05:39AM -0700, Eric Biggers wrote:
> A few small fixups on top of
> https://lore.kernel.org/linux-crypto/20260927224418.109759-1-ebiggers@kernel.org/
> 
> Eric Biggers (3):
>   lib/crypto: x86/aes: Set RNDKEY in aes_cbc_encrypt_aesni()
>   crypto: aes - Boost priority of encryption modes further
>   crypto: x86/aesni-intel - Add transitional selections
> 
>  arch/x86/crypto/Kconfig    | 12 ++++++++++--
>  crypto/aes.c               | 12 ++++++------
>  lib/crypto/x86/aes-aesni.S | 25 +++++++++++++------------
>  3 files changed, 29 insertions(+), 20 deletions(-)
> 
> 
> base-commit: 69897f5e8552af8835a2c8a36aa7d597e1cf6689
> -- 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
