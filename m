Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACCE35F8B9;
	Thu,  2 Apr 2026 23:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775171504; cv=none; b=LJF6//oTa/xoX5EwAXCbqr+l1spXeEA8LIaBT8b2xCf5wuK1StnO96qOZrE8iaZfrh8kzpSxF1j2niYsi21QXdUQbnch5zSnVGbvR/wKdCrMiEurVl5ahwOA9m8lHU2gtvd8FwwCPiRfERHvvrnyP9tzt+RpDM7VV3jbm6nCuws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775171504; c=relaxed/simple;
	bh=8h1E32kMKguX58cLP/livqlA8gHZ69QIjreTlzb5fFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ux2IUVynMi7mmm9vQbIYf+rMa+2m4jMJFQLu5su14wvMN6M1JbeerX6AMjQAiea5pnsIjgxuyjIjgT5pAtFTwM2yBNPbpY+icuEeCdQijy6ZzK6+IKKW2eoyJ/hNL8MDzV2neKB6REIkNHUrhJMORKtMdu1X+kPrP4uXoTpKo+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/+wRZdu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/+wRZdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D60C19424;
	Thu,  2 Apr 2026 23:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775171504;
	bh=8h1E32kMKguX58cLP/livqlA8gHZ69QIjreTlzb5fFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h/+wRZduzum0NKhqehvBwXCxp7xlMFYgTBnO0ARAsmDxHGnvbl1PuNn/QYkBBvupK
	 KKBU/OY6ezFcRscp9gs62egVkBZbCN10ZuvxYCd+/KqeTCTL+LY1YmejEkS3kLd7bh
	 X4eJT64frt9dBpfasxT+78KmTo32LnzZ0tzATqxlHolNrGuwNuC61Hq2JNHk8hiRWZ
	 7aha093hvNoHO8AKxgM6eqJEslzxPxN08TzH0UnOe/1rKtOw30H2O6ubFsZwfeTYmH
	 SZBmtfxTmq+ffn99nQxuZ871k6LUWoosjoJzNXbp3vH+HuKKKsCTrD8eAFc0/S+AuV
	 EgO316NT6BDAQ==
Date: Thu, 2 Apr 2026 16:11:39 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: Include <crypto/utils.h> instead of
 <crypto/algapi.h>
Message-ID: <20260402231139.GC2910@quark>
References: <20260331024438.51783-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331024438.51783-1-ebiggers@kernel.org>

On Mon, Mar 30, 2026 at 07:44:38PM -0700, Eric Biggers wrote:
> Since the lib/crypto/ files that include <crypto/algapi.h> need it only
> for the transitive inclusion of <crypto/utils.h> (and not all the
> traditional crypto API stuff that the rest of <crypto/algapi.h> is
> filled with), replace these inclusions with direct inclusions of
> <crypto/utils.h>.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/aescfb.c | 2 +-
>  lib/crypto/chacha.c | 2 +-
>  lib/crypto/memneq.c | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
