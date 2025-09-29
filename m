Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B332676F4;
	Mon, 29 Sep 2025 23:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759188163; cv=none; b=byisFKr6XgJllvzA2BtLyrZppu1L40dHjvKh60+UiCrbdFwPu18n2XpjVTnWga8F7Fh1gFtFhuxsX/dze+jRbjTuW8HHLgQxzFCFAdMQjef36B/ZVfCYsV4FgX4crl9R3uvadbDh/eKECp2n7iX3KuJsPUqVphm7TgOivnvVAdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759188163; c=relaxed/simple;
	bh=OfFT9FbRxh9xUxav8ZOLm5luySP25QLHLU4Vfz5J5g8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=AZhbl4QpDz8PlTFYJ+M7p3GgBUR+xFY3AFjNS1+TtXp8lxCFfMONhyWsU1TAIHr7v9eONzlXTv9PirnGAp/EkQqKEfpstWLw7oXW8MP7vgjwuLAhfLhpl1kz66YMZL0e7r+KEWkexjIGMtBqWCfRCYwTc1rWnDbahLNnmFU91cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtlahbSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtlahbSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A45C4CEF4;
	Mon, 29 Sep 2025 23:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759188162;
	bh=OfFT9FbRxh9xUxav8ZOLm5luySP25QLHLU4Vfz5J5g8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=NtlahbSt2wK1uRHAzGMZGmzAbW7JiEYKYu+0WNvQdgjJYnSg+UgoBnqkH69eVfuWf
	 3WIum7HfbozH39MbnjcfKDPksZ4cuFmGYK0W4vMEPU8eFSMfVFnuE2tqUqlYN+m+1y
	 21Bu3/WNa8zXVp7AxVLiKpuLzTK+XfOL7oZU4i40DoirSTIN07aSx5ABxD7/UzuWHM
	 A655EaitK5A8odLKEmIXgH+UATY2WKeEndgYRanwtGZOTaduTy6WoKt8tOorQtUx5V
	 BkLug2NVw9MssWXqYZFIDqlgH9Xo+6LoImJ7g64TgvN0NYBnXuCg8FXzSkphlAUSBp
	 lbxjrikPCbv7g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7200939D0C1A;
	Mon, 29 Sep 2025 23:22:37 +0000 (UTC)
Subject: Re: [GIT PULL] CRC updates for 6.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250927195257.GA9798@quark>
References: <20250927195257.GA9798@quark>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250927195257.GA9798@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus
X-PR-Tracked-Commit-Id: 136d029662cdde77d3e4db5c07de655f35f0239f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e2fffe1d958b3660bc4e07e6542d97b6cc168826
Message-Id: <175918815602.1748288.9081847177239298046.pr-tracker-bot@kernel.org>
Date: Mon, 29 Sep 2025 23:22:36 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, kunit-dev@googlegroups.com, Ard Biesheuvel <ardb@kernel.org>, Rakuram Eswaran <rakuram.e96@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 27 Sep 2025 12:52:57 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e2fffe1d958b3660bc4e07e6542d97b6cc168826

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
