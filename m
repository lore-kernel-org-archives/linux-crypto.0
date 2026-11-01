Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793571430;
	b=oKxuzMXTnd4zzWO5PM1kDd1lE0E03q8yCc1DsrIPSN9lsxeyYL0rPssaKTOZNl1v3QBq
	 E3eeDHT36GhGg8KcWmTrsEhy2iI3mBYvGRLFqJig2skcjsqxWG4+5IfHTmPIucFKMgkNf
	 agVnw9Fnlrx/HiJ/6om6c5eTeXnx2am9+5SpDnX/sVxsw95iDkyB1guFs+vvGNQPC/c+H
	 k40L3GES8ikw/cnrUiMqeMidMQPkugCz/Kh6er8zE+5CT88QTw32ZaMD9HEZtYuWjypEq
	 e3clH+PPeyg3js9PLvivcMMKIiyULlLvcHJk7vi4TZb7ivtQxvWWq1cMq/kMTRHcnjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793571430;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=Fv8sMlP8O3GHUSoY8MBfh8MY+kr37FDNK89rZQzSXdU=;
	b=rBteBwPDPvJv0DmTb97Aus+2XeZWsietlrL9iTsmEysyVCpeiXitA/UEBoPQOEkkcBfM
	 QId8gaYpQKkt3HgI+AJVbkn/pFAWBt4T1OJnC/bS5PveeR6iORa/XBwriuh9ssdRu2eRR
	 9spo1/pe+pTTkhK6SzRY39abY8Tkg/tURSA/BRtj9t+A/RCJd7jIOWEGLPnZqSZtcx5Gu
	 0z3Y/YizZSsGF2uwIs8QRJeDIXFdUloFPVNmqW6ivmIP4JdmdHnZgqXtAW8sGe+Z0dxxc
	 6Zb9/hh2UP641CjU6QItE/aPVcj7CUEf7w9Z1mBTnquzdp0wQ7H/36qWqjATML8FgoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VlnlOoUU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3086074B53;
	Sun,  1 Nov 2026 22:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VlnlOoUU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A0F1F00A15;
	Sun,  1 Nov 2026 22:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793571429;
	bh=Fv8sMlP8O3GHUSoY8MBfh8MY+kr37FDNK89rZQzSXdU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=VlnlOoUUEu9V0plLi4Kke52P9Sf7LmnCXI3/r9nD/EkLF8dgcbn/b70x7s8xOpjzM
	 vBDpICruAngiVNvxs7IVSzf2GH3D+B5AcFg6C/1RMLmTfGWgGqs0LmJd92jQOeIJaF
	 wsK9MssC5+2tsvQklkL07S8F2Zzqk3PTJHN1zfusMqgsbvhB+jUERHRUHHZskloFPo
	 yl/WabE6HiCKHMwoMCYwf1B+T0vXDZWAeuYQt311a5PVRX3ugUcvRN0wyZzbvYibPV
	 2TlmBTOm6MSHm2nJI9gJKa3Redvt//yKNi/XBo/uFCvCdVwIZi6hXO14jaV0sdhUS0
	 kunSJJwhwyeCQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA5B438003B8;
	Sun,  1 Nov 2026 22:17:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] lib/crypto: Use size_t lengths for Poly1305 and
 ChaCha
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <179357142829.2624073.2124484665042168888.git-patchwork-notify@kernel.org>
Date: Sun, 01 Nov 2026 22:17:08 +0000
References: <20261014152604.323310-1-ebiggers@kernel.org>
In-Reply-To: <20261014152604.323310-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-crypto@vger.kernel.org,
 ardb@kernel.org, Jason@zx2c4.com, herbert@gondor.apana.org.au,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
 vladimir@genproof.com

Hello:

This series was applied to riscv/linux.git (fixes)
by Eric Biggers <ebiggers@kernel.org>:

On Wed, 14 Oct 2026 17:26:02 +0200 you wrote:
> This series upgrades the Poly1305 and ChaCha functions to use size_t
> lengths, matching the rest of the crypto library.
> 
> It also fixes the (not currently reached) handling of lengths above
> S32_MAX bytes, and (not currently known to matter in practice) the
> assembly functions depending on unspecified high register bits.
> 
> [...]

Here is the summary with links:
  - [1/2] lib/crypto: poly1305: Use size_t length
    https://git.kernel.org/riscv/c/0b58c136c2f9
  - [2/2] lib/crypto: chacha: Use size_t length
    https://git.kernel.org/riscv/c/e42003dba6dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


