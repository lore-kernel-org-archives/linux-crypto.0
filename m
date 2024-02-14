Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A004E182DF
	for <linux-crypto@vger.kernel.org>; Wed, 14 Feb 2024 22:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707950549; cv=none; b=n9OEsV8oU/9Zfz7bPriG6CyeyaIvczArpvnZn1Qa2g7BtZtw5JvC/3GI0jnVsvFHWJX0SgjHhzWWL9xIxa2fQcs368aVgkPUdZepn2VgU9WT3vm0RUECOcL/jC2gjnx9u2GHat3vantOgMeDon9JqW4PaHrqw6WZyWAdFa2DRpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707950549; c=relaxed/simple;
	bh=gDOKWTuLGxFAgQ12MXLWBbnnr1TL1BYLv6cljApQScI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FvxyxQPbtMc5OM7cP/6EzJ87fQzuHGoX4rila2V+jjd6675k5l+eB5pKSenG1/+13JDNLzzFD1Pk5AAp7xJRuA7wjnzn0raMES9YdL0yoSXuSrWxpseOfN15fvKUBjgRefBSdYx1aJaMF485VRobWhrptnbnPQ1PPF8H8DLngHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LKSJ67WX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LKSJ67WX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01C6C433F1;
	Wed, 14 Feb 2024 22:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707950549;
	bh=gDOKWTuLGxFAgQ12MXLWBbnnr1TL1BYLv6cljApQScI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LKSJ67WX3MyMv6KrdvhUVOXfdXMBhUP4msexPKlL9uQE8T2X/BGA3cgDAxsE77PCy
	 n6GPfDOMF8fjxf+b+EYsUWhLmw+TUWbREbP9mYvLdn2U46HzDJYXGqCQi1ICb/relA
	 O57gXeBJJe/Kf28mvi5NqJcLftEgXkr0DkEkqBnHHn/1497gPjwZQJ4yXYDdGbPrzE
	 gBQl/cfxhO4zf+vSzHhIHKt1EdmqwUKI2heX6OQStD/0G9hH/umaXHO+dMQiKQQ8wu
	 VyykXW6solwe+D9Z82Q8zloM9QNyfss0C763Fd1EOh2+IF0Zfv/5FBknqdXqvqEDmY
	 hOexDnvsFr9TQ==
Date: Wed, 14 Feb 2024 14:42:27 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-riscv@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>,
	linux-crypto@vger.kernel.org, Jerry Shih <jerry.shih@sifive.com>,
	Christoph =?iso-8859-1?Q?M=FCllner?= <christoph.muellner@vrull.eu>,
	Heiko Stuebner <heiko@sntech.de>,
	Phoebe Chen <phoebe.chen@sifive.com>,
	Andy Chiu <andy.chiu@sifive.com>
Subject: Re: [PATCH riscv/for-next] crypto: riscv - add vector crypto
 accelerated AES-CBC-CTS
Message-ID: <20240214224227.GA1638@sol.localdomain>
References: <20240213055442.35954-1-ebiggers@kernel.org>
 <CAMj1kXEjEhZY6zoQQzJioBB6QVGJbCmO2w5T3+T0=iPxHmvYJQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEjEhZY6zoQQzJioBB6QVGJbCmO2w5T3+T0=iPxHmvYJQ@mail.gmail.com>

On Wed, Feb 14, 2024 at 05:34:03PM +0100, Ard Biesheuvel wrote:
> On Tue, 13 Feb 2024 at 06:57, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Add an implementation of cts(cbc(aes)) accelerated using the Zvkned
> > RISC-V vector crypto extension.  This is mainly useful for fscrypt,
> > where cts(cbc(aes)) is the "default" filenames encryption algorithm.  In
> > that use case, typically most messages are short and are block-aligned.
> 
> Does this mean the storage space for filenames is rounded up to AES block size?

Yes, in most cases.  fscrypt allows the filenames padding to be configured to be
4, 8, 16, or 32 bytes.  If it's 16 or 32, which is recommended, then the sizes
of encrypted filenames are multiples of the AES block size, except for filenames
longer than 240 bytes which get rounded up to 255 bytes.

> 
> > The CBC-CTS variant implemented is CS3; this is the variant Linux uses.
> >
> > To perform well on short messages, the new implementation processes the
> > full message in one call to the assembly function if the data is
> > contiguous.  Otherwise it falls back to CBC operations followed by CTS
> > at the end.  For decryption, to further improve performance on short
> > messages, especially block-aligned messages, the CBC-CTS assembly
> > function parallelizes the AES decryption of all full blocks.
> 
> Nice!
> 
> > This
> > improves on the arm64 implementation of cts(cbc(aes)), which always
> > splits the CBC part(s) from the CTS part, doing the AES decryptions for
> > the last two blocks serially and usually loading the round keys twice.
> >
> 
> So is the overhead of this sub-optimal approach mostly in the
> redundant loading of the round keys? Or are there other significant
> benefits?
> 
> If there are, I suppose we might port this improvement to x86 too, but
> otherwise, I guess it'll only make sense for arm64.

I expect that the serialization of the last two AES decryptions makes the
biggest difference, followed by the other sources of overhead (loading round
keys, skcipher_walk, kernel_neon_begin).  It needs to be measured, though.

I'd like to try the same optimization for arm64 and x86.  It's not fun going
back to SIMD after working with the RISC-V Vector Extension, though!

- Eric
