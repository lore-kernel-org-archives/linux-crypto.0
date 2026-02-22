Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EBE1F8AC5;
	Sun, 22 Feb 2026 21:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771795178; cv=none; b=dbSdujUhA2MmXsj/iUWVyNmsn+/WMSGtzsVHJ+FwjE2ZI04OqUX/zkTLZv28pjVuh/UECFbdub8cL7ySXaoTrX7UIJkmAuS7iT/LCVTazGRllZwmtPe8eujDDT/M46YCSV/crcmbUc7Tcr9l+dtNZtrKt7+caAVBZlYMcbPi9VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771795178; c=relaxed/simple;
	bh=YQ8MiMbU2gaw1BUCBjolouOvZgqpI0bY7QYQ2Uv7Ulg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=B1j6YrGrvXOu3b62/Z20/Y4sqYnMCbDh3FDdK+UnbaOSUgHjUKmCjziAqFH4bVo4wsBm+VmDcJCXBWyGtlzBhF+vBpupgruTx+PYez2xG85ULq9OAaExLjAgc82dfABQH9+9r7nrrrAtrm67CPoDLbSC+RSHh+FxKcMRYbaQPa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgGA8UVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgGA8UVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DA4C116D0;
	Sun, 22 Feb 2026 21:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771795177;
	bh=YQ8MiMbU2gaw1BUCBjolouOvZgqpI0bY7QYQ2Uv7Ulg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=SgGA8UVa+DLbtw0uMMvdZM0mvbx/1tm3J7uJ5vhW8vKezdHW4feJ8Uc7oz00Rw7Wp
	 uDc/8Llr7uR7QMSYf5wMXi03wxPNIA2ry9TD5na5325D8Cb+Fbg4ktpUjUGsnOQlel
	 w8JemU5TxB389F1qpNtoU0uONDOyQ/o2wQ3izl62aGyDnYjDsvEBnRaruAynXIRdmt
	 cwKBFnRdyD6e3xmj5Z0/4FJVZYoaJ8YnZ4iWsUH/rQVtMfHa5AoJ430Y8MTFlX9OL8
	 pqU+HschbZuRn8QLEuYXrWLKC6XLOWkUriJop6Ef3vB5JdoFJe8yQ/eEKz+HW/dpF4
	 I224K1FdFjpfA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA09A3808200;
	Sun, 22 Feb 2026 21:19:45 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fix for v7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260222203543.GC37806@quark>
References: <20260222203543.GC37806@quark>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260222203543.GC37806@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: beeebffc807531f69445356180238500f56951cc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 75e1f66a9ed09f29c6883ea379c174e8cf31f7cc
Message-Id: <177179518422.1502390.6995161937246919166.pr-tracker-bot@kernel.org>
Date: Sun, 22 Feb 2026 21:19:44 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 22 Feb 2026 12:35:43 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/75e1f66a9ed09f29c6883ea379c174e8cf31f7cc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
