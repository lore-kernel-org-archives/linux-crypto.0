Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5056D1D5CFE;
	Fri,  6 Mar 2026 18:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772822317; cv=none; b=UenVfZsu552AFwGxnC1rLOZBMK9ezfh2KcQwBZsz0NJRnAVELBOLfZp8IuGgk/fCpVKDjFieIoZi8Q6MqikEAoELTlwxRFEmaLpEasr93iSkMLs/SSyG9B8LeEYBkZs4l36fJklEUk+U92HmVnZJvYL5TdIYVYQUl+w1UPDYGAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772822317; c=relaxed/simple;
	bh=RJJdltJX8kdG1hkbbccZFGAFm3iT/F0G8uDsWVG/7xc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=LoIJ3Vgu+c4cnIZaAbKMXxvASEPne9bT93cni9eNU1lFI5dMzS9mbt/HuXpl56c0ZzaMiYRcB7PUWv9CDS4J9k8ozwODfFbCNsNCpgkkJHMuAHtItwh56fVY46BUE5jIVKjzQhku7xETeax5IvfLD26lB/otE7dU7EMuc6hjKnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UB8Fvje5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UB8Fvje5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B6BC4CEF7;
	Fri,  6 Mar 2026 18:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772822317;
	bh=RJJdltJX8kdG1hkbbccZFGAFm3iT/F0G8uDsWVG/7xc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=UB8Fvje5FJRBUgvHURwQM9afqwCX62auX/58uq0jR+140GAOTayNELstHzmIh5/T1
	 GCKHuY7erXjqmdytv4Srmtw77XJ+hKlEf+C7WqABKfIgD6S10KtTVJKFVCxfdIX/pG
	 X0ffE84+d2RBS4yirptYNZ3hi6whGXQAlxIqnOS8wD9tN762LcwzQmfkrGOpszTMlE
	 wsTHfUMYrYfdvmXAYWu3NyjktjcqKPj3tLGSRfadXo5cuvKiPBP0AR384nZKrjDeC2
	 tpUvpaYzLr+fds/G4F+WmVA9bwiOMxk9V/cywDoQGeQpGTyR4+VtPsdzeLv64sVTsL
	 i7/yp9Tc3EnZQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B2F7A3808200;
	Fri,  6 Mar 2026 18:38:37 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 7.0
From: pr-tracker-bot@kernel.org
In-Reply-To: <aapDn5mYeL861_6n@gondor.apana.org.au>
References: <aapDn5mYeL861_6n@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <aapDn5mYeL861_6n@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v7.0-p2
X-PR-Tracked-Commit-Id: d240b079a37e90af03fd7dfec94930eb6c83936e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 617f5e9fad91ebddf0b39e5eb5063d22459557e5
Message-Id: <177282231633.7628.10344389944581828273.pr-tracker-bot@kernel.org>
Date: Fri, 06 Mar 2026 18:38:36 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 6 Mar 2026 12:01:51 +0900:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v7.0-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/617f5e9fad91ebddf0b39e5eb5063d22459557e5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
