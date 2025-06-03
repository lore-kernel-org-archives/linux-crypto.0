Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A67523E338;
	Tue,  3 Jun 2025 16:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748966927; cv=none; b=O8WJ28zoIyJeTvz4mMJg8NFbeZ9J82FV+MQZb4r6bjf5VbWDW2HWtGxQcf8/tXjqpmIBq+SoLol//gTypklqWqj5T+N368p9jDH4tv/V+yRIYyK8cRB5CSfrN2hshmco9XYdYMouymLSvZz77mGBBzrLJingww9BuvlMWfDNMfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748966927; c=relaxed/simple;
	bh=96SPufIrpbR7wcQ7sN5b/FmYCyQhHS3Np/ejr/JKaYI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=phSCo4LPeIae9qFSuqC82bzS3PwOPb6SEMfN8gpKEHjS4JOjcX+39IdMOPbZwUQU37YWcaNyZPC1sMGbleEzvGF5BYpdT7sclUh1zqErzWRDjwP9ztWuv5jBnHa9iemdhMJL0WHJUVsJeQ/jPzS5sCl58o5vg4l9Er1ZvsfKvb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EwFnVu1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EwFnVu1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5336EC4CEED;
	Tue,  3 Jun 2025 16:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748966927;
	bh=96SPufIrpbR7wcQ7sN5b/FmYCyQhHS3Np/ejr/JKaYI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=EwFnVu1SU9zKAl/l9DeKxEzH1fXYn0vUQlVLtMjbz+OPCBqhHtRFPKc4Ky2S73gR3
	 kcqoCVnV/N1ecX+vGkk8z7Yd8gdqVuhovOeucVAUmF+TvkpLmYxaRwrdnHtMLQytCl
	 pgArNe/c5peSS6tQDC0KQUZbb2uImfq/P5dTqND9lwLoxm28S/ioX4jYc0f7dwY92D
	 +EDWf3PBjNbwM6ldOAuBuxKGDPFvo+YDoZW0durk51mvULucQQqkL979PRi/R8OtKp
	 ZNil/7LPOkb1g7aaFDiu3y3sa2bX7xzmUHGLk3IncCPCnKju27wphjejya6CkNdWV+
	 Lu6VoU/KZvHyA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAFE3380DBEC;
	Tue,  3 Jun 2025 16:09:20 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <aD6CFvN-fgiCs_-6@gondor.apana.org.au>
References: <aD6CFvN-fgiCs_-6@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aD6CFvN-fgiCs_-6@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p3
X-PR-Tracked-Commit-Id: b9802b54d41bbe98f673e08bc148b0c563fdc02e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 04446eee58fcb2a6c9db5abff7f07cc2f38da9d0
Message-Id: <174896695977.1571592.4068825608541997845.pr-tracker-bot@kernel.org>
Date: Tue, 03 Jun 2025 16:09:19 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 3 Jun 2025 13:03:18 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/04446eee58fcb2a6c9db5abff7f07cc2f38da9d0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
