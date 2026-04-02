Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9429F3CBE6B;
	Thu,  2 Apr 2026 23:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775171558; cv=none; b=f94vAqHx7HUNkemDVac2qtB65trqdmf4zKRgx8qIrJXufCNmpoQ9adFrlHXvvpcuCDG6zKuSWn5QPP9ebypI9r+rpa6p9wfS/EAfnoHgILxAG8ISZt6mY5AYoL4S/5jHkg2sA9B0KYc8I4HBKyQEMXu0oeRDzdqrxxVUOUVy/YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775171558; c=relaxed/simple;
	bh=4KoKXeuV+gv1aO4Hc4y0VUJ5jWRGUCNj0cNm6N4ZxKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fyTyGJg3k7ao0EWaVaNMFc/AKqek39KqucwHuVNnCFtSGyerpSZsNmW9XG/5waPmqcfuTKHk+Cgh+QNcZFf4vJVAO3RyyTL2sylpCi9BV5c1j08CpZmzg9N9BBv/V+0HT8O79T5jg9gov/yHG7ymTWAE2VJHYFy1VWr9YNou2Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaWifGZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaWifGZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF0EC116C6;
	Thu,  2 Apr 2026 23:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775171558;
	bh=4KoKXeuV+gv1aO4Hc4y0VUJ5jWRGUCNj0cNm6N4ZxKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iaWifGZVegT9SpOETXhU9V6uvCm/vc1EoEXUbbs1dDKy6k83jfr2k8pXcTd5tPnLc
	 GJx5Gr9+Qxvu2BVupi5HhTXnXl9TFApco+3XYr4clHdfBKDSj/UaGDQ4eFlimH14c+
	 +P1jBqErFJJVw04wRB7aXRUvpcGuuDIUiITHjcE9LSRxXRwnTfG/VEOhLFoaB2HAuy
	 A9m1Ud9W77BQlEBfrNagbd9CvehzlmuzBYpghs9iBWTI1x7V5osQlxYoS0deas46vO
	 aW2ROXaWzvJXeGSeyfsvIN119EV3AVBOqFO2OIvjEqva++Ii8O3fa2unMG3ZYmBGAv
	 4Ee9KbmrNGJyQ==
Date: Thu, 2 Apr 2026 16:12:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] lib/crypto: arm64: Assume a little-endian kernel
Message-ID: <20260402231234.GE2910@quark>
References: <20260401003331.144065-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401003331.144065-1-ebiggers@kernel.org>

On Tue, Mar 31, 2026 at 05:33:31PM -0700, Eric Biggers wrote:
> Since support for big-endian arm64 kernels was removed, the CPU_LE()
> macro now unconditionally emits the code it is passed, and the CPU_BE()
> macro now unconditionally discards the code it is passed.
> 
> Simplify the assembly code in lib/crypto/arm64/ accordingly.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
