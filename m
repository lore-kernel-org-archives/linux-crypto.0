Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B2923C512;
	Tue, 16 Jun 2026 03:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781582242; cv=none; b=USvBJ25el+fVoHS4Qg8slnWk3pw8+c7TsZsHKN6kiY2g6mQdsTbm1PFqeDHykmGg0DiZxuEIjL7Wtbl1TqoakwYaAB4UaHjQSmHAmylh6jB99Ew6AU31U09tb60F2mkhe1G8iiWfe0c8Eandlgdfc0npq3gnzV84CamOyKeqd44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781582242; c=relaxed/simple;
	bh=GY0jVjTHBbJYBZM4FVu9fTp0mUJYW7cVthw85dqR08k=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=KX7AfNPR0u9DelldbRkvOk8MQF/Fahu5EqO0ig/sUeatfOJyHcAJb4Vx+0mul/n4YlpzAlKuMBREOfHmyzVJWTu6M8gJftCIC/AYQEh1JlhwiIkJztuZXFVHJ+8Kzdmjmt1OYjP1v2V6sB73u060rr8V0k1eW9IKThJIbRgfbd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TtGUnB7n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TtGUnB7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EA71F000E9;
	Tue, 16 Jun 2026 03:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781582242;
	bh=0aAjhkxLA+t0Q6LuTnEtNpb5Zhiy67j7mHYgF8LyZeA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=TtGUnB7nTTlPAJTEBlsm/caRZu9dB2KAXrUXZX0v9ad+tzYvR4G/XlS+5XnixBuPf
	 o+vc2ZZMdH7RaI2CuhcpTxUYRjAeq/9KDvtRIx9sE/6Wmy8L3G+oXTsNlkoCkeI4V2
	 09iWJKIU+qJLtQa3IdZB4eP0yWE+4bR+4XMcQwvMygWoIHjC4bQQmvCk4orFSmLS39
	 AniK9zlknPDR4y66CUtkgIIb1pKg9f6RtGQWzz3Kqbr4Bl0e0K2Qg6d8thds1qnPJp
	 whus2lcH/HTxA8KaNrgBDRumZIMW+qbS7SuDOZNwbFnnQCuodjcWD4/ZfhZco8Ub6K
	 DD/+7JSK7z8nQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199A9383BF4D;
	Tue, 16 Jun 2026 03:57:18 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Update for 7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <ai9zXTKk9fhCZoKd@gondor.apana.org.au>
References: <ai9zXTKk9fhCZoKd@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ai9zXTKk9fhCZoKd@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.2-p1
X-PR-Tracked-Commit-Id: 6ea0ce3a19f9c37a014099e2b0a46b27fa164564
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0d8c1134936f1fb6678156ab4248ac740d274525
Message-Id: <178158223664.434177.15641615559030054967.pr-tracker-bot@kernel.org>
Date: Tue, 16 Jun 2026 03:57:16 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 15 Jun 2026 11:37:01 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.2-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0d8c1134936f1fb6678156ab4248ac740d274525

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
