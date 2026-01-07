Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DE91A0712;
	Wed,  7 Jan 2026 20:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767818102; cv=none; b=CQMKqrKV6qEBP2e3CT6c/uFzp0qWO7v+oEmNJnL+cg0GKWtCCL7No/8wRZZokzjTzspeMpe5nm1C85Pid3GY5NEN4fsGppbWLdORC0clFNXEcnJXwQJvCAiM3A9byK3jwTHZj1TzkpFWomwQg3B4A+5bLGOXM0MttOfFYdjZypo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767818102; c=relaxed/simple;
	bh=vKhxxji3EawjSoSR0eYv3ESIoEzWRCnC8y7NrYlJoHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bWqC7vSrhze90BmNMMtIOvZKYC/xRz427bzeIY2hfpWxEDW8o+Vo66LIQkY8Z2td5dOIOL9MJ5HMAyk4Y/43WP++cPJUc3mFZDEBov8jUFNnC/r70nllw4ExdOzD5yTlu9a/i/jsTv5l4UvfOZyxbfRbJFNs9tgAK8qn7Xc6hyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DrImanlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DrImanlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE70C4CEF1;
	Wed,  7 Jan 2026 20:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767818101;
	bh=vKhxxji3EawjSoSR0eYv3ESIoEzWRCnC8y7NrYlJoHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DrImanlqQNEn8WqBqIPDAFwBghL1vkzPQ/Yb/fhl9jwCjpo9Bg2qJ2Kq56c0SOIJx
	 XEq9YTZ4bNnlJ32sMsDOJyCAA415rqCFHPJ7Dq2SsLw42f/fMNCOIFsQbOa7OX1FO9
	 cAXQtLJFygLKYp7EN85FvAo1cTsL5Ecvw0H3zHsLl5Yrwztkyk39kw0qOFSu/VrFZR
	 MMPySeQMcrSYFQxLrUZAnxci5iKikOA5vfK8QjUZRpKaDP3xX2C8Q6OVKsFJOL6dBa
	 vhyLQoEaQyvNP5SsYFkgsjtLwS9Zzx7yYNwFMHF4ryuQvbweSoz0KM95lJYISZHhOv
	 9TjiuqgHfQufQ==
Date: Wed, 7 Jan 2026 12:34:58 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 15/36] lib/crypto: s390/aes: Migrate optimized code into
 library
Message-ID: <20260107203458.GA2200@quark>
References: <20260105051311.1607207-1-ebiggers@kernel.org>
 <20260105051311.1607207-16-ebiggers@kernel.org>
 <167cbd49-e0ba-4b1d-a724-e64ab6ee863c@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167cbd49-e0ba-4b1d-a724-e64ab6ee863c@linux.ibm.com>

On Wed, Jan 07, 2026 at 08:41:02AM +0100, Holger Dengler wrote:
> Hi Eric,
> 
> first of all: happy New Year! ANd thanks for the series.
> 
> On 05/01/2026 06:12, Eric Biggers wrote:
> > Implement aes_preparekey_arch(), aes_encrypt_arch(), and 
> > aes_decrypt_arch() using the CPACF AES instructions.
> 
> I'm not sure, it it makes sense to implement this on s390 at all. The CPACF
> instructions cover full modes of operations and are  to process more
> than one cipher-block-size (*). For single-block operations, the performance
> might be worth than using the generic functions. I will look into it and do
> some performance tests. If there is a possibility to plug-in to the level
> where the modes of operation are implemented, it would make much more sense
> for s390.
> 
> (*) Yes, it's a bit uncommon, but the CPACF instructions on s390 can process
> multiple block with a single instruction call! They are so called long running
> instructions.

I'm happy to drop the CPACF single-block AES code if it's not
worthwhile.  I included it only because arch/s390/crypto/ already has
such code.  Since I'm making it so that the crypto_cipher API simply
wraps the library API, if this code is not brought into the library it
will effectively be dropped.  You had pushed back the last time I
proposed dropping one of the s390 optimizations, even a fairly minor one
(https://lore.kernel.org/linux-crypto/51fc91b6-3a6e-44f7-ae93-aef0bcb48964@linux.ibm.com/).

But I have no way to test or benchmark the s390 code myself.  If the
CPACF single-block AES en/decryption code isn't worthwhile, there's no
reason to keep it, so I'll remove it.

As for AES modes, later patchsets are going to introduce
architecture-optimized AES modes into the library, and the traditional
crypto API for those modes will similarly be reimplemented on top of it.
This patchset just focuses on the existing library API for key expansion
and single block en/decryption as a first step.  (As with the
traditional API, single block en/decryption is needed as a fallback to
handle any modes that don't have a standalone implementation.)

- Eric
