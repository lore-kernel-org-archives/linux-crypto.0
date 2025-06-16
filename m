Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBEF265296;
	Mon, 16 Jun 2025 03:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750044437; cv=none; b=WZnk6m5k5+nyUM4thxD9NDPmFfLSdAOZdc5GmYH493jAPA45eyTgntG0a/tinTG5no0Rklc49X58PN6x+ugxAazHuz9whS44Wu9IU23h0y9Ad3rIOgBQnKvczy/P6TpRNw19V/hyhddMHyq55r6T6gyNdEmqigFFKpR3oqeQlf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750044437; c=relaxed/simple;
	bh=ov17jFVZhhAla01tzQDPNoJqAL0NkucBcljLFqiWedw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=RjUa/AnzWqQNpZY7bEjNlso+Zd6HjT/R8eaE/4V1fd6QSUUVVUI+c3aXTJMMtd4P0EY/0u7HG849t0lJhYS/AjZCHnplPJiPhk8y9UuY/7QUw3XGvszZEUdvI3gbTYGSCYGyuvYvRrlIuu8LM3yvZkHO6t6XEQnpI2VNnmxzkfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OdgbtJr9; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OdgbtJr9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JhRGK4jXnVQ6+DekEGOh8HvxWAfgHU9rMzaDKfUDnRk=; b=OdgbtJr9jj783tzS1GGx7gt/BG
	3NWVVg3wKvybuNw4Xv0qkLx/l8Wfe+R8+FYvEkH/5kA+oaNXbkxzL4Rcl9MpumeCBgOp/qt3eilXf
	cI+oxD5ALq9JHLMk1SLHbgapBxlrleT0KGZFnq9hvsVNc1hkjPTwoFEMRcCLU4bJjFghQLbyMnlol
	/lFxRxlA1Y9dg5BNsbPR5zEdKI84X4oax/ANWBdBTD137lFxJCtO+bf98lMAOi8y0qZ7rKw4A5ygz
	T7fK8KIBwuKpdKm/xwCcqpRCtLBcrSI2Z3O3euJ5g2bdF8FvTsPAfN39LA8g0JP4y6E2vjqaXHBrj
	Rkqlsamw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uR0Ft-000Iud-1C;
	Mon, 16 Jun 2025 11:27:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Jun 2025 11:27:09 +0800
Date: Mon, 16 Jun 2025 11:27:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, Jason@zx2c4.com,
	ardb@kernel.org, kent.overstreet@linux.dev
Subject: Re: [PATCH] lib/crypto/poly1305: Fix arm64's poly1305_blocks_arch()
Message-ID: <aE-PDfmowagPegen@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616010654.367302-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> For some reason arm64's Poly1305 code got changed to ignore the padbit
> argument.  As a result, the output is incorrect when the message length
> is not a multiple of 16 (which is not reached with the standard
> ChaCha20Poly1305, but bcachefs could reach this).  Fix this.

Sorry, it was a cut-n-paste error since I copy the code from
the update function where the padbit is always 1.

> diff --git a/arch/arm64/lib/crypto/poly1305-glue.c b/arch/arm64/lib/crypto/poly1305-glue.c
> index 6a661cf048213..c9a74766785bd 100644
> --- a/arch/arm64/lib/crypto/poly1305-glue.c
> +++ b/arch/arm64/lib/crypto/poly1305-glue.c
> @@ -36,18 +36,18 @@ void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
>        if (static_branch_likely(&have_neon)) {
>                do {
>                        unsigned int todo = min_t(unsigned int, len, SZ_4K);
> 
>                        kernel_neon_begin();
> -                       poly1305_blocks_neon(state, src, todo, 1);
> +                       poly1305_blocks_neon(state, src, todo, padbit);

This would do the wrong thing if someone ever tried to pad a
message more than 4K and called the block function with padbit == 0.
Fortunately it can't happen today as there is no digest interface
to poly1305.

Looking around it seems that this pattern is replicated across
all of our poly1305 implementations so it isn't a big deal.

I presume you will be picking this up via the lib/crypto tree?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
