Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0292163B9;
	Thu, 24 Apr 2025 06:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745475762; cv=none; b=MP0dfVWRcS8AxqU3Lr2rEehwismCVz1ZSb2yJ+rW/8a0jnGA6sBtufgIeVigvCfNVMD36bJTRPJ1p3iiPFkxqZnmAzOZLq6Td68jmeQDMU3sZkPgcrCRD1bSs9FDdQau4HsWxraf8prIkFL1Bfhn7E/8kf4nj6sCOX1/EnhiIuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745475762; c=relaxed/simple;
	bh=MnbDTkDjx7fGLQrr6aq33qeElS5aQV1V02HztW2z4QI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=frsu2ERYpofBEYhXTR6UIHDkztKUYqCzPwRGLvbfv0wCvs+0BfzAT6S6qbfWgBRCTchBt/okiWIljFDkTsUzho7twq783500eu1FPYJWFMV1im2l9GpGhMICxtbRKoKyowqCnpis+3PpZ1Zzu+SRQBAZbfrOO/gXbeVTVgZ+pQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WtboPodA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WtboPodA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13DBC4CEE3;
	Thu, 24 Apr 2025 06:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745475760;
	bh=MnbDTkDjx7fGLQrr6aq33qeElS5aQV1V02HztW2z4QI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WtboPodAb4If3nkaa2PXy6oXsf0a3bXZctQ2wvPcXSI0l79MWAm4Z2gSZuz96IF9H
	 0qLlIMYtp2SHP6GDqfM8ztwqvVgTZY6FXR9F5f0adrLGLlrBdyf5RWCE1I7N7CrTTj
	 DAPkO1+pZGzixh+Urbuscma6hbYr7IX/6giX9wVWMj2r92tTCqm0d1+78+g71USLbJ
	 THF5D9zsliGl+VvssarcSIxgX6vlpU47E9eZMJKjYTEQ8nflTSxlLh63IVcKVnlFdc
	 SWV4SxmWIXzI3lSv6htjlMKoZppQdBmQJNjRQ4JTvSh2Z3t/BH9C3LOESeyqGxlX14
	 DIG6sr68pN51A==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5498d2a8b89so561949e87.1;
        Wed, 23 Apr 2025 23:22:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU+dwKdWGi/oXXv/11j017luD/6cSyRvbeiNO3r0QjubiBFfSFte6T0kd7axjJ2Hkj9+eleYdNWmT5lIA==@vger.kernel.org, AJvYcCXuh/6bjRJbOR9/eUAoB1aRDIp4OaoH5N1Ii2aif0sF/5MIqsjCpy7/Kyqzmf4gZkrFDGp1g2pKa3cBN/8=@vger.kernel.org, AJvYcCXwuHIeTBenxQd66PzjaQxJ3UZ6Qg9Vot5On3gbNx4yiWDuBmgFx9Tx4/OR0LcJ+frPOHm27OJxKI1ZlQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxOnWQp20667775jSdTbz7exANcqKgpyGzGXxaYuagK8Wredye9
	PbhCpy9LlZ/tQQoi/iEmVB/3GOMCil8YpRbr3hLpJgJ80V4VrOigR85OiFGJ1eVLilRR2lWaYaM
	esm4N8/ZIN1j1yaXIXSUOTK+71Lw=
X-Google-Smtp-Source: AGHT+IEBg0GksqRUxYbq10WiBQxT674qV08e5XaXakQ/0Ux/wZi1/Em/Ff29tbRd93xidxYNQXuF7ob7W4sz3W9cDJE=
X-Received: by 2002:a2e:b8c9:0:b0:30c:3099:13db with SMTP id
 38308e7fff4ca-3179e5ea6f5mr4171351fa.14.1745475759305; Wed, 23 Apr 2025
 23:22:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250424002038.179114-1-ebiggers@kernel.org>
