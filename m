Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DF428C5DC;
	Thu, 24 Apr 2025 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745512106; cv=none; b=nx8/AS/Lkdd18eFLIwGpDCTlaRtyTDnbip1RdqJ/uEJCAmfTkEXCJ/K0hADDVTfJ3WzRajRRfoRn0yT6PO3hlka7plbKVSouk3d1KJ8yelHE3E3xyqBt3crKNCgrUDDtCzzMPzGNsRG2TabrnZX6hBSZsF7aRt0F9STh+nIYB5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745512106; c=relaxed/simple;
	bh=Wh4U3nBzrU2K1jT6zuyYDKJn0hR3cN2FV8zyY1+WwQs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=aGU7QNkgdszV9MyzdCkXJQ4qBtvm0wlVcu45r+X0ufNdhP2BP/mmC5qsJUoNsXLfvB4tP58Ouyb0Zxh8j/IbxH3tA7e6B+MG2bAU48c42h+V6hUXZo/dj34//5lx1VCIAkUaR8J05QEGOPJFqhE5SvlB+TnWyv8THEz5AXEEweE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7SMJQuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7SMJQuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C841C4CEE3;
	Thu, 24 Apr 2025 16:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745512106;
	bh=Wh4U3nBzrU2K1jT6zuyYDKJn0hR3cN2FV8zyY1+WwQs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=g7SMJQuT3jtdhOthNR48m7mFL2fTzMz98fwU/bZsEAf/QIdy6lBtGZO+h2Vr18fnS
	 iE4yv9oStB7gBO+U/EoUhw2Hn4snau8b23zLJv5FY2iCL79FpXcx76C1c0BJN2mysd
	 reIoPxYDWm++uEXvgqjtBtZWI9kilTC958/QPQmsU6qCT20fYRVBhOkmIW+okFEH5e
	 6IIXll3ZmdIZwNB79frD+5ezm+zDH1cVMWPVDbMfLgNYaoa5dODDeDGVWXc8pMM6i8
	 Pt8F4jHBl3FmJTcfvP9Iec2jGQBAWxzVFMXRaBacIzg5/8chHxB45Lbhr3QoQqhgf7
	 Ktc9iyCf8hnmg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB011380CFD9;
	Thu, 24 Apr 2025 16:29:05 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <aAn_NWZjdX-wYHxR@gondor.apana.org.au>
References: <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
 <Z-ofAGzvFfuGucld@gondor.apana.org.au>
 <Z_CUFE0pA3l6IwfC@gondor.apana.org.au>
 <Z_89K7tSzQVKRqr6@gondor.apana.org.au> <aAn_NWZjdX-wYHxR@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <aAn_NWZjdX-wYHxR@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p5
X-PR-Tracked-Commit-Id: 8006aff15516a170640239c5a8e6696c0ba18d8e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 288537d9c9364356a4b2f6bd947f2e89cdaa353e
Message-Id: <174551214449.3411799.922824770184674490.pr-tracker-bot@kernel.org>
Date: Thu, 24 Apr 2025 16:29:04 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 24 Apr 2025 17:07:01 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/288537d9c9364356a4b2f6bd947f2e89cdaa353e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
