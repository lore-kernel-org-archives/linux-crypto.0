Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB968BFF;
	Sun,  8 Jun 2025 23:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426073; cv=none; b=iK22qoX+HhIyWg6FyogxNpdiU6FvXVByl8fSYvhiq9NqC42iqIpvXmVM7p2GL/8hiUaqDxuncUIpGEidiRA5e0aCeZa0RitA6bnYSxQkuOjz5twxvXjUEL9DMhDslH/fS9J8lEsYd+4yY+QD+PaW4JBpxG5nB0ryBhskL6Xr5gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426073; c=relaxed/simple;
	bh=I6jrhA3GfAGx6N3X6KPCw1zsVQ7tu7WlT+3G6vHgfEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XUbpUrzfoPXu4xI86Gu7Ic+baZhWGqNCnZ1MpJBV3dnSc/CxqCvJVRUoCzkLCIsAxWBj0b2bHCtHhb5ESlwVo/zKrgaNO8ilziTFSCdhbWUEwGp68ucZWPiI5LeS9M1Y1PAYA/sNNoAVfYipY8vhrslp94oDD/Hf1AR33sFBoCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJz62pKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJz62pKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A158AC4CEEE;
	Sun,  8 Jun 2025 23:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749426072;
	bh=I6jrhA3GfAGx6N3X6KPCw1zsVQ7tu7WlT+3G6vHgfEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BJz62pKJBdv8S8xO0Fy5dGb2X27fLcbHs86VHT2jOKxU5UD88hdBErSDbhcCoFSnK
	 0Iz6iA3IGioLmGKCsheLOkkYrlzswEfpWT3jK1TEkrwVSGZdYieiPUjp3DSHP1kQ73
	 jTsC3b57NtBDkM7n9+9EoESeJ7U7LcX3boH9mEB24VsuJdELORPjNy7AkronjCcEcZ
	 p5NtFou9zBfDnXBoNLthtqS+aoWc7dZap02b9NV8mPEoQzwjbIRrtC+nP0g5VKsl0L
	 M1RM+byekfhkKdhlm3Bh2AJRewISlebpXT0vdI1E3Qyrlc4VSxVKOsAQr/UOqu+uwJ
	 QSXIrJi5JR+Hg==
Date: Sun, 8 Jun 2025 16:40:51 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: testmgr - remove crc32c context format test
Message-ID: <20250608234051.GB1259@sol>
References: <20250531205937.63008-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250531205937.63008-1-ebiggers@kernel.org>

On Sat, May 31, 2025 at 01:59:37PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This is no longer needed now that the code that used to directly access
> the descriptor context of "crc32c" (libcrc32c and ext4) now just calls
> crc32c().  Keep just the generic hash test.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> I'm planning to take this via the crc tree.
> 
>  crypto/testmgr.c | 55 +-----------------------------------------------
>  1 file changed, 1 insertion(+), 54 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
