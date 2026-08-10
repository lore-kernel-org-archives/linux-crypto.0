Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F549337BA4;
	Mon, 10 Aug 2026 16:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786380046; cv=none; b=U1t0IJ1YRxDl1++3AP7xOv677yT/keSlAjBBuu0M73/jUnqJWD60hlcT6Dr3azo2ArMF0qwaLROP1Vwbyxi0E4bFQVbKxaXv7F2jp4Gh0FyvEjl5b4MiJDJFRLGUhMpnkQPFb73YqTMj8GMQ0fcnQWFsGN7WzwoqNK9hsYl1+E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786380046; c=relaxed/simple;
	bh=tnHT2Y0FL2RpQBIiymB6PoSFEFvNyO0B04wLaZByMPw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=M5QFc34sLAJ0KzL+XPX1AGTTRUlkOze3pfPsPt4P4x8Ye0Z13HEHJ7XhIKRQe5W1nIZ5NrdMpyrU2GYY2vCMsKB92B4Ll9m5+qHCVIU/LioKnU3ZMk4xxYA1DPh6GVRqoKIiLNVdKntfO7rx1D/QNiK1EMF9E6putMOGU8M84QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dll4YPbU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dll4YPbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA53E1F000E9;
	Mon, 10 Aug 2026 16:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786380044;
	bh=EA4GBKNzs+FRSJHtyYU0nJKVM+bIvgzF3iCbm/z60gM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Dll4YPbUSvl4rsKQKW7Ojp9WBzWVYih6/sMCmyHDLgdfBf8vjkP4GnCJ8Loks3Sli
	 Ly7RVpsL7umPQXHdHKPmsa9Xp5ovqur+BphM5444+RuHvcy2L+n6CBDhCrxQnQ6a2d
	 91WXJdKTeYVcY3V2olu0rGnqjVBJA06of+yvtYy/9olHZ9vDXSC/bZSzBwmNH0Use+
	 5/SfBjPBg31cLSp4ASxcynOKZ/Q3/CJc4iP928hY15SiEDx17c4dkW8WQ7MmmkrQXk
	 3ZXgYPPJUlqfuBURa1ArXpw0gW3zA4KLzKMdHGWN6kGjcepUD2RBN8zXz9dFQAUo0H
	 Ifnvmi9MBbj6Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0D1D39253F1;
	Mon, 10 Aug 2026 16:40:02 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <anl3S6pbchyEAvzF@gondor.apana.org.au>
References: <anl3S6pbchyEAvzF@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <anl3S6pbchyEAvzF@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.2-p3
X-PR-Tracked-Commit-Id: 285d8204638cf8be0dc304dc40f0290ada701340
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5eabf07a0bf317723da229376b4e910f12b4644b
Message-Id: <178638000148.3867291.2696451407640071418.pr-tracker-bot@kernel.org>
Date: Mon, 10 Aug 2026 16:40:01 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 10 Aug 2026 17:01:31 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.2-p3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5eabf07a0bf317723da229376b4e910f12b4644b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
