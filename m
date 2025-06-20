Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E00030E844;
	Fri, 20 Jun 2025 06:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750401247; cv=none; b=RguyiIrCE4mA1IfdUm5+AWFIsw1NeCcCnby5OS/19khar7f53txhKH1i6qAJ85x7yXDLsyRhwh5x8QZol54tbkB8DqyuUX5yWMXRe70mwDWShYWeoC819g15ewmWEJ5O8+q2qdbeSOL4xqm9ArzES37cWfO1rrhwgXTmLKMGIDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750401247; c=relaxed/simple;
	bh=IuRwyOKneJCSkVWyLAcFAEowDNOyO1GkwmbicDcNxCY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Cl7b3roS6kxL7mNdDSCujaC8sA1osFKA/BggE4xrKOBzpvlYZKhDuM5D8wEQsNuB5JK/OYzQ/wN0+sKZOjXCfteh0XZUSg8ur3KslKerjqrjLn/dz07z2vSkZfT8eyWuNsNZRA6irXcgkxl/5svAhBRMr3+G3VrljRPHQFvL288=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lk6ejsEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lk6ejsEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD66C4CEE3;
	Fri, 20 Jun 2025 06:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750401247;
	bh=IuRwyOKneJCSkVWyLAcFAEowDNOyO1GkwmbicDcNxCY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lk6ejsEW34nyj0jbAi+W0p23wmxjzGn1Ka7Ebw52k0/yRKCneOztTHBSuJbG8MM+h
	 361HMPbtPYocgxeiicEIP8z9S/CcI2XsmoKycAHvGtR83kDFSVkhkgAUKuWm4knsqa
	 bKx0/4KjSgxBcddcEuA3lA0R6sBaCVUtgJkeQzX3P50a0ELrMOrIndpGz23N4yHR6l
	 13ynuPR52Bb8x9HNz3fkzgLo/sejigBzKzwYMGlrk88S7KgovBrPeNlvVLQXO91NX0
	 37r/t2H1xeIFBbhnXSyx24tn3DuJ4oVfkHPArJ6hru/ii0YDZK4Q7iEghWse1sjNFP
	 kBCXLAsUsu1sA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C1D38111DD;
	Fri, 20 Jun 2025 06:34:36 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <aFTS1jNQ6DB51gUs@gondor.apana.org.au>
References: <aFTS1jNQ6DB51gUs@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aFTS1jNQ6DB51gUs@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p5
X-PR-Tracked-Commit-Id: df29f60369ccec0aa17d7eed7e2ae1fcdc9be6d4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0fa5248255a1f4cc87f35610f2762d9cdd919246
Message-Id: <175040127473.1104049.8048882044326007827.pr-tracker-bot@kernel.org>
Date: Fri, 20 Jun 2025 06:34:34 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 20 Jun 2025 11:17:42 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0fa5248255a1f4cc87f35610f2762d9cdd919246

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
