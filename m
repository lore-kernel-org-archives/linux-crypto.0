Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AD53D75C2;
	Tue, 18 Aug 2026 03:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787025492; cv=none; b=VZ3yHND1eG5+RXF2v4Yj8ErR4jOHz5FCqBNzc00KVv2beEBwvICQifo+CGgFG1/XCAw0+GjC87pd+rE38dNboYSnHahxuSuUZyuLWq8vw0K3tDcBA5zLoY8wVmSMcQKFRiMaiIMQgb+ZKv++f/0eUKTWBsqtLuDvilZIvPI81PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787025492; c=relaxed/simple;
	bh=Qe1iFZbyJvJ1PODIZAbo0ULl1yWqLzsBEieINey0Fjc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Gpx8254dzLfLaW4w3/JHlLmU+d33SVnCwbRiknu3/Mvk3bQiI4BwYixRWTv+g9SVDBjGbkgRr6IsuwuOD2noiVnnwUGlD1l2q3O23rEjbeAUvX/Z1jKDgHSU8dr15C2mSEVrMd2Ivva4xZR3imkH40yEWUttjqYNmkIct9vn4BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CU3eTXWL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CU3eTXWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB02F1F000E9;
	Tue, 18 Aug 2026 03:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787025489;
	bh=fSNZ1OMC52wd162Vy231Puw3XfSeQa3R8gYRSkp7hJ4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=CU3eTXWL+yA+fRpoxWTepeAvtiYohEhuXeiXnEoLeUutsNBqZu8mW28aNQr9IgFyQ
	 exp9paAqKG0dnz2gBRbx6CReiyTx0MG+y1TppEO9CoILvaE/mtMV+OGtMrqxkbFP84
	 YXau8PyYaR2n51GM7DXPyYGgVocxcB9Juglz57gmMtz3Na9Z1S7u64iavpE8wyHu7A
	 AmHHo+aQ8wkdp7EP0o9/10ziE1Ai+E4LyP7SBAGLMidQ89n/Tw2v4tr7Ikpxvj1G1/
	 BsGpPaY8PGQdKz7WdzD09Q1vXQ/ou+7Rvsi5TDeRCZWjNmQDqZWPDuhclznZPldSBQ
	 TqPhKbl7VM7GQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1980C3926381;
	Tue, 18 Aug 2026 03:57:22 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library updates for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260817174028.GC8327@quark>
References: <20260817174028.GC8327@quark>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260817174028.GC8327@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-updates-for-linus
X-PR-Tracked-Commit-Id: ff6ac629076fb3f369c6ad35d6ead1c666469b95
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d47db9bf50d28647689e6743ee93c45cb755ffc3
Message-Id: <178702544073.1862718.3050822579226871550.pr-tracker-bot@kernel.org>
Date: Tue, 18 Aug 2026 03:57:20 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, Thomas Huth <thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 17 Aug 2026 10:40:28 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-updates-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d47db9bf50d28647689e6743ee93c45cb755ffc3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
