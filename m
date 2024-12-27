Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF979154457;
	Fri, 27 Dec 2024 08:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735288994; cv=none; b=b4GX2wr8Bgmi+rg/1jBtzGuObIku16tuCCJF0jXJe2hImnzxC1+ABoy5CfkAawkQaVXwbM/YvQZJJfsCW0576U6ggoMhofRjcHd3BMU0m/OWUsgPkRKLHtSOi3dJRyaqdE1XYeryZVWDzMBimvCZVIYJaiqLdnjEGxapsqO6rXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735288994; c=relaxed/simple;
	bh=RhhhWSx/EreyZNGNV47lSpm8OnSp6XFtaFvMGz+S+og=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jXi3NGUEJqobFnPx6RPtvITmTI5YVALhx9o2wUgDKHS1sNvGqzJGSFrwQC541jzGS7BH2iMAvhBOYVeGwEOPMmYaqwbyy08Q3WmjGyr45nhNFbbZMSJJcA081XN7pa4Kk3D6s4fhOn53OHBC0SZ722nvMhe252GCIaUdUZpGbW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DTb7zFgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DTb7zFgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57894C4AF0B;
	Fri, 27 Dec 2024 08:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735288994;
	bh=RhhhWSx/EreyZNGNV47lSpm8OnSp6XFtaFvMGz+S+og=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DTb7zFgr8jttbWVUgyp6ZKwZ3oHWQEC1vBDsG8gjybBZxqqmAxXiWRQKEFvJijy9v
	 xGo4rBT7rq3wQtOiGiBX7mU5GEaAv5o09PZqYJM2RF8qtTc1c8NDosGbdjrkdn8mfk
	 6ari/pRd3uuTcj8T4NxXa4xBXgiOggokbDJ5IPW/U+OyBoGlcsb/7zJCul81KD7Ref
	 S/bc8mzLhCUndqmbdF+GOGJauKBs2Vz6fSWKNddsAi9LMKQpCqvpn7y9g2C3G5LMS3
	 LwEzL3mYdSIASzCfQUccYkR6htAI5U8adH6Moi3RI8KoXI3rmvvFoGaF29kWNL27PO
	 4kSn7aLJDNuFw==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-540215984f0so7448774e87.1;
        Fri, 27 Dec 2024 00:43:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXLQufz8pJB/6LHFUnpB5LBv3ivI+RgIgkmTk1x0M6T2c18oUDf2aPbM1fgJLsnGaNgolnK327tmc6zdKA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrhQ9JsyjGpxGlN4eR+K8kYXbj9LZfggny9hlPkqc/uIUIiCgg
	VAyzG8h4Dpif/92LZK6RhMNIGqWsB8EUbIQ0PcVjA8mOoa8uFPZ8iIIomtrVE4Ip9LWgplbqYuk
	Rg3Qb6KRBE9qw4mor5ZmIS9tutZk=
X-Google-Smtp-Source: AGHT+IE9sTgBL15+HlHDoJP/WBKAy5PoB9bXCVJNqWoyGljD224wRAOPPbZypLIldMeb4VqafyVyjDcI9RgdmiX520c=
X-Received: by 2002:a05:6512:334e:b0:542:2972:4e1e with SMTP id
 2adb3069b0e04-54229724e74mr5957772e87.12.1735288992659; Fri, 27 Dec 2024
 00:43:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241226194309.27733-1-ebiggers@kernel.org>
In-Reply-To: <20241226194309.27733-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 27 Dec 2024 09:43:01 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEufcfUMoNW3M4T2CvnvJP4NyNF=YRAj8vh_pSyVywJ2g@mail.gmail.com>
Message-ID: <CAMj1kXEufcfUMoNW3M4T2CvnvJP4NyNF=YRAj8vh_pSyVywJ2g@mail.gmail.com>
Subject: Re: [PATCH] crypto: vmac - remove unused VMAC algorithm
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, Atharva Tiwari <evepolonium@gmail.com>, 
	Shane Wang <shane.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 26 Dec 2024 at 20:44, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Remove the vmac64 template, as it has no known users.  It also continues
