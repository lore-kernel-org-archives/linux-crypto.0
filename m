Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AB63876A5;
	Thu, 26 Feb 2026 07:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772090250; cv=none; b=SvDYYM88Xg0lnVAF/2u8Hmefi6fBol55YJNUBtYg2JFUgq1WmnNtwt6/yypBo70K/cZqZSWS13LulCngdEQzU3pfUdRgAex/j0QzZW/ZaBheNeP6TUvV7I1kD1IlTuRA3RbV3NRIUEebqk2gA5CFkOcaRj4sGEyV6jfHTle2GLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772090250; c=relaxed/simple;
	bh=hAuYZQIr9N/o7uDEdBaSaPZ0TbhyTQANp3RRYiMFIp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Laf7qcnX8x+LQcOSS1GQX1i9pZKpwiRlVdbaZlNQv45XTnycioOemmJtUPs0+Gs6i/HjAlMzm82JZxmmIAkrtbhbD7th4qhxmiUoqnWkN8SGFWGV2aFGmfWwwCbCa1QAEudJOuuIFnPXGgNcPo3p0RyGrTyEE0WfSTCbIwZFgdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id EA29A20201A0;
	Thu, 26 Feb 2026 08:17:18 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id E49DB25ED1; Thu, 26 Feb 2026 08:17:18 +0100 (CET)
Date: Thu, 26 Feb 2026 08:17:18 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
Cc: "ebiggers@google.com" <ebiggers@google.com>,
	"horia.geanta@nxp.com" <horia.geanta@nxp.com>,
	"pankaj.gupta@nxp.com" <pankaj.gupta@nxp.com>,
	"gaurav.jain@nxp.com" <gaurav.jain@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"ignat@cloudflare.com" <ignat@cloudflare.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] crypto: caam - RSA encrypt doesn't always complete new
 data in out_buf
Message-ID: <aZ_zfnKVnTaG_4bk@wunner.de>
References: <6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com>
 <aZ296wd7fLE6X3-U@wunner.de>
 <e1d7ad1106dbb259f7c61bdd1910ac9f08012725.camel@ginzinger.com>
 <aZ3Uqaec79TUrP2I@wunner.de>
 <e36dd6fa756015ec1f2a16002fabfa941c33d367.camel@ginzinger.com>
 <aZ6vF1CHpcp5d5qk@wunner.de>
 <5f9c1e7ec61065a2665a2ec70338e05e551435d4.camel@ginzinger.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f9c1e7ec61065a2665a2ec70338e05e551435d4.camel@ginzinger.com>

On Wed, Feb 25, 2026 at 08:47:07AM +0000, Kepplinger-Novakovic Martin wrote:
> Am Mittwoch, dem 25.02.2026 um 09:13 +0100 schrieb Lukas Wunner:
> > On Wed, Feb 25, 2026 at 08:02:08AM +0000, Kepplinger-Novakovic Martin wrote:
> > > ok I can confirm: "git checkout 2f1f34c1bf7b^" indeed is ok and
> > > 2f1f34c1bf7b is bad.
> > > 
> > > It's not the same behaviour I described (from v6.18/v6.19. that could be
> > > a combination of bugs) because on 2f1f34c1bf7b regdb cert verify succeeds,
> > > only dm-verity fails
> > 
> > Hm, I assume CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API=n magically
> > makes the issue go away?
> 
> correct. where I see that specific issue (on 2f1f34c1bf7b and v6.7)
> "caam_jr 2142000.jr: 40000013: DECO: desc idx 0: Header Error.
> Invalid length or parity, or certain other problems."
> it then goes away.
> 
> on v6.18 CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API=n doesn't seem to help
> and I see the bugreport's behaviour.

I note that for the RSA verification, since 8552cb04e083 the same buffer
in memory is used for source and destination of RSA encrypt operation
invoked by crypto/rsassa-pkcs1.c.

That's fine for the RSA software implementation in crypto/rsa.c but
I could very well imagine it causes problems with an RSA accelerator,
particularly because rsa_edesc_alloc() in drivers/crypto/caam/caampkc.c
now maps the same buffer with DMA_TO_DEVICE and then DMA_FROM_DEVICE.

On v6.19, 8552cb04e083 seems to revert cleanly.  Could you try that
and see if it helps?  Be sure to set CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API=n
and CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API=y so that we focus on the RSA
issue for now.  We can look at the ahash one afterwards.

Thanks,

Lukas
