Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA79418CBF2;
	Wed, 16 Oct 2024 20:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729111877; cv=none; b=mZJBuwnMu+u+Aqrkb1KAU0Mr7QmNwxT5U7r7+C3KcErLyF0zXpyTo1WnA65bXxflOV/whYedJAFKGdgWkTmWPUY9EP0SFfE4cArb0VQ9eBXd5KxcPd4a/NVTNlJuaVsuVvPYU0ci9YlXKs5if3FwBn3N1GG36bZfz+tsaKo7Hyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729111877; c=relaxed/simple;
	bh=RonxhO10pQQTlclrveWQs1F0qTeIr+6A7J8x1FFUmVA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lIjH3cvnUGpUrfo4hfWHLN8OvSq80Ull444DzJD1FUef4T4B1SHb3Zo3B+tUw1NUGzL3Naimjl5nnIuNGxkZC2B1ix0sj+6M9wm1klJ10bfZglCanwQKEIji2OPNOlkawXYAiLX6Rkb+eRJhfO2aGoYsBKGfU+1hjvYWABJFxM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rHAyUZ8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rHAyUZ8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A507AC4CEC5;
	Wed, 16 Oct 2024 20:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729111877;
	bh=RonxhO10pQQTlclrveWQs1F0qTeIr+6A7J8x1FFUmVA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=rHAyUZ8OUyCFkqTcUDOdY1F3LFG/UsQSKC1FSCTSlNxN8P/pXA6qrOwsvlmlTt1G/
	 2fODtzXVM6/ZCSqVGMY2n1XO8QyQRClH141ApD9D/cWJBNnXZrq5MLT7aWUpWM7N7q
	 +7CYoRpo7nfkVEdNmxWiSuszqUrnwAe87kUk8W6BtYunP+QpFw1gFmhamlofWguDX0
	 jbJcCUzGif0cqE/RuEM2Ub5ue190TVDzsFGWGPrfljLQz1x6Igkc0KG1DdeVz2anFK
	 hr2JIYc6w0UBOOoGyJ/6jbkvwc7C91gJHPIETcsMNZKFcVz1COwFh2mKpWcYyihs4P
	 NVySnqIiUue9w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3423C3822D30;
	Wed, 16 Oct 2024 20:51:24 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <Zw9RM_jNu9vqp9T8@gondor.apana.org.au>
References: <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au> <Zw9RM_jNu9vqp9T8@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <Zw9RM_jNu9vqp9T8@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p3
X-PR-Tracked-Commit-Id: e845d2399a00f866f287e0cefbd4fc7d8ef0d2f7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6f6fc393f4dbaa149962a4662f5dd08513c28905
Message-Id: <172911188290.1955101.8167362156672429096.pr-tracker-bot@kernel.org>
Date: Wed, 16 Oct 2024 20:51:22 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 16 Oct 2024 13:37:55 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6f6fc393f4dbaa149962a4662f5dd08513c28905

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
