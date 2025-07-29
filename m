Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85B51A00F0;
	Tue, 29 Jul 2025 01:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753751519; cv=none; b=tkSmhRF4TXFJlPLYT5mjKHITwVcdVdoZIN1KCgzcV3xig9fr7jCwtJBpdMaXU86fXe5nyP2AYZf6XOwUiXOOV+2jjb/dJW5xaPGirBL/NH4WEQEp6AkHgosvkGWP40hWcmGzIvEu8uTk3g/WY77uFVCFr5EgE/ziW/xYt0n7UjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753751519; c=relaxed/simple;
	bh=VP1id6GCghcLZyHfrUd+AivxE8vN7brpXwy47B/7AFA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=XS6fNu9V5Zq/OSsENdG5JqOeoIECcdrXe9oa7JQfPbDnL+0Q+FxGwW03QDl1O7kmFXkKEmmBt+xHMnRdTmQpaeCu7VHaiDKpb821O9jTWUKy6DIiqNx7zlHobfLI4Z+F1KUKzjnOuEF1iAMtPRWASXAoi31DUf1in3VRDYsyNpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZJ5wDjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZJ5wDjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB622C4CEE7;
	Tue, 29 Jul 2025 01:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753751519;
	bh=VP1id6GCghcLZyHfrUd+AivxE8vN7brpXwy47B/7AFA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PZJ5wDjhSkzf9Dqik6h97ZXIQy/oatMQKwzPOIdYdvJfRw/ZoHrQ+LNuAOFWvw1ht
	 MFswOH8VgzssbI6hOBQM7IIr4jI629zrX1Zn5cigAmjRWH/p5LDNgOc+b2l8C/XFnA
	 ZGlP6KY4LM6FfCTKJPYJHA59mG0np49+Djs0TeVN4u44AwFaXYtOmmbCQzcgz/TJbH
	 1FvgBK1+M3bTYsYK5pTsTx8gAhSs6qLye6cscHT+alRuTZRQIVS4zmOrBUQUAwbson
	 asU6sz7rwFMUOJRZBi1EpggqYeMFqz9cOlFS/6s/hvTD1LEAUf+N8LKBJsZTlJ2cyP
	 6bmQArmcFIw7A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7159C383BF5F;
	Tue, 29 Jul 2025 01:12:17 +0000 (UTC)
Subject: Re: [GIT PULL] CRC updates for 6.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250727233644.GA1261@sol>
References: <20250727233644.GA1261@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250727233644.GA1261@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus
X-PR-Tracked-Commit-Id: 118da22eb6fbd48f896d17411f942399283d600c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a578dd095dfe8b56c167201d9aea43e47d27f807
Message-Id: <175375153610.918485.7607442013005860591.pr-tracker-bot@kernel.org>
Date: Tue, 29 Jul 2025 01:12:16 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 27 Jul 2025 16:36:44 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a578dd095dfe8b56c167201d9aea43e47d27f807

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
