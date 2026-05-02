Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1A138AC8D;
	Sat,  2 May 2026 20:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777753707; cv=none; b=LcBac0nwJtU4IqIzr4KH+u1kRg9081zf/sk+/C1f0SqZw6Pjh2HOjgtQOkGOiikHFhdb4vaHkpC5chi0XtWDqyuDRlZJDpfLeTF7kH/nAlRWXT2Ie1eaVbCaZ6VfWScrZGjDo7hob7XX6qyr2BBjHeAy1zXiw04wmadT76+ixZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777753707; c=relaxed/simple;
	bh=p96Hpc1f4VRm/Bm763Wx4ijW5oZFsgJrrn+D6Ed5WNo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=aLv7wLBmrUeFaj2Acl7TBnrNlySGKYfBAOC+3Uh9NIIeTpZEHQO8yb7U1g6LYCSA7IkCOiQjunpZsUvoTmYbT6da4qZY/Wo5fh+YltNAG5py7Cz9kfzuz+r6+OCXQuweTEVDEqHCHICD9VNa8DxtnD/Vu2uv64onS/93ic/WlyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFpcc9Eq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFpcc9Eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B74C2BCC7;
	Sat,  2 May 2026 20:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777753707;
	bh=p96Hpc1f4VRm/Bm763Wx4ijW5oZFsgJrrn+D6Ed5WNo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=gFpcc9EqtCudfUYO69eZ+BYUHjrFs0H65cNwSZdvFrh2HK5X66uEJGSUdGd7zaq2b
	 YJ30B/97o0rLIc7zsO/Jw5/jReu03sy2swKIIZbw1rOxtz3N0gF7yhlfBnUO0E0WaZ
	 Arco41btcJW2O73b+lx6EVTyixQN+NMMBZyYI1GashcsoOEHb9OJ2gP6OHyxY7An5q
	 YLgjOzy6s64zOw08y3X4x+KWZMi/DIn1noy12NeMMhdhp0BU/fgkgMgrlihC0/1tTL
	 DMkEwphBc98NuADrj2yvRDmyj5TSWbOK0k/Zo8eAWCOACACwhqL6Fq8+7XwSDQX0FG
	 1YuUmwnxcl+aA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9E0F380CFDE;
	Sat,  2 May 2026 20:27:40 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <afWAJTyPunD79Bcd@gondor.apana.org.au>
References: <afWAJTyPunD79Bcd@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <afWAJTyPunD79Bcd@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p3
X-PR-Tracked-Commit-Id: 5db6ef9847717329f12c5ea8aba7e9f588a980c0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 66edb901bf874d9e0787326ba12d3548b2da8700
Message-Id: <177775365924.3928406.5133812754799678181.pr-tracker-bot@kernel.org>
Date: Sat, 02 May 2026 20:27:39 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 2 May 2026 12:40:05 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/66edb901bf874d9e0787326ba12d3548b2da8700

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
