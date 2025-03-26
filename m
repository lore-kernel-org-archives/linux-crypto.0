Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5021487E1;
	Wed, 26 Mar 2025 02:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742954690; cv=none; b=C8NnaWJe2/8zvPkuQnToXpxPAg0QTSHDZE+ck1bQF2yUycOCRI8j91WLlyby/suMDnPM6D0lpAfc6YlmZoFqMg8zyFC8YDbK8UYyQeQtYw23o3sy3/f9QEeqszuIN7RSKUmcHlPFkpk6jcsuRTBFssNgfODwSPYpHj7U4JNifwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742954690; c=relaxed/simple;
	bh=EvC093YO6Vl20sHLh3XTqh/N84zVNcc11k0pLZiOPkc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CfKAqfLcErer8I27PjxepCImZgtBAOqkQ7yM18Ub19/TauCxRgFI/Pg0YOh4WF7Ba6FI6UWRHHNXFYtIoROULi0141yvLaVeMEWY36qEUiWRLoPCWyh1ftO4OD2lSyD1yhDfaHejToyGYeYcofsfk+vsgZrSQvC5BSXwK9Ip0y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tI1Q9Dro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tI1Q9Dro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA68C4CEED;
	Wed, 26 Mar 2025 02:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742954689;
	bh=EvC093YO6Vl20sHLh3XTqh/N84zVNcc11k0pLZiOPkc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tI1Q9Drogq70o6tVvsmX5SZgcEWkFLV4V9Wm1fk6XA5SUJ7GX0y/MbDo6+NBYzwKL
	 Wjc1PkQy4JiaEkP54O8IzwuEaZT8zYq66+xquFqCeKyDL+YQTByg/XUPuVeJ7l8tTW
	 0Lx9SeruqDaUaFAGhUaF/32YwAU8AYgWqqyaFqjNH5NwjdHKk0k4l8ArbNtWWnvEwe
	 6a4VVG2w7WPASac8511qeirEecNxDu16ks9s2Y+fTv+edXdWM1fGdjPXZPasjcxFSA
	 EOUVFIk8n1NmWE5CW0dbZf0LN/S4SlqQzvEtEVSukYkASgeAHZe/yyJ4oiJ4BN1roh
	 xUvWSfUAIbAyw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 716B0380DBFD;
	Wed, 26 Mar 2025 02:05:27 +0000 (UTC)
Subject: Re: [GIT PULL] CRC updates for 6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250323222415.GC9584@sol.localdomain>
References: <20250323222415.GC9584@sol.localdomain>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250323222415.GC9584@sol.localdomain>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus
X-PR-Tracked-Commit-Id: acf9f8da5e19fc1cbf26f2ecb749369e13e7cd85
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ee6740fd34eb53c5c76be01201c15310f461b69f
Message-Id: <174295472606.808498.5170254847116979850.pr-tracker-bot@kernel.org>
Date: Wed, 26 Mar 2025 02:05:26 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, x86@kernel.org, linux-crypto@vger.kernel.org, Alexandre Ghiti <alexghiti@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>, Keith Busch <kbusch@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uros Bizjak <ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 23 Mar 2025 15:24:15 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ee6740fd34eb53c5c76be01201c15310f461b69f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
