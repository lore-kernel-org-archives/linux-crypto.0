Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DEC3939BC;
	Mon, 30 Mar 2026 21:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774904543; cv=none; b=JY2nEOt3eXcIXT1I4FHn2RXZCOOihMVu8CGsC2WcxFN806AiXaTO029VtbNRmWVWNZ/Nm8qcnxmm37D2nVZ3Bn4v/9tBpjsi31dPvTQrOhE54k3bhJY/ZV/MnSJpm8S3Bv6G2HkhQfDQYlCDsWsAIR1HYYIN+sHWbHXpWBv9iTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774904543; c=relaxed/simple;
	bh=PCgwVl5MtqbTZ8yXjzSvPBHHkATmETn2i773a/x4nP4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=NpJOfyhUCr+CsTHA+DLS2vi3mVYdKfo5Kj38VBAEx3xHdlaC4+1vlyS80V19gqskGnpDxcd2v6PhU0BnnFwPxk6KHccQThkrA0EWcNSTrabAMaANdtSphbwEGHWX2jJM1ZmRoKVXlBojXPhTjHVKn3xjzaqHYc+D1HMSy9y3eqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fxPdICtm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fxPdICtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B33EC4CEF7;
	Mon, 30 Mar 2026 21:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774904543;
	bh=PCgwVl5MtqbTZ8yXjzSvPBHHkATmETn2i773a/x4nP4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=fxPdICtmQOh4c40FRiBfcvLrZJA7FxGaeR/SIfSZ5IbDCLChe8HxSfCyUyyTjJVG6
	 YH9iLusRCuTjbY50P8dRPzcMqMpLPKQJAn/otJ315mAPf4Ppr3sJsfPCjfSHdIssjE
	 G4RddZdk0BHHWhf3jDeny6ODI/6jG8GwgdXqToaAqM1EUasCwE/+jj2Yp0dASBEjGU
	 Zzz3vRVp5S5gMzcDX9OxU7V5HNTMK4mrtCWLIZPH3oBGN7wxzdKPsJczKoZKgXg5fD
	 k2P8i98S6L0uEPMi3xVCQTF63Z9Ar/IY78J2G6gFaIFZTK4TV87r4sGRLLh454V6Vy
	 i8jTzBiRGACdQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D0FD392FF83;
	Mon, 30 Mar 2026 21:02:08 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fix for v7.0-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260330194508.GD4303@sol>
References: <20260330194508.GD4303@sol>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260330194508.GD4303@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: e5046823f8fa3677341b541a25af2fcb99a5b1e0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d0c3bcd5b8976159d835a897254048e078f447e6
Message-Id: <177490452701.1933951.3943505546071372769.pr-tracker-bot@kernel.org>
Date: Mon, 30 Mar 2026 21:02:07 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Herbert Xu <herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 30 Mar 2026 12:45:08 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d0c3bcd5b8976159d835a897254048e078f447e6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
