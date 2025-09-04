Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D74F28489F;
	Thu,  4 Sep 2025 20:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757018253; cv=none; b=VZfy3kYpJ1SmBMsuUiN1C9r0p07kkE3WZOI7xezz0CotM4H95fIGCkRmWFw0BsQFOsndCKLRCnq9I4TIAIOwiEnC8atTHXUAsx3zHpvYTuferwOsOEiEVtQNbY43u7J27WWYKDxSkV1/I1ysUGzR5nk8QORdsZO96y61cv4K2ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757018253; c=relaxed/simple;
	bh=B7M1DB+EDgvhINKfl+akXwFUQjn0LD/CdoV3yFctHQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i98XMxcpYEWe+OZVhRZdoprt/FiYaEOrVcdAmQfnO8XvEfwr/5X/H/SSaPZjm8ojxbPvoQF2CqUwGygkcD9IRHkMB3A43QkVa2aU5EmYfFgflzrgQJu8R7zAHtkxexh1vkOB8Iw56+mdxk/ZkWqG7xQadeXfvuCjbbdSP4TIt1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mh/6vKc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mh/6vKc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F84DC4CEF0;
	Thu,  4 Sep 2025 20:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757018253;
	bh=B7M1DB+EDgvhINKfl+akXwFUQjn0LD/CdoV3yFctHQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mh/6vKc8XVyUGesQ7aP9+uV9t/JWafDZ1TSypYuml7aUam74x3JuKgQDYD8csh3D5
	 gBgRnJDcQicombK5EAbBXuJrB5tZVwsff3w340+pWnetsBFcD16zkEBElrUVcdjf/J
	 OkX+Td7qeMjhaSCgczSbyh/DoAFsk32A2CUhgZ1DcAxrTID1oYxfZa/0vk4FxktWZo
	 7iAKLvoEHWjBSpIzua23CjXwOByHyGcKr5tjOkCWEgk6AJS+TCaEZjdUwvLD5e6d2G
	 NGEHHS5Gm38WhdxqqLVw5AwPCIxkq6zBjqjoW3znoeRNGb1i2FqIfv6dTOMdoKKrZG
	 5ukhhOk4d+G5w==
Date: Thu, 4 Sep 2025 20:37:30 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vegard Nossum <vegard.nossum@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
	Vladis Dronov <vdronov@redhat.com>,
	Stephan Mueller <smueller@chronox.de>,
	Sami Tolvanen <samitolvanen@google.com>,
	linux-modules@vger.kernel.org,
	Vijaykumar Hegde <vijaykumar.hegde@oracle.com>,
	Sriharsha Yadagudde <sriharsha.devdas@oracle.com>,
	Sumit Garg <sumit.garg@linaro.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH RFC 006/104] KEYS: trusted: eat -ENOENT from the crypto
 API
Message-ID: <20250904203730.GC854551@google.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
 <20250904155216.460962-7-vegard.nossum@oracle.com>
 <CAHk-=wizcBV_yos1SZW9Zty7960TCeEE1t2qE_Wmm8CMoim60Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wizcBV_yos1SZW9Zty7960TCeEE1t2qE_Wmm8CMoim60Q@mail.gmail.com>

On Thu, Sep 04, 2025 at 01:22:32PM -0700, Linus Torvalds wrote:
> On Thu, 4 Sept 2025 at 13:05, Vegard Nossum <vegard.nossum@oracle.com> wrote:
> >
> > However, since commit 9d50a25eeb05c ("crypto: testmgr - desupport SHA-1
> > for FIPS 140") when booting with fips=1, the SHA-1 algorithm (or anything
> > that uses it, like HMAC-SHA-1) will be unavailable.
> >
> > security/keys/trusted-keys/trusted_tpm1.c is hard-coded to use SHA-1 and
> > will fail with -ENOENT when attempting to initialize the hash instance
> > using the crypto API _if_ the hardware is available. This in turn causes
> > the entire trusted.ko to fail to load.
> 
> Oh Christ.
> 
> Can we please just make that trusted_tpm1.c code use the sha1 library
> code directly instead of going through the crypto layer to get it?
> That would presumably neatly avoid the whole issue.
> 
> Eric - I haven't looked at how painful it is to just do conversions
> like that - I assume it's a boilerplate thing and trivial to do if
> you've one one. Please?

I already got to this one:
https://lore.kernel.org/r/20250809171941.5497-3-ebiggers@kernel.org/

And yes, as usual it's much simpler:

     2 files changed, 36 insertions(+), 190 deletions(-)

(And faster too, since the library APIs have much less overhead.)

Jarkko is taking it for 6.18, I believe.

- Eric
