Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0909211710
	for <linux-crypto@vger.kernel.org>; Thu, 20 Mar 2025 08:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742460956; cv=none; b=rMEctgwabPyiC9avC5qIFhebAtO0l3o6jugShc+o58vSSexRRdmWhhlJU7Kw4H0P/uSugGhdKxmKaWhSbUQS3w5DRYMKusjIHJQf2L/Mpjz6wTJsFTwSr0PQR2hBSH3TRTyfpkmJtcj1clAF+CdqWZ1+MiHIBrzitA/heMBI6iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742460956; c=relaxed/simple;
	bh=aPOqkd5z7dHA/YpbB4wJT4DNs/hTbzC5BMJUwFGcEoA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GqYVab4J2rQncP2rdsWGWf2b5NBarCi64UXBRX3fyz6aaOa0iZ5GaJlAZxupaR9RUtXUby2r5ZtxXAZJSaUSdd6KmyuoTuy7LDTMsLVnD8OL8lPUmv9cCrmsGQFbpZnh5kWQcqc6LRcD3fsY11oQ8maHskj9yX1kslz/q7mGyY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdwmXqFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdwmXqFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E8AC4CEEC
	for <linux-crypto@vger.kernel.org>; Thu, 20 Mar 2025 08:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742460955;
	bh=aPOqkd5z7dHA/YpbB4wJT4DNs/hTbzC5BMJUwFGcEoA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XdwmXqFLkZ64lnj4IK+B6VVNEnRVSsV63nrZQidN0l2mp1qTaZ45UA6VB9XnB3aHc
	 BiH88EMqfnkGPIRhri1e3+/K1E1BpnHkoyJJ3olzBOk/3uSq6ok4EDBPi+PCCnujgv
	 V6YEAM+dT8KG5zR+0FfC/8aKJGibHLT3VVz9bZZFPeSEsWm+I1bG+boW6J73XFrED3
	 TVJF27kRuA0Q4Xeao3UaFLDQTUOlYURH4s16Buhf3s5d4MKHyv56zH9iqCVI7Qs/nv
	 v7tpYr9n7FWJTwIRBadRWgXLiGUEyTIsBdG0Li45PMAbWnAoYPdoErn/Wnr98hwa6a
	 baMzndh4HtAFA==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-54ad1e75f49so337820e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 20 Mar 2025 01:55:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVuhTneHbpRu4CVY8jmYKvL5c2DZald2fupHc7tdQ8tv1JsHEMbqnW50hbsDu2+lqOCudOh7JmheUbbPeY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxpx+AQJpQah9CIfC2uETmMWFXS0dRN9JLOnQkeL2U0bwNDbAb9
	gRif/ZMRXLB4hhoQgTFBP2NRwCwdFw5twUocvChDcqrFFxnfraPma2jiYdaJdoE9HXIkYvZxUnO
	CtlQFt/EhBlSbLgFgGy1EP0tKSPk=
X-Google-Smtp-Source: AGHT+IG7klNhhuyGCLLjrkmZBdftTlLeG5BjHjPtvWcIFLCQG9KUaAXrJiUbbSzodhNMAZsDF1GH6G6VHI2pBw9EcY0=
X-Received: by 2002:a05:6512:3e1e:b0:548:91f6:4328 with SMTP id
 2adb3069b0e04-54acb1be834mr2384163e87.15.1742460953776; Thu, 20 Mar 2025
 01:55:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1742364215.git.herbert@gondor.apana.org.au>
 <CAMj1kXGAokDnf_spFU85qCh+quU4eewgWwCO6-UpCWDdf5Q0Og@mail.gmail.com> <Z9vOUut7CWJK0kVJ@gondor.apana.org.au>
In-Reply-To: <Z9vOUut7CWJK0kVJ@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 20 Mar 2025 09:55:42 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHXZoaf3H4brxm2O+mvw0iebEUkO2euNj4CeDVn4dz40w@mail.gmail.com>
X-Gm-Features: AQ5f1JrTlvYoKh16WMg3zBNjdODun7NCtL7Z_EPTa99P7zYiEMs4aBwJ0Dmyds8
Message-ID: <CAMj1kXHXZoaf3H4brxm2O+mvw0iebEUkO2euNj4CeDVn4dz40w@mail.gmail.com>
Subject: Re: [PATCH 0/3] crypto: Add SG support to deflate
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, 
	=?UTF-8?B?WU9TSElGVUpJIEhpZGVha2kv5ZCJ6Jek6Iux5piO?= <hideaki.yoshifuji@miraclelinux.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 20 Mar 2025 at 09:14, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Mar 20, 2025 at 08:51:40AM +0100, Ard Biesheuvel wrote:
> >
> > IIRC Eric had some feedback at the time regarding the exact behavior
> > of the zlib API, and I notice that the code no longer deals with
> > Z_SYNC_FLUSH at all, which I did handle in my version of patch #3.
>
> I didn't see any feedback regarding this when looking at your patch:
>
> https://lore.kernel.org/linux-crypto/20230718125847.3869700-21-ardb@kernel.org/
>
> Do you have a link to that discussion?
>

No. I did some digging but I could find anything. Eric might remember.

> I was going to add the original USAGI workaround but then I
> thought perhaps it is no longer necessary as our zlib has
> been updated since the workaround was added back in 2003.
>
> My understanding is that the workaround is not about Z_SYNC_FLUSH
> but feeding an extra byte to the decompressor.  The only difference
> between Z_SYNC_FLUSH and Z_FLUSH on inflate is that one would return
> Z_OK while the other returns Z_BUF_ERROR,  both are treated as an
> error by crypto/deflate.c.
>

I'm fine with this, I just wanted to raise it because it jogged my
memory but I can't quite remember the details. So if things are
working as expected, it's all fine with me.

> > Do your tests have coverage for all the conditional cases there?
>
> If you mean the scatterlists then yes I have coverage for that.
>
> If you mean the USAGI workaround then no because I don't know what
> triggered the original problem.
>
> I do note however that zcomp which also contains deflate does not
> have this workaround either.  If it was really necessary then zram
> would have run into it and screamed loudly about not being able to
> decompress a page.  Or perhaps nobody ever uses zram with deflate.
>

Yeah I meant in general, not the workaround for the mythical USAGI issue :-)
