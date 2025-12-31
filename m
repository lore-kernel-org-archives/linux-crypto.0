Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F4C2C236B;
	Wed, 31 Dec 2025 03:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767152098; cv=none; b=MKTOFkNaCmdWqmf8HjdeTYZ+5wx2dieky2Vvxt9wZgVxyxEhf3PpRfeGVxwjiP0gDNDpxBzdkFX0mtJzt+M2Cb0QQvH8w4UBOG6pK0QAw7J5Mmq7acJJw+NGSmCvrKLrfW2xI3kuzu/WA3MjWP7315WuV86Uzkj6dxNeGSp0dsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767152098; c=relaxed/simple;
	bh=8DSvRSus0xbGzOAr4jp/3UnDYQkmeJ4CLOvKen8nVeI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=jCF3InE0qlYQMjjRRvXonTSdLxHjG59wla7l2m2dwJKCJLRIWFh/61DR69YYlabvz4kQw8kOUgkn6ZSGOLMdx9JNx/Kf5sSIGpxjFtjA0jfmU7UME93H4Fyp7iGWnRqgqtNJ6qVUdAXfIRuQU7m/KoHaATTQv4JdVPXpT0/7LWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PG4+EZXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PG4+EZXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F82C116B1;
	Wed, 31 Dec 2025 03:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767152097;
	bh=8DSvRSus0xbGzOAr4jp/3UnDYQkmeJ4CLOvKen8nVeI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PG4+EZXESNN/ftMqOQkG0PDmeBExQAFFKYmt+0c0Wyw/6A7+EiNm42NqjrtMcWrPq
	 Qt/QeETxER8bjdf3F00f7YDoq3oO8gav1HcUjrVnwIYpRBmgaIaPdL1KS8flzEBHcI
	 WKCBrcVKd/MdX+SIb1G4X0Vy0q4vDV9ELOJ8dN1NVQYx/f1AWl+jnfOAhHodzM0qpF
	 MTWySVkAHbTffMpM3OcGVU4y86CAH8PNXVrd3jBJeXpS28V6ubn0gDrJMdqIT6tTqn
	 16ZKhJ3po131qRbAqBwMUBq3FG4VeJtp8cUO9xJ9YcT//bKWkO64Z4NDarEV4Wtrz8
	 LZ13dG9GWDmBw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B79D3809A19;
	Wed, 31 Dec 2025 03:31:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] crypto: riscv: add poly1305-core.S to .gitignore
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <176715189877.3416240.15703522189822790265.git-patchwork-notify@kernel.org>
Date: Wed, 31 Dec 2025 03:31:38 +0000
References: <20251212184717.133701-1-cmirabil@redhat.com>
In-Reply-To: <20251212184717.133701-1-cmirabil@redhat.com>
To: Charles Mirabile <cmirabil@redhat.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, ebiggers@kernel.org, Jason@zx2c4.com,
 ardb@kernel.org, zhihang.shao.iscas@gmail.com, zhangchunyan@iscas.ac.cn

Hello:

This patch was applied to riscv/linux.git (fixes)
by Eric Biggers <ebiggers@kernel.org>:

On Fri, 12 Dec 2025 13:47:17 -0500 you wrote:
> poly1305-core.S is an auto-generated file, so it should be ignored.
> 
> Fixes: bef9c7559869 ("lib/crypto: riscv/poly1305: Import OpenSSL/CRYPTOGAMS implementation")
> Signed-off-by: Charles Mirabile <cmirabil@redhat.com>
> ---
>  lib/crypto/riscv/.gitignore | 2 ++
>  1 file changed, 2 insertions(+)
>  create mode 100644 lib/crypto/riscv/.gitignore

Here is the summary with links:
  - crypto: riscv: add poly1305-core.S to .gitignore
    https://git.kernel.org/riscv/c/5a0b18825068

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


