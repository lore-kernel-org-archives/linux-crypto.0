Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FDD2FF150;
	Fri, 19 Dec 2025 08:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766132009; cv=none; b=m+nTGLRiEGvXsSD+qYXaPfY+Ga48aljsa1Fexd6gMdBLmVDz2eKLFNKa0sejCtwl28sKWhrd6kKReadLUQmmg8fieL4LegWanGoLOLSRWy6OHdoFY6qSMuvxLPp5VF35aMazTT2YB5K1F7gry6TU/8zkFQ1ADeQ5yFodMtAFmmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766132009; c=relaxed/simple;
	bh=kgtkqQanSlE0c9RUER2tUM0+KsbsX/FrAzeTetm0HOU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=bIxhrCdlEa4kqBtP5dQ8aqO6ZwSOf8+g18Qnls6lA4jnHZRZEjlRDBuhbsZBC8mSMRRoZ3BpPp0Cjvg/ZuSFe/kn2M23X8o9HFF7gmjAi3TvVX8McehcCHaZXXUACkYoTy878Cls+CPSWbU//R/SDiY9eCYxBvhK4ceInd2SFsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rjo1Kry+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rjo1Kry+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEE7C16AAE;
	Fri, 19 Dec 2025 08:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766132009;
	bh=kgtkqQanSlE0c9RUER2tUM0+KsbsX/FrAzeTetm0HOU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rjo1Kry+fyYxnQI8brBvI4faz6fFRHFUKZwKsbJmi/bnGKuJnZeCNKKrkfleufCKE
	 BlaiYb2d24In68vTs+3OZwNd2bu+DHBmLIdBTLVF/UYIUXYyL6lfLzFxTxJUJc409o
	 u1zFXAho4yQcC8rFaaGtK2mhAtGIpS9Yu866IRUY4xV8ORDWvn5+1fglkALBe53vL8
	 Jz7ikJva87HnFbKzvwIasggjTLM/HXPy7wWktD2QZ1lTM+3GUngVNe6yjCaUgwAEjW
	 KNTOtJ0Ei3181Y3kMhs3XCJH4+d7KQ9ZGhuEf/Zh5JLx6Jlik3PhWUeBv2wQZ0D2Hh
	 0VJP5bK2lVoSQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B912380AA50;
	Fri, 19 Dec 2025 08:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] lib/crypto: riscv/chacha: Avoid s0/fp register
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <176613181802.3684357.12542900768855708596.git-patchwork-notify@kernel.org>
Date: Fri, 19 Dec 2025 08:10:18 +0000
References: <20251202-riscv-chacha_zvkb-fp-v2-1-7bd00098c9dc@iscas.ac.cn>
In-Reply-To: <20251202-riscv-chacha_zvkb-fp-v2-1-7bd00098c9dc@iscas.ac.cn>
To: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, jerry.shih@sifive.com,
 ebiggers@kernel.org, Jason@zx2c4.com, ardb@kernel.org, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to riscv/linux.git (fixes)
by Eric Biggers <ebiggers@kernel.org>:

On Tue, 02 Dec 2025 13:25:07 +0800 you wrote:
> In chacha_zvkb, avoid using the s0 register, which is the frame pointer,
> by reallocating KEY0 to t5. This makes stack traces available if e.g. a
> crash happens in chacha_zvkb.
> 
> No frame pointer maintenence is otherwise required since this is a leaf
> function.
> 
> [...]

Here is the summary with links:
  - [v2] lib/crypto: riscv/chacha: Avoid s0/fp register
    https://git.kernel.org/riscv/c/43169328c7b4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


