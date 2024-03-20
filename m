Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56A68594B
	for <linux-crypto@vger.kernel.org>; Wed, 20 Mar 2024 20:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710967839; cv=none; b=XHSYQCA1rjU1rAFJsR3A6Ay0O0m67a+GpX2dqpEsB+qWpwIXJCosb1Sq0QwBK/edCunxPmD6Fa9OwhZxb0BYuXkj1Of6PE3lT+8cjrCnT64OXNarDf0ZB2SWdhueptKpfLRccqVzWd4TuWCdPV7CtkMxvVTZQWZDFEvHibhQWuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710967839; c=relaxed/simple;
	bh=RbipWbMWoVvJY57B7zAecrnUinQPH1sMwHudXDipRa8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ndssTslTCtIDkFQ0qzTRAtlUqr5w13N93B/P0nzOnqEp/JQftWfMndilah2eXKfHk5KLVZYdiG70mmrQK7izkTVOX/dTxgFvtrQvDv4wmRZqSeV3qm+K0HjHYGLWUkIlGk6Ugd1SgBnWIplKiT9PxZkmZyCoExBGEKpHVPChxTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWLamDeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWLamDeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6905BC4166B;
	Wed, 20 Mar 2024 20:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710967839;
	bh=RbipWbMWoVvJY57B7zAecrnUinQPH1sMwHudXDipRa8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ZWLamDeJVmy9Sc3MPZ1gPGHkABS90E4m13Vvy3w0mwi6DsNyamapZ8rVhBrn+cwPr
	 Zqu7d+ieji/DQq8aW60GMMHCn4uPmBMHrb3vOJKNFp5ZqBOs9MlMrLrBgfeXMTtc6Q
	 HQ3EN2KLcTHBnsOQpcg2iaVttrO/vMUdjNKMJLo7Tex67g7n0R4vU5XXBnPkug0O6z
	 cWiVKV85GC5a1kKYOs+sSs6QBGJ6fCNS4A6WgkFonuIhVgCOlhu6O+nXQPuCpY0wI9
	 esVlblwctYjV/IJ56Q+pJecA1QO/ISdsGHF1hE4DNaRXM6nDip3DXDGizSjx7AbXbd
	 zewbtYxsK6adw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 605B1D84BB1;
	Wed, 20 Mar 2024 20:50:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH riscv/for-next] crypto: riscv - parallelize AES-CBC decryption
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <171096783939.6804.12731110062638308548.git-patchwork-notify@kernel.org>
Date: Wed, 20 Mar 2024 20:50:39 +0000
References: <20240208060851.154129-1-ebiggers@kernel.org>
In-Reply-To: <20240208060851.154129-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-riscv@lists.infradead.org, palmer@dabbelt.com,
 linux-crypto@vger.kernel.org, jerry.shih@sifive.com,
 christoph.muellner@vrull.eu, heiko@sntech.de, phoebe.chen@sifive.com,
 andy.chiu@sifive.com

Hello:

This patch was applied to riscv/linux.git (for-next)
by Palmer Dabbelt <palmer@rivosinc.com>:

On Wed,  7 Feb 2024 22:08:51 -0800 you wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since CBC decryption is parallelizable, make the RISC-V implementation
> of AES-CBC decryption process multiple blocks at a time, instead of
> processing the blocks one by one.  This should improve performance.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> [...]

Here is the summary with links:
  - [riscv/for-next] crypto: riscv - parallelize AES-CBC decryption
    https://git.kernel.org/riscv/c/da215b089b5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


