Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794434458;
	b=a7R9QL06beAahuno0hNZcd+EL96Oip4j3dMQUjzSBNKWjUK1a4nf9vPX+Jgu0y4tTsKI
	 hepEFlp5zpLTi+rRpaDf7zswgEwGgiVnGEb8mJKvx9vfEiynFXzIaqWBbtkCcFG+DamIZ
	 totfPwURyXt7EEbkPykOFR429U+fVMk2XpjwkTcbf5t3s8C5p62lascpXU9kX6TsPeyP+
	 fzWcRj4U3Ioz7x/KjxvSIviAZNU/aVzFcD9Fy2kbsTGtGqI9cIemE3jDFgs5QJx9CK/fT
	 LeRnAOjFJNWBpUIhEDDj7h2fvxWiOjEWVXvts9R9E45S4LFO+qEmiim4BgorNUmKXLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794434458;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=Tq/ip9Zm2MQbR2BQIY9HvE2MPoq/Q+vmfjbAPwav2zY=;
	b=sPDZoVQdcfZ8b1CyVmTeNXgeicpxohHZKocP+ic8oMHgdfZbVl+3iboM7NCFX0OMBosT
	 5Rese5UsfCNTa0oZVAT5rU2dNF6CuhDVDfOqKsW40ABU9Y37mXX1PV4yG7ZxzlhXggKt8
	 cIjbtFMVhLwhO2mMaLTPoxi+ln9EtM8VpDEw2eaDlhe2sqd6y6xsPEuFwVKo+9oj7M32I
	 L9fKm5otLz7wsdXu3icPDm1H5KIHLsk0lae3Kf0MN0nWZbqGzI2PTxLW8x6X3MQseQjYS
	 BztUCaJUFlazwbwEqH+Ty83j16SZcajjcJAG1o9LOVEyXulRkJBWlAKhX2VlWy2mEzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hf70Z85Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D89606A33D;
	Wed, 11 Nov 2026 22:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hf70Z85Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652C41F00A06;
	Wed, 11 Nov 2026 22:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794434458;
	bh=Tq/ip9Zm2MQbR2BQIY9HvE2MPoq/Q+vmfjbAPwav2zY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=hf70Z85YdjocoAvwEL5+cFn8jRBDY7y/EODlmZgktijLlQMz1fwwneAFK5tTjDWEi
	 Qnnl78rqlNlNv/oTQF7YzGWIaaYnRzusYfUKSU6SKBne/iv9HCfVnHH6o66tGT1+Ek
	 0rvJldkAjfSVuPGeL0vnkGJl8xwdTi7d2kGMhxPLPZubjd1+Y/d/0WwCMPN4mRyN12
	 RNOGPqi/WrcWkZ1IIiOtm9s+XH/CmZHnVU2gCPed6OyBCGoH7sjgFEaOKOBtXLwflE
	 slUugProhHHKXra2VsEU9LkNt8rmCToim5kzq9DqVSyiSlmksBExl+a6zZIHkBXVJ7
	 yYO3IZwZxOujA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5A7B3391AFAE;
	Wed, 11 Nov 2026 22:00:58 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <avRMpKP0ZQhAyqu7@gondor.apana.org.au>
References: <avRMpKP0ZQhAyqu7@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <avRMpKP0ZQhAyqu7@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.4-p2
X-PR-Tracked-Commit-Id: 26ca5f34841f0a86d0883664a1c13be89a01d351
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0eaee8fc9305b4ae8e75e68c30e7e93b6b367234
Message-Id: <179443445699.1663589.12074273684430387636.pr-tracker-bot@kernel.org>
Date: Wed, 11 Nov 2026 22:00:56 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Wed, 11 Nov 2026 19:08:20 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.4-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0eaee8fc9305b4ae8e75e68c30e7e93b6b367234

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
