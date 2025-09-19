Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C674322761;
	Fri, 19 Sep 2025 17:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758302129; cv=none; b=fXsgqhd8qZdf+4aqPaN4kMA8yfrDsU1Rg00aAfJl6NDS+LFi64ImujJhvw8/QrPegL4ujK6RHKj0n6G4ej4ry7caFqmtnh+MTKc3kdo5GWGH9gxRtZ1pl6W05i/fSaJZC/0OPKEl3MvE8e0Puw7TuJT/zPrN38G+ZNa22ohL/ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758302129; c=relaxed/simple;
	bh=qlpo7NNcYN6CRhJBeWOyMKsYADlLPk52U7XA6pwEZrc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=HNaS9LMg8gnEXw+D7YFds19yQTZtRnhmm1+yzY9yidHOGOAxsIH1PJ3TNjlsRP2kiUkeY1qKaF78vFvn/nMh3rk2JzpayJzJTxasL6NB9FyqxioMVS2XeVvJ5vLVWvYkGb/rVuaAf7Y1jVQLNegd5MuyVkSLDJOJmwXrChC+CIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XkbvOxUw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XkbvOxUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AEFC4CEF0;
	Fri, 19 Sep 2025 17:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758302128;
	bh=qlpo7NNcYN6CRhJBeWOyMKsYADlLPk52U7XA6pwEZrc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XkbvOxUwT8SGTKjoEwa5H/2mRJL/qrspW2tdWu1ulpgZ7vJJ3zIQepO8OYoMnO0G4
	 YzZKUTHK6LQPhr3LQYCWOJ5IdakVib8mL1cph4w2vJg9Kfm/soA2bR5OzsFSmhqsJk
	 jw58aHQ6kgpozou6jZJqrtxuL5t62I1S7OJxOoVuqaQgwz0FtkWvqmcvvdrsfARoYX
	 4Ih3LZFEkl7/qn9mZnjVn4naehorsYAZxKukSs4v/XT+1sbOq9urRK7EMXyf97yC0L
	 MmODNDi0vosEn75Dj8oa0BeKMmUr27lTcsjxtq0s1GlUNNTUPbW/DTEjRLdBTBkHAE
	 uf+8r5XYjPz3w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7190239D0C20;
	Fri, 19 Sep 2025 17:15:29 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <aMzXm4zy8LARVMbk@gondor.apana.org.au>
References: <aMzXm4zy8LARVMbk@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aMzXm4zy8LARVMbk@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.17-p3
X-PR-Tracked-Commit-Id: 1b34cbbf4f011a121ef7b2d7d6e6920a036d5285
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dcf7d9e0aee523e588aa3d5ce7394043cd2dea9e
Message-Id: <175830212809.3636420.8856055781957639331.pr-tracker-bot@kernel.org>
Date: Fri, 19 Sep 2025 17:15:28 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 19 Sep 2025 12:10:03 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.17-p3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dcf7d9e0aee523e588aa3d5ce7394043cd2dea9e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
