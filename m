Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD0451A748;
	Thu, 15 Oct 2026 17:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792087023; cv=none; b=OR7kAx+EGMNlsG/5pG6/VuGzRkqbNpXC3MhgRHdp9Ao4NKFS2tp6zFf49SF1RxN8wADImDZy78KsJS/2PegZhJZXxv+iGAnLCG7tnOfgQy9corJOeLkVC92iLhot7O/N5Yt7kTVmbiqKSPQHkcszXakpHSUKqXqUpuMV5l19YGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792087023; c=relaxed/simple;
	bh=7Hfn+brBOXcLoHJ+PAuVi2SEJIJ3f+sLkcCxOedGfkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eqch00bcCNnP/AcDLwsXivgEjFxpEmO9SDd9bz3zRgLp1e+3qOOb6ZSLaTYIbo85g1ButWmfkp+cdN/kMBr0/hyceVVG7SVkZEC1j0Pe/xIbEcval27yAWdQ+4DNHMKZXFbrlHSG6Hb21dP+f/gFhLhsFLn7ClQyBMYbitfoY5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EviEvf77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EviEvf77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90831F000C4;
	Thu, 15 Oct 2026 17:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792087017;
	bh=52uaFk4JHI6/dvs4oN8s+5whsTrmziLj6Ep4NwCku7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EviEvf77GMDCOK9reGneCYRTlCChdQ8TNzLlxHNMY5Y/c9RgNT6b0hcsP4aby38T5
	 D7ILTdmEizFFDmp4Bm7PEFrJeg1o3n66r81hmBYfCRdxbyhZsd2crmYX/T5Atc6g9u
	 /5Rbw4AIBIxJeVCgkHuOnW9BWVffRYsiZLW3ChJeAGbqwjLIfabsNYwvIZlUXqDR/D
	 Q4BFOEmhEfM6VXBVY5VsuVLlywUE2cV1AkMqSKFTlvPTFNJ20AmxTjkmmiQAElBzJ+
	 MBf2P85edUaqb2wlJdWydcAK/e397C9wLnuXTkuQiWb+Sv86uX1pDqTSJZLptyFpA1
	 sDmpoLo8LrnGw==
Date: Thu, 15 Oct 2026 17:56:55 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: herbert@gondor.apana.org.au, ardb@kernel.org, Jason@zx2c4.com,
	skhan@linuxfoundation.org, me@brighamcampbell.com,
	jkoolstra@xs4all.nl, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lib/crypto: md5: remove unused header
Message-ID: <20261015175655.GA2170687@google.com>
References: <20261015060806.5377-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015060806.5377-1-raizudeen.kerneldev@gmail.com>

On Thu, Oct 15, 2026 at 11:38:06AM +0530, Mohamad Raizudeen wrote:
> The code handles memory accesses using direct pointer casts and
> functions like 'cpu_to_le64()' instead of the unaligned helpers.

This should say "using memcpy() instead of the unaligned helpers".  The
actual unaligned accesses in lib/crypto/md5.c are the following:
    
        memcpy(in, data, MD5_BLOCK_SIZE);
        le32_to_cpu_array(in, ARRAY_SIZE(in));

    and:

        cpu_to_le32_array(ctx->state.h, ARRAY_SIZE(ctx->state.h));
        memcpy(out, ctx->state.h, MD5_DIGEST_SIZE);

- Eric
