Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA50C8E0;
	Sat,  5 Apr 2025 03:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743822507; cv=none; b=nK8EylEYD3DDuVH45i9m9vVzy7b6cgDi+2OX70G43HftbwYcLQTjXgh+/XNXhJes2N44I2kcoy5ZaEfWjr3taFJBUeLZsv2eM9ZsW+P2YFYkjX7K7E69+EGEmb4tdWloR+rC9LmrQPvb3Ov6VBmYMFhbQwirPBrEYVt3NDzA2+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743822507; c=relaxed/simple;
	bh=hY3qBxjnUeZNl+dbRmdPNBeOglco3GBszbi2Y72/3b0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Csti01+KLPvYE0lWRIPRCZrygqbR2hwn7vhcBO97nvfB9ecPmzLrkV87CZh+fos79paTbN4Dc9NYpCyzrSQFAe8o4sqKnHI+kf1gjerOi7LzlFpvtS2MDe++lo6jTGLOzYr32Gb/j1El4X//xK4y9Ckavr0xItWSAGRgkDpp9UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H81Swo9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H81Swo9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18261C4CEDD;
	Sat,  5 Apr 2025 03:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743822507;
	bh=hY3qBxjnUeZNl+dbRmdPNBeOglco3GBszbi2Y72/3b0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=H81Swo9p3GDmnSHphwJd/Jpns9BhPSCCvyamA2NWTCNqrWYr4Cee2WaERRdbq4DEw
	 w/DjVHydprarNhDtLJEdv4Vr4yukuD5eQhLwp8W/2skUnoTHuE9V4eHfmogiXTrAH0
	 a1yQsTkjEqofHY9Yp9uJOZ/JEBROm5mcVIKV1ZTHMcEVR6gaRW7U0VrZ4VCiuozDmz
	 zWFscMGP1MLcAAAaRrwIt/Z6giXx+70BiCRNb2kT8LiK/FAMmsBmq08qaOo/FFqavp
	 Mr8LW/RGmRZTbA6fjBG/evpQZA6wrMvRoObb1nEH8gQEIEoP6zwD7+P/d+egyi+Oe3
	 sdIPsmid+TlOA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70F853822D19;
	Sat,  5 Apr 2025 03:09:05 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <Z_CUFE0pA3l6IwfC@gondor.apana.org.au>
References: <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
 <Z-ofAGzvFfuGucld@gondor.apana.org.au> <Z_CUFE0pA3l6IwfC@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <Z_CUFE0pA3l6IwfC@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p3
X-PR-Tracked-Commit-Id: 12e0b15b1986736af8c64b920efad00c655a3c79
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a8662bcd2ff152bfbc751cab20f33053d74d0963
Message-Id: <174382254400.3509887.2094987018379246467.pr-tracker-bot@kernel.org>
Date: Sat, 05 Apr 2025 03:09:04 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 5 Apr 2025 10:23:16 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a8662bcd2ff152bfbc751cab20f33053d74d0963

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
