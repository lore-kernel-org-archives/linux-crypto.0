Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362B826F2BD;
	Sat, 22 Nov 2025 23:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763855759; cv=none; b=WYAgCcWov938ETe3YnNHWrkZQ8DRftH/UT+0krU5RDVgw9iJdIvhcDkY8P4eJOy48AjDmh4orbJgf/Wy/kJFqH+wMJ+YV/xyFmy2fpnYoiRyJcB1ub7Cp4nuQZ+PkFy/UxTsIwvESCxSK1G7enQ6guxcZ8aH18lGMs7XJghpg5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763855759; c=relaxed/simple;
	bh=lp3vsWUbifJmE8Cm9IpL4ae96+uy2diEBkm7se9xwtM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ibPo4mm3Kyvg9qTGtGOZP4oX8ZNareM5+M9lA03/eM6IncX9mZFyViyqyLlhpugVLcXmMgaqj31Us1D/xCxmvrHu7ONCE3V2yhsT3ew00aKJw2KhQ9quGd7To5MVdP0ZFYHrRmNPJZsi6dD3qwbW/tW7TTsRZRbDBGx8wRLPlCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9WQMrou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9WQMrou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3136C4CEF5;
	Sat, 22 Nov 2025 23:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763855758;
	bh=lp3vsWUbifJmE8Cm9IpL4ae96+uy2diEBkm7se9xwtM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=j9WQMrouPtdFUaAczsduLtKOpCpDfCHH8vvo1wTKge1NWLpHb+MoWmvwVpLFkMja6
	 wkMA5aR+5UT221YO50MkkwBVJ8bYBIraTnQvgTUYgI9VajHHN9XnAs1hLyZmNuAbhK
	 OZ64CHVYQ19Y95FEmX+WdwHqMMiYA2n34mxTLturjqbAFbrGT9kj7hziCYHv+HQRQ/
	 nMduvlSSoCo5K5u3SW/dkbpLJocMfqrgGBmYeZm5LAWMOriz/awJfaK4x4uWT/d+ts
	 kH5y8OYG7a3gA0kCIYoGFITU0GLN0X807Mpy3ohfNVLCRdT7X1BmnjDlpGblSmUDfx
	 vG0m9TC2PPPeg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB0CD3A8576E;
	Sat, 22 Nov 2025 23:55:23 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fix for v6.18-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251122195231.GC5803@quark>
References: <20251122195231.GC5803@quark>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251122195231.GC5803@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: 141fbbecec0e71fa6b35d08c7d3dba2f9853a4ee
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0629dcf772e66ff9b81822af0e29ae2c7d03068f
Message-Id: <176385572249.2905465.12186822492359694772.pr-tracker-bot@kernel.org>
Date: Sat, 22 Nov 2025 23:55:22 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 22 Nov 2025 11:52:31 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0629dcf772e66ff9b81822af0e29ae2c7d03068f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
