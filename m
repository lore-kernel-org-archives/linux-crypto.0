Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286DC3AD518;
	Thu,  8 Oct 2026 23:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791503407; cv=none; b=a0CCL15NIlMSveRmmUii5vY5AxWwNza4c/yvED1ykYLWXPvS7bHSTJAkApAFL8gAIfOsiZPN3+dKxG3nmxNHP3H5n+wTNpEOwlqKh4du6OaPGV4TOLiAqQutCsZ+jKbYkDOMkbwYGQX/cQJaNwHfqUfAy+LzAW637vack7N+Xm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791503407; c=relaxed/simple;
	bh=CJxOqD3NE61s59E7mg9tMzBvtBspVcInzlShefe/6P4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=bRsc3QJiNu3bY4h8eVF3ZUnhcjrv8VfKiXSgU1xbeXbybDidiUyqXarADdwbFKcCQikLg7DdGNcIqKB+s+n21EysZ5MCEGmpo4EybL4XmUTOoEGMvWgl6pOuTtOz8VXIHMEpa+7nOOr6fIaiA7x64XwvCkMGoYaIDJqfxdAviZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X84G1Tz1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X84G1Tz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6451F000FF;
	Thu,  8 Oct 2026 23:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791503405;
	bh=w6nkmv/DDpaHl5YKwomMF3p1zN5UZG16ybANi5RR8Jg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=X84G1Tz1+NBASMVv7LWyF0pxG85zWONvjbkufRPTUwl78f2Fr2947zOcEhH6JiGSp
	 1mwu32bEvNGsSZH1alEfPXoDFq73CVuaQ+jyUvxp8xBuDLC5Fmp/tksjuC1clhA7eL
	 yeS+WYpVR1ZGc3Xz+nS3iPtqgXwG5rqvcXm2QfRxxmx3zC5CpTeLLOCxwBT6hj/W4/
	 Ygf2h5jffs8j3jik+4WzXMYyCg6TQdsTDBH6fWx1vbaxybWJQYatwjbHLaENOlA1zM
	 h52TT0RuAym1ajzGBxdsSZe5Ayur+hPlVzm70YyIYiMOSL3xU4qSLroVFohBASTWZD
	 7yc5OkkCV2qMg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B4574380AA60;
	Thu,  8 Oct 2026 23:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2: use arch_extension to enable LSE
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179150340428.483817.886115147971378041.git-patchwork-notify@kernel.org>
Date: Thu, 08 Oct 2026 23:50:04 +0000
References: <20261005162137.71397-1-emanuele.rocca@arm.com>
In-Reply-To: <20261005162137.71397-1-emanuele.rocca@arm.com>
To: Emanuele Rocca <emanuele.rocca@arm.com>
Cc: sgoutham@marvell.com, gakula@marvell.com, rkannoth@marvell.com,
 sbhatta@marvell.com, bbhushan2@marvell.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 schalla@marvell.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tamar.Christina@arm.com, Jeremy.Linton@arm.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  5 Oct 2026 18:21:37 +0200 you wrote:
> Instead of using ".cpu generic+lse", use ".arch_extension lse" to
> enable LSE.
> 
> The ".cpu generic+lse" directive replaces the assembler's current feature
> set with generic+lse, dropping other previously enabled features. In
> contrast, ".arch_extension lse" enables LSE while preserving the current
> feature set.
> 
> [...]

Here is the summary with links:
  - [net] octeontx2: use arch_extension to enable LSE
    https://git.kernel.org/netdev/net-next/c/9142c2f8f84b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


