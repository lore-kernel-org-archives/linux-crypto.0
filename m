Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4246613AA5F;
	Mon, 16 Sep 2024 04:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726462523; cv=none; b=tWgj13HLg3BxJgY2aENCy6fBbcflnyb2bhQwv2kcdr6nZl5GvH4rlBtI9ap8kcFm4PnzwnBiFxr2mGR0DNhiuBnIvVR8eLbUeRnHskgqPgOie0nThmL2vb2W2CX6lOpLFXfO+dl2piP+J6+8tg+tTERnhlTsFoGN/9gj7ydBzIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726462523; c=relaxed/simple;
	bh=Q96zhx1qwnoxMs9+rsd3+/0l/tJnp0elMcZ1aR1HwwQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=oLcDQb+sOCqa2Sq8wNlzDATx5tDD9HL7kwr90sBCcAGfxoabRmNpi2ZkpxW1og52YNLRvrX7eGV98pzshEzaqNAvEvOmhpjc1KyckrrDegDRwoqOaN3MDlUDowClwp/tO4W2df4WJ46sla7RIXe6OEU8sAlSwNG8jEVbPUY8BJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cd+LMHGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cd+LMHGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24A5C4CEC4;
	Mon, 16 Sep 2024 04:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726462522;
	bh=Q96zhx1qwnoxMs9+rsd3+/0l/tJnp0elMcZ1aR1HwwQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Cd+LMHGxcA5psAZ670+Fx4rsIIXY0HLU3GqACWyOb1/CSWpSAKzUc6boMib+kB+G0
	 HoaQq5wZBxgEHr3+vD1hTrp3gu9sboBJ5pwkIWeLwHlFKbFMv/3M/hMi/wA52PXmM4
	 xr85RmCo/LjFGsLYY+aJdYGCVzN9KJIHs+pnTgQJT6n936RuWO9+c0FKKm7jh8VXd5
	 jMgTp3f42ehr6ACHo0kK6NJG948qrXneNCqzktVQWt2jT5w0qNbvEOTpKZS8eS3E09
	 zyCecWwY9f1O9kAFdqHqXTW8UudrhwMjqKDRFQ+iE23NH9RaIMFINTZIXFhZ4Kmo3t
	 0N3ZCd1edqIEQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE01B3809A80;
	Mon, 16 Sep 2024 04:55:25 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Update for 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
References: <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au> <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p1
X-PR-Tracked-Commit-Id: ce212d2afca47acd366a2e74c76fe82c31f785ab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 85ffc6e4ed3712f8b3fedb3fbe42afae644a699c
Message-Id: <172646252417.3235832.759034537058096675.pr-tracker-bot@kernel.org>
Date: Mon, 16 Sep 2024 04:55:24 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 16 Sep 2024 11:59:01 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/85ffc6e4ed3712f8b3fedb3fbe42afae644a699c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
