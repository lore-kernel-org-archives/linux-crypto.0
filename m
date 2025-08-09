Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43B41BD035;
	Sat,  9 Aug 2025 05:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754716782; cv=none; b=p5JIl8S2S9c9H+PKCw9u1qQeU4OtL83FhiDizNh1ZvDqA91JxYF2p7ydelyTY8nJk55zrlFP1M+8FluX7Da5XzDLxXbzvIKJMIOlbf147XE5Xdu9HbiSYyw9JyIldUTXJgHQ6OchDm0dKGKc0UQoCOB+0O8378boAsVbTwB5yyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754716782; c=relaxed/simple;
	bh=o/Q6oXK95eojTB5aBs10Ti5Dfs4qZbnilecSrMHqIp4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VeM4VxxK5jLWTic8lNrfmFEc/EhXlZElrpZ1WW3O2ly3jJoMUdO01vJo1X11x2S56SAEV6L9gALlLXRRhyOxbFuQJ/1CTXQ8SyjWDBPtA9LIzcetXtaXtiJDSqz3acKfuJNOokDSxl6dxsoJGJ1ytSP4efm0J6QnZ+3ESzSzOTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qcBQoWzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qcBQoWzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EBDC4CEF1;
	Sat,  9 Aug 2025 05:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754716782;
	bh=o/Q6oXK95eojTB5aBs10Ti5Dfs4qZbnilecSrMHqIp4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qcBQoWzxO463OUOFf4JyOkfzmo2ILvcHIcMMWedMPirZU71B3SkrlO68/yqV/mgAP
	 PO8aYhyU+C9wQaD4ER8JNHHfedoFjfMxTZUb1JA3avbZ9su+2oXFLs5/S+Um9/5gn+
	 uYjwjsdxuY+vBX1gXf8OIy6ocbpqCE2s2sf0cBSFVj4kFlYvRNgtEdeaHO6C5F46m6
	 9oTWsd9izy3UqZnx0pYghRUxTF0iLfbwqweLbjcd0loT4BNYPV2xA9+rasRUkVeJKp
	 i6OQZ2pTtx5nDjzCsLBqWba1Zz1PoZM6y38aNDNUaFiRDRcRmFUY0OTGtcCdbwxdbk
	 Sqtn9ZGp+TMtQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAF96383BF5A;
	Sat,  9 Aug 2025 05:19:56 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <aJWOH9GgXhoJsHp6@gondor.apana.org.au>
References: <aJWOH9GgXhoJsHp6@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aJWOH9GgXhoJsHp6@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.17-p2
X-PR-Tracked-Commit-Id: 9d9b193ed73a65ec47cf1fd39925b09da8216461
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 01b6ba6b097a0ceeef1975ae37c1660fed1b560c
Message-Id: <175471679557.380510.9903755724887042086.pr-tracker-bot@kernel.org>
Date: Sat, 09 Aug 2025 05:19:55 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 8 Aug 2025 13:41:51 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.17-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/01b6ba6b097a0ceeef1975ae37c1660fed1b560c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
