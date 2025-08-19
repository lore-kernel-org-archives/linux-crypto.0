Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3B51607AC;
	Tue, 19 Aug 2025 00:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755564009; cv=none; b=D8bpdXZqcLDkLARZkulB8GzoJqUufiAKUSW2aBubq6SLQ6vicye2s4eb6cD7BdOAxhqs7M9UnJ5AZDfq2YPl/agt6/fp0e7t+rx/AyKCY8ViF++xF+wJyFYMIO5iS+GKEDdUsl5A1AaZOqjxpa4XpteFy/0V5cUc9accQbbmA1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755564009; c=relaxed/simple;
	bh=qjqR7/wG4s/fGkSkjeV1jCvFNJYxK73OG7vqqwSJzsg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=MjLMzG72T4dj462+ONmR0Z9plMR6dEG6MqRZVFsN+wvH6ZbwP9x32d6d4AZwQmk5qBbM/B0fiMki6ozo1J5097+GGSkSMU5CGS8cpXJIvEavVBoEKBUvAfs7ZWRjnfWoqmPY5zWHmdZEx+/R2uIDBqK74ICYpNLrMW5sYn8OEtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ds7lAItm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ds7lAItm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E309AC4CEEB;
	Tue, 19 Aug 2025 00:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755564008;
	bh=qjqR7/wG4s/fGkSkjeV1jCvFNJYxK73OG7vqqwSJzsg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ds7lAItmTS723iNavJtidA9TkhejkAxn1+Q+oDAYWs2eSTRqb7c6acYAIppAqU9BM
	 Cnte6Tqwl8rHtRnfDOIgCENnAYQM6hWAMge6Y0LqQczW7XUgNujoIJ0l+h+ezuTzPZ
	 UOnHeJqJ7pgjgxwEsZp6Nr3LvJOATO7KcazJ+tkS5NWq50bD5QLIQrDYO+Oq2lQ22J
	 k+QKxQotQI1S13aPRyf+wfyoWuNUK6JJtGXHIlrnyHp63FRGyB0bG7gFQb6a8lRcYS
	 3DghprKOpaO+O7ZQ/Nk8Wb1DXi9GhCIfs0A+6YuMF7i9zRRigS8FsdbM573OchyDRq
	 Y5LVACwaScOUw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33EC9383BF4E;
	Tue, 19 Aug 2025 00:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfc: s3fwrn5: Use SHA-1 library instead of
 crypto_shash
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175556401899.2961995.16051530585251950559.git-patchwork-notify@kernel.org>
Date: Tue, 19 Aug 2025 00:40:18 +0000
References: <20250815022329.28672-1-ebiggers@kernel.org>
In-Reply-To: <20250815022329.28672-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: krzk@kernel.org, netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 14 Aug 2025 19:23:29 -0700 you wrote:
> Now that a SHA-1 library API is available, use it instead of
> crypto_shash.  This is simpler and faster.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  drivers/nfc/s3fwrn5/Kconfig    |  3 +--
>  drivers/nfc/s3fwrn5/firmware.c | 17 +----------------
>  2 files changed, 2 insertions(+), 18 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net-next] nfc: s3fwrn5: Use SHA-1 library instead of crypto_shash
    https://git.kernel.org/netdev/net-next/c/661bfb4699f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


