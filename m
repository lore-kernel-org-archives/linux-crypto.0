Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9288F1B4223;
	Tue, 29 Jul 2025 01:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753751521; cv=none; b=LOs1s19DIbzouhyIkrDwb8W2piUfJbgx1bT1Du6RTbxdZBRz145fVtBGEI5xjUf3k5ADhuKn4ON+yFCVEHWqnG/UJXR6vat6Upa2u7m/EiL0+f2JzCjf3bZy+irDFmLTcqokOmPY4TKf7VvL49A1rWRrpnBvjYrexW650y+Qqw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753751521; c=relaxed/simple;
	bh=MV3FeMY7IzFgFqoFzdX8voHTVrG3ON53fzn6MCanA44=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PFNvugq2jw9OrgOJVx4ow2HxL0AQpetNr54q/HU7g/Vfn/pMKzEv5+1WRt5EqJiHVLx5sj2juO/CF/ViPetTVWV/nwFIq9elvnTgqDhskCPdr6c3lVaPqA2LJwPRAnTH/h2Ak14DpX7FQO03R1AHMIY7oNlqxZJY6APmbhmkoTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dqPs3JIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dqPs3JIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75819C4CEF8;
	Tue, 29 Jul 2025 01:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753751521;
	bh=MV3FeMY7IzFgFqoFzdX8voHTVrG3ON53fzn6MCanA44=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dqPs3JIGn4I/vqUaAhkWh6MA436W7uOHFuaFAYbWZ3otJVCUs6171CDb8CrH0Xbpj
	 PDqc22yY6u3icYqpPpChWFaGxA+fsWodmFdnPZCxZPA+NdiYA2lXiRXhkM+ZmUq94j
	 ndNJ60wuhRL9P213iZBWPs5kY4y7uNHWLFZHDRxhhJmpN9QwZ/1BTw+d+peJBZZLng
	 Q5Qj9v+DXH95NGmZA+7xBN0k4fF0iPO0MCqAsF8MBZygbvbONPpWHgidc/uE+CZ+ot
	 +v0P4lWoOrqVAM1zBg/Dqhx7JGqOQqWHb/LWs8u/KZoUIHdGoppbF1FO/QIBmL0lWs
	 ooX83igHF/16Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33B51383BF5F;
	Tue, 29 Jul 2025 01:12:19 +0000 (UTC)
Subject: Re: [GIT PULL] Crypto library updates for 6.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250727234345.GB1261@sol>
References: <20250727234345.GB1261@sol>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250727234345.GB1261@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-updates-for-linus
X-PR-Tracked-Commit-Id: debc1e5a431779c027a5752f247a4de2e4f702b2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 13150742b09e720fdf021de14cd2b98b37415a89
Message-Id: <175375153764.918485.7824425342434213534.pr-tracker-bot@kernel.org>
Date: Tue, 29 Jul 2025 01:12:17 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Palmer Dabbelt <palmer@dabbelt.com>, Sohil Mehta <sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 27 Jul 2025 16:43:45 -0700:

> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-updates-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/13150742b09e720fdf021de14cd2b98b37415a89

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
