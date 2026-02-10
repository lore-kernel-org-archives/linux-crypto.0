Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3696138B7CA;
	Tue, 10 Feb 2026 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770747017; cv=none; b=EB0fk+Kui1P8ouEkg3BORjDS4QQw7O4mvPfUgyd4/ETRtZCaXqTjdvetHSjDt5WGjao3FjFhsbaE/vQ8FgoF6VoK9jOdos7ydkuz08KmxWtsumVdlPkNOK/d3xlbnqbsvaYpIF2KGWHQihLx/BFPGuwDUx8D+qr/6xQQ+Hf8tdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770747017; c=relaxed/simple;
	bh=RELt37vdCLW159ej8RC7sNGv/HZTN8baxr5SC2ldelQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=a1qalkVh6rTRl3jrUcqluJ+l3j0iccvtmHE35r1BMt8wcRRfQ9YXuHlHE2B0k9r5NyGKmDw3C62u7ISDCKb3DVWBWaotq7+jik6nUDThC1FhK4PzGrEUqjWbQv6Fl7xCLXQ5KD/sdKKt6GcI7qTcdWdpUy5cmYUqAUbVA2mOl/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNUbrGBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNUbrGBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99B8C19424;
	Tue, 10 Feb 2026 18:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770747017;
	bh=RELt37vdCLW159ej8RC7sNGv/HZTN8baxr5SC2ldelQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lNUbrGBYYK84M45EgqvqchTt+3LvUzf4AzcfMeGON7O5xcTmF2HDIzwqiBWX8MGQv
	 fzp/R4EgW++TJTIhSHGTE/w6bZsQR0Ow/NKWIseDDylQJSedO9C5TtQM5ByIMyjgDe
	 8hRXn88b7sBlUgB3SN4OyBer6JXFe/7utdOCd1sli4fhYCWzA++lZUBp8TzBO61go9
	 jjtsomgjSluFRKUuVP/+gM/q3t8ytN3Am/b2ZEyoBM83ePAp+u8raE3GEooouvauvE
	 R4XEh8COwuRmKe42TkBd/JK7SPCBmnznS7zSFnANVh0Y4qM2E3zbHbmuUWip7s0bmN
	 37d5u8bLVjgkA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7FCB439E3B79;
	Tue, 10 Feb 2026 18:10:13 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library updates for 7.0
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260209034257.GA2604@sol>
References: <20260209034257.GA2604@sol>
X-PR-Tracked-List-Id: <linux-crypto.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260209034257.GA2604@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
X-PR-Tracked-Commit-Id: ffd42b6d0420c4be97cc28fd1bb5f4c29e286e98
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 13d83ea9d81ddcb08b46377dcc9de6e5df1248d1
Message-Id: <177074701242.3619225.7229331659607085210.pr-tracker-bot@kernel.org>
Date: Tue, 10 Feb 2026 18:10:12 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, David Howells <dhowells@redhat.com>, Holger Dengler <dengler@linux.ibm.com>, "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 8 Feb 2026 19:42:57 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/13d83ea9d81ddcb08b46377dcc9de6e5df1248d1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
