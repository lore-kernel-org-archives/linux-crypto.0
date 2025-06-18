Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E292F49FF;
	Wed, 18 Jun 2025 17:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750269530; cv=none; b=C6AOZuryhu4PZL0SIkkejokboEd06WC/EBx7PNfMBj1F+awniAExYty2uJ7pEShxP0WXIfQLvXrCr6Fq5xFq3Irv8qvEtBpe57socRf8Vg3xI8bLvPIWYWZT5xEUlFFwED2306mKAOCiEnIvgqh4fq4ks6tO6cRJ2fR+Nh6ZHbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750269530; c=relaxed/simple;
	bh=q0gLPh+y3dH8uSy02iDzfWcYQRSrlkjlxD7Uzniavnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sVqgIFFy/KvvcIEjjiDQyv7M9QFke0LzAGR1Ei9pxkuhGCfYWFOO5TMNOSCUhfhvRH1x3jluLmKRuwsfTgkU1c2KJ72HjZIqIkKGFzGyCPAaOFzwTjHp/k+Jq+Lm82bmGY8htSOMjL1/9mYuoFufUz6taYA1MWnCqV4cjtV0XSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NfzobozG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NfzobozG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746F9C4CEEF;
	Wed, 18 Jun 2025 17:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750269530;
	bh=q0gLPh+y3dH8uSy02iDzfWcYQRSrlkjlxD7Uzniavnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NfzobozGQMAz6c6YrsXHwvssnz85iTEJMYewSq6QNZJkRHRPdrlPjFkMBhTOvRVhg
	 wTzRqpjb2bg9WeGU89yPIPUP970k0LcffU3jxn2CLS1VE9SQWrg+Ro6cBKyvNq30wp
	 aKj8QpXj4BknTNRz2vuV/T8zjW9Sg0MG7FuMqr3JKRSA/sTNyd8aAofX1FWYxydL9j
	 B/xOw8tMGIi5YGd2hG2ChGEr1oFkFc6xwNTFP66AEjQlFzpzHj64ynFCVzYqE738+v
	 JTRLxUUqhJC4+G84BprM/wEipWqfJdOa8M8Uw1HcmMgoL1iJE1B5wZrwrufEG0+Sfe
	 fphJD5gVYyJvA==
Date: Wed, 18 Jun 2025 17:58:47 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>
Subject: Re: [PATCH v5 0/2] Add support for Texas Instruments DTHE V2 crypto
 accelerator
Message-ID: <20250618175847.GA1639822@google.com>
References: <20250603124217.957116-1-t-pratham@ti.com>
 <20250617042755.GG8289@sol>
 <87ikktgx57.fsf@kamlesh.mail-host-address-is-not-set>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ikktgx57.fsf@kamlesh.mail-host-address-is-not-set>

On Wed, Jun 18, 2025 at 04:00:12PM +0530, Kamlesh Gurudasani wrote:
> Eric Biggers <ebiggers@kernel.org> writes:
> 
> > On Tue, Jun 03, 2025 at 06:07:27PM +0530, T Pratham wrote:
> >> This series adds support for TI DTHE V2 crypto accelerator. DTHE V2 is a
> >> new crypto accelerator which contains multiple crypto IPs [1].
> >> This series implements support for ECB and CBC modes of AES for the AES
> >> Engine of the DTHE, using skcipher APIs of the kernel.
> >> 
> >> Tested with:
> >> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> >> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> >> 
> >> and tcrypt,
> >> sudo modprobe tcrypt mode=500 sec=1
> >> 
> >> Signed-off-by: T Pratham <t-pratham@ti.com>
> >> ---
> >> [1]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
> >> Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf
> >
> > Numbers, please.  What is the specific, real use case in Linux where this
> > patchset actually improves performance?  Going off the CPU and back again just
> > to en/decrypt some data is hugely expensive.
> >
> We don't really care about the speed here. These crypto accelerators are
> from embedded system. Often less than 4 cores and this particular SOC
> have variant with only one core.
> 
> ARMv8 is clocking at 1.4ghz and DTHEv2 at 400Mhz, so no way it can give
> better performance number in term of speed. But crypto acclerators are
> designed specifically for lower power consumption as well. ARMv8 crypto
> extensions leverage SIMD registers, but dedicated crypto accelerator are
> still more efficient. Think about battery operated low cost devices. 
> 
> These embedded devices are often in the open and vicinity of attacker.
> Crypto accelerator are much more secure.[1]
> 
> Bottomline:
> 1. Crypto accelerators can deliver a higher cryptography performance.
> 2. Crypto accelerators can deliver better energy efficiency.
> 3. Cryptography hardware usually has lower timing and power side channel leakage than running
> cryptography algorithms on the processor.
> 
> IPSEC and partition encryption/decryption/authentication use cases are bulk
> operations and often have low setup cost than operation itself. 
> 
> [1] https://www.trustedfirmware.org/docs/Introduction_to_Physical_protection_for_MCU_developers_final.pdf
> 
> Cheers,
> Kamlesh

Okay, so you admit that your "accelerator" is much slower than the CPU.  So (1)
does not apply.

As for (2), it's not clear that applies here.  Sure, your AES engine *by itself*
may be more power-efficient than the AES instructions on the CPU.  However,
using the offload requires all the additional work associated with offloading
the operation from the CPU.  Since it's much slower, it will also cause the
operation to be dragged out over much a longer period of time, keeping the
system awake for longer when it could have gone into suspend earlier.

Thus, using the "accelerator" could actually increase power usage.

As for (3), a couple issues.  First, you're just making an argument from
generalities and are not claiming that it's actually true in this case.  ARMv8
CE instructions are in fact constant time.

Sure, ARMv8 CE is generally not hardened against power analysis attacks.  But
you haven't actually claimed that your crypto engine is either.

Second, these side channels, especially the ones other than timing, just aren't
part of the threat model of most users.

Meanwhile, a security issue we do have is that the hardware drivers tend not to
be tested before the kernel is released, and often are released in a broken
state where they don't even do the en/decryption correctly.  Furthermore,
unprivileged userspace programs may use AF_ALG to exploit buggy drivers.

It seems implausible that this patch is more helpful than harmful.

- Eric
