Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793724757;
	b=gcY1+YLGLjxORBQjnHdGjKCQ5fT4bByT5RLBbiW0Xyxy21QJfj98pk580hNrfs+47fzx
	 im64xPiW8Gp8y7aytiCu2SnYkuqGB1g6YeI8YxT037z8+arXU+g8SXfvTgawH+6chv6pM
	 pmwlGM4kNkikx53FPZC6BNsGQ0uIumfDpd9tEDymE3KulbY63bvA6j9moSe4gP0emz9o5
	 sXkHFPQc5hz6wBJ65BaGQ7QZ0gIEfzq1FgTqd06KM4RwDjaEE6mcRqSerwNUVeDgEAESj
	 XGwbfPK0Jiw1tOSZaGOaWFrScjnLHaffg1pUtzD1RkNoiW767K4jjrULwmpFRd9RQvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724757;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=lNlcpPLo7FBrO/QJvjnMbL90+K6TUMGiPf3gYVpjyjI=;
	b=cOQvVDJkFAsKifNqeiehGpOQkMsVEHPTiAN4hm8Y/qRDA4olUCLjtkHUMOJwljdqvJJZ
	 3zZ638Xod+zqhtPtgQlknondx2R3VQH3vJa2TIVodmbw5eoJejrKFKcYO8bjproCLaj++
	 nC7Ws9Yzgpv/Q9KV/yxC+p01J4wBMuq5JBY0tZ7wEvM2ZMX6kKh5lr9xFe/+TApL1+2hb
	 KOEb1RomF23N/CsDWzPdO5ixxg75VsRoBoGquTmv63s+voO1Id0y1krNNcdzkkHmuShA+
	 PF5atOUNNi0lxE5r3QEysy99nOBI3fOrttP4vESmgLiGTeZXgGPXUTogoccW9vG/Vag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EupygsBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BEE606A326;
	Tue,  3 Nov 2026 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EupygsBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878361F000C1;
	Tue,  3 Nov 2026 16:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793724756;
	bh=lNlcpPLo7FBrO/QJvjnMbL90+K6TUMGiPf3gYVpjyjI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=EupygsBD3uzXVUovJisqhgzt+LGoP/Rpk+flj07K63weXGyyPWRChJxAJhJeH2LG0
	 0siQzFJGtwXDHa5+9zIcY6Gh/vC4NOYw3n1OBwHBozIqlSHAbTZ+4XkgmKSd+zSqxG
	 UX96tkXQoHElBiI17QAIKIfNa3m1alT7qQB37WMva/U2q6xBAYfsSHIVT4et6+ymko
	 uAsx+pno2MOOCpopFvigrq3vkaoaPDoFzHwqxsrtOxZnrGKZJkW/zTcZxHK5RIDuAX
	 2GGoJwU63nzuloquRD2j0WgDIPAFLQaer1MiqPb3CDAAAuW7xKQx3bcEZOry9m6xdr
	 VpaaY8V92GWBw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D37E391AFFF;
	Tue,  3 Nov 2026 16:52:36 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fixes for v7.4-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261102174428.GA1935@sol>
References: <20261102174428.GA1935@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261102174428.GA1935@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: 01ad209f122b7c173477bd60c7997564f9c65961
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b2e7a7bbc127534b73936a505237f08758552252
Message-Id: <179372475516.1755341.2580594496121383266.pr-tracker-bot@kernel.org>
Date: Tue, 03 Nov 2026 16:52:35 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Mon, 2 Nov 2026 09:44:28 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b2e7a7bbc127534b73936a505237f08758552252

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
