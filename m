Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A62336CDFD;
	Thu, 21 Aug 2025 12:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755777657; cv=none; b=YrNbffm0CA32aqqclZM9VoO+OhYPP7BXpkkGx/++u6sXjXSJEENqCkXKVIc+q2SmSRJz/E1TQf1bRQQ+i0NPWqb8SfHq7S2UsVxWt6OuADG8E5ONcNSMTJLZzK4Xpm7xsSCayzaF/La8hoO6BPcOOogQB8PcqFMkn7QEpoN3yPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755777657; c=relaxed/simple;
	bh=0If7dBB0sCLIUEXZ2OkN2bJH+rbHuRFSthuH8PWLWxQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sEZTvqPr1WNEtIvcHAuvJxhgNq1dVocwwRxLYKvsR75A964c1GVLe2r0j9TCW9cVTo7+1SqmoJvXFFWZ4qal9lbhwTw5mW/ahweBl9PX4p8744zHURkIJqk04d7AnCUu5UIT6aUmqZnAtUvxhYmpdWt+/lx7L4IteS+lQXjhC9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQKI7AtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQKI7AtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5202C4CEEB;
	Thu, 21 Aug 2025 12:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755777657;
	bh=0If7dBB0sCLIUEXZ2OkN2bJH+rbHuRFSthuH8PWLWxQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=UQKI7AtXBg0iBmKFt6mtmjw4pKfHYoEmaWoLCMbj+nAF1ZfDpPk7Hv1vxeLRaLh8o
	 MFc3MwqcrN9aKiOinqIWGHj4u4N4wopkPksDhcwC07HhMWbvAl91Q8qx8HGUvPTJQp
	 hYxJ8IVuAoxuVIwoLeVaaTsjjzehqGxrKH5AVEEN1CA1OfMHwFzIdNrCTtZeLTEXFo
	 45KujCo5cmQL/kGuau8ApIIEOKLArgAD+/+hzA+tyJbNH5SJNboQfw8yLlTEPRgeA2
	 jFduqLB1VMBAb9RZucq/DlSLRHXJNSaOWmHuSztXzVeDHj7YFT/xtYE6xSwKgqGxpO
	 nL7y1BjoQ+uEQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 715A2383BF5B;
	Thu, 21 Aug 2025 12:01:07 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fixes for v6.17-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250821033420.GB185832@quark>
References: <20250821033420.GB185832@quark>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250821033420.GB185832@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: fd7e5de4b2eddd34e3567cd419812d8869ef4f13
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 32b7144f806e231a3fb619d4ddc5a6bffb731715
Message-Id: <175577766591.1009012.3319634323445862102.pr-tracker-bot@kernel.org>
Date: Thu, 21 Aug 2025 12:01:05 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Tal Zussman <tz2294@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 20 Aug 2025 23:34:20 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/32b7144f806e231a3fb619d4ddc5a6bffb731715

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
