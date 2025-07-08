Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CC723D2BB;
	Tue,  8 Jul 2025 20:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752007227; cv=none; b=u8nFQOkCXOmrjbWmOqz3lZjISHFsD/XYv+FsfzHQP63fx04bGfvpgTppT2Pm778N5rRba4kktA/DETyEWsZi9SWuRlt3b87SS7h5570yBYwZF1cFMGwOsCYFAHFFYLt8Rcietvs9L89cwLQpCkjJ+VmKb0OsxjPSlS9wzm6iWXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752007227; c=relaxed/simple;
	bh=ZIayn8e4OzueYZMELhL5+WOuvDI/74uotmmV/2guudU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JSwl/TGDX1GvgIvmv9LiifxoSdeE+AaJS5veO1lw3JR2PO/jkRUmuh4vtLZA6Yy4VJKY3F4BCXDV8KF2HoT0dUO5TeizQCKmaolHlYDDlOMDcsYYqJlB08pGnzahHlsYIg9cgkLOH9Lrl+bka8PShSULlFiQFsQ9TQGHDOiT+nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmfhclPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmfhclPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D11C4CEED;
	Tue,  8 Jul 2025 20:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752007227;
	bh=ZIayn8e4OzueYZMELhL5+WOuvDI/74uotmmV/2guudU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hmfhclPJfhDclhh6yFrLN576vtqoJ3grCBVos+ubavvIoqVo7H3dA+BflVtC9+VmY
	 B8JU5hKLyUvij2APBJzVE+KmgyL+ZYjABMoh/4CR1eok6VcWIT468KVyZ9xSLaQbZ4
	 MBlPWsm3SOOdNpVeFzfBKd4tw1YGqj2PoxbnolfUEUO4Gb0rOSsZhHmH1Lu6q+7pvv
	 zckI7tVHLL0baDQtoIkN+9u9QODyYQdFSZ+xJR2Ueti/YjVi0wwSMM1gUyvMV4zyFg
	 +zwh8NjKv9lAF5DGuttnGlsSjviPB6E+Kl+NqT/WEEORSmu6C1Xtz5NBRmckfaGKuO
	 FbNdF0bGhWXDw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB171380DBEE;
	Tue,  8 Jul 2025 20:40:49 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fix for v6.16-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250708164517.GA1255@sol>
References: <20250708164517.GA1255@sol>
X-PR-Tracked-List-Id: <linux-s390.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250708164517.GA1255@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: 68279380266a5fa70e664de754503338e2ec3f43
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a3b5b88ea9bc9da00bd89d94738bf7181b2516f7
Message-Id: <175200724864.8458.2505833963148624358.pr-tracker-bot@kernel.org>
Date: Tue, 08 Jul 2025 20:40:48 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Heiko Carstens <hca@linux.ibm.com>, Ingo Franzki <ifranzki@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 8 Jul 2025 09:45:17 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a3b5b88ea9bc9da00bd89d94738bf7181b2516f7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
