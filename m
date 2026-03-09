Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293CC318BA4;
	Mon,  9 Mar 2026 23:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773099010; cv=none; b=hz/aD6/eHvSAvIVG9cc47SzpHk4QyXgDOx44YMy6IcbqCHWN3juU1J5u9YIrLM4UAya5Zyd5rSIqSKTUJRZ2LUhIyD2xfAryZEUH0IHzpnhUrXTh65IVHODcBNRy83Hwmx0+p5XgTNPqr+TIJRrs9mbt3wNepQK8lSdFp27Xdas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773099010; c=relaxed/simple;
	bh=Ww59W5W2ElNkG5x82sGjndbjOzflSRwY6APjAUV8K04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWVSrWq9Bl9QUJZB/x4PwAUqmNW0EIs2o4q5a/GXkF1F7GfNK465/356Zu4kBMxtbinMH22laLMmQRU4gW+FpXVRERBLecLqfMPzC9T8Zb52ROZBzrfajNZbnXYJZ2dmEVkhUUBMZOT3TqoOFl3rAhdsAiext+ZAvQ2q7XhT/UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=it6snpZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="it6snpZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DE0C4CEF7;
	Mon,  9 Mar 2026 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773099009;
	bh=Ww59W5W2ElNkG5x82sGjndbjOzflSRwY6APjAUV8K04=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=it6snpZy/ri5ODlERgYmKLW+Lu0LjjuKTZPX8O8jl63GPJSiE/l1MhvxAV3EbsPkp
	 4bQIYl6HGg/cNeABh9bI8IUqmBzjgGW4kUE9WwB1M6A78mrrwo4chunZFrnbrnOqc0
	 iVL6XGGSMKyNezo3M6ZLl9a2Qsy9f2d7rZDHr9eLfdrRtZGNkPzWcYymLWM3MiGs0T
	 sDBiVcJPuuRr/iaRf/lB2LDCAdJhwjzu4Iwhz9FSBn6eirOm18YN/W54m3B9k5wAHd
	 AvXSXo3KENisCkUMiqnk31hXaGQ6YasPSuN2Rs601GYe9MjB8LmQdt5kAkdk2losQe
	 2ZJqDk0xW9+lg==
Date: Mon, 9 Mar 2026 23:30:07 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/8] Reimplement TCP-AO using crypto library
Message-ID: <20260309233007.GA270909@google.com>
References: <20260307224341.5644-1-ebiggers@kernel.org>
 <CAJwJo6YhhK63tMQnMoN=9gsYcO4UCXovhK9S4GOdo8bw9B-49w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJwJo6YhhK63tMQnMoN=9gsYcO4UCXovhK9S4GOdo8bw9B-49w@mail.gmail.com>

On Mon, Mar 09, 2026 at 10:33:32PM +0000, Dmitry Safonov wrote:
> I like the numbers that you achieved here and tcp_sigpool riddance.
> If you want to measure the throughput difference, there are iperf
> hacks I made at the time of upstreaming TCP-AO:
> https://github.com/0x7f454c46/iperf/tree/tcp-md5-ao
> 
> We certainly have to support AES-128-CMAC, HMAC-SHA1 and HMAC-SHA2.
> For the last one, we specifically had an RFE from a customer.
> 
> It's a little pity to go from ">> Additional algorithms, beyond those
> mandated for TCP-AO, MAY be supported." back to "The
> mandatory-to-implement MAC algorithms for use with TCP-AO are
> described in a separate RFC [RFC5926]." as I've always enjoyed Linux
> (and opensource in general) that provides more flexibility than just
> strict mandatory required options
> 
> I.e.:
> "Of course, TCP-AO key contains a shared secret key. It is specified
> by the option secret as a text string or as a sequence of hexadecimal
> digit pairs (bytestring).
> Used cryptographic algorithm can be specified for each key with the
> option algorithm. Possible values are: hmac md5, hmac sha1, hmac
> sha224, hmac sha256, hmac sha384, hmac sha512, and cmac aes128.
> Default value is hmac sha1." [1][2]
> 
> I guess that may cause a regression for an existing config.
> So, I don't know, could we get your big speedup and yet let the user
> choose what algorithm they want to use? Basically, making
> tcp_ao_hash_skb() a callback with optional algorithms implementation
> and a faster mandatory algorithms that will use
> hmac_sha1_init_usingrawkey(), hmac_sha256_init_usingrawkey(),
> aes_cmac_preparekey()?
> 
> [1] https://bird.nic.cz/doc/bird-3.2.0.html
> [2] https://github.com/CZ-NIC/bird/blob/0ee9f93bd076c5cc425ceaec9acedbbb7c9021ec/sysdep/linux/sysio.h#L246

This series already preserves the nonstandard but reasonable HMAC-SHA256
support as a Linux extension.  And users retain a choice of algorithms.
Maybe think of it as helping them make that choice by dropping things
that we know (but the user may not know) should not be chosen.

I mean, even CRC-32 was an option for the MAC.  Really?  That's
something that should be a CVE, not a "feature that demonstrates the
flexibility of open source software".

Offering all four variants of HMAC-SHA2 is also almost entirely
pointless here, given that TCP-AO MACs are limited to 20 bytes by the
TCP options space anyway.

If there are specific additional algorithm(s) that are actually needed
for backwards compatibility, then we can add them to the list of
algorithms that the new implementation supports.  However, do you
actually know of any user using anything other than HMAC-SHA1,
HMAC-SHA256, or AES-128-CMAC?  If so, what is their use case?

But let's not keep the crypto_ahash based implementation of TCP-AO
around as well, as there's a massive amount of complexity and
inefficiency in it.  I think this series makes that very clear.

- Eric
