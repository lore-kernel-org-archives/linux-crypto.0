Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6194263F28;
	Thu, 21 Aug 2025 02:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755744005; cv=none; b=nDgnm55/v246MZM2X4y5HHPPo21VFH7OMdZJdHaJhlHaVMvtSAPCegQsY4UahvkIssz605JkmxLi1uRkE5MoSffRRXFxGLQl9ZQ29XnRfs6urXp/LuldwwNS7cQ679MolsrjqC2ZFx9/c0xSxaDHgz5sCRMzvXU2eSfdmef+yg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755744005; c=relaxed/simple;
	bh=QzQMZHYn9eqbFKPsHM+6Dm0ssr+5m6Ute8cLenX7mz4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Y4JhssB58QP1uMsJvqcUKSOU2n9IbwHdMTnv4Tv9LO5Bm5nHPTCLR5gobbyzUXf3XN8SjoULrXRoPPbQ8B/1PC+M2XTAfwvwrwYpqOjs+AmGNZJqkhM7jZgnw7NgJ7Jr3Lm8lpOtS+26UP7IpZlulsR3YJNYg8UPEhQB7QnBruw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NlQP/16o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NlQP/16o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C095DC4CEE7;
	Thu, 21 Aug 2025 02:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755744004;
	bh=QzQMZHYn9eqbFKPsHM+6Dm0ssr+5m6Ute8cLenX7mz4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=NlQP/16oIedOEhOXfM45ZpIOFOpRPG/IoaS5qCBqKfc3GiaFbiCrczLWjWaWqTOum
	 TMbeGHo5eLn8hVk129HE0Ct2I4IzXwT5EUYEiRXbquQCrYV8GwH+3ggO6CtHflFNeU
	 j8RPV++JQpIAvwYn8aqKP8N1YQDDDb1LOp2z0y+vF1jNpo72KYbfpf8yLm+hUGnunG
	 t1PcW4+LCw3EDxoBn9EqFxLwqdqUYAtfdXN+cTh6Nw4rvuDFZeQEd5hydJZzRfKZn/
	 FDcLh+a9nM2+kHEpilXq+C/Kw+DsO+2hSW8mY+CFKBv1Bw7Ve7D4Q4oCkPY/kuZjNH
	 Qh8Faf/cJyiCg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70C8A383BF4E;
	Thu, 21 Aug 2025 02:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ipv6: sr: Fix MAC comparison to be constant-time
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175574401399.482952.6684319949813619321.git-patchwork-notify@kernel.org>
Date: Thu, 21 Aug 2025 02:40:13 +0000
References: <20250818202724.15713-1-ebiggers@kernel.org>
In-Reply-To: <20250818202724.15713-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, andrea.mayer@uniroma2.it,
 linux-crypto@vger.kernel.org, dlebrun@google.com, heminhong@kylinos.cn,
 stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 18 Aug 2025 13:27:24 -0700 you wrote:
> To prevent timing attacks, MACs need to be compared in constant time.
> Use the appropriate helper function for this.
> 
> Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net,v2] ipv6: sr: Fix MAC comparison to be constant-time
    https://git.kernel.org/netdev/net/c/a458b2902115

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


