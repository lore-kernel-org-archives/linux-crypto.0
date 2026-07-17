Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5627537FF7A;
	Fri, 17 Jul 2026 20:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784319463; cv=none; b=VmROA9zREIiLtF82FB4GWCLELdtbZiXyk8HLzfNNxk903gkrFW99EizTK55gjAvd3TKNWVRQp94/hyDAP29x16JoWIIln113C0BW0LSg7BQfpDnpgT2NETkd3xcp4xIE0OcKWWNof1TcUPSaTr2lwA6dAYhR/cS8FA5JBnrSefE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784319463; c=relaxed/simple;
	bh=Ujaf15x6/zFiNiZQK9lbAb0Xa2IDEIiX/4ukAgGcQm8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fBJtLm/fCWAlSFRePqIzSG+rT0zUERz9/su1YBL7U11wET0B0yfIdLN7n6sFbtZNTB2i7BDqng1r98u6+bS4CIbE+2BcwDqJN9sT+z/mVIwc6vef9uu6UWyz+4ZMtg5Phnm7RfprUhjBjAc9wvM2rKW+ZjTNWhhwF+Pfn2CIpN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNba8DN7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNba8DN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6841F000E9;
	Fri, 17 Jul 2026 20:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784319461;
	bh=sboNH7c9evuIPN+QZbHw11wakR9EZSplwacBGdc7Q88=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=oNba8DN7gyE/djqq+OAByE9CzJLpPUa71GWxDAvt7a9ZGN2xe9lt8/tY9fqru8D08
	 BqOqeUtHhvRZqKUQfnFLR2vml0+/mitfYYHgzoGniBGAwQsI2mf9MWmcnU6LevW7ho
	 IAkMgByq2kcaIbD/7c5CTqv7S2zsPajxc2uOOSxjvsIsZtxexFGAo3St2UUMZ3frR+
	 EcanIWq8F2brP6ELGMM/5ejtoMJxqf8jyLJg+igYk8nX8KjCWOiTNl8Rryh4WoHm5v
	 ymZEPAok9Fa4HsRqtXks/LWbvflIr8ZkyxzLP5Bxf0p2oTSdu5FVqImIFGJScGYiKq
	 T38FgSiPl+VMg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93B9B380CFED;
	Fri, 17 Jul 2026 20:17:14 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fixes for v7.2-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260717160746.GA2046@quark>
References: <20260717160746.GA2046@quark>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260717160746.GA2046@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: e073f1238ecaea366f53e98724c40b31856da56a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0dde292a4c23090459655ada697e948ff4adc7c3
Message-Id: <178431943320.1854741.4995862756718009789.pr-tracker-bot@kernel.org>
Date: Fri, 17 Jul 2026 20:17:13 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, Thomas Huth <thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 17 Jul 2026 09:07:46 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0dde292a4c23090459655ada697e948ff4adc7c3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
