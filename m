Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3052B30E0F2;
	Wed, 14 Oct 2026 15:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991688; cv=none; b=prRUXZ4ArWIVoRm1I3hFwMgsxTjTWbD91mfxyvWahUPOAjw+sNVBtoVZAxDy9aYYBIX4pa853lb87JwAO+lGk4qrKpwJoTMyIekIaTyj82CpFhOJPmZcIX41x7mc1pMsYfyMYgEiY8PHTL6fG5braCm+LiVFVEJMDVfjatNiGJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991688; c=relaxed/simple;
	bh=vySwCo/m6FnzKLXtDPHpRkKFWtCS1FS8hofCSbSCt7s=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=c6rRnHrgkrcdUtKFfNiS4LvkG6wclruxiMdOD6ph3dCJd9fTEoCJ19lUrPTLc8syrizpPLFE+U1ZqlaCFLlTQhAjsLQpqxAHKYTpzQJVsXhhoY7B99i+w245c5TsMkK2h1iO6bFXIa+6dg0zTxffovBbQMbrFU8rtxJc3ujxbM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KmhQiIwP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KmhQiIwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8951F000C4;
	Wed, 14 Oct 2026 15:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791991686;
	bh=/ud6+KD4quyTh7afRqwzk//nYlbo/lzrjqjfzxBCTAA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=KmhQiIwPysSeH6SgIqOw3nb62xrrCQyUM/zzBjTDoAAhrzr7b/xcqcejvfSlYE2dx
	 P55bJs3yHZ1VXvMX9DeBJ4D9q29gF7fi5NM0FTHxOwcDnRCOwrzdTRU0A8iawAlj/3
	 dGScPRcBXb5LsDTGtdepwYeDVOmX5WQ0gLcedIhxfJtWrfm5pmhmImzZ7e9D4nONy/
	 ltKSSApasJUX914uN0XHMAVSpigsVw3/uSQrJNFuTucuGBMx+AxRp2sbYvnr2Nev8G
	 W/QsIYDEJnsynzLCTkael/B6iFNP9fps6nyEc7160CfviijckygXVYj0U4QHyk5wzQ
	 cZ8tVFme3dKxw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B469C39F1DF0;
	Wed, 14 Oct 2026 15:28:06 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fixes for 7.3-final
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261014131520.GA97513@quark>
References: <20261014131520.GA97513@quark>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261014131520.GA97513@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus
X-PR-Tracked-Commit-Id: 7b817748bf083ad715a8d70de63f2184178cc372
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0fcb05b72344f40806cbe810de8872f1698bf053
Message-Id: <179199168521.2361238.13327515092527634616.pr-tracker-bot@kernel.org>
Date: Wed, 14 Oct 2026 15:28:05 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>, Sashiko <sashiko-bot@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 14 Oct 2026 15:15:20 +0200:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0fcb05b72344f40806cbe810de8872f1698bf053

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
