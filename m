Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4F4242D7B;
	Mon,  8 Jun 2026 15:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780931035; cv=none; b=bygTRw/HhSoBDSXlocHilpD9qhkHI1ogwa5nLjxqIsI1csBTJ2UwHKACLPLj6YWbHndXplqAcfFK1NiI0onJSfnsoWK4EQHr5avBPIH9YGOt+BJTYU49N1zQF283sOHv6tfWkBkcAcr4K9gnPaKZlTI5XbmDZeuSbZEjNCzef2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780931035; c=relaxed/simple;
	bh=AzptZ0ZBLrTLtR/jb5QC3PsviqeuYFQRQ+nC/hz/zV8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lKaFIr+vzef7b/5U/ZK09V1LLCfJf2IIK+2mEo3/YMA3k8SkKzcNmXrRpbmBgWs7uEi84baZtlTYeFdGA4z73YuglIdVR04AG9NsKQl5BQn4bt5+MnvY+EqQPRviuYtqQGl07K+0/cD4b4i/8r8B346Ur2BMXu3+QazbYKf71XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CbO87EnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CbO87EnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38161F00893;
	Mon,  8 Jun 2026 15:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780931034;
	bh=utxTo7gP0nhaGzRG/RefqrxCKGDuOBahN0NFlCJ4nLo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=CbO87EnJuTcv4OXqDypZrcCDrWe+GU4Vn1sNAixkXkLeVrHACRfmKmACC4Uw94loB
	 LDwP0Rkut2kK2KYqSoHWvZMwIdSsqjTZUbqVmGeDqGS6IGAmXPyr9pGEstpdqJ/eTo
	 un/nFAOduwyMTKdpkKgCQD0X/i3R2f15tOe+CxpaxpWEjkKSR/RQvqXubQdSvc/f1T
	 RYeOCPsX4yWQcnaP7FcX3malVVzCqtWqByndG19X1CL1/LVNtlVwRTpxlo/IhZ9eAY
	 VHaJZvW15AX+bNZRsD4JHq0YJFmynaZA5VgizYWzgZCjJfhACM4R/RubKpQ4r7S8Ah
	 KOMCg5fIqw0Xg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0C043811A67;
	Mon,  8 Jun 2026 15:03:54 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <aiZWfDt54UazaMJ0@gondor.apana.org.au>
References: <aiZWfDt54UazaMJ0@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <aiZWfDt54UazaMJ0@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p5
X-PR-Tracked-Commit-Id: ecf3edd349dfabee9bc8a46c5ff91c9ebd858d48
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2d3090a8aeb596a26935db0955d46c9a5db5c6ce
Message-Id: <178093103339.1528785.9938975298212387866.pr-tracker-bot@kernel.org>
Date: Mon, 08 Jun 2026 15:03:53 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 8 Jun 2026 13:43:24 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2d3090a8aeb596a26935db0955d46c9a5db5c6ce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
