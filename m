Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE248624E;
	Wed, 28 Feb 2024 21:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709154034; cv=none; b=SXwH30myr4zfmie5CPhDwbEusXGtr58V3WgdTbE1dKEfe94IcMzgTyixYQEmodagTgwrbBP2pS725SKnz26FDIINSdNrhaAZSltGwdXnX/wj7sFLJhpI5x0Lx6KabACdU0KeCiIMirNeDL4csGa5sfg5V2ouycjAzq9NeCABIAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709154034; c=relaxed/simple;
	bh=MSAWTfEVrwEWwdECtjngCmanvERiNCcF+LUfK8Are3I=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=WjkVCk7Qec3ZWSa6FmrFethCmFVCXjioxN8WK3nd9brU3FI3E6revLbntPg5VPdoSfkGZJHfPFe7OzwZwbSenamNh+mp/mbmO8md0XrnYGxfeI9TEpqBnlrA4ucE+R0TKWghOlqpN2sjHKKOA71tcuJrLrDDmX3YXjwlZXilJHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hgPHfMT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hgPHfMT8"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2917C433F1;
	Wed, 28 Feb 2024 21:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709154034;
	bh=MSAWTfEVrwEWwdECtjngCmanvERiNCcF+LUfK8Are3I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hgPHfMT8OI+cOAWCtHn9IIN6athVXtYUGOB28+882FsvFGo220tulqrRArVm3oQtn
	 bJvuj9oGnbQTtxtWooAMcJBmxnii3fdIVumskFy8lLrcppYhxHF5gpNWIVVsG8+CrT
	 LZI69QH0SjcDKQN14D6r1PdJD/EsSJ63XRmeIMFN8eKFiM5YGNLemWYCQTVtceF/ri
	 xD2aZv7JZfyYLMeISrH11qR8Lws+gUl/bvjJvE958G5EBp3S8R8QeqZT2xsh0a+JvK
	 SBDC7EhS8D+6yivDMgSxeTwvzf50T0gKcxbs4Nvz9MRHVsSBKcNEmde02QcWxJXFTH
	 jVjbFQBKlTRHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D076AD88FAF;
	Wed, 28 Feb 2024 21:00:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] RISC-V: fix check for zvkb with tip-of-tree clang
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <170915403384.31531.3005880789311750599.git-patchwork-notify@kernel.org>
Date: Wed, 28 Feb 2024 21:00:33 +0000
References: <20240127090055.124336-1-ebiggers@kernel.org>
In-Reply-To: <20240127090055.124336-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-crypto@vger.kernel.org,
 llvm@lists.linux.dev, brandon.wu@sifive.com, nathan@kernel.org

Hello:

This patch was applied to riscv/linux.git (for-next)
by Palmer Dabbelt <palmer@rivosinc.com>:

On Sat, 27 Jan 2024 01:00:54 -0800 you wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> LLVM commit 8e01042da9d3 ("[RISCV] Add missing dependency check for Zvkb
> (#79467)") broke the check used by the TOOLCHAIN_HAS_VECTOR_CRYPTO
> kconfig symbol because it made zvkb start depending on v or zve*.  Fix
> this by specifying both v and zvkb when checking for support for zvkb.
> 
> [...]

Here is the summary with links:
  - RISC-V: fix check for zvkb with tip-of-tree clang
    https://git.kernel.org/riscv/c/886516fae2b7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


