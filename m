Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C7EC2EA;
	Fri, 29 May 2026 00:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780015808; cv=none; b=K8AvdPPzfFd3BRL5MZ8/UcGdWnJALHw2cNcOFhKLIaEfJqUfbRlsY/3M5oZN3loscd8ic0GKyFnXqNKX3QZyeym/wWB47nV5SPFAbDtEPQ3Fkghv45Lwm1eSEtTVUUcF9v+AdGgeHIlOVIbgEULmlOTR1e8X3wD2GrIT7dhoGxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780015808; c=relaxed/simple;
	bh=hIWLlnzV0lM+MVRFowSZ2kp+dkzlKkdfgrjXOerTqYM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=NsrRbKHlM8vTPZ/7i13PYA0WtYNsE2+O/YQpobPwxxKCFCz7ezPwnbEYZh3P2XouysRe9Lp+H32wGwHf04Ed8OosnrIhwU8BVpi5BO82QIF8UBHDQXpLlFvi32R3WambTnfNyVtk1/b1W0VvdPa64Xy/SxXrF2z6ENQP8HQEaDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eQS7G9qG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQS7G9qG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829F71F000E9;
	Fri, 29 May 2026 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780015807;
	bh=9c1Jg7Sy66lUkriJqX6233T9AcnGFds8CGU3Ig0aH/4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=eQS7G9qGUxFCVWWZ05cA6kxadrGe3bSyKQ5tUF9jbePbx4peSYEJ19Unpsb+3XhNt
	 J47i5O0BYlGU/6EdTLsFRLbcIU5urB9U1CY5ME9sEhbAt5WsYGc6WPHqagLbqfnERE
	 6lWcbMpuGk9YA/TnZkmR0moBzyYc5Ib9J0WoZTqFqyn9XVgYmolovkzqmjuqjT7ZY4
	 /PkyzG1ArCwzT3lxD04uL2lZ54ra1IjQNQ6FtBvsmbjjTxzgu3c3p05Y+K7vOrPqx/
	 2XD7CgXdEjijPhbBfxSj4PfKztlCGYMc/vyEo2/yG+p5907Z1/rxRHSJj1ah/64fNJ
	 cuOu0xfy6PEjA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0C3A381197C;
	Fri, 29 May 2026 00:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] Remove unused support for crypto tfm cloning
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178001581139.1574269.16262378108123076484.git-patchwork-notify@kernel.org>
Date: Fri, 29 May 2026 00:50:11 +0000
References: <20260522053028.91165-1-ebiggers@kernel.org>
In-Reply-To: <20260522053028.91165-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
 kuniyu@google.com, davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, ardb@kernel.org, Jason@zx2c4.com,
 herbert@gondor.apana.org.au, 0x7f454c46@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 22 May 2026 00:30:22 -0500 you wrote:
> This series is targeting net-next because it depends on
> "net/tcp: Remove tcp_sigpool".  So far no commits in cryptodev conflict
> with this, so I suggest that this be taken through net-next for 7.2.
> 
> This series removes support for transformation cloning from the crypto
> API.  Now that the TCP-AO and TCP-MD5 code no longer uses it, it no
> longer has a user.  And it's unlikely that a new one will appear, as the
> library API solves the problem in a much simpler and more efficient way.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] crypto: hash - Remove support for cloning hash tfms
    https://git.kernel.org/netdev/net-next/c/f331c7be97ce
  - [net-next,2/6] crypto: cipher - Remove crypto_clone_cipher()
    https://git.kernel.org/netdev/net-next/c/cb2e6e86ceb5
  - [net-next,3/6] crypto: api - Remove crypto_clone_tfm()
    https://git.kernel.org/netdev/net-next/c/590a46c68a7b
  - [net-next,4/6] crypto: api - Remove per-tfm refcount
    https://git.kernel.org/netdev/net-next/c/3065170bfc7f
  - [net-next,5/6] crypto: api - Fold __crypto_alloc_tfmgfp() into __crypto_alloc_tfm()
    https://git.kernel.org/netdev/net-next/c/9d58d14e3a18
  - [net-next,6/6] crypto: api - Fold crypto_alloc_tfmmem() into crypto_create_tfm_node()
    https://git.kernel.org/netdev/net-next/c/0200de9d75b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


