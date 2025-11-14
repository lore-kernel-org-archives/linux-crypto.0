Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66D931C595;
	Fri, 14 Nov 2025 18:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763144436; cv=none; b=Q33MdCF9hnsWTuW/gTN7vU8iTxrZ/KMNks2jx+2LPj4tH/f01krJF+emEP7oHXy1l/wM1cpjyaPYpKVl4qgggEcJWGc7UnXX8TXlYnOrJaTKtbIdCpMsAL1r9+iQLjycFgNM3LjhJ9xpz4vqYAWAI8/3pANCu13OzIfBGuK1cJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763144436; c=relaxed/simple;
	bh=PziOzj8UlCOhp8w/YGnSDZ7jYPbZA60+DziSrmjJAfE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=o4ilLuvisBF9Tl5QdGLIjrtgEsyxqgkG7dI1anQRfWIESN3i07nguFDx4CwKE5ZNfOGJ/sf1n/j31RwnshKEiETBeyBYfmtcpCfin8tPX2ZmybMUlA97D7iWiqyQgPhpdwfitaUiOfU95pqOqwZsm7aRPh7yH0BrzL7Fmn7uPak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gfNI+kfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gfNI+kfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D81C4CEF5;
	Fri, 14 Nov 2025 18:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763144436;
	bh=PziOzj8UlCOhp8w/YGnSDZ7jYPbZA60+DziSrmjJAfE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=gfNI+kfcvkCCR3z0WXBvN4NSVyvrZPLYVDzT5ezHkWgecUMjzsrV6WlbHHeclpzzw
	 Py28YFjVCS55dTBsjcK4YOfCYgJqLquT+DuQC5vdSXcd0j5EEUn88Z5gFEBnuBzpJB
	 R8oP577TaTghgdUZ4Lo9FKEuoD2WZJeuvVF/Tyx4W+npXFcSee7UJLkdj1fMwaSd2D
	 N/KuqMUWc96gGN/9cdxSenSsPdfsWfVe0jZ2sR0ssdrsQTLjmLnhtKc0MS0/pjMfyD
	 1diOJkvg9sTnMLDUF1cXPIySL+zBy1Up7NnuN39Xwsm+CrR+Hx3714f8mulxeCKg1G
	 TElVaTHyhv0Kg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7104A3A78A5D;
	Fri, 14 Nov 2025 18:20:06 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <aRcBNZJDTLFTTHxN@gondor.apana.org.au>
References: <aRcBNZJDTLFTTHxN@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <aRcBNZJDTLFTTHxN@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p5
X-PR-Tracked-Commit-Id: 59b0afd01b2ce353ab422ea9c8375b03db313a21
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b86caedd0b2c6e86c3fbaf5a04e5f9161b5688fd
Message-Id: <176314440512.1790606.9345148328376095634.pr-tracker-bot@kernel.org>
Date: Fri, 14 Nov 2025 18:20:05 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 14 Nov 2025 18:15:17 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b86caedd0b2c6e86c3fbaf5a04e5f9161b5688fd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
