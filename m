Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819B87DA8C
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 14:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723733794; cv=none; b=cxGRfGN1pA2YNfCa6NN9N6udlGq+rikc1bqkd8BuG1wWRgUqh0mDxEBEjAiOJya9K28/dlHAgy2pd5I7YiiiLryuRkECKIg2CF+Vcu27u7vj5tXtMcr8iXJcsWcgtkjnxfnBH/sKmgbXXERmWePS24NQ1QJF7rGMFfxMGDw+aec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723733794; c=relaxed/simple;
	bh=HFzanJOpl5F52CO5VR8Cesg5UumRYPth8xClCT8F51s=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=pLJCq/6MczbcxgwKThCocBx580tb0F9L+dJ2KsTMR/qrkmTZQB+JEAS8VMTnJzckmpunWwlNRSfVRju+g2zT6spFB56BidSisVzeGcgwU5Dmmehm+V9Fpk02akakb68F5+vjxNeSzeUpXIfcf86t5ppj2BQyF8yzLjjjM7/d+nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=bhz72+3W; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="bhz72+3W"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1723733790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPiHSTzZPAgxEjydbNzXnV7Jf9y++4iGJgPQDSG9dKg=;
	b=bhz72+3WW4nt2n8JfWWv0nMQLwqbSlEIKMu9yIKz8lifpbcfiTUi9h/w9Cra8WXLI7nU6y
	LznoueKtV0+XE5gXRmGzYOZqUY4kHrHVNybmbQFI1zFC1rtFM1yJheqW3Y8bqy5SOq1Wr9
	Ai3eYc367knWW6FofqUVHb4+/ik3W3K0xyr++Xj8kDrM6ALTzJVjyuYrzqqK5toO2X2YzA
	WILaLwQbP0Sr9YxQAqMda8jVMVHYut9vIowntRMmrKyaYSRqvmROyVF8jtKU5B5ohHg0DX
	JJQ37D2feZ90qFufuKBMgFlzVfOThltiYpljXJsKvg7BbZrMftuArK1DTITfSg==
Content-Type: multipart/signed;
 boundary=26d7175694655f4f9655d8acedb850606612fa2a0f560f3ffb02ca0cbc90;
 micalg=pgp-sha256; protocol="application/pgp-signature"
Date: Thu, 15 Aug 2024 16:56:27 +0200
Message-Id: <D3GKMPVC05GY.USJUY99OPVO3@cknow.org>
Cc: "Tom Lendacky" <thomas.lendacky@amd.com>, "John Allen"
 <john.allen@amd.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David S.
 Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Diederik de Haas" <didi.debian@cknow.org>
Subject: Re: [BUG] Non working HWRNG on AMD Ryzen 5 5500GT
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Diederik de Haas" <didi.debian@cknow.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <D3GJCRNY4KDK.3SPJB5WP8Z7DK@cknow.org>
 <Zr4PJYISc_h7cQdW@zx2c4.com>
In-Reply-To: <Zr4PJYISc_h7cQdW@zx2c4.com>
X-Migadu-Flow: FLOW_OUT

--26d7175694655f4f9655d8acedb850606612fa2a0f560f3ffb02ca0cbc90
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Aug 15, 2024 at 4:22 PM CEST, Jason A. Donenfeld wrote:
> On Thu, Aug 15, 2024 at 03:56:26PM +0200, Diederik de Haas wrote:
> > Found an article [1] which could be relevant and downloaded and ran the
> > accompanying test program (written by Jason Donenfeld):
> > # ./amd-rdrand-bug
> > Your RDRAND() does not have the AMD bug.
> > # ./test-rdrand
> > RDRAND() = 0x47c993c0
> > RDRAND() = 0xec7c697d
> > ... (more seemingly random numbers)
> > RDRAND() = 0xba858101
>
> RDRAND isn't the same as CCP.

Ok. I don't know/understand enough to make that distinction.

> > # dmesg | grep ccp
> > [    5.399853] ccp 0000:07:00.2: ccp: unable to access the device: you might
> > be running a broken BIOS.
> > [    5.401031] ccp 0000:07:00.2: tee enabled
> > [    5.401113] ccp 0000:07:00.2: psp enabled
>
> Looks like the kernel reports CCP as broken. As the above RDRAND test
> doesn't indicate anything about CCP, I don't see rationale for that
> determination to be wrong.

It could indeed be correct and that my BIOS is indeed broken.

> Actual test code is in drivers/crypto/ccp/ccp-dev-v5.c:
>
>         /* Find available queues */
>         qmr = ioread32(ccp->io_regs + Q_MASK_REG);
>         /*
>          * Check for a access to the registers.  If this read returns
>          * 0xffffffff, it's likely that the system is running a broken
>          * BIOS which disallows access to the device. Stop here and fail
>          * the initialization (but not the load, as the PSP could get
>          * properly initialized).
>          */
>         if (qmr == 0xffffffff) {
>             dev_notice(dev, "ccp: unable to access the device: you might be running a broken BIOS.\n");
>             return 1;
>         }

Yeah, I did find that and that's how I got to the recipient list.
In the linked article the author did receive all 0xffffffff, while I
didn't and that's why I wondered if there *could* be an issue there.
But as I don't understand this enough, I asked the experts.

Cheers,
  Diederik

--26d7175694655f4f9655d8acedb850606612fa2a0f560f3ffb02ca0cbc90
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZr4XHgAKCRDXblvOeH7b
bpYvAQDibbsu1Kc1CkXZs5mu+KJL4KFb1gwRgegr4fSg7K4LOAD8CExFrSq4Ex+k
cnMuFwu54ltVK9fnQNRkHq1umrVX1QY=
=7xNQ
-----END PGP SIGNATURE-----

--26d7175694655f4f9655d8acedb850606612fa2a0f560f3ffb02ca0cbc90--
