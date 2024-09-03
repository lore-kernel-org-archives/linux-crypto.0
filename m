Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9AD18BC22
	for <linux-crypto@vger.kernel.org>; Tue,  3 Sep 2024 17:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725384311; cv=none; b=cjGKKiWGJUYLrkvJRTfN3VqPRX0WJHgjFiLaV7RARJuw7J3aGzUY62ke/+n6QpDDKvjs/NTBZzNmW1wB2iXx9xtef34SVxGNTkM07j6PDLKOn4Vq5zwwrWj9dXMqtDI+TzPsd6IjTVtcQ3+/7ZRWIQ7JtoI/ib0/NV5dGStgGB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725384311; c=relaxed/simple;
	bh=0GQ60j9Kpm6aDkp69Hid+eWu32D7f4A17UAOLn1+/VU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSfwjcE7doKfM5tjFjLhbP+t4b6k6gC4YFFKhrww++we1tSmo5SoiGQl/nAPpMmXy9laDCcjTvXxPBW6D+0nrM3YeKZaTwccZKW26+t4lPkrfEpqTZk+BatKoBNELpGeTY+QJX87+50/J0w7t392YwV/qczueKYSnGFV6a4eacQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=boGfBQne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boGfBQne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5361DC4CEC4;
	Tue,  3 Sep 2024 17:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725384310;
	bh=0GQ60j9Kpm6aDkp69Hid+eWu32D7f4A17UAOLn1+/VU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=boGfBQnegjIhyx5Rv4zOG2nFqQUEcaf3N7sGnQObNGCZdcEppewEGrKeSP76AhOwA
	 NDkBgXM2bYAXkcqW8TKZ4QnjxuUjh17OzA94qgHLJZlVrP5mtyGBAADjRArZWb8fZP
	 1CT9QCcFCQ1mO00kLRMzWY97WwekFN0kAwGAc86nhJGTgSFBk+tn+ggiDgFf+GIEkr
	 jmGPwOjJ0Ajf6Fmnym83s2lojnPNwgUzUQm/WrX2gJ59GzYKWdLw1wUdEdZm6oLx73
	 GJnliTSTvKZgnw2PkDwxyh+rO8tfNhfQhBOd3qmp6Yds7uh+mw4bUCrbCQ6aP14FnG
	 lt88Ktlo5ReGg==
Date: Tue, 3 Sep 2024 12:25:09 -0500
From: Rob Herring <robh@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v7 0/6] Add SPAcc Crypto Driver Support
Message-ID: <20240903172509.GA1754429-robh@kernel.org>
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
 <ZrcHGxcYnsejQ7H_@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrcHGxcYnsejQ7H_@gondor.apana.org.au>

On Sat, Aug 10, 2024 at 02:22:19PM +0800, Herbert Xu wrote:
> On Mon, Jul 29, 2024 at 09:43:44AM +0530, Pavitrakumar M wrote:
> > Add the driver for SPAcc(Security Protocol Accelerator), which is a
> > crypto acceleration IP from Synopsys. The SPAcc supports many cipher,
> > hash, aead algorithms and various modes.The driver currently supports
> > below,
> > 
> > aead:
> > - ccm(sm4)
> > - ccm(aes)
> > - gcm(sm4)
> > - gcm(aes)
> > - rfc7539(chacha20,poly1305)
> > 
> > cipher:
> > - cbc(sm4)
> > - ecb(sm4)
> > - ctr(sm4)
> > - xts(sm4)
> > - cts(cbc(sm4))
> > - cbc(aes)
> > - ecb(aes)
> > - xts(aes)
> > - cts(cbc(aes))
> > - ctr(aes)
> > - chacha20
> > - ecb(des)
> > - cbc(des)
> > - ecb(des3_ede)
> > - cbc(des3_ede)
> > 
> > hash:
> > - cmac(aes)
> > - xcbc(aes)
> > - cmac(sm4)
> > - xcbc(sm4) 
> > - hmac(md5)
> > - md5
> > - hmac(sha1)
> > - sha1
> > - sha224
> > - sha256
> > - sha384
> > - sha512
> > - hmac(sha224)
> > - hmac(sha256)
> > - hmac(sha384)
> > - hmac(sha512)
> > - sha3-224
> > - sha3-256
> > - sha3-384
> > - sha3-512
> > - hmac(sm3)
> > - sm3
> > - michael_mic
> > 
> > Pavitrakumar M (6):
> >   Add SPAcc Skcipher support
> >   Enable SPAcc AUTODETECT
> >   Add SPAcc ahash support
> >   Add SPAcc aead support
> >   Add SPAcc Kconfig and Makefile
> >   Enable Driver compilation in crypto Kconfig and Makefile
> > 
> >  drivers/crypto/Kconfig                     |    1 +
> >  drivers/crypto/Makefile                    |    1 +
> >  drivers/crypto/dwc-spacc/Kconfig           |   95 +
> >  drivers/crypto/dwc-spacc/Makefile          |   16 +
> >  drivers/crypto/dwc-spacc/spacc_aead.c      | 1260 ++++++++++
> >  drivers/crypto/dwc-spacc/spacc_ahash.c     |  914 +++++++
> >  drivers/crypto/dwc-spacc/spacc_core.c      | 2512 ++++++++++++++++++++
> >  drivers/crypto/dwc-spacc/spacc_core.h      |  826 +++++++
> >  drivers/crypto/dwc-spacc/spacc_device.c    |  340 +++
> >  drivers/crypto/dwc-spacc/spacc_device.h    |  231 ++
> >  drivers/crypto/dwc-spacc/spacc_hal.c       |  367 +++
> >  drivers/crypto/dwc-spacc/spacc_hal.h       |  114 +
> >  drivers/crypto/dwc-spacc/spacc_interrupt.c |  316 +++
> >  drivers/crypto/dwc-spacc/spacc_manager.c   |  650 +++++
> >  drivers/crypto/dwc-spacc/spacc_skcipher.c  |  712 ++++++
> >  15 files changed, 8355 insertions(+)
> >  create mode 100644 drivers/crypto/dwc-spacc/Kconfig
> >  create mode 100644 drivers/crypto/dwc-spacc/Makefile
> >  create mode 100755 drivers/crypto/dwc-spacc/spacc_aead.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c
> > 
> > 
> > base-commit: 95c0f5c3b8bb7acdc5c4f04bc6a7d3f40d319e9e
> > -- 
> > 2.25.1
> 
> All applied.  Thanks.

Please drop it. Amongst other problems I pointed out in patch, there's 
no binding for this nor will one be accepted as-is. The author has had 2 
weeks to address it.

Rob
