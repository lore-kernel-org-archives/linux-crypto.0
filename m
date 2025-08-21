Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E4F296BB0;
	Thu, 21 Aug 2025 03:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755747551; cv=none; b=Gkj9yIQ+cbELo8uufdKeQIPpJL666wpdEiLULEDs8+JBkHa8pxXSFFQRO4A7d/ATLcUmdskCnXxZbaMN6qqEyKBacRPXzK1mzDn0MPCoVY5cs1ZFSoeZqmf0vCyQglEHpyP3KtNO3/llpVX1umu075uwl0mNJ+G2OhwKo0pJgNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755747551; c=relaxed/simple;
	bh=+UVb2MqZsj0+Og3lACzapiVlaw5TiQuyOqeaaRcWKTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lzs++W0zJZqKARFIfhgX5WxxQdIvst+S3IQ/4Aes8Xgm0hrtk4hI1Fpd64UuVcjUf30eVAlPaT1zvm8klEpxEybZ9YTsgQ1GpKCs9DcW2HkQsNSTLjmR4rwpgjccF6SYLKbJlT/UutAFS0OkxU7f5yEpyrCOalE0F5pu7C6I0wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XqfMoK4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqfMoK4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C857EC113D0;
	Thu, 21 Aug 2025 03:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755747551;
	bh=+UVb2MqZsj0+Og3lACzapiVlaw5TiQuyOqeaaRcWKTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XqfMoK4SdSTf4lHGYLtWpSwyjCUNUp/MOP7W4W3PSMYH7huHL3ROBWZZ/BzzHRLHl
	 eOybeTaZ5edg16zmWsPUkeRsjth9hV47zLzx5Z2L9wen66asNo+/KlUJCnaxU+0W4R
	 MtWm+l+nVfGRPFHoAYNeGBgY1CBVAA265+5rw7gcBHVukK7K1T7fw1ggoysKaHPF/5
	 SWFLOXv8xBwRqJFQ/JDE7bin49ikgWjfS1inwq6SUaLtlEdoOwnkuGJhg0Vx+y/6uk
	 jvWUh5k97Jt4R4UfHsEHvdArkHbpH2SgdO/B5v1IUy3JWo6TLtj5nBZNSzOgcoP6my
	 TMsJTaTeRTNKA==
Date: Wed, 20 Aug 2025 23:39:08 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] lib/crypto: Drop inline from all *_mod_init_arch()
 functions
Message-ID: <20250821033908.GE185832@quark>
References: <20250816020457.432040-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816020457.432040-1-ebiggers@kernel.org>

On Fri, Aug 15, 2025 at 07:04:57PM -0700, Eric Biggers wrote:
> Drop 'inline' from all the *_mod_init_arch() functions so that the
> compiler will warn about any bugs where they are unused due to not being
> wired up properly.  (There are no such bugs currently, so this just
> establishes a more robust convention for the future.  Of course, these
> functions also tend to get inlined anyway, regardless of the keyword.)
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/arm/sha1.h     | 2 +-
>  lib/crypto/arm/sha256.h   | 2 +-
>  lib/crypto/arm/sha512.h   | 2 +-
>  lib/crypto/arm64/sha1.h   | 2 +-
>  lib/crypto/arm64/sha256.h | 2 +-
>  lib/crypto/arm64/sha512.h | 2 +-
>  lib/crypto/riscv/sha256.h | 2 +-
>  lib/crypto/riscv/sha512.h | 2 +-
>  lib/crypto/s390/sha1.h    | 2 +-
>  lib/crypto/s390/sha256.h  | 2 +-
>  lib/crypto/s390/sha512.h  | 2 +-
>  lib/crypto/sparc/md5.h    | 2 +-
>  lib/crypto/sparc/sha1.h   | 2 +-
>  lib/crypto/sparc/sha256.h | 2 +-
>  lib/crypto/sparc/sha512.h | 2 +-
>  lib/crypto/x86/sha1.h     | 2 +-
>  lib/crypto/x86/sha256.h   | 2 +-
>  lib/crypto/x86/sha512.h   | 2 +-
>  18 files changed, 18 insertions(+), 18 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
