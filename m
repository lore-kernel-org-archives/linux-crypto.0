Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B3549B443;
	Thu,  1 Oct 2026 21:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790890680; cv=none; b=L5kfSP1pS3qUer4JnzysbFlw20urpjUkX/+e1NpjxxW4JEBzeOpARWhAqmb8ZUDWjMMprrRlYfb4+klLd7HnCkbRuwiy/DvpRsBx+iBCsITz5P5TQLHrLRJlH1EXwahxpyGlLmuD6Z0CFmw2m3ITVx1Ijv6wxSX43ti/v0svIaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790890680; c=relaxed/simple;
	bh=XppxJQfw+440H9B1TZTXdhlOOZ9r8vqt6kmRrFUKGy4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=K/wxupZzk3pdkGCHWJK5yQB8TBehsqpDdx03rtsvtSQK7NgKNJifqBnjPaQGhcLiGbYCvMntmltqRMo5yMafD4am7lBNZNRUYi35uYGj+NCLCfeNR7qWQvQROPf8o4UvzcCdzfqkuNgNulch2KduUMKmsUa0UuptbcFALu6yggE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ejchsBx9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ejchsBx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455D21F000FF;
	Thu,  1 Oct 2026 21:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790890679;
	bh=WUaYppLBRXJolnv8gGX6scJTm8PlwaW22rKHqyTEU+g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=ejchsBx94JvWZrANQXcQZQYt6vfMYGgnIZMapuYCh+U8WtET81jDe/OX9ECUi3z2V
	 Th7OAbnBtxyejainX1PElM4lDUKbAjPSzVxKzaW96yL+f9Kq5JpVU2ntQjJuff44Q3
	 9ycOJhXMLos2wkIspW3/CV/Vs/WaYbyopUGQpOSl2tKbi+MEtQ3l856XsIiu0zEKVI
	 gF1I1jOr53sI3dB21GGKQ9E05PU2aNmkfOSFUmRDb/RyMYiMDX68LQn5kDUqz+B25V
	 D84ZSL1qC5nmL0lKfWWvKIUH3qCBNMDKySJnJXJsY9E3e+CG/yJMvz+jyDEyUjCN5o
	 AiqcR6UDB0/3w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A3E73811976;
	Thu,  1 Oct 2026 21:37:59 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fixes for v7.3-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261001175312.GA1709@sol>
References: <20261001175312.GA1709@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261001175312.GA1709@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus
X-PR-Tracked-Commit-Id: 572af6872e520c7102e58362ef7cd7c2ed4342be
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bd35955b089ad881f57a5a2619687c804d057fec
Message-Id: <179089067771.3100647.17142690027579160588.pr-tracker-bot@kernel.org>
Date: Thu, 01 Oct 2026 21:37:57 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>, Stian Halseth <stian@itx.no>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 1 Oct 2026 10:53:12 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bd35955b089ad881f57a5a2619687c804d057fec

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
