Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54E521ADA3;
	Wed, 18 Jun 2025 21:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750282312; cv=none; b=TqoPIbvRkzkSMNZ3tBx6T5RogEQFBZ07gaW+OaM3FXgDUMMUvWq0ByLtg5nNIy9RFmTEEQjs97m3/9img98Or5z4BNkRUVQfDcZ2EUdPXjcoNIf7azGv3gdj7UQDWwKHY19UZtmzNx/BzUGLSBmMib+4akeX0Yx5+0Nw2L++abU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750282312; c=relaxed/simple;
	bh=AGOa0IAut9m4IdU6RN6Dctiy/5A4LTVB78HgeMn4eKU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Fvf6HR+gxnR6pW9E1nQrdQaRdblr/QdjQznIizz8bWPclnrYUoeurAqXVv+fO/pKgdLNos0MRq1GTFT4UIO+Hz3vshF+a7TkUQPDeZLKQndXRvtMSlWnTouisuS7ujOLh0HTkZCMeWzrbFwJQoaOwhesAYbR01FadkPzOeBTaSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JlLF2AqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JlLF2AqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E748BC4CEE7;
	Wed, 18 Jun 2025 21:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750282311;
	bh=AGOa0IAut9m4IdU6RN6Dctiy/5A4LTVB78HgeMn4eKU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JlLF2AqPAJbde3XrMvGPfRd4155g0O+gKhdfVGXM/Or6RID6n2xhOWt/ywiwPLmwH
	 znWFhlb/5wPuloX1UUdZH1IRvFMl2lPujlpyV6lOJpt2tc78QelKTR03lqmEVMsgHh
	 IB8GVhpsKrNrp3G+Sx+miCLMmdLmMhhwA1+e+SmM76bdYE9EENcHBJ2xp6C1x38rRc
	 TRSSLI7qYxG9L7ieQ4OSUJKg/C0BbMRWjJdSGY5Rod9ppqbj+1NpJajYmFLFqWLD4n
	 Mayn/2aJwRNp4OuC9lAjB3d0l/CtG2VB7kA4mBOGkR/eLnJhHLmaxoxdEFLkeTqi+H
	 CXiIob2MXSbSA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70BBF3806649;
	Wed, 18 Jun 2025 21:32:21 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fixes for v6.16-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250618194958.GA1312@sol>
References: <20250618194958.GA1312@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250618194958.GA1312@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: 9d4204a8106fe7dc80e3f2e440c8f2ba1ba47319
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 61f4769affffc398499250ccacf0b86d5b654399
Message-Id: <175028233987.264355.6917828638720227443.pr-tracker-bot@kernel.org>
Date: Wed, 18 Jun 2025 21:32:19 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Kees Cook <kees@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, Nathan Chancellor <nathan@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 18 Jun 2025 12:49:58 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/61f4769affffc398499250ccacf0b86d5b654399

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
