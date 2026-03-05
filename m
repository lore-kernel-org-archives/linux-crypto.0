Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0873A2FFDE2;
	Thu,  5 Mar 2026 19:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772740530; cv=none; b=UfKSW2sAfzJN3dTlT3Rw8HrG4WxNQgQUsaYu/7Ha93qQNmZ6iq+M+0dlGfNL2gnHrdm2U7n52Y6QvAeTk/1l7mWMOGOFbX6Y4a0drcj9oCtQOGg4dd7cFMJDlzfT7sENLCcG3MwCII5vN7tm3Zsl2ltxJK4lajivMYqeqTXFlZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772740530; c=relaxed/simple;
	bh=iKnMN8w1eS1scDXpgBOWnJmy3TBURduZQpQq7kaVz3A=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=X9J5GbBEOeNJ3paJjKxb/gLvohvvQlqzbg5Bf3DOWv9SBdfJKD/DSqSMOpTReECpDxQy+zLCs7ZjhNFwYhGXkmPbaJbzZxCSHo1mo2tuvBYPmqK7PnIsAMde/lhddVGYocYM/Y57xOWjbZQkCfBBuARMAWW5PhzMi3uaDlQVodg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kVMsnii0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kVMsnii0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4A4C116C6;
	Thu,  5 Mar 2026 19:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772740529;
	bh=iKnMN8w1eS1scDXpgBOWnJmy3TBURduZQpQq7kaVz3A=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kVMsnii0Zm2LOjRjWNW2Qyga9u6HQX3VN+90hHUepu1rY7x0AuJmiiu0tPQrq0Y7I
	 Cm3QsEg0sg8ffb4il5HMWXbmcH6bkMWJ9dMON3qMbFzas15dhU+c1SBGBjy7zu3C+n
	 CsSCWTpvK4AtOoWkA9qBrrh9dR23VSoQHF9P1BAsE5Nh+emEYRyBOKK5BFm9m61Waq
	 PRDlw3VyzYzOBxRYN2TseIMVndKceO0mV1+8bb7zNfe0TrZvCdP0OnOyHIIC1Djf3s
	 LQioHuI3UKEcbFnzmZSjzAm9ROKpnwhF/ocSWl5qpJYUOhLLBXOZtwS3jB3abxvqmV
	 9Fvpems/WDuWQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA2853808200;
	Thu,  5 Mar 2026 19:55:30 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fixes for v7.0-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260305184254.GA2796@quark>
References: <20260305184254.GA2796@quark>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260305184254.GA2796@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: 3875ceb592d3cb23dc932165cc1eeb74cf4dc319
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6a42ff33f38d171a6bf8304f6323c43e8a0ed9b6
Message-Id: <177274052925.3268027.11524898076411931576.pr-tracker-bot@kernel.org>
Date: Thu, 05 Mar 2026 19:55:29 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, kunit-dev@googlegroups.com, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, Aleksander Jan Bajkowski <olek2@wp.pl>, David Gow <david@davidgow.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Geert Uytterhoeven <geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 5 Mar 2026 10:42:54 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6a42ff33f38d171a6bf8304f6323c43e8a0ed9b6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
