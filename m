Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C03726290;
	Sat,  7 Mar 2026 13:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772890286; cv=none; b=jIGXEMqFMZjU9UaYIASCY/lwNerftyL1ahKxcfxUn34Zl1XM7vDrfxqAO3KxjOohUVr6vXsh6/Zl/1TlNULTjcvc1KRR7BEDMs6HZ5JTXXce51I/YqpzT2iVOQQ6df4rnEsSucPyDp89WHkBBzPCqg7RC/fJtPTlW6Iqbi84s/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772890286; c=relaxed/simple;
	bh=wDdHuvzNSXU/hID5H4bNu26FaFTMUqGvFoTfECzEspM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rU2U9XY9hzMb1iEzRQPizu+luacbhvEWhD9apXOPSETwvnOswbog6GUo1St+uBqvpQ6q63IS8IAqA9D9jsnpRwLqpfDg3LX8U0j79xncBNGzy9OAtx24E85ta6CB5i1KQlmSaeqA5owTetquk2elLl0s48RXeZJ39nYziZfcaFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.78.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by bmailout2.hostsharing.net (Postfix) with ESMTPS id 156FF2020ABD;
	Sat, 07 Mar 2026 14:31:14 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 0E9334F240; Sat,  7 Mar 2026 14:31:14 +0100 (CET)
Date: Sat, 7 Mar 2026 14:31:14 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"horia.geanta@nxp.com" <horia.geanta@nxp.com>,
	"pankaj.gupta@nxp.com" <pankaj.gupta@nxp.com>,
	"gaurav.jain@nxp.com" <gaurav.jain@nxp.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"ignat@cloudflare.com" <ignat@cloudflare.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] crypto: caam - RSA encrypt doesn't always complete new
 data in out_buf
Message-ID: <aawoonmcpvx58hL3@wunner.de>
References: <6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com>
 <aZ296wd7fLE6X3-U@wunner.de>
 <e1d7ad1106dbb259f7c61bdd1910ac9f08012725.camel@ginzinger.com>
 <aZ3Uqaec79TUrP2I@wunner.de>
 <e36dd6fa756015ec1f2a16002fabfa941c33d367.camel@ginzinger.com>
 <aZ6vF1CHpcp5d5qk@wunner.de>
 <5f9c1e7ec61065a2665a2ec70338e05e551435d4.camel@ginzinger.com>
 <aZ_zfnKVnTaG_4bk@wunner.de>
 <aau4hTzIYEVKyAT3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aau4hTzIYEVKyAT3@gondor.apana.org.au>

On Sat, Mar 07, 2026 at 02:32:53PM +0900, Herbert Xu wrote:
> On Thu, Feb 26, 2026 at 08:17:18AM +0100, Lukas Wunner wrote:
> > That's fine for the RSA software implementation in crypto/rsa.c but
> > I could very well imagine it causes problems with an RSA accelerator,
> > particularly because rsa_edesc_alloc() in drivers/crypto/caam/caampkc.c
> > now maps the same buffer with DMA_TO_DEVICE and then DMA_FROM_DEVICE.
> 
> That's definitely not good.  It needs to handle in-place encryption
> by using DMA_BIDIRECTIONAL.  If the hardware is not capable of that
> then an extra copy must be performed by the driver.

Okay.  However in the latest hexdump provided by Martin (on Feb 26),
the data returned from the caam RSA accelerator is byte-swapped.
i.MX6 does seem to be capable of big endian mode, but I guess
peripherals still use little endian and so it would be necessary
to postprocess (i.e. byte-swap) the buffer in caampkc.c if the CPU
is running in big endian mode.

It's unclear to me whether the byte swap issue is the only problem
or whether there's a DMA issue on top.  Martin hasn't responded to
my latest e-mail yet and without someone willing to answer questions
or test patches, I can't help any further here as I don't have such a
device myself.

Thanks,

Lukas
