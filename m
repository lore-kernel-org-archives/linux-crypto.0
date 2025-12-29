Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2A628E59E;
	Mon, 29 Dec 2025 06:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766989114; cv=none; b=djOB7GeRDZBjrh45OYdcewTjrX4g1Ts+cMeLyhQZGOXuiJFKJqvlpxf7EuMrPRV92t7raixzscrm7n/hh4IQVSuxCSzwRddTZ6gMFH5zK8FIZXroWagUH2Q5FZ4i0pLjixAFZUNWWC+tb6HR1aAQ+EP/57uNMxal1ctRp7KkHGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766989114; c=relaxed/simple;
	bh=qstDeCUOmR4RHhq/vy9KlElVzvnKkiBYsEDby/4nMLc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TKpuS4viOcsmg38zhD2IKgf+Y/xJeDGYL3cl2NCJcu3fPZIVyIdEx0YtrEsw0mfFdIg4n4Wh0V9lLlmD0PL4SA0gE60Fc/VBjpdkuxG7zPD5dz7P5mNwoaBu6HqswB6rsOAhARjyW+IEqOh4qTc7C7A94FwfnLcARSs2jDyrfMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQ2zJt4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQ2zJt4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35120C4CEF7;
	Mon, 29 Dec 2025 06:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766989112;
	bh=qstDeCUOmR4RHhq/vy9KlElVzvnKkiBYsEDby/4nMLc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dQ2zJt4MXHophB9CHAFA7YFtQniUbtnxdGvNJn3y4Ls/MOC2LlfoHY3bW8yWAQR1j
	 d6KiH/bX63h+FtDoePUD+jQ23ZYfmlbWKM/FMf+RLo03aB48lceVz0iODeHjJSjm98
	 JPiUHJYa8LX0yvzv+D1U+gwT69fZJyY5u59G8mLDUGy6CuVeEM4zVJ2SiUOki59Qzv
	 k1QbtUdgb5EMRxglp3tbCci5braIRW8dKF/HGZse18hQogtZc11HWL1mROjLQHEgFh
	 8Pq0gtN74PMMpQzYQ1i3gXs1ziOc5j26y3PGb2BosMexHzKctmSHqi0E2hkdCOnMnp
	 17bFvoPsx8hrA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3DB0E3808200;
	Mon, 29 Dec 2025 06:15:16 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <aVHMLaTgxU8eBdub@gondor.apana.org.au>
References: <aVHMLaTgxU8eBdub@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <aVHMLaTgxU8eBdub@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.19-p2
X-PR-Tracked-Commit-Id: b74fd80d7fe578898a76344064d2678ce1efda61
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a69eddfd171f5570f5c7b333e41f3dead26ce859
Message-Id: <176698891475.2860963.5575527961980430682.pr-tracker-bot@kernel.org>
Date: Mon, 29 Dec 2025 06:15:14 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 29 Dec 2025 08:32:45 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.19-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a69eddfd171f5570f5c7b333e41f3dead26ce859

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
