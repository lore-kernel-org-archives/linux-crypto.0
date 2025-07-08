Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666F91EA7E9;
	Tue,  8 Jul 2025 01:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751938807; cv=none; b=jQSHb2/ydI89sGrVevTpbg/rS98fMNNpQojShDb7MKu0QSfTC2UnXFjyy98wDkcNawBuxQ87prKsIwPtH/nnhhl5QQRDz6Df+tM/cv/dyumGvTf9JiC07fsPQQqOOPLxqTT9OGb5sMS9rvJ0umloHvbMO+Hginidr45qKjRVDY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751938807; c=relaxed/simple;
	bh=oUYRwPP56CvNkgwPRZNPluMS1mnfgi5LqiiX2TixEzE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ooxDnYEU4tcwlOB2NXGG57E3YbRCHWKJsRGnTWXxzn3VkrDPavR0htSdc072kDq/HLoHVan5zXjmst4QKyQw9IaYwvHNpxOtO5jILyJc/HrVTU/jtjqTJW3CBR0GMOvvTrbnCOf5BRvwWM6VHnRT3Mz8NTFCtwgZM44yv0d4bDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngl1yuNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngl1yuNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D56C4CEF7;
	Tue,  8 Jul 2025 01:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751938806;
	bh=oUYRwPP56CvNkgwPRZNPluMS1mnfgi5LqiiX2TixEzE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ngl1yuNjSNtPOklZg9q3phAX2h0AfpMjUSOgsTwbXEUS98rhzFOR5p3kOF7m/kGT5
	 Iy7Qd5l2F6rVncFLzpZLz6wsr0yOhEvAujLnva6OPjWyXn2ioUHI7oxsV/5OjYWArF
	 6Tmv7uEBVtnXntZpX4TpZ2YKakLpIKmayuG06aidYotp4cpPqWMElK0OHJES6F842F
	 MeZmlHVRp8BE1z6oAfFGBpRumE5l1G2tr4iNlFrs9shGHODzkqxOBP+A96GZmW1qq/
	 zdodQZZWAN6s3VJowwBrhi0ePbYH8YJs5t4Jx1LJJe/uCdC5opMszsyagXFgX2as2h
	 wNJYavLXOd6lQ==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-32b78b5aa39so36077771fa.1;
        Mon, 07 Jul 2025 18:40:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU0GUcqjDWRnlk+Y4AS5wDznLRjiTv1LMGSS/lJqih6fqnhBOqch1TjrSy8h8UKmz9ejIcb+PO8CGzoU6E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/NE4C2xG7pvM/OTQBvb3wx4wxaHDk0yUI8gS/6wig8vYyAuAu
	sTAtEGLAl6roggQtlS2gB5RPB0/87SxhvbYb1UqWk8d5169bkqh8mJXJ26pqgygYSrT+zHdJLdE
	hXn3ZEjK6vcgYFxnHCPmTuo0AtRVVZV4=
X-Google-Smtp-Source: AGHT+IEkFzCoH95ZJ8XDGNbeH0xUiIr1Yr5j1RBL5YvtAA4SnqvN/JgsfrnFFPs0kCVwKZk0KLIP2pzbGmtDQyl2w0E=
X-Received: by 2002:a05:651c:b0c:b0:32a:de39:eb4c with SMTP id
 38308e7fff4ca-32f00cc27d3mr52307231fa.18.1751938805280; Mon, 07 Jul 2025
 18:40:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250627190940.66756-1-ebiggers@kernel.org>
