Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50865225A3D;
	Fri, 13 Jun 2025 18:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749837863; cv=none; b=rt+np+niSy4mheZf2PW+XgbokQg9opGkneleMHTaToeVz7x1j3qjqBseOWnz7GnNflHI5K8hr7g3FWoqLBRhrlMh9wru0njq45vRx8h/5mkyBhgoFh4S5SzuOxp2/eJZfoTUxwMdgNORfxiFR8aqICaWQbo8bZ1YsrWA9VXDBUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749837863; c=relaxed/simple;
	bh=QoWL+WLjv4+FfD13sRd00iIwab26JFHdbKgK4m9ZyNo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BD7VOCEFKyyFuSqjh1VL9tWkQtlTFO3r3/JdexVBJWq57gVgpE1mR+e7NxeWnl0U6zEUi8XyJ3ool6LOe1UKYtwp2kyfuJ15oijxwMJxDFQdO3juqUZRo26po/bnJja3iS0Gp6nQLacnEijMi3U2EC8CEs73FqHx7gLBWP3cs2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cMm5aTwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cMm5aTwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20487C4CEE3;
	Fri, 13 Jun 2025 18:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749837863;
	bh=QoWL+WLjv4+FfD13sRd00iIwab26JFHdbKgK4m9ZyNo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cMm5aTwnPZaqMUP5SaQBhlSIMtGwx+tIjzktITjwhVrH3QZtXAkHN4QSLI0CN8cpv
	 ctdW20kwxLywF+oPifr4MScKssh5lSpZYnDVomJGY10BMFgGV1l/giQ4H5OamRlybl
	 qk/hc+Fx+krvrBayyw2/QSvcp2tznCOFfW1e9uDuB311y8E/Oe/K4ekdxICb/YHx49
	 Ib3T82iOL46ouL5U9DPxUZHa25EuS8yi5ImvHIIUg9aNR6nF2D/FH2yV2xjvbcX2Ln
	 QQg3gfiHw58IBknyX5xOGEVdW2z/1ovDz2jY88/EZ/9z5pSs+RKeB8VFXpJ1IRCJmM
	 zhmA6TxAYki4A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EADFE380AAD0;
	Fri, 13 Jun 2025 18:04:53 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <aEupSzhTI4h8kz-5@gondor.apana.org.au>
References: <aEupSzhTI4h8kz-5@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <aEupSzhTI4h8kz-5@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p4
X-PR-Tracked-Commit-Id: 40a98e702b528c631094f2e524d309faf33dc774
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ad6159087fbbd754bfe940bd62b6322307925faa
Message-Id: <174983789254.834702.8944781738634806282.pr-tracker-bot@kernel.org>
Date: Fri, 13 Jun 2025 18:04:52 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 13 Jun 2025 12:30:03 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ad6159087fbbd754bfe940bd62b6322307925faa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
