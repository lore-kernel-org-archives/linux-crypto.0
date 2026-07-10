Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E05A3C09E5;
	Fri, 10 Jul 2026 21:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783719443; cv=none; b=XMn3nu65o64svvRk+pLtE30otAE2TFnXpP8mVW5lr4Jp5R9949HfA/xGmiX5uTVUehv0V+8vV0vb2ghyAOi74IprXL084wdPnVYHUV91SE/y0l5Xq/zQV+LKqrxZbohVYxpxjGh8gLX00swiMWPqsYILqcuU6L1UbDyebtAq30s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783719443; c=relaxed/simple;
	bh=g/65r6Zl52c5Lu5VFDjKq6YGs4gibIkRjG+Oyw7OUpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ei3eWu0WrcVZKA0B/5GHt/ARBmNZnH5oFJsCBrpEChXuRaJdCeyXJHOafttrKMz6dNZGLhTPwtOvaeINoto5379NYQDUqStgEOOOeLlKJgv2Lb94r/h+WKCfCgfc8nnDZMvvDjhwgqZ0nqZhB09WtD+O5sD+8YcHhHwMDtA8aSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErpNrKah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErpNrKah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A2B1F000E9;
	Fri, 10 Jul 2026 21:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783719440;
	bh=tXJO98NiV+M3ZHWe40hcWvLZj3tsp+2pn41neMfQsfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ErpNrKahZ2ftDZLRZIu4IDyBtV5Oa4EZZouVUX8R0l3oxfIiN/p8BF3dt+aF6fFmt
	 vtptJcEsXS7Mh7Z/ayECbrfw6Sm2WQEFsm4vyoe/Kd1qO7yDGt4I9mhMF05zKMW9jj
	 pB4g1kzpSojSK0LA7wr/syPjK0gsV1e6tgsCDXUjOcWffLBY4+8Uy5XXJ8D9UHaiy1
	 r/9pJC5PzLNh3zQZmO06AS6gz8OU8k9LnTDGg6ZhZhRPsSqo/GnhzrRROcODxFtC5t
	 2BLK8Abx4peWScIaa2YYv3VSpY5IDj538q7NwnAAqoaFkUQp5YpgBZArUIcwGTc80C
	 xuVen6Y/aotAw==
Date: Fri, 10 Jul 2026 17:37:18 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
Cc: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org
Subject: Re: [PATCH] crypto: rsassa-pkcs1: use constant-time comparison for
 digest and signature verification
Message-ID: <20260710213718.GD1911@quark>
References: <alEr_e-G0L2nxxv-@fudgebox>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alEr_e-G0L2nxxv-@fudgebox>

On Fri, Jul 10, 2026 at 07:29:33PM +0200, David C.C.M. Gall wrote:
> Replace memcmp() with crypto_memneq() for cryptographic digest and
> signature comparisons to prevent timing side-channel attacks.
> 
> crypto/rsassa-pkcs1.c: RSA signature digest verification used memcmp
> which can leak valid prefix length via timing analysis, user data
> could reach the leaky comparison via the digest argument to verify.
> 
> Assisted-by: gregkh_clanker_t1000
> Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>

While we should use crypto_memneq() on MACs, auth tags, and other secret
data, I don't think we should let it creep into domains where it is
clearly not needed, like public key signature verification.

- Eric
