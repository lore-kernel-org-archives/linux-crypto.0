Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1BC22D7B1;
	Wed, 21 May 2025 03:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747797303; cv=none; b=phwsFJM4Uah3FODlCNNbaQ/2LkZtVbC6l6OnKagK0riapdaszUUhCLFpNliI9CY94j6fsldj83uUFME1JbbfbyQVh+vEEjVf8KcJTtuLyaKJ41GQUUToNi2oWfS1TTIcE2Hoz5v1UIXrM8t3EM4cusvbqPhvMJV9GcQSkZr9g5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747797303; c=relaxed/simple;
	bh=JoN6Frh1H/LnALQNXfz2ZB5ZwN6+WKQwE9YXLVn5mLs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lO8+Y94xPuB4574QYljlwvC9bxUAisnC+11ynIbb1UPpmfoEgkatQorY3kE1Cm/wpbvZkuPqo33cW/NKeYBXlCGm8rNNjaKihQEx5ZeLMJKr8Cr+I/2+gYsQhZIfdKYDDP5PA0ojS+oastbrpNFE+co8KOEFvHw6YydGyXL650c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uOAfO28x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uOAfO28x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E00C4CEE4;
	Wed, 21 May 2025 03:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747797302;
	bh=JoN6Frh1H/LnALQNXfz2ZB5ZwN6+WKQwE9YXLVn5mLs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=uOAfO28xyPKppSR6sr1ZIZxG7++AOl8LZWF1hCR/llvlNFbjhMT62l9ssD5/0iUnP
	 L9lfigkoM7w6ryJHPm1Z39NlftSSJHENycG1243RnwharL2j0Q1VSGaGBDxTv0pcgG
	 Yp4UaUAKwyvsnP6+xRwJunh0hODCzkWsA9TBk7r5MFNTYNvM2Lur6bvqccCAq1u+uw
	 VZ4Gj0pMoDCjNNs+xjaeBfBXhxsChxmvg6IBXZBqPgPJhAEV2Z/0BcbL8CiGiaJJzI
	 yBe8+h0l80cpkfBaTEV2UQ3w0K2dZrNQ2RHEsKfMNwbd17M2u6EPsSb3K/kg7W3S2O
	 uhEKJ6bhj6JMQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE03F380CEEF;
	Wed, 21 May 2025 03:15:39 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <aC0zk5QbJJ_FDCKq@gondor.apana.org.au>
References: <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
 <Z-ofAGzvFfuGucld@gondor.apana.org.au>
 <Z_CUFE0pA3l6IwfC@gondor.apana.org.au>
 <Z_89K7tSzQVKRqr6@gondor.apana.org.au>
 <aAn_NWZjdX-wYHxR@gondor.apana.org.au>
 <aBGPSpJcLRrwiutd@gondor.apana.org.au> <aC0zk5QbJJ_FDCKq@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aC0zk5QbJJ_FDCKq@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p7
X-PR-Tracked-Commit-Id: b2df03ed4052e97126267e8c13ad4204ea6ba9b6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5da472ae1f128840b27795fa461b47a85d882ce2
Message-Id: <174779733836.1554736.3453438309835149712.pr-tracker-bot@kernel.org>
Date: Wed, 21 May 2025 03:15:38 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 21 May 2025 09:59:47 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5da472ae1f128840b27795fa461b47a85d882ce2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
