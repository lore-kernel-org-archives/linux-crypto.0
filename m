Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802662BEC3D;
	Fri, 31 Oct 2025 14:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761922198; cv=none; b=mYMyG/kicdIeQnOXMIGigVGi83J2V9gtIZnECxJACGJ5t97s5EdUWN5S008enlj0XqKzBPeQPm+N5isTNSAVPLqnIDcN/23OpYJL9IyVz2Bqk9kqhgblKoQROZEfExPCxTkR6HTXA3NujASjG/hKbwZ6je7g9DVwNmX2NnL+GDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761922198; c=relaxed/simple;
	bh=HLdqFGgxA0GPmDUUA7HdGRWTPcEU3gNNMC5MuOq7yi4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=haj6SxxW5XSLQTtHQZmCzj2CZC/WNNhJW8BDltHwtgwu/Fv6YlwqAY7vhYvKVve0XTJlVnccE/OkIBRUulkgMBDhxhcj7huTq0gbs5+kLqZ9lNBVOK9urySYbBxQdhCHK/RNXl111rSZo3OPQONFqEoyvZDugtg+bGKDLgiMeqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPMYv4Ip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPMYv4Ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCBDC4CEE7;
	Fri, 31 Oct 2025 14:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761922198;
	bh=HLdqFGgxA0GPmDUUA7HdGRWTPcEU3gNNMC5MuOq7yi4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PPMYv4IpbeGeY/SqFnPVsiNu7sCu56fgR361h3BXCxrVjF89XaQ5SmBYO8f7YkAKe
	 KAbB+KSYtL5geKS8TaomcpKq4QzGHO36zL/H6ug/aNcz1lcUbhcpKUzia7Bpfj4/OI
	 +Zu7bKmAmz3nY97Zb+bCR4Txzsy1JpUTX3wEBRH6Xcgj6w0kKSTNYD33+c8IVC15sH
	 +XFW9tLSUJI98+4LY5nphKCDLutHRf435U3dMsnMqSfxmaUJX96qCvPqpsIwwqgMhB
	 hoVBsVt3wxzIZFKAncg1J1q+xeQRaLpqeclBHwYDJQD0A+p54gdowyA+/SSYFDbTw4
	 5wD9NQYPDGzXA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADEF63A82560;
	Fri, 31 Oct 2025 14:49:35 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <aQR_duMIT385hw9N@gondor.apana.org.au>
References: <aQR_duMIT385hw9N@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <aQR_duMIT385hw9N@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p4
X-PR-Tracked-Commit-Id: 3c9bf72cc1ced1297b235f9422d62b613a3fdae9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3ad81aa52085a7e67edfa4bc8f518e5962196bb3
Message-Id: <176192217420.504982.17366932003623482304.pr-tracker-bot@kernel.org>
Date: Fri, 31 Oct 2025 14:49:34 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 31 Oct 2025 17:20:54 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3ad81aa52085a7e67edfa4bc8f518e5962196bb3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
