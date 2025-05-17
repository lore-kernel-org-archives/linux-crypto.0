Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314DD4B1E76;
	Sat, 17 May 2025 04:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747454683; cv=none; b=gHmiRQKWSertujIz7dWZxDY2MkiBFvSueJKAwnUm2LQf8ehPo4R56m1P80q4d4H18IfRLDu++3bg9AIn3vqdUJc9truQ60/EWi8GDkbLpEvwbHSws+YN8jXBLr+YK9Hevh6XdREDueyv1Tj+ZO5AIWhOZN3bn1+CSl6o7fCOxFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747454683; c=relaxed/simple;
	bh=1vRjM3XvjwfIykQPa3Xkj1NllSnYDC3NpEBH9OkOJno=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=exD+piTP70JZR6NrqjwGgA+Yy6WFp8FrirMnJToei/OcnRdmX7IPvHbu34b8PAR5tVHQ5XaVASzetWLnQKXh40EzJ2qQtivVjt+Vv5R16qZUEeSmSwn+RuTQIYDZ7PxcZc5NIrdLnWrsTOhqZ9Sd44TNObGAmTEHZShlEdaZl3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EDx64oHx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EDx64oHx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Uwqu2b52J98glaxbPk7AfH0U6sSJXaY/+XEyftIzbzk=; b=EDx64oHxMzQ6vAsNnA8/frK4vF
	oNBGOspz07bgp10uR4DwooOW0fhoDjvAxC4OKwnibppueKxJqs6q0OCb0q4XhiDn7BqNVf7hI6/jD
	yb9T3j5faH/LwFgMLEMThtkg1sIagSQe7VVHkaHY6IUfUmN4KFvWZRzAXhwT45rRR5i0YzW1QQxtp
	+eKJFX06CXowF+FA/4kePGjVq+kv8mfTV7drNNEVXzbJWP4Vc9rBQk4P7S08CbsYDf7kgPM02d7+p
	cvS+MWlBYn2mEJIlfE9WfNTldYAgpTZ0WOEqesf3ZmeZwh7k2zhJrOpN5PWUwkdK53yS6MgHNmalw
	EDZa7sug==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uG8mn-006kn8-34;
	Sat, 17 May 2025 12:04:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 May 2025 12:04:33 +0800
Date: Sat, 17 May 2025 12:04:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] SHA-256 cleanup
Message-ID: <aCgK0TDExgBnBHX9@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250517022428.401622-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> This series restores the SHA-256 code to have a clean design where the
> crypto_shash API is implemented on top of the regular library API
> instead of a special unsafe low-level API.  Diffstat is -41 lines.
> 
> Eric Biggers (8):
>  Revert "crypto: sha256 - Use the partial block API"
>  Revert "crypto: lib/sha256 - Use generic block helper"
>  Revert "crypto: x86/sha256 - Add simd block function"
>  Revert "crypto: riscv/sha256 - Add simd block function"
>  Revert "crypto: arm64/sha256 - Add simd block function"
>  Revert "crypto: arm/sha256 - Add simd block function"
>  Revert "crypto: sha256 - Use the partial block API for generic"
>  Revert "crypto: lib/sha256 - Add helpers for block-based shash"
> 
> arch/arm/lib/crypto/Kconfig         |   1 -
> arch/arm/lib/crypto/sha256-armv4.pl |  20 ++--
> arch/arm/lib/crypto/sha256.c        |  14 +--
> arch/arm64/crypto/sha512-glue.c     |   6 +-
> arch/arm64/lib/crypto/Kconfig       |   1 -
> arch/arm64/lib/crypto/sha2-armv8.pl |   2 +-
> arch/arm64/lib/crypto/sha256.c      |  14 +--
> arch/riscv/lib/crypto/Kconfig       |   1 -
> arch/riscv/lib/crypto/sha256.c      |  13 +--
> arch/x86/lib/crypto/Kconfig         |   1 -
> arch/x86/lib/crypto/sha256.c        |  12 +--
> crypto/sha256.c                     | 142 ++++++++++------------------
> include/crypto/internal/sha2.h      |  52 ++--------
> include/crypto/sha2.h               |   7 +-
> lib/crypto/Kconfig                  |   8 --
> lib/crypto/sha256.c                 |  97 +++++++++++++++----
> 16 files changed, 175 insertions(+), 216 deletions(-)
> 
> 
> base-commit: 1bafd82d9a40cf09c6c40f1c09cc35b7050b1a9f

Nack.  This breaks the cryptodev tree.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
