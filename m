Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172C5239567;
	Tue, 16 Jun 2026 03:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781582247; cv=none; b=eABhcymDHH0k207z7ggv7z3UUEnGF5EYYsxd1GqS8xSUtlZilpnRVfwjhxwihAXqBxISpzuBJGf+5Q0/4YmNA6cLezbOzqFPkVXFqdL9RZiw2xDgsVk5ZCb9Kr1Ez+odd4kq0kfMcGtcWqz5Bc0jzOveaP3CSMWBwp0Pm688qb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781582247; c=relaxed/simple;
	bh=SZE6/OKYiB6UllzvXeQiDVG9igPB/S4jbWYQtRtzbrI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=XylcPHwwe6GHGw5nzCTi4Vfi71FuGfFdhulKpKhHJ7+7t+yQ47vN+QhuXNoXc2d92cqOq291dJaziAOzSDKNqo5iOdW1CgtFflaqSUVnkdQAVs+aI7U15S7U3M+ZFcZEo1i/iByyeyFf6vl8ZCnq8P/q7oc9fgvT5DQII9GHMeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+/n9lcn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+/n9lcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46511F00A3A;
	Tue, 16 Jun 2026 03:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781582245;
	bh=yNUzmtt6qa5bmNQZQlXYCbvN2WkItm5nKEMD6C4kZ1Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=S+/n9lcnOXYscPfPPqyctKkKSZ8xhGhSPI1y0EpiCczU91J6OY8bkpCHLRU8C01m7
	 q+WdZaUwvz6NrvQtSr7J9V7tewZNN69mhPDNfpx8dD4tOqk3YzP2zadLXjgDrUtowH
	 tdj/ED51zJr2X/lN7dDVa3wSRddhOmjQoCFfwJdgSBo4ahAdHzaGz0Zz1/4x1UggSF
	 w+75teAq/L3DtdkvTm/Ixq+L0HU4gVZXi7slVCCQXETZtkvoR3G8BiFN1hgMsJmscD
	 kGG05dYWKWGJL9lVjSix1kDhlit6oWWv8L2oJZ3asid0PUbKP1czOkw3sV4rnYYoZH
	 MZvbb0wiFCsCw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0927383BF4D;
	Tue, 16 Jun 2026 03:57:21 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library updates for 7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260615175458.GB1831@quark>
References: <20260615175458.GB1831@quark>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260615175458.GB1831@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: 065f978a0e015c4dd9f536f5c08078a37f5509c1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 673f72944dde6614a56b37a61c6097f584c90ce6
Message-Id: <178158224034.434177.11291504195892449039.pr-tracker-bot@kernel.org>
Date: Tue, 16 Jun 2026 03:57:20 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, Arnd Bergmann <arnd@arndb.de>, Christophe Leroy <chleroy@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 15 Jun 2026 10:54:58 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/673f72944dde6614a56b37a61c6097f584c90ce6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
