Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794089101;
	b=pI9tYnH1IhqihN6dqmdZtORuR+D8UTg/ZtFrH+Be+9At/AV6aAcXI3ZCcFF8ESwvOGn1
	 K/JgkRhhj7CX66nXeqdcJp5/ZAWyamwoYmiZi7Iy6fRm8sl0hsrfWCm9nw8oKMQzANrNK
	 hmvw2za0LkLPJCNBJ0kFJHzckUeMFiRuMherQuuPCTAKE/I4n6f6ZLdxVpid8FcQa+iAg
	 sFwIcmiZFtqFOM+SOZXEiN9kW9Io6I/wyVS5ovivrHGdA81j1BBiTZtk4J8JqnFPhCHN9
	 IjmUbgIg1+7pbO+wCefTzxHr+lQP5NB/OWCkOdCac5651CRmc5LDtDuG34UxxLUSmMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794089101;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=u2523iWY8SvdNIod4ebnybmgX4R59xI8eL3agzPZycg=;
	b=j/m/oY6MNhu28vsyEKIzUEXw3VajBK6XLDndzVsXDr+W4FRZEaNg0SoUVhy2scqgWL+K
	 grgklLXgeHDMdXsSor1HhsLGbfjxefbQ+LnJD1CoubXN/VuqOau7yunruOY8YJaNYn9jw
	 iTtEoh17x3OZfgn9hXSPXJZwjjZ3Xo2Rw/YH9FdDeM7KxpM+zYOlHvUwcAaFsC/HDarkP
	 MchdDEaitNYPUgvXrgxuR6TQ7GrMZSL8sBnTfW2q/sDB2LjOh/IbLw5LCcQmbrmPntnUI
	 uhCgRuj7gGMlRjSQCOxassEQqwsGJ6O9uJPREH3LwxqAaj8ad0XeLhG6Oz4cEgmd9JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EOaYrk6e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1FB606A326
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 22:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EOaYrk6e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D5B1F0089F;
	Sat,  7 Nov 2026 22:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794089100;
	bh=u2523iWY8SvdNIod4ebnybmgX4R59xI8eL3agzPZycg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EOaYrk6e7ZwdYSYeCfV/KnivGThlEGhUuKk4vTaHOnFaHUirXZLyiINELhg26fjMR
	 Njg0Uo3bpsuaW3wfC1lvBEJOAaVz+RF8Wof/INjMzI9WVYj/wIhFtZQy6U74eASnvR
	 or8otwaeKoRhUGAgqCKn3tOk+x6G/cOQAISNifh/7vdNUNkK7XmdZ9R9hvEAR8vi2b
	 S2LTcq02DmBgq4KxYD1cF/UthlGAvCaBoL1yj5Z8cIa6fm3RKpCRCRxvRg3osHlctT
	 Bs86hqRKCrKOfipyt35Mhsqp+ayJXu68FNyqyutKWmgUYzieL7f9e1/MPiwA36l+F9
	 tmT+w+A9cbLVw==
Date: Sat, 7 Nov 2026 14:04:58 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH] lib/crypto: x86/nh: Remove unnecessary check for SSE2
 support on x86_64
Message-ID: <20261107220458.GN137269@quark>
References: <20261105043710.310742-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105043710.310742-1-ebiggers@kernel.org>

On Wed, Nov 04, 2026 at 08:37:10PM -0800, Eric Biggers wrote:
> Remove the unnecessary check for X86_FEATURE_XMM2 (and the have_sse2
> static key it controls) from the x86_64 optimized NH code.
> 
> This code is 64-bit only, and x86_64 kernels require X86_FEATURE_XMM2.
> (See X86_REQUIRED_FEATURE_XMM2.)
> 
> Also replace <linux/static_call.h> with <linux/jump_label.h>, since this
> file uses static keys, not static calls.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/nh.h | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
