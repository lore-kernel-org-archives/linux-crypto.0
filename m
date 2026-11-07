Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794087591;
	b=0fPItc3jphU8agqEvOTxtYkYvPTaG31r5er0iQZanE6v9Vs8jCFAqy7LooVK59/uuk5A
	 QPr0OGdmGZaUbx41S2ZH65l4jzeANaVaH9CUUe5ab/AmKhODpv5BXWdS1+HiK3ed9J9OT
	 uST/gL0PYdm9RAQLlyDGkRukIi547A6wuXeVl3msrj1R7jw7UAPi0TKsXfukHHWxxSrT0
	 eTDpV5yDFXIAbcIQWPhI1ASUBaziL8goCfa5wGJ7TXoxEJ4eHlV4wc22jhMP80un3JeAM
	 SxmFK/h7DL9RH6finn7sotcr4sounKuxkyg+uLX0HQScEMs5k/pcFdJaYuMM9hfJvOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794087591;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=N6BX7jy9UP524WlkQd/sKHQmxwNRGsDuHmwgftesxwc=;
	b=bdSU3c63uhPfuWUJoK3UfczU9yn1iGTopurtRaWRUOkHjDKcC4ccXuOHGBzwl+sT8Kjt
	 5C5hoSzPDhtnFQjA+T4BI7t2EJ+3vQ68YNthYVdIr7qAah5lK0vifSs9L7346EOrO4GhE
	 hhJaEBDr7+UORaTZb3fGVbBZehp7JKNap4RtBTuqsplwre40G3JeMmu9+OFdG1zDtQs1R
	 QxLO73+oBrtarwHbl52MRAzSJPKzorML7ipF+M4HFqIxUL8Nu9YmdQuVUj/pPwipryaXq
	 y386YAAfp7GGyHfHJDGjjQQB8MlrSGpM0cljw0zW4VdzisnORHuwxmw7TS449l2eElA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FZ6y7H25;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99330606A32D
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 21:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FZ6y7H25
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FE81F0089F;
	Sat,  7 Nov 2026 21:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794087591;
	bh=N6BX7jy9UP524WlkQd/sKHQmxwNRGsDuHmwgftesxwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FZ6y7H25zRt2Fu64hKiew23g2fWY5v1ZsZdPnOBESTUMuWZllvyK0ikoTUSg5ei6Y
	 oOCUesb3uP5QBVT2qYma37FVoVCK+Bt9yIN8yrpmZOkKTUSreFnCFjvGAHs1SUkRdt
	 P6TmJb9M42Fb+9kZ1GE91MqiG4KSIsmLsoY3q5+72+abU235Mv8Wbbq0P/lzLUJ24M
	 CsyVanFSryurr7Q0flQlAwEKqyHLbg7t12ajzza/7k/k8oDRz3J1cM9dpu+oYfISK3
	 bCN2gns7b9KzpdDVXreDK6kqtEHOGeeccsHVaqzEjVCQG4/V63fY6dvZh3+BLHajNL
	 gHxxKwvUglY7g==
Date: Sat, 7 Nov 2026 13:39:49 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: Re: [PATCH] lib/crypto: x86/chacha: Use bzhi to simplify mask
 generation
Message-ID: <20261107213949.GD137269@quark>
References: <20261103235027.63382-1-ebiggers@kernel.org>
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
In-Reply-To: <20261103235027.63382-1-ebiggers@kernel.org>

On Tue, Nov 03, 2026 at 03:50:27PM -0800, Eric Biggers wrote:
> When XOR'ing the bytes from a partial register at the end, use the bzhi
> instruction (from BMI2) to generate the needed mask a bit more
> efficiently.  All real processors with AVX-512 also have BMI2, so we
> might as well make use of it.  This follows the example of the AVX-512
> optimized AES-GCM code which already does this.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/chacha-avx512-x86_64.S | 30 +++++++++++----------------
>  lib/crypto/x86/chacha.h               |  3 ++-
>  2 files changed, 14 insertions(+), 19 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
