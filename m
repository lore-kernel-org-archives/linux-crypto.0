Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FAE137932;
	Sat, 28 Jun 2025 01:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751072504; cv=none; b=F370PvAlpk140Qf0nL8nCdrbuKqlRVR/dhWHovjQBtRz7xN6nZ2tNDbQlmgkR8SaTQsV9UcQsTc5eGX5jRQIqOhNDC5jOJI78ACScgTJKcL5ySccj8cm3sH0OdNo2JXAjJrbBHSOolhl1iuATGJtHVD0zhooTXODU2ZUmioE6bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751072504; c=relaxed/simple;
	bh=BVt084Jffd0MsEmn1r/uRb+4WdE7yeSiaCEgJg1Cgd8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=m+3wniKdJZ9fXb+4tztfKL3a1HLRRuRay2zzjpgi8jYkc8E9KIZPYiuaFTNe/kZrKm5nvd3FcEVbeoKnSElj9Xt/GRt2hxMNOWbdzpqnOCoyi0ATT+Moo6pK/TJrrDnMfMV3jDIoWs2qufuXvICOFC8Yoytl03fmQIg1KKiK9hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UApGjuuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UApGjuuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F36C4CEE3;
	Sat, 28 Jun 2025 01:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751072504;
	bh=BVt084Jffd0MsEmn1r/uRb+4WdE7yeSiaCEgJg1Cgd8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=UApGjuuDE8cCkFsgR6hJekH28YcYgQgJZq1+sHItnY9VV22xe57BVUdrqTfRDzMHW
	 f7TB5/4upgDWLpa2EkKyDpqGLCm/eUCa5CDBqwSMChZgPriBb0Lum7uTbLH+3dbo7k
	 YnNRZ10Lao+2NMK9WpvVN8uOKayJ0wpJ+7HJe4KXSCHLV/ClufYstYgzENBz5I4tZE
	 mPNqmOHiytCXMo+o1rdTfmWhNVz0ToHfHIJHFnQGoPDyAMJ+VIFcfrVBPcNwPukoI9
	 2ohNLC35wTXQdGrZItwOaZTvdr9j2caW8sVZ/0xJdabK7u9e9ST3dZ3iUHK9n2AxvW
	 2hA7st4BzdbPA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70E6138111CE;
	Sat, 28 Jun 2025 01:02:11 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fix for v6.16-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250627181428.GA1234@sol>
References: <20250627181428.GA1234@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250627181428.GA1234@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: 64f7548aad63d2fbca2eeb6eb33361c218ebd5a5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5683cd63a33a5f0bf629a77f704ddd45cdb36cba
Message-Id: <175107252995.2102963.10280922816552279818.pr-tracker-bot@kernel.org>
Date: Sat, 28 Jun 2025 01:02:09 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Arnd Bergmann <arnd@arndb.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Jun 2025 11:14:28 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5683cd63a33a5f0bf629a77f704ddd45cdb36cba

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
