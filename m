Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309EB25A642;
	Sat,  9 May 2026 18:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778352113; cv=none; b=XwkXRDXLamyE5GDvnqd26dMdJyXnpTeg4EnRVpYJimhC9RSFDEN+Kv8lcucr3V3175PyhzknfuW/zkud7ncsM7eQYm9yryCAGtum9nmu4Bvt6pKIJNqPznuy9jxQ8VO4ENDRm9r7aaU4yyGCSHiTn/6Za9XuCFotVXXN3W9yVwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778352113; c=relaxed/simple;
	bh=5x6vMZJIgP2JV5U0sf4/3UHVPYatudGhzTthPLFbE1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dsjT+N+pTcUsXzF/1YmrJw4rYLJs1ue3KX95VLlK9OpwU6zlcsTGl9+hArlzQKxPxUwMwrxnoTDhaosoIEjkC9/K42Zd1SWSvtcTfeUek/WlEoJV3b7QUYKnP0Yt5haTkDBbNvXf409tkvuXf5g+g4xtadWf90X5p8yZknxbPKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AyJ5rWZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AyJ5rWZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626DCC2BCB2;
	Sat,  9 May 2026 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778352112;
	bh=5x6vMZJIgP2JV5U0sf4/3UHVPYatudGhzTthPLFbE1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AyJ5rWZIJlvuab7tohPZ8gd7mvCmDxDNq/R998ABZKL2siI3NOIG5fVudgG+OtgJY
	 hNTUVyvIvpVN/IQQdxRB0+xP/TMJRVoi4EUtUA9zmVEOnLlC+vDDBS5mNaY7+I/dwr
	 hznqQ4FgC5RYcm8MWrDvOtf/Pkv/CkE/xcb+X86Cdtdz9lUKt4BxTT5TVtiwSMORdC
	 ICxc/QlGkB2kaXTTOyXicZiiO/mwafgH6knNICANk6kNsvg+SIaNU+HmB0pF1Ii/hd
	 e1njZm9xgEXduDH3ASCwWoCuo+GNQ7ZjjCl57klRJMYkkNb3TMaHVz2azJGCgvPWl9
	 6IvHRup/FfYXQ==
Date: Sat, 9 May 2026 11:41:44 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev@lists.ozlabs.org,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>
Subject: Re: [PATCH v2] lib/crypto: powerpc/md5: Drop powerpc optimized MD5
 code
Message-ID: <20260509184144.GB11883@quark>
References: <20260506030005.9698-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506030005.9698-1-ebiggers@kernel.org>

On Tue, May 05, 2026 at 08:00:05PM -0700, Eric Biggers wrote:
> MD5 is obsolete, is vulnerable to collision attacks, and is being
> replaced by SHA-256 in new systems.  It doesn't make sense to continue
> to maintain architecture-optimized implementations of MD5.  Effort
> should be spent on modern algorithms.
> 
> Indeed, architecture-optimized MD5 code remains only for powerpc.  It
> was already removed from mips and sparc, and it never existed for any
> other architecture (e.g. x86, arm, or arm64) in the first place.
> Earlier the decision was made to keep the powerpc MD5 code for a while
> anyway because of someone using it via AF_ALG via libkcapi-hasher
> (https://lore.kernel.org/r/f0d771d5-ed70-444c-957a-ad4c16f6c115@csgroup.eu/)
> 
> However, with AF_ALG itself now being on its way out due to its
> continuous stream of security vulnerabilities
> (https://lore.kernel.org/r/20260430011544.31823-1-ebiggers@kernel.org/),
> it's also time to be a bit more forceful with nudging people towards
> userspace crypto code.  It's always been the better solution anyway, and
> it's much more efficient if properly optimized code is used.
> 
> Note that the md5-asm.S file contains no privileged instructions and
> could be run in userspace just fine.
> 
> Thus, we now have two factors going against keeping the powerpc MD5
> code.  Different people might weigh these two factors differently, but I
> think the two of them together make the removal the clear choice.
> 
> Let's remove it.
> 
> Acked-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is intended to be taken via libcrypto-next

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
