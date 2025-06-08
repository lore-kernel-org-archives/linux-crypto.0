Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0DB2A1BA;
	Sun,  8 Jun 2025 23:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426483; cv=none; b=SamdxFoKHE5wiyvzdOJRMaOJ7WgsxOIMbUxp3SfVNdEfjXKyFz9ijZmd9apjQGPm/ZXMHs3ECcnWHXGYXos8I4yf2/xD1Lzcr9C2JO5wRPEaKSBa9Wo9VRPWmR2FKaWOVtCZtCLDE+ijNFjCaFipMgBROrtAJKKw1f3mwd6LlWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426483; c=relaxed/simple;
	bh=KT/w6FBT4N6PSgfhF3FSGdgyAUAhCEGDFvPvlVX2I2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDMIdKpOLYcv9L/IXNshCKQr+g6/1ruV1ngYB3WfnVee7gbRWr0ilfQR5s5TJFNH2jGaacV+mdNFFHmeGtv5OZ+Wk1XvRYLAWxGhjb4L5JdtXOqrOcXT0w/JVUhWiD0yMCvXuxa2E1b28uwPFifNadynz2pl83uZIyB4ZXi4psQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mj/thd2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mj/thd2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038EAC4CEEE;
	Sun,  8 Jun 2025 23:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749426483;
	bh=KT/w6FBT4N6PSgfhF3FSGdgyAUAhCEGDFvPvlVX2I2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mj/thd2Z9uYe8ddf/YWYAFUEWePinPdYjbTu3zsxtF0EGbMbUwdTFcBVCvLyqWqkL
	 s8TD+FN4opFmHQ7GjeY4VZu8ZJ7KUhFXrxGEq03XPBJ9D2xl90iH0CE+OUFMzFVz4n
	 iN/J0T055wmB9CEPVyecBVuULJ03Q1ocQBZa0ZCSS1yKTgQzuF38Q3ERr4lcd2AJuq
	 tq2jNVQr6Rerr0MgIhheSVV4hcs59a7DV18WyrUxNMhTtQuU8J3rHi1P0dvehdgGnM
	 BypM9OZDAB/2ny7ZcnodBHqDSsoWn7ly8eQOXcNF5B9D/4DwjG5+kebOI3AFPUDl6O
	 N/rO7KWDT/9+A==
Date: Sun, 8 Jun 2025 16:47:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] lib/crc32: remove unused combination support
Message-ID: <20250608234741.GF1259@sol>
References: <20250607032228.27868-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250607032228.27868-1-ebiggers@kernel.org>

On Fri, Jun 06, 2025 at 08:22:28PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Remove crc32_le_combine() and crc32_le_shift(), since they are no longer
> used.
> 
> Although combination is an interesting thing that can be done with CRCs,
> it turned out that none of the users of it in the kernel were even close
> to being worthwhile.  All were much better off simply chaining the CRCs
> or processing zeroes.
> 
> Let's remove the CRC32 combination code for now.  It can come back
> (potentially optimized with carryless multiplication instructions) if
> there is ever a case where it would actually be worthwhile.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  include/linux/crc32.h | 25 ----------------
>  lib/crc32.c           | 67 -------------------------------------------
>  lib/tests/crc_kunit.c | 39 +------------------------
>  3 files changed, 1 insertion(+), 130 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
