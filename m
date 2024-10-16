Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043901D3573
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 21:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729115531; cv=none; b=XueZuyO6TXOOh0Q3Bs9O51UK0qV1cubQ7x32NcLhwP9ujiyAnREPvbLF7ai5NcMCI2yQed5YLJYQ/52L0JJzQQ7+rYQ3PJj2Q4MQLeSiQy42XB23ELbf/f+oggcKOhFQRlTRxadG2jUbe5P/HUfxLUiCXyk4huCpZ7WW0uF+7N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729115531; c=relaxed/simple;
	bh=tyxcytVdH1qmxTteySfqjmYd+Y6f4oby9bxoU85+JXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ep72pFJpIvlFWeMy7W/zJYZd2J2a34UCi8YJRWv6qZIUYcKcayUC1BB5umxSC8eWVqVWFaJby5Fz5jsyv6iE4049waLqC9y3IhtZdYVihEhXHNsDjAlOF4EhnZRq9EP1VXId5U2ACD9+77Nomwn7b0S9bw6RwWzZL4VJWE8vTdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bEaYQKDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bEaYQKDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDDDC4CED2;
	Wed, 16 Oct 2024 21:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729115530;
	bh=tyxcytVdH1qmxTteySfqjmYd+Y6f4oby9bxoU85+JXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bEaYQKDdBB6x9dC/UjVblHkQ7bDNb9tJehkAoQLs90sPnT6PxKVs3mDTduTE3Kuf9
	 5H/FylAEA8qY6TjeLrpVsOisHeCOK5laTyz07/r+WzNjx0oADRpg2nCb2Ui/n5JaAt
	 cxHu4t2ory34eKzRwMTelOxHlAPvsbMcHq1nqALVimTr50tAZ6zcwWTA7ZBnR8vzS9
	 A++jrGrVhNBueUHcMG0MvwFxDK5YLwc4Ach1pTUSAy2mKhhErfQWvZW4uexEYMfxXs
	 jLgFBh7kEXNnFlWe5uHqPhwF5GewCMheeMJ6xv6R3VqmINz3nwg/GeKTU886bi1dUb
	 95gMtlj88e1yQ==
Date: Wed, 16 Oct 2024 14:52:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2 0/2] crypto: Enable fuzz testing for arch code
Message-ID: <20241016215208.GA1742@sol.localdomain>
References: <20241016185722.400643-4-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016185722.400643-4-ardb+git@google.com>

On Wed, Oct 16, 2024 at 08:57:23PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Follow-up to [0].
> 
> crc32-generic and crc32c-generic are built around the architecture
> library code for CRC-32, and the lack of distinct drivers for this arch
> code means they are lacking test coverage.
> 
> Fix this by exposing the arch library code as a separate driver (with a
> higher priority) if it is different from the generic C code. Update the
> crc32-generic drivers to always use the generic C code.
> 
> Changes since [0]:
> - make generic drivers truly generic, and expose the arch code as a
>   separate driver
> 
> [0] https://lore.kernel.org/all/20241015141514.3000757-4-ardb+git@google.com/T/#u
> 
> Ard Biesheuvel (2):
>   crypto/crc32: Provide crc32-arch driver for accelerated library code
>   crypto/crc32c: Provide crc32c-arch driver for accelerated library code
> 
>  crypto/Makefile         |  2 +
>  crypto/crc32_generic.c  | 94 +++++++++++++++-----
>  crypto/crc32c_generic.c | 94 +++++++++++++++-----
>  lib/crc32.c             |  4 +
>  4 files changed, 148 insertions(+), 46 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
