Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC0518858E
	for <linux-crypto@vger.kernel.org>; Tue, 29 Oct 2024 04:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730176434; cv=none; b=A2Ux/n78LW0A5cS6jTNeLq3+BBPfZ0VQXRrXK7cn1YKfGEnVkhfjHXJLJFcnpB49xFoNQm6oDNrOS4owypn+cy/ipBum6M44QMC5JuJiTJVp30HHibEtp3gZwMG9jjeA1VlZAaLEcaYI8cu8LSeE628L5J7Rd9nLelRL5zF8mvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730176434; c=relaxed/simple;
	bh=4CtdPk7cmGUaaPCQAJ0MnFzZqIsIkd/eok2Ce380dm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fIsxZ40r3iehGkWPLNbiVgeJsXmFVTicoJgzHhXFVymc6nwkZq93bKQLbs0s4y7iJ12AGFeCHfQyL7zRuxaBNiZrJTDumnuDq8VkW86NWEyl1hFw2+83/71D44MkcTly3oS6iezi9BnlKD2eG5H7o/g1wzDUDezFL6xedwe28H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Xo0drjlI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Xo0drjlI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aKRNdZ99qIWm9zXuWG0blSi1UKWNXtxmNGnFIr8KZ40=; b=Xo0drjlI3X8Dkvz1kZyQIqhwEU
	Y91Pd8t2sSk7pPPg4OTWo2e2hLSC/wAzdSSki+w0mePpFUHvB783p7k8vT4fR3Q2O5VU33sntmEZa
	BSeIYr5wMJ3DNei/bivef8DXKE1mVovMWaBILlTgn2oEe7hjRNTg03T8Y7TByHU3xGoFo+b/xrPRw
	LPm7+0cCzv4n7PlUIhzLRdKx8Zt//yeUfJ/KYcpxr9wQtzNkkfITPx8HA3BFqMz52KRR5TpWNkTfC
	ewocj8RSi79v+Zcmrsc/N5NxpndwohIK5XmCCQoCLCDXlNdFRcRZ4OyX9ClDIDIJFCalJfWmec5An
	N5turzaQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t5dvN-00Cr2m-14;
	Tue, 29 Oct 2024 12:33:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 29 Oct 2024 12:33:45 +0800
Date: Tue, 29 Oct 2024 12:33:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 0/6] Multibuffer hashing take two
Message-ID: <ZyBlqeddZeVgM8_M@gondor.apana.org.au>
References: <cover.1730021644.git.herbert@gondor.apana.org.au>
 <20241028190045.GA1408@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028190045.GA1408@sol.localdomain>

On Mon, Oct 28, 2024 at 12:00:45PM -0700, Eric Biggers wrote:
>
> You say that your API is needed so that users don't need to "spend extra effort
> in order to accumulate and maintain multiple streams of data."  That's
> incorrect, though.  The users, e.g. {dm,fs}-verity, will need to do that anyway
> even with your API.  I think this would have been clear if you had tried to
> update them to use your API.

It's a lot easier once you switch them back to dynamically allocated
requests instead of having them on the stack.  Storing the hash state
on the stack of course limits your ability to aggregate the hash
operations since each one is hundreds-of-bytes long.

We could also introduce SYNC_AHASH_REQ_ON_STACK like we do for
skcipher but I think we should move away from that for the cases
where aggregation makes sense.

Note that when I say switching back to ahash, I'm not talking about
switching back to an asynchronous API.  If you're happy with the
synchronous offerings then you're totally free to use ahash with
synchronous-only implementations, just like skcipher.

> With this patchset I am also seeing random crashes in the x86 sha256 glue code,
> and all multibuffer SHA256 hashes come back as all-zeroes.  Bugs like this were

Guilty as charged.  I haven't tested this at all apart from timing
the speed.

However, adding a proper test is trivial.  We already have the
ahash_requests ready to go so they just have to be chained together
and submitted en-masse.

> If you're really interested in the AVX2 multibuffer SHA256 for some reason, I'd
> be willing to clean up that assembly code and wire it up to the much simpler API
> that I proposed.  Despite the favorable microbenchmark result, this would be of
> limited use, for various reasons that I've explained before.  But it could be
> done if desired, and it would be much simpler than what you have.

No I have zero interest in AVX2.  I simply picked that because
it was already in the kernel git history and I wasn't certain
whether my CPU is recent enough to see much of a benefit from
your SHA-NI code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
