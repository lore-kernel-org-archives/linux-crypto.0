Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D65F21CFFA;
	Sun, 23 Nov 2025 20:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763930265; cv=none; b=Kc0W9u6oFNbTlIsSTz4GriEAIitLd3kofPaYIuLL/++2XIRZ0eIeWhRq9hZsUJuNDE4S8lLyPaHJmQBrcHniYYz+G+BkjCC6i/NnPa9xg3XPWUUc3kB8VGL0RpJE7vGRBLrWqJA0pYSpQRjSqvQLQjL2VKL3W1Kd9gjqoPru1xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763930265; c=relaxed/simple;
	bh=ZVL7+ulqZ2NQz4aHHJ+fjTldZPRZrcObHzTyt/0ta/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u+EFly3TVL9Fz3iRNXd7nVXbm/7YA7kCVP0Q5ULN1gjHgl/cNHzJDfJqYn7pmRLRFzQUrJm37cRBK9VNV6U4CGPc1leePegxAmHRI9UygYepVlERG2Pg5wfXIFbcS90JMiJmzTgooHhPLVDX/GIrNivmGnBtKyyxQ7Yc5Oidupo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6Si6j+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6Si6j+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3ACEC113D0;
	Sun, 23 Nov 2025 20:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763930264;
	bh=ZVL7+ulqZ2NQz4aHHJ+fjTldZPRZrcObHzTyt/0ta/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m6Si6j+gOMlRn3PCx4wiBTfTYRVxFqx4Hr92jYfcnZ4RSMC2zdeIWysZxonz529oE
	 879TeSEPhR/I51Rc5E3iebNpLda/pAVgCIZVCXbkcAMiKsb+mhURWeqOjmfQ0lrF0+
	 EOoV2KI4vY/+oCrSXNBRk3Jo6YFKbX4eF15X1Bo2NBHKJ8zOZReMoai7B3kvmsH46Q
	 cTjSFjNO8YRGrxrPuN1bcmLlGf/QdmcAjrFaCed6yRrzLLEIzCfkgRcNNxXgvqBlwo
	 cHBCKvf3YZ44Gt3P5MGGvKrsRUdzSSY3mkDf2QUMza733CqcrNOKff3UMH08i+WTzt
	 Q1jBZ7YZKtdyQ==
Date: Sun, 23 Nov 2025 12:35:58 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH 0/6] lib/crypto: More at_least decorations
Message-ID: <20251123203558.GD49083@sol>
References: <20251122194206.31822-1-ebiggers@kernel.org>
 <CAMj1kXFSL9=TWzv35mSwVMVaKAQ=3n=w93=1+VSfKyDe+0A+Ow@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFSL9=TWzv35mSwVMVaKAQ=3n=w93=1+VSfKyDe+0A+Ow@mail.gmail.com>

On Sun, Nov 23, 2025 at 09:31:19AM +0100, Ard Biesheuvel wrote:
> On Sat, 22 Nov 2025 at 20:42, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > This series depends on the 'at_least' macro added by
> > https://lore.kernel.org/r/20251122025510.1625066-4-Jason@zx2c4.com
> > It can also be retrieved from
> >
> >     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git more-at-least-decorations-v1
> >
> > Add the at_least (i.e. 'static') decoration to the fixed-size array
> > parameters of more of the crypto library functions.  This causes clang
> > to generate a warning if a too-small array of known size is passed.
> >
> 
> FTR GCC does so too.

See https://lore.kernel.org/linux-crypto/20251115021430.GA2148@sol/
Unfortunately gcc puts these warnings under -Wstringop-overflow which
the kernel disables, so we don't see them.  clang works, though.

- Eric
