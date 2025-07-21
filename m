Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95626AA7
	for <linux-crypto@vger.kernel.org>; Mon, 21 Jul 2025 04:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753072764; cv=none; b=QQjfu1BWDnYXIiWgL/kFvljzEHU7uhnSKlhuH3wn5phPI3i8eMfo4L/YXHFD5eGPPg1h7MghNOZu06ZQFcR8hx3/VS+1JsnNS7+6nQEKpzhNGJgTXUdxTPqQXO37yWgiuBS60MbgavyUftdFyNW716VoNuXBVRKfMdOA6A8jFQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753072764; c=relaxed/simple;
	bh=+NBfCXOVbJTCcOUVmuXMnaKWytljkns5NLJTUzQdkT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EpHthPCCoFxRl53TGwBtPaIA0Sn2TMBah+Jv4+XQRiG5D9QeA1XbjdFR708vdZHvBhJ3/BK7bxTIm2Wz+4nfV58mlSOWuTn3afJatYau7yI/OyUxAqhsbrAhIW4FLSdI0JRmST6+9JKr9cX7Qac+pC8kgKDafVf/hud+t7FEGlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AsAp/sva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AsAp/sva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F78C4CEF7
	for <linux-crypto@vger.kernel.org>; Mon, 21 Jul 2025 04:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753072764;
	bh=+NBfCXOVbJTCcOUVmuXMnaKWytljkns5NLJTUzQdkT8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AsAp/svaIVEgP1VpxIVkZO33cX4wAekY+udfWkSUnSKMRlSGvLlYY2utXrHjspxFQ
	 TCJvJyaVm6c4VaL+V8a70fPDo4NxRsgMKinWa4N+sPVZm3+CAlQ5haAt7C3GrKIYDe
	 FF3HXRPPL7ygJFOLXt3H4BOcQW4hPs+zB94mgEPykDe+DsHv7kwWRkneqY2TLkmGSp
	 okfpx2xChaw6ZYvbbsfKilJS/v165UiB1CVeJvuI/IgsJBrH+EOy5RtYevctmzcuUq
	 VXaaLjI27xXWYmj9yhN1HUi7K9F8dseSNveHxmPx8M/Cit1JEX7WOqVcd3vzOP8IBo
	 i6xAy4jnXi86w==
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-32ac42bb4e4so34965851fa.0
        for <linux-crypto@vger.kernel.org>; Sun, 20 Jul 2025 21:39:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVSB/IehKWtauvqdMESEY7iqe+iRbs8hEu/R7dt582HXAeXY8jXmW1tZFW/sDEvoAdwpqLTBf1Gn0SaS7M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVhI4XRWLCi32lcWbA63V5/hSX2qRESxHiTGcaumK+NuCkEMHR
	JKl4WHgIHunLG8yqqcuezDSc7ULc1qvxmQqP34mOOZcxO/VN7FhohApWrEK5m0z71DO96CH8REh
	uvFcfnq4/PzmTHYv1o9xH/0ScOCZwiuA=
X-Google-Smtp-Source: AGHT+IEGeV7RQBO68+P8sQxm2CQn5VI9n6G5dpD6w9QCbCBwUCCgh9IpBbAyyug/+b7rFd+0lHZpVseIsQyv1AFi5Lk=
X-Received: by 2002:a2e:ae18:0:10b0:32f:22f8:a7a1 with SMTP id
 38308e7fff4ca-3308f61c682mr40110971fa.32.1753072762733; Sun, 20 Jul 2025
 21:39:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250515142702.2592942-2-ardb+git@google.com> <20250515185254.GE1411@quark>
 <20250718221645.GA295346@quark>
