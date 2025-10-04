Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316B220296C;
	Sat,  4 Oct 2025 22:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759617070; cv=none; b=TOi2Ds5hz0bwTbxlZRcMbxXqEQv2gNLBMJDMS7TzX+LOiAGfks6krvUOAmVjgLGifmVU0Kt7C3Obk0qieFsEVuSlCWP7TAE8437cJg11FcvThpqC2TfutNIpPhbJKFqnZgdOgPyO0R8nxf+SfEuWKS28yEFu0oapl+MHO9w2YtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759617070; c=relaxed/simple;
	bh=j/igH2dDvneh3c6mhovPgeU3qARqDkOjr5X1IGu+9nA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=iGrS2eVbMwrYVxBjBygiEmDctrC2B3wYLXifYwIZ38y0+tz+bSGmGAsC+WQOw5HDufWfY89VK6TVw2iqaAzS0ZhKwN60ByN/zkSbyfjvxrR4olyyb9hapsnJoxZfddwiMgyS/rCO44ojEGGlUqLvCRXZZzNeBhiiZEkLK4JioqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TPZTe+zS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TPZTe+zS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1374DC4CEF1;
	Sat,  4 Oct 2025 22:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759617070;
	bh=j/igH2dDvneh3c6mhovPgeU3qARqDkOjr5X1IGu+9nA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=TPZTe+zS8TdSpoOGbzbK8GzJADr9LCVw5RDg1fkeN6AXbHwbxFH179x1T4qIuAVWp
	 K1eqdlk3OTtH3ZtJWY/aTDdHuQ7t97JplzCjF44mPrrzxJTbmOZRfRc90/WRcl17pm
	 ikJ4IOtICYttJAXJHqL4a80PQkfD6p/E84/wuypHydQLsqDfb94aKI/GtcVIifxEDm
	 BD9iCR+RhYeh11Q+zFZ+KyHXeuu/mWdp/LImR/zTkBOQa3hia/AuX550RRTgDCGoTb
	 z8IqeTaFDoDX671enJoPtlJhINbv+lh1J2n09AHaoKmf+2Gh8f8L/bHOHvuvATmjUH
	 emDB8EW3SK78w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EC0D839D0C1A;
	Sat,  4 Oct 2025 22:31:01 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Update for 6.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <aNuln6SQ_VIISMPi@gondor.apana.org.au>
References: <aNuln6SQ_VIISMPi@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aNuln6SQ_VIISMPi@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p1
X-PR-Tracked-Commit-Id: 166c83f7789ed02dc1f25bc7bed4a1beb25343aa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 908057d185a41560a55890afa69c9676fc63e55c
Message-Id: <175961706053.457981.12209986464406586247.pr-tracker-bot@kernel.org>
Date: Sat, 04 Oct 2025 22:31:00 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 30 Sep 2025 17:40:47 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/908057d185a41560a55890afa69c9676fc63e55c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
