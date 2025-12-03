Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF7F26059D;
	Wed,  3 Dec 2025 03:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764731688; cv=none; b=kIYID6VLCeg1BXvGvCfeN+5naocQBG8r3czAmoSjMCYWZS7OzVVoHuF8axcuo/1ayyEsXNGVgN3St+MUYfWkswRFkb9cPmTxnxOKnqtNtoEVWeR1g32HCo4qX3omIaj2l9xd9YnSQ/6M/9TC0Wf0Aq2wpR18Hk2qvhcuUZb5WNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764731688; c=relaxed/simple;
	bh=KbAWFLVFkShjxjkDAGO6cVuyu9KmSLkKg3Vs8S31Yuo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=uaArqiw+pfitC+8yN2huOl4Th3bJSgiqbodryrRa8t3AECtt8TV2KHcelocDil+YVHFBIgHD6765b3NQ+ZJ/ytPChcotRG+MJHR6EdQTAEX/Jq2RWCIvoTglA+z1jwaRNqD/Jhs2jmg1qoD1R6DzxHX9/gDZq48sOLKPT1sf8ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m13Ct0r+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m13Ct0r+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9058FC19422;
	Wed,  3 Dec 2025 03:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764731688;
	bh=KbAWFLVFkShjxjkDAGO6cVuyu9KmSLkKg3Vs8S31Yuo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=m13Ct0r+gAT5luKFlI25IwWYwP0kbLBHrO+ACi0tWPKplUvoD8S9eP4nom3xzrwO6
	 ystW8/VCkB9PEsw61G0afE2WpZVVlkCQfAApf9WAvppq8C716RekhRO1tlkhUF/7gi
	 vZHIM8n2vW1BSn/qQsqilS5lLn7O3AyJWQNOlXWBmyemQba3CPg6LCpQzBlqjqjNZc
	 Tt+cCRVY0rhbQ307Oy7h338736qJPVRoKWYgGk24QiBdW2HihRLoErsisPWKRCPiOf
	 Cp5eid75KWU+zkLysyKrCRiKFKdzsk6tEeapWWB8QzE6iBVIkRfTTNkk5JyBfVjZ4p
	 FhHMH7a/6S26A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F28703A72A63;
	Wed,  3 Dec 2025 03:11:48 +0000 (UTC)
Subject: Re: [GIT PULL] AES-GCM optimizations for 6.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251130024719.GD12664@sol>
References: <20251130024719.GD12664@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251130024719.GD12664@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/aes-gcm-for-linus
X-PR-Tracked-Commit-Id: 0e253e250ed0e46f5ff6962c840157da9dab48cd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8f4c9978de91a9a3b37df1e74d6201acfba6cefd
Message-Id: <176473150746.3498170.15312634954358325028.pr-tracker-bot@kernel.org>
Date: Wed, 03 Dec 2025 03:11:47 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 29 Nov 2025 18:47:19 -0800:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/aes-gcm-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8f4c9978de91a9a3b37df1e74d6201acfba6cefd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
