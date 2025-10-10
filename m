Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374C080604;
	Fri, 10 Oct 2025 18:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760120725; cv=none; b=JfzuvdVK7EaD3ASzgU4gKl5GwPoTLzM0U/c9/t1bnnkuV8a5ST5gNjoawF6sLod3zO3FYcu7vXryuTJH5yGeQBnmAtnKqQ5uj+q+06GvFSdayvvmN4p45h3dGgZFB/zHZHQgvii4ij+z9YuEkrbahtB+wDIfiFx+u2UuSi5iSZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760120725; c=relaxed/simple;
	bh=fAmDhQhLpZsbE1XKoeEo/U43tDVbxfYiL5jTe/N8bLg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=nPtI2EN45V4kFH542HttbW5VSoJLUnBnYIo79y/CdH3MU5jroCAtECTXwFKwGbP19kibnXbfdn+hY+gfUBSq+728A/zd2w49MsMTQHrcWPJIy1UQ4tRlR23gSp3AtQ7fabgdhFxWsjaMFcYhS+I478ffF+f9fLAJ5Qt8n+BHzQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=caVYPERi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caVYPERi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16121C4CEFE;
	Fri, 10 Oct 2025 18:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760120725;
	bh=fAmDhQhLpZsbE1XKoeEo/U43tDVbxfYiL5jTe/N8bLg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=caVYPERi2s/pmptUCFOP8H0RftjN521kdNIGZ3YfKpHBxs9/CJnPwYMBKldf5cief
	 j32jvcuowcAJ+K4gld8MpoUzoVFXmz1CdJlV1DK93ITFIMlkBXUZUDIvVIKEa9+OIa
	 siuPtE0BMz98Z3m5/qlkF7a0xkOlGQ3G63rD0SHNn0uPGiQ7//v7O9GJ0ydaHU1QVn
	 9xfrakZGHcvHQBLL9Kc0X1LmOdJUnaLg1qLCcY+iJpZditK2+nXs9b0L8/4v71C66s
	 x0jx5ZQrA0NTsqLtJIJ98AmmvTqRY1h6mS46Y/Lrm2cgt8jwENfDQL2sOuSB3jsoWG
	 HWFL8h9RtH7sA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF6B3809A00;
	Fri, 10 Oct 2025 18:25:13 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <aOjwVEx6xDDRKiAx@gondor.apana.org.au>
References: <aOjwVEx6xDDRKiAx@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <aOjwVEx6xDDRKiAx@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p3
X-PR-Tracked-Commit-Id: 6bb73db6948c2de23e407fe1b7ef94bf02b7529f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0ae452440cb9fee9079dc925f40cd824c1a9de2a
Message-Id: <176012071215.1074429.8699595490890675969.pr-tracker-bot@kernel.org>
Date: Fri, 10 Oct 2025 18:25:12 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 10 Oct 2025 19:39:00 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0ae452440cb9fee9079dc925f40cd824c1a9de2a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
