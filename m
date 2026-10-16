Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C6234D382;
	Fri, 16 Oct 2026 07:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135767; cv=none; b=P3QTgox2aGKu+rltQLwbJJwlWnIORkNvOe9Sda9C4+ReScEieE4jUFZJ2NcE8xFk4T/QPworWDRtVZMNMZ+NoGFhWvDXBLHWQrd11E/adhO1DWOwSUAKQS1BOY8C5wLm+oH0FUUIpmqZEtg/CnwMMiWVsns7MqoNc0Zi6hCnMh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135767; c=relaxed/simple;
	bh=0Kz+uz79rxdLTxcsBO1572arfN2rTyeOHFfwrchcLxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GeLQLVErRQT8/p5jy7Uf7vBPfXB8wRRSWYhNbTd3cwQzHA7N/vj6glwH9t7YvP7dTELf/YBdD9SA3AR11ouzRix2SxMT3BSy/NeMz9cFNVkVOivBOxZMMaM61YNjusjKjxvJ2JlidDCluSKOpKaGV9w18RpvqvEAAjZ+5o0mWeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UJ1dbdxX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UJ1dbdxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A901F000C5;
	Fri, 16 Oct 2026 07:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792135765;
	bh=Rq6pRCQaGsckMnSn2g00vwitNSiwavPxWyGYcycfMW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UJ1dbdxXC3sT4JBxcaHCvwbtN+BiHIPej4dRaeok9Yu9DfvcR7Gv4zQUQ1fg+sYlR
	 eXxVu+xjd6ewUyNW++cARbnFFPYLdH7FgcUnaiZS49+sQZ8JDWCHRDFiv+A5EbKecQ
	 VyLYgGU0KsRH/6PW3ylhO4m+Bzwre2mik58tj02OqSSz2c4FENt4tPJVSo1PcMxiet
	 nWuaJGMInl48NE9zxP7cLKHw5ve6FBSOW4h3amavD4b+SdR4KL5ZmZmaeyw4uvfaGf
	 6+7nXdpBpgQ0ZFlwyQQEuW3lJ8Dihm2nqmTr/rFZ1tY42yBJQ+g1XpXrEk2OdXeWa6
	 Mw7o9yBm4u+JA==
Date: Fri, 16 Oct 2026 00:29:24 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: ardb@kernel.org, herbert@gondor.apana.org.au, Jason@zx2c4.com,
	skhan@linuxfoundation.org, me@brighamcampbell.com,
	jkoolstra@xs4all.nl, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] lib/crypto: md5: remove unused header
Message-ID: <20261016072924.GC3049@sol>
References: <20261016023558.8797-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016023558.8797-1-raizudeen.kerneldev@gmail.com>

On Fri, Oct 16, 2026 at 08:05:57AM +0530, Mohamad Raizudeen wrote:
> The `<linux/unaligned.h>` header is included but never actually used.
> The code handles memory accesses using memcpy() instead of the unaligned
> helpers.
> 
> Remove this unused header to avoid false dependencies.
> 
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
> Changes in v3:
> - Update the commit message to accurately describe memory accesses.

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
