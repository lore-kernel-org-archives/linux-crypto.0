Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9F83B2FCE;
	Mon, 20 Jul 2026 20:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784578071; cv=none; b=KZvFfy0140NjFSOYVssdO3wK8XrMQLG3QYqGUejA3JxKBTb9D4fqqp6azQiHmmJdKWA7GMh1yrXbAlkVy96K1ZYJSbF8ziPWISxiEE7eD9t3tUOw+mqPbnen/aP0opRCdNvLc21g2sEaQ9UYnjAtg4Ljs3dZp1RS+KBMYh6BJgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784578071; c=relaxed/simple;
	bh=UsWZC+p+WRzu4MXmAJpNwamKc42o+jInTMzUhuNmQSw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pK4SnkiEp/xL5dwGsKJfE86SbWJJ7glxOehy0MrAQsO6D5jUfla/9BM1d4+m3v7i/mN74Rcp3m3qUAaFN8r8Jfnh05BkzSEVBErzXGi8fBPMuqiNPBLIdn6c409lY/arsJSX6ZQexsC4OX/RG7VoCbNgxZZJ5Bf7EezA6TvxXlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C7F2pXvq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C7F2pXvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA951F000E9;
	Mon, 20 Jul 2026 20:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784578070;
	bh=fH3PXZH25pPFGfcHKEcbA7SRBICXgXHjScA3SjdXTpM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=C7F2pXvqZPIIqT5l1rw74Sium1X+OkjCCh123LRdiHj+68ax3QU+KRGyVC4odo+I4
	 t4gckhcVtkNEAmyymSluRAyCtylhq/jLKEreqmqn6XEhc/5mmXsbkyN30RuYmc3lxj
	 SlWM/p+zr/QRpacZXAAX/TDYgnSqpjZyIRr2fQ4zkl7vE/p+cdwynvOojel8xdszfF
	 Ns0e2YVnw6RnUQ4tyG/hwWKdUq7qBAj/raXUnUvOkBDOwiSPZ/0lbzjTAQE9YH0pBT
	 C/dxtzp+H278AE48cOYxYzvfQfuNJ6h3u3OdldmJ9PBBLGCD9owmfxQN8m97Y4OmwU
	 NI4Y8Ve1bkSkw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56A6439244CA;
	Mon, 20 Jul 2026 20:07:21 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <al1xHJ44X6qhXFTy@gondor.apana.org.au>
References: <aiZWfDt54UazaMJ0@gondor.apana.org.au> <al1xHJ44X6qhXFTy@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <al1xHJ44X6qhXFTy@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.2-p2
X-PR-Tracked-Commit-Id: 8173f7e2ce67e6ca1d4763f3da14e5b01ce77456
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: abc69ae5d23e7910dc5a77f8d8b2c34d335724c0
Message-Id: <178457803981.4145645.3887422714364035805.pr-tracker-bot@kernel.org>
Date: Mon, 20 Jul 2026 20:07:19 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 20 Jul 2026 10:51:40 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.2-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/abc69ae5d23e7910dc5a77f8d8b2c34d335724c0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
