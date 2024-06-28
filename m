Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C9828EA;
	Fri, 28 Jun 2024 01:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719536514; cv=none; b=fAJGHjF/A5yUr9zlZTClban9MIdNQO0UJfSnGQHkPW4deFx1huRfDbEfBA+a+3rnxtJWQ1dsyttouXqqufvlJMccMhpQU7HOgjLSHj2js1KsAIBnT1W65gQ6z98C3JxXLI5uzyDeXYTu+5cS9Niy8R7fqL2I2pz9sRhNXGRJ0i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719536514; c=relaxed/simple;
	bh=pV2h0LEZ2VCWHX8+jQOV1ozSQfsgpmRWnzRtqC7oEVw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jCmsMjr2N/X64HnhuJaJtE5HS7h/ukJk8yg1EeKUe6pas/6zsadDndhjV0B4fVM9L9g0Pl0gcwNKz0MpaxGnn0g6Tu2qaWA9l7jw3lXX6V9upEXaAnSbrdO6rHhmU2HIxxs1gLMRe5qD8U2JXrOBCkO1Cn5oYLq5f0iWSCJ0Ktk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f+n1rFkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f+n1rFkM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E23E7C32786;
	Fri, 28 Jun 2024 01:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719536513;
	bh=pV2h0LEZ2VCWHX8+jQOV1ozSQfsgpmRWnzRtqC7oEVw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=f+n1rFkM1mo2jqiSaASnPAlLiQ0EvEI+ArdJHAlFIlxfjFGYTEKyKDJTOn7pda4GG
	 CMb0+aonmgKifEmQcb6cM8yFqsXFXTGrZ9CRUTtbff/s+df6fBWf2fBTqmMWoaHOTh
	 +4fPv6rxeqAq3FNNc0EtKksA4dvdXq4DtFpEdxL9lMZCVaPKRdJp7CJuu8auMLj165
	 auM1b/TzYk05BBSAH8qx7f772FfyOWG40Vh7hmoQEo4dBngSFIPN+SQ7FZO2PiqxVs
	 YlfSe+SdXnOsiv09hkdZQzKmHJ68yhfiTrEvrXUbK+7WebDfkbx6KeLwOIv85s7uT7
	 zROzABJtrIK+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D72EBC43335;
	Fri, 28 Jun 2024 01:01:53 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 6.10
From: pr-tracker-bot@kernel.org
In-Reply-To: <Zn4Gc+jxtfLZ+cD1@gondor.apana.org.au>
References: <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZlascqIex2rE2nO_@gondor.apana.org.au> <Zn4Gc+jxtfLZ+cD1@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <Zn4Gc+jxtfLZ+cD1@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.10-p4
X-PR-Tracked-Commit-Id: a5d8922ab2aec39336ebc78d7cefe3b84647b058
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5bbd9b249880dba032bffa002dd9cd12cd5af09c
Message-Id: <171953651387.31542.2046745370772004601.pr-tracker-bot@kernel.org>
Date: Fri, 28 Jun 2024 01:01:53 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 28 Jun 2024 10:40:19 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.10-p4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5bbd9b249880dba032bffa002dd9cd12cd5af09c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
