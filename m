Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CB130149E;
	Thu,  6 Nov 2025 20:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762462445; cv=none; b=YOQz5mKGhGWHyCeSR+iFawNSGRo2DCV9tHY3oWRH8bgYwJavZ9DdnUjTQDI9jpmDo49cLbMXIVXaRQxBd3+FPRZXl+PVm+pLhBXtywOcc/eiSKlXUds8IuX8EEc72oVvMCyi4Ln+hvFpKklZGgvSdEhzdqO9vdNBv77g1YNYZKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762462445; c=relaxed/simple;
	bh=Vv3eueX5Yzwe8L22S5wqi1JNwoPSkSmIv6GaWGqcWO4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sxAxcqEqjHzUbbKrEncQ/pPpfyTPTMhhPK5m9qQDtiYVPLMGcLaQUcjL/IjEKVwW0BNrDeiJqiX4E/K4UKHy9tbehJN8EyugRSG7H9K9YYSyWEO60HK7yPvOsV4a7FT5Tv6oO9FHbbqENdNYTXMty7S9h3jCvZtOoP5K5GXZIpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xrs1F4QF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xrs1F4QF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336CCC4CEFB;
	Thu,  6 Nov 2025 20:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762462445;
	bh=Vv3eueX5Yzwe8L22S5wqi1JNwoPSkSmIv6GaWGqcWO4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Xrs1F4QFVdTPj/X4JAoddy1czp0pDIhdc0U/doAWQgWZ/ZfXHR4wLJuZ92iWsJZKk
	 /GcYzRbC0zT8Q5w2nt+D9C1GW3+NZyCCmC5OjDNasODHfgVRLamODsBdfUbyg4wdRB
	 6oEsNQSZB4+t3UFclfsSNZRAUe3FJ2t2zspvN+ewOzNdCl+b80QRcXv4SqnO82pfK/
	 D1MCMQYuVrqRL+fueealIWGdhnBBid8Cu9Kgvecz9lewuai2p5edkp1fhvguJtCBab
	 4J5DK74F3dCdMlLW6MW8XB5oseCLNT9K/To8RMpv/K+t/TcS1M3dW9+xD+eOxFHauh
	 GkkNBuoaJmLaw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3464E39EF96A;
	Thu,  6 Nov 2025 20:53:39 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fixes for v6.18-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251106203136.GB7015@quark>
References: <20251106203136.GB7015@quark>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251106203136.GB7015@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: 44e8241c51f762aafa50ed116da68fd6ecdcc954
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a1388fcb52fcad3e0b06e2cdd0ed757a82a5be30
Message-Id: <176246241786.354628.3357961680437143105.pr-tracker-bot@kernel.org>
Date: Thu, 06 Nov 2025 20:53:37 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Nathan Chancellor <nathan@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 6 Nov 2025 12:31:36 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a1388fcb52fcad3e0b06e2cdd0ed757a82a5be30

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
