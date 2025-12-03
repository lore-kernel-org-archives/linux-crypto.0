Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CA6242D6A;
	Wed,  3 Dec 2025 03:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764731690; cv=none; b=nCxW8+S3wOHWH/HLXCm1SAbCAYUZAi1UY9s30YdmRukz95FSA0LtG+LLgUPjlXlyQuvvIsWY3WTFLEs7NRiICcrYvnCLTy7/knNBA92lLFG7ctIE49LqDbmS4BhYyE0NXat8SzAleyaW+2cUDrMd+PAHE89SGDxTA1uP7fcGeuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764731690; c=relaxed/simple;
	bh=CmH9xGLeKbwAGZm74e9TZSo5bkmGGNnlbjDyRkgJFUg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ixTQtIJGvBUCDgDrPMv5DmW4Tzq2PD04KWt6OEKv2f/Sh3JQlQYZaBBcPopPXjNBeW1crolvzQybr3ObMhaci1unkTPRXe9LGShUOcvwLpv+teJ6MlpPeikSdEs4EcigZfkRA0eTyRnh3Bku5UsxxDu0xYCba8eWJHhVRk/hYDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5oqCFbu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5oqCFbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3A0C116C6;
	Wed,  3 Dec 2025 03:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764731690;
	bh=CmH9xGLeKbwAGZm74e9TZSo5bkmGGNnlbjDyRkgJFUg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Z5oqCFbuFokGoXlBjvBSGIsD5IQdTbybjgEgo8fFKFR7bU1AsvedHrsuJZxaiiC49
	 W6gCOwHAFMHXHLoyUsH/QbiJIh4Z+iP2kscTHuQU0Gi2rQxh/clREMUsOqr/JuUrOs
	 b4WOFV/ouolsyoUA0CNbVnnAGdpaOf/br2skjZy1NRH9ygIWaSLatPGMFIaInW03YR
	 qXctpM1uIfxHvgguRfp+3Ii+flSOZRfpNogHo4CeMWh8GZql1DBLr7V5OiWuzdtWv2
	 6U50pqmBa1IWEO1OwozljMBQT8DH6A+vwbG7O/KxKKv1n5r3FM673GhNBJBfDRM5D5
	 ZKs9xYQB1ISEA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 788803A72A63;
	Wed,  3 Dec 2025 03:11:50 +0000 (UTC)
Subject: Re: [GIT PULL] 'at_least' array sizes for 6.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251130025006.GE12664@sol>
References: <20251130025006.GE12664@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251130025006.GE12664@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-at-least-for-linus
X-PR-Tracked-Commit-Id: 4f0382b0901b43552b600f8e5f806295778b0fb0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 906003e15160642658358153e7598302d1b38166
Message-Id: <176473150920.3498170.2716963658148999631.pr-tracker-bot@kernel.org>
Date: Wed, 03 Dec 2025 03:11:49 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, Miri Korenblit <miriam.rachel.korenblit@intel.com>, Kees Cook <kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 29 Nov 2025 18:50:06 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-at-least-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/906003e15160642658358153e7598302d1b38166

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
