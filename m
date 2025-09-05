Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4922FB097;
	Fri,  5 Sep 2025 17:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757091976; cv=none; b=mN0CHxWCfrUmbrM3c8PxfmlM/wZo+LxhQhrOrmgL7OBQdOjAgQ/e/u66WXQ31gwLolIL9UBHbfMfcxkYqZ5bnnSiNFrEeelA3OwDQdRl+a0XE8hNC52YsDkj7Wgkf4IF6LvWandsPOskcPuCnG5JUFztPnAN/5aOjwzPcIemb9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757091976; c=relaxed/simple;
	bh=LPcsLD/N8LOoBFBUKHVatP2lR1A4EFh3Ug8KaV6BhZc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=C9es8gJ1quiz/hyGSu8+vSgWv+ygEIfycn4p0rrR3DzkTFWzeRKgK3RMV1YuVeATnFQ/vXmWAoMPCf6qqbdtEy3VnKsnnoRH22aXCUVWBNUDOzMLTvI7Bsgj063e2OvWqcQDNtjBSJzUBALYW61yCmcEXTWXk12HFeVPCwWi0c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0wKsBZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0wKsBZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD08DC4CEF1;
	Fri,  5 Sep 2025 17:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757091976;
	bh=LPcsLD/N8LOoBFBUKHVatP2lR1A4EFh3Ug8KaV6BhZc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=J0wKsBZdWrrsVkKmhujNGaLiKUFjW82k6S8R/Af9h8VrYFGiSCJsroKKwcNa3uxQ0
	 BbboC4rnyezmpdREIp4xN+zkBOiqTGcKPQtoINezsEBHapvPgUbJey56+sBnh7+u5D
	 H8BlHAXKOdhNAIPvJNVu/OxWrIK78DKAIbaN89ihtFZEc8WAypl0HLacuTGFETnI/O
	 +ITpK32XVSJKbhZU4ffWVH82/6+NB5a+mvtCSFTQJH+gCtOD11SLbaiBj3ssYB+E72
	 6yNBRJ445Rqhf08wt3c8HMvoLniGJIWiXziARZMzQIhOtXPo4FLVa2pOOOrdvyIFMe
	 u9GLWM6zXnw3A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 715E5383BF69;
	Fri,  5 Sep 2025 17:06:22 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fixes for v6.17-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250905034148.GA26307@sol>
References: <20250905034148.GA26307@sol>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250905034148.GA26307@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus
X-PR-Tracked-Commit-Id: cdb03b6d1896c2d23f9c47dc779edba0a9241115
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 01c93aa01c75e7a43f7f53229bcbecffac75eb84
Message-Id: <175709198091.2623294.1074796665519896961.pr-tracker-bot@kernel.org>
Date: Fri, 05 Sep 2025 17:06:20 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 4 Sep 2025 20:41:48 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/01c93aa01c75e7a43f7f53229bcbecffac75eb84

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
