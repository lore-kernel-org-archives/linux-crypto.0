Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416A91DDC22;
	Thu, 17 Oct 2024 13:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729172383; cv=none; b=QnPZMeAaNoXuqtyOKy823gK0deYvmPSm1/0ax1sYGaZfW/M/jJb0bRWG9fz4SgQZOp71zaA10pLswmkPsvsCBqIHqdIkYZXx92s9yDveQb3G6Eb0UIYc7gIoQbe7TzvtvdPMOl8k7n1wcUaRVPAwHzhuH1ZtlVXIPM5uLzGwMEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729172383; c=relaxed/simple;
	bh=/Z6nbXADLiIGjPex3JCDSxQPOzXF5Or/GK2vQ2ICUEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q2hgZUuiAi1zOZKFWlGfTyOluZbrW0ef6E0sa46DlOvmSKxBI+ww+wnTi3//vJSaeE4yOgAjfR8NkALHU/sYtAVxeUZQyKNxJXTt3gOtXfRCUrCz+smXDEjbcHTCEIh+Morm/1cnHKbXsT/EKuzwtHwhMUI1QXk0v4z7uR71+h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=YkXUNo1P; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="YkXUNo1P"
Received: from francesco-nb (31-10-206-125.static.upc.ch [31.10.206.125])
	by mail11.truemail.it (Postfix) with ESMTPA id B612E1F9C7;
	Thu, 17 Oct 2024 15:39:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1729172378;
	bh=RqKqCojaEzQZ+8p1QMDFCOmzawbTxuGxzwtudrDemAE=; h=From:To:Subject;
	b=YkXUNo1PMxy8eEuP3x7vyw2bxc6SR/1ixpxecn6kKLYhbAlINHUw1/OMo4KKIcgOl
	 lcI4oADlV3Q7srMrx22ObObGAAMbg6lF1nW9DtiyMFr2GPyY1P67Ud/OfyoeNQNCsq
	 yO08+mVJ5dxgz7+e7J9WhZ4VDDXibXUoMAZz0vXuwdtbyw5s/my4geNf5HcBB/p9nB
	 5mwcID5lHjc7lftPZ6sCxyGRG3evArW5HjUPPVosCei6rAZmLyPHEkEYXfxMzL8f7s
	 G1Z/qnatclbyo9fp5vyBINCby/cKLV6YaYGYBVcot/nRSBrb2aU7VX198cwaBupnAa
	 P9RHUWzO8XHGw==
Date: Thu, 17 Oct 2024 15:39:33 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
	upstream@airoha.com
Subject: Re: [PATCH 2/2] hwrng: add support for Airoha EN7581 TRNG
Message-ID: <20241017133933.GA31667@francesco-nb>
References: <20241016151845.23712-1-ansuelsmth@gmail.com>
 <20241016151845.23712-2-ansuelsmth@gmail.com>
 <20241017131112.GA28955@francesco-nb>
 <67110d84.050a0220.2ae4bd.8910@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67110d84.050a0220.2ae4bd.8910@mx.google.com>

On Thu, Oct 17, 2024 at 03:13:37PM +0200, Christian Marangi wrote:
> On Thu, Oct 17, 2024 at 03:11:12PM +0200, Francesco Dolcini wrote:
> > On Wed, Oct 16, 2024 at 05:18:42PM +0200, Christian Marangi wrote:
> > > Add support for Airoha TRNG. The Airoha SoC provide a True RNG module
> > > that can output 4 bytes of raw data at times.
> > > 
> > > The module makes use of various noise source to provide True Random
> > > Number Generation.
> > > 
> > > On probe the module is reset to operate Health Test and verify correct
> > > execution of it.
> > > 
> > > The module can also provide DRBG function but the execution mode is
> > > mutually exclusive, running as TRNG doesn't permit to also run it as
> > > DRBG.
> > > 
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > ---
> > >  drivers/char/hw_random/Kconfig       |  13 ++
> > >  drivers/char/hw_random/Makefile      |   1 +
> > >  drivers/char/hw_random/airoha-trng.c | 243 +++++++++++++++++++++++++++
> > >  3 files changed, 257 insertions(+)
> > >  create mode 100644 drivers/char/hw_random/airoha-trng.c
> > > 
> > > diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> > > index 5912c2dd6398..bda283f290bc 100644
> > > --- a/drivers/char/hw_random/Kconfig
> > > +++ b/drivers/char/hw_random/Kconfig
> > > @@ -62,6 +62,19 @@ config HW_RANDOM_AMD
> > >  
> > >  	  If unsure, say Y.
> > >  
> > > +config HW_RANDOM_AIROHA
> > > +	tristate "Airoha True HW Random Number Generator support"
> > > +	depends on ARCH_AIROHA || COMPILE_TEST
> > 
> > > +	default HW_RANDOM
> > This should not be always enabled when HW_RANDOM is enabled. Enabling
> > driver should be a opt-in.
> 
> Was following the pattern with other HW_RANDOM config. Ok will drop.

Whoops. I missed that it depends on ARCH_AIROHA. Given that dependency
is fine to me without any change.

Francesco

