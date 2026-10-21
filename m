Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792547665;
	b=lD9JBRE+3glgsl4yYrGNyumWR5/2PFl5aBxFlBANZ8JEwVQBCZCzIQeFbm4KEN1KDbnn
	 WYwrq0ifd5krfe9j3ERv+LZ/U2cOXvsoXluJPtSeYMZZVsQZ9gcA/0wTH+JFYwmiJ2khU
	 kkwo2mYL5H/UXPFbpanxEABPXFizKXH0IF45ab7c2o44covlueU9kMS8vRTM9oBWDtN6Y
	 jSARbkWP3XlOfIWjwEOZNi8l+y36Vj7obUmhPvTOcwh+MyfUqm2pZGmvvP/987d2dIhsg
	 44Gj3jhO5f7bJC1SIk9OIwP8ws48JC27ahlDUeM/z9VIAERgwUMFklKrQ2IBWdoutLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792547665;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=mO1yiG8KJmLePJg/SvpwmBNa+JmQD/Jhxq9a0QBKaE4=;
	b=zlpImeqHC1XtHUunKWdHzTMwAcogLMAyqpy0hGq0KTA0qhfnxDCiWqjqPFjyqiL0J1zf
	 DaO5yM/huVFZvWlEhLvc9MigUUXFQqrik5RTHkrQHtTv+wcJa53CNgSusiYag9VUfyw08
	 TW8UtvZpAUTdi7EnZYlbF35AhwR9eEsl+u2PgL1qkfXUECLJkKQHCKva9i9I2oRwH2Ohm
	 X5ajDPrNl2B8/xoh3Ra6wCD1ET7MnVPk6XUU2Ejc+oUjuKoZMMACgySthnbZCDR/EO0K6
	 Sc0dtXhjxvO0g8poH40Lu3v57LhjrXi0gQBb+H5PKDH+75voLm/8VGoN0PGCxnPUkDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bd7YZZNk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC6B606A319;
	Wed, 21 Oct 2026 01:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bd7YZZNk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076641F000C9;
	Wed, 21 Oct 2026 01:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792547665;
	bh=mO1yiG8KJmLePJg/SvpwmBNa+JmQD/Jhxq9a0QBKaE4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=bd7YZZNkTdEljQHcNF/TSi8HMKm1zoPVyWLITMJR+l48LR4E1xI4KlBYp/rrrb2FT
	 BGLt2E5jP8MYw5p4Aoi2AXCswIS3LevIOGCSZUFYPhBCo8bAbqGYWaLHYgWG30LlxR
	 Br1w/0R3gXK/KS+h64nnRSGDG4zu9nCoQYysHesGIBEy/yYJBoWJsxRixefjLstY4C
	 4qx9C+JE+1ZKIqhVmAmM95BCIxfjRg6BOCMUbTXj1kED1oDInQs5sWJYQV09ByTDRP
	 WIYdPm94/LOFee7RtPqIxAMKE7vnMYiokbAjBb0elk6YcMtVkVP4i5abIlPfGDIMy8
	 5QKJqRz7Uc1eA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F14F93809A0D;
	Wed, 21 Oct 2026 01:54:24 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library updates for 7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261019023341.GA3270@sol>
References: <20261019023341.GA3270@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261019023341.GA3270@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: 20ec6916d8712e84d58e8c688a25cd368ddeb82b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 95615dd9ff28148e40a3889e813de00274929448
Message-Id: <179254766356.320300.10426801402142180321.pr-tracker-bot@kernel.org>
Date: Wed, 21 Oct 2026 01:54:23 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>, Stian Halseth <stian@itx.no>, Thomas Huth <thuth@redhat.com>, Vladimir Kukharenko <vladimir@genproof.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Sun, 18 Oct 2026 19:33:41 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/95615dd9ff28148e40a3889e813de00274929448

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
