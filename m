Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC04246781;
	Sat, 22 Nov 2025 19:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763840029; cv=none; b=nAENOvCKcfJDJMlbugVbzlDRLQm19PJRD35Nz1rpl2JoDLCNE1S7n0r92+L4lYHtBKKCDCneh32kvj1IuBM4dXHoZGes7HaD/ADyv/vgbNGLKn4fSs9prq5S/ZURFYxZ7WbJCZF5M2XiJ2DGISv21VnZNjE7w6nOB69d59fviH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763840029; c=relaxed/simple;
	bh=54O9zCVJBJ00e5viX8B7D20s3kLkGuu+i8Dp11LY3HA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JkVM2p14iEg5nwQMIM4MwMFnz7EAknc+xkS39g5phVyq9ugW4a10hNuOOjAWU+0GsEKLerCarkEgh9KmdvbSL0CSlQFIZ41C4nfecYiK3Dxci1u+gJm9eGD3qrhQq54hIfbVVs7vgadrvDLP+cReOgsWMEleoWYnQ3ez+0CfQ+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KthHT2iP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KthHT2iP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3101C4CEF5;
	Sat, 22 Nov 2025 19:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763840029;
	bh=54O9zCVJBJ00e5viX8B7D20s3kLkGuu+i8Dp11LY3HA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KthHT2iPpu7CUe3k3R4U6as1q3A3VL9xZX6ZRrLEGwzrpua0i22Ns5pM+syFSwPlv
	 3XWc25P/CpcaBVg50owKZUzYIFryyqnpQ/JOA0gIdU3pXqeh3crgPrmue15Jmknqfo
	 TcBB8Po02UcxKGDj6o2ioJSC1Q0iTdhP1CYmK8gPoNZi+4kGrTi1Y0ow9HpiHagbtQ
	 I2gVpAz95GAKGVtoAfrHpwmswHJaRWAWBbHJAF6t8SYOJ8Dz4e2BYlAS6mYTUWn+XD
	 V0ghAle4PBNESRlVroF/3NMQRSnRkYKE8WdX4T8TSqrkAJrBHIZOIyj007imLwe1ul
	 DlwHv0+ufSjMQ==
Date: Sat, 22 Nov 2025 11:33:46 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH libcrypto v2 2/3] compiler: introduce at_least parameter
 decoration pseudo keyword
Message-ID: <20251122193346.GB5803@quark>
References: <20251120011022.1558674-1-Jason@zx2c4.com>
 <20251120011022.1558674-2-Jason@zx2c4.com>
 <20251122191912.GA5803@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122191912.GA5803@quark>

On Sat, Nov 22, 2025 at 11:19:12AM -0800, Eric Biggers wrote:
> On Thu, Nov 20, 2025 at 02:10:21AM +0100, Jason A. Donenfeld wrote:
> > Clang and recent gcc support warning if they are able to prove that the
> > user is passing to a function an array that is too short in size. For
> > example:
> 
> (Replying to this patch since there is no cover letter.  In the future,
> please include a cover letter when sending a multi-patch series.)
> 
> I've applied this series to
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next
> 
> In case it gets bikeshedded further, I merged it in on a separate
> branch, and I'll plan to send it in its own pull request.

Sorry, wrong version.  Fixed now; I replaced it with v3.

- Eric
