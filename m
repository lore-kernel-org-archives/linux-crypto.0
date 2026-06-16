Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170ED3C76A2;
	Tue, 16 Jun 2026 03:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781582246; cv=none; b=L90e1UuhB09MSEFhhew4wBUm33bmwWliwbZxM72Sr6fRhuGzZ0qQSROfwiw76xDPWSd5NZ8k3O1w0sSoiPLtLUJTPFF0iEFhIUYDxspre55bdjZb9vFJXS+1Lb5Zcd0bh5UJlb8TVIr8NBScfo44nhvMF2gY8TICzu9cEmIr/Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781582246; c=relaxed/simple;
	bh=/x7+wud4p4//jwO6sHQpHbq0knSnV1p+m9RSn7jCNT4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=urdeoIyc4Wgpjepy+rAkz2RaQ566O2Zdoo8WI/zjMIqrZH8GYYQdxcY52tokL0IwHqThmEXDF3PhV76AsKh/dzh0q4nvkHl8QeWqzR88xoOlSPSSV8Gb9Mw9iK67V6+GJtzUIjPrpx0mTk4JTRguVIQHbELSsFzzalhzqgcvee4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xw2cMGwj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xw2cMGwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19651F000E9;
	Tue, 16 Jun 2026 03:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781582244;
	bh=1xpIJSTc/EKDVe7Rsp6mx/xsVw/icl1eA7buZMGoQ4A=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Xw2cMGwjQmwirUJwPKvo26EsWvWYyo+ddWXg6tiUT9tmUjDbEKyfdG0fBkpsLp+n6
	 pb4lWCA6agRRtRDmrFQkpdQOqoU/sGXne0BBlBZmzSgmnX3mTg1G+8/t1AQ4Bjb9TD
	 45jVeHu0PvTPYNzfpX4PSw6Y4721M5CcU+IyHvkevGDdpgNpXyeHFCKyucg7fcNG3n
	 GbQuom4lwq3KtpQ5R1dpsfLCcEi/I1RYyTdUKjlzie6+iilXKyLmpdmJpmIDAfADFb
	 5GnVdODcy9her5f3dulHccNQK2cPqsFo8SndJUIBXhL469C+uMEm8Lv2ZxO/h86422
	 kyTNrN+JHHWgA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199A7383BF4D;
	Tue, 16 Jun 2026 03:57:20 +0000 (UTC)
Subject: Re: [GIT PULL] CRC updates for 7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260615174807.GA1831@quark>
References: <20260615174807.GA1831@quark>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260615174807.GA1831@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus
X-PR-Tracked-Commit-Id: cbe44c389ae80362e72696ac08f7c55a83f2a050
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ef3b7426a63c930c51d60d6c2428663d52a84e2f
Message-Id: <178158223877.434177.4901029841879163152.pr-tracker-bot@kernel.org>
Date: Tue, 16 Jun 2026 03:57:18 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 15 Jun 2026 10:48:07 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ef3b7426a63c930c51d60d6c2428663d52a84e2f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
