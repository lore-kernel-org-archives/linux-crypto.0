Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24409255F24;
	Wed, 24 Sep 2025 20:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758744830; cv=none; b=GqBrqe/mo9dzvPF5X7SNAP03lftglu/vh9c61wXbqsrjCsiBLS8lwQrVyg8llQPCZbA9IguvYjwXEc6Wz7QCb41uY+V65L3ATwwZIbRhsFlQ8h8vAB0syBXswph8LFAs27ni+ct4tnT1FGUsY5P0YYPPJY6+GU0eD6q7EqUNDlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758744830; c=relaxed/simple;
	bh=KbWLpnKpZpB1MV61iY4ocxBnAXpwveDFdsBvXXtWJLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uj6mbMi9+I/3qZvrwNkf4rVvh050JK8C1m4+3PikD4FkL05iX/v4n6heqXt60VKx+gtLSMjBJQaHTyFFqlftUF7Xn3EFuzEFSF1nPLQ8Og91V8SNXG0r2aNpCwY0Qu7AdyzL542joS8h5InFVZcxj6pEuCoG29weq3tU/yQ2rfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHIMGFRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHIMGFRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E06C4CEE7;
	Wed, 24 Sep 2025 20:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758744829;
	bh=KbWLpnKpZpB1MV61iY4ocxBnAXpwveDFdsBvXXtWJLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BHIMGFRTDpiqMAIdEY6VqUYpzWDI3QssDcC56z3gdn6Z8pNBbAmz0WWPitkE/1o1m
	 rm/t6vZ1RHom6UTsi/GIW0UDbUYwwkxpn+WWj2NhCTtn9lR9RBgwphVxnP8yIjrmbk
	 xDoxIoERCvChIRQilKaGpE6C6OCXXFCf62Sse5R+wvqzzM/oCkNR6tiAzNj2fNK/vG
	 Ih/PE9S0PnvIx6QnZ2nB+TFQqoj+S2TD6jq0AYPlCnyh3zX3pfXkmyNNakI/Ot+JFg
	 d0gPhYRJj2LmAeXmo/q7I/NnWLBZgXWMm/v3NSw8RBtOuVDPX8lxYuzv9Bdewvqma8
	 aHrPWBR7KURJA==
Date: Wed, 24 Sep 2025 13:13:47 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: af_alg - Fix incorrect boolean values in
 af_alg_ctx
Message-ID: <20250924201347.GA4511@quark>
References: <20250924192641.850903-1-ebiggers@kernel.org>
 <CAHk-=wieFY6__aPLEz_2mv-GG6-Utw9NQOLDzi4TF93xFAnCoQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wieFY6__aPLEz_2mv-GG6-Utw9NQOLDzi4TF93xFAnCoQ@mail.gmail.com>

On Wed, Sep 24, 2025 at 12:40:29PM -0700, Linus Torvalds wrote:
> On Wed, 24 Sept 2025 at 12:27, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > -       u32             more:1,
> > -                       merge:1,
> > -                       enc:1,
> > -                       write:1,
> > -                       init:1;
> > +       bool more;
> > +       bool merge;
> > +       bool enc;
> > +       bool write;
> > +       bool init;
> 
> This actually packs horribly, since a 'bool' will take up a byte for
> each, so now those five bits take up 8 bytes of storage (because the
> five bytes will then cause the next field to have to be aligned too).
> 
> You could just keep the bitfield format, but change the 'u32' to
> 'bool' and get the best of both worlds, ie just do something like
> 
> -       u32             more:1,
> +       bool             more:1,
> 
> and now you get the bit packing _and_ the automatic bool behavior.

Sure, I'll send out v2 with your suggestion.

I do think the idea of trying to re-pack the structure as part of a bug
fix is a bit misguided, though.  It's what caused this additional bug in
the first place, and it's not like it actually matters here.  (AF_ALG is
rarely used, and when it is, the sockets tend not to be kept open for
very long.  And the entire concept of AF_ALG is a mistake anyway.)

- Eric
