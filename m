Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAA71DDD7
	for <linux-crypto@vger.kernel.org>; Wed, 14 Feb 2024 22:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707951400; cv=none; b=GxQWamdenz6AmZOOlsePRTyL0MO9uXiqxh+X62Q/KrpebCwEyKkz8DR7vN9bDsnUytTb74Q2+V7xVeCfroNfoX5UVa34z/Mp9oS56NgBaW/rFOe4CGZhG2Ny+iybVWTFtuhHqrg9VAU+0wkd9g5axfWz0CAfyFYw7hxCOtXR4cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707951400; c=relaxed/simple;
	bh=dT3umuOkpXbN4uVvQqNXMbQjeiYWLCoVYkutJvXlNt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aOSpEN/sTpZ+9ayYW2KvwUgSAu9XJ1CKv5+Jnbdm/fcsisgqBc58z/CSAKaoW2wrsOTpSTj54WaerF76xlnaZwBwO2DzoRsrYYIzGxx9nNCgxubG1mos7uezi6+aIzMpsJ3OnvhaQbXvmL2sLe4AyFYWEEwRM/bgVIBvJy9JPrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DAwfMBdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DAwfMBdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77AAC433F1;
	Wed, 14 Feb 2024 22:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707951399;
	bh=dT3umuOkpXbN4uVvQqNXMbQjeiYWLCoVYkutJvXlNt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DAwfMBdw90asazKyxUJ5Vr8F1katfbYJwjbpnrf0+poankbtcbuerzGAwswSWU9L/
	 5IQ4jTk+Ctpml5QvXMBiiURwk2nONc3EvCTWfLHl3WErG+bMKbfe1y6RRBye81yTyj
	 yStB5WXwO17mixrgfn/nHyEQ7cWvsppboh6e8WtXkPvQbvUDl2XYlbpcRzSLdQmhBc
	 m/K/v0oOSTEvGVR+deqRPsI52kb3OBrzFjz+QFsQiy7pEWirExMWl6pYnIdTTykcyT
	 P0N/toc1e3/lS3BtlPB3avjTnQdIKbetvDDF6gBFPb4mqKhcv9cFxAVs6OqyzjXhVH
	 pyBCANg0JnNsQ==
Date: Wed, 14 Feb 2024 14:56:38 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 06/15] crypto: algif_skcipher - Disallow nonincremental
 algorithms
Message-ID: <20240214225638.GB1638@sol.localdomain>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
 <a22dc748fdd6b67efb5356fd7855610170da30d9.1707815065.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a22dc748fdd6b67efb5356fd7855610170da30d9.1707815065.git.herbert@gondor.apana.org.au>

On Tue, Dec 05, 2023 at 02:13:26PM +0800, Herbert Xu wrote:
> As algif_skcipher does not support nonincremental algorithms, check
> for them and return ENOSYS

Shouldn't they still be supported if the data is being read/written all at once?

Also, ENOSYS isn't really an appropriate error code.  ENOSYS normally means that
the system call isn't supported at all.  Maybe use EOPNOTSUPP?

- Eric
