Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388EA7082D;
	Mon, 28 Apr 2025 16:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745856708; cv=none; b=JoVDm7PeKgYEvWROianbYJiSgQc39mLBjEfO7b2ZWBa++7lKCwe19mWGMhVVrWgURu66L/kF+oRTUZ+Md+NaW7RSXbuwK8HjRikMhxXQQ6wfqf61isCxp530IvqirhKP9+EYAtM3THGXf167fc2YFnGItqj6oVbSIKbi64SdAck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745856708; c=relaxed/simple;
	bh=MbKO8SaBCDGxoiJgE8jQ05+BO3x2JyB6v8MlnkyG1BU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BilSxPckAgX3a2VAyRuMQoiA4La6zfMFeDnVuz1S9Q689DLC0Rqa/I+25/doEZu/YH8ULyMv6MCeRInJdb7e1bmaLBVUfbnaY503haNu1SpwVZFi9ck2anA4bCqnpIj6CrmHwpexcS78ryOZNYodNILWg3IcuHUq9VPRrpDlsk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HNd4J5te; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HNd4J5te"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85333C4CEE4;
	Mon, 28 Apr 2025 16:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745856707;
	bh=MbKO8SaBCDGxoiJgE8jQ05+BO3x2JyB6v8MlnkyG1BU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HNd4J5teYs3+43kb6ihtyUGVF2qwDOIZpIJi2yT3QSV4+r3maP6SUfhHdP85x+iT8
	 NvkfEPFXuszb7QtbNvmYMofVA1dg7JOo1OewdOt7hATjXB2y4N6jNMfsJW3hFOz8vo
	 25nYB6S6loiob2ZdTyqy18EEEmMiuA+Piw3eIcy/lRrteJmcD5xfwqXE5al7Au5tEn
	 Qrn9xrcFKHSH7iq3FwhqwUYVpBMQVwi5qn24jziwNsjC1GrN4str0kwgLG8DiEE7Rx
	 CAuhOVxzsj4XVMCT79BAy5HturBiwhgchmKbZQH98qeuk54mzPSTc17ZwpKl5/4C0l
	 BxxKBSK7ttpFQ==
Date: Mon, 28 Apr 2025 09:11:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "crypto: crc32 - remove "_generic" from filenames"
Message-ID: <20250428161145.GA1606@sol.localdomain>
References: <20250428125530.2018272-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250428125530.2018272-1-arnd@kernel.org>

On Mon, Apr 28, 2025 at 02:54:02PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Each loadable module in the kernel must have a unique name, so renaming
> the crc32 crypto module made it conflict with the crc32 library, as
> shown by the build failure:
> 
>  error: the following would cause module name conflict:
>    crypto/crc32.ko
>    lib/crc32.ko
> 
> This could be solved by renaming one of the two conflicting modules
> to something else again. As I can't think of a better name, just
> revert back to the previous state as the easiest fix.
> 
> Fixes: ce653e0a7e0a ("crypto: crc32 - remove "_generic" from filenames")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  crypto/Makefile                       | 8 ++++----
>  crypto/{crc32.c => crc32_generic.c}   | 0
>  crypto/{crc32c.c => crc32c_generic.c} | 0
>  3 files changed, 4 insertions(+), 4 deletions(-)
>  rename crypto/{crc32.c => crc32_generic.c} (100%)
>  rename crypto/{crc32c.c => crc32c_generic.c} (100%)

Dropped the patch, thanks.

lib/crypto/ uses a lib prefix on the lib modules.  We could follow that and do
libcrc32 and crc32.  I think that's a mistake though; nothing else in lib/ does
that, and it would imply that the Crypto API wrapper for crc32 is the "regular"
CRC-32 module and that the lib module is something special.  It's actually the
other way around.  So I'll propose crc32 and crc32-cryptoapi.

- Eric
