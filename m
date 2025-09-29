Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F09273800;
	Mon, 29 Sep 2025 23:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759188164; cv=none; b=Kq8Jk0MliG/orl1Yz6B9s3v70tm7ErBBzr5EHQg+xV+UV2XzKWxqdj05/Lw/sK275KdYtN7UHs5PQQt0BPNpxHNI7Hh976iPeqiUssSLpjTJxsJla8armq1LZoaEguvWn+3Mc65eeLZJkctnKCXw/d+UTkmLkB8l8AWB4BTv6Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759188164; c=relaxed/simple;
	bh=OzZWO/GkM8jNfcxogMz/Fn3WzXD9+GWKqGGoZITx1KM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=QcqUTlMQF44rVEgmfYzJigzeCFPncNrK+lGrweIJSRtukErgLRh15Ttl+INgLiBtgFV68h8q7loHnOEixLuuPae4oAEJ7ExVmkRgwJl2A7D1v3yXhGkdpBM9PB/zL8EtB7iLxpnbJFPsqOR1CSbYcKWs3g2fmV4KlU0hBapsl3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mIjZvgT2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mIjZvgT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362B9C4CEF7;
	Mon, 29 Sep 2025 23:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759188164;
	bh=OzZWO/GkM8jNfcxogMz/Fn3WzXD9+GWKqGGoZITx1KM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mIjZvgT20dmDqYsJrDK4pqP45A5vK5beG9O8GIaDKk+ObyDQjLpKpDqAZC4hgsYSt
	 odxcdGWGVESkvbyjHOboElzLt89ahft1cthcVTBBY9az+3IjOnf+gtu9c6HJsy8UyY
	 vXPHKy6eNZe+LLg0DT1UFSYVWZR3+h4AQ9PFsJ16axyfzrbOtdt1vYnSDxWPVCPEkE
	 b3WRHAtsWTqB4PAC0iB8SQeWw4xKO4bT+ZrYKCpq78laRV9zDsA7bFSJI+lpImM4Oi
	 Ke2Su8ONjbJ8jgGdGdSXT3uG/ggC8nATgZxe3/DJdrFHcDDNdh6F7vYLNHyb36Ps6+
	 mKzUACuon2Avw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB05A39D0C1A;
	Mon, 29 Sep 2025 23:22:38 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library updates for 6.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250927200131.GB9798@quark>
References: <20250927200131.GB9798@quark>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250927200131.GB9798@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: b94bc4398beccd329a51052c5e7e84e4670dbcd9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d8768fb12a14c30436bd0466b4fc28edeef45078
Message-Id: <175918815759.1748288.5369810754343583702.pr-tracker-bot@kernel.org>
Date: Mon, 29 Sep 2025 23:22:37 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Longfang Liu <liulongfang@huawei.com>, Zhihang Shao <zhihang.shao.iscas@gmail.com>, Zhiqi Song <songzhiqi1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 27 Sep 2025 13:01:31 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d8768fb12a14c30436bd0466b4fc28edeef45078

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
