Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DD5248F54;
	Mon, 26 May 2025 21:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748294425; cv=none; b=Zqx/6cXoR6Hbpn7HQFuf+gn9xguiV84dzVdX5L4cRSxyj4jd0bZcDB6XhrwRLWgMgisMf693fvCGGQPoaMnVQTy7ro4BfrgXhazLYwV/bPGte/G4AaEOWu2OuSLEA8dV6MyqZXC+dJt7Jhp9lXC2em3xaQTHKFdo962VvsBsIAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748294425; c=relaxed/simple;
	bh=4QcUF2QIlAxk9+Swhgdvlo5jMSObNHQKTJtZSvLDJyg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Xmx4QwO3oS0ac+BDjq8MWCQ2JrESZWBePSZKUGBklieQyl4wQWG6ZGgmwLBO+6rfNBb7Wi1GpTHV5Coya1f5KjvYRz4nwASwMuRp0FXn14GaFbBJhrXD2YrrcLmncw65QGLcItIoBaOOzkdK1nPks405jhITv8dQviOQUqWIIv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Be1k8o2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Be1k8o2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB43C4CEF0;
	Mon, 26 May 2025 21:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748294425;
	bh=4QcUF2QIlAxk9+Swhgdvlo5jMSObNHQKTJtZSvLDJyg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Be1k8o2sbfz+QzRPX8P0lcRqZFZ1ESYL2GvG+8fSx3fZZniQX0EEimmofJ7rlXxaj
	 BcGKC7RmdswE6mdxC6Kv/UqpQxso0w+nPLJESwl4DvdKaTRgvFVGqbQQGF+auISk5D
	 OLv+MDKE8XrC975x5zZQmPk2cOT7K0pcRFpa6Uimx7OlJrRy9pUXYqlENDdiNuXD7f
	 y4KF6PwW6nZKJOWdQOb95oVGGrsGTAeX4ofew3hDvPWBetrKDBCoW8hMejrZPtEoYc
	 bKL+FDvhhOpvtLoWBp5PWqnaGkD3JbmwdJGZP88GVCs7gndFWx346NJhKOKGfSxdwn
	 qRRoeHw1uIPaA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1375139F1DE1;
	Mon, 26 May 2025 21:21:01 +0000 (UTC)
Subject: Re: [GIT PULL] CRC updates for 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250526011412.GB23241@sol>
References: <20250526011412.GB23241@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250526011412.GB23241@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus
X-PR-Tracked-Commit-Id: 289c99bec7eed918ab37c62cbb29a2e3f58fb1fb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 15d90a5e5524532b7456a24f4626cf28c1629c4c
Message-Id: <174829445997.1051981.15334906005383852224.pr-tracker-bot@kernel.org>
Date: Mon, 26 May 2025 21:20:59 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, Heiko Carstens <hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 25 May 2025 18:14:12 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/15d90a5e5524532b7456a24f4626cf28c1629c4c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
