Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E810364EB3;
	Fri,  9 Jan 2026 16:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767977017; cv=none; b=k1SIJNjVdt53L7NSxH05wyk6LWqcq0cxA1kOAk4LvXAd5QP9ta9WkaSIFc5vwHOmVlzsBY4XMiuhRV/5W4MXRUL6/239BVUxLBG7jEvsWWop+tNIrMBTwQXEF5I1o7+Og8AbUgXb1zOvczrUX0IQN1aElEb4halomcg7Ds8FfLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767977017; c=relaxed/simple;
	bh=CR5tN1qzYJpufd4fvQU+7lPndFTT8Bmh0Sk3EHjED7c=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Tb74X5FA7hkqgFIlzcMVgPUcsedvY0N6+O2WA9yDcPMkKDmcNpynIBr8EZ93qN+an8vJF3ryNDQ+HEvattfVabL5yvvkwdpmBC5uYxvxa1eAL5L+oKzH0+Xc73wTTm4SYmGZaP2fkO8IUgK47fhg4/ylImenokcetb6QEqEBtKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ciRAIlZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ciRAIlZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FB7C19423;
	Fri,  9 Jan 2026 16:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767977017;
	bh=CR5tN1qzYJpufd4fvQU+7lPndFTT8Bmh0Sk3EHjED7c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ciRAIlZW4VGS7lZb/n5XOtZP4De0s5u2/8GPbJ//FQA72mnSdugLB7BrW4ABAoIL8
	 n+wpmde4N9azlwU08VEvoCQakqwjgxK6Nrawtj0RoDqtq8zqZoRZ1xVHt3AGZAXaUs
	 CnYZd0mgo+JGiPq2dP8YStQuOOfK38HZDhFwkSo8lB5aRFjAiP2ejDnuW11CaQLRsn
	 ZNxLgp3EgoSQtWPm/M7v4FePIxKxnMUw0/0bwZoXVIKjBTOK8En2oGOI3IKtpuc31D
	 pNXTkbwKlwXnFYAweD+2OeL7SxMy55HG5T8nXKe7xtlJjq9uiALZPQ+wWwKSteQbH1
	 QzEbWNj4z+Bmg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3BB2E3AA9A96;
	Fri,  9 Jan 2026 16:40:14 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <aWDO0UuX-rOGe1Sd@gondor.apana.org.au>
References: <aWDO0UuX-rOGe1Sd@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aWDO0UuX-rOGe1Sd@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.19-p3
X-PR-Tracked-Commit-Id: 961ac9d97be72267255f1ed841aabf6694b17454
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 77d4c5da97ceb5f9bf9993a36b5fb453616412e8
Message-Id: <176797681283.323012.10953641385306813043.pr-tracker-bot@kernel.org>
Date: Fri, 09 Jan 2026 16:40:12 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 9 Jan 2026 17:48:01 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.19-p3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/77d4c5da97ceb5f9bf9993a36b5fb453616412e8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
