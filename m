Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599A91C6FF6;
	Tue, 29 Jul 2025 01:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753751523; cv=none; b=WJ4xjszjkv0Rd4jP7S8djoKNlvYTj8nILdUVQ7XlCf3ne3ZIps3vdG9lnHhdtkkIn4w9QvA+J5hzyd44aYfD+K2TGhVTQanp3peMDruWAjMQ6BqXnuIxodULQziYM6NRwO63bMnx/Cz7N6O6vJjRWjVuZp8iBoexnHr3bO2QTP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753751523; c=relaxed/simple;
	bh=4HvhE2BJsTW/nGWIJs21PM1ZhGsIQTNgAJvcYNkWczc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=UIs05L9CGbhJcMRKgxCtpiDxdUQxb10iZwpEqRpiSNS64PD+PMoha1hgAPqCkG+CBrPkarm7gqor+GT7LsPdVnVBlJL9RKeRgfaPc5eNUeHwSEEbhWlj2hGWsgdW4Z+iztNaxPcJekzRcJFR72tYYKIls7s66wIVp/AVVdYrmto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/ILjos6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/ILjos6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE67AC4CEF6;
	Tue, 29 Jul 2025 01:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753751523;
	bh=4HvhE2BJsTW/nGWIJs21PM1ZhGsIQTNgAJvcYNkWczc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=A/ILjos60Xqg0Vaq3yMINQsxdvdNnjl3hwoG+WYvClUwZYL4ahd1I24B8b3l0W3GV
	 HYVNIx0SFNIYgP1eQJXonDSuwZhNUkJ198a+todzePRR+swl9edqPhzJPPpI9F1JSq
	 0w1G4UZcnOYtN74yima1x41UDKKPe1OeqnD1P8YV88zBwxy17YXIvGGUHOBnhsuHiI
	 MHyCp9rAUFN/J62kRlg6Un6hkiGfSQRvtwii1MBEliqRNKnl4Q+I4FsK9A4HZRaF7c
	 JzYL4gQ47Wg0tmA0DC8qAQKW5Cu4vDSz2wCGw63fL+thHNR1ZhvA0HnJoXhVb/psrp
	 RnypLtQqr2+WQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADCFA383BF5F;
	Tue, 29 Jul 2025 01:12:20 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library conversions for 6.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250727234542.GC1261@sol>
References: <20250727234542.GC1261@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250727234542.GC1261@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-conversions-for-linus
X-PR-Tracked-Commit-Id: 998646b3c1129188f1fdffac3779feb9708b4b4a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4b65b859f55b036649a4525f09fa7c5bbbab384e
Message-Id: <175375153939.918485.1163691169468282516.pr-tracker-bot@kernel.org>
Date: Tue, 29 Jul 2025 01:12:19 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, fsverity@lists.linux.dev, apparmor@lists.ubuntu.com, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, John Johansen <john.johansen@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 27 Jul 2025 16:45:42 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-conversions-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4b65b859f55b036649a4525f09fa7c5bbbab384e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
