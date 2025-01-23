Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF0D191F77;
	Thu, 23 Jan 2025 04:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737607728; cv=none; b=XQ3z6oQ8RO8oj1AO97sW5+Yl+awnlD7eXs8tIwKwcqXIsJs6UPRwYo8Be/S1p3VygjLPvhlf1i8hxQaUAR5dzqhcoPyRHcBz7gKbaBaMlEj6WNdzCvFWOHy9AXRaNBwPy2He7xGycZFmNb5858P2EDaD24u/CYQda/cBtzEQvIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737607728; c=relaxed/simple;
	bh=y1+iCRU1U7QeTPTHL2n95Gj9Y2R+DTo7f9tuxrOd4JQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Fk5N7KSjEeyQJIDNtK2uoQJvzAtlOmunoXiBUTj5SQox+YKxCxBZbvoZQo8jkmiYpHhut4xVvY7a+WO2rDqxlCWA5naMqdIrxEGZlLIjeBDAOfHqqguRfcLVoST5R9I/oVKpqYEIKFnbkgS0qspjqdDpxu1Wci2jiohTtnYu1/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0vDNj3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0vDNj3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D8FC4CED3;
	Thu, 23 Jan 2025 04:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737607728;
	bh=y1+iCRU1U7QeTPTHL2n95Gj9Y2R+DTo7f9tuxrOd4JQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=X0vDNj3ftI9/qnPDqCUc95JNQiVDjJXGe1X7EsEWpc3k53L/3jY0PzfD8GP9QagkI
	 oNukaTnuwrcn4mXvaiN72C0ld/af9ZMpUQl5nBZkz6AgXZnlOUZMOEF0CSx5CMaV+3
	 /SgpU67ChVr7nz+6vtjRDCJ+/xGGuch4CGS+RIF4A+RlczAfywkyXYyhV/GQVupk6H
	 3LxtpJyy9Fks8023GJ4UslDGZRBcuy5KC23M8ttH81A2LJ7BV2SdzZEHA+gymFKufD
	 YRK0UpEEksw2HF0gsUU7PZ1jZBxIHmJw9KYpEbufj57627LtCC3/HuE3zV9rJdvxsB
	 tha/Ju7TUky5A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34218380AA70;
	Thu, 23 Jan 2025 04:49:14 +0000 (UTC)
Subject: Re: [GIT PULL] CRC updates for 6.14
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250119225118.GA15398@sol.localdomain>
References: <20250119225118.GA15398@sol.localdomain>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250119225118.GA15398@sol.localdomain>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus
X-PR-Tracked-Commit-Id: 72914faebaabd77d8a471af4662ca0b938011c49
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 37b33c68b00089a574ebd0a856a5d554eb3001b7
Message-Id: <173760775268.924577.12088549785918915041.pr-tracker-bot@kernel.org>
Date: Thu, 23 Jan 2025 04:49:12 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Kent Overstreet <kent.overstreet@linux.dev>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, Theodore Ts'o <tytso@mit.edu>, Vinicius Peixoto <vpeixoto@lkcamp.dev>, WangYuli <wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 19 Jan 2025 14:51:18 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/37b33c68b00089a574ebd0a856a5d554eb3001b7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
