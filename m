Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3928A176FA3
	for <linux-crypto@vger.kernel.org>; Tue, 30 Apr 2024 16:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714494553; cv=none; b=hN7H4DGIkJuyxOkVeShb4P/stz9wXn3q6TO3IWQvWSqosUXnrT7mRMFjWGleUF0LpPyTngRhkb7GJ/umGL1kYjkz5uGzRXUIVEz5Qo+BrTeBci/VPccKE7D3jWzHlQcbZq2NMolhbqzK+ejZ1uWq4pJ3w5R/r0WYzExiMoC0ADs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714494553; c=relaxed/simple;
	bh=kkvw51P6Za/qRoyOm34SqO6Jg6cob+X5xRe+y/3jnK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gcOkeQ3r0A1SOG/cQ6sWvdzq9lyCWcwIgQOVYvDcdtZ55uawqU5c0FWz3cMMz2RXe8rExSo8rRo9pSokgX/+leDotqlDdWZ32phQoYRppa7EgbHWH+bXH+FXbhPErc5DGj5bIxFK3//BEhURnNpzZinNX3r+J3+4r/TPA5T6Wns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=XPpR772T; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="XPpR772T"
Received: from cwcc.thunk.org (pool-108-26-156-33.bstnma.fios.verizon.net [108.26.156.33])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 43UGQXgJ020744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 12:26:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1714494396; bh=goM805EIaf7WdDPZb5HYoEDPI6lMIJGS/qiTjPMlJ4k=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=XPpR772TTYa+XubwFcYgQTJGqPnocH8jOsOUU6PbJtTFCeafVZVTs3c5HsWPB/WVV
	 t9aeDlLLf6eS6D5fG9jABT9OhATloQkxO2W4BaEJWNSg6Nsk8w4uctAslsQDRHFbNW
	 ad6HFsLXwIhoqeQXsPW7+q2CNuFZVdCSxZApkcqeMQqjfQoSE/npXoHmCnfdBudlsu
	 IU6D4XWXFki+ynyqxEyUZ8axvsEo9L8prRWKzUj4kxH0m9qhPwd0Q64SczYfX9QdWD
	 kNAiiaVNoTqDjyYBNFlrN4IT6sZJo6F7fSe4GFTMN8ktK80aoNKZzdT5jmSNSgyr0h
	 JpAzC+tMmP86w==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id E1EA515C02D7; Tue, 30 Apr 2024 12:26:32 -0400 (EDT)
Date: Tue, 30 Apr 2024 12:26:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Aaron Toponce <aaron.toponce@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] random: add chacha8_block and swtich the rng to it
Message-ID: <20240430162632.GA1924352@mit.edu>
References: <20240429134942.2873253-1-aaron.toponce@gmail.com>
 <20240430031105.GA10165@sol.localdomain>
 <ZjB2ZjkebZyC7FZp@hercules>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjB2ZjkebZyC7FZp@hercules>

On Mon, Apr 29, 2024 at 10:41:10PM -0600, Aaron Toponce wrote:
> > Note also that currently the Linux RNG is using a portable C
> > implementation of ChaCha20.  If there is actually a desire to
> > accelerate large reads (which again, aren't the main use case of
> > the Linux RNG), it would be possible to use a SIMD implementation
> > of ChaCha20, which already exists in the kernel.  That would speed
> > up ChaCha20 by roughly 2-5x depending on the CPU.
> 
> If ChaCha8 makes us uncomfortable, even though defensible, ChaCha12
> is a good compromise. As you mentioned, Google implemented ChaCha12
> in Adiantum. It offers a 1.67x speedup over ChaCha20 while still
> providing 5 additional rounds of security over the best known
> attack.

I'm not sure I see the point of trying to accelerate the Linux RNG.
Sure, doing "dd if=/dev/urandom" is *fun*, but what's the real world
use case where this actually matters?  The kernel RNG is meant for key
generation, where a much larger safety margin is a good thing, and
where absolute performance is generally not a big deal.

After all, with key generation generally you are also performing some
kind of assymetric key crypto as part of the IKE or TLS setup, and the
time to generate the session key is in the noise.  And if you are
trying to wipe a disk, using something like shred(1) is really the
right tool.

Ultimately this boils down to a risk/benefit tradeoff.  I judge the
risk that you are a shill sent by a nation-state security agency ala
Jia Tan of xz infamy, trying to weaken Linux's RNG to be very low; but
what's the benefit?  If the risk is low, but the benefit is also low,
maybe it's not worth it?

Cheers,

					- Ted
