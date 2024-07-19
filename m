Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51B414A60F;
	Fri, 19 Jul 2024 18:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721412580; cv=none; b=Zm1YRaLnglkJIz6Zc9k7fSAO6MJx7lFE1/S4TxCrUMI8GXq3NL5ztWL32RAsTRpXaHOg8fS+KYblqtAXCA+VlveMCSZQldGy2tIRgsGcZkFUVtZCzc2FMkEjVj9cBofNL7hfQSvqPe+nXqwTyUJdlAZ3r/YeG78MqpyeI1hu5G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721412580; c=relaxed/simple;
	bh=8zheA4hE/fXlFCGnvo4NtcqKaIf499iKmfrOqpWKo6o=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=aPQjVmKOxI5mu5AfIM3MJnLBqLmNRLE7XYiqq8MMlz8JcSemam+EViTMKBvUNfXixL3WjnqpP99lbm/0yLAvxo8St919UKh7gO2Qc+Zql3Z1hebwISywpyyJNV1dtMIzuUIagSdeqLBXZotsQH687hJPzi1Q57pOIJ3halVpz8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G33LoK3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G33LoK3y"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 999E5C4AF0B;
	Fri, 19 Jul 2024 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721412580;
	bh=8zheA4hE/fXlFCGnvo4NtcqKaIf499iKmfrOqpWKo6o=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=G33LoK3yTm9wzy7n4Dx55EPgSTDCInO1lc5ANAmja+8773gBar/LrWRffbASQ8PTS
	 v1kUZEuDjGwwNdeYbaG6WPQz4nrNEznkLhs1FAz7QE+MNclMz3xB7Lrvdd/GPm4tg5
	 FGp42EF7GuEjDbMy6TJ6lc7Yqr/DoJLF79YUY9uKLw9vQWoaghFj0KrkLmO4GUpCdJ
	 TDiFgW5tRZ91QnKJA24KbFHh3dc/s698vyTUZJq0AOlObPFP+bjO1yiDRw4oTwdcjx
	 JnpYGH5nZRMujiL6a114q9MNjFuRQxBSXDc9iebjBpoxbDCPKJttCDA2vDkIAqzgzp
	 LGNwfmnCYxRYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9024EC4332D;
	Fri, 19 Jul 2024 18:09:40 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Update for 6.11
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
References: <Yzv0wXi4Uu2WND37@gondor.apana.org.au>
 <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au> <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.11-p1
X-PR-Tracked-Commit-Id: df1e9791998a92fe9f1e7d3f031b34daaad39e2f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c434e25b62f8efcfbb6bf1f7ce55960206c1137e
Message-Id: <172141258057.2862.10259587371562814962.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jul 2024 18:09:40 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 19 Jul 2024 01:49:26 +1200:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.11-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c434e25b62f8efcfbb6bf1f7ce55960206c1137e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
