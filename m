Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B942AC17;
	Wed, 25 Jun 2025 03:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750820680; cv=none; b=vGrR/HgXCiIFd2F9rg5MOCee84nOhBT0ThmklP8dVwmRTi4WZYYMr7kR4Any3GlvjVsvEMji3FA2UrUg4BTdBZAJuaZCB7zgD0qio97My+GrBAoIim8VaEZ7iCFgJiBUQwUXOvpUO4IBpkqeH+jyXoxrWeBhgsIfPaXuJUI6lEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750820680; c=relaxed/simple;
	bh=/UygT9wn3aJnZqLyjymuRu9rP0E91Bor+TDWg/1ZU3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D02txxqpMH0h7h84IlbrO2WWbmsolGF3TwLIX6DaBq4ecJuJY5JuBnW4ZY0JdjEQ4xMPCN537M7PpeS7B/MDIwvE6gWgzhP94KA6I3ZII8Kfil2VFLTx68MMzfA37vAeoEVPy8XvceeE9wt18208z3TMgwMeSgAJKjx7xWEUWnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OtYiRk7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OtYiRk7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444E3C4CEF0;
	Wed, 25 Jun 2025 03:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750820679;
	bh=/UygT9wn3aJnZqLyjymuRu9rP0E91Bor+TDWg/1ZU3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OtYiRk7KjYFVfe0hPGv0yLSMZZ/cj9pepD9RGv02lA1mEeEwLfgpiUfmCZ4u2lc5t
	 ws9pk0P1hkZaEn0Xo9v9claCOZVyWePa7ujkeva7xsC5xKpH59fGMPvbYQlZfIKf60
	 Z1GQJs/5OsMjtUfAohIUUbb6ksH6ksDXBv3WUDlwe2PvTTqDOwR3lsREcuBKfygf6V
	 AkgupYpOvXq8rBAdtBu1dQhYgzLgb0TdoBaoCfUX7D1QooH/ZNWYpwaqwEQO7GWgaJ
	 1qWfGDyRgGDXTYd1n4hyYf0keWmETWxtIgtvyVusNxUjWpBeVZleIw4w7yuuTC0+W9
	 bgso5iI8E50CQ==
Date: Tue, 24 Jun 2025 20:04:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Fixes for 6.16
Message-ID: <20250625030404.GA8962@sol>
References: <aFtidDP6MLX1V2A6@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFtidDP6MLX1V2A6@gondor.apana.org.au>

On Wed, Jun 25, 2025 at 10:44:04AM +0800, Herbert Xu wrote:
> Hi Linus:
> 
> The following changes since commit df29f60369ccec0aa17d7eed7e2ae1fcdc9be6d4:
> 
>   crypto: ahash - Fix infinite recursion in ahash_def_finup (2025-06-18 17:02:02 +0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p6
> 
> for you to fetch changes up to 20d71750cc72e80859d52548cf5c2a7513983b0d:
> 
>   crypto: wp512 - Use API partial block handling (2025-06-23 16:56:56 +0800)
> 
> ----------------------------------------------------------------
> This push fixes a regression where wp512 can no longer be used
> with hmac.
> ----------------------------------------------------------------
> 
> Herbert Xu (1):
>       crypto: wp512 - Use API partial block handling
> 

Wouldn't it make more sense to revert the "Crypto API partial block handling"
stuff?  It's been causing a huge number of problems, and it's been getting
superseded by the librarification changes anyway.

This is already the fourth 6.16 fixes pull request for regressions caused by
your partial block handling changes.  And I have another one queued in
libcrypto-fixes.  I expect there will need to be more...

Indeed, I just found that a lot of drivers in drivers/crypto/ haven't been
updated to be aware of the extra byte that comes back from
crypto_shash_export().  So there are a bunch of buffer overflows there too.
(Not like drivers/crypto/ actually matters, but apparently your changes are for
its benefit?  So it's interesting that it was actually broken by them.)

- Eric
