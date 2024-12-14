Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9052033A;
	Sat, 14 Dec 2024 17:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734196678; cv=none; b=V3ILPjCnFQ+/FIDIy7NEQyVbM61aVaSqjzPR2xwpOHPUxUBdkaBWXfxiOG10J57Zs05TIjSnZmtDt4LSTFOBzfwTthofCuLbfPcnvb5D9vyjYGLr08pmWkH5aKLCpVs/MXUlx92u6R9ptUNbJvld31I5iSFgp386gMXEc+Fi0/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734196678; c=relaxed/simple;
	bh=SrYSqTYhMAMdYpLDzifSCyAbgsJ3gl3o3iYk0OX5FQE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=E3ZCI9TO98dBKSl3pRV9AVKpE1tCuASaXr1kmMRH92VgVoO1a5zaW+lyuijs43j/8RUkhQKxotzcZvRMP73tdHFyLBFFQHm4m7JxiwW8AndUkIQ+RCRN7jCCoE6jI51aNQ0A7D0M/KzZugpJ5JKnD1dQDk6WmyH1OlHOmBwXq/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rSzGYLBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rSzGYLBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE21C4CED1;
	Sat, 14 Dec 2024 17:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734196678;
	bh=SrYSqTYhMAMdYpLDzifSCyAbgsJ3gl3o3iYk0OX5FQE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=rSzGYLBWIKMn73LLVJ/eDK115BLTlqZ5NbZBq9lfAtmRIpeyHcLaMB1II9i3+yySU
	 yEIqTMv3pa9ct891fohK/JkbUbqquWBgzzZnh9pUiRp+HVjwUr+AqPhYED2Q0qQKSN
	 KqshyxTWifusjHss9+Ba0LHo9TW/wPFIGL2j4KhF+AG57y+4uzf3vFYqDosppf/Wcv
	 tEXH9x4nFSsgufpUqHOIrRGOvrSYtRd0xMMKv62QCYjA5Herkpks4N9l3JWGSPeYdb
	 4XQ1YlFDCjalyh3ojVJOvO5Dm5pA5gHOz4mR4UBhMShLMAac75k60zlRZpvL1YP1vj
	 9z5NZl9WWCHUg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB363380A959;
	Sat, 14 Dec 2024 17:18:15 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.13
From: pr-tracker-bot@kernel.org
In-Reply-To: <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
References: <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au> <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.13-p2
X-PR-Tracked-Commit-Id: cd26cd65476711e2c69e0a049c0eeef4b743f5ac
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ec2092915d60df2700f7062f171a7fbbad93166b
Message-Id: <173419669454.3361629.5467310783517180575.pr-tracker-bot@kernel.org>
Date: Sat, 14 Dec 2024 17:18:14 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 14 Dec 2024 17:21:16 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.13-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ec2092915d60df2700f7062f171a7fbbad93166b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
