Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A03785C4A;
	Wed,  7 Jan 2026 04:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767759048; cv=none; b=IzEHmRzCBbSIwMkak+FWv/eXiV2NjIjvJwPMIGyf3kMKgCn8IxyEeFmIhTb1Cj3kHfj79Ge5xAxfFfnKkhkDVuKbMARHQQh5hs9DhNpAB9Q3qO4MsYUTyzs9cVZReJ68EJE5GiiDTGMQk70Bysy1MAr+MVbUiP0mKi+SyoMpyEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767759048; c=relaxed/simple;
	bh=FSlk6vAJoaclX2GgiP//Izyjst+vE/JFjKZg9hmb/ak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bBXQ0wz9piARxye2SiALJpVxTmlKhUWC/oJxvRmsK3yLpxS8dHmTTgS8HMHu7MsDILQVTPSAP8sCLJPJcnJ5dE8/Wqq83YDZP4hNfFw6bNwYI6IbTboOZ/wGXtAxFjG+B9DBQQWWO2Li2TOUhiplcdw8btGHglSQme9VOTDwM2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j6z7HYUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6z7HYUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FF0C4CEF7;
	Wed,  7 Jan 2026 04:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767759048;
	bh=FSlk6vAJoaclX2GgiP//Izyjst+vE/JFjKZg9hmb/ak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j6z7HYUh+6yDb9wrrK7TciUdYle3JuVvbjZhW8PvJ1/b2wQUXsMLcq5fr0OO2RpP2
	 q9sXvtU0jpMVQe7nfSgjhfhn0bUjc9Tjx2gJkUkEBJvmRNAosJitQXcY+QhgrGbTuT
	 Ir9/XiuQ6ffArWwxvUOM6ZxXS6Qtsztsa6wCStQEHWeIblPDkGprwSck3zdmLBkoyb
	 gye695zNGr7Au3bl266SCLbTJ63b4qXhSwceF7ehqmJ8neEeV3zrlO8fKDfG7ooQ5V
	 mUanc2Jw3hWhQ5A6oBnm9Z22skgOGzjfoA0s2P+OIUSsNv8AGhlZa0t2Q+dMuv0qFP
	 p2XoJrgJ1WpyA==
Date: Tue, 6 Jan 2026 20:10:27 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: nh: Restore dependency of arch code on !KMSAN
Message-ID: <20260107041027.GE2283@sol>
References: <20260105053652.1708299-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105053652.1708299-1-ebiggers@kernel.org>

On Sun, Jan 04, 2026 at 09:36:52PM -0800, Eric Biggers wrote:
> Since the architecture-specific implementations of NH initialize memory
> in assembly code, they aren't compatible with KMSAN as-is.
> 
> Fixes: 382de740759a ("lib/crypto: nh: Add NH library")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
