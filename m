Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827F5372ECD;
	Wed, 15 Apr 2026 22:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776292693; cv=none; b=MScD5IxWo6ZiTy6+p0n+tUDc/6x4RUmeWPFlPBDC1Vdg3jrlafIl+62it0vbYz7dk21wEZUXbSr1rm6XbUqrAIuooYb1s845100VivdV0K2YJVEClU4OFwI+JgBpVnChz2BzSF/NJPQYaKzNmVS/+ELOIUe+V++dJOAas72TMHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776292693; c=relaxed/simple;
	bh=qAXB9kfU6vrVAnsuyDw8EssopauOMlJcS8RfOAZ0YIo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=GcUt5RAkKTAnfMPyQwmOJwjhX+b7CJKQa6iN1dSxsOfS/OV1a0ZmzDiuD3TdjHcvP974tnySj9TnIjT2t+kLRgGnkBu4c8Df8yWM5YTT8r+QGpJUQE4S6m39dlb04m2aj1acr15pyq+VSYazbGhiIVKwiomFbPQikY3IFivJcx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lMsOvvRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lMsOvvRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4697BC2BCB0;
	Wed, 15 Apr 2026 22:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776292693;
	bh=qAXB9kfU6vrVAnsuyDw8EssopauOMlJcS8RfOAZ0YIo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lMsOvvRxWu0Xeau9ihgi9ppc0VpT3htAsNUlQBF8mN2LzNZl9uq6BcaJyJIiTplQB
	 JnWv/EHBR6PdLgF3phpQdanxhT0dGCkZya9tMfm9m9zsqgwlwRt9yJK5B4xPDhpWTT
	 37EkqDUVhraICVopByJULW5y5RfCdKwG8urDJCDyA3W8idScRayCm8oszGmh+GiTY7
	 8MVKGc56AehtAarERBgz410j5HU2xI33c5QL9X++fWs9VkgNIRR8gQ/Bw5tRdKYzCP
	 VnexSHO+oZu99JqYHhF53Jf0ywwKIaO25Sq7ToQbmLQqLfXMI92QNOTFfjEx1sYgcN
	 zz6V56GR+6pfQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9F03380A963;
	Wed, 15 Apr 2026 22:37:43 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Update for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <ad7u9gGDjLBaFt1_@gondor.apana.org.au>
References: <ad7u9gGDjLBaFt1_@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <ad7u9gGDjLBaFt1_@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p1
X-PR-Tracked-Commit-Id: 8879a3c110cb8ca5a69c937643f226697aa551d9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aec2f682d47c54ef434b2d440992626d80b1ebdc
Message-Id: <177629266228.2482053.14151573363715646187.pr-tracker-bot@kernel.org>
Date: Wed, 15 Apr 2026 22:37:42 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 15 Apr 2026 09:50:46 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aec2f682d47c54ef434b2d440992626d80b1ebdc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
