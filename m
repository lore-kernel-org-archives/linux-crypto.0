Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8B2D51A;
	Mon, 13 May 2024 22:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715639902; cv=none; b=I98oSEWVCJAok1Na00vVjVghYsdcxYRrYbzClBGz1IJGFjWmGTKhkSQ2z57eJ18dj2OhUEfqdrUDqxlBwZW0f7XpRUdKLPEURVF0U6b3x2152IKz+HcFx/TdA2PAOvcYcPYBTdciM2mpmpWcPVshYP7GE6rY2xliAbbwg6T+51E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715639902; c=relaxed/simple;
	bh=6DkAFClS2Q1GXsiqXyDYj614/N1JxpW+Hir5QUpH7BM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PApq7fDuiRTalSewVJNITOnA47VN2Bk+76H9dmoQ2CY5aBajvYK8VW8D71vI/hNb4XAGq9FS2RTUxodpFMGj79ThbSW5UmMOo2A5yr6xod2xjaECnYIHDVfUadWoAN8MaRzVlhSovu+x0Dv5yXIH7ztQCfYmmu7gN4+FK4jIbOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOrW61QH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOrW61QH"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F13AC113CC;
	Mon, 13 May 2024 22:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715639902;
	bh=6DkAFClS2Q1GXsiqXyDYj614/N1JxpW+Hir5QUpH7BM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YOrW61QHCwu/altnJvtbslvrlhnDSYTeL7XnkrU4mu+s86Ar60lW/jiawmwGAstDq
	 eM/ESUM6Os2L/z5g85YmOAwDM6FqUetAl7OaRXnhPu8pjkl4MdEuh7uCxQljhXMYSp
	 KJs3xAjPD6Xt4r0w0INfM+tzv6s++PPS+fuLqF+M+nFiarXg54BQng8f0ZJPQzGGGj
	 5WbcMEF1ZQlkcB/Be4sLiR4djeGmuqkLC+HqxFUobysSQBb5OFRzW8trx5PB2YP1iT
	 OHJ/VTTkEeR4j2nIBAcH/NFbRGSMDs74IlnL6DtszceVu9lcuwhTjd+ZvASz0fPnID
	 GdQJtAnE6C9KA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44499C433F2;
	Mon, 13 May 2024 22:38:22 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Update for 6.10
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
References: <Yui+kNeY+Qg4fKVl@gondor.apana.org.au>
 <Yzv0wXi4Uu2WND37@gondor.apana.org.au>
 <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au> <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.10-p1
X-PR-Tracked-Commit-Id: 13909a0c88972c5ef5d13f44d1a8bf065a31bdf4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 84c7d76b5ab6a52e1b3d8101b9f910c128dca396
Message-Id: <171563990227.20499.13690225369013101385.pr-tracker-bot@kernel.org>
Date: Mon, 13 May 2024 22:38:22 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 13 May 2024 11:50:03 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.10-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/84c7d76b5ab6a52e1b3d8101b9f910c128dca396

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
