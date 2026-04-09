Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC678BE9;
	Thu,  9 Apr 2026 17:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775756902; cv=none; b=CXH8jD0jx9zgGoPLGtq0W57u7FyjZp6XZk5R0Krl2LzgwvZb4Bnja7JotGSnyiUkjYuicXAvOtLyWmwPbKmJJYFWg7gb1Qy8jP7w7TshwoXRB6C5MZAbFEVsgEOXEgoaBf/L5eOZow4K/DKXL0/r70FO16O1nkQg0/jYfjbXqkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775756902; c=relaxed/simple;
	bh=8q59SIFWEVq34cuARhd0ZskiMzGrBpaXP8qFu9ARl/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kiuOGmH/csGoaD2rWb72pi6BJXOID9V6MyHPRv866tw5UEX606/KrPr+mSgd3tpiheXmwNB04jZyQDWfEXzFqZA9irnIm4K6LwMdmQ8OgkJAoex4WlN7o5JeipIiiQYoG5airV3Y6GTOQ4/1a7pq3hRAWASOnGAt7zoFKZWYJSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rl61ENT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rl61ENT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58966C4CEF7;
	Thu,  9 Apr 2026 17:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775756902;
	bh=8q59SIFWEVq34cuARhd0ZskiMzGrBpaXP8qFu9ARl/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rl61ENT6PT27kifDfWND/EIh19RZuYNyCuiQJt5tMoYIInZ2qQ7vqw82Xe+1oWqzu
	 qPoJpj/ZPEvGp0yu79kp3xUO5Ep63sgyWnGbRu9FD0/yFtQx5OuS8QJ3xRReO6FLPp
	 ZGjBpXxdAdTwUUCwixhPs+XR+JFt4yI91scY456ruIV+3nn+wnghPjsejF5C9K58N5
	 oP+8Ybkos3Q3/Nwjs9+Zfl2BInPWz3nVIbxy4gYv6R9mtiW/xzxzsbtiLpCPbinFr9
	 C4XycfrkVAtFP4++knG9XMoXSesRWWNpi4OHgu//u1FxikR/gVwA5cT6zldAUbYxY2
	 zfZKs3PYp+0bQ==
Date: Thu, 9 Apr 2026 17:48:20 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>
Subject: Re: [PATCH 1/3] crypto: s390 - Remove des and des3_ede code
Message-ID: <20260409174820.GA535565@google.com>
References: <20260326201246.57544-1-ebiggers@kernel.org>
 <20260326201246.57544-2-ebiggers@kernel.org>
 <09684f23-8937-4fed-b88a-361c9ccef04c@linux.ibm.com>
 <d5fb24534a56017e622ef15272eb2f0cfc6d6de6.camel@physik.fu-berlin.de>
 <e1767c51-0bfc-45fa-896e-ac2de0268828@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1767c51-0bfc-45fa-896e-ac2de0268828@linux.ibm.com>

On Thu, Apr 09, 2026 at 10:22:11AM +0200, Holger Dengler wrote:
> Hi Adrian,
> 
> On 09/04/2026 09:29, John Paul Adrian Glaubitz wrote:
> > On Thu, 2026-04-09 at 09:08 +0200, Holger Dengler wrote:
> >> On 26/03/2026 21:12, Eric Biggers wrote:
> >>> Since DES and Triple DES are obsolete, there is very little point in
> >>> maintining architecture-optimized code for them.  Remove it.
> >>>
> >>> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> >>
> >> Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
> > 
> > Wouldn't it actually make sense to keep the old crypto code so we get
> > additional coverage for QEMU's emulation of crypto instructions?
> 
> For qemu test coverage on s390, I would prefer the libica [1] test cases,
> which covers mostly all functions codes of the CPACF instructions.
> 
> If you want to use the kernel code for testing in addition, you may stay with
> a kernel version before the code removal.
> 
> [1] https://github.com/opencryptoki/libica

Yes, the kernel is not a test suite for QEMU.  QEMU tests belong in the
QEMU repository itself or in other projects.  We don't keep code around
in the kernel purely to exercise functionality in QEMU.

- Eric
