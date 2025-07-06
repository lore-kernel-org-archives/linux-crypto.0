Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B385F19005E
	for <linux-crypto@vger.kernel.org>; Sun,  6 Jul 2025 23:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751844911; cv=none; b=KWrix30n7EnQsiDW4yXwOVwUjiAkYjwnkpCF0u1VjyHBu0FIZmhwYwnOAU1QeaH6TMCKxRTvFD/Ldi75Kbgx4dT/fEjCSQrkkZ9B30J5z1CMpfYKcnZJPvKGIum/6OJGxkH+I9lV/7DTxOWo7oXuJfxDxqD+Pgd2qeDffxJ093E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751844911; c=relaxed/simple;
	bh=OtkaQlGOMnD2CLW5Awwe4hKtM4qCPFSTKoEi1AtCy/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=seBIjmZUx7IgcA6BiORfycjIbQp4WrPBw0AWm+DhMOlWINFY7XXeHPoHSqa0/s4Bkr9ORrAPGOkS/9seHZ5ArlKyA0TpT49+KPIv8I3TDNatqVx2gzP4eD/YmyanO4n49+o8iK1+VQ6raw5ZOW414taqe2KUvp78oot85hKQCnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IDY1j3A1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDY1j3A1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B95C4CEED;
	Sun,  6 Jul 2025 23:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751844911;
	bh=OtkaQlGOMnD2CLW5Awwe4hKtM4qCPFSTKoEi1AtCy/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IDY1j3A1/nVOTtdQyU32ZBr/SwuprbOT0SIaJeRgJ7sW8ZVfCri4PBB1btlgnOlPb
	 FbyVJ2FK/86vOZiAIYqMp6CmrYdaDHYbexNv6nQV57OVOY9lukuneklAdkOO8fdgvY
	 JNsqWWqv9XMXwNdsggW3k28Zs96MnYI/H+doXrDoivE2xcTfiT5K1N1FYA5PsP7/E7
	 e+IG2+BnRAsR4eESDMhukUZZmbcn01VlIaNk1GYZDS6zFD2s1g8Shr5JtM2s1k8BeH
	 0a0QAvagzhhoIDusBKfMo8oPcTRcClHk65top2TYzM5GkPioKRnETecepeccpkoB9n
	 kQb/DSjr2ZCRg==
Date: Sun, 6 Jul 2025 16:35:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	herbert@gondor.apana.org.au, paul.walmsley@sifive.com,
	alex@ghiti.fr, appro@cryptogams.org, zhang.lyra@gmail.com
Subject: Re: [PATCH v4] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
Message-ID: <20250706233508.GA179853@quark>
References: <20250611033150.396172-2-zhihang.shao.iscas@gmail.com>
 <20250624035057.GD7127@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624035057.GD7127@sol>

On Mon, Jun 23, 2025 at 08:50:57PM -0700, Eric Biggers wrote:
> Hi Zhihang,
> 
> On Wed, Jun 11, 2025 at 11:31:51AM +0800, Zhihang Shao wrote:
> > From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
> > 
> > This is a straight import of the OpenSSL/CRYPTOGAMS Poly1305
> > implementation for riscv authored by Andy Polyakov.
> > The file 'poly1305-riscv.pl' is taken straight from this upstream
> > GitHub repository [0] at commit 33fe84bc21219a16825459b37c825bf4580a0a7b,
> > and this commit fixed a bug in riscv 64bit implementation.
> > 
> > [0] https://github.com/dot-asm/cryptogams
> > 
> > Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>
> 
> I wanted to let you know that I haven't forgotten about this.  However, the
> kernel currently lacks a proper test for Poly1305, and Poly1305 has some edge
> cases that are prone to bugs.  So I'd like to find some time to add a proper
> Poly1305 test and properly review this.  Also, I'm in the middle of fixing how
> the kernel's architecture-optimized crypto code is integrated; for example, I've
> just moved arch/*/lib/crypto/ to lib/crypto/.
> 
> There will also need to be benchmark results that show that this code is
> actually worthwhile, on both RV32 and RV64.  I am planning for the
> poly1305_kunit test to have a benchmark built-in, after which it will be
> straightforward to collect these.
> 
> (The "perlasm" file does have some benchmark results in a comment, but they do
> not necessarily apply to the Poly1305 code in the kernel.)
> 
> So this isn't a perfect time to be adding a new Poly1305 implementation, as
> we're not quite ready for it.  But I'd indeed like to take this eventually.

My series
https://lore.kernel.org/linux-crypto/20250706232817.179500-1-ebiggers@kernel.org/
adds a KUnit test suite for Poly1305, including a benchmark, as I had planned.

- Eric
