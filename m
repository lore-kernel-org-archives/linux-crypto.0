Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4022E8880;
	Thu, 21 Aug 2025 03:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755747457; cv=none; b=uWb4Fahq9rzBugA+k3S4DFhYn3R9qDC2uHu1Nkyed6WvZUUPkPoESeDffQAn7QqgvVCDK9tgqJq6KfHMSI9aJVMmtTsKtVoviCi66g6ICq2aT+jhvZ3c3YU/cQ2Zi4hu90voV6Ud4TDj7/Z+hwEcRDGh7EV0qG4GJZ3zv96G0pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755747457; c=relaxed/simple;
	bh=WhaZPUxZf3PPdoM74yYKh8wAuRdvXT5HvvzgKszxlE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XOLY9xjPCu3o5YY+HZSESVkzabfvR1w28iyA1tuxBGEDLHiicMY5AXOyiQURPBBRhw8DAoQojuHRnYdCdWyv+usLvT7nIX3GLYkJeBOuQeX1QSVfaBeOk4SOe9inJcF9dZYsQQPZdAru6mXGTuMbObJLYJIQV0uH+YWsN65JdWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMBeyKnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMBeyKnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A896CC116C6;
	Thu, 21 Aug 2025 03:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755747457;
	bh=WhaZPUxZf3PPdoM74yYKh8wAuRdvXT5HvvzgKszxlE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jMBeyKnKV0r6TzuBAsC5n2RtO5IdWDw0EKTe4GrdlfBAKeP2pQ0r18rIvENHoQUtX
	 WMmzFWRrNGh//VUh9PVFcNJLgcOG3qg/VhIXDjRXGBASCqJD0LWnGsOnfM5n5Eyhzt
	 nAFSSc/o+nUHu3+f1DB13+8NXetPkF8oXf9giVJakqw8b1Llm76qzGqBQMW1RN5qLM
	 0lJNK4PK5EVXHWuKAE1Zny9b9icAZh6LqJQvN92ptIYSgwXIfJTyA1Tjl9vAH5jlY7
	 Dx217opu9ynHezl1DydRnZWbq3c/EWv+fDg6O+f7ol8iZNc4sUEHiP5dFrzd2fEZuR
	 KzsBA5gB1NdxQ==
Date: Wed, 20 Aug 2025 23:37:34 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] lib/crc: Drop inline from all *_mod_init_arch() functions
Message-ID: <20250821033734.GD185832@quark>
References: <20250816020240.431545-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816020240.431545-1-ebiggers@kernel.org>

On Fri, Aug 15, 2025 at 07:02:40PM -0700, Eric Biggers wrote:
> Drop 'inline' from all the *_mod_init_arch() functions so that the
> compiler will warn about any bugs where they are unused due to not being
> wired up properly.  (There are no such bugs currently, so this just
> establishes a more robust convention for the future.  Of course, these
> functions also tend to get inlined anyway, regardless of the keyword.)
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crc/arm/crc-t10dif.h     | 2 +-
>  lib/crc/arm/crc32.h          | 2 +-
>  lib/crc/arm64/crc-t10dif.h   | 2 +-
>  lib/crc/loongarch/crc32.h    | 2 +-
>  lib/crc/mips/crc32.h         | 2 +-
>  lib/crc/powerpc/crc-t10dif.h | 2 +-
>  lib/crc/powerpc/crc32.h      | 2 +-
>  lib/crc/sparc/crc32.h        | 2 +-
>  lib/crc/x86/crc-t10dif.h     | 2 +-
>  lib/crc/x86/crc32.h          | 2 +-
>  lib/crc/x86/crc64.h          | 2 +-
>  11 files changed, 11 insertions(+), 11 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
