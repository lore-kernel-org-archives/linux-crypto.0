Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E0A391E45;
	Fri, 15 May 2026 20:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778875789; cv=none; b=q5SZ6tSpxono5HLjQzPmH90NuEHKtN11HFbIKHcd692dQvYOIi8TWTBIUZxdzUTV0LwhO7jb/p3tE2lrGPHy9cPFOD5hMT4vM9zIawy1GNczOJjRmU3RDZ/4mM8BFz00sSvmWni9fv+sK0wOAWLh1uXvSeQHX72kBMZIuo+cLxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778875789; c=relaxed/simple;
	bh=c8XHB0Oq8UYbKuxHkZjMi+25hnVnLFmgVdYqTGnZ3kQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=D+zKf94T7S6Xx/L3I3n1A6V6sj5141nl+iIw6/Fex60ok2FP0Zy5no1bRaVrUkqCvvvsfw6dCsW3PJFUgWVR8JsRT8cYpzezzuVbzjLFMDrvf1wfa7dW1qGezIJpfzSV79XDDc98f32PAnQqRWPDkcR1RbaZ0NmquOhrzTQ6xzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sN9srSQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sN9srSQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB63C2BCB3;
	Fri, 15 May 2026 20:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778875788;
	bh=c8XHB0Oq8UYbKuxHkZjMi+25hnVnLFmgVdYqTGnZ3kQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=sN9srSQnVYY+G9TMwABdIacWaKqrMEbZdQyQNmij5Z0+CcJ6z9jCmP5KZaJ+Zl/AY
	 Qu8VFx9exxyT64CDYqQkO+WTiIBrHKgzhmkzS0pKlfF+g0p9jgDbIx43hZFliZLl9W
	 3sMlrcqJG6RAwcNq8w8mLhPrtjau4+Zq1Mf1zLk9XztitpNWBQisyxJm5bebdrgLSl
	 fcwODK49Ai2fJ2Tl+rOTY37lxU94FJGKaGCiByHTiOgEcRwWSQqE6Gzv7glRECmSat
	 qqOAfBlx2LeK0pnyJF4Bt8CR1HiaLoZpe1xfkmphIyZ7BideuzrLPPgDVxy8jILUk+
	 QDyaI1lB+otAg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 579DD3930A09;
	Fri, 15 May 2026 20:10:03 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <agbpRZ1OdUC-orcg@gondor.apana.org.au>
References: <agbpRZ1OdUC-orcg@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <agbpRZ1OdUC-orcg@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p4
X-PR-Tracked-Commit-Id: d1fa83ecac31093a550534a79a33bc7f4ba8fc10
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fd6b56615696c2addca7b43c862b21a9a386c116
Message-Id: <177887580256.138500.3259603774070079201.pr-tracker-bot@kernel.org>
Date: Fri, 15 May 2026 20:10:02 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 15 May 2026 17:37:09 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fd6b56615696c2addca7b43c862b21a9a386c116

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