> to have longstanding bugs such as alignment violations (see
> https://lore.kernel.org/r/20241226134847.6690-1-evepolonium@gmail.com/).
>
> This code was added in 2009 by commit f1939f7c5645 ("crypto: vmac - New
> hash algorithm for intel_txt support").  Based on the mention of
> intel_txt support in the commit title, it seems it was added as a
> prerequisite for the contemporaneous patch
> "intel_txt: add s3 userspace memory integrity verification"
> (https://lore.kernel.org/r/4ABF2B50.6070106@intel.com/).  In the design
> proposed by that patch, when an Intel Trusted Execution Technology (TXT)
> enabled system resumed from suspend, the "tboot" trusted executable
> launched the Linux kernel without verifying userspace memory, and then
> the Linux kernel used VMAC to verify userspace memory.
>
> However, that patch was never merged, as reviewers had objected to the
> design.  It was later reworked into commit 4bd96a7a8185 ("x86, tboot:
> Add support for S3 memory integrity protection") which made tboot verify
> the memory instead.  Thus the VMAC support in Linux was never used.
>
> No in-tree user has appeared since then, other than potentially the
> usual components that allow specifying arbitrary hash algorithms by
> name, namely AF_ALG and dm-integrity.  However there are no indications
> that VMAC is being used with these components.  Debian Code Search and
> web searches for "vmac64" (the actual algorithm name) do not return any
> results other than the kernel itself, suggesting that it does not appear
> in any other code or documentation.  Explicitly grepping the source code
> of the usual suspects (libell, iwd, cryptsetup) finds no matches either.
>
> Before 2018, the vmac code was also completely broken due to using a
> hardcoded nonce and the wrong endianness for the MAC.  It was then fixed
> by commit ed331adab35b ("crypto: vmac - add nonced version with big
> endian digest") and commit 0917b873127c ("crypto: vmac - remove insecure
> version with hardcoded nonce").  These were intentionally breaking
> changes that changed all the computed MAC values as well as the
> algorithm name ("vmac" to "vmac64").  No complaints were ever received
> about these breaking changes, strongly suggesting the absence of users.
>
> The reason I had put some effort into fixing this code in 2018 is
> because it was used by an out-of-tree driver.  But if it is still needed
> in that particular out-of-tree driver, the code can be carried in that
> driver instead.  There is no need to carry it upstream.
>
> Cc: Atharva Tiwari <evepolonium@gmail.com>
> Cc: Shane Wang <shane.wang@intel.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/arm/configs/pxa_defconfig             |   1 -
>  arch/loongarch/configs/loongson3_defconfig |   1 -
>  arch/m68k/configs/amiga_defconfig          |   1 -
>  arch/m68k/configs/apollo_defconfig         |   1 -
>  arch/m68k/configs/atari_defconfig          |   1 -
>  arch/m68k/configs/bvme6000_defconfig       |   1 -
>  arch/m68k/configs/hp300_defconfig          |   1 -
>  arch/m68k/configs/mac_defconfig            |   1 -
>  arch/m68k/configs/multi_defconfig          |   1 -
>  arch/m68k/configs/mvme147_defconfig        |   1 -
>  arch/m68k/configs/mvme16x_defconfig        |   1 -
>  arch/m68k/configs/q40_defconfig            |   1 -
>  arch/m68k/configs/sun3_defconfig           |   1 -
>  arch/m68k/configs/sun3x_defconfig          |   1 -
>  arch/mips/configs/bigsur_defconfig         |   1 -
>  arch/mips/configs/decstation_64_defconfig  |   1 -
>  arch/mips/configs/decstation_defconfig     |   1 -
>  arch/mips/configs/decstation_r4k_defconfig |   1 -
>  arch/mips/configs/ip27_defconfig           |   1 -
>  arch/mips/configs/ip30_defconfig           |   1 -
>  arch/s390/configs/debug_defconfig          |   1 -
>  arch/s390/configs/defconfig                |   1 -
>  crypto/Kconfig                             |  10 -
>  crypto/Makefile                            |   1 -
>  crypto/tcrypt.c                            |   4 -
>  crypto/testmgr.c                           |   6 -
>  crypto/testmgr.h                           | 153 -----
>  crypto/vmac.c                              | 696 ---------------------
>  28 files changed, 892 deletions(-)
>  delete mode 100644 crypto/vmac.c
>
...
