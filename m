Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F9B13C3CD;
	Sun, 20 Apr 2025 19:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745179019; cv=none; b=k+RZQbHGFOrsfWSNMio/qbNqNaQfcVer4cyKNQfXh6frYreDqnFzI02XkddFvjka0tdXsgOUjmzHyxzIzhFeaGsxio3u0BiMHyU7SCbuZqzvNAyGh8tnWZylug7WkgEZQTpn/22E3mXoTolQ4LWwhcjU9xAO1FZT6wxjMFyCSfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745179019; c=relaxed/simple;
	bh=lmo+efipKD7P7WTcZCfEySlix+rDvcjgEr0L+hnC9E4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HdH8SD9nO9GnADR4BfIwm8oht7Enx/GmVSe3tGDzA1TiTWNRq+Z8tIzM/G8q0EbJYT+6CFm2BZgoH9z2J0DPSTAJT4krZbGPnZNDOzGjh6LT3zWWSUybgsIxi+GAvjB1qj+QWh5L3yu2rgEAmZ2QFrf8LR/kSnKS4UBLnbAnzHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mrz2J44A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mrz2J44A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA08C4CEE2;
	Sun, 20 Apr 2025 19:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745179019;
	bh=lmo+efipKD7P7WTcZCfEySlix+rDvcjgEr0L+hnC9E4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mrz2J44ASIX5ZV7hjArrCxW5gL1gxy++ocYi9SWPiMpypuiKkAqs4aunVh7xmoCPb
	 sHBDSNbYeMDRuYacE/foTPevFv1qC8v2Phn+bjqTuhN5+sGe2xzR6aYUbJDYou/PF/
	 svOJ1sdTfM4/CQrfLQS5qLyfA3DXB3SGYsPENpHvjQqJisplGz4tMLuYAYRf3/LelU
	 W9p9QfoBoNTxm7FKQ2Wr8IbIgddMHiGU5fLJXmZPR+0zmvY7c5Cjx0t/EZ4gDv9ys4
	 +ixL8feXKDde+x9zEUSXfcM6FsVcaJn/aID9g1PY5prRZps5UWMEmhn9KMmeVHmDPN
	 E545RaoZVlxpg==
Date: Sun, 20 Apr 2025 12:56:57 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Palmer <daniel@0x0f.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, Jason@zx2c4.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Palmer <daniel@thingy.jp>
Subject: Re: [PATCH] lib/crypto: blake2s: Disable self test if CONFIG_CRYPTO
 isn't enabled
Message-ID: <20250420195657.GA291714@sol.localdomain>
References: <20250418120216.2968994-1-daniel@0x0f.com>
 <20250418145945.GA1890@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418145945.GA1890@quark.localdomain>

On Fri, Apr 18, 2025 at 07:59:45AM -0700, Eric Biggers wrote:
> On Fri, Apr 18, 2025 at 09:02:16PM +0900, Daniel Palmer wrote:
> > From: Daniel Palmer <daniel@thingy.jp>
> > 
> > Currently CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is used to remove
> > the self test code. CONFIG_CRYPTO_MANAGER_DISABLE_TESTS depends on
> > CONFIG_CRYPTO so its impossible to disable the self test without
> > enabling CONFIG_CRYPTO.
> > 
> > If you don't want CONFIG_CRYPTO you probably don't want self tests
> > so remove the self tests in that case too.
> > 
> > Fixes: 66d7fb94e4ff ("crypto: blake2s - generic C library implementation and selftest")
> > 
> > Signed-off-by: Daniel Palmer <daniel@thingy.jp>
> > ---
> >  lib/crypto/blake2s.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> 
> This is okay as a quick fix, but really the lib/crypto/ tests should be
> refactored into KUnit tests that aren't dependent on CRYPTO.  FWIW, I recently
> fixed this for the CRC functions: lib/tests/crc_kunit.c.
> 

My series "[PATCH 0/9] Clean up the crypto testing options"
(https://lore.kernel.org/r/20250419161543.139344-1-ebiggers@kernel.org/) also
fixes this by replacing CRYPTO_MANAGER_DISABLE_TESTS with a non-negated option.
(But we should still disentangle the library tests from CRYPTO at some point.)

- Eric
