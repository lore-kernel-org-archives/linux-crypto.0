Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAE6364931;
	Tue, 21 Apr 2026 16:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776788744; cv=none; b=c8m93pDxRnbFTnVgyCd3UaXciXPug7qE+XTeVaQcBWW0SIwTA7WPxUcdSBk2NulxEgKm7EPKC1cjzW0e/bfBLRB16FyQJth7yvbaA42+FDnOzI0fpzAGPelQUtIxdrHGmzanimnsO81LWNKiZ8xCVL4h2IpGmf7aRYpCvVJ+eGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776788744; c=relaxed/simple;
	bh=KffcYwixpkWMsAIOwuxkU6RtuqIOmNHd430zTCye0V0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sm6716Iinexice0VEFI86BUf5u+bPe45jznm8tx2hnflypHUVfsh9CzDAFb2EI49maTNZYI7xmxf3sWjlQu3H/zPN5FjHsZPf31bWm6erZu2CvKxB7yW7o7TM39RlBQFm6ablWJSdkAZxgw6SVexC/iFEpq/19j0LBNM6y5547s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kab5xLh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kab5xLh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4721C2BCB0;
	Tue, 21 Apr 2026 16:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776788744;
	bh=KffcYwixpkWMsAIOwuxkU6RtuqIOmNHd430zTCye0V0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kab5xLh27c1O/P3Lt9wMp30Tl+/yqROpd4mzfr3VV5PnV8C3QX8UZ2h/MOb9LJDtY
	 0uygsziIoSqZluKp+gCwqN48iqXhqQkXEnyXvG7rgBfkXRAXeswpKrL1j2Q5D3RerC
	 zkvgFZbrFOIc+SD8iIvGj8BSUQM+Yi7uyWfSLL9aGMp0mYmsCkpPC0BBpWg1S4J1rm
	 CaCznsALnyxQX6W8d/xJa4FZjWu0DkZNsByklpeGv5BOoz8wVjLhTGjCEDvXCSF8nb
	 XWF8ZV2L5YwiH94K23VGvL5BZmkvGQhon3Bvj15vkg/E18J4CgGc1emCEfNAmRBA0U
	 NFRxnR/DzbrKw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CF6339301AE;
	Tue, 21 Apr 2026 16:25:09 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <aec7Aj9lhK3YGZjF@gondor.apana.org.au>
References: <aec7Aj9lhK3YGZjF@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <aec7Aj9lhK3YGZjF@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p2
X-PR-Tracked-Commit-Id: 3bfbf5f0a99c991769ec562721285df7ab69240b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6e286940e2259a8aa72d2055efad0226dd72ce38
Message-Id: <177678870798.2896080.13576439747846193528.pr-tracker-bot@kernel.org>
Date: Tue, 21 Apr 2026 16:25:07 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 21 Apr 2026 16:53:22 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6e286940e2259a8aa72d2055efad0226dd72ce38

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
