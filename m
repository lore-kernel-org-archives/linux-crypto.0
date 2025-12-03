Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94DF256C88;
	Wed,  3 Dec 2025 03:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764731687; cv=none; b=CpQ1TrSnTLrVtBxikOOW6+S2rP8HpzJafGIKdIf0cG5m1AGT0eXH2alsxYlaG2nRIptTtUrX5y2jrz4h29fJ5EXuXiUVup8zyvVQ1ghC2NheHCSQ0PfxOEl9hf7g5+ftwc5tcjgP4o6OvtbOWM9NV5DO2iTHesI5A9+LIWKB9x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764731687; c=relaxed/simple;
	bh=tEnfEkiXoPZyA7Gb4774jfHkvE+FNDSrAzS+QT32Q8E=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=KafZtPgko8LlOPujaQDBkFGrVFzwGJkLm9toVNFoV68ckpxeSMwvKJzLu5LY/ozpTliUlQnYsq5/NPDFcCPke2yCLB2z4ppWQbdtkuqYwAEqyoU6WYe4lOF+HhMeorRR92Orv4X8PouGWcyQRlVCozd+JCTktr2YTFvrugrTscU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XacF4OdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XacF4OdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F65C4CEFB;
	Wed,  3 Dec 2025 03:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764731686;
	bh=tEnfEkiXoPZyA7Gb4774jfHkvE+FNDSrAzS+QT32Q8E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XacF4OdHHOzK5r1C5oglZt7J+IFiSHWWrPstsMIwEvMNRCtZXYvYchd/9AGxj3C/2
	 52l7vUT3gcBnkG+d0wXNdip0mLU7j9sXgQfH+eY8td5QoXzyI1k7cegtvI+Qrmpx7A
	 Cp+oOLICtJW5t0155NmpVvTlhqv1KLBqdqU94RrE/jZLb+x08a8GGOAdfYVbpbl3In
	 MZchgWgiQe6koOujJJ8Cn0vsx6doKjrcRlTdO0jD1HU6jgY+9FCMr4v29pzks9SBdj
	 LNnSEh6MVL+qbNfT5Hn3VRSOaevxuZYY2e/lVVazGNPamv45QI1G5i4swDRb3jxDrv
	 OPG4pvWRQw2dQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B7A03A72A63;
	Wed,  3 Dec 2025 03:11:47 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library tests for 6.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251130024401.GC12664@sol>
References: <20251130024401.GC12664@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251130024401.GC12664@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-tests-for-linus
X-PR-Tracked-Commit-Id: 578fe3ff3d5bc9d851d597bb12dd74c22ad55ff8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: db425f7a0b158d0dbb07c4f4653795aaad3a7a15
Message-Id: <176473150571.3498170.9812476991509806739.pr-tracker-bot@kernel.org>
Date: Wed, 03 Dec 2025 03:11:45 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, David Howells <dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 29 Nov 2025 18:44:01 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-tests-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/db425f7a0b158d0dbb07c4f4653795aaad3a7a15

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
