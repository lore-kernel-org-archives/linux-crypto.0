Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72E3233D9E;
	Thu, 20 Aug 2026 00:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787187386; cv=none; b=R3gZyiKBF85h7R9lJPZh7l8zq8zsXtF5E2vemNsF3NEsTecZrRtIDMV3Z69i40d5D+qpARFz9NxNOXyT9zRTw4C19kz2MvK0hdp+uPOPN65GUPIXXHhjSp/Dy/e6SMf6iW3ZwQkI//QKWjFKcPxXIUcYykkXrhmLPDRClAOaOpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787187386; c=relaxed/simple;
	bh=tLhP4UpNs/LaEUPOVu2dHM+2i1iytSL/zEHhfgdsk2w=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=akIpciIQKssfQR4Q1qjdeRvQzfib2nQTlvo616LfdHGvmOgFphBO8vQme79lOfQZRQm9juIqxIT6SobafBUtE3hFNGj6pqEX9jJABOHxSoUJicZS7RLmVM8LZLT+Z9O7cJDFb5TrShDY354b+UaP4Oa3WhsxsQjMsuMfuCDeUHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpUWkvs8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpUWkvs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14E81F000E9;
	Thu, 20 Aug 2026 00:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787187385;
	bh=XSxvtOmafHFZMIb0fiLqfHRDepDxDCE2FVGZlhrD9n0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=SpUWkvs8FCF31VFat0D2KTtLpr/AO0CJDnhKS9rKhZh8UzLR7nCYEtMr+x8Sh0/mj
	 sGN7INPay2t4m8vDrqwO7CEDrAZ7E2vrQaixQHWcuKGUSUz6h8dHIy//eWKShqEjQe
	 luxRWravYPT28ipEjv292GeuZuYvu+Oq6NDAVVw3SM57OyC1D7kyHBaiPvjaRdKveg
	 GSp8U4O1JUJt/cAb97VtuiKUN8THYQI5tgeeWAWbWVv2iXLn4jJQk8rKqbatSZ+9fK
	 N//KXJ0A7IguOT1tVQcgwsS6t8YLSo5/UWTlSV8qoyPDuIelllhYtksF5OXk6bkcq+
	 J7risJgys6eGg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9396B3811A50;
	Thu, 20 Aug 2026 00:55:37 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Update for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <aoQL-FPagOSHf8Ug@gondor.apana.org.au>
References: <aoQL-FPagOSHf8Ug@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aoQL-FPagOSHf8Ug@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p1
X-PR-Tracked-Commit-Id: 7537036a2e6fe96f8ed82034f755c54714a0e417
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a4ff2be345d0abc943da8dd8da98151843b750dc
Message-Id: <178718733622.3758847.1813152833176803007.pr-tracker-bot@kernel.org>
Date: Thu, 20 Aug 2026 00:55:36 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 18 Aug 2026 17:38:32 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a4ff2be345d0abc943da8dd8da98151843b750dc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
