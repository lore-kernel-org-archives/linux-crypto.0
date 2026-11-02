Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793643136;
	b=ZrnGKuZD3ExCbRFOrPuDBKOD3z2bhHynxRvvwEdfqRo2nlOCCIo3Y+AQt48ylXcHezKf
	 VobTHAjFoEqOy0LUO8pYsXD2oRZy4t6ZEsxdq3NAU4hnyEUx8VfifIB4yyYGmVih4wHgB
	 dOL43SqIDm3jRjvZ2j9tdPQCIOVUaVEIA2l0tKZ0BGIf9ONgxkTv5w4tNYKq1kae7NJiM
	 egr6AfkbIr35CvVvpDQCIX6hEWLgNRFeEZbMnZzkn4LWgEua9l2r6f/DD0iuIy9qdO3qi
	 bZfAkFGxp6YIEIjo8mqft46iS9XpsSq/qK90NeiS1r2fZW6SaOgO1yruPIxs1hXPvxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793643136;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gAki4CP77SskVRyShDUmxie7oMO3N+9Lunra6xGDc5Q=;
	b=BqBLS7Y0K44rqSZimnbq4GEF2UsRvoL2dfg23phRIPdg+Yln2DhXKh++Ai7mwVxz5+GE
	 m0EmdleBk1TIML+lMPYXzlhPLJuRrrtZWOqI2aY4GT6fxawodP6lCEf4TUNzztkg1guiE
	 CJz6QwRSskXQfGG1egCnT3Yi3b56cycCGmei1Uq9+5NE8VAJRDSOi4IUv4bmmRgWf25Wp
	 45m6MN+FQMOByRqcOQFCxE/ZZZbcvNjGrhgR7kRwsSjH2bogK+tVmvGjwg7ceWmjt/fp8
	 yQTcl5KKCTta94/117jrZjzfONJDVMZgKwilVTgPLcTCa6YC3ihd4mtcR/GpnTiJtug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UUBNS1ko;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EA3606A326
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UUBNS1ko
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48C01F00A16;
	Mon,  2 Nov 2026 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793643136;
	bh=gAki4CP77SskVRyShDUmxie7oMO3N+9Lunra6xGDc5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UUBNS1ko7KR3d+JOGrhirmxaLzyM2G4oI59vO846s3LWpYTIIHcAuNuF837pZTbRn
	 8BocndNshqddu+NqoGkkUzVRiR1hCimUesRDdeeQArCZChKFdhBKQegPws30r+AXNG
	 vosLPAR/wvkmQPtjz/vkZULbJBPqbhH6oaA287YZOrb5xNzirHsbG3x75EStPrtaHb
	 a0oJAx6gCrpuWH0zMes0aYyWlN1nys70tOWZ1V94tjB053HJxwvNHMZnLItEAIMgtg
	 Wgt8OAQV6STW9Agn7NPnqUvUOigwEvn1VUZRjSqPhYBmEuFBrsGUy/ctJPAtjCH0YZ
	 tNJv2pDnmU2Wg==
Date: Mon, 2 Nov 2026 10:12:04 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Maholi Tumanggor <maholitumanggor@gmail.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
Subject: Re: [PATCH v2] lib/crypto/mpi: Fix heap OOB write in mpi_powm() when
 res aliases input
Message-ID: <20261102181204.GB1935@sol>
References: <20261102064225.2271-1-maholitumanggor@gmail.com>
 <20261102092550.2633-1-maholitumanggor@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102092550.2633-1-maholitumanggor@gmail.com>

On Mon, Nov 02, 2026 at 09:25:50AM +0000, Maholi Tumanggor wrote:
> When mpi_powm() is called with res->alloced < size and res->d aliases
> base->d or exp->d, assign_rp is set to 1 and a new buffer is allocated
> for rp. However the final write-back block unconditionally writes the
> result into res->d (the original undersized buffer) instead of rp,
> causing a heap out-of-bounds write and a subsequent use-after-free when
> mpi_assign_limb_space() frees and re-assigns the corrupted buffer.
> 
> The previous fix (v1) introduced a new issue: inside the exponentiation
> loop rp and xp are swapped after each squaring/multiplication step, so
> after the loop rp may point to xp_marker instead of the originally
> allocated buffer. Fix by saving the allocation pointer in rp_alloc at
> the time of allocation, then using rp_alloc as the write-back destination
> so mpi_assign_limb_space() always receives the correct buffer regardless
> of how many swaps occurred in the loop.
> 
> Confirmed via SLUB debug (slub_debug=FZPU) on kernel 6.8.0-147-generic
> (Ubuntu 24.04): two BUG reports (Right Redzone overwritten and Freepointer
> corrupt) are triggered by mpi_powm(base, base, exp, mod) with base->alloced
> smaller than required, and are absent after this fix.
> 
> Signed-off-by: Maholi Tumanggor <maholitumanggor@gmail.com>

Is this issue actually reachable from any existing kernel code, such as
RSA or DH?  The commit message needs to mention this.  If it's
reachable, explain how to reach it.

If this fixes a bug, there also needs to be a Fixes tag.  Fixing a bug
in a previous, unapplied version of this same patch doesn't count.

And finally, please see the Sashiko review, which had a finding.

- Eric
