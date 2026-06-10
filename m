Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B094A1A239A;
	Wed, 10 Jun 2026 00:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781050813; cv=none; b=QFOU/lEg9Nj26HD/xkIt6hs1d2W5v/ujTfRmxCovtVl9NsurK9VFrHEEsZI4vD2RyiXA9I7yisfkFEJzvmt46a/TmfYQPs6J1hb6q7bfh5apA5LWEXGSi7bqxAgLadMUsmvcLlU87vj+/z4OflgVZdGmsULglVIUs6HP2tmJYWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781050813; c=relaxed/simple;
	bh=lIXsDvASR11s+lkmmPZBN8NZv0scO5jmKsi1J+B44ws=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=s/Zm8fI2yjsKxhiAOGxlutPcaphBaD8BmeRhfXekpQoPZ8nAvYo7G4KndFbojO/lzDn1DCReiYjztcIu19tPfzfdAVMHhpM+MG62nGvrf5F8p/6Q0U5hxIRmnV8jxYelUNE40xo1aX10oSt0PW1V4VlbXAvIO2lIyGnkwsxLTUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hNzBHLz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hNzBHLz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318A11F00893;
	Wed, 10 Jun 2026 00:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781050811;
	bh=pg9xF3NdKInQJrrnXNni1toksgqVe/gvi7C8c5BGpTA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=hNzBHLz01nf4M7xYK9x6gHglA9zt49GhJ6Pa2qmgeFzx5Bw7gKqnplr/Le4oDt9n0
	 68i+JdyeTUmPo9Uew61l74MR4VTfFlQEuxXRWxQciAby6oU0Z+DtXjzJvOcI5UKlzx
	 z1PbbfjsJoIWHmYtw/diXZpTynLQ2vL/XMo1isslq7a8SihVgbXV6TN+6ngF+87sXL
	 v4ial373xl+O74wxdU1zpPqptnagW3wb3jJjjVLtw88uPlFD1Yg0DdIx3hyo9SbqRJ
	 pBxhcFj/9B+gB3GF6t6+JcFSXfdjHv/7mEnnUvTlOQluaXQRLOd73eDlrZBUk7QUK9
	 5UShVBqeOmUDA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939AE3930A0F;
	Wed, 10 Jun 2026 00:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] Consolidate FCrypt and PCBC code into
 net/rxrpc/
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178105080939.2761032.9825918956605127872.git-patchwork-notify@kernel.org>
Date: Wed, 10 Jun 2026 00:20:09 +0000
References: <20260522050740.84561-1-ebiggers@kernel.org>
In-Reply-To: <20260522050740.84561-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-afs@lists.infradead.org,
 dhowells@redhat.com, marc.dionne@auristor.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 22 May 2026 00:07:31 -0500 you wrote:
> The FCrypt "block cipher" and the PCBC mode of operation are obsolete
> and insecure.  Since their only user is net/rxrpc/, they belong there,
> not in the crypto API.
> 
> Therefore, this series removes these algorithms from the crypto API and
> replaces them with local implementations in net/rxrpc/.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] net/rxrpc: Add local FCrypt-PCBC implementation
    https://git.kernel.org/netdev/net-next/c/f10e73dffd2a
  - [net-next,v2,2/5] net/rxrpc: Use local FCrypt-PCBC implementation
    https://git.kernel.org/netdev/net-next/c/97b768514a6e
  - [net-next,v2,3/5] net/rxrpc: Reimplement DES-PCBC using DES library
    https://git.kernel.org/netdev/net-next/c/432042e25e33
  - [net-next,v2,4/5] crypto: fcrypt - Remove support for FCrypt block cipher
    https://git.kernel.org/netdev/net-next/c/374efbdc85d0
  - [net-next,v2,5/5] crypto: pcbc - Remove support for PCBC mode
    https://git.kernel.org/netdev/net-next/c/1967bfaf7ba1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


