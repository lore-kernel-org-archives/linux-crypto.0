Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADFC38D402;
	Tue, 23 Jun 2026 17:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782236743; cv=none; b=sPWiLE80ZJAKx3pJeFOd5UKlfZXjOxjkc3uVY0xnVqpNlUTTBH9Vsme5CGkyPzd4cIOF6sl1iPcfUmD3Sv55u04KX57PPWvniLxPbVhHS9/F9o/L2AgXgI+s8fcoQU1WHOXJ7FiPEljgzVWGSLFDlyCt8/24knvCMg91QuY1OME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782236743; c=relaxed/simple;
	bh=3F9JITuCL3Q6WQ6xO8GFZEPkn54o5MhYIkDteUmsJQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXgJA250LwXiLWLDrfBk/INuj5keUNlawOkRL0rR1VNyb7IzWjjOZw+moSUoGW0RqTtNF48/Lht+ZeLHC6q9aL+4BZMaxX6IFY0fQUDNRBgYkfQD863HZ5cytzV87agGomOu0Px8+MoecGPZiaxmznyz++6gdB/NSYgpE5YZE34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KZb6fF0r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KZb6fF0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8631F000E9;
	Tue, 23 Jun 2026 17:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782236742;
	bh=Z+KZ7eLxT5XKrkOXLovvKv/03+JktkzJGUFB56VR1HU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KZb6fF0rRvPTq0y+NX7mUS2XZkwqXbOXxp5+J+3YS1qDcDb8BilWCDG2+zBOz1SMV
	 mbMl/oiDXG1zuZlQzVwpwdTiEFdmFCSyUoXgu+xNV4dAYf7GR47W1UP4et+BYNN0G3
	 LvWO+F52Fbrxz6Qp405L7NSQXe738vxss7zru9Q6f29Zz9eAw2CQyKo2iXOLY6bE5Q
	 Od8M+lZCB6/o9AKwUoFrpuIhaGLmbvhH8nuZqMJsGjlYW5OfYBet3qhk5ls4g6u4np
	 sMwbFOYD5QCjmPLcQ2DZysn+uLEr/VWYx+oXg77XJZ+Hzm/FqjfzKyz5xZGriOf00N
	 OMt64tfFkuw2A==
Date: Tue, 23 Jun 2026 17:45:39 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev,
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
	Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
Message-ID: <20260623174539.GA1850517@google.com>
References: <20260622234803.6982-1-ebiggers@kernel.org>
 <CABBYNZ+QLvkYkn_EcBZ4+GopyhKqJLcfCoABYcw1VamavbSvhg@mail.gmail.com>
 <20260623165208.GB1793@sol>
 <01b73988-b35c-4ce8-8463-4589fe18b0b0@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01b73988-b35c-4ce8-8463-4589fe18b0b0@gmail.com>

On Tue, Jun 23, 2026 at 01:29:20PM -0400, Demi Marie Obenour wrote:
> On 6/23/26 12:52, Eric Biggers wrote:
> > On Tue, Jun 23, 2026 at 11:04:14AM -0400, Luiz Augusto von Dentz wrote:
> >>> +===  ==================================================================
> >>> +0    AF_ALG is unrestricted.
> >>> +
> >>> +1    AF_ALG is supported with a limited list of algorithms. The list
> >>> +     is designed for compatibility with known users such as iwd and
> >>> +     bluez that haven't yet been fixed to use userspace crypto code.
> >>
> >> Is the expectation that we go shopping for userspace crypto here?
> > 
> > Yes, same as what 99% of userspace already does.  Probably you'll just
> > want to link to OpenSSL, but it could be something else if you want.
> 
> Hard disagree on OpenSSL.  It's not a good library.
> 
> See <https://cryptography.io/en/latest/statements/state-of-openssl/>.
> 
> Distributions should ship AWS-LC and either rebuild reverse
> dependencies when needed, or work with upstream to catch ABI breaks.

I don't like OpenSSL either, but it's the de facto standard on most
distros.  While perhaps distros should make that switch, there's no need
to wait for that to move away from AF_ALG.

- Eric
