Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4928B34404F
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 14:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919565; cv=none; b=oB+9mkAWECxDW3BVC6BxoIdv7vrqpiZkEfxzOCysJz0q80GZOHto7WdB5OyMngKG9M2JTv8uGk/ektwKAD476Or0sZpEbe+T6SdI1UHUWPkMLKdlhk2oQfgrQr6H9aj3rGefmY0B/U2sC2cnSGyJC0XgFeE/R3MUycQGmeLixbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919565; c=relaxed/simple;
	bh=aWeZLFH5RpgoAv9utSwqm6Yp/w0k/N6YxdsEFm/omZM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZjvPsGecCB0M2zpSsIHRfvhA0VXsEL9lPDllnDuN6/dzp1bVff69NZGabADuJVILeoJSbZAgCGJBTG1xE4+czt+un6s6WvLWI9R9JWlVEwFbDa86oEJUGhcw5JMCQLJ8RllVEJ/JoR0twFCZlGAapJhtN5/KgnAsNLg/iqC2f7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=abxjRt0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="abxjRt0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07617C116D0
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 14:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761919565;
	bh=aWeZLFH5RpgoAv9utSwqm6Yp/w0k/N6YxdsEFm/omZM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=abxjRt0ySxBJ4xYXAFBU9dhgABvTdBFl7LU+6Gf3bGyYJFlzw3fNnN7OEPbPB36HQ
	 f1ecGzv32VApuXP5oieVnrqzeJ5zOXeO9tXAa27FU18gQMGdCood3vIG5R+iHL8SA4
	 ZqeDk/kGPDsPGYQqD0pLJ+XmioxRHI7ZpSBfdvik72JTIaA8gL3pZv7OXDT8UFccUq
	 egVOsLvOOD5QgesUXdlelSyn8GXcs+HXvAy61/KVhXSEimaorpVvcaY5TargEqTCg+
	 5P6GLFFaW9g8uUp+rsgo6/uDsN1vGN1GFdwjqRmc1cHwIId4X7Z9Y715pHMOPNAD0S
	 6N4sqMXDgFBJw==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59310014b8eso2471373e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 07:06:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXITdmVzErSL7HvOsvZUQNRAfCNQDUHN23HxHDlvi97LrvEFP13dpCRwGFUExGz5QXGy+GspjdjWHPQF0k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrdPgADp7KJwNaNiE19sSbGg+OFCBygB/EH1y4HGZcpJNs+96N
	uwlSQvui8visQ9rQVBX2Ln7nsX4qE/x1PsKsSpEiCVa+2EXE0v5IPr+tgpxjNqPxBZWSQkOulJ3
	cTzuc09eqsEoWRYtnbw8IzitMhHGZ9Vk=
X-Google-Smtp-Source: AGHT+IEp5m47JaUV3jVoZQ5XMFczaX0U7o/VOQHO5RGjNAQsdXQw+KNXcUYCJlrWBHGG6aoWOl43H+2qo/UwG+8ZTYI=
X-Received: by 2002:ac2:4c53:0:b0:591:c346:1106 with SMTP id
 2adb3069b0e04-5941d4eedadmr1292338e87.9.1761919563392; Fri, 31 Oct 2025
 07:06:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com> <20251031103858.529530-27-ardb+git@google.com>
 <20251031135552.00004281@huawei.com>
In-Reply-To: <20251031135552.00004281@huawei.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 31 Oct 2025 15:05:51 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEJbnKuhEjBGxtH6ri9fkJ_AygfLFMXVRbnnVKqWzSrBA@mail.gmail.com>
X-Gm-Features: AWmQ_bkKphB_oRPPSkEzIfFAX2WH5E8Txm3hjePOvgQQIuD6R_hNOY7rI6PkH1Q
Message-ID: <CAMj1kXEJbnKuhEjBGxtH6ri9fkJ_AygfLFMXVRbnnVKqWzSrBA@mail.gmail.com>
Subject: Re: [PATCH v4 04/21] arm64/simd: Add scoped guard API for kernel mode SIMD
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 31 Oct 2025 at 14:55, Jonathan Cameron
<jonathan.cameron@huawei.com> wrote:
>
> On Fri, 31 Oct 2025 11:39:03 +0100
> Ard Biesheuvel <ardb+git@google.com> wrote:
>
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > Encapsulate kernel_neon_begin() and kernel_neon_end() using a 'ksimd'
> > cleanup guard. This hides the prototype of those functions, allowing
> > them to be changed for arm64 but not ARM, without breaking code that is
> > shared between those architectures (RAID6, AEGIS-128)
> >
> > It probably makes sense to expose this API more widely across
> > architectures, as it affords more flexibility to the arch code to
> > plumb it in, while imposing more rigid rules regarding the start/end
> > bookends appearing in matched pairs.
> >
> > Reviewed-by: Kees Cook <kees@kernel.org>
> > Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Very nice.
>
> FWIW I looked at all the usecases and other than a couple of trivial
> comments on individual patches they look good to me.
>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> For patches 4-19
>

Thanks!
