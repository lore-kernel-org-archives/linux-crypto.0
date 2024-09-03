Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F102126BE8
	for <linux-crypto@vger.kernel.org>; Tue,  3 Sep 2024 22:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725404388; cv=none; b=ZiuaZqaZrP0vMZBWhsX41eSVO7xat7GhvOGjeicFKWgJTHLAaiN5Hjb0ooU4f/wG9GNNWPmX/Ua9lo7WdPwK6+cNizCHHMOjIAmGn25p5YPcgApduhln0r+qQjQ5kXyX4A6dwO9Q813e3lQG6bEUkDnBpbOOB6UUx4IGKgkQhiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725404388; c=relaxed/simple;
	bh=PB3beGuUpyRMJ/S2D64l5J/LWOM+pC/Y60AvXgaPxEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SnHdBboGvB5v4mybQkBMGfRvYZj1zreJF7P848Bg1JYYzAfUX1U3pmF7Lrw64Cx+Y0Jp7wPHSTQiDtRV9MC/fe+ZjhEmlkVvERtKOIR9rLm7/rnRcu5HIpq7P7cyIEQZ47WLzVQ7LrYpcc+kHFpANufXOeYJPYq/IotQ0meSVoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ilv+nujL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ilv+nujL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9y1aTG66Q4OPDA5vNHTHkzERjvSvgcpYPBgD5CFAHxE=; b=ilv+nujLHInxFo6vhQXnVHx/0s
	SLE9cQII5QGrFttYcd9yWGTa5z1CZcRfgZjj/GUFphTOwkPy7LHPL7a0JcDwWLczc8MQ6MVTxwRj8
	iV2sWVwL4usBHE52gBjeBfjP07g+Jh7cJjU6E219OMwGa6aYW4+P34lkt3PdZM/TH9IvvKuKVW41k
	fbzk0204PYmoleU1TmD4SIHcb2VTXsk3S5n12TW2otTam/jRoes5D3BV+fQg6CvOkrRKgAQWFDpn0
	JI+9SR6neTiZxKna/oznT3nE6LOsyV9mjGZsdZM7c7nlDNw8aLQCmARbEAsP1Iz8bmG6vaVA3OVZc
	jMjI5Azg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1slcUu-009U1i-0K;
	Wed, 04 Sep 2024 06:59:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Sep 2024 06:59:40 +0800
Date: Wed, 4 Sep 2024 06:59:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rob Herring <robh@kernel.org>
Cc: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v7 0/6] Add SPAcc Crypto Driver Support
Message-ID: <ZteU3EvBxSCTeiBY@gondor.apana.org.au>
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
 <ZrcHGxcYnsejQ7H_@gondor.apana.org.au>
 <20240903172509.GA1754429-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903172509.GA1754429-robh@kernel.org>

On Tue, Sep 03, 2024 at 12:25:09PM -0500, Rob Herring wrote:
> On Sat, Aug 10, 2024 at 02:22:19PM +0800, Herbert Xu wrote:
> > On Mon, Jul 29, 2024 at 09:43:44AM +0530, Pavitrakumar M wrote:
> > > Add the driver for SPAcc(Security Protocol Accelerator), which is a
> > > crypto acceleration IP from Synopsys. The SPAcc supports many cipher,
> > > hash, aead algorithms and various modes.The driver currently supports
> > > below,
> > > 
> > > aead:
> > > - ccm(sm4)
> > > - ccm(aes)
> > > - gcm(sm4)
> > > - gcm(aes)
> > > - rfc7539(chacha20,poly1305)
> > > 
> > > cipher:
> > > - cbc(sm4)
> > > - ecb(sm4)
> > > - ctr(sm4)
> > > - xts(sm4)
> > > - cts(cbc(sm4))
> > > - cbc(aes)
> > > - ecb(aes)
> > > - xts(aes)
> > > - cts(cbc(aes))
> > > - ctr(aes)
> > > - chacha20
> > > - ecb(des)
> > > - cbc(des)
> > > - ecb(des3_ede)
> > > - cbc(des3_ede)
> > > 
> > > hash:
> > > - cmac(aes)
> > > - xcbc(aes)
> > > - cmac(sm4)
> > > - xcbc(sm4) 
> > > - hmac(md5)
> > > - md5
> > > - hmac(sha1)
> > > - sha1
> > > - sha224
> > > - sha256
> > > - sha384
> > > - sha512
> > > - hmac(sha224)
> > > - hmac(sha256)
> > > - hmac(sha384)
> > > - hmac(sha512)
> > > - sha3-224
> > > - sha3-256
> > > - sha3-384
> > > - sha3-512
> > > - hmac(sm3)
> > > - sm3
> > > - michael_mic
> > > 
> > > Pavitrakumar M (6):
> > >   Add SPAcc Skcipher support
> > >   Enable SPAcc AUTODETECT
> > >   Add SPAcc ahash support
> > >   Add SPAcc aead support
> > >   Add SPAcc Kconfig and Makefile
> > >   Enable Driver compilation in crypto Kconfig and Makefile
> > > 
> > >  drivers/crypto/Kconfig                     |    1 +
> > >  drivers/crypto/Makefile                    |    1 +
> > >  drivers/crypto/dwc-spacc/Kconfig           |   95 +
> > >  drivers/crypto/dwc-spacc/Makefile          |   16 +
> > >  drivers/crypto/dwc-spacc/spacc_aead.c      | 1260 ++++++++++
> > >  drivers/crypto/dwc-spacc/spacc_ahash.c     |  914 +++++++
> > >  drivers/crypto/dwc-spacc/spacc_core.c      | 2512 ++++++++++++++++++++
> > >  drivers/crypto/dwc-spacc/spacc_core.h      |  826 +++++++
> > >  drivers/crypto/dwc-spacc/spacc_device.c    |  340 +++
> > >  drivers/crypto/dwc-spacc/spacc_device.h    |  231 ++
> > >  drivers/crypto/dwc-spacc/spacc_hal.c       |  367 +++
> > >  drivers/crypto/dwc-spacc/spacc_hal.h       |  114 +
> > >  drivers/crypto/dwc-spacc/spacc_interrupt.c |  316 +++
> > >  drivers/crypto/dwc-spacc/spacc_manager.c   |  650 +++++
> > >  drivers/crypto/dwc-spacc/spacc_skcipher.c  |  712 ++++++
> > >  15 files changed, 8355 insertions(+)
> > >  create mode 100644 drivers/crypto/dwc-spacc/Kconfig
> > >  create mode 100644 drivers/crypto/dwc-spacc/Makefile
> > >  create mode 100755 drivers/crypto/dwc-spacc/spacc_aead.c
> > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
> > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
> > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
> > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
> > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
> > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
> > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
> > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
> > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
> > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c
> > > 
> > > 
> > > base-commit: 95c0f5c3b8bb7acdc5c4f04bc6a7d3f40d319e9e
> > > -- 
> > > 2.25.1
> > 
> > All applied.  Thanks.
> 
> Please drop it. Amongst other problems I pointed out in patch, there's 
> no binding for this nor will one be accepted as-is. The author has had 2 
> weeks to address it.

OK I will revert this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
