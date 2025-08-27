Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F0019E82A;
	Wed, 27 Aug 2025 01:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756257608; cv=none; b=rE6lbFHqqLoLOdFqUwye0jYCs7XbVVUcdhCHGzfWynh5dnQtyYjqj8G2I0qSTWiuIE6Esg/s6aqnnC2TPaAt3+ayedoOkepSBHfGsMSjFD7lhAEjDVXBR22Ew7U540rYG75dDkBCdXToI4atAkIhjQknhotLr4VthSinLS/9dOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756257608; c=relaxed/simple;
	bh=YHfWEdHcLHm56xupCmMjwJq7/hCAgWaJ2vfBNRx/Fa8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fyxxW5uPCHld5I49gmSGJ8BqwXumz9+CB2Ary6m2yhJDKvCxjUW80gyfBzHrpcpMJ8cuV0IDT87uME4V6uv3ARtAMyJtdbf0BI2jZuxb0PdX/wrovwbVQcAU5Ev9ZpHZl89xEnyOGTz7CNeGTaQyhfAhpI9vVtGaohYWkLibl5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fqJsE03r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fqJsE03r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED54C113D0;
	Wed, 27 Aug 2025 01:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756257608;
	bh=YHfWEdHcLHm56xupCmMjwJq7/hCAgWaJ2vfBNRx/Fa8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=fqJsE03rQ2q4ZAUa/gCfZk8bSGv/wd7YMsgBgd03W0M7n8jylJdh9kvJA6Wp1qKJj
	 Wuh9ZEp97dH0wYYoixl1rjKjDSbh65WH2gM5UeF7rLbIm8xclVw8MDKNIT9mqMCpEL
	 Gr5wMKUqV01wn8nJZ5oQzwRp9WHhSAM+qAV1zx9HbeRNb89v6JTdg0o1vCpik6T7jw
	 OCMPNsybYQG46DmWPSVla9vaV0reI3XozpZcw43frLW3hu5d4koWk6V9RFN0tRW+SP
	 2epSbtQWWI4CTQuv627H6ZPSZj0Cq+eqSaqlHEomCaMu9hsDfAsGMeFH4h8WrSZI62
	 X303ed0ViWIjQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB071383BF70;
	Wed, 27 Aug 2025 01:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] ipv6: sr: Simplify and optimize HMAC
 calculations
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175625761549.160020.15897047289309076377.git-patchwork-notify@kernel.org>
Date: Wed, 27 Aug 2025 01:20:15 +0000
References: <20250824013644.71928-1-ebiggers@kernel.org>
In-Reply-To: <20250824013644.71928-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, andrea.mayer@uniroma2.it, dlebrun@google.com,
 heminhong@kylinos.cn, linux-crypto@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 23 Aug 2025 21:36:42 -0400 you wrote:
> This series simplifies and optimizes the HMAC calculations in
> IPv6 Segment Routing.
> 
> Changed in v2:
> - Rebased on top of latest net-next.  Dropped "ipv6: sr: Fix MAC
>   comparison to be constant-time" since it was upstreamed already.
>   Moved key preparation to seg6_hmac_info_add().
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] ipv6: sr: Use HMAC-SHA1 and HMAC-SHA256 library functions
    https://git.kernel.org/netdev/net-next/c/095928e7d801
  - [net-next,v2,2/2] ipv6: sr: Prepare HMAC key ahead of time
    https://git.kernel.org/netdev/net-next/c/fe6006568904

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


