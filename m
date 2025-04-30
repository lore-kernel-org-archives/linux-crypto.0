Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAE5259C;
	Wed, 30 Apr 2025 04:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745986719; cv=none; b=bCaa1VhL2MSPRj1YVd1wow/nksO5i3AJn9s/O+3FsCZ6yw3fRGwGHDUGOyIz8CoPoNOhEb7Xo+ymw12fEgoEaxI+Th6WrPvb1ZUGVLWnN9AGyzHPu4bfBPef4c/5xugPHsuzPBxjXPUfbYZYbrGqBIKq1/KyggA8iryu0spL4As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745986719; c=relaxed/simple;
	bh=amf+vnN2HAcoHHdfN7rgm6A9V24nacrBsaJKv/h/an0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=WZc0oETBIM08apw8VpUy3QZ8JrwCq9zg+5Uu6HIqj3QgfjRCDPjLWZCsw3aEA7L9kiSfcSxu+RCLjn2SskvWaYes33pHUcf/m/Cpv063P8PBm87UGKas5BCkyVQQeFZHdN4oNbRxumnjuCWjji9ZKIQEusofvj2So7eXdhvKMoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sW/dzKbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sW/dzKbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC4CC4CEE9;
	Wed, 30 Apr 2025 04:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745986718;
	bh=amf+vnN2HAcoHHdfN7rgm6A9V24nacrBsaJKv/h/an0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=sW/dzKbTusgPYXMpgQ/SO/t7dGuhg7gPtGmp0Q9SSryZJfA/WR+pDQBwEKCcPS66M
	 jOoOpBZyfit2hVzZrPMRg5jM/iaER9UARE3HrnPt/L0x39gvhsQr3UNbdijL7+vElF
	 zZwUIcKNzCeSlVVSHdVQJ4LBw8Gr5ga/aBs4TFgSy8lYQEe/M9plydnUII0bSGP4K2
	 FF5pyTzaWTcE9imCUnJ1iYlvEwXI/5O3/PKgn7EbWjhF7mqaMEBGnFXTuc5o5tGb5/
	 Yp8Hjgwk7jiLe6CqaWv+V3wqmZH/rrgjwZGHRLFldrJlsQzp9gvaPJWHmqxGwzgq6b
	 6n/nXCBvrstAA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB1B73822D59;
	Wed, 30 Apr 2025 04:19:18 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <aBGPSpJcLRrwiutd@gondor.apana.org.au>
References: <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
 <Z-ofAGzvFfuGucld@gondor.apana.org.au>
 <Z_CUFE0pA3l6IwfC@gondor.apana.org.au>
 <Z_89K7tSzQVKRqr6@gondor.apana.org.au>
 <aAn_NWZjdX-wYHxR@gondor.apana.org.au> <aBGPSpJcLRrwiutd@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aBGPSpJcLRrwiutd@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p6
X-PR-Tracked-Commit-Id: a32f1923c6d6e9e727d00558a15ec0af6639de19
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b6ea1680d0ac0e45157a819c41b46565f4616186
Message-Id: <174598675762.1885816.17254634880865595465.pr-tracker-bot@kernel.org>
Date: Wed, 30 Apr 2025 04:19:17 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 30 Apr 2025 10:47:38 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b6ea1680d0ac0e45157a819c41b46565f4616186

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
