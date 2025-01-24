Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A0E18F2C1;
	Fri, 24 Jan 2025 16:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737734711; cv=none; b=XMGbK9QpF8MNPrL97pVdt4hGpdMt+PndWXKZjXfFaifUtiR3xC4O3jx8Kn2Eu2qjsBt46QLyLN0iHuSV8cvMaevwLjf4Q0VA1l5VPpSZboMZkX2xubhA7QOZMCWqlc90/jGW8Gp2jei0f44Uc8tTrypAsh/yR4ExOmrO17Fd3dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737734711; c=relaxed/simple;
	bh=myIXFINSgmE+k+Vzncbgy5lK5UeGL4sbMNiSgs2cpKQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=P/WirbEDanLgWLo3URkd2FCMxMaMNpGHwbPEYROfbDHv7BXTa7DRRtN+DoiHcS1FtoAHU98Xih8PnrGgxbzWejXO6/tOON0P3eKJfnPX4ytm6h3UlJc2qYmjOiOKM6Cqn2HXI2QA795jTbr2xaS/nRwAlL2xHGchjfpGhey4dls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dg2oFPld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dg2oFPld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BB3C4CED2;
	Fri, 24 Jan 2025 16:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737734710;
	bh=myIXFINSgmE+k+Vzncbgy5lK5UeGL4sbMNiSgs2cpKQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dg2oFPldZ136rR+AjrCjC0+3Gy3iDBBqaTzbqkMQwk8TT0t0vnYbV6psxGO7kOAGY
	 n5JoSk9AxgbcyxN1yKZloFPUb0FzYz+0sE1poHyVqqPHCj0xYoXXxBBOf8s5+5Nb9K
	 EcK/Szh4HBi921Lmt716O6fMrS9z5kegrrvxGFFbMvPEVwCKkFCJ4DFHqz0Colz6Sj
	 PDcKg5yX66rh8371nCm5pNryhO5QqsODRqis7NVMkftGICAzW3vSee9teBO0isGf95
	 KDJEuQd7LTVsIllkokKvq+ES0wPE5MS9PlCs+sfUyb0qMW9skF0LhLt+1lrkAstReg
	 b9GtbaZoxrO2g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAF15380AA79;
	Fri, 24 Jan 2025 16:05:36 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Update for 6.14
From: pr-tracker-bot@kernel.org
In-Reply-To: <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
References: <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au> <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.14-p1
X-PR-Tracked-Commit-Id: 9d4f8e54cef2c42e23ef258833dbd06a1eaff89b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 454cb97726fe62a04b187a0d631ec0a69f6b713a
Message-Id: <173773473554.2087587.7761248322547842344.pr-tracker-bot@kernel.org>
Date: Fri, 24 Jan 2025 16:05:35 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 23 Jan 2025 19:10:34 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.14-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/454cb97726fe62a04b187a0d631ec0a69f6b713a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
