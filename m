Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA5114AD20;
	Wed,  3 Dec 2025 03:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764731685; cv=none; b=WeQtTTBUdJhKyaAdLrvauk5YpkyM+djB1HV+8HuA3kSr2RRCXhYI+jdRgt57lyB4B5JqA1jav+VuuVz2+O6Eq35mHs4O6u8T7qLdN92AWL6SRYTq37mhpoHu+EmYB/UqxmIa4LseHpiPFl92zCeDbA2LmIc2mY+T9ER0hz4uOQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764731685; c=relaxed/simple;
	bh=3930XIrMlQ+86AK7EJsWH7FiioNqV9f+jhWid1SDJAg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=K5jOgOgKMugJZCWuHns9aaFmxoH+fVNVpHeNbTlgV/0dfRRHXzfWETXAKm7voE8sLt3cR2EWUazrzfjFQ9WD/NGYeSH/GPsla2tiPDFIjJFU1n+WMx4ok6S+qxKWUehMusJ0THiqBSJC+jrjaV8w99UaBzBmRAoXMxfGj+zXz6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hqWa5y6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hqWa5y6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D077C4CEFB;
	Wed,  3 Dec 2025 03:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764731685;
	bh=3930XIrMlQ+86AK7EJsWH7FiioNqV9f+jhWid1SDJAg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hqWa5y6C7f4d45HzwK7ilsGDMgs5fnu6lmVk9vIcvfmfWUglkN8uWej3umW57aSMW
	 C8hYi7U+SJZIeatqVShUwE0U5tp2vqYkqrGo/MUwZunbrpQtJQ3Qefnud/xXHwGAf4
	 z7x4HrzK8tIrtuPuOyBDzLkhIZrp3p/UXo+Z7XAlHsrShASwMzepZp5faretde3JjR
	 G/COou7gRlMQXVhlteBvxLiPR8eam/pcmpBg6cUPPa2hy2pH5spb13VSazLDZDqrp/
	 PvLNG6QfGA0MusfbD3mj2ugWYMdI0OXrNGy1mEoPbU3x97rlQGR19li/GKO5GLxVs9
	 d9o0QaI7/bkdw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 789923A72A63;
	Wed,  3 Dec 2025 03:11:45 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library updates for 6.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251130024212.GB12664@sol>
References: <20251130024212.GB12664@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251130024212.GB12664@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-updates-for-linus
X-PR-Tracked-Commit-Id: 2dbb6f4a25d38fcf7d6c1c682e45a13e6bbe9562
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6401fd334ddf5e2035a0dca27cd761974d568fcd
Message-Id: <176473150413.3498170.11215890861414688134.pr-tracker-bot@kernel.org>
Date: Wed, 03 Dec 2025 03:11:44 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, David Howells <dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 29 Nov 2025 18:42:12 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-updates-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6401fd334ddf5e2035a0dca27cd761974d568fcd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
