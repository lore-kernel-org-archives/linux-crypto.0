Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E501AC435;
	Tue, 24 Sep 2024 18:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727201043; cv=none; b=Mdy8C0pS0ovy57ioThkWUSn4ynYNR72+qN7eZVxeQu2DGnFNzri4Ti2zT0mBqQ5VVTUsbDzPN7FvbALj+hqVxrZH3aQmNRLJ2AiuncsMn3bguNf3m5wp3TAyeA/yQcv0bKpB0NMt8MDzn8IeHCM/iyqKH8KYtjH/TY8XRnRyY1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727201043; c=relaxed/simple;
	bh=Nry20tYU/hvIHE+Fi9qXVD9G9iu1adf5oXjftGVvgAo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ekT1m881RFF3r2dTa/wyp35rklpyiCzkCHklOatQdBwkPs+FnT0UEKlwohVlmo3ISEV7NNx0a0dEoOECKMBOBjAHi60xQCgOP9u1woNlK60XXg8BPYUpymf+TCwVJkwRMf2M4Cya6dfwh2GZEWsDFChOYzzG7LeCeIXLJAH1cYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OxBL/Umo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OxBL/Umo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88972C4CECD;
	Tue, 24 Sep 2024 18:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727201043;
	bh=Nry20tYU/hvIHE+Fi9qXVD9G9iu1adf5oXjftGVvgAo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OxBL/UmoF9vKT7O8qljIN2QcCswrDnqW/w2kKuMEcAirsebRv/FrGN4AQS7cDyF2b
	 eUH6xrJ+xpNb1vK9WDc5HvcK44JNradoO+Y3Ivl8BWIDbX5za1WgcHUK6GZZV0GEIf
	 7PvyEsC8RP/qa+hEEVWfleA6KQ1KtF6DY33RbGoslQgV27KaarIJwuBFLkCZB7lD4A
	 sWT5rjRhEtAAU5Tt+iS1I1eEeallit7Zhn8F5YeHBuVE6IGZFHkHwSel0/68JcigJX
	 WCHsbGawuv1TNA8aOr6F1dngP/2dn8kJPP9+UPH9RnW6WSBXyVC4UgUZAiCYCNYJ1J
	 l6OkcA1w0gEnQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D673806656;
	Tue, 24 Sep 2024 18:04:07 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
References: <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au> <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p2
X-PR-Tracked-Commit-Id: 44ac4625ea002deecd0c227336c95b724206c698
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1cfb46051db9ddb68e297eaf17270e09874ec5f3
Message-Id: <172720104593.4145686.7072222308128375599.pr-tracker-bot@kernel.org>
Date: Tue, 24 Sep 2024 18:04:05 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 23 Sep 2024 11:08:15 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1cfb46051db9ddb68e297eaf17270e09874ec5f3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
