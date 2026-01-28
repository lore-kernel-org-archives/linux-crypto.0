Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E16A2836E;
	Wed, 28 Jan 2026 00:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769559016; cv=none; b=giwKMdWBIZzmRrbCkR7znQqhD1ACWLu28xF5cbzwtgT2ycl/T3bC9vPewYMQG8fy7tzb5j7Zh/2uKnDRr8eAwum1XKb2swoN1Ki5UYeEFpON1aOT9sQkiSgS0TFngyRr7mlyvDPbgNwB0TEOnaAkGVXgJVT96SfBdOSzxOZ1hk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769559016; c=relaxed/simple;
	bh=YFywH1NNICjJT9Qan9SX2ws511YbJA/z71q+8XPWPkQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=NMAPHvZ2ym+LyqDSpgEZxb9CScowk60esYF+4LM5j+uiBDsui3q08TXpZVKX+Flf2CKypxWoOxv5iOxS1sJyebXO4Oe7octCtRe0Ipl+i7KY7wx+d4aOO/acpaFEkajESK6usx7uHp6w9pMl3En5BWWmc09DkMnr2IwHtUDORCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+OhCtRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+OhCtRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0778C19425;
	Wed, 28 Jan 2026 00:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769559015;
	bh=YFywH1NNICjJT9Qan9SX2ws511YbJA/z71q+8XPWPkQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=C+OhCtRjHcY7mZynFuZsKWtjMQT+gzMert3/KPLWyoq2RCibJHzk/cG4Qcc1GEHyl
	 29YqBOuHZ4SdO8gGntXJDnnMbR7X3oj4FpeaYyEbgeBDuQJ6rCIaCS61bhEg3efQtb
	 HqCpXVMISDIkXoL0rYGxQtJi0xgiBFwDzeFVjJuw4qM3hj/u5DvpK34RsHgUkJtEx4
	 0cCtM7CiR95buoaAeHgb/yApJeaTWHzT+lI7AcjDagUs5vzeNZ6CbjNrGr/9IOBAHP
	 XCOiDvpu19jgmYIcPjt/+87hBvaQjdwuxbE3I23NA/O5yoOeGadremK79ujJHKmvBG
	 vGg2sN2EsK/wA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id C8C5E380AA67;
	Wed, 28 Jan 2026 00:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Remove low-level SHA-1 functions
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176955900959.1450890.12872654962892844333.git-patchwork-notify@kernel.org>
Date: Wed, 28 Jan 2026 00:10:09 +0000
References: <20260123051656.396371-1-ebiggers@kernel.org>
In-Reply-To: <20260123051656.396371-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org, ardb@kernel.org,
 Jason@zx2c4.com, dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 22 Jan 2026 21:16:54 -0800 you wrote:
> This series updates net/ipv6/addrconf.c to use the regular SHA-1
> functions, then removes sha1_init_raw() and sha1_transform().
> 
> Please consider these for net-next.
> 
> (These were originally patches 25-26 of the series
> https://lore.kernel.org/linux-crypto/20250712232329.818226-1-ebiggers@kernel.org/ )
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] ipv6: Switch to higher-level SHA-1 functions
    https://git.kernel.org/netdev/net-next/c/5023479627e3
  - [net-next,2/2] lib/crypto: sha1: Remove low-level functions from API
    https://git.kernel.org/netdev/net-next/c/9ddfabcc1ed8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


