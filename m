Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3486B1862;
	Sat, 25 Jan 2025 00:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737765431; cv=none; b=i6Pnelv0qLevDkz80ImIOr1hw9E/L3+STluIQ8h85mN1BcJeZwi6+BmClz6BHUvBV8cLU9CpWobOV5MBI90z7d5bPKp3ekmERY0O6eMVCunS+vSbvPhKnRnRTVJd7cmzpgRk8p397nObSb52cMha2Ppurg5QSag73Sn9bhtm5ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737765431; c=relaxed/simple;
	bh=/XKNL+ffny1utwqOscX5gmsrc6PnhDUiijxIROEzzr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ywyk5ewnT57nsmC4AX1UlyPxR1Tp6mlNke8Op5oc06zu29UX2EeohO331gYGVS4W6QaeqQz6pZs6yz8Vp+0yrK3OUmqMzMjKjFP/A76ZKTiBt9buv6+hh812ctD1aOxmi8m7+ZxVZzDHre1fX5rntlvXbPJjLn57hoL8l14xmhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgIC0jj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgIC0jj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5CDC4CED2;
	Sat, 25 Jan 2025 00:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737765430;
	bh=/XKNL+ffny1utwqOscX5gmsrc6PnhDUiijxIROEzzr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KgIC0jj8FKHsV6fFs7jCfZXrsPd1jMHfL57xG2svJv1avy1fpucfwmVVgHKx/AOBZ
	 l09LPwak3R1pDEEByyfMWMs/ipGAoe8LI5hPWbfkQWXGRO3TtjmuDgO8Ajg4DV5y/P
	 c5+E1pHrn6d8WYG5tZs5aZd+Wtd7Ag+evJCZ9JzpE/gonYS/BpZFkCtNLr8W2a2a0E
	 3DRK2H+U4d9Vko4fCrpDDyjs0eW8gTz316CPhEziUn5VeaqP3LE0nkP98fcf1k9OJd
	 iDDmVwQtTJydnJgirZQ/ZmhF5hFDyWOTu6LEPqr0/VokCMrZ375128GtA7n1BZmoHK
	 si+dUtte5NjWg==
Date: Sat, 25 Jan 2025 00:37:08 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Chao Yu <chao@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Theodore Ts'o <tytso@mit.edu>,
	Vinicius Peixoto <vpeixoto@lkcamp.dev>,
	WangYuli <wangyuli@uniontech.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] lib/crc: simplify choice of CRC implementations
Message-ID: <20250125003708.GA4039986@google.com>
References: <20250123212904.118683-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250123212904.118683-1-ebiggers@kernel.org>

On Thu, Jan 23, 2025 at 01:29:02PM -0800, Eric Biggers wrote:
> This series simplifies the choice of CRC implementations, as requested
> by Linus at
> https://lore.kernel.org/linux-crypto/CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com/
> 
> Eric Biggers (2):
>   lib/crc: simplify the kconfig options for CRC implementations
>   lib/crc32: remove other generic implementations
> 
>  lib/Kconfig          | 118 +++--------------------
>  lib/crc32.c          | 225 ++-----------------------------------------
>  lib/crc32defs.h      |  59 ------------
>  lib/gen_crc32table.c | 113 ++++++----------------
>  4 files changed, 53 insertions(+), 462 deletions(-)
>  delete mode 100644 lib/crc32defs.h

FYI, I am tentatively planning a pull request next week with this, and this is
now in linux-next (via my crc-next tree).  Reviews / acks appreciated!

- Eric
