Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406031DB356;
	Fri, 27 Jun 2025 05:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751000907; cv=none; b=m9oX8S0Z1pygqgUmMv4sYfJFyaVHgW1nas6AucJCGo6GS5cWGUH6lT3Hg/udSY/FIE/reSPCvGo7sZ0HFLmQ62s03uTUBiiOh2Td/rpxQeaZ1v6Qo5JmHtNtoc125BkDn0iYTkY6TinbOJSnPISP2UECMark/SWk3IwZSQgNSfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751000907; c=relaxed/simple;
	bh=7BCxLiFnqDOAZEBIHj8b+6zGHSSyO+aPlOtOXb3V6no=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VH2mEks07RmqyRM9H4xIhoKRHyvbavjJYkoApcnakyD/6X0lb4v0t2+d5FkJWEdCrDX+pUWNWz9WlgC+g70k5zMZvVKzmJc3MnFcoP2yw8tXjNTwAZghzELxCO4zxGMJTiPHlBZ8261ug9ziXmhtuSzAdVIhuw11HdAW5QBOPgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oGRkucjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGRkucjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EF8C4CEE3;
	Fri, 27 Jun 2025 05:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751000906;
	bh=7BCxLiFnqDOAZEBIHj8b+6zGHSSyO+aPlOtOXb3V6no=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=oGRkucjPxUIae3IV96cOdJJWrMXlrH4ijTfUSacQVs9YfgF+9hyAbHIik9lmBNsfO
	 t17RrpqHdiPyCviQjiUQ/axhV58TOzvZ9Wqb084ukt+rpX9zl9LUD1OU+Sj8kY+uVM
	 Kmiht4Iiyf9Xq4MZE+6f9ReC9c0lsGSeC9jbfVWD1WmjAGfv8/dgwY2Qs1wHwnf0Ef
	 NjGPEQoqn66npAgtf1oOl3K54cB7F/fddnSaefYBCIhEN9zxJ0n2iQ6ZigTPIMe9MT
	 uXqsFH4w++MHC4IYC65iZ+/XTpbU8cY4XL/J9r9T5tsTjRxblowvnijLuUwur8b29/
	 uIEMC8PHDyqUg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33E763A40FCE;
	Fri, 27 Jun 2025 05:08:54 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <aFtidDP6MLX1V2A6@gondor.apana.org.au>
References: <aFtidDP6MLX1V2A6@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <aFtidDP6MLX1V2A6@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p6
X-PR-Tracked-Commit-Id: 20d71750cc72e80859d52548cf5c2a7513983b0d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 67a993863163cb88b1b68974c31b0d84ece4293e
Message-Id: <175100093273.1434667.621269751591627404.pr-tracker-bot@kernel.org>
Date: Fri, 27 Jun 2025 05:08:52 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 25 Jun 2025 10:44:04 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/67a993863163cb88b1b68974c31b0d84ece4293e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
