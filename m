Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBA821A421;
	Mon, 17 Feb 2025 17:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739814034; cv=none; b=gL4KI6eUclRn/g9+M9k87/I2g9tur3lrVPQ30zd+7ikED2Qpj8vKeID9T3TtiTM/ZAryaQ4YH6FM4TFQehMaw3do1KNwv53feZ1JWz26doNc+kerPkMAYKfILrTACucHkXQuSaVRblpBcA8Y+IAofylUWEwAwEdazgMvxfd25LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739814034; c=relaxed/simple;
	bh=Dy/0GI1ft/U44yuy4Q2Na9V/ddLvYKKyiIq0KGW5S+c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f82uCrWp5lFK0a9jz/UaUyuRRQ9PbrtW43dUNq15WlX/dHShmdAwnM76CzxMrb+mPdCIlkX2y9w+KaLaVePqq1HcKCVRhIdr3FE9zPiWxI4bCoWGI9UehgVlNihEEp4fxUmAKnd4meavwQ4S3ocnSm7BuP2vxYARaZcyLM+p7Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WNhfr3gv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WNhfr3gv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ECAC4CED1;
	Mon, 17 Feb 2025 17:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739814033;
	bh=Dy/0GI1ft/U44yuy4Q2Na9V/ddLvYKKyiIq0KGW5S+c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WNhfr3gvbgG7kEediEzqfjJ61dCny56DanKCmNYmeojo/ibXqv4tJuMGMZ+0jGf0J
	 wIhL0GJ+DU21zwz6EzFpJmP9FuZosVt4FztCzQ4rdkupYgOuCc6rXFrIcxyn6RYf49
	 i+kWLBaZYC2gEc5toYkq/WxuDabqk2BGBotwlrn7MTMX3JwV3pSoYhPF0xDuNQR9jy
	 0S1NHGCu3f6hB2wm9kg7OQZ7Wm68Ix6eQ97fFfwtB4O/zCqcmAKWHLo5iZ2NNDQagc
	 55814Y2qdrlL0XnmVoIWz0+cdSuQXmAznp1zvJAolcTdxfUYCatEYdwBBPcmn+jh4q
	 P75nMbAfJef3w==
Date: Mon, 17 Feb 2025 09:40:32 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, fsverity@lists.linux.dev,
 linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Ard
 Biesheuvel <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Linus
 Torvalds <torvalds@linux-foundation.org>, Mikulas Patocka
 <mpatocka@redhat.com>, David Howells <dhowells@redhat.com>,
 netdev@vger.kernel.org
Subject: Re: [PATCH v8 0/7] Optimize dm-verity and fsverity using
 multibuffer hashing
Message-ID: <20250217094032.3cbe64c7@kernel.org>
In-Reply-To: <Z7FM9rhEA7n476EJ@gondor.apana.org.au>
References: <20250212154718.44255-1-ebiggers@kernel.org>
	<Z61yZjslWKmDGE_t@gondor.apana.org.au>
	<20250213063304.GA11664@sol.localdomain>
	<20250215090412.46937c11@kernel.org>
	<Z7FM9rhEA7n476EJ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 16 Feb 2025 10:27:02 +0800 Herbert Xu wrote:
> On Sat, Feb 15, 2025 at 09:04:12AM -0800, Jakub Kicinski wrote:
> > Can confirm, FWIW. I don't know as much about IPsec, but for TLS
> > lightweight SW-only crypto would be ideal.  
> 
> Please note that while CPU-only crypto is the best for networking,
> it actually operates in asynchronous mode on x86.  This is because
> RX occurs in softirq context, which may not be able to use SIMD on
> x86.

Yes, that's true for tunnels and for IPsec.
TLS does crypto in sendmsg/recvmsg, process context.
