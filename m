Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A554823536F;
	Thu,  6 Feb 2025 16:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738861061; cv=none; b=dWxsgH7t3ZGitK6Xcxx3UH6vJDKn2rTeqOvEvY1AkczWyZ4UG/4a6ZlxmHXa2ufEg6ehVLTObVDDVaXtVO3ZdYrsR5j8rVztWmofBz5GMx3AvqnJLeGLQHudkWLirPscijBgJ9rowojaGGjKxmcrSJIiv4U0WnXs/w6vsqyBKcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738861061; c=relaxed/simple;
	bh=RsuYz5vTRl4AIl9KHqvKGcfpK12ecn0BP4ne9KmTjqY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q0nRG3LGNpTtsbzzH/cnOUz/q8XqUpCUhYpO/iVrz4M8kzp6mV0p148N1VqID0TZkA/xPpD6fPjInPOsrjWMeZZWPEq7/nuj7OBh2L6ptJLH9aKawotnJtgAIv9548WS8vdvrl67uBv3er5mx6z1C3nDiWZ56ugwtVmeMUaRTkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4XfvPJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4XfvPJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4DFC4CEDD;
	Thu,  6 Feb 2025 16:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738861060;
	bh=RsuYz5vTRl4AIl9KHqvKGcfpK12ecn0BP4ne9KmTjqY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=i4XfvPJ0EmXOGfDKHDd7X+K6kVxjfjdq191KJghcZdmrCyFnzgrQVU65tV8IHjTm6
	 VgSvORoFFEZN276imJ4kj+F45Jdz169xyAbLjiul2bqcCplDF7NdEzqaXGX/87yqu8
	 k6Re0YykG4hFwDaFjvQOBzTUVi4ixeIP4Fx3Pk7PD69TXIg9QhxGBQRVM1Ay7KfoYI
	 TlnhFh7kuDvFvplForHo47HztIQhE2lluxwAEV1sdg8skdSESIDvxLnvFPQq+SOFxC
	 hU86HUqxuUXRjPvsIGV2beyoEj7vqGPYdax5kTtlYUoYOQRnQIK3JRuKV8NPB5TXAc
	 cABlEWqwaomzg==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-303548a9361so9637781fa.0;
        Thu, 06 Feb 2025 08:57:40 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV8+v6EGLy4UB94ze0H3SoZw9wYfp7fWgfuMkDR+hYNMUus8mm0nWEysAWd/vfvjTnG96dgl/gN+qXFG1M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2FKELH9C+6T5JdWC87rcmmv5XWg1FCMPg2tZnNv6tkKscTbeK
	gaV8zrDvrXfx/XbFW0IUMsyOecnSnLCNyLz2NH5BCm6rZE5b5oO27Z+AY/Pb5mEmU2Vx6oi/Rue
	eirGL1+IpfoWUHs55ZldvtebFAZg=
X-Google-Smtp-Source: AGHT+IEo7OhVrpSv6ls3k4FNFsikTPTd9xK65RQgyNey6knAGv/QOhuLY6j6Wln7x7F6a7IFJmDxJQUEYHqxOP9ebd8=
X-Received: by 2002:a2e:bd0d:0:b0:2ff:d49f:dd4b with SMTP id
 38308e7fff4ca-307cf2fd84bmr29082171fa.15.1738861058434; Thu, 06 Feb 2025
 08:57:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250204201108.48039-1-ebiggers@kernel.org> <CAMj1kXGjc6Abm1eHANt7w=D5eVpJXHHNo_7ZcyRMNMNwirZoHg@mail.gmail.com>
 <20250206163946.GB4283@sol.localdomain>
In-Reply-To: <20250206163946.GB4283@sol.localdomain>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 6 Feb 2025 17:57:27 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGtmdCCXLrbcrmGaEZTfT6nz9P=FokdtHhjtuQooY3d0w@mail.gmail.com>
X-Gm-Features: AWEUYZmUEU16fW4iYklv-4zqCTuFySJJKObCDU8KhxHEOLmb9SUJDrSJPLdSm8c
Message-ID: <CAMj1kXGtmdCCXLrbcrmGaEZTfT6nz9P=FokdtHhjtuQooY3d0w@mail.gmail.com>
Subject: Re: [PATCH] lib/crc-t10dif: remove digest and block size constants
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Feb 2025 at 17:39, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Feb 06, 2025 at 12:09:22PM +0100, Ard Biesheuvel wrote:
> > On Tue, 4 Feb 2025 at 21:11, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > These constants are only used in crypto/crct10dif_generic.c, and they
> > > are better off just hardcoded there.
> > >
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> > >
> > > I'm planning to take this via the crc tree.
> > >
> >
> > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> >
> > Could you remind me why we are keeping this driver?
> >
>
> I don't know.  I had to keep "crc32" and "crc32c" around for now because they
> are still used, and I just defaulted to doing the same for "crct10dif".  It
> *looks like* "crct10dif" is different and we could indeed safely remove it like
> I ended up doing for "crc64-rocksoft", though.  "crct10dif" has no remaining
> references in the kernel; it has no references in cryptsetup, iwd, or libell;
> and Debian Code Search doesn't find anything else.  It's over a decade old, so I
> was worried there was time for users to have crept in, but that doesn't seem to
> have happened.  So yeah, good idea.  I'll send a patch that removes it, with the
> device-mapper folks Cc'd in case they know of anything else.
>

Good idea.
