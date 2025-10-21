Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F0A221F0C
	for <linux-crypto@vger.kernel.org>; Tue, 21 Oct 2025 09:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761038601; cv=none; b=Me3/WxEG3VcKKi9JEiGQMkG6mZ+WjpMyZwruAtg2jnFd1WFFNRb6N4crjUH3VmedZZ+56el071IloXrwyR3LvjkWof5j27KdLyvNKyFYpMmlzaNxKSmqY5NiTPXvUYnYFyblkQ1hz1TPY3nlTKj0zQ+w5oDEh9y0KLUpD0NVlk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761038601; c=relaxed/simple;
	bh=siT4dHhFRtLHmzf8No1g5rI39nMLHFOVTlqBlC6FJXs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DFpL+H1MP2a8MZhWfB0kWbDDqOl8hMx6e/xr1hXFS94Xp6Dlq5dt8Jt0GoUaVALQPevFce2u1uuEpmBHWMOW5PGXbpSN4UYOw4rgiyfMPotzzImlXDN5z0cRw8uZycP9HLVTmEZGzi3FZRk3r4pomIVSRTH+wQZ664fvz1IrmCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5L/s+Ep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5L/s+Ep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B7DC19422
	for <linux-crypto@vger.kernel.org>; Tue, 21 Oct 2025 09:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761038601;
	bh=siT4dHhFRtLHmzf8No1g5rI39nMLHFOVTlqBlC6FJXs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=M5L/s+Ep11ydt2PRNb3z4WGQu0duCzFC6bkMI6VSuNmnKbW3bf+PG/xkiW33RaEee
	 UeFQZHX5oyBtiTNYr2FLdf642kT96XPDDCwU1RA6ujE0ugU3u1Q0eNy04/ug8U/oeG
	 ANNW6H0qgiyjhP9ScDzI+uejpOaN/WFWEkrj9T/UxAZQfcmequSNhtbT8vifY90146
	 CGx1x6hzjna19WhLC9MApMd5PHlf9yf4YGqdstakWavkOsPuhqK7aP/6757wRLN9Og
	 myqEYLK82dIcqEa7vDwdzKLBK/lrIoVkhVR5uOZbPMufTfCwxilzMZRnmUbt7y7hiW
	 oBitQhsed3y4g==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3717780ea70so58872221fa.1
        for <linux-crypto@vger.kernel.org>; Tue, 21 Oct 2025 02:23:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXfCiABbkpaiUFhi4bL5np0S0D9SSevv9Eip3SxIzmqtgbX+kQ4ON0OK0ECfAkWam/VBSzCU806WC3CGDU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwL5T7V1na+n9bXmSFkfazZHbTmk4mY8sG3g3Agh+/WWj9WXrQ+
	71U0YXtxd/IjKE5cTx7nXNq2qCvGD9I4CcCSYR+gEHS1HE0++b3AfzyAX9dkIjQxZB2TdR5xIy4
	uU1jnuWsvZeQciRqwGPvPeY8ajuiY4A4=
X-Google-Smtp-Source: AGHT+IHehuvAcUwnsIKlc9SJ9pUrJQPiH4zAJPIHBzDcdeKYlo32G+eo1Enryh1Wkpbz7ueaSkFJqyOvAILxG0Azntw=
X-Received: by 2002:a2e:9fc9:0:b0:336:72be:3339 with SMTP id
 38308e7fff4ca-377979feb62mr54976441fa.28.1761038599616; Tue, 21 Oct 2025
 02:23:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com> <20251017170718.GE1566@sol>
In-Reply-To: <20251017170718.GE1566@sol>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 21 Oct 2025 11:23:08 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEBworuqfQiGpekTdDsa1R5y3jCmS_U91vGCHyhY9QLxg@mail.gmail.com>
X-Gm-Features: AS18NWDbKfRq249JXG9Iltw5RC8ZRy2b5DJyiPJTBssBM0JuWkoLHIllDHXeA3U
Message-ID: <CAMj1kXEBworuqfQiGpekTdDsa1R5y3jCmS_U91vGCHyhY9QLxg@mail.gmail.com>
Subject: Re: [PATCH v3 00/21] arm64: Move kernel mode FPSIMD buffer to the stack
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 17 Oct 2025 at 19:08, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Oct 08, 2025 at 05:45:34PM +0200, Ard Biesheuvel wrote:
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > Move the buffer for preserving/restoring the kernel mode FPSIMD state on a
> > context switch out of struct thread_struct, and onto the stack, so that
> > the memory cost is not imposed needlessly on all tasks in the system.
>
> This patchset needs the following fixup to build:
>

Indeed - thanks for the head's up, although the robots already
informed me as well.
