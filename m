Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D443148DC;
	Wed, 18 Mar 2026 17:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773853216; cv=none; b=t9qh/jySTMKN0B62qa6SIMklCbmGNL91CtEydMaWJJCDF3GzUyfRvWpwIM4+5nFXHQXLm1SMglWvrrthpW2FZNwR6isEzsbBN8GeEmGQAqzseKGJTg1tYbCKT54J/N74QTivIDjwipetkFA+iC44T8DYN8u6TnQCWZ7QKg+jWWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773853216; c=relaxed/simple;
	bh=y8olGlc+sOjBfqKzfVVoVP5Q6FZ1IMqZq09Ik9ifcZk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=SxWUkWndVAdENBJJ4OWnNmD9h0EI+ITMfMSHPdnhrOEtXCpUZL7O+qy1kPUl4AezUUUvcPbzDtiZWbZ6COd/GaBPyd7v0pkwWLzGRLQzTnHTo+IxPnrf/S54/uq3+Cn636qN/n8LBSyoSAeiNXh/Rq1AP4JzFYNTU6BoAKeCQ4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=noOFnhNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="noOFnhNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCF0C19421;
	Wed, 18 Mar 2026 17:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773853216;
	bh=y8olGlc+sOjBfqKzfVVoVP5Q6FZ1IMqZq09Ik9ifcZk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=noOFnhNH9AO/qy8Kj6EFoKPBQ9qHY9E644QbdHmN/J6/cuodllDPEEMuhEp4IBJ59
	 M42QIcNAXwxDKS3aot1GNYvVj91urY/aPlpfsIpcilvOUzi2+GKuiXTmd8pDJgOIc7
	 HMue62JfHb8TpgsKZgTmUFn1M0SOLwcR92VPRsjyladXrtR+3E+RrfOaOOJLi3O0T4
	 MhVYRhM+LiO6fEjhZHQ3ExiVpolAFEK0kEXWoZ1qchGEmQ0IxH6EhHjPUObl4NDIxx
	 q9IJ2vQp88czK6s/GAOQfO7Hx59OpZlbfv0yvW3wvsdclOFdXRtTuUxRLeCxKQFaOI
	 vhd21PLQjd8xQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FDB63808200;
	Wed, 18 Mar 2026 17:00:09 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto Fixes for 7.0
From: pr-tracker-bot@kernel.org
In-Reply-To: <abpZRauhYoKH-f54@gondor.apana.org.au>
References: <aapDn5mYeL861_6n@gondor.apana.org.au> <abpZRauhYoKH-f54@gondor.apana.org.au>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <abpZRauhYoKH-f54@gondor.apana.org.au>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.0-p3
X-PR-Tracked-Commit-Id: 5c52607c43c397b79a9852ce33fc61de58c3645c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c5cb126c48e728aaf7f2ac209ef5506e47c2ad6a
Message-Id: <177385320774.796867.6437767467225205919.pr-tracker-bot@kernel.org>
Date: Wed, 18 Mar 2026 17:00:07 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 18 Mar 2026 16:50:29 +0900:

> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.0-p3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c5cb126c48e728aaf7f2ac209ef5506e47c2ad6a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
