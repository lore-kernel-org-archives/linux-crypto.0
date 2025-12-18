Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AA3347BA9;
	Thu, 18 Dec 2025 20:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766090599; cv=none; b=oQbWF7sukpV08g0D5Y6+4ziUTu0RsryQLT32RzRsl7mll4xdKJ5HgYIjMPQ4tEusn4iwePYj7JxSHPPl3so2ms6HQjKafSw9C8pPfBfYIdSpJQXqIXDKXS+BD9qBMOjlel7ttWsVY4xikhwyrqMZcXEpI3n/n69+gu3zdFTGA+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766090599; c=relaxed/simple;
	bh=0nkt7N5KegtpAu+94CKpharYA0igULECgqJAOFvjAsI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=k91xly2EoM8ge6qOM6YaPWdMUohxCClOF+WICydGwM4wXTLhty8MIqRFmY4G6rl5FZfZEkq7bCcPXdDZ0IO8BzF9UJimYZwJ2naeXw1LdQGIccA2EsjfWwz4g11sh4df7hqTMezawHnnS1r6cHPnIwPce2HMDqz57O/MFNxjYOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hVQ1Zwco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hVQ1Zwco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58BEC116D0;
	Thu, 18 Dec 2025 20:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766090599;
	bh=0nkt7N5KegtpAu+94CKpharYA0igULECgqJAOFvjAsI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hVQ1ZwcoLYJHTXlQZ2wM+x6UzI74TRKy6um+0b1VEuexyWo79/cKyxK1Uwd6CmPkV
	 stxUA1Sa6wWyNZqYciy4eHzebsXd+7qdZrsevCJVSRNxyfEapUx6UklQdHPHDiV2DV
	 +S58uB6A0VkzeGqN1lf2phN6cCvia29aDecBRMFu5EhL/ojwGzrErB7zL8FS+yGJRH
	 JjPU02xNhnacCuqck8P8UYZskALvS2xvJZnQQ4n/Id23TNG4LTX+kx2H4URpc3MXwL
	 yT4askEFRczEoy5s7Dgh+6N6f8tG0hKTcGjuAG3+JSgkNSp7q9HqO+6gzG+8Z6yzvw
	 cupaUnS+NAOPA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3CA3E380AA42;
	Thu, 18 Dec 2025 20:40:10 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fixes for v6.19-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251218190606.GB21380@sol>
References: <20251218190606.GB21380@sol>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251218190606.GB21380@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus
X-PR-Tracked-Commit-Id: 5a0b1882506858b12cc77f0e2439a5f3c5052761
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 516471569089749163be24b973ea928b56ac20d9
Message-Id: <176609040923.3123986.7208501276249795784.pr-tracker-bot@kernel.org>
Date: Thu, 18 Dec 2025 20:40:09 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, Catalin Marinas <catalin.marinas@arm.com>, Charles Mirabile <cmirabil@redhat.com>, Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 18 Dec 2025 11:06:06 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/516471569089749163be24b973ea928b56ac20d9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
