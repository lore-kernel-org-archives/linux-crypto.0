Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8B83101CD;
	Sat,  2 May 2026 18:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777746075; cv=none; b=pDPkaZfFbqiPgkTGLS3vKS4pbDg0bN/w6Z00EwQBBiOHlLkB3tpPkR14zOp0vlVWAZmryech4+zjzgJBm64kev8efOWLcl8w83ZnANE6H5FAjLVBcJSZieuAHHDpN1HIZLdt/kqT6ZrHs5rxvRavqBlVaNQsCDBs0/30MtTvv/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777746075; c=relaxed/simple;
	bh=x044spbQIis5Huyds3Tq1QQAexZUusMMTKW29O5B0QM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fdVbBB9JiowOcrEmsz1EVNbjIUeNc6sp3AmGmVSkQuq+Hut3AbOx01sNCfZFwMjuBXV6JVWcvJb4NvQTkUD/51LE8qD4N6Za18uQq6iRoN6Q7rZzjOL9xB5NLMUDu5GD0kHt264WiGL7xGLuJVkvGhdUctNl+9iAd0/T2peMYJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OQ1Rk7rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OQ1Rk7rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AC8C19425;
	Sat,  2 May 2026 18:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777746075;
	bh=x044spbQIis5Huyds3Tq1QQAexZUusMMTKW29O5B0QM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=OQ1Rk7rkBiKTZxitLuoLyA+TEtiMdpDsmlfFt6XavqNmm99Osdrp7YiUwvz8Ph2OI
	 2wHbjIlVygynCzdLtCWkJ7EnX9fXQC1+SC/6dXdwEJxvdG0dCYAsPRVdeCRFHEN2j3
	 UC7gyCvBYNM/zkOMDZXLrGz2p+YWnzctNEpqyARuUlHqD1UUZwC+DsikYQYTD1/0o3
	 CwS7fJjMf+lg0e2igpzEhfB0Kots029BtvySG1X2mePfmZmCR9/dgod6b4ElfFU15D
	 L99UGajLBzOKGskQJjV4/ybBYEy/JxbApffbs6HXHmkI2T6lP2nRLz1qaHr2UiBfvn
	 0PSyg4Mcx8OdA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02C7C380CEFF;
	Sat,  2 May 2026 18:20:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Documentation/tcp_ao: Document the supported MAC
 algorithms and lengths
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177774602754.3903048.8237803495851364172.git-patchwork-notify@kernel.org>
Date: Sat, 02 May 2026 18:20:27 +0000
References: <20260429210856.725667-1-ebiggers@kernel.org>
In-Reply-To: <20260429210856.725667-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
 kuniyu@google.com, davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, ardb@kernel.org, Jason@zx2c4.com,
 herbert@gondor.apana.org.au, 0x7f454c46@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Apr 2026 21:08:56 +0000 you wrote:
> Update the TCP-AO documentation to fix some incorrect terminology and
> claims regarding the MAC algorithms, and document which MAC algorithms
> and lengths the Linux implementation supports.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  Documentation/networking/tcp_ao.rst | 38 ++++++++++++++++++++---------
>  1 file changed, 27 insertions(+), 11 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net-next] Documentation/tcp_ao: Document the supported MAC algorithms and lengths
    https://git.kernel.org/netdev/net-next/c/34d67417c8cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


