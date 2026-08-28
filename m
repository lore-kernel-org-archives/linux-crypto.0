Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6389935C68B;
	Fri, 28 Aug 2026 17:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787939392; cv=none; b=CYqPGO1QxN8H0OI4lhaB8Cna0qA7LU19tjl1siO1hJvJ39U3ygbi3k31CnA+O4MGXIvwtV5qonVxBZNrZWi5flA0Mx4roFIPNVJELrZvZ8dNNeYKYzu2tESckmJm3pNIEQ13OUxtF1YtRDlBARptaVbMGgDoAaOzmUkPHYmeMXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787939392; c=relaxed/simple;
	bh=JdaVoS3N7ngwnCCBER8dkSqGaQTn4BkvebsFM5fn/gk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=oGTy9Sz0pngCpLYiKNPAD+AnBZNKBlDWhDCTrAK8OJsz6QOf38dKY3p6KYsSbzRGUqFboEbp97s16UMK43ecZ4ErI9LDF+tQcAjR3gF/bESqRIQEKymG4SY96s5T0jnXLL6zQqC+ZQP7+824rIta6crrHrWo5KYhybSsMvVfrq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qst0uspe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qst0uspe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0699C1F000E9;
	Fri, 28 Aug 2026 17:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787939391;
	bh=HOR0e9qgz9FrcWvJ194fgH8CaXC8Q4a44s8v3QAsbHY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Qst0uspeIVEXBGLWqUI3gFw8VolDbiwRNFR5MW7umkQFyCBlOZx+1TJOMA6cOsac/
	 oJuVQTULID1DzV+ndt23Isy7gHpVH+nbAYtA82iYuD5PUrLXPnSCr5pUTsxxlupkFx
	 FwTgVIqTy3CR+w9XCaS4IIN7QUFKIos/iDdatgxRtvCXxkkWA28BCZ+MHJOCvkRMbC
	 6aR7YhHOHtFsw4zifYemZ8PtfBpXQLgfL+f2sj5di5Mgfz9fOKtKJSry0pwAsMiZ/g
	 vY6qLbOtv1QRLWNLmZCIxKfznr/eH540J6G8tHs2Dg0Hww2DhJD8ihReN8LayMLTFX
	 0QXo7BxYpE0tw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1987D380AA67;
	Fri, 28 Aug 2026 17:48:57 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <apEv7dEdx36Oano_@gondor.apana.org.au>
References: <apEv7dEdx36Oano_@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <apEv7dEdx36Oano_@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p2
X-PR-Tracked-Commit-Id: ee440d4fc0d2f15894ab1f64c474a3adbc858880
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9df08cdd33a70ee1310523065fc4e3f161f6242e
Message-Id: <178793933552.2708560.7021033823486780112.pr-tracker-bot@kernel.org>
Date: Fri, 28 Aug 2026 17:48:55 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 28 Aug 2026 16:51:25 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9df08cdd33a70ee1310523065fc4e3f161f6242e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
