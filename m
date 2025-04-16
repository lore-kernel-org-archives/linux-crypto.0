Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC03F18C32C;
	Wed, 16 Apr 2025 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744817038; cv=none; b=b5WiJDUQSr/T58SM9HzBSzSAzrh2UYfnoPYcj2NTqbAK9EEFDsWSxuBW+Qw+z+3W5hfhDe4jtcXN6OttXHmI1KNZKcjyCWVL1KBWkG0xWahUkmz0TVueBaH9e8I/SiThkC9w/HqvGCf0v3a6+Y5Nc0FPT9+Fq5l0TK57TqOEbaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744817038; c=relaxed/simple;
	bh=8XPcMaYVMwW8Co4YCqNYFo41qCAFeBCoRi8bBGzPEPQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=AktIbchKU1k+VxmSYigx+Ykv+rWX5IRfhTR9TMDXA/zZBm8uwlpXoAG4+MfoKUSn/zJEKkUhlvfd8yL872J+r/StNdsOYi05K2rZBYFEX2SPg1PDniGGvVBLDQVlFql3J8y2oY55+1Bm8d2ejcxNWEKmufrXw7axjL42H4HrMpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e3YextUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e3YextUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D61EC4CEE2;
	Wed, 16 Apr 2025 15:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744817038;
	bh=8XPcMaYVMwW8Co4YCqNYFo41qCAFeBCoRi8bBGzPEPQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=e3YextUT3X8P/kE/7IXIGWMls6kqQAU7pOzanmj5Nvtqbrp04zMcwbqk4465F5hJ9
	 RomUM0Rz8R8oGTpsRT7tiDHvoEcJODTjizX2GIpM/fEvJixsyVLDU8BIP0hHyreKYF
	 OHCYSbc2Tbtq++zMFUb8nQ6ejaTIBJ1KpEeaN5hVJ29K4GRJcRSDkMv6Wo+ypSTE8H
	 bm/3JNCVMDRkSoPq5+3xI0tV1KXX9DDEIGZ8ThtOjiOYWbOpBVsVM2p8TRQiD/ECKx
	 kmw63wYx+P0r8VUjyQqicTpdwmEqS/7WIciijBdXvsjx2A/Qks1OMytgkmHXVMf0FL
	 2ZhWbtvdmSPSg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 710E23822D27;
	Wed, 16 Apr 2025 15:24:37 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <Z_89K7tSzQVKRqr6@gondor.apana.org.au>
References: <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
 <Z-ofAGzvFfuGucld@gondor.apana.org.au>
 <Z_CUFE0pA3l6IwfC@gondor.apana.org.au> <Z_89K7tSzQVKRqr6@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <Z_89K7tSzQVKRqr6@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p4
X-PR-Tracked-Commit-Id: b2e689baf220408aff8ee5dfb4edb0817e1632bb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c62f4b82d57155f35befb5c8bbae176614b87623
Message-Id: <174481707610.3404472.15311451011419368445.pr-tracker-bot@kernel.org>
Date: Wed, 16 Apr 2025 15:24:36 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 16 Apr 2025 13:16:27 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c62f4b82d57155f35befb5c8bbae176614b87623

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
