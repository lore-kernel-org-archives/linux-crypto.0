Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A721D172E;
	Tue, 19 Nov 2024 19:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732043194; cv=none; b=FUkKvhOte6rM84yqL/ooHmlLs56KP1cq3dORoYc5ZS1smuXV+rtXsoX9YTbys5fryuzVxnTl+hxhxa0sip4bltVvEjuGdd2B8jw1vcOStCtjaHoXMoFWTbOYzcOjg2EHPIHuiusdlaD+15A8KhASw0N5lNmgpzscLk5EaTbaW38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732043194; c=relaxed/simple;
	bh=/WJk8y6T672F/qMNSHm5xHVNrf16DGVmOO4aDClQ5LY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=GynNnUZGi5jWTh1acGFN/U6Y4YoXkUf8DZYVQjn7zKh3vuwnvUy4GNR48y+4p8cy19cPPjJc1dNOvK6xZS3ubw7XaVB5VNmr9ZoCKUj8jrekxRuk2XHrrbXRLaJvbFzqv5Ni78VEsqcfQgQ9kjDdzMoiYXUDnCWPuUPKh8fyT94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NiTKfkh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NiTKfkh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD45C4CECF;
	Tue, 19 Nov 2024 19:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732043193;
	bh=/WJk8y6T672F/qMNSHm5xHVNrf16DGVmOO4aDClQ5LY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=NiTKfkh7QHQ9QAKSm0uedfBi/rpgWnGKzgXvHuldWG83+Ub8duv+CiozwyPGDM3K1
	 zn6BdpI76fFhhJhNAaq43FKvMJgpt6v/9v/dN2LII+/weLWN6pzuZ29XXJ1dW0ICdd
	 BHcOms38QbkFZHW+eRYXhYymJW/m8M4gTk4VRf2QL5+QGPO3YtzNJlTUOAhKtQWG5A
	 d/wJyWB4nXRLM9Fw1abKrrFBXTXIdTIrgvlwWuCvqC517Tk3nENwlzONWDnPK4huuP
	 6uCDmwFN59nLk/g61GOt+izqqPiJbcWCf38396o5qLn1OLeODVcInvwEqrBmpEQY10
	 87Ct3dza7Qdig==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADCBF3809A80;
	Tue, 19 Nov 2024 19:06:46 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Update for 6.13
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
References: <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au> <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.13-p1
X-PR-Tracked-Commit-Id: 4223414efeae3a8efb4da1e9c9c52a1a44c1c5bf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 02b2f1a7b8ef340e57cae640a52ec7199b0b887d
Message-Id: <173204320541.653509.12918427866739802295.pr-tracker-bot@kernel.org>
Date: Tue, 19 Nov 2024 19:06:45 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 18 Nov 2024 11:18:25 +0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.13-p1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/02b2f1a7b8ef340e57cae640a52ec7199b0b887d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
