Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FA32B9A7;
	Sat, 19 Jul 2025 01:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752888880; cv=none; b=SGiQVdmfECucA894iIzZL/FkEycpRq7623IydrAb+zEu1fR1fXNCeJy0Gco7utFLAukfgMz4G3kaCTSFLHra2TspoL/moxEK6LO2htZf8WQsV2sMyeSy1G44S8+45ufJCAMGx6/qF/POdgcUn/C6l99Y5Ac3/ukXv4FZIIWceqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752888880; c=relaxed/simple;
	bh=n37UmbNNjeQHOFSW/Hft4r6y1ktwxSaoxI+SPmPKyY4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=reC4Wd4P/tZ60F7Juh8eHDr5zPav98b63a+K+wD5O6O5D7M1BOM5d25/o+pzEmmzMShViJwUY1eSmLmXqYZEUPDD3QvzD0HBeXRcNtQ1Bayf16R0JPtioIhu7PqxfvseBi8lBttSTgAKb5MQfNvkT0sXs1V7ZZZ0M4nIjKtfiI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oCEqvc8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oCEqvc8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6757BC4CEEB;
	Sat, 19 Jul 2025 01:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752888880;
	bh=n37UmbNNjeQHOFSW/Hft4r6y1ktwxSaoxI+SPmPKyY4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=oCEqvc8jNrOlRxcd0HgNwC5vvYXRLBKjiSH/8eo8FRTHQqTE2W4Hk0dpErihu5Cl5
	 97YG8fS5eO4R8N7lVJjZ7sSEIWFM6gkjIrlt9JyhzTaT0kSUH2vywECtEeJGVwDo+u
	 1tjJx9rT+dYhs+4Z5HWES41IgbdVasRCLbmgraabf64yPLPBMckrSSoyYXiEwxClLk
	 uQnyKPoWnA9ZINc7WUjTDZw1/hWbvClZKPouTkOqejT+tZUxcGByhOydq791yoTWH2
	 kRpXal5x0TxVOW+B/2jRiiXBzOn3A6jkVA6Bzq0cyfVvEy1vfd6qOH55QTJ5NSjZIA
	 tB8jWBYoETgQQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33F47383BA3C;
	Sat, 19 Jul 2025 01:35:01 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <aHroehR8vSrZnULY@gondor.apana.org.au>
References: <aHroehR8vSrZnULY@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aHroehR8vSrZnULY@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p7
X-PR-Tracked-Commit-Id: ccafe2821cfaa880cf4461307111b76df07c48fb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 27c2570359d688884887cd45fa92e678523012a6
Message-Id: <175288889973.2848293.7835133601205838094.pr-tracker-bot@kernel.org>
Date: Sat, 19 Jul 2025 01:34:59 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 19 Jul 2025 10:36:10 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/27c2570359d688884887cd45fa92e678523012a6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
