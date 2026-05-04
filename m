Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69053377010;
	Mon,  4 May 2026 09:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777886684; cv=none; b=R4qTH7OwZN/seduh3Zj5FT57xcV/2p+XhCzds7Z+wsSfb2fvPdYoQfu8gKtFRcm1/FMYu8nBhQFFCyXyLdlPlRbdwIb9DTReV+4dSo4bv6QJCh+w7EAWoF5/tk0T1JbtEHFx52FxfWEc2m2EM4F/JewtZ+XstOy2ip8DSSZKwbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777886684; c=relaxed/simple;
	bh=oq/Aj/4H7yLe6Phx9EOvJMamkeCmsNoJFNmchyWlaJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dzFfSlcwSruM8Ss1JF49ATrZk3RhTwJ3O4UEjL3jpunMAO8LHyTZVgseiszc8q5fQFPMscGF4hAHNlb1DPwYrH73smrlvZCBlcxMFlnwYE4SYojY6jkNQlQcYpQZV/9lqXWTssO2cqeK1fx+2UPH3OZKaIHIvUy0XVBUvqCR2zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r3ZC5Yzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r3ZC5Yzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99F1C2BCB8;
	Mon,  4 May 2026 09:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777886684;
	bh=oq/Aj/4H7yLe6Phx9EOvJMamkeCmsNoJFNmchyWlaJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r3ZC5YzzgxTPHiT0sv4LtTlGaMe/W2TRyPHoZNR8YuJ/n5KsXqpqt6A1NrLesCvyk
	 V2wmUGkblTEJJWdk+9iv3aOAGZr4cESZn3hqtWOiTC5KRjIaEVLa4QMzEQyNRLs9zK
	 AVnS5DKV8VYdXN+YiSb9KLQ1F5/5Srp77Yu3SIYc9rj+6L37jgg/1jdCYzFe5E6J3y
	 /ibzrN+WApKFP2yTFoolfu4PlTcEfPyV+0+gOiRosn1ZEhns9I4cByQ+Ue0JlaW7Wl
	 p8sMSD2O1chYdR2r2/axHerHFo1D9nvG18z9GAEcTVnsLF6R6gkU5l7ExY7BhAASe/
	 QHRfpzAoaRr/Q==
Date: Mon, 4 May 2026 02:24:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	Taeyang Lee <0wn@theori.io>, Brian Pak <bpak@theori.io>,
	Juno Im <juno@theori.io>, Jungwon Lim <setuid0@theori.io>,
	Tim Becker <tjbecker@theori.io>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Feng Ning <feng@innora.ai>, stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: af_alg - Remove zero-copy support from AF_ALG
Message-ID: <20260504092442.GA2486@quark>
References: <20260504070724.GC112568@sol>
 <20260504071025.180058-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504071025.180058-1-ebiggers@kernel.org>

On Mon, May 04, 2026 at 12:10:25AM -0700, Eric Biggers wrote:
> Thus, the risks of the zero-copy support in AF_ALG vastly outweigh its
> benefits.  Just remove it.

I realized that the "hash" algorithm type still does zero-copy even
after this patch.  I.e. this patch affects only "skcipher" and "aead".
Those are the more important ones, but we should do "hash" too.

The diff is still fine, but I'll adjust the patch description to clarify
the scope, and send a separate patch to handle "hash".

- Eric
