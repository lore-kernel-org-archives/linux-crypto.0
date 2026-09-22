Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F661576EA6;
	Tue, 22 Sep 2026 17:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790097118; cv=none; b=P7v2va/Km7PO9p4INVn7kOL3bjaKW0qx3u5GXxFyIyIB4JbwKu2I59OV7DqNRpTv29WIBQrNubVvkVOzKHdh+BcYjqaL7VyqC7jzsy0tR2Bhqgr7CyMcpEvUyLa3M7ify1pO2pqmK8BYT4b0BsyMm2ZeEcB2iohtVuKClvM5Ml8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790097118; c=relaxed/simple;
	bh=7INDWyjEMmxZW9FWQ316TyCUBuVNL+via4izX58jB6U=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=WMjLsVrqti8LXND92DeGKNTye5jc1H7y4Lmdr/p8iKooOuuqRNHX5hMsmYtpB0nxsehqeSzzVP95ulNkJLhLeH+7P301oSICIuumxDs0BBy9ULtaqaSqaw24Q/3BFMIFGFCCN4QPshfAiPHjfZ7eembHT1caodBJBRGvkbyoRpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHBplQx8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHBplQx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984761F000FF;
	Tue, 22 Sep 2026 17:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790097116;
	bh=1huyjfiU38xti4OiGjfx6dHrq79pQIxSdjQzi0eMhfs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=QHBplQx8dGEgRpCbnzq/ZBUYiu9E5qGu284oHqxuRpaSlIpszC8n3JpPnAgDxu3kg
	 yE7oEx4kqiO+gOLlvF1wjgy5cgFLJkqStwmqdLlGDF3lFAhTbde3J3V+gxfVGlN9Kg
	 4zbaiYPw7guyGhKYyo5KEMSwJrowlitKElLoTvTtrLha4AVuPpk4198T/oKv/PqGeN
	 EVgyaF8JPjWtLzRdQDrULFfAmZsayhnLFdn7KdT4JlbpiW39NEhd39jzRcUUCmKcSU
	 jkzIUeE5HrX0aeIi0cJA11M1CbgeHnFc0mDciXbSQxouFoTI5zuR2cb067OQeaXalh
	 iHD9kaEldfSIQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0CAA3811A56;
	Tue, 22 Sep 2026 17:10:48 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <arHy-64aKoBskSIp@gondor.apana.org.au>
References: <aq0LWN4cVftl8r5p@gondor.apana.org.au> <arHy-64aKoBskSIp@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <arHy-64aKoBskSIp@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p5
X-PR-Tracked-Commit-Id: 10396a2d6d41d594975b6ece712278570c3c970c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c4e9f74da4389a6b3e505d329d99232915a6b9cd
Message-Id: <179009704737.4190423.13938946515680742436.pr-tracker-bot@kernel.org>
Date: Tue, 22 Sep 2026 17:10:47 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 22 Sep 2026 13:16:11 +1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c4e9f74da4389a6b3e505d329d99232915a6b9cd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
