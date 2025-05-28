Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23418634A;
	Wed, 28 May 2025 22:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748470531; cv=none; b=MC397P/1ffb2VNT0BK+HnSzrr507e0/bpN715KswnZe5HxkXDQvn4+JIYzwNBUI57+SnOy+QY4UJLr7/tMa1Cen22g8+naCkg9LvLhgJV8tEi94grVujiqZYoP0xUjX87LOfuRgLMaNB9OVIuzA7QgjXfyzmPgeNLDpEbOpGuuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748470531; c=relaxed/simple;
	bh=aDsCpElC2i/bSA+1zi2eQ/hnJoCVt0Alx+eab1BZLhs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CJUj/LGEVLdx/pqKR1/PSWSemWhnDORLEloMu0/p1WomjMMlN0HO/pEvvyME2TO56QaTZoTLeOjyCL4t3g37r74m5pYSvFQS/wMBN/CRLt4EmLyzpNL1Q6t555hWzUSqchpEuvomFGVAEfs3w1cXYMh15oTeGH/IpRvh/M95o0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SDPOUjyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDPOUjyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4227C4CEE3;
	Wed, 28 May 2025 22:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748470530;
	bh=aDsCpElC2i/bSA+1zi2eQ/hnJoCVt0Alx+eab1BZLhs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=SDPOUjywO+2A4gDrSWqsWzYgSbEiww29Sjxe/w/gFCe5sz1KodharjSA85ijVadSF
	 PIl46aMabl4iatREt09mqEb7hGM2qqqlo9avdPflA4JOsGdwrhLAs0RSRUkqtQLIgg
	 /sc5Hg1alihUYokoDJfG5C0WVJ8loEvTup8pDYBkm5zBBBBZU0mDSguG+b03H2b7LS
	 nVz3RFQ70s95D7pKNzIWiCPLrrkyugk5WUuzOO90WuRldBBQPFDOt2BG8k2mhjI1b5
	 1zHOBHvnPykDMfk0wD54O11IEBuhzQHrO61Apl4K6ECqn4iIJfrb0AlmNCX8g8gMx8
	 6v9Q9369kopKg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAFFD3822D1A;
	Wed, 28 May 2025 22:16:05 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <aDZ89Fs8Y20_fj2I@gondor.apana.org.au>
References: <aDZ89Fs8Y20_fj2I@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <aDZ89Fs8Y20_fj2I@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p2
X-PR-Tracked-Commit-Id: 0a84874c7e7dde5cdddc80a82093120e924a348b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 408aa67404405c8519ddee70bc0e6c55daa7c959
Message-Id: <174847056445.2608061.5885516562298346451.pr-tracker-bot@kernel.org>
Date: Wed, 28 May 2025 22:16:04 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 28 May 2025 11:03:16 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/408aa67404405c8519ddee70bc0e6c55daa7c959

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
