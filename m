Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D23738D6A2;
	Tue, 18 Aug 2026 03:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787025492; cv=none; b=gh1VV8qzD4G0TK7FH5VGhE41hy7fNwJSAqZTGx11QEZBOIHy7gLbngzN7i0QsaaP5H6kwlkdeDOaAh3ovTUUuuuS9NQPn9RI42Xx8QL1LvKYxdyuAcQ8x59tJY6jw/J/23vzr1e+2avDQzAoEbmMloNfLEe/RohLUGFYaM4Vma8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787025492; c=relaxed/simple;
	bh=gZXlH7EVeg2fmw/2ENvG7+8h/m40En4BgIhf12d54xc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OmjrCiuHXev/XS4/58Oc7HJlPBS5fjs88wO56OICOReIvsrXrV8ifsBUsChy4iisJacXmW1G4hKZYQWvFFkJxJF/2aAelTz28Q9P4GpnVPcg+b2Qqx0eWQJgDsO8ddhB4aJnHedI9/YWWJz2K7nSgqUHlG9bBPg35NVFVw7DuRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TjdkYuSa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TjdkYuSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BBF1F00A3D;
	Tue, 18 Aug 2026 03:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787025490;
	bh=dV0s/NYfQcudqU5686rdxB41prqW77rBNOjBBC9eEyE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=TjdkYuSarPPwFyzMYLRiofKufdmCRN/Hd8nGxbv5vu7mgZ4ul4UIlSHWSjJrcTeC0
	 0265TJK5a65u7eubGj849PqBG1PmkNLDK+Hm14ZTjuCHPrEIqyV+eOPyM6KnNqV6Av
	 paERhYlBXQNQjJIX7Odz5xV5VtE33iLFJVLydSVgCbA1ECJVmfeTOC5/WfX9jJPqE2
	 VUIaJfPjf4vvojoDOSofXmw4/YeR0G+fxAX9kuXYfmnZVH5RnmYucmkpzLbxk96hSf
	 SFsJ6p60HtMcgkf/lsCtFRZF2EenvtAkKhMj18V0b7lLXP7iVcDxXdzkJBXIA1SEQZ
	 i844iiV1SDYqg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 938703926381;
	Tue, 18 Aug 2026 03:57:23 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library tests for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260817174532.GD8327@quark>
References: <20260817174532.GD8327@quark>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260817174532.GD8327@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-tests-for-linus
X-PR-Tracked-Commit-Id: 561131a27f5533e6e63520b4bc43d9c832a27c09
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fc8c78bce3335860ff4ae9fcfd3b2eb1f674efbb
Message-Id: <178702544222.1862718.13696878249345033920.pr-tracker-bot@kernel.org>
Date: Tue, 18 Aug 2026 03:57:22 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, David Gow <david@davidgow.net>, Thomas Huth <thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 17 Aug 2026 10:45:32 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-tests-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fc8c78bce3335860ff4ae9fcfd3b2eb1f674efbb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
