Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9261F285C84;
	Wed,  8 Oct 2025 18:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759949380; cv=none; b=KbWLPYvytS6lmnrxCesteBSDYNQVM2YyQPW4l1aDqusNUH+BvO2g/Iv1FaQ8CH583iqgtmO+eDplqDLyNv2mvl9W/ndQWwqisZnQha/hyt78eyJZv7PzQ4p6jxpg0Wl4h/xWmHDFvDeZvTaPwaXNakTHHN5PYW2PKEQZtKWtLF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759949380; c=relaxed/simple;
	bh=rn/CksSeidX4XVatbLodXp8DG0AnrwoSBGc1MI3zS6o=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Sb3xS68novoy8tqm/fQzlGm3S2C86MGNLiCCUXj01CDPtVXVmPYMVrYt/AiF0p+bz4gOfmDYyT1FvVlY2bETKg0sHLhBMnZS/5NFTbghA6EMC2+zU87IhIKTu7KBAjAZVRD4SwP0gxb+rXSIwgvhWEixyGc7QlgyjUH71mNC+MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ztx4FKwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ztx4FKwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725E6C4CEE7;
	Wed,  8 Oct 2025 18:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759949380;
	bh=rn/CksSeidX4XVatbLodXp8DG0AnrwoSBGc1MI3zS6o=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ztx4FKwWNwUUIS8jXQknwy31/O2N59T7rVmwfYqCnz7hbUbpQJWZaK0B+kUSjKuw3
	 roIABMVbjYugVGWvvrq+jfjW9EvYGjTyM+u8e+JZArN7DrrOINmm4xZu1VhQXDXk1T
	 /nd5YAR9nk+7i54PDIAl4+PFiGE5HGPk1o5G9WZZ/ViOrf3DPIfyh8Vs37ZwNUNZKI
	 GF8MM3J6LG1NBcnUPwfKHvzbop243pz0fQPExNumr8CbdQCVjJ7m5bUlpivzyaT4Za
	 i+GchvqIpUwp4fd10V/glm57O81tjFQhkFxmVCDoMfP/rCbBHWutFSqB8Je4BbFCxM
	 2o/DFKzsEvo6g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33DF73A4100B;
	Wed,  8 Oct 2025 18:49:30 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <aOXczKUtckTr4uCl@gondor.apana.org.au>
References: <aOXczKUtckTr4uCl@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aOXczKUtckTr4uCl@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p2
X-PR-Tracked-Commit-Id: c0d36727bf39bb16ef0a67ed608e279535ebf0da
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7c8dcac8d72da94328f4de7bf98320b75710da1f
Message-Id: <175994936874.3563654.18007539900437432887.pr-tracker-bot@kernel.org>
Date: Wed, 08 Oct 2025 18:49:28 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 8 Oct 2025 11:38:52 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7c8dcac8d72da94328f4de7bf98320b75710da1f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
