Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4F615442A;
	Wed,  9 Apr 2025 02:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744167002; cv=none; b=o/UpaD//WydIVrfPh7b19drRzAoOUQ3nk/WRgq+qvTdFx24E6eSTgfwS1cXcmy8Ivp70BGqvLXdwwjdDXCoGvcBaCxL0OYKGxMhkXCuafpI/bI/bzRzHObu3q+lmXOBNnjW1xrbOhraVSh5xVEWlOFSKoNh9epOdYiosKQqAWT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744167002; c=relaxed/simple;
	bh=v8pmHbRFhEkEll44lXfHjE2MVQoEHKwhbr1Y+FFvQ7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JvR/Vzc7EJJl+sZFp5ysbfKi/G00f2eRY+2FI4+0/pEk6erCbWtESu5H9LHm/kzMN9G9OXop3naHUh5Fl75a2oOy/9ii3NleCuq3xIsjWJdNEEvH5z1X2fA4gkUMan2NfTPsNPsFW09MLHq4sZ3Qw6+47HhNIUa9KlmjFSGx1KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nvHmZALx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nvHmZALx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DA7C4CEE9;
	Wed,  9 Apr 2025 02:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744167001;
	bh=v8pmHbRFhEkEll44lXfHjE2MVQoEHKwhbr1Y+FFvQ7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nvHmZALxmALi3k//Y94NhzIkA9NIs44ZiWlrMczvCcqtENgxQQedowXsNGupWcEDm
	 f0HMaXUiWXcffpDU594ByCoeowrzaHUtWCsnXlKuJgi7/24EPeFsMXapRsk/swRv0n
	 FzZv0l/ZGvqxJLdZFxEvwxN5SZR8kdCNZ8ov9IxaY0pc77uYxJNZHKRY8+D7NYi58Z
	 8RQoCqsDQARwVrFhOd3rvxu/Jc+NF/FVKerZ1bOjQmSl7ysasUHw2B9KnHWPKuGNYu
	 yuESrTojj4DVgBpfVHFewqg6zmXOZ3pkI9UcG8do11qC8kMj573h7WtFnRPpOdS2Op
	 lpQp24Rn2UyIA==
Date: Tue, 8 Apr 2025 19:49:59 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: crc32 - remove "_generic" from filenames
Message-ID: <20250409024959.GA4424@sol.localdomain>
References: <20250405183324.441383-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250405183324.441383-1-ebiggers@kernel.org>

On Sat, Apr 05, 2025 at 11:33:24AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since crc32_generic.c and crc32c_generic.c now expose both the generic
> and architecture-optimized implementations via the crypto_shash API,
> rather than just the generic implementations as they originally did,
> remove the "_generic" part of the filenames.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/Makefile                       | 8 ++++----
>  crypto/{crc32_generic.c => crc32.c}   | 0
>  crypto/{crc32c_generic.c => crc32c.c} | 0
>  3 files changed, 4 insertions(+), 4 deletions(-)
>  rename crypto/{crc32_generic.c => crc32.c} (100%)
>  rename crypto/{crc32c_generic.c => crc32c.c} (100%)

Applied to https://web.git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
