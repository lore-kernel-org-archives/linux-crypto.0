Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19510194C8B;
	Wed, 29 Jan 2025 20:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738180820; cv=none; b=ajO4GdIh6DZWsHDGlxIVg0hOynOakQVuJHua+FE3IMWRwi4cOlmRdJQMeoZwDmSKB0t0NI1RqSS0i4iVsyBeaDYiIjGHgeCZwUndtQayREjt1CgH9SY0rTiUKMA1Ucl6qNoWD6YQvl47xpCjOj1yMUTqLr6JPO7TGUVuzICN2PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738180820; c=relaxed/simple;
	bh=emRa1ZaSZIr5ALV50yMjG8A0cdZ9I1fa9JB3Q0Yk7to=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qEnfP5dYnm+jSFIsvmMD18WhQbwgLByk09YSs+yT37060vu8sLEoP0DXKLx/U+C/OsFHbpudZnMLoHthR6yQe+UtmiLCpxAimz4I+JcsWkDNEEbvhiy9jNRt3JdSTw/mPgqaxa0YwipE3cjHBRJxDT5pH3qrTQXrM9K73K3rZIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A2kVrrVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A2kVrrVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE355C4AF09;
	Wed, 29 Jan 2025 20:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738180819;
	bh=emRa1ZaSZIr5ALV50yMjG8A0cdZ9I1fa9JB3Q0Yk7to=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=A2kVrrVOywfPZfY+R6PUS/hMBXopkQuBmTTWdYf+KLkOKcutGscoB84vodYHT/OAM
	 3sp32xG4z+WfBLVFvKGIr4hxFD37rc80YEDP4NUeFl9ennZRo9yRZEknpBeGCSFXds
	 W1vjndjBo647rALkpTSnIVJsmidhty2eZ+9VKNLr1bwVOEvSI1wilmJcBBWTSkmLLr
	 1s27FKzCSoGarctEZen32PGyWV476AAA64iLyYkUhJCOOgQX6VxoRX1zwSuNzA8PCc
	 mw6lytgNefjbdDbc/kYUMUCuEzHJptlcS/aDtouBUfGIl1Sx+Y5OKDf0fr6BVCW265
	 myqIkcX0nIYDg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33CE7380AA66;
	Wed, 29 Jan 2025 20:00:47 +0000 (UTC)
Subject: Re: [GIT PULL] CRC fixes for 6.14
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250129174135.GA1994@sol.localdomain>
References: <20250129174135.GA1994@sol.localdomain>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250129174135.GA1994@sol.localdomain>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus
X-PR-Tracked-Commit-Id: 5e3c1c48fac3793c173567df735890d4e29cbb64
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fed3819bac88835b54c68a15ba41d95151ebaf12
Message-Id: <173818084591.411204.14355685122106150739.pr-tracker-bot@kernel.org>
Date: Wed, 29 Jan 2025 20:00:45 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Kent Overstreet <kent.overstreet@linux.dev>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, Theodore Ts'o <tytso@mit.edu>, WangYuli <wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 29 Jan 2025 09:41:35 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fed3819bac88835b54c68a15ba41d95151ebaf12

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
