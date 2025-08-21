Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CE5217F24;
	Thu, 21 Aug 2025 03:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755748756; cv=none; b=PZG5GQ58xVa7SPechQXe0RKEHoe7pfW6pXFehZZQ8Bvsm03TszuczG+MIo+/qhTuNZMWxoM+o7aGEWJ59tWobVIAKuKeQTKSOdAawYfhtNUgmEFMfLwPr8v6WdBsGYEl2/RMx6YMVoDmG4TkGVld+Td//dZ2z42z8O0pdNwAgY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755748756; c=relaxed/simple;
	bh=wlPvbixKsFivuJ/uCAGwERK9ERg3cDoDU73Rw68oQZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=frLLG25FPSloqB0wEQdwVRqbftGvHANPG8YnbISNrklDi/FTy74+lSzo20BEMiFXZtpYM7jbIbgJy6qGuVgTV67py3pzPAFqAAxkA0Z/EZfg6u4hXZSF/bIW3i0E7rZApvFXAsLopnvU6Y+iYpBcwMFsWbKtdP5LmznHt1orweI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMwcQWRM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMwcQWRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F8EC4CEF4;
	Thu, 21 Aug 2025 03:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755748756;
	bh=wlPvbixKsFivuJ/uCAGwERK9ERg3cDoDU73Rw68oQZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vMwcQWRMwZTBZxKoKPwiy8DIy8hOQNxeZ2k2NxO1AG86P1Izv9gAzrHwhl8dcZ9X3
	 sMYxrShEmUIpA4u+rUuhQpbeMN8vmse3mSoyFzwA2iymU2nAeWWTFPVHBMM7XMWCPx
	 akJFOAq6Mi6dt9PDtSo19qm09sRvt6iQeBr0A3k1dqtpn7EmRygmeoIW6/2hxLzzUN
	 4l2heOzrxJzrodyTdy4Fi3atNFi2OaKtR12KD0oaIE3YTf6KFjhTRtIquPdz0mqphG
	 A7IA5bKphrVvN/sGVds1Ij1lI+oSqPCzg2Hew58Aw7ADkyZFvIjL+Bh+tT2u68KJld
	 VWp1RaM1ivriQ==
Date: Wed, 20 Aug 2025 23:59:13 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Rakuram Eswaran <rakuram.e96@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	ardb@kernel.org, corbet@lwn.net, skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] Documentation/staging: Fix typo and incorrect citation
 in crc32.rst
Message-ID: <20250821035913.GG185832@quark>
References: <20250820162615.6942-1-rakuram.e96@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820162615.6942-1-rakuram.e96@gmail.com>

On Wed, Aug 20, 2025 at 09:56:13PM +0530, Rakuram Eswaran wrote:
> In Documentation/staging/crc32.rst, below errors have been corrected:
> 
> 1. Line 37: from "to being" to "to bring"
> 
> 2. Line 119:  Incorrect citation date:
>    It must be August 1988 instead of August 1998
> 
> Signed-off-by: Rakuram Eswaran <rakuram.e96@gmail.com>
> ---
>  Documentation/staging/crc32.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Sure, why not.  Applied to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

Note that this file is somewhat dated and is due for a rewrite.  It
doesn't describe how most of the optimized CRC code actually works these
days, using carryless multiplication or dedicated instructions.

- Eric
