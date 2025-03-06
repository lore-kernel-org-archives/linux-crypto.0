Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26779450
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 08:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741248947; cv=none; b=Vrniz3UCZhBfYqpyiVrJEx14yoqiawvJQ2aTCQPqo0elZ190gAoB06HGSEXB9da9F3v/E0mJ/huB6PMBFQDv0uDSi5RaWd0kiLXpyljgMzgIUjF1IIzN4/AmudHwlbOyrCfV7oyorSCEaYvN7fzBzSwvtFYjAOWFTQPnzFRmtMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741248947; c=relaxed/simple;
	bh=ANwq88u975BdIIs07u8qtA3KbLF0jq+BOZtMd8DrZw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yrg1Yo51NoyIfFVYwu3e2FQOP4BL1odZmFXkXucSNJruv82JgUTpGUE6CW87DE/Q99FpsbaesZKqREeSi3OoH1Fb8hcVNp7Nf1jU8a29M+qX0qSrPARyU+pZdcvVWOEtf0OAkfsx3UqdpUP2nLdaC93I9kp/KJ0tsHK97pD0zGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nKwm5Z2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nKwm5Z2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683EAC4AF0B
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 08:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741248946;
	bh=ANwq88u975BdIIs07u8qtA3KbLF0jq+BOZtMd8DrZw4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nKwm5Z2NQ+C5eXXXc8IsZXiOEe7mjHRiSdmcA4iTAdT89n5WTlsG35NaPTGmg8AxK
	 bEB6JUucve3FWsmTTljEtGLj6SHXYOuNKFRLaVsIKzzFtUMS9ENuw/T55WU7/8PynA
	 Un4DEHmRA11uoxFiKSx7Ekgq52HDJ1QyLx5wZDKyHPL0doM3cgYKSYlKCK+SYNSBng
	 dHelPsdkEKtx3Lju3wrP3uG0udkOTpnmwcyr8afWRxfLBqQv7IZ88ChhnWp323uIjI
	 2oi2wvZSn6i4Xg5pVQfOJBljfSJvy8Ml5mHTGqx1Fn8sBq2zHOIzDcKz93n593jNml
	 bUZ6zUm0bkF6g==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-307d1ab59c6so3500121fa.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Mar 2025 00:15:46 -0800 (PST)
X-Gm-Message-State: AOJu0Ywd7n34QdOF5sHunXxx9gte+S4TWsaMuC3t3f8kpOW/sjDtorLl
	tyuj5vivsoVcaTQcVKSVmhY7qKvDEJonMYqdD4MsZCqxx1iafo/v+Rx4DOkeZOPIdkNUOOBaSzp
	TMY8KxqV0l6w/4G2fDe+v+Y+zh10=
X-Google-Smtp-Source: AGHT+IHUkvJ9lB5Q1YIiX2hdmqsu49fzlm0P+cWPvvvulbO09jPMU6IrIQISBzi4TGQwAFV2qSgikTh+leaJMl+EiMM=
X-Received: by 2002:a2e:7a1a:0:b0:308:fa1d:1fed with SMTP id
 38308e7fff4ca-30bd7b1376emr21363181fa.34.1741248944648; Thu, 06 Mar 2025
 00:15:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1741080140.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741080140.git.herbert@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 6 Mar 2025 09:15:33 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFfrXFuA-jrH6hiZe8kSoCrfRfUuhPDzw_nihPFLnNf=g@mail.gmail.com>
X-Gm-Features: AQ5f1JrS5R4mlZ7i0vWcHXVM01QXrbOPQiHnQki-ffslO7XW-LHPM4eaFwegfPg
Message-ID: <CAMj1kXFfrXFuA-jrH6hiZe8kSoCrfRfUuhPDzw_nihPFLnNf=g@mail.gmail.com>
Subject: Re: [v2 PATCH 0/7] crypto: acomp - Add request chaining and virtual
 address support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-mm@kvack.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 Mar 2025 at 10:25, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This patch series adds reqeust chaining and virtual address support
> to the crypto_acomp interface.
>
> Herbert Xu (7):
>   crypto: api - Add cra_type->destroy hook
>   crypto: scomp - Remove tfm argument from alloc/free_ctx
>   crypto: acomp - Add request chaining and virtual addresses
>   crypto: testmgr - Remove NULL dst acomp tests
>   crypto: scomp - Remove support for most non-trivial destination SG
>     lists
>   crypto: scomp - Add chaining and virtual address support
>   crypto: acomp - Move stream management into scomp layer
>

How does this v2 differ from the previous version?


>  crypto/842.c                           |   8 +-
>  crypto/acompress.c                     | 208 ++++++++++++++++++++---
>  crypto/algapi.c                        |   9 +
>  crypto/compress.h                      |   2 -
>  crypto/deflate.c                       |   4 +-
>  crypto/internal.h                      |   6 +-
>  crypto/lz4.c                           |   8 +-
>  crypto/lz4hc.c                         |   8 +-
>  crypto/lzo-rle.c                       |   8 +-
>  crypto/lzo.c                           |   8 +-
>  crypto/scompress.c                     | 226 +++++++++++++++----------
>  crypto/testmgr.c                       |  29 ----
>  crypto/zstd.c                          |   4 +-
>  drivers/crypto/cavium/zip/zip_crypto.c |   6 +-
>  drivers/crypto/cavium/zip/zip_crypto.h |   6 +-
>  include/crypto/acompress.h             | 118 ++++++++++---
>  include/crypto/internal/acompress.h    |  39 +++--
>  include/crypto/internal/scompress.h    |  18 +-
>  18 files changed, 488 insertions(+), 227 deletions(-)
>
> --
> 2.39.5
>
>
