Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FCD1922C0;
	Sun,  8 Jun 2025 23:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426101; cv=none; b=LVZRmMMTMC6zg3tx9sMx+z83YJpBiSSsDZ4PR6gJ+g9pzKlFA+wGRPDV4/Cmh15FTpVR/d5or4/hZbB1vKGvnGATJ6/9kNh+PzuGVtM/i8J1LilkevmkDozSyndSyarbM0vQvGUftkzkiW+kalOshckanzmhevdysC65Ynt5+OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426101; c=relaxed/simple;
	bh=hB8mMmGaOPMH+CqVLyd+XiZfyQc6/lX0p3F7iqBUYQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I36qAdkdDlm9e/uePvN+YWl4lW441m70ITYP5hdflGeGIFU1D2LV4riiTIZu34HTMkWetQHgtcNGPMNZpTExpF2BIp1oe/DYv7qSrqHIhZkyfW0l6YJ6Yn4pz8FA/AWrYV6IrDoho8L1OCjppIf7wNHqdbsGX5uiQ0zS5UVBvpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKYAgnjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKYAgnjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1134C4CEEE;
	Sun,  8 Jun 2025 23:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749426100;
	bh=hB8mMmGaOPMH+CqVLyd+XiZfyQc6/lX0p3F7iqBUYQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SKYAgnjd0TwOBwE5XLFB5r9JBEtjLQXblUP23jWg8XDiGFW0BeT5LendTUsRtp7vH
	 sv7o/7h0WAfeUfAwU8DA1+vhYQ2r5E2AjjOnkM/vZuka9gVtrqXgB/mS0Zp76HBa12
	 m7MbUIcbMloyPSQnEvsalHOTpk9w8TabsX7VpWVW4RlGgU5uoOciyaCTfaQzeEpGWO
	 ivikx2VoZk6te8d8TKjHvJYXyVaD8wcqZoACVHKgnK6/nLefv7OtxoMUzSJarY9OZh
	 3tNAgIFs0u890OSM1bfIHoXTv1uGWOtiAmHHFnBU1tkGm8NewX2cbPC5dMdRAJPlcp
	 z2w1fh2fUVPGw==
Date: Sun, 8 Jun 2025 16:41:19 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH] crypto: inside-secure - remove crc32 support
Message-ID: <20250608234119.GC1259@sol>
References: <20250531204244.24648-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250531204244.24648-1-ebiggers@kernel.org>

On Sat, May 31, 2025 at 01:42:44PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The crc32 acceleration in the inside-secure driver is accessible only as
> an asynchronous hash.  However, there seems to be no corresponding user
> of crc32 in the kernel that supports asynchronous hashes.  Therefore,
> this code seems to be unused.
> 
> The patch that added this code provided no justification for its
> inclusion.  All devicetree bindings for this accelerator are for arm64;
> arm64 CPUs often have CRC or PMULL instructions, which already
> accelerate crc32 very well.  And these actually work with the crc32
> users in the kernel, unlike this driver which doesn't.
> 
> Remove this unnecessary code.
> 
> Cc: Antoine Tenart <atenart@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> I'm planning to take this patch via the crc tree.
> 
>  drivers/crypto/inside-secure/safexcel.c      |  1 -
>  drivers/crypto/inside-secure/safexcel.h      |  1 -
>  drivers/crypto/inside-secure/safexcel_hash.c | 92 +-------------------
>  3 files changed, 2 insertions(+), 92 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
