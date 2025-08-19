Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDEE1AC44D;
	Tue, 19 Aug 2025 00:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755564010; cv=none; b=hADWorBf1nRknDKvjOe858I563UBWQ2xupH8aWXRQQksLbBublpIcOdNky4K/d7z8zVIkpcNKD71ACfVbNBan5PFJMDEY3imIvNLHungBql6tIyvSYpwwt7/kulZmwlb2zRcDD90DXTOkwEx7BwidLqHZtnGgGw2mvdpM+5zVV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755564010; c=relaxed/simple;
	bh=1UOC/S8NX0q/Tbwv3Ar8qP5cEhOOtnHMjinZiBj5+BI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=b0qkbsW8hHQ1Jkk5ra+q3XmncOWEwpyfQDCAyCepU1dIr/EG/q8aModb1DsC75/3tv8iY6kc6MLJ9q9REZcXfd7Bw0Jv8o2BY61j7BewlzDVHvKPzxdyO3dVQUxW/et+lCDVe+3ejWPbI76LLqk+2UwJhZxpO7oDersr35lBR34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIw34vct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIw34vct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E120C116B1;
	Tue, 19 Aug 2025 00:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755564010;
	bh=1UOC/S8NX0q/Tbwv3Ar8qP5cEhOOtnHMjinZiBj5+BI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=lIw34vct1wdbKwSUk8FQeerC20lGSTKKZmFvH7uktMIECJhG8RPtdtpDqAoXIIJ4L
	 BJMnqJ9HTza9FnAxris8mZk5zD9OXsuIwRYbG56CXf5tP6rKJw0WNEdGJg0fh5kEpx
	 +a4owt6gxadVxCxaWhGMrsdbOh55Hw7oo8tTaG7HreF4CrfkXMI57RMbmX7k1tnKe1
	 crAO4UshugYaR+WwtpA3HCX3upC0vC2ZvMzR3G+PDdya+JAdBJvBCO9bpHtQBQrPqP
	 JuA2oPcGTMhJ/IbUwTeZNtlEnhpQuUHmRI2mMN+2yZ5tbkvZ9a2677WpG046wyHHWX
	 YTpUVO4bUh6Ng==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70BF2383BF4E;
	Tue, 19 Aug 2025 00:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ppp: mppe: Use SHA-1 library instead of
 crypto_shash
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175556402024.2961995.8220856469203813950.git-patchwork-notify@kernel.org>
Date: Tue, 19 Aug 2025 00:40:20 +0000
References: <20250815020705.23055-1-ebiggers@kernel.org>
In-Reply-To: <20250815020705.23055-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
 linux-crypto@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 14 Aug 2025 19:07:05 -0700 you wrote:
> Now that a SHA-1 library API is available, use it instead of
> crypto_shash.  This is simpler and faster.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  drivers/net/ppp/Kconfig    |   3 +-
>  drivers/net/ppp/ppp_mppe.c | 108 +++++++------------------------------
>  2 files changed, 19 insertions(+), 92 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net-next] ppp: mppe: Use SHA-1 library instead of crypto_shash
    https://git.kernel.org/netdev/net-next/c/b55f7295d600

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


