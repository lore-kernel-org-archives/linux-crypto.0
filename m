Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BA8480948;
	Fri, 18 Sep 2026 18:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755116; cv=none; b=Fv0kH1AgE7kTE0tUWr8sP4zAJG+26tjrCuqacbVrynM6MPsRDpRmMZkZjt708O8HG96ZDd0utZ3sdWedGDnXaTQCsVWcx2pAwhp5WcXNSzQDK1skPD6byoK+2+alo05Z2R+So38PNVjTjCLXkwoX+Mw/WmK7q2XvRzXz+2xuLYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755116; c=relaxed/simple;
	bh=zaO4U76p5FcuvoTOH1pC6PuSlM5ffkh97PW+dyO8Wzk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FkzGsqatHfBVBjwNiOD/fkWnmYEgzqjMR8QQFpwKTFg2H6MfiQBvOJu/zY7jBwHcDwUv7CmaXfHGpxCOiUMm8OEmZPs0hXYUeXZY5Uito0f4rbb7BWm6uriuEoNfcz9LN8bUUaKs1v8FCTM/XaPMJqNkebFDpzzAhY+T1VKMqAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fff2bhp9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fff2bhp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E7D1F000FF;
	Fri, 18 Sep 2026 18:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789755114;
	bh=jZJOsWDy/dPWpM63PIQFbXnVE07Vj+odzKUa9Ff2oXQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Fff2bhp9TdE9NQy/STrpRvF1oWcBkdhfCcz4LLxp1MynOaIyWKcUg+jMkGTRnPdjZ
	 ty/pQ+wA78aQ1ERgq511/cSuSOo6IvvI5PbJ3SfT5igF8CdEUjQHr4UmxwlUg84tyS
	 N/vRM61ImI4HChF9J/tZZFFqnmbvmXGdmic8tYLugIEfeLQP+dIlk8pCmlV9n/SCXY
	 XhKNomDvaNEqUwYdp+OgL1TVHzyijmkb+6uDuOOPuvh88wSz0ENHq72HfnWGsjOjfo
	 y/6N96Mbixo/OTDcu2X0PMkOeq32lHJNohFnZCRbgflbdDooAf/MQ2LLF6u6NjLXTa
	 fcFpNW7a8IYgw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199E7380DBEC;
	Fri, 18 Sep 2026 18:10:49 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <aq0LWN4cVftl8r5p@gondor.apana.org.au>
References: <aq0LWN4cVftl8r5p@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aq0LWN4cVftl8r5p@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p4
X-PR-Tracked-Commit-Id: 53cf0f26eece095a3752642151150404bc3351cc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5ad17a9760cd00c53d4a932a840e59af3a8f960e
Message-Id: <178975504765.1083250.8622300803411028785.pr-tracker-bot@kernel.org>
Date: Fri, 18 Sep 2026 18:10:47 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 18 Sep 2026 19:58:48 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5ad17a9760cd00c53d4a932a840e59af3a8f960e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
