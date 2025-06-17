Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20C115539A;
	Tue, 17 Jun 2025 04:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750134506; cv=none; b=pggJzdX9N0dGp2sPBTmU9L2c3zUgB8vZrlaIFtcWk4bzbSnbW5lWbtogkDK8ydzk8gxH8zZwpdFMm5OAwRIv5POXywbJx/fJgD2QklpsLia83tFink5UsnlYb4SLpoFWN1aOOamPUBQD8HjK4sRIyA4nWJTe6NtErfJR16QRcKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750134506; c=relaxed/simple;
	bh=PnJko5vxDtAYo4xtfL54bpZLAmxUI5zpeQ7QYnXzKvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djyoCCWWTExKIbv80M1rtpjo3DodiWsSKRKkGnilE8dJX0rxBNbP5GunH26wTKtafbsj/ZDE/sGVn2LrqyxNwquOaqp4UVK0MKeQhDU+j1MYw8PupkoSqEJUthSRwqDsXPJU+yJFDTpSc5tgI1pbszqJSTicjJhX9HOIqYxJtPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JT0Zap80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JT0Zap80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85E2C4CEE3;
	Tue, 17 Jun 2025 04:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750134506;
	bh=PnJko5vxDtAYo4xtfL54bpZLAmxUI5zpeQ7QYnXzKvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JT0Zap801QYfqX2dK6+3BKLTq1OF46HXM2SK+yQrcSWC8I0+zNUAnAAgk3oW5qz/j
	 bViQ4PWHNR7sp/btqryPHfVoaJaLBgME5dXhIHLrA94VDiVckwTcRtJbO06HZZt725
	 dH11OlQhV9Gkmc+f21JopULDKqTzdurT1MHX3Ovf0jI/T0VAFNegSarfjXrg+fOzga
	 7QmwpodhbrLN8MkjoeEVEpft84z0LxroJd+JdiXE7PUl8teApAvmMPmHyMAC6mxsh9
	 m4HJsdClJkT8S4S/Pr/gigmN6cn6niFTyWi9dvmj2s3bw717Dms2/jXMNlK4IMUalG
	 hZVoqhPXnyhpg==
Date: Mon, 16 Jun 2025 21:27:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: T Pratham <t-pratham@ti.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>
Subject: Re: [PATCH v5 0/2] Add support for Texas Instruments DTHE V2 crypto
 accelerator
Message-ID: <20250617042755.GG8289@sol>
References: <20250603124217.957116-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250603124217.957116-1-t-pratham@ti.com>

On Tue, Jun 03, 2025 at 06:07:27PM +0530, T Pratham wrote:
> This series adds support for TI DTHE V2 crypto accelerator. DTHE V2 is a
> new crypto accelerator which contains multiple crypto IPs [1].
> This series implements support for ECB and CBC modes of AES for the AES
> Engine of the DTHE, using skcipher APIs of the kernel.
> 
> Tested with:
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> 
> and tcrypt,
> sudo modprobe tcrypt mode=500 sec=1
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
> [1]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
> Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

Numbers, please.  What is the specific, real use case in Linux where this
patchset actually improves performance?  Going off the CPU and back again just
to en/decrypt some data is hugely expensive.

Note that the manual you linked to above explicitly states that the CPU supports
the ARMv8 Cryptography Extensions.  That definitively makes any off-CPU offload
obsolete.  But even without that, these sorts of off-CPU offloads have always
been highly questionable.

I think it's implausible that this patchset could actually be beneficial.

In fact, it might actually be really harmful.  You set your algorithms to
priority 30000, which makes them be prioritized over ARMv8 CE.  I've seen
exactly that bug with other "accelerators", which actually regressed performance
by over 50x compared to simply staying on the CPU.

- Eric
