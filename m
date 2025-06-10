Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D990924502D;
	Tue, 10 Jun 2025 18:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749580932; cv=none; b=gcJSPZXP7OC/RPshJ/UP7Rbln17fRZcxsUmyFE7fwabKnB1+OfFqzADUZDYlOKmxca0jNxkYOPTLqLUt85diTXm1oXPxKNRCk7VP5wpl2DRDKTHFlguYG7B4oUaIHOjEiq3a1NcUC0itZkFCtpSXHDtTJT9USu4vOqGt1244yf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749580932; c=relaxed/simple;
	bh=SRK4oOAbH+Nd5/QGu3c6zwgfCNvKDJBW3daJbzcjYAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qehHO6ZmIyfFSE6c9SUPFB/DZLq118MR0T8xf3f/S9ZLojBvzSJanVxs5lKF/yATq7Kj2WGvxWollj47bYagnEFDSu/G4EfxxyEGMcF2LlkVfCnk5DA7JxAirCKmGI3GdWYslw4i+x4IFKjpUXA9WNULuw2pFV1v1K2fYB0TF10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o9un6jmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o9un6jmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F1FC4CEED;
	Tue, 10 Jun 2025 18:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749580930;
	bh=SRK4oOAbH+Nd5/QGu3c6zwgfCNvKDJBW3daJbzcjYAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o9un6jmUVybuavuWZsqHzWayBJ3FcxCqA/hi/it91vvatbcTVsqU18NLTfa+CiK3L
	 PksVxD1tuZT4Pflv/QVvET2D6AL5JFSI7ec/C4YJ1nKI/yr6z8ZxtjZ+F37WRs6SAX
	 dNZBaMOKRNiC6G5CvkQsY71T+t3HDQnqyf/ZAK4c04702mihq/dBczA6Z5piWRl/GN
	 EadwfB/f/yI+C90ZkuI/xeDFht7mtiWWh1OsPUOyW3FP2P0LNU0MHhgCFCNUSpdput
	 mJsRnZXObHkqIDb9G9RGcD7hzgy7O7rOoZtlAW1AoXRiqpf93d0zJF1R4bRD0jWE5p
	 sR6dJUHGfUKYw==
Date: Tue, 10 Jun 2025 11:41:46 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: Annotate crypto strings with nonstring
Message-ID: <20250610184146.GA1649@sol>
References: <20250529173113.work.760-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250529173113.work.760-kees@kernel.org>

On Thu, May 29, 2025 at 10:31:17AM -0700, Kees Cook wrote:
> Annotate various keys, ivs, and other byte arrays with __nonstring so
> that static initializers will not complain about truncating the trailing
> NUL byte under GCC 15 with -Wunterminated-string-initialization enabled.
> Silences many warnings like:
> 
> ../lib/crypto/aesgcm.c:642:27: warning: initializer-string for array of 'unsigned char' truncates NUL terminator but destination lacks 'nonstring' attribute (13 chars into 12 available) [-Wunterminated-string-initialization]
>   642 |                 .iv     = "\xca\xfe\xba\xbe\xfa\xce\xdb\xad"
>       |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: <linux-crypto@vger.kernel.org>
> ---
>  lib/crypto/aescfb.c |  8 ++++----
>  lib/crypto/aesgcm.c | 46 ++++++++++++++++++++++-----------------------
>  2 files changed, 27 insertions(+), 27 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

Thanks!

- Eric
