Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D6758E2DE;
	Tue,  8 Sep 2026 16:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788886189; cv=none; b=B6j/z3qOcvJdcevXy00XET7zo4ZjEr011Vlg4TBO9auRZQcYdM6YMD0xJMZ9cZSQZ7xg2Lag0AYL355QRC1Wa8q7H71g/+4dGexFT6Qa7SEtK9GwV98Phu02IeIScq7XVSQ9yuMEHO3tR9mRt5S1VhJGg0ixUAeHlX/V5UvYrB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788886189; c=relaxed/simple;
	bh=Q7dYLYkg7WMyS4Jj2hu0IFEjCWA24AyWvpvF1S8llxA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=IcHjGEjpSEoa1Iz3ho1zvVAt0l+s4t0xR/G1AFUhMVIgIrFuV6H4CUu4HuABCNVXFlP8ipKqK61EDFS6BjO4V1bxDC2cJH1rrAwDvI8pQc8HXWRxvUTIjsasuJPcKgQ4irc1B4xFyngHJ7pAkf0Vf+WlEFSGUolmkf5TLLinGxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ELyfWYSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ELyfWYSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3241F00A3D;
	Tue,  8 Sep 2026 16:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788886187;
	bh=shtHAzJOx+EB1+VUj+R7U4P9CNW54h2pnaByxdOjVRM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=ELyfWYSclJAUZJScdIyBUoZKq6H+XJsuSWNniuxFZgtb97ZHkkodCnTYeWMMa4CF6
	 9NPjzRH6Ci6k6sqHwf7FnqOmx10YyM/yZrLxu9dNj7y4Ygs0/eWi0LrRhjdQMjtH4W
	 S3qP/5cWgsqK501qiibZ4QhPwcudyrNs8vRvmSGP5IkC0axpzKF47CX1grb76AzCAd
	 +QIT3x0x3duDvn4uFTonbRgS6kyjdTA/uq4JbAx7lwGvIMt459lwxclTAX6eCScp4U
	 JAFZ1p9afZi0J3BqS5NkXkwFIEEA7d4oYFtw2zUq8zlFnz2jREZkWSFw22pYkpSKUt
	 Tu7u0s5O5tSzg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A3A39EAFC0;
	Tue,  8 Sep 2026 16:48:47 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <ap-dwlnQ8f2QSSDj@gondor.apana.org.au>
References: <ap-dwlnQ8f2QSSDj@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ap-dwlnQ8f2QSSDj@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p3
X-PR-Tracked-Commit-Id: 60892a384aa1e65d0e703e1c513417bdf0c80777
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7daadf5131ed488037cc4540797e53c7f2c5d3ec
Message-Id: <178888612607.3639424.11513617795103771240.pr-tracker-bot@kernel.org>
Date: Tue, 08 Sep 2026 16:48:46 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 8 Sep 2026 15:31:46 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7daadf5131ed488037cc4540797e53c7f2c5d3ec

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
