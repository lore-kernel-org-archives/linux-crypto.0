Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65411E2611
	for <linux-crypto@vger.kernel.org>; Thu, 20 Mar 2025 07:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742457113; cv=none; b=ImN5W/IV6AEazQ+q/Id044ZnKcN3DvFFqG2FMJ1W7ZwBwsKXeO0Cxh9mu3eDBu/btbjkaNX6f5zHs8J2nvCj5nM8xl+1uRQ3HShs0d3Wb17oUduN88sPJ+vNyiTvbplcFZ53YVjnYJCF+oEfMjz6TZdlmnNHfIJtS6tBjJrnk9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742457113; c=relaxed/simple;
	bh=9jCNV3AeFUBIDemlzi0f299DFlSTTmjNjUvi4tsDhF4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FV7AnL+N2jZTJKptwDHOtihIOKRF9tOtErLrWrb174tpFDAeUyrWybgMPw2+hOADo38otNWtK4FkDDW9K+L5vwQuKnksaA+Q1Ou0LOnCKyo/09Y13+dBXvRDbpGnzBy/dEoicsFTWaExQcLg8HupltikB85dP/e3dgodIWzGThg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wff7GKQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wff7GKQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234A1C4CEDD
	for <linux-crypto@vger.kernel.org>; Thu, 20 Mar 2025 07:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742457113;
	bh=9jCNV3AeFUBIDemlzi0f299DFlSTTmjNjUvi4tsDhF4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Wff7GKQ8+kb5snJyUQNt10WJfH/lExaHZwjCfq1Qw+Xn28cemvl11fcUQ+/glvTPO
	 pN/n/ZEwielMwj0RbTZD42cR6+HYK1kNvkhXPosFqWAUsUnF3lP8+qBwtv+b4vg/7w
	 MTN8tUxESVa8EEzQkCJGAKUfveD17Lwci7Qqa0h2ex0kSki/e4GSvz1vumLwVy5F28
	 e4KKcHbVXe5k9lFWQfy8aK/hHugrNe8UTVu7KYApTo+KbQI/EU3hc1d5b9o9hJZrbG
	 muxEXg1DEI+3j8fGFLYyolEJPGVYF6pIjEiD0TF9KGnzY8KjkCsf50o2pCoFSW/OdQ
	 Z05G1J38kHSvA==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5495c1e1b63so677010e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 20 Mar 2025 00:51:53 -0700 (PDT)
X-Gm-Message-State: AOJu0YyhQHdCtT8X9/+jviNqKcZYobZEcvjhZapwH/psSrZJZSHZ6ABj
	NDa3uqUbfX4cq0fCVYovUYxMGf5y0iRMNbFvy81QkJO1kT8f1xl8eS7afu9E9WH6BcRqBVLMaoR
	DHR3YvYpLJvBkS9n2o4z/M3l7x90=
X-Google-Smtp-Source: AGHT+IHPbrq1o4lgNig1AkGzUuiaWj6ZQl6VPBLHq2SyYFVry4c05zwGISfmBQkqqdY78VBuYJnVvg1pzS+RLr2u8Ps=
X-Received: by 2002:a05:6512:130c:b0:549:903a:1c2 with SMTP id
 2adb3069b0e04-54acb22429fmr1950418e87.49.1742457111499; Thu, 20 Mar 2025
 00:51:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1742364215.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742364215.git.herbert@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 20 Mar 2025 08:51:40 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGAokDnf_spFU85qCh+quU4eewgWwCO6-UpCWDdf5Q0Og@mail.gmail.com>
X-Gm-Features: AQ5f1Jqm9KR6ZZPit6KXt6NaFhLUzU_9XBIAPprPzhpd3GnkW21QNLtu8xAOdfU
Message-ID: <CAMj1kXGAokDnf_spFU85qCh+quU4eewgWwCO6-UpCWDdf5Q0Og@mail.gmail.com>
Subject: Re: [PATCH 0/3] crypto: Add SG support to deflate
To: Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Mar 2025 at 07:05, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This patch-series adds SG support to deflate so that IPsec can
> avoid linearising the data.
>
> Herbert Xu (3):
>   crypto: acomp - Move scomp stream allocation code into acomp
>   crypto: acomp - Add acomp_walk
>   crypto: deflate - Convert to acomp
>

IIRC Eric had some feedback at the time regarding the exact behavior
of the zlib API, and I notice that the code no longer deals with
Z_SYNC_FLUSH at all, which I did handle in my version of patch #3.

Do your tests have coverage for all the conditional cases there?
