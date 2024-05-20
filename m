Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8C2E57D;
	Mon, 20 May 2024 16:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716222836; cv=none; b=KU2xkhvByvTmuJ9By4yMvYj+EGlf4SeDj2S59RzeQ0GGhkiNUZxeG35NFdOVzD/mam851IZ7xVYvhJOCFsZt8sdmcvN/mXB5Ul1oeVUfPkAGaeziRCsSC5PKrnNWzzmG7n7k7gZAy8F3467RHnQ76zx32sxFnbiFQTZOy8CSpR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716222836; c=relaxed/simple;
	bh=mHxM4umJ6Kfb9sMqszuEgHZ1WtBqpwJ8+qSP+stVI48=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=aZyKuGoW1GGHhwzbgZdFuGXkXqEQc1yTJdyCmCE+OSqWVISshMvG8d7Wuhm0WC92mwbFhK0f0Me1mgyZcz8W6CIjAd9B+JBaCSxXFhJxWpJZ79Y1R4XWr3Xi1zyYMkD7G1wzwZeh/Ve9/SfABhLir4ZKUNtpTd8/tdoV2xeAjxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uj+9ETRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uj+9ETRq"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D0E0C4AF09;
	Mon, 20 May 2024 16:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716222836;
	bh=mHxM4umJ6Kfb9sMqszuEgHZ1WtBqpwJ8+qSP+stVI48=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=uj+9ETRq6cYVKsudH4jQUSjfpMzx4AwLu9MZmpkGjg3xF/QGNx+NcLd09Ew7soOO/
	 OWP9wSmYlR/BhuD5HeViwomBPpQaGweisYeDoo8HDfYC1eo5IxOjUjKXJajZyehkG0
	 ZC1/g5PS1AxvlCztN7uIdXfEmLNQf8GR5PTyJfBk3JjWgKqiHeZ01IF/clm/3W8q7k
	 XWsGvZiZpbrD/Dd4+h4UCOB3PT+rtTQ3vuEvTn4V30BH27BtFfWUBh2zEcn5EH06OV
	 tZK3jsWu4l2XkAp/DwJ0Lg+cSK5r3D/OHH1R2LJUUHt+3nt1jm8VJSFzON0d4CEQqP
	 /SEFPbIE2zJ2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33F3FC54BB1;
	Mon, 20 May 2024 16:33:56 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.10
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
References: <Yzv0wXi4Uu2WND37@gondor.apana.org.au>
 <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au> <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.10-p2
X-PR-Tracked-Commit-Id: c6ab5c915da460c0397960af3c308386c3f3247b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 568c98a0f6eff6d44accfe56d0c58008bf0d498e
Message-Id: <171622283620.31783.7576966862048379005.pr-tracker-bot@kernel.org>
Date: Mon, 20 May 2024 16:33:56 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 20 May 2024 11:26:42 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.10-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/568c98a0f6eff6d44accfe56d0c58008bf0d498e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
