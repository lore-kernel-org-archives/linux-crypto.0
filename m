Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE3B17BB32;
	Fri, 15 Nov 2024 18:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731697133; cv=none; b=qCcSijiQGa+Ai13VvP59xsHr2yUNCW4/6LOvaXjv8zXjbdwtTrCC6wTRdvcbJgvg8rut2FNhB6DK563JhTN5Knn9wqj1CKZb2PKxTu+xIGWx+SoYR8JloQyOyhYZSx6VC1VyrUwWdfw68Sg+dGHmKSqemWwyisCOeura9xWcVPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731697133; c=relaxed/simple;
	bh=dWfVFu/UQF1AjwccGDxDVTOlLFvrv0/PWmsIM99AJYk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=EHJ4ZRGZqLuUgk48ZpfFDdsCNzJb7IM8RXZjE7nsPCMg5aNDWjqIRcgrTw93IqU1BaG3lHWJjMeDcu2xwzIPOtz2At6fahMCepqD765OJ9S7u1Ek6avfsFLobHg6/b7p4bmZmr+b7n18iCbXNyFCSNtpQjFuoukPmFd6t19A5Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R2PMGnI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R2PMGnI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB7BC4CECF;
	Fri, 15 Nov 2024 18:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731697133;
	bh=dWfVFu/UQF1AjwccGDxDVTOlLFvrv0/PWmsIM99AJYk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=R2PMGnI9jvdh8qT5Z179NR7F2Aij119aL5VL3T9kdqgwjr5yXwET0dzxN0bgImenN
	 vhAxKjEJMwO7jfpC8ulzt+q+txZsD9KlgFX7GVNbhC1ck6k8vtD5y67UDesa97y9Ps
	 EkJyIfsod+gw7T2+0zUgTCcbGfFfJFRmVfy6RoI+7JmBIvx4L1utaVrkR/FZ0RK2pJ
	 KWBQpN2ltEpO0A6lXnyXHtpUKQ5W6+UzrGRuhx81XB7q8UtfJCYsA1I5sZLK5qdKMU
	 ZJzFSmCMep+bmQxQKhs11z4zB51jR1oQp1pHBruj+rkKWE3Eq/7jphJRCVKf0BjwyY
	 1NABFXJQW4xxg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE06A3809A80;
	Fri, 15 Nov 2024 18:59:05 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <Zzc13mpEUC-BblD4@gondor.apana.org.au>
References: <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Zw9RM_jNu9vqp9T8@gondor.apana.org.au>
 <ZxXqbFAO9VN3ugIR@gondor.apana.org.au> <Zzc13mpEUC-BblD4@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <Zzc13mpEUC-BblD4@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p5
X-PR-Tracked-Commit-Id: dd41b283ef2f028e414312706b48f2880b7050b5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 842c7e5834af1fd20b3c79f894be51b2059e3c88
Message-Id: <173169714437.2685462.5553967884640283932.pr-tracker-bot@kernel.org>
Date: Fri, 15 Nov 2024 18:59:04 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 15 Nov 2024 19:51:58 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/842c7e5834af1fd20b3c79f894be51b2059e3c88

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
