Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A1437269A;
	Tue, 21 Apr 2026 18:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776797477; cv=none; b=aqiLLWW3NjRygh/OcExn02T8R540QNANJV6xnJdU5+apmta8xVbcepas82prrJUTs4gK7v/ZwVT8WOCtG2ZrVVfzHNEFnbKq47ahy38w9Au7hynSMiq9FKS/TbwlcUYcscM1c/eAiyV0Y6uWPFI7VVNMrajq5ocgd4/EPQrCLXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776797477; c=relaxed/simple;
	bh=HI6Uh/IPMyAfvettDpq+wb1qISlDb3hvqZtcmqjV5EU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=obZEFSC7tThk07y5lmXQgAmNFTj/qtw4uM24/XAqy8XsX8gBI5s9MI9w+pZJGsbzo6DJB21b4AItu8J7Yw1oju/jO1rxjuWoP6TRF4VHZt+ZmWrPiU4iYOIxC6agl8wZ4AXMfo8TeGmahJIODNsAd+aTirSoWTA1Bdibv2CL8TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fb5qShqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fb5qShqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1A2C2BCB0;
	Tue, 21 Apr 2026 18:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776797477;
	bh=HI6Uh/IPMyAfvettDpq+wb1qISlDb3hvqZtcmqjV5EU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=fb5qShqoyWnjRVLa7gPVGBa0lApP4iObDOCRBl5iNTxsgGmA4wi7WXbZV5WnMuPzl
	 OY9CMyDI9EZgnFbhI/2uz0aCqKffxgzGGA0hevYIe2wrDa+jSWLC5f3SAN/PQRY6lY
	 hU23ZCXJDltHJuNfVP061soSnylEat6tmmamS2Dca29+lo7oF7khhfi4salncBC311
	 CcTwStSYsmg6w71Nv0H58aWSy+May3O9uD0vLyR7QRMYAlNM/094oWhiRf6nELAn/L
	 d72eO5HLtjL9z/s2ab5VTXAQat70bQofTNIgIEuu84xVr36pxLNVYaBlP6R/XDCJYU
	 yAj8fwH/BEIqQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02E003930203;
	Tue, 21 Apr 2026 18:50:42 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fix and documentation update for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260421183847.GA2202@quark>
References: <20260421183847.GA2202@quark>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260421183847.GA2202@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: e9af4f47d4a036b4be67e4be361f62e05081f7bf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e2683c8868d03382da7e1ce8453b543a043066d1
Message-Id: <177679744066.2956451.5936265352144185176.pr-tracker-bot@kernel.org>
Date: Tue, 21 Apr 2026 18:50:40 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, Ignat Korchagin <ignat@linux.win>, Jarkko Sakkinen <jarkko@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Lukas Wunner <lukas@wunner.de>, Randy Dunlap <rdunlap@infradead.org>, Yiming Qian <yimingqian591@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 21 Apr 2026 11:38:47 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e2683c8868d03382da7e1ce8453b543a043066d1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
