Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C09A3DA7E4;
	Thu, 26 Mar 2026 10:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774522219; cv=none; b=A8DR44rf7nau+mKRpsy5u15772XnHw4YMtYhm/5SUaYhhjOZgf/3d/yd02ANsLgghvv2dqTZ7EDc05H2YjP2NpX4u1cbjZAKKejsZPFKNaVGOl/6Nk4rEUGpI+75QJWKHWA1VC7ZW+9ax5UJOIqes5TD278RxycRnO4vdW11Rks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774522219; c=relaxed/simple;
	bh=ZsigC3kAhTBaa8GgDW2ZB7kWXkygn7iMWT8um/Dx09U=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=QcA28x2xyYmQh7anbiTqRgq6IRKe/2IKkJ8AsMuzEthGp1TXk8BSE0YL3IyIYDvHhqYLWfHxHZqIr/U5UkE3DWPowB9qSI45ipBcPuftdkZnn9jPQ6qzQrCoT4pGEpuWnrvX/JSCqIDaIztJiX4sU7kRb6GHrzZD1XoP4Z+6/AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rYNaRVv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rYNaRVv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932DCC116C6;
	Thu, 26 Mar 2026 10:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774522218;
	bh=ZsigC3kAhTBaa8GgDW2ZB7kWXkygn7iMWT8um/Dx09U=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rYNaRVv4Nzj7GsJCSiMnACrfMG7/fcDo8eYda6SXkhOAmifx8OZJO4fI6QRNuBy9J
	 K4j+tOrd9l5vBKrOYBki2aSkOD92i5EKroJMpqtX3HkIyyUb2oogI1CO6hU+rLefaI
	 ELNerrjOSjhTwdLWgG5I239RHAEbAROzT0EhoPyAmimWNMnfr43ENalZ12D/pDWStF
	 tOnyf8oHQ2sygXzKJTX5nlvCZyPCLhlECPSDZfX51U9SyOhg6dNBvQeJ5PFTymSTER
	 sinFemDkbuipvZtTOds4Z7+0OEf42aIgGbxbTdjRujCQ0H15exnW+L/oEsdJPFoVa5
	 Tmw7UfHR+cHCQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FD7B3809A33;
	Thu, 26 Mar 2026 10:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] octeontx2-pf: macsec: Use AES library instead of
 ecb(aes) skcipher
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177452220504.2493472.10225019589643023185.git-patchwork-notify@kernel.org>
Date: Thu, 26 Mar 2026 10:50:05 +0000
References: <20260321225208.64508-1-ebiggers@kernel.org>
In-Reply-To: <20260321225208.64508-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
 hkelam@marvell.com, bbhushan2@marvell.com, sd@queasysnail.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 21 Mar 2026 15:52:08 -0700 you wrote:
> cn10k_ecb_aes_encrypt() just encrypts a single block with AES.  That is
> much more easily and efficiently done with the AES library than
> crypto_skcipher.  Use the AES library instead.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  .../net/ethernet/marvell/octeontx2/Kconfig    |  1 +
>  .../marvell/octeontx2/nic/cn10k_macsec.c      | 53 +++++--------------
>  2 files changed, 13 insertions(+), 41 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-pf: macsec: Use AES library instead of ecb(aes) skcipher
    https://git.kernel.org/netdev/net-next/c/8f303194b241

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


