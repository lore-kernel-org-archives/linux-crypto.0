Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E12ED0
	for <linux-crypto@vger.kernel.org>; Fri, 10 Nov 2023 01:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QsToYqcr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63A3BC433C8;
	Fri, 10 Nov 2023 01:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699579827;
	bh=QXKTvhWHBgvgPkLO1gSFMd6sxBadRrPpalvLsnx+m98=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QsToYqcr8pwTqsZ6hel8ILJkuhsY0BLXDXxDJuTOqpFOmAdY/c8fF4jFebzz8d1Vm
	 rto/kPw7r8Yv/UQTRzTw0t2koEKSRnHZ+v3Em21V18+csWmev8EiuzHPXdFUnXTaxQ
	 LbEUG80pRI4EZnFgdvzpVwkkfv3BnVD2UXC+gpa0h0/ymrjfc6ViiS2vJdIJgGZi3d
	 Bm/cQv5JQ3bqChAwxvHR46nILKINWKH5s3wAOppvwm3R1kATLVoOUhZR2Necr3rDyJ
	 wAThFJCv9Tq7d9WfUpEdjz/11O2P0f0N43Ty4N8B1lJ5xjAcwOWV+uF4wCU1p0n0Xb
	 Fd2NXp/F/6FGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E348C00446;
	Fri, 10 Nov 2023 01:30:27 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.7
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZUxgc8jIBEgc9CMc@gondor.apana.org.au>
References: <Yr1XPJsAH2l1cx3A@gondor.apana.org.au>
 <Y0zcWCmNmdXnX8RP@gondor.apana.org.au>
 <Y1thZ/+Gh/ONyf7x@gondor.apana.org.au>
 <Y7fmtJHWT1Zx+A1j@gondor.apana.org.au>
 <ZARrt99wJb7IhoY4@gondor.apana.org.au>
 <ZFeldCJcieIlXKJ8@gondor.apana.org.au>
 <ZHQe9A8CC93iCFMG@gondor.apana.org.au>
 <ZKtH5zrS4pR22PGT@gondor.apana.org.au>
 <ZOLcCC523FoBAyv0@gondor.apana.org.au>
 <ZPAiMYaqUslSyZ6+@gondor.apana.org.au> <ZUxgc8jIBEgc9CMc@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZUxgc8jIBEgc9CMc@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.7-p2
X-PR-Tracked-Commit-Id: 9aedd10fe38418319bd8ed55dc68a40ec04aaa05
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3b220413438184b352b297e7cf593fa56999b5b3
Message-Id: <169957982731.19824.17401685485894678356.pr-tracker-bot@kernel.org>
Date: Fri, 10 Nov 2023 01:30:27 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 9 Nov 2023 12:30:43 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.7-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3b220413438184b352b297e7cf593fa56999b5b3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
