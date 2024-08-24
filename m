Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4541F179647;
	Sat, 24 Aug 2024 13:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724507404; cv=none; b=AH0Ngg2TYAio3Cm1p4wxm5Zm2Z5/0d+Ey1Mq/zlmifQ1npRLINLAMucePr8Wt03jzqL21S6RrBpU+MW7kS7RNU9JRV1PyE4j8yycVgVw9px0MeV3MFOYVDv4sUclERUEQveudvuuioEYxuKbUTGyvtW77Ev/Hhkchxd2pX2LkVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724507404; c=relaxed/simple;
	bh=WekqPcGzqZWKkrQb0rydEPKOUyCFf5mquCf3jEr8lJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jn8gwHGU42nY69C+x5tdch3zf1ikhoAcUIhLLSEvFvAJKUjrxSRfD/Fc2465/MMJCiomToDZqMi9sE69mQ8iZg19e1GKmnYssKnaHtjLm5Ll2bmMmfuH/J5zxDK6CkiX6Zw5jiJLXSn9ZogER265rkpkwu4catdVuAabHpeKkkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1shr0i-007209-2F;
	Sat, 24 Aug 2024 21:49:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 Aug 2024 21:49:41 +0800
Date: Sat, 24 Aug 2024 21:49:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Fangrui Song <maskray@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-crypto@vger.kernel.org,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Jan Beulich <jbeulich@suse.com>
Subject: Re: [PATCH] crypto: x86/sha256: Add parentheses around macros'
 single arguments
Message-ID: <Zsnk9cxUbjL5H_bI@gondor.apana.org.au>
References: <20240814044802.1743286-1-maskray@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814044802.1743286-1-maskray@google.com>

On Tue, Aug 13, 2024 at 09:48:02PM -0700, Fangrui Song wrote:
> The macros FOUR_ROUNDS_AND_SCHED and DO_4ROUNDS rely on an
> unexpected/undocumented behavior of the GNU assembler, which might
> change in the future
> (https://sourceware.org/bugzilla/show_bug.cgi?id=32073).
> 
>     M (1) (2) // 1 arg !? Future: 2 args
>     M 1 + 2   // 1 arg !? Future: 3 args
> 
>     M 1 2     // 2 args
> 
> Add parentheses around the single arguments to support future GNU
> assembler and LLVM integrated assembler (when the IsOperator hack from
> the following link is dropped).
> 
> Link: https://github.com/llvm/llvm-project/commit/055006475e22014b28a070db1bff41ca15f322f0
> Signed-off-by: Fangrui Song <maskray@google.com>
> ---
>  arch/x86/crypto/sha256-avx2-asm.S | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
