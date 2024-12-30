Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F521A83EA;
	Mon, 30 Dec 2024 11:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735556720; cv=none; b=V8ygYP87Bxgw7R4XMxT9wYowDB+61oMMizqVSeFiHT/Tb1u1NOy3n47lDd+y+NH4212OtHBAk30JAZeBOtifC6giVkG94xaEAcUE3xfvRydOPx0mFpG1b//pnGwlRmYyqVaZ9SG2g0icqAwt+e7Rd/n3v04Kaw7eVnGIS/SxAy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735556720; c=relaxed/simple;
	bh=qfb7DHzgExVzKgGWJHPlFxeVctNnqLg3iDSUuMPUUXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P8gUFvViu9ZNd8czHLYexMimPFumiocK4nMqTK9C5P5wMdWvYiQPLL7/7Z9VqygnRVLfu0zG3SkplQC2lYZtd6vyy3QGKs8KObVX59yNhskkvGKS2PpYfB4t9idsqb6J5cjPNr3bTk/bFlfYnsWysOmNVwrGm+icRw2OKlA70ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-518808ef4a1so2842280e0c.3;
        Mon, 30 Dec 2024 03:05:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735556716; x=1736161516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=id47K/4a6U+QFVGteH4iyr7Ptsppi8ire0OS89OefHg=;
        b=UG39lFcqTTPOLaM+fcV+BsBXnhg8KZSzqQgJSODoplbyQdkSUfFwmrqSb5Z19b0Kza
         KVG0sbpJ7D4uHSe0r3cO8aoyX0G3mIO2rp9sB/P4VBIfZ9UXAuJhft5Wnf4H9i/XDdC9
         ZeFMkJFdZkhoQgxUBMOyKtmkkN04+wHb4IoqwhYbT7wtEwi8o7vqfTVl15GKTkF+uKMF
         Np9GHu/1pR2y5JtIiBWHuw3N9LsKm+dWcdoQh+6V09maLykIQ1nl2SyfJJVoL9goGJM/
         izEbsLyYtBgQHJRDVN/iPrnlicdtMXX8fHm6pryDUXUMrDamzrR2+YlolZZWEv4fxU3a
         Cy5g==
X-Forwarded-Encrypted: i=1; AJvYcCWGMX0NJXCB+LCFDir6lfRKSy1EZLKE4xN5X/ds2qNeXWbOvAL4q7ZONRZKoMAXkaLcPE4GaCSN5iguO/0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJwQnOohU4PXsDAGD73GseL4bgKh2VvqD3HYF1LEdSsGMgGcfy
	e+VO0vzQDyr19fKfkZPOitt4Q9jl/nRHs4MceW7pViv/PFtRH0xkpwRxcso3
X-Gm-Gg: ASbGncuHWYiZ64LE1IWwMKyrg74dimVC9ISRX25blGIe06JvTFS+usDGSBq79E/Pmpa
	989sJ52EaJytszW6I/YNmslZ5U5+G6wkOrT4NoceQIpNndzb1igEt2PrlQavSOSiOA66TLQLd/G
	f4TCmbNocHQ2rInMTC4pT03QhxqIQerRvb6fKqDJBirvLez20R5VA61xQ+J+imT7VkB9CU/hltq
	/E+m3jVKm0/buntEBmG6bMFCq0kSkdCt483W/qQ4FeFEUM77i9w903/oNUzA+ZowFGVWr1ys8wr
	sxRI0dqYgVssPFpGip4=
X-Google-Smtp-Source: AGHT+IFDjw0OLR9fVsPQ9wafoY54jQMJNeo+tOFF/U07NbT4/mAvyfU9CzMHSWd3M1KvHpYwNKr4+A==
X-Received: by 2002:a05:6122:2a44:b0:518:81aa:899b with SMTP id 71dfb90a1353d-51b75c6fb79mr23151745e0c.6.1735556716107;
        Mon, 30 Dec 2024 03:05:16 -0800 (PST)
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com. [209.85.217.52])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-51b68bf014bsm2357800e0c.25.2024.12.30.03.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2024 03:05:15 -0800 (PST)
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-4affd0fb6adso2461871137.1;
        Mon, 30 Dec 2024 03:05:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVF8jIu7BbxBs5fVPTobo9bBE6Ag6VINgWiJtMRuu8o2srjVBVidHh3d3wxCIKFGOn8/u5tUF+b5uN2cJ8=@vger.kernel.org
X-Received: by 2002:a05:6102:c02:b0:4b2:5c72:cd55 with SMTP id
 ada2fe7eead31-4b2cc31f256mr28218146137.5.1735556715611; Mon, 30 Dec 2024
 03:05:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241226194309.27733-1-ebiggers@kernel.org>
In-Reply-To: <20241226194309.27733-1-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 30 Dec 2024 12:05:03 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWRim0-vjzRSAhrSmukVxo_gzY_dDrtY_mYOPU2An9h+Q@mail.gmail.com>
Message-ID: <CAMuHMdWRim0-vjzRSAhrSmukVxo_gzY_dDrtY_mYOPU2An9h+Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: vmac - remove unused VMAC algorithm
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, Atharva Tiwari <evepolonium@gmail.com>, 
	Shane Wang <shane.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 26, 2024 at 8:44=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
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

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
