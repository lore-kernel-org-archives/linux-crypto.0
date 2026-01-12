Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B04339878;
	Mon, 12 Jan 2026 19:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768246916; cv=none; b=dO4R9tui+B49zVGWyWeBV4MTluzdDJNYYgs5yi0LqGfF1EGITMUFYXfVsB88A52tozhDp4b4TyMSUZLOL2Lnch1LIg1ErE785r3Je/TdzQP4RMCArDasQGj1DVEgHZkFC/vxXFcMj/gRckppKWjMGYDROs8DHanW8cpsa/GCfQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768246916; c=relaxed/simple;
	bh=jXXnRFAkcb4K1vgRE51siMG7Rs8YLTeospsnKLwFyJM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=L3XUFFoVyMB04lOu9AWm4Z1CRf+FyQkMtzxNfjoYhmWaWo5xchxlntu/hSYB5K8W4il4eS5E2vgtwcgTYpjRFe8sn6Gx8CkAome9dUUSJ4/dAt72J12+wFFDpG/LUVPqugNd+tgnqY0EfV4bUaIkr2oR76xaSdHcvA3qcRYVj/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BdrjP8rr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdrjP8rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AFEC16AAE;
	Mon, 12 Jan 2026 19:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768246916;
	bh=jXXnRFAkcb4K1vgRE51siMG7Rs8YLTeospsnKLwFyJM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=BdrjP8rrronFFwrKjzneh79Ws3mUmPQCtfGdQx/mlZ5z1TL+f00usxKwD1Jv93Lgk
	 T1xBC5qqOr1uwjQRTj7S0mXLM6IvhPJoxrBFO40gi0SHPh3JpjMgdXNBe0/oHEThZj
	 8FXJhBm3aKjadc6Va8LRWO8uafTrKwZr9T9w7FNkEKz0v2AL75AW90Mszh02B8PvXr
	 3rSxgSX0epzfcCwmlhTrPNhkUKHsEjzwPpla81OQi8hG/EXpLxbx92zde6Q9eESBmy
	 MyJuCVloSqM20a0Hbt+AjYOKYv3QUvu1fC7ViRX4OwuIOB8py+/GHgmzDBoWnHhDQt
	 bjQ5oAzWlmWpg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 78ADA380CFC3;
	Mon, 12 Jan 2026 19:38:31 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fixes for v6.19-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260111193909.GA4348@quark>
References: <20260111193909.GA4348@quark>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260111193909.GA4348@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: 74d74bb78aeccc9edc10db216d6be121cf7ec176
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7143203341dccbca809ba0a8e72239ea4652ace6
Message-Id: <176824671012.1091852.7378273717811695975.pr-tracker-bot@kernel.org>
Date: Mon, 12 Jan 2026 19:38:30 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, Jie Zhan <zhanjie9@hisilicon.com>, Qingfang Deng <dqfext@gmail.com>, Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 11 Jan 2026 11:39:09 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7143203341dccbca809ba0a8e72239ea4652ace6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
