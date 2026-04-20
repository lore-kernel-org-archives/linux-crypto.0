Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AC43876BF;
	Mon, 20 Apr 2026 20:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776718570; cv=none; b=t76mP8WrsAgeMJQ46fCCBB1OfkpOAev5J15mcydxWqQxIWgsayH37Czl0Z1Z6uY6Ay4dlSQWDd9GZr1Qvo+qaJWD3AiOD2kf8Pv/MJz7AtGBX1o/aTL0l3mY/iglotBVcb753SfH1gkihrCGt9/uU1OlhbjgP0QjtciotaEPQzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776718570; c=relaxed/simple;
	bh=H6eEaRiH37AZtLerAN/34O6Dp6vmt9ZTzMQopSVfLEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IzI2LGRIRVT7MtCn+kR+cim+F2CgPAg6709TeXPxEHZlEd5ppVJDteG6rjze0PlxPF9eCbPih7BsSEV+ysm7LY0gK0cEX4YPwhA0yPod2rWM+on/ZBRCSspTuPiJ/ni2Webe+G+jo6pgIyrh+JgxOT/Xsgd+h44vPSQ44H2L4ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ENy8lOBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ENy8lOBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9004BC19425;
	Mon, 20 Apr 2026 20:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776718569;
	bh=H6eEaRiH37AZtLerAN/34O6Dp6vmt9ZTzMQopSVfLEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ENy8lOBWqxIWxBHhRKXOim5Nvikvo8QpEvgGeXv3j5672JfxwJTjvrlcLZDc92Ei4
	 WNDi97Fzy66uNT8oy0TR7kUTn0w71ZlXiY7xo+Y5pB3gYK8BCMFCGxiax71dHZ0C1F
	 GXZ3Peq8Vrzqdb3IrUongmR+MsgPbir52tp0iiR1HBNN2mHyl7rBzzAVgNSsHgaRsl
	 7BPzcs4z6Cz4BysrQpdZ7YYLtlT3vjcwctxqkIb93PcJNsCWMwzsM7ZSXYDJc7FeVT
	 d3zhYGTb1zLJjChTr3oh/fmtKn+RWCmc2JdCxOtZR4GT1QgrwkPIFfumA4gklobJIi
	 QE2JhAG1njN8Q==
Date: Mon, 20 Apr 2026 20:56:07 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH 12/38] crypto: drbg - Remove support for CTR_DRBG
Message-ID: <20260420205607.GA153390@google.com>
References: <20260420063422.324906-1-ebiggers@kernel.org>
 <2300345.NgBsaNRSFp@tauon>
 <20260420174713.GC2221@sol>
 <10862605.nUPlyArG6x@tauon>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10862605.nUPlyArG6x@tauon>

On Mon, Apr 20, 2026 at 09:54:48PM +0200, Stephan Mueller wrote:
> > Note that the only way to select it
> 
> The selection would always be done during compile time for those vendors.

Again, even if someone were to want to do that for some reason, the
status quo is that it's not supported.  That is, currently you can set
CONFIG_CRYPTO_DRBG_CTR=y, but "stdrng" is still HMAC_DRBG regardless.

- Eric
