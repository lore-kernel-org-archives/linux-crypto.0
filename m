Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DA21D5AC0;
	Tue, 29 Jul 2025 01:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753751525; cv=none; b=KYavRFJ0sH8AsCwCBUtYRw0DY3buHMa/K1oXEM/pJdIcZyQk1cZzyGrCjbBCco8AEjq5PHMHOQ2Z0Hw8+LIQGRhQ8nt82zKXkq7+g8pcLwT4WIpBdd7wC8FmTMRdPSRdOJTwa/T1FlOCXe/t9t3QMUq73RgFGEO9Oxp58kF2pkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753751525; c=relaxed/simple;
	bh=DhGVEgSZfVQ1SKNqb/j8EeNOhU9QfW8HBugQpTav9PE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=cpjMc51TlzK/PTSly4b66q/q9zUINeKr9T2JklivsoPp0tII04aUBsyT5rR9SP9fe6GRypl3pPSJBEEmFWV4miqMPymcYhcKGS1EBMIKNQSdKrOTsdXr8hgXXyZ1k7Wt+ZW8NUuy7DK10PAwxs2HwzoCl5H/03bvDp6rzIaq+a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cki3toNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cki3toNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF52C4CEE7;
	Tue, 29 Jul 2025 01:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753751524;
	bh=DhGVEgSZfVQ1SKNqb/j8EeNOhU9QfW8HBugQpTav9PE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cki3toNACexcUkogDUgs9OtWOW0lzylA8cAD2yExS7q8GLNg2kX41wHhw5G4qbQWy
	 rpqZK9N1Xqbq0kV2IcnJ/vObNKOau3EPDXNOjU1WyA0BvGn4UGNDYDLYT1gggsAsQ2
	 VurwI6gL4YKEv1htdn8EFB64+do/dk0yrWrQo93325ITPBVYWODs/YAVCEV6YU5h2J
	 Bn5lOuoByDWAbnL/88CwFsee2y2XCKyX8Ors5fgwbM9KbQfIcgFYdHnd5Z/5/YSIwU
	 1iArBMNBjH4B0jp3rPur+UKxHWcPIAP5Q8bGLPfISNnsOqyijwBUeBglAZCj6jF9h5
	 Vxj8zaJ4qpY5A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70BE1383BF5F;
	Tue, 29 Jul 2025 01:12:22 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library tests for 6.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250727234727.GD1261@sol>
References: <20250727234727.GD1261@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250727234727.GD1261@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-tests-for-linus
X-PR-Tracked-Commit-Id: 8cd876e7833758f8a924db2e39530d2a9afd2703
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f2f573ebd42d659111bc71279cc16e5e78e56ae7
Message-Id: <175375154089.918485.2702091025415289613.pr-tracker-bot@kernel.org>
Date: Tue, 29 Jul 2025 01:12:20 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Guenter Roeck <linux@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 27 Jul 2025 16:47:27 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-tests-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f2f573ebd42d659111bc71279cc16e5e78e56ae7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
