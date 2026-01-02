Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E0526A0DB;
	Fri,  2 Jan 2026 20:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767386345; cv=none; b=tE3B2saownuayNe27DK39Isqgi03DSDq9hwVpiyapTnwimW90AHx08EgAiWTdWShSRYyyMsPRIN5RglsguMcLHsb5sSur/Ko/uRmij89/L8yETGPgdbaYOcQbDe1eiIwViHRNOKGeBlrOROsSkCYPcHXNhkXwAJ2/kIrusn+w9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767386345; c=relaxed/simple;
	bh=qYVGsme6qbi2/lTx2dCMPBDr4i2NzrnzhSnVR1c+Zzw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=I20O14RnQark2QlGhsEbuDJ6X99nugUiLhVGblneVRMl68wb8pAGnM6ke12j7fYurO+SyWalPifP5TUwMDuNQhQJmKeFH7zMNtr+bQQNvrylS5AKI830Z+kLn2/cSS9xLnGsjkDNGhFvz33Mm3icHaJBKdxCtRnByj52CX6qxQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HM1/wxUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HM1/wxUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE82C116B1;
	Fri,  2 Jan 2026 20:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767386345;
	bh=qYVGsme6qbi2/lTx2dCMPBDr4i2NzrnzhSnVR1c+Zzw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=HM1/wxUAyYxW97QktDhW6s7b361Onx8P6EPtO7Z84I9C0WIxOVDBZSYk6uVDT/MDY
	 IwCu8XA+LF/J2P64piZQqPLZZs13fdmXBXWwDgqA3cbFD/WLL3ZHrijnq6p2qHJdwV
	 xEF9IFQoX+S9OjW0iXJmFnB+wOoDXcx8OFfS96k2yYE1Q8wQ5CoMBPjIdT2f41GihH
	 Une4RxpAI5idDmwXF1VuUZW3+BdNe/NWy5S+3APeRzvUOg/h0uHhOIqRqrBCdRbJ/X
	 Jf8c1DPeRwjF+kkxb0IG/vLVlGB0KnVPq0/wkww+rsO1y8q2sq8QtbkhEcTCt7184P
	 Wz2adR3IxHhBw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F2A9B380A962;
	Fri,  2 Jan 2026 20:35:46 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fix for v6.19-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260102182334.GA2294@sol>
References: <20260102182334.GA2294@sol>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260102182334.GA2294@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus
X-PR-Tracked-Commit-Id: c31f4aa8fed048fa70e742c4bb49bb48dc489ab3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dec1ecf2c707ff34aa3224fd49aeee0a852a62f7
Message-Id: <176738614551.4003266.17031594581502151884.pr-tracker-bot@kernel.org>
Date: Fri, 02 Jan 2026 20:35:45 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, David Gow <davidgow@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 2 Jan 2026 10:23:34 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dec1ecf2c707ff34aa3224fd49aeee0a852a62f7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