In-Reply-To: <20250627190940.66756-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 8 Jul 2025 11:39:53 +1000
X-Gmail-Original-Message-ID: <CAMj1kXGBs_rRTOw+Ejh78LU4d9NXeSs6a_HajmxmM-hxLsNuJw@mail.gmail.com>
X-Gm-Features: Ac12FXxtm4vI_kiSzQSFQ_cYaQMIubot1PAWTZOwQ-pV3TC5UgrCExFTreKs8oc
Message-ID: <CAMj1kXGBs_rRTOw+Ejh78LU4d9NXeSs6a_HajmxmM-hxLsNuJw@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: x86/sha512: Drop unnecessary ANNOTATE_NOENDBR
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 28 Jun 2025 at 05:11, Eric Biggers <ebiggers@kernel.org> wrote:
>
> When migrating the x86 SHA-512 assembly code to lib/crypto/, I replaced
> SYM_TYPED_FUNC_START with ANNOTATE_NOENDBR.  This was intended to match
> a change in the caller from an indirect call to a static call, like what
> I did for SHA-256.  However, for SHA-512 I actually decided to bring the
> static call up a level; see DEFINE_X86_SHA512_FN in
> lib/crypto/x86/sha512.h.  Therefore, now the assembly functions are just
> called via normal direct calls.  At least for SHA this seems to be the
> better way to do it, and it means using ANNOTATE_NOENDBR is unnecessary.
>
> Fixes: b82535bf96da ("lib/crypto: x86/sha512: Migrate optimized SHA-512 code to library")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting libcrypto-next.
>
>  lib/crypto/x86/sha512-avx-asm.S   | 2 --
>  lib/crypto/x86/sha512-avx2-asm.S  | 2 --
>  lib/crypto/x86/sha512-ssse3-asm.S | 2 --
>  3 files changed, 6 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crypto/x86/sha512-avx-asm.S b/lib/crypto/x86/sha512-avx-asm.S
> index af7ea311cc945..7732aa8fd8506 100644
> --- a/lib/crypto/x86/sha512-avx-asm.S
> +++ b/lib/crypto/x86/sha512-avx-asm.S
> @@ -46,11 +46,10 @@
>  # and search for that title.
>  #
>  ########################################################################
>
>  #include <linux/linkage.h>
> -#include <linux/objtool.h>
>
>  .text
>
>  # Virtual Registers
>  # ARG1
> @@ -274,11 +273,10 @@ frame_size = frame_WK + WK_SIZE
>  # The size of the message pointed to by "data" must be an integer multiple
>  # of SHA512 message blocks.
>  # "nblocks" is the message length in SHA512 blocks.  Must be >= 1.
>  ########################################################################
>  SYM_FUNC_START(sha512_transform_avx)
> -       ANNOTATE_NOENDBR        # since this is called only via static_call
>
>         # Save GPRs
>         push    %rbx
>         push    %r12
>         push    %r13
> diff --git a/lib/crypto/x86/sha512-avx2-asm.S b/lib/crypto/x86/sha512-avx2-asm.S
> index 1302ddb5ec8cc..22bdbfd899d0f 100644
> --- a/lib/crypto/x86/sha512-avx2-asm.S
> +++ b/lib/crypto/x86/sha512-avx2-asm.S
> @@ -48,11 +48,10 @@
>  ########################################################################
>  # This code schedules 1 blocks at a time, with 4 lanes per block
>  ########################################################################
>
>  #include <linux/linkage.h>
> -#include <linux/objtool.h>
>
>  .text
>
>  # Virtual Registers
>  Y_0 = %ymm4
> @@ -566,11 +565,10 @@ frame_size = frame_CTX + CTX_SIZE
>  # The size of the message pointed to by "data" must be an integer multiple
>  # of SHA512 message blocks.
>  # "nblocks" is the message length in SHA512 blocks.  Must be >= 1.
>  ########################################################################
>  SYM_FUNC_START(sha512_transform_rorx)
> -       ANNOTATE_NOENDBR        # since this is called only via static_call
>
>         # Save GPRs
>         push    %rbx
>         push    %r12
>         push    %r13
> diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
> index 108f1accc6bc7..4cae7445b2a86 100644
> --- a/lib/crypto/x86/sha512-ssse3-asm.S
> +++ b/lib/crypto/x86/sha512-ssse3-asm.S
> @@ -46,11 +46,10 @@
>  # and search for that title.
>  #
>  ########################################################################
>
>  #include <linux/linkage.h>
> -#include <linux/objtool.h>
>
>  .text
>
>  # Virtual Registers
>  # ARG1
> @@ -273,11 +272,10 @@ frame_size = frame_WK + WK_SIZE
>  # The size of the message pointed to by "data" must be an integer multiple
>  # of SHA512 message blocks.
>  # "nblocks" is the message length in SHA512 blocks.  Must be >= 1.
>  ########################################################################
>  SYM_FUNC_START(sha512_transform_ssse3)
> -       ANNOTATE_NOENDBR        # since this is called only via static_call
>
>         # Save GPRs
>         push    %rbx
>         push    %r12
>         push    %r13
>
> base-commit: d74152ec2b5106263c2a502380acfaf5954f9898
> --
> 2.50.0
>
