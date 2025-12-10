Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA2D1DA60D
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 09:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765359116; cv=none; b=UTruyyhT1jibEaJtXP1h/pMRF2ngwz8DPQTom8F8hbtlQwPp/gtcd7OwJctSVMW7Ud6lr0dGQM8EYPQPmfdlw0EhlR8ljuOpU6u9m6UCtzWfNnnv/BRaGBWxCoYjaanFjlpxTuJ+u4CdXgpzkeZQFI7P6G2l30+HziRXuo4a97M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765359116; c=relaxed/simple;
	bh=PVlMWh9gYQN3TI3V9YA8XnqbZc6K7zFyFj/h07fH4qk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mJCALVqofEfCG/TCeVy/mb1sAWz7F/Xg4GKb72R0zeR4cAtjGtp4hSvp73hdOCul5jtkd1O8dCE2tZlFMdjPhPzcCmkMnJImZsHb/WWf29a7O3rvzbMT5EOyzUxiTI0rp7BQ+ajbKRPFdpYJfP8y2YnaI7wqsYWdsc1ELMvL2LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ViyC+VLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ViyC+VLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB37C19422
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 09:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765359116;
	bh=PVlMWh9gYQN3TI3V9YA8XnqbZc6K7zFyFj/h07fH4qk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ViyC+VLG3ybMm5t75PamWhZn6T90Hy3kpGzQPLWOyfZC3lNQFIVfePwS8g1chGU4Z
	 A0DRMD5ofASs8Ty+U3YJ6I5383kNSKUuLzSq6rElrREe8kR18wzYx/DYuaM5/cfeva
	 4ag6izFEVpVKtFgVF2AgzE/VHqlUZn5jg57lmAvSOCz+fRBtTlBVqVGWMJomcYkzlT
	 PR1rvkzMnAADN8tjzv7proHx217bQXNpDeLIin6JwltB2/X2BWkTVgi79W3zgzx347
	 a6YXe5lHEa5aP7sZX68U5Vxcf0KfdgjMQN0q35j98b7bftrruKjPDyXydNq710VRxT
	 6kXBOe8tW+Pbw==
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-340ba29d518so4361464a91.3
        for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:31:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWrbssA3BZp4dUYw2hRURXWy9fn8cPrlaf2+A1bNaV4duQ/P0ly4e+zFxERIp7RTRvmpbC4Ck6TJeQ02B4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4qxR1iHDGuUiKWWTJP+r+uBCgGlQsrAHGlMiLlQM04AkHqioX
	/SDv0CsEZqXCgL3yCZU1PBpMsikGdnbkCo4lBV6807ZncoRJGadrxAKD+NBsxeeAWcsZQ44E5mH
	P90Ck/n471nka+03uUfhT1rWt/rytlmI=
X-Google-Smtp-Source: AGHT+IFbUzutDYOyNafJhVUQCfe03Kk/KJCoOpuuukf7EzJ8t34omxbEQyu4UCtUp95JppOxVQPmT2fqF4QZ7caNNLU=
X-Received: by 2002:a17:90b:5748:b0:341:124f:4746 with SMTP id
 98e67ed59e1d1-34a7288bf9bmr1452104a91.31.1765359115916; Wed, 10 Dec 2025
 01:31:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com> <20251209223417.112294-1-ebiggers@kernel.org>
 <DEUFDH7FJURL.3J0FN5I19VV8F@cknow-tech.com>
In-Reply-To: <DEUFDH7FJURL.3J0FN5I19VV8F@cknow-tech.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 10 Dec 2025 18:31:44 +0900
X-Gmail-Original-Message-ID: <CAMj1kXEQkB9MWB+PAi4XE_MuBt0ScitxTsKMDo1-7Cp-=xXOpw@mail.gmail.com>
X-Gm-Features: AQt7F2q0ooNszjnIOtFVUY88MsdG5GCslssi1O_Ntmt3L6KAaaMJKGXC5X9ZZHA
Message-ID: <CAMj1kXEQkB9MWB+PAi4XE_MuBt0ScitxTsKMDo1-7Cp-=xXOpw@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/ghash - Fix incorrect output from ghash-neon
To: Diederik de Haas <diederik@cknow-tech.com>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-kernel@lists.infradead.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Dec 2025 at 18:22, Diederik de Haas <diederik@cknow-tech.com> wrote:
>
> On Tue Dec 9, 2025 at 11:34 PM CET, Eric Biggers wrote:
> > Commit 9a7c987fb92b ("crypto: arm64/ghash - Use API partial block
> > handling") made ghash_finup() pass the wrong buffer to
> > ghash_do_simd_update().  As a result, ghash-neon now produces incorrect
> > outputs when the message length isn't divisible by 16 bytes.  Fix this.
>
> I was hoping to not have to do a 'git bisect', but this is much better
> :-D I can confirm that this patch fixes the error I was seeing, so
>
> Tested-by: Diederik de Haas <diederik@cknow-tech.com>
>
> > (I didn't notice this earlier because this code is reached only on CPUs
> > that support NEON but not PMULL.  I haven't yet found a way to get
> > qemu-system-aarch64 to emulate that configuration.)
>
> https://www.qemu.org/docs/master/system/arm/raspi.html indicates it can
> emulate various Raspberry Pi models. I've only tested it with RPi 3B+
> (bc of its wifi+bt chip), but I wouldn't be surprised if all RPi models
> would have this problem? Dunno if QEMU emulates that though.
>

All 64-bit RPi models except the RPi5 are affected by this, as those
do not implement the crypto extensions. So I would expect QEMU to do
the same.

It would be nice, though, if we could emulate this on the mach-virt
machine model too. It should be fairly trivial to do, so if there is
demand for this I can look into it.