In-Reply-To: <20250424002038.179114-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 24 Apr 2025 08:22:28 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFZ-Wy9Z5Rqe-o6fnKtgm+=JQeFnVMvG=jmKz36=02w6A@mail.gmail.com>
X-Gm-Features: ATxdqUEf-FfEO6d9z_202RUFsmqfhy6LhKcEQhVv3O5CQR6i6602IFM1v6-7V-w
Message-ID: <CAMj1kXFZ-Wy9Z5Rqe-o6fnKtgm+=JQeFnVMvG=jmKz36=02w6A@mail.gmail.com>
Subject: Re: [PATCH 0/7] lib/crc: drop "glue" from filenames
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 24 Apr 2025 at 02:22, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series fixes an odd naming convention that was unnecessarily
> carried over from the original Crypto API code.
>
> I'm planning to take this via the crc tree.
>
> Eric Biggers (7):
>   arm/crc: drop "glue" from filenames
>   arm64/crc: drop "glue" from filenames
>   powerpc/crc: drop "glue" from filenames
>   powerpc/crc: rename crc32-vpmsum_core.S to crc-vpmsum-template.S
>   s390/crc: drop "glue" from filenames
>   sparc/crc: drop "glue" from filenames
>   x86/crc: drop "glue" from filenames
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

>  arch/arm/lib/Makefile                                       | 4 ++--
>  arch/arm/lib/{crc-t10dif-glue.c => crc-t10dif.c}            | 0
>  arch/arm/lib/{crc32-glue.c => crc32.c}                      | 0
>  arch/arm64/lib/Makefile                                     | 4 ++--
>  arch/arm64/lib/{crc-t10dif-glue.c => crc-t10dif.c}          | 0
>  arch/arm64/lib/{crc32.S => crc32-core.S}                    | 0
>  arch/arm64/lib/{crc32-glue.c => crc32.c}                    | 0
>  arch/powerpc/lib/Makefile                                   | 4 ++--
>  arch/powerpc/lib/{crc-t10dif-glue.c => crc-t10dif.c}        | 0
>  .../lib/{crc32-vpmsum_core.S => crc-vpmsum-template.S}      | 0
>  arch/powerpc/lib/{crc32-glue.c => crc32.c}                  | 0
>  arch/powerpc/lib/crc32c-vpmsum_asm.S                        | 2 +-
>  arch/powerpc/lib/crct10dif-vpmsum_asm.S                     | 2 +-
>  arch/s390/lib/Makefile                                      | 2 +-
>  arch/s390/lib/{crc32-glue.c => crc32.c}                     | 0
>  arch/sparc/lib/Makefile                                     | 2 +-
>  arch/sparc/lib/{crc32_glue.c => crc32.c}                    | 2 +-
>  arch/x86/lib/Makefile                                       | 6 +++---
>  arch/x86/lib/{crc-t10dif-glue.c => crc-t10dif.c}            | 0
>  arch/x86/lib/{crc32-glue.c => crc32.c}                      | 0
>  arch/x86/lib/{crc64-glue.c => crc64.c}                      | 0
>  21 files changed, 14 insertions(+), 14 deletions(-)
>  rename arch/arm/lib/{crc-t10dif-glue.c => crc-t10dif.c} (100%)
>  rename arch/arm/lib/{crc32-glue.c => crc32.c} (100%)
>  rename arch/arm64/lib/{crc-t10dif-glue.c => crc-t10dif.c} (100%)
>  rename arch/arm64/lib/{crc32.S => crc32-core.S} (100%)
>  rename arch/arm64/lib/{crc32-glue.c => crc32.c} (100%)
>  rename arch/powerpc/lib/{crc-t10dif-glue.c => crc-t10dif.c} (100%)
>  rename arch/powerpc/lib/{crc32-vpmsum_core.S => crc-vpmsum-template.S} (100%)
>  rename arch/powerpc/lib/{crc32-glue.c => crc32.c} (100%)
>  rename arch/s390/lib/{crc32-glue.c => crc32.c} (100%)
>  rename arch/sparc/lib/{crc32_glue.c => crc32.c} (97%)
>  rename arch/x86/lib/{crc-t10dif-glue.c => crc-t10dif.c} (100%)
>  rename arch/x86/lib/{crc32-glue.c => crc32.c} (100%)
>  rename arch/x86/lib/{crc64-glue.c => crc64.c} (100%)
>
> base-commit: 1ec3d4ff5c77422927896c1f7d0ed01267ec1213
> --
> 2.49.0
>
