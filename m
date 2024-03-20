Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86698594E
	for <linux-crypto@vger.kernel.org>; Wed, 20 Mar 2024 20:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710967839; cv=none; b=CjCtZFZ57wWeMHdlOdBgNsKVVP700VNY4XWj/l7rSl9mm/YV6k4lGej5x1meomk7hniJWQvmF32E/wuUZBrWlLGecDejgMCs2Yka+21PiGNv7TQ0qnbIPuApkWV/sladj/svlCHCB8ZCTnJ2bYJcLb94wwk0cTf4+TvWhAsuw5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710967839; c=relaxed/simple;
	bh=afP5A0NF+uMzPWLZu45rPVAkiCKsGunwRFG9Ivhk/Ns=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=dpNYkWIBKk8aEOQD1Z3nF2d9S63CEHLo9icrxwFxt0Y+Nx1aZ29PXRhBskVU106u5lKXD4OM7cIacOzUzaVi7+U2OIfHyukqTr/xxzHSrYQ8uJ0MKVpvfk+bp0CsqJ/trWhMC2quJer1bCdVsOZr08hba84Caz6d9RgA6FE2KN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtvSscKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtvSscKh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D6D2C43330;
	Wed, 20 Mar 2024 20:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710967839;
	bh=afP5A0NF+uMzPWLZu45rPVAkiCKsGunwRFG9Ivhk/Ns=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=jtvSscKh9OFUqlssM6reOh4z6/tswKTw8PFxCLOFU7zM51ahkQ8u8ByNBsDrIQ7ap
	 oesavW1gUfGtQE2s1xQCajLB6EhPBIEYNQHE7JnHnSahhJ6m4HIxkBf00SwKm39x7i
	 TdOr8qbtePyOEFtc7LDGnAN4Di/ZonialVlbNmSHMsbXqzf1xWMkMSnmS5Pp0Yii6i
	 EdVzdp0fr5ApB6dfYpg6zp9wfvXvRpLkeLtyGTWm1Zr3DmAUa9ITOVTKM5ENiOndfW
	 a4RDn/k9goaaf6FV5eWDn2rmjCEa5ETDPHBHsi7FFlTFlAbsdt7il9l5AuY4mLJGmp
	 L6zr6fw/2tM2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41253D98303;
	Wed, 20 Mar 2024 20:50:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH riscv/for-next] crypto: riscv - add vector crypto accelerated
 AES-CBC-CTS
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <171096783926.6804.7089388626356276369.git-patchwork-notify@kernel.org>
Date: Wed, 20 Mar 2024 20:50:39 +0000
References: <20240213055442.35954-1-ebiggers@kernel.org>
In-Reply-To: <20240213055442.35954-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-riscv@lists.infradead.org, palmer@dabbelt.com,
 linux-crypto@vger.kernel.org, jerry.shih@sifive.com,
 christoph.muellner@vrull.eu, heiko@sntech.de, phoebe.chen@sifive.com,
 andy.chiu@sifive.com, ardb@kernel.org

Hello:

This patch was applied to riscv/linux.git (for-next)
by Palmer Dabbelt <palmer@rivosinc.com>:

On Mon, 12 Feb 2024 21:54:42 -0800 you wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add an implementation of cts(cbc(aes)) accelerated using the Zvkned
> RISC-V vector crypto extension.  This is mainly useful for fscrypt,
> where cts(cbc(aes)) is the "default" filenames encryption algorithm.  In
> that use case, typically most messages are short and are block-aligned.
> The CBC-CTS variant implemented is CS3; this is the variant Linux uses.
> 
> [...]

Here is the summary with links:
  - [riscv/for-next] crypto: riscv - add vector crypto accelerated AES-CBC-CTS
    https://git.kernel.org/riscv/c/c70dfa4a2723

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