In-Reply-To: <20250718221645.GA295346@quark>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 21 Jul 2025 14:39:05 +1000
X-Gmail-Original-Message-ID: <CAMj1kXGp-643YkYko4V-L=nARY5OEMJPp+zQ+2tqzjj4MuyHQQ@mail.gmail.com>
X-Gm-Features: Ac12FXwhjxTpeivRdfUvJzMe4UjTzvKkHRmLnAluAqeGcL4VFi4H-osOnzM-reQ
Message-ID: <CAMj1kXGp-643YkYko4V-L=nARY5OEMJPp+zQ+2tqzjj4MuyHQQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64 - Drop asm fallback macros for older binutils
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au
Content-Type: text/plain; charset="UTF-8"

On Sat, 19 Jul 2025 at 08:16, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, May 15, 2025 at 11:52:54AM -0700, Eric Biggers wrote:
> > On Thu, May 15, 2025 at 04:27:03PM +0200, Ard Biesheuvel wrote:
> > > diff --git a/arch/arm64/crypto/sha512-ce-core.S b/arch/arm64/crypto/sha512-ce-core.S
> > > index 91ef68b15fcc..deb2469ab631 100644
> > > --- a/arch/arm64/crypto/sha512-ce-core.S
> > > +++ b/arch/arm64/crypto/sha512-ce-core.S
> > > @@ -12,26 +12,7 @@
> > >  #include <linux/linkage.h>
> > >  #include <asm/assembler.h>
> > >
> > > -   .irp            b,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
> > > -   .set            .Lq\b, \b
> > > -   .set            .Lv\b\().2d, \b
> > > -   .endr
> > > -
> > > -   .macro          sha512h, rd, rn, rm
> > > -   .inst           0xce608000 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> > > -   .endm
> > > -
> > > -   .macro          sha512h2, rd, rn, rm
> > > -   .inst           0xce608400 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> > > -   .endm
> > > -
> > > -   .macro          sha512su0, rd, rn
> > > -   .inst           0xcec08000 | .L\rd | (.L\rn << 5)
> > > -   .endm
> > > -
> > > -   .macro          sha512su1, rd, rn, rm
> > > -   .inst           0xce608800 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> > > -   .endm
> > > +   .arch   armv8-a+sha3
> >
> > This looked like a mistake: SHA-512 is part of SHA-2, not SHA-3.  However, the
> > current versions of binutils and clang do indeed put it under sha3.  There
> > should be a comment that mentions this unfortunate quirk.
> >
> > However, there's also the following commit which went into binutils 2.43:
> >
> >     commit 0aac62aa3256719c37be9e0ce6af8b190f45c928
> >     Author: Andrew Carlotti <andrew.carlotti@arm.com>
> >     Date:   Fri Jan 19 13:01:40 2024 +0000
> >
> >         aarch64: move SHA512 instructions to +sha3
> >
> >         SHA512 instructions were added to the architecture at the same time as SHA3
> >         instructions, but later than the SHA1 and SHA256 instructions.  Furthermore,
> >         implementations must support either both or neither of the SHA512 and SHA3
> >         instruction sets.  However, SHA512 instructions were originally (and
> >         incorrectly) added to Binutils under the +sha2 flag.
> >
> >         This patch moves SHA512 instructions under the +sha3 flag, which matches the
> >         architecture constraints and existing GCC and LLVM behaviour.
> >
> > So probably we need ".arch armv8-a+sha2+sha3" to support binutils 2.30 through
> > 2.42, as well as clang and the latest version of binutils?  (I didn't test it
> > yet, but it seems likely...)
>
> Actually "sha2" isn't required here, since "sha3" implies "sha2".
>
> The kernel test robot did report a build error on this series.  But it
> was with SHA-3, because in binutils 2.40 and earlier the SHA-3
> instructions required both "sha3" and "armv8.2-a",

... even though it is part of the ARMv8.1 architecture revision ...

> not just "sha3" like
> they do in clang and in binutils 2.41 and later.
>
> For now, I split the SHA-512 part into a separate patch
> https://lore.kernel.org/r/20250718220706.475240-1-ebiggers@kernel.org
>

That looks fine. I'll revisit the remaining ones at some point, but
not a priority.
