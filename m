Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45D21B263;
	Thu, 22 Feb 2024 08:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708589951; cv=none; b=YN3LevsLojFNlFARXIfCV5aNFuT3a+gST6zpc46xJL/IQqzkjpTvEpdluQe92hDWsfT3AQwhvPL/UmmHdDw8NwGCEo0EWN2DRnfn/RoWfb8LcNYykYAS+dtBXVoCc8mN2t6syb8QC1fL8wFUkWGJEN3FLThW5T0+OijhfcPAWtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708589951; c=relaxed/simple;
	bh=vS7S3JhxkbwRX4DFeskeDy6mHgoSepoNa465jqU9o/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V05T4Mrl/syr7ythSiXMHJmsYoGSr5Jc+VKu02SvpKpdjs4jN+tyYMa20usOYMcdp8iD8SWwdprtJkRffO0SIaOa1mlQECREiolPDElhW3MG5yPkSTHc2B9d3qdL88JJ1FOtjfqcBuDUqvqJrtlF+uhJQCVbmQTuVQDOmtA7b20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bvDHYiSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bvDHYiSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5416BC43394;
	Thu, 22 Feb 2024 08:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708589951;
	bh=vS7S3JhxkbwRX4DFeskeDy6mHgoSepoNa465jqU9o/s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bvDHYiSr7olryX4OEgArbxtV/4R7EOQQuVZBgCQZ5FGKaKZfZlnoHN6/tS4kTmFtD
	 R7V/vSUKQnDxfZntEJt4NLAti4bGLnrYbMClQbEnAgV2JmvgIDEOAe2dK65dElFa3H
	 pradVYpu6RUlIBmfKSodaW7erWbP1hAM47HfGOzhCGR8/nmvxgBKK92QlTmqg49U5a
	 nUEDgwQ/O+jX1VPTZx8Pm3JtLduYhdDa6pESDHWZCVGJBC0QJ8ivPGgnhJL9w1OXRm
	 gNtnbbslL3D/IKGglohwj++r8KtUME24sCyly8IEQepdTz5dnm+F7ftczTBwhDwQIe
	 gnGAKDHir0wbg==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-512a65cd2c7so6103393e87.0;
        Thu, 22 Feb 2024 00:19:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUjoGJ/bFB/x2+Ox/0IkQCbt0Uh4hsV/GKRhliiX4oTZ4IS0pHgzYBGlha9JmAWNHaxZopiKQbO4toXm3Hi/G7nmICwKdWgTVKnctD/ltOE7cmjgBagPvay//W3WdyHCrpy0kl3
X-Gm-Message-State: AOJu0YxiyipgSuNjpTzhIAyJOGYUWX0DMhi5LBdIFG82L12u1bHWgOXp
	Niy9PC7xHZlNSMbUkqgwjScfJQPWocszIL7l3TUaqeQeu8fG9ZLAXliRqrVEr9qdxTijdoKhWzM
	XLDuNOZGd0p9rAketEYKAtUmTrDM=
X-Google-Smtp-Source: AGHT+IHV5gOtaICNnyDxbMw5c6d9fdwZQsZW+AoMdXSTbSE+z6mmRgO6x1FRbA2RnlVtZ8grhv+KcXVkf9HjRS25WGE=
X-Received: by 2002:ac2:544c:0:b0:511:9e5a:922d with SMTP id
 d12-20020ac2544c000000b005119e5a922dmr12986471lfn.14.1708589949519; Thu, 22
 Feb 2024 00:19:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240217161151.3987164-2-ardb+git@google.com> <20240222063433.GA37580@sol.localdomain>
In-Reply-To: <20240222063433.GA37580@sol.localdomain>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 22 Feb 2024 09:18:56 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG1aFudSnFWzcJrG8DOeErDTSZ5EWpS60fxaU3c=ZTKAA@mail.gmail.com>
Message-ID: <CAMj1kXG1aFudSnFWzcJrG8DOeErDTSZ5EWpS60fxaU3c=ZTKAA@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/neonbs - fix out-of-bounds access on short input
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, stable@vger.kernel.org, 
	syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 22 Feb 2024 at 07:34, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sat, Feb 17, 2024 at 05:11:52PM +0100, Ard Biesheuvel wrote:
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > The bit-sliced implementation of AES-CTR operates on blocks of 128
> > bytes, and will fall back to the plain NEON version for tail blocks or
> > inputs that are shorter than 128 bytes to begin with.
> >
> > It will call straight into the plain NEON asm helper, which performs all
> > memory accesses in granules of 16 bytes (the size of a NEON register).
> > For this reason, the associated plain NEON glue code will copy inputs
> > shorter than 16 bytes into a temporary buffer, given that this is a rare
> > occurrence and it is not worth the effort to work around this in the asm
> > code.
> >
> > The fallback from the bit-sliced NEON version fails to take this into
> > account, potentially resulting in out-of-bounds accesses. So clone the
> > same workaround, and use a temp buffer for short in/outputs.
> >
> > Cc: <stable@vger.kernel.org>
> > Reported-by: syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
> > Tested-by: syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> Looks like this could use:
>
> Fixes: fc074e130051 ("crypto: arm64/aes-neonbs-ctr - fallback to plain NEON for final chunk")
>

Indeed.

> > +                     if (unlikely(nbytes < AES_BLOCK_SIZE))
> > +                             src = dst = memcpy(buf + sizeof(buf) - nbytes,
> > +                                                src, nbytes);
> > +
> >                       neon_aes_ctr_encrypt(dst, src, ctx->enc, ctx->key.rounds,
> >                                            nbytes, walk.iv);
> > +
> > +                     if (unlikely(nbytes < AES_BLOCK_SIZE))
> > +                             memcpy(d, buf + sizeof(buf) - nbytes, nbytes);
>
> The second one could use 'dst' instead of 'buf + sizeof(buf) - nbytes', right?
>

Correct.

> Otherwise this looks good.
>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
>

I'll respin with these changes. Thanks.
