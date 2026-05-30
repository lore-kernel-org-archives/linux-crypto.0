Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C692628C5CB;
	Sat, 30 May 2026 19:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780168333; cv=none; b=QfO44Vw6ZrPvzt4OlakJHlYGCmaZGPryDsx7nVDiAEZ2Z41eH9u1vbg/scC8ZPtJZLm1gFTwpUIXByC7a2HonRtKfWgEIoHW1KTo3qa1Yjqi8CgIGKCNjqnHxZmParG+WqxbNDh4eViv8Vqi/+5bIiHRkIs+pwBqLbJI1sDmO3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780168333; c=relaxed/simple;
	bh=DJcr0gSSpMZr6xUdirV2SS3XS4yWuzkl58yJTUak94Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RaMth5ymtVXATYF6/VMIGj1uiPEV2mvPBNmHbZKMJri+lv2EMLce5G/pA+86lZYJ6k05CyTZylU7bnddsiBgkbn4vv/9GAFA5c1DSq6nOKFc3I8C+Oz46ILbYYaAGw2yPgj5qLY3af3MNDloRtMmtGynfA/j7putdw/QGFTid+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bOs1jz+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bOs1jz+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BF51F00893;
	Sat, 30 May 2026 19:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780168332;
	bh=wuWV0UDN7XNlhZhb++Cgiht7/YenA/gl8ofUZVO9VMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bOs1jz+oauIQCmArH/fPM8HDOOrAHv/F7bMYh+FHVbJubtmHf+sgKD/tCUW6TEsbE
	 g256mN5wQ8CrEDMqDbFm3vhO/CtWEcENaGGoHDYmArQm1RWWX+mPCxyGX2BubIx9tZ
	 r+RR3/n/qEyxuUkcBhsTBdWLn4rVWGZ/ssSwSB0+X2eFJcaC+y5/m/QBViyZkbfqN+
	 /XonNk8OwW9Yg3ykoNOFeNBkE2Old6QgDvjtPaefzwddrSeOZqxx0tybAxKhLtj160
	 UYMeLhE/juU/JfS1Kg8C2h1ku/qWXuwnN9ckhkB1d2gj+0/8wiHu4702aBTgGhf6ce
	 pEL+SjY785pVw==
Date: Sat, 30 May 2026 12:12:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christian Lamparter <chunkeey@gmail.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: crypto4xx - Remove insecure and unused rng_alg
Message-ID: <20260530191207.GA6807@quark>
References: <20260529220430.34135-1-ebiggers@kernel.org>
 <e0b3cfc2-c6da-46d4-9dec-027dafaba74e@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0b3cfc2-c6da-46d4-9dec-027dafaba74e@gmail.com>

On Sat, May 30, 2026 at 12:20:57PM +0200, Christian Lamparter wrote:
> > diff --git a/drivers/crypto/amcc/crypto4xx_reg_def.h b/drivers/crypto/amcc/crypto4xx_reg_def.h
> > index 1038061224da..73d626308a84 100644
> > --- a/drivers/crypto/amcc/crypto4xx_reg_def.h
> > +++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
> > @@ -88,24 +88,13 @@
> >   #define CRYPTO4XX_DMA_CFG	        	0x000600d4
> >   #define CRYPTO4XX_BYTE_ORDER_CFG 		0x000600d8
> >   #define CRYPTO4XX_ENDIAN_CFG			0x000600d8
> > -#define CRYPTO4XX_PRNG_STAT			0x00070000
> > -#define CRYPTO4XX_PRNG_STAT_BUSY		0x1
> >   #define CRYPTO4XX_PRNG_CTRL			0x00070004
> >   #define CRYPTO4XX_PRNG_SEED_L			0x00070008
> >   #define CRYPTO4XX_PRNG_SEED_H			0x0007000c
> > -
> > -#define CRYPTO4XX_PRNG_RES_0			0x00070020
> > -#define CRYPTO4XX_PRNG_RES_1			0x00070024
> > -#define CRYPTO4XX_PRNG_RES_2			0x00070028
> > -#define CRYPTO4XX_PRNG_RES_3			0x0007002C
> > -
> > -#define CRYPTO4XX_PRNG_LFSR_L			0x00070030
> > -#define CRYPTO4XX_PRNG_LFSR_H			0x00070034
> > -
> 
> Hmm, don't think these defines will hurt anyone? As these are part of the hardware spec.
> Or do you forsee a future where AI-Agents will sent patches hallucinating that it "fixed"
> the issue which readds it? I have no idea.

Well, there's not really any point in keeping these when they aren't
used.

- Eric
