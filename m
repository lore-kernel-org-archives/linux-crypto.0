Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250263358CB;
	Wed,  3 Dec 2025 19:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764790537; cv=none; b=pS1dla+bApt9l8CyHzvkg1OqHAyTV/MP1WvU5u9lKjEPc0w6zxD86m27Qqe5md3mQwNDF74ZY1QDA/xgXEjhj9i2pRXFmMYTjV+KvYczXqHwWT1VXV+YE7923LnCa26D/ZArPaomiv5G3FmyvLn/MNYk89jh4VjitrFLYgTdjpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764790537; c=relaxed/simple;
	bh=jFK1BuM/m6jtK4dGr5//PiUNyUgG/YWjsdk9insWa7o=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=H5p3MPez2vmxxMJEGx9u8mmddIIt2IWaIUPKOWCELAy6fMLN+5JZMj+1NFoCku+Bx/ItGVBvqFPZQ57pwQJBwOTL3bLDrKNNPpIMtD0IvYjnmprN5gIYsnCxCzCF/h+Sdq9W0xSPWxqn8pDxeTIKkWtQ9pyl2HnuHF4k45gTeGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=exD4vTdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="exD4vTdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA258C4CEF5;
	Wed,  3 Dec 2025 19:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764790536;
	bh=jFK1BuM/m6jtK4dGr5//PiUNyUgG/YWjsdk9insWa7o=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=exD4vTdm9u2faR40O0CkbjdKxH1YmfcOxiJJQMTZwGw2FEyMw8mcEesVeHlirQvn/
	 JaISZcaitNB2wKl+0WEdVdR3glVcvgoUn6n2tBGEOFKRjPtIk3ZAkA0s9m/08io+4g
	 fTWsrHKuxJ5ykmPYqArzY19SlO/bULoiaodDWK3HGiqSeEiqwxxcuQqPQndYIS3oJO
	 TEY8vKIfsggr/9yCM7dOcLXberZ4Jjs5xdZh6xumo6c+8tLfNwIfLoG63TkrO2ZqW0
	 drM7aNp+iqXHUK92scGkvsSPvnJVpXxhhzGZjHgEVg5ogyZ316Lvg7/7QvE+FPe0LW
	 ugAQCnNDqWtLw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B57B63AA943C;
	Wed,  3 Dec 2025 19:32:36 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Update for 6.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <aS1q8uJfxD8lTuLH@gondor.apana.org.au>
References: <aS1q8uJfxD8lTuLH@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aS1q8uJfxD8lTuLH@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.19-p1
X-PR-Tracked-Commit-Id: 48bc9da3c97c15f1ea24934bcb3b736acd30163d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a619fe35ab41fded440d3762d4fbad84ff86a4d4
Message-Id: <176479035526.47894.13028968268239719814.pr-tracker-bot@kernel.org>
Date: Wed, 03 Dec 2025 19:32:35 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 1 Dec 2025 18:16:18 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.19-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a619fe35ab41fded440d3762d4fbad84ff86a4d4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
