Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA8F1F9428;
	Mon, 21 Oct 2024 18:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729535250; cv=none; b=i1L9XMj22dEIiLh6FSnKPIrCTZfEHlpRXEKEFz9XWlSwyM8ERJvIPD//HPUhCKosGMTAiuP92cWqJbiQL8vCr5OJBIPLOcpUwld6Iy8uocKwnaxKRNwjuV2sjH/hl+Pangt1jj0sNszA3mjvkOeYJNGMu+UCcrEFu/mfb468qlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729535250; c=relaxed/simple;
	bh=2sEOQOPHW1JywRabWfVE6g+TWK69PAQId9/YmP1/b4I=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=omyqi15+GsJ20O6hptiMoAROHhjM6ecHYXmNYP8QTBVvgrMHlL1pWlkM6bQVtfM9ugBbnl21BSArP3oxv12Yzejo0+W97teo4Mtx53t99fLttIV/IYodvHB8sfv+eNX+xabA3rtFyW1fGF8E68mdeLO9ry4r+dn4/P1dWMyg2+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S0jypGmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S0jypGmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1688C4CEC3;
	Mon, 21 Oct 2024 18:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729535250;
	bh=2sEOQOPHW1JywRabWfVE6g+TWK69PAQId9/YmP1/b4I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=S0jypGmhGp5uoOK4Ozsx9ZXQmQmpem3pbft33fN/S49Jm7LNXhD95YP+FtITl3jkq
	 TPZAN63bkusJZ4Nkb0ezkICnzmgM9p/GqTH6lcVW6JacRKlz3NyOdjvpwbqYvHlduu
	 CmCeC5ZOTU1ucvATVBSalu8RTI/sYuExvoum13uqYOmHcpiOyhdu/Vu3hgKb8nZTrt
	 WOdVertBUlGuRHEbU30xyfR79yVl9TUKZ6CdTJeJtKp9yQI2Tpb81CpoBFQ28u5jt2
	 uW6GvsQ802/s0+LjWzRaYwReAFSASWWfn7Ho6kxf5lXA1oM3g694LNoLk8gTqwMPOx
	 8Pu9AggMgZGEQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3408E3809A8A;
	Mon, 21 Oct 2024 18:27:37 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZxXqbFAO9VN3ugIR@gondor.apana.org.au>
References: <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Zw9RM_jNu9vqp9T8@gondor.apana.org.au> <ZxXqbFAO9VN3ugIR@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZxXqbFAO9VN3ugIR@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p4
X-PR-Tracked-Commit-Id: cd843399d706411ff80520fb7883afeeefa76e98
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a777c32ca42b9a8a5e5abd915883a73620d9044b
Message-Id: <172953525589.401524.8311435958320768805.pr-tracker-bot@kernel.org>
Date: Mon, 21 Oct 2024 18:27:35 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 21 Oct 2024 13:45:16 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a777c32ca42b9a8a5e5abd915883a73620d9044b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
