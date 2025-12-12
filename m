Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518F62F6921;
	Fri, 12 Dec 2025 10:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765534315; cv=none; b=ZMar+/fYEbQZFs2iPQsirCZXTa8NdQzKbEa0b74yCR2ZJGypM5T9cQuMRH18iZ4FAG1IpdjCO5NVloyksljPPITZr1aWjCpIgxrNa/jMm+D+uIY40q5kn4U1eyvKM+iiERKAGhryeuxZllzDaiZ+uceHhY/RlMCZYP3ECXISo5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765534315; c=relaxed/simple;
	bh=//YvcFKn0+j3qQqIcMA2YNDyydX63rRdGRgEI+xjb48=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TeC6C+boIJgXibAe/b3anDkMijZWI3ZW+drkr5KcpS07kXB5e5KJUTdoYLuWIwVxsmdaeox6ASjA8aw7mGI/i4z5ws4rm7TwtGo85ADuZU19tCQ+OAibbo32bRpbjDpk0JkHXusXGTeyGCtSAJVyQIRDSdbiFMtzLOmW1OCqnBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CO6p8ust; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CO6p8ust"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFCCC4CEF1;
	Fri, 12 Dec 2025 10:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765534314;
	bh=//YvcFKn0+j3qQqIcMA2YNDyydX63rRdGRgEI+xjb48=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=CO6p8ustyen1+T8g7xklFODj2P2/DKh4pGHRV/velzOinWuRHh+eScYouGBHHS2HU
	 7j5X9LzSPkhJEY5AIas9NHiV9nYZbuP4hR5ar/PIt7DJbPL/L3fWaSDVssVN3CMFZX
	 QOILDh8QzzkOPkOxpYJbgc+3/365gXwB4QQrnVuEd0eJj1AQ+j6hPMOO804sAV8sw3
	 A+G8bFbceoXWE0/dy2vv0HrrxeVAg7i8QhyLgTufmccPbWDX1hgDBPrezBlvlOpr8s
	 73TSdyY3dfkikhMur6N4PasWTxqeO1FdzHgoNCahSJ3JiWGikjhWLGplb+Au5GCfme
	 YPqVRGMGMSgHg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 787DE3809A90;
	Fri, 12 Dec 2025 10:08:49 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library fixes for v6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251212035818.GA4838@sol>
References: <20251212035818.GA4838@sol>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251212035818.GA4838@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus
X-PR-Tracked-Commit-Id: f6a458746f905adb7d70e50e8b9383dc9e3fd75f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 187d0801404f415f22c0b31531982c7ea97fa341
Message-Id: <176553412814.2108206.9564239926182569541.pr-tracker-bot@kernel.org>
Date: Fri, 12 Dec 2025 10:08:48 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, Diederik de Haas <diederik@cknow-tech.com>, Jerry Shih <jerry.shih@sifive.com>, Vivian Wang <wangruikang@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 11 Dec 2025 19:58:18 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/187d0801404f415f22c0b31531982c7ea97fa341

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
