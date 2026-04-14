Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D311AA7A6;
	Tue, 14 Apr 2026 00:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776127104; cv=none; b=nu9+aiznYAS3OBZ+s6PO1nU+u8gyTHEdTHY2fIeJ76Rkf4a1ACj37ABqneMmQ0OGE4YrMJCrRyodUsXHEfKmoU76Cq4hrNqNFhWiuUvL9NC97tNXlSVwaPazTLYHOQ5pI9yYzH/RXQNk8GOj3LbWJsiDXksfs0K73J6AplF2zVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776127104; c=relaxed/simple;
	bh=Gc6PfR8mg78bc2nZBSOOeXTxrqwjLV39hOWe/+ycSm0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=kUj6k449sDBjbqNeZrBLIDEBuaaPTrpbipmCnyPRmndE1fDt+3GLNeT4XZzohNbpBcSPJSQcQ3uo0B7yYugf7kqGuLrNvrY7oj8+91yd7yB6Mf10qu3743Z/+VVmP/Q89v63rteyI28XEFd/LHZMCZU77CuFdbBmG2Yb/ZRHARI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZCkTh8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZCkTh8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB618C2BCAF;
	Tue, 14 Apr 2026 00:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776127103;
	bh=Gc6PfR8mg78bc2nZBSOOeXTxrqwjLV39hOWe/+ycSm0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JZCkTh8FzLgkqnG+HxOg6tccMBA5tBfIgRtuUykc0wE16SvkBU2aPpIKeI3wHvGNF
	 N9nWdAYPKnM8k8xWq0r+H6PO266XY3MalNKfMRYzDHL0GVxER2Of66U7mVVV0dRUje
	 6+Ofup54e/PQbCfSsCDSaFYVa79azUiOMvtWotKo4EJsCtyGEu6ISYf5OzadMHe6M8
	 6SzCbxSqgjOuCrB5GNeYelf4Ac9UaHFk43uuLLxCv/1dgz+3HEPRjT1XH5eEw17wO9
	 Tj9q4vHXkrMm6tK7QXJOtjCbhpFauetGF9zjUQITCPWKx9uXx+W2Q5lfZ+04qMag75
	 REhyTO0EMF8IA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FD5D3809A0B;
	Tue, 14 Apr 2026 00:37:56 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library updates for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260412003225.GC6632@sol>
References: <20260412003225.GC6632@sol>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260412003225.GC6632@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: 12b11e47f126d097839fd2f077636e2139b0151b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 370c3883195566ee3e7d79e0146c3d735a406573
Message-Id: <177612707471.625472.10128103824010012548.pr-tracker-bot@kernel.org>
Date: Tue, 14 Apr 2026 00:37:54 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, AlanSong-oc <AlanSong-oc@zhaoxin.com>, Arnd Bergmann <arnd@arndb.de>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, Randy Dunlap <rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 11 Apr 2026 17:32:25 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/370c3883195566ee3e7d79e0146c3d735a406573

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
