Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341C92CCC5;
	Fri, 13 Feb 2026 00:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770941588; cv=none; b=bqGO3izeVmAd0hwg/IbkksJBN9pSUe71M6pTAMvpBEB1/aGcJMOfdcPGmyFgaPgYglm+4SkEIaK5Y9WTtLJsjl9SE29dWNuwxwTyDKssThU5cQoUiPk2cXfPRtfbbCeSbbP4QVeLNReQ+Ne/TNFHNNOEvK2b4HQgU14FjmUhB8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770941588; c=relaxed/simple;
	bh=1xonqy6rQWMsq8NcxxbcLlRmc7tyrUvtsOJnFFNXEAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MpR/dP5Z3QXAF4ORe/pL9i3D+iB4VIOJkiqzLVUacfAZl6Nbft8hLzEs1DDPhimdG4SPYCD91AfRhJsb604FjzYKMzq1lTiUklkju2bHOgxx6a02DZLN35XyIrur5+A69xU0TKt2mZ2wdCUshdXe9ov6Uo+b6sngANGcVaZe9ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OQeHNdh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OQeHNdh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27859C4CEF7;
	Fri, 13 Feb 2026 00:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770941588;
	bh=1xonqy6rQWMsq8NcxxbcLlRmc7tyrUvtsOJnFFNXEAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OQeHNdh1yatVAxhlZ/GNFUV0lQXw4uiMS8Kw1AJEs0p6LYw2AHIhRwWe4GBy/1hOB
	 5D5otA8FbqDeO5FJt1YwWuZWSLUfFfdD45gEU51zslxsx3tJp4AdmkBcsqW4b4ETGg
	 +bN3aZe4raCfNuu3SHW3n3sO78rlEUtIIT4EaLCKpb02F1fBBk1tISdmDL/DZOu0BJ
	 +DCPkxNf78s0JObruXgai3qCFxLuAZL9Y4uT4FNIIT0qnQQSG+puaz0DJhNm4nrJyN
	 /J7CYDR6l4g24tD5o4IZT9/d6nTN7VPfp1iP7xsEpSCu1k/vOJQ3m3mJYQvj9K/hvp
	 5kbiw/sW69xlw==
Date: Thu, 12 Feb 2026 16:13:05 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	"David S . Miller" <davem@davemloft.net>,
	linux-riscv@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH V2] crypto: aegis128: Add RISC-V vector SIMD
 implementation
Message-ID: <20260213001305.GB2191@quark>
References: <20260126092411.243237-1-zhangchunyan@iscas.ac.cn>
 <aYW8XJk44phI3JSG@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYW8XJk44phI3JSG@gondor.apana.org.au>

On Fri, Feb 06, 2026 at 06:03:08PM +0800, Herbert Xu wrote:
> On Mon, Jan 26, 2026 at 05:24:11PM +0800, Chunyan Zhang wrote:
> > Add a RISC-V vector-accelerated implementation of aegis128 by
> > wiring it into the generic SIMD hooks.
> > 
> > This implementation supports vlen values of 512, 256, and 128.
> > 
> > Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> > ---
> > V2:
> > - Add config dependency of RISCV_ISA_V to fix the issue reported by kernel test robot;
> > - Add return value in preload_round_data() and aegis128_round().
> > 
> > V1: https://lore.kernel.org/all/20260121101923.64657-1-zhangchunyan@iscas.ac.cn/
> > ---
> >  crypto/Kconfig              |   4 +-
> >  crypto/Makefile             |   4 +
> >  crypto/aegis-rvv.h          |  19 +
> >  crypto/aegis128-rvv-inner.c | 762 ++++++++++++++++++++++++++++++++++++
> >  crypto/aegis128-rvv.c       |  63 +++
> >  5 files changed, 850 insertions(+), 2 deletions(-)
> >  create mode 100644 crypto/aegis-rvv.h
> >  create mode 100644 crypto/aegis128-rvv-inner.c
> >  create mode 100644 crypto/aegis128-rvv.c
> 
> In light of the recent move of aes from crypto to lib/crypto,
> perhaps the same should be done for aegis?

Yes, I'll be focusing on AES modes next, but it will make sense to move
AEGIS too.

Regardless of that though, this patch needs a proper review.  I'll try
to find time, but maybe others in the RISC-V community can help too.

- Eric
