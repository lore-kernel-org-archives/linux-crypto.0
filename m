Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858F33010C;
	Sat, 29 Mar 2025 18:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743272652; cv=none; b=NfKzgWGSfkpXkhxqk/puk1IjxhsvJYe0O4gnUfTA+F1YSYbEFE3QW7rhFBMQ6xxq4NtGgLonIZKwMaljQnaybupzqxYKCddNr7sS45tLNX2TouKiwlRsOajwjiaKBalQ1P1zYDeLS/oMHePoXO7n2+s6V4wOxxvtecAlWJ1yFiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743272652; c=relaxed/simple;
	bh=eNfYS3q/jo7IeKzz1xOmd+nNId1afPO6f+EtrYSscTw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=q4lvUB3AvPWXx1iS14ETxPXOIfPyA5NRAbaEADR1gR5IoRRAVrosLkCtWGHHN5sibRr1uTKfbt26vfp31CEyYN26choJc7KnJOgqLamMj9ia9UYX0c+3d812Qv6NZO7d9r8L/C/WWaa9nM9StsS3QOiQlD4LCH+OFGUz473t7KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EF4jOcP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EF4jOcP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EFFC4CEE2;
	Sat, 29 Mar 2025 18:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743272652;
	bh=eNfYS3q/jo7IeKzz1xOmd+nNId1afPO6f+EtrYSscTw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=EF4jOcP7h+S8pMfX5YNGd7XEBHo2wNzUUnZmf+NPM2MupKnBbxDLKyJg4Y42SBfhI
	 Rg2L7Gu2Ha/uDyVJxOiv6VhMWOOUI6wt+iNhTIyIIoykEV2fyYdWdKsGDClvYYKimp
	 Hgf5CXSfWyQ5yjDvjeZqNr4Y2sTgMHmzbZxQy2ffjBy8gcbtELgjEc+Rsca1qdB5bi
	 4d6QkjY/RBvayBVIHKprKXkKRROTsCs8xt9IM0JFfE13e5l5k/lks3/S93ZG0mKSaw
	 yxQIWf+AQK9L8aKa2HcpHH1gOiAYU9YKfwDaM5aYCXM9bCejHzF2FW71dDtZ1QJiXl
	 NXmCgeNyPxZSg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33DBD380AAFA;
	Sat, 29 Mar 2025 18:24:50 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Update for 6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
References: <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au> <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.15-p1
X-PR-Tracked-Commit-Id: 99585c2192cb1ce212876e82ef01d1c98c7f4699
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e5e0e6bebef3a21081fd1057c40468d4cff1a60d
Message-Id: <174327268869.3243059.6128954475859020749.pr-tracker-bot@kernel.org>
Date: Sat, 29 Mar 2025 18:24:48 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 25 Mar 2025 13:53:28 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.15-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e5e0e6bebef3a21081fd1057c40468d4cff1a60d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
