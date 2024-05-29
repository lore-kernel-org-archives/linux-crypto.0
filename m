Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DACC1B810;
	Wed, 29 May 2024 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717002691; cv=none; b=lSfQOWqXOiSV29lNRXzsFAGWHj4BipAEmkiaGLOCT52Lla9shm2AjUyYLOQr5bC/qLTNcIQ1arO6z/1Wb8SIMVmB+okW4gf300/DYXXO0Xcmg62TW3Zspxaw1rCeoGonFNZt2zgvDNzJrqlEMMi1w0nIz3jrX0ph23L/fMh+NOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717002691; c=relaxed/simple;
	bh=ZN9sr+TXvW5Ln+ZWK8tWWaaBctNKc6GLhsyv9i+gi3w=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=a8CQNQWff7L7Xfv9bjstCScWmnGffW5ekmw9nvZPHxgzONAJd0HLdcybREQiYC9OYoOt11j+qnRvlP9D4bS+A5Ex3hR5XNUWNfG11Ez3Y5nCMe4eaJhcFaxegs4N0dIwdm40BQSETGGwxtBwCAZBEuN+D5FZ+/3zjr3hwjnL1oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LPQ0YT4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPQ0YT4r"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 034EAC113CC;
	Wed, 29 May 2024 17:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717002690;
	bh=ZN9sr+TXvW5Ln+ZWK8tWWaaBctNKc6GLhsyv9i+gi3w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=LPQ0YT4rvhoJHL3C3ahWoRUFfZxdOOPFBapFnm0jq7zsefGjY4Y6yTwS2g3ArO+YI
	 9jYToLrtrqB1GZIEN9KI1sBDfhivyalON7yKD3SEUpca7aEoE1s3KLpR24RgobCrIQ
	 0VD9yzhqsKrAch1aTgt7PB6lL/wIoa5xBMZ3HeAepEvqZsi8Z6YC9R3ttf7F9wnB4L
	 15pPIGRtQV/GTnb50vbKYudV/tcXw07gJ91l0iy7GrjlR9YqXDNhTJRRD8ybhTHJnM
	 9+QYOUF3ZT1DuhCSdLJBTXlvMWuQ8lGHKlMjNesHih78X3KVzsHRzxTkyEnHXmyxGe
	 l/pWTw8qXMD1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EA421CF21E0;
	Wed, 29 May 2024 17:11:29 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.10
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZlascqIex2rE2nO_@gondor.apana.org.au>
References: <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au> <ZlascqIex2rE2nO_@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZlascqIex2rE2nO_@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.10-p3
X-PR-Tracked-Commit-Id: 67ec8cdf29971677b2fb4b6d92871eb5d5e95597
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: db163660b02abbffebfad1bcd6dbce1201c72731
Message-Id: <171700268995.30079.5541394862780715730.pr-tracker-bot@kernel.org>
Date: Wed, 29 May 2024 17:11:29 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 29 May 2024 12:17:54 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.10-p3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/db163660b02abbffebfad1bcd6dbce1201c72731

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
