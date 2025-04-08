Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3BB14037F;
	Tue,  8 Apr 2025 19:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744142056; cv=none; b=GcD5vAbPP9epA1SBJg1Ie1/OQQcswJzMCDI5r2Qs+mYHi8pvVulxeEpNEEPStfJc7l1+c5tYCbdN8AuoCUp8kh69yivuZZOx+ib/DjBQe9PrkO5+0UxXeam2KweUECiblYDlBtgJmWLFuAmIUOg9Ih9lwAbHAuo/4H8HzGBke4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744142056; c=relaxed/simple;
	bh=lD8uDjCoWh/8BZS/h9c2q3p508Uhqy1YGOGyHlmgz/Q=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=AePcLKKThM/WkYJv+pZiFoWkJvsgV7e86QrSoTi6fxKQC7eDvUz1y4sBD2QvXzPKnbev5L+JN/8Ye7+Fv2LmY72T40oY5nvWR8GVCkS2aIo5rBlwkOFED960AwNRXXTQfrX82CL6J4TXbHDxu5OrNr57iREcspN79EdKBzvDnps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4Zzq1ny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4Zzq1ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6904FC4CEE5;
	Tue,  8 Apr 2025 19:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744142056;
	bh=lD8uDjCoWh/8BZS/h9c2q3p508Uhqy1YGOGyHlmgz/Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=U4Zzq1nynnq+OuSbxjdJYXKa61DdEooUmr2xhFp3Sy3K6/wxv2bzv+j/e9H+G6osG
	 Fi+3L7pNmAFOkRVIyOON6ZNvDHRbDUTLmBBi27gftEUZ0qSW++FWtj+0DXqEk5lXvK
	 qjroHZxrGZl00AYL85Q53IWwJkx03tC0ZPq35fEJ5AaCvF2dkh4ATv6Rqq3WC6veNG
	 l++CRpI147+/lKXY32ajhFDCgZB9bhqv0f4AR7Ry7XWxDMPk5FQHf97yq8v6E0qUjk
	 OPPpz4Ta/8wspoU4LIH0NSLo0W4CCd3x6ggxtnsacyEVTRPZfE22t2wZl7FAMiTdN9
	 W6w4Ix80F+CCw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB36B38111D4;
	Tue,  8 Apr 2025 19:54:54 +0000 (UTC)
Subject: Re: [GIT PULL] CRC cleanups for 6.15-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250407162706.GA2536@sol.localdomain>
References: <20250407162706.GA2536@sol.localdomain>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250407162706.GA2536@sol.localdomain>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus
X-PR-Tracked-Commit-Id: b261d2222063a9a8b9ec284244c285f2998ee01e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 97c484ccb804ac07f8be80d66a250a260cc9339e
Message-Id: <174414209360.2111430.10442056540793161632.pr-tracker-bot@kernel.org>
Date: Tue, 08 Apr 2025 19:54:53 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 7 Apr 2025 09:27:06 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/97c484ccb804ac07f8be80d66a250a260cc9339e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
