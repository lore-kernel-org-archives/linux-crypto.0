Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C887824B1
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jul 2024 06:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720678245; cv=none; b=PgLcC/PzBl1Ftu7uMeBH0FedB/v8fnV6Z1tnNOjrdR4rutZ68wfeU7oAEJIeab2Wpx15gQyTESDW3iTZAPEpSSDxbGM+JwJwYovU7p3oqW6yhNmHC/Mm4XM9dy3ttIRuF4rW8qWZCAgnnAzsxP2OsQX1K1TGuQRAgIlgDHIgmHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720678245; c=relaxed/simple;
	bh=lcFAHfMhzImkUJyJbyq2URb1/vfTm36nfxaZxI+rK4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E7eVQ3XctmdSeNTJeok+VvpdvPL5UdN/ZtPVoTLuJWBeltaYHGoGBwcBe4TiM2qzFJGVWzGfvRu4aPkSnCaJ8SKNmOKrrI2cBhLKbcfKy7egn/BNrKNLNhhK/x6kwMsONRrUUNpSzMCO8bPWMEIHh9ODWOFFwbZqA/EEG1JXFM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ud4PPCSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ud4PPCSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C603C32782
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jul 2024 06:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720678245;
	bh=lcFAHfMhzImkUJyJbyq2URb1/vfTm36nfxaZxI+rK4M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Ud4PPCSbRhk1MEoErVjRMLr7XPObor4He8oXVNIXeLDMCTO8GFyYFa9nmLkPypm//
	 r4Lb4i43UJxzob1XE6BQDAyXI7EbFke/JSRjMn0KXm/I6lQv6d2jj5e38U7WZsaVJv
	 6QHOWi7w5PjdxueZWgYLzqc5NEgw1igXink99VUmOYDVPZKOR3TVA5aX4d029x6E30
	 AXwvgrOAzCl4Lbk0Bq4TQun3EAgqOuesqsXRFZB5PBmLzRo4j28YO5hkJAVF/uRZCc
	 qsJS8i+p8+JxigWL65aRnkbNUrAXEMBzEk6jDLL1JbNjANIo2IHsKdN96WmVeORiRd
	 fu/YQbvqjgOUw==
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2ee92f7137bso5168651fa.1
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jul 2024 23:10:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWkvLNp1eT05/84vi4ut7Ci7You/fcdS4jc1G9qpOO4XFsVL7SAGiJ4lOrhfgBrlHcj9C0d/HXg37bqob1lAKNvIvZvIKQE5VEjywBG
X-Gm-Message-State: AOJu0Yxis5Gycv9PTPleqeIcQM0qfp66h3yF3Asdf0SN56V8P5kjTS6s
	pX1OXIbb/WR0nvFsHJI39OyVA/BB8T7iNBUULXjempouBJAZ3Ge0/RPwQWhdxYOm5mXAFEw7KsF
	2FYP+kX05+PvxR9Q5KV0RPfOoKj4=
X-Google-Smtp-Source: AGHT+IGEmHzUODhJODXm9h1hdOQCtHw3ie4m+DSYFIxj0QjKcEgNjBY9E0S/lNiIqJuXMpdBbexxDBZCzxgSieNAVPA=
X-Received: by 2002:a2e:95cf:0:b0:2ee:7af6:54ec with SMTP id
 38308e7fff4ca-2eeb30b9a59mr52392031fa.1.1720678243542; Wed, 10 Jul 2024
 23:10:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611034822.36603-1-ebiggers@kernel.org> <7097bafd-e146-99a5-7f86-369e8e2b080@redhat.com>
 <20240710181417.GA58377@google.com>
In-Reply-To: <20240710181417.GA58377@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 11 Jul 2024 08:10:32 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFsa83=1atXR4DksAgViw9j5dhc3fAautPpMoNYPzuRZw@mail.gmail.com>
Message-ID: <CAMj1kXFsa83=1atXR4DksAgViw9j5dhc3fAautPpMoNYPzuRZw@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] Optimize dm-verity and fsverity using
 multibuffer hashing
To: Eric Biggers <ebiggers@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org, 
	fsverity@lists.linux.dev, dm-devel@lists.linux.dev, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>, 
	Bart Van Assche <bvanassche@acm.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Mike Snitzer <snitzer@kernel.org>, Jonathan Brassow <jbrassow@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Jul 2024 at 20:14, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Jul 10, 2024 at 12:54:24PM +0200, Mikulas Patocka wrote:
> > Hi
> >
> > I'd like to ask what's the status of this patchset.
> >
> > Will Herbert accept it? What's the planned kernel version where it will
> > appear?
> >
> > Mikulas
>
> It's blocked by Herbert wanting to design the multibuffer hashing API in a more
> complex way that doesn't make sense.  See the previous discussions.  I don't
> know when Herbert will change his mind, so for now I've shifted my focus to the
> Android kernels.

Yeah, this is really quite unfortunate, especially since the
alternative approach doesn't appear to be forthcoming.

I'd prefer Eric's approach over what Herbert is proposing, as the
former is available today and only addressess problems that are
actually known to exist, rather than handwavy claims about what future
developments in IPsec or h/w crypto accelerators might make meaningful
use of.
