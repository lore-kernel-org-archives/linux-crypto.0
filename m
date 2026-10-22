Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792702218;
	b=GAXntNwt3x+clPIScu2Ox7t1OnTSUeiiHZm4E+PjVof7ZflpxtI3mSzQFL6QAo+1uTIK
	 5dJh7GfBVIBl2Q59S43wlq3Rr1SxD1ipQVCspAc0Vx+e/sI/5sIX+PswutTHsioukwK9b
	 5FbRIvcxjmsdE+eFF2JdMhMTqTtGbkG9eTrXbjyj23kwiWB0/udIETj14iOxqYV+hMgUF
	 8j2tkhl8iq5gpevkC8iCsApjEEQGcXOfo9ab72e5JNPxQRAeaRwFJ1RUi02z9qi4aaS7w
	 wtqxq4GoSa4xbHR3Bxq+KFvtCRhGy0EXIsSSyKlw51/nqaHAVDJBabMT7AKpRew3A/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792702218;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=HADS5v3OTNzhFSnCi4s0Trn9EpBiA+fSI37APqr3GUg=;
	b=HX0T9Bgb56LgyG9ZA7pn8FHgsh0TzACtZFXhskaPw5Ab6ktSTT7ISHqTLcnSJsNiP/mU
	 nQjnIP+LWKKNVRf4a0kELYQ+IczcetB3I0NeE+gfQqlOVxiKRxAhQuDFNEO08xLWJV+o0
	 B0N593+PffBAIxrs0Rv4XurM2PNRIITia0VE9MenFjAlD+R8vT/UdZWBwk2Sa+p/hVv4x
	 jdCOZ1IUq+TmnEAxELUsnot5bIiJmjOrNNH3S92qsEtXFy/p8YW7IMIl3S/bcMZwHVqWq
	 Uzc6AZR+u+mpKxpekLvTiQHr96FaUGHGC03LfOOrPQbBKpUavLhi1sbR22KZgmAZt4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jNS5gpu2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B338606A32C;
	Thu, 22 Oct 2026 20:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jNS5gpu2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5478F1F031E2;
	Thu, 22 Oct 2026 20:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792702218;
	bh=HADS5v3OTNzhFSnCi4s0Trn9EpBiA+fSI37APqr3GUg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=jNS5gpu2+En2YhYiQPWCT7euQ7cMpvxDt1oStw7Xtx4RJun8lTEWpcsTbayXG2qF/
	 KqEyIDxnMbYKcgyhlFLBfFKN+XkqEBNvpicsp1DIwzJtzC1V3JejDi8Bgi48dpVmUb
	 gVI7H2dl+SBKDkrDK5v2NM5W27SWNp0RDMQCN2H/42Gxyf5mBi0IZwGMgc7tfOrnm7
	 6EK9PoBNzqXh3xx2mdc2QQeVIFPsj3VClfgozas6fLSv5AYdwbzTCB6Mmn4SQHJNS4
	 pUUIiUFYJxkjM+q4jDlXznewXSts8x6O9+V58pgw0h2QFr2pFAAzmk7cevF1A7i+aF
	 JQyy/DqPjFhog==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 44105380822E;
	Thu, 22 Oct 2026 20:50:18 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Update for 7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <atW3dd8TntKt9hj4@gondor.apana.org.au>
References: <atW3dd8TntKt9hj4@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <atW3dd8TntKt9hj4@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.4-p1
X-PR-Tracked-Commit-Id: 178aff4cf425b3fc51ff09c571fa1bfbc1eb8ea4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bf2325084583daaea91084b25069f121d5d8832b
Message-Id: <179270221710.170280.8063788263845998429.pr-tracker-bot@kernel.org>
Date: Thu, 22 Oct 2026 20:50:17 +0000
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

The pull request you sent on Mon, 19 Oct 2026 14:23:49 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.4-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bf2325084583daaea91084b25069f121d5d8832b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
