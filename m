Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E15248F74;
	Mon, 26 May 2025 21:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748294427; cv=none; b=K33UJocDPMZ1WTZAPsC2YgfaTS1U3S2y5hkkoIs34KAJxx4hpZA+DI3i4fk8IW+TJmMeYPFC6Rw9PJ7Q3tMEDVh7iJVaK+Z+b2v3eF6bCQ0Fpt7vMNe5RsCV7FtGthoOoXxpJlp2zFDwTidsOoVcd7T2Efy1IAbFCcRfYzHC7Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748294427; c=relaxed/simple;
	bh=1U02zqj6EtpoEwJo2alR0hyIGxV1Q21ZIR4NvwfPbd8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=P8DeH693rifwdkuvDGn5tvSof5yaj3j9QH9CT7i8iIPRK2Tr4hP6+f835ydU09RdciwkjpIfzcof8s65WA+PW9vwcPvWMO+9KWMk51VKPsUcIz+wywlSKaiyoWZwSYZGdrYgNjuwWsrmnTIn0KC7mjZSLA5kZ/XnWzROjsCCslk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ezIjp6bA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ezIjp6bA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085C9C4CEEE;
	Mon, 26 May 2025 21:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748294427;
	bh=1U02zqj6EtpoEwJo2alR0hyIGxV1Q21ZIR4NvwfPbd8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ezIjp6bA2pwjfJTmx3dGZGcRf2+03j+lyQzPh+fmlUQaAY+1DUxickGfGvoBC1svR
	 XJRCSz2ImdAKj7jmL1E2BEt9gcxMa1GiLws8k+yQJfG5pTu1c9/SsIYCuAtYzFAch4
	 RxPl1YyOz7amKZl4XHYuBHyFp74j6WrQbzztAJ6DU8KoQeEonGI0oCGNWfVq242Pji
	 Zgfh5TubVhd05dJYOG6199NcMBoI6S3JNSk0OYDyJaXNPU4rsfdDSaLml3bYe2z8jO
	 IxTz7fWZ9d/cAZSTlwTpFLPkGtYzNpCeXoUyowVe83hEQMZFFhEVuUuF0vgMsD4441
	 QqwYIj8UvDWNw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BD9B3380AAE2;
	Mon, 26 May 2025 21:21:02 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Update for 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <aDPmka4yENceDgPs@gondor.apana.org.au>
References: <aDPmka4yENceDgPs@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aDPmka4yENceDgPs@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p1
X-PR-Tracked-Commit-Id: 2297554f01df6d3d4e98a3915c183ce3e491740a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 14418ddcc2c2055743ac7ee53d5ac2cf8a8660a7
Message-Id: <174829446156.1051981.4467417796956937768.pr-tracker-bot@kernel.org>
Date: Mon, 26 May 2025 21:21:01 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 26 May 2025 11:57:05 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/14418ddcc2c2055743ac7ee53d5ac2cf8a8660a7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
