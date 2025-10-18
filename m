Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DD54A07;
	Sat, 18 Oct 2025 00:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760747423; cv=none; b=OKRtVJny994ahqS01sIBmcdYxAoMeE44/3OlTUMIx+x9zqDrGE94LAnN6+5HbynBw1LRG+g7i6b0SrhQPtgUbq2YeLRhF9ywOHKrDerMbooaviBD8zjs87h24YlHCy6wnFCW2tCdsmpQsZvxaumqyAvumjg6zHQSJiZXDstHIi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760747423; c=relaxed/simple;
	bh=TbpdMPxTnyQryq9EArjG4g/pRLmvfKc+mSNaVgK0Dp0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=bwgLW1jirbZXmT9ile2SSZe8Z0fjVWZh+6mqMXWFJbV8rIgLTLRsceg2F/jb4Ujd3DaTQcTfdy6ZoFWpB6hI8nuHYAeB+NKmIPMvpd1MczITeyQ91zPPOduscScsbT1eg+ZpdQLGZQYsbAw2XLPO1xI+HKFcftrl4RX+aFfAU0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dza9S3M2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dza9S3M2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3C9C4CEE7;
	Sat, 18 Oct 2025 00:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760747422;
	bh=TbpdMPxTnyQryq9EArjG4g/pRLmvfKc+mSNaVgK0Dp0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=dza9S3M2NUOb+3VPYJIJgK6bcDW0RUAXmD4g1z3fUNjuJMO8aLdE5LnAGRJ/UWmoL
	 87E1tlpCzFlUPmrs75chd6ylBtyjvXqa5LnIe1WQRbMl0hjQ/SLC0G/aIJ4cFw6Hl0
	 EKed1UMMq4cGD64KMQdOQUv2eqnwR3lmTyagZB4K1XowYyPfC6HKdftllups7Yotvk
	 SFju4mM3XBkCJUMDguxR+7BCqBZ4Am0VgQ6gbATvQ0cWHYe71/fy5Rn2T5Gc48Qhra
	 sVcsi7j6Dcg/PaEsPIe26w6E2wS8JkWPGmz87zHyGqi5T4JWKU0T/OX4v4gH/54ZFL
	 xWPndlEDlftAA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33AEE39EFA60;
	Sat, 18 Oct 2025 00:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: Convert tcp-md5 to use MD5 library instead
 of
 crypto_ahash
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176074740600.2838675.12865926124938428065.git-patchwork-notify@kernel.org>
Date: Sat, 18 Oct 2025 00:30:06 +0000
References: <20251014215836.115616-1-ebiggers@kernel.org>
In-Reply-To: <20251014215836.115616-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
 kuniyu@google.com, davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, dsahern@kernel.org, 0x7f454c46@gmail.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Oct 2025 14:58:36 -0700 you wrote:
> Make tcp-md5 use the MD5 library API (added in 6.18) instead of the
> crypto_ahash API.  This is much simpler and also more efficient:
> 
> - The library API just operates on struct md5_ctx.  Just allocate this
>   struct on the stack instead of using a pool of pre-allocated
>   crypto_ahash and ahash_request objects.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: Convert tcp-md5 to use MD5 library instead of crypto_ahash
    https://git.kernel.org/netdev/net-next/c/37a183d3b7cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


