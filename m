Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B20F403EB9
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 18:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792089280; cv=none; b=EJ0VYIdK6NYXjDj2Q3QM9FaSvkhRPpyCEXLEeLl9Zly3ZY93Z1QiO0t8EGQhLnrCpB/TjcCEA3FZPpwgLKsil0zSj0L2IiQrp09Fdt+XeameBgLx1yTJMW1YYLtxXMN3mGUG8YZ7wxuFeUp0hZxMMYyLo9r3I6hf6t5F6ggnO5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792089280; c=relaxed/simple;
	bh=UB1pCZMh6qVYTbAeWkGvQC/iqIDF9nkW13n1A/tlu3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OzKH8lVmyzy0hZXgZf2xXs9MRzgZCgSHu4SHRk/H4XRU64nxrV8P4Xm4ifeEX6zyH3TAlwPeySmYKW0JtpQElqxrOUU6ESOD0fHWWaeiWG7KseM43tPwaXAOvzsqLjEXuqCc3rs/YXsHHW4peXRzGMyqBnDhG5JBcrCoBsdD+2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XrprAwjX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XrprAwjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0D91F000C4;
	Thu, 15 Oct 2026 18:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792089272;
	bh=BlfZuWZi/bWVnDZK9qm5ECa89wrkDMKxDAuc3EiKExk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XrprAwjXTZ2ucr4OfM2t8PlL1NWcHwZaMNKnaaOWkVQS3hbT+IqPOGGZTiJusE3wW
	 ZeI9/eLO15WRWLjsIXkbCqu0uIdmPF/dqxyg0KISMATJlHDZAveJ1SGT5aluoueFaL
	 HSrrlfpvRwPVqxL60fL4O4rNx4NfIKTUuRJNKRXJPE9b8D/6vkc+BtX3mD6auFROeq
	 teb5SnXX4e9hzCoiCZCYQ7CUCpEEe5R+O75zqTt6G6q0HjwACeH8QKb7d3ymaGGi3W
	 QCprBW3q277PpYPXbPIsr//lv7vPIkx15TUEM28Z7aQ79vuUT83eKYyJ2WDaNhLkA5
	 oOzHl0FtX7ANQ==
Date: Thu, 15 Oct 2026 18:34:30 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: aes - Add import_core/export_core to
 cmac/xcbc/cbcmac
Message-ID: <20261015183430.GD2170687@google.com>
References: <asjT87HAZ_UUbbvm@gondor.apana.org.au>
 <CALxtO0=TXw68akF3AFPT0=J4tZ2XV+G5kuTOELGBzhbgBdN0RA@mail.gmail.com>
 <CALxtO0=w3jafDBj1gvoAZxcM8tRM0WRAiv-vc8c4+AjSmnOe8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALxtO0=w3jafDBj1gvoAZxcM8tRM0WRAiv-vc8c4+AjSmnOe8w@mail.gmail.com>

On Thu, Oct 15, 2026 at 11:12:58PM +0530, Pavitrakumar Managutte wrote:
> Hi Herbert,
>    I applied this patch on top of cryptodev-2.6/master and ran the
> crypto self-tests (CONFIG_CRYPTO_SELFTESTS=y,
> CONFIG_CRYPTO_SELFTESTS_FULL=y) with the SPAcc driver. cmac(aes) and
> xcbc(aes) now allocate their software fallback and pass all
> self-tests, with no regressions on the other SPAcc hash/HMAC
> algorithms.
> I will push the SPAcc v26 patches. Please suggest otherwise.
> 
> Tested-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> 
> Warm Regards,
> PK
> Vayavya Labs Pvt. Ltd.

Refer to my feedback at
https://lore.kernel.org/linux-crypto/20261007102457.GA1695@quark/

- Eric
