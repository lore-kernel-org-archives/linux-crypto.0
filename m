Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652233D561;
	Tue, 14 Apr 2026 00:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776127102; cv=none; b=bM0QyMTYWno8zu6v15BzoaoWjXEK5AlbQnLFYdD1EXQ/YptL+Y/wqEo7huJ8xkJohkCrHd83o0RQRrnpqHnUGFinpinn7bS599Zvyrjno4lChql7I8SHtjRjLyUIinCNu9NVyiTL9Y1JYviKwWw8MTQi8WIUNjxDG+cXpPVch5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776127102; c=relaxed/simple;
	bh=hHa+fbgnPntiN856xJNJCBs9hbW6P/Jq5FWYjMmPZto=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=s+StMQykEgp38+wyFh03LW6q1UmvAEw9Uxi8qddlbE6WczYUdgHqOVAODUe1Vx7xQmkPnd5JlzUTxoXojGpKi3dEKt6zxvKI6Tss+4G6nO7sUKwvqbAi7gk3lhQ4jGxsI/d6GmVmdZ8judXJf16h9j1k3gUt5S4LSFaZLaqlnfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vzbiz8t5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vzbiz8t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17904C2BCAF;
	Tue, 14 Apr 2026 00:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776127102;
	bh=hHa+fbgnPntiN856xJNJCBs9hbW6P/Jq5FWYjMmPZto=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Vzbiz8t527DrfZzcA6P4LBXTbSOBzc8Cd1g8mquvgnkQRrmhnbap6xFIlCYwariOk
	 Yh7w7byfW5Qg56xJmX2N5NIqPzjKSMjIUfOKay9tRvumsdhLaiJ2FMEOQUwy3x5RPN
	 xeGNXfUwyvHAF7AruiSHsC0+C3HOUellUmyfdqfgn4GPDHM1Y/cVYb6CJ9gFsKaMxK
	 DzuBfrZPHCr7LdsmpmQ2WVHZrIzRVW+EQm/NIA4dSG2KUwg7o/sR0nS3Abpk3bo6Us
	 ZVTuPl/aJ7AWautZs3/p+qZUwYLefHUFwP/8YWcaXigvIIJhPkOHGUw1DAcMX+xbFS
	 s6ch6oLzbvkmw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D0273809A0B;
	Tue, 14 Apr 2026 00:37:54 +0000 (UTC)
Subject: Re: [GIT PULL] CRC updates for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260412002343.GB6632@sol>
References: <20260412002343.GB6632@sol>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260412002343.GB6632@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus
X-PR-Tracked-Commit-Id: 8fdef85d601db670e9c178314eedffe7bbb07e52
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d142ab35ee0b7f9e84115fe3e4c3de4a9ac35f5e
Message-Id: <177612707317.625472.91099862803652965.pr-tracker-bot@kernel.org>
Date: Tue, 14 Apr 2026 00:37:53 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, Demian Shulhan <demyansh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 11 Apr 2026 17:23:43 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d142ab35ee0b7f9e84115fe3e4c3de4a9ac35f5e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
