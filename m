Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9A03FD15C;
	Thu, 30 Apr 2026 08:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777538994; cv=none; b=WTghPVbHkYndyqYjNBsTLaRfr57a9TvvMNrgVM8tqPoOZFL4Gkjhm1HTtkSHx8Wl4R8p1WCx4x1o7H92F6ev9jKY6OdO21wKoKz/7KsSLPCKOiSct8Wkfq48lOEw5QcSj8M6Kh21rQCmyWwARILEnF40mrKTJtjfB4k2UaGCcXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777538994; c=relaxed/simple;
	bh=Ig2KLrSxctNzfv91/Ob0md9MNjcSl3mUxpCXDK4oFKo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Nc6SoYGhuCytQVWzphtZSN2+NSZnPt8288m/+mKU2O+ETcLM3bgFo7Fx0WsUf34SeaIUCtyTsOcebGPFFSoLCGo/C6pjsZF7/+fWRs3ToLPa/ciQBgVRXBClGLGqtdaqb5ziZaWFB8HuAPyU7miSZg0wNSbJyxtrodrH3SMvyH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1TkQH5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1TkQH5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDD4C2BCB3;
	Thu, 30 Apr 2026 08:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777538994;
	bh=Ig2KLrSxctNzfv91/Ob0md9MNjcSl3mUxpCXDK4oFKo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=l1TkQH5Dn+sUZ3til3wuTYPRDB+JaNiKkdXyEkx0f6Hh6E1yu5YdhowBr0/KzN7Ma
	 wQhxWNlRXB3zuGY8wsxlKj46yayeWaKAWRGSEnioEwjzfGYXbqYzdmjCnPI8Aulc7R
	 TYRT1Ojwpx5QEUy4kZu9xjnyn5Jhfx/HsDENJ1o4zh2IPTJtQnif/8+Gk+MFJoEkGi
	 DPAnWRnDuWGOk7dFK1khzNA0TnU+eDrwWnMQIRrPo/vjLEO23FKCOnGqhWQP8mos0i
	 tb0PRSYeYiCAtufnBPi4eMA5i+h1h9E2u26Rbs25sS1u7iN3igzkbGi9SoZDWZ4Jow
	 XbeyHY5usCwVQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02FFF380A95A;
	Thu, 30 Apr 2026 08:49:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] Reimplement TCP-AO using crypto library
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177753894880.2417501.17222225356856785813.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 08:49:08 +0000
References: <20260427172727.9310-1-ebiggers@kernel.org>
In-Reply-To: <20260427172727.9310-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
 kuniyu@google.com, davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, ardb@kernel.org, Jason@zx2c4.com,
 herbert@gondor.apana.org.au, 0x7f454c46@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 27 Apr 2026 10:27:22 -0700 you wrote:
> This series can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tcp-ao-v2
> 
> This series is targeting net-next for 7.2.  To make this series
> self-contained in the networking code, I dropped the patches that remove
> support for transformation cloning from the crypto API, which is a
> further negative 275-line cleanup and optimization this series enables.
> That will be done as a follow-up, either through the crypto tree for
> 7.3, or still through net-next for 7.2 at maintainer preference.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] net/tcp-ao: Drop support for most non-RFC-specified algorithms
    https://git.kernel.org/netdev/net-next/c/5eb0cfedb258
  - [net-next,v2,2/5] net/tcp-ao: Use crypto library API instead of crypto_ahash
    https://git.kernel.org/netdev/net-next/c/068f5a009556
  - [net-next,v2,3/5] net/tcp-ao: Use stack-allocated MAC and traffic_key buffers
    https://git.kernel.org/netdev/net-next/c/48168799896c
  - [net-next,v2,4/5] net/tcp-ao: Return void from functions that can no longer fail
    https://git.kernel.org/netdev/net-next/c/8e4f61e43163
  - [net-next,v2,5/5] net/tcp: Remove tcp_sigpool
    https://git.kernel.org/netdev/net-next/c/4baf2415992e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


