Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346BF16F26B
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 11:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715341826; cv=none; b=M5jbDQU+AU4FNLp0PIRfgDle2YdcuRtNvExL0mx405UcLB/9wTSzfO9e93SeV0x1r1fXhhF04zVBvAWmIW35ph50Q6W+h/cEBeC2WOuZMpzmaDPQLFMDRFhq+wjB4hva6PJCiVc0yD5BrhCxHYg7O09Inj184QLnM7VXqoB60CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715341826; c=relaxed/simple;
	bh=AGUJV5/xVBdTLPDzghFo5zVLGEYebLFiG6iUIgp0ssU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UmM9q5iO/RqGg32jPBMa56LCTcFIKgJtcCuYUrMD9FYTsT/J10gLm49hK+8Ycw2mNe81M9PvTTNsh3luBEthiXxqx0AbrmIaeAhBPy325b8qDQOvlDyvoBtEsln3FB6xdah1014kEx3FjVegSyDo5NWesa0g8VzdV3xzcw/1ybk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fnHUmHrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fnHUmHrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9B1C113CC;
	Fri, 10 May 2024 11:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715341825;
	bh=AGUJV5/xVBdTLPDzghFo5zVLGEYebLFiG6iUIgp0ssU=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=fnHUmHrqb/QH3Bvx2t66KZlD1I4UaeGc87nUTKHi+Y1JCcbcPcjRDb9ZBQ6YxxYzn
	 I+ZG0HJAVb5h0ezluG2yAWXjIdxMil+JVgmXHFokmu+GZt6mFAngNxW5QULcAazkXV
	 +t0jH2xAXynzswcrO53SNeEXv0NO0LPlaYJQjam5vKFvYijVElGLQ/kRQQtLht9UDY
	 2rv3/AkY9TzqwEBSohPe55OrOEJoGSN/xjviXZHvAAqvQN5NilubtzV17sfPYIHY+i
	 UR4lFYvzlFXvUlafcAgkIiCTD5R29ns3emoAPEA25Mo9E4n8JNy+d6PBp7/F9iZEu5
	 +EK1rUieIuWLQ==
Date: Fri, 10 May 2024 13:50:20 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann
 <arnd@arndb.de>, soc@kernel.org, arm@kernel.org, Andy Shevchenko
 <andy@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Ilpo
 =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
 linux-crypto@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH v10 7/9] platform: cznic: turris-omnia-mcu: Add support
 for digital message signing via debugfs
Message-ID: <20240510135020.06aff350@dellmb>
In-Reply-To: <2024051013-purse-harsh-d927@gregkh>
References: <20240510101819.13551-1-kabel@kernel.org>
	<20240510101819.13551-8-kabel@kernel.org>
	<2024051007-rendering-borrowing-ffc5@gregkh>
	<20240510133158.2f40ee55@dellmb>
	<2024051013-purse-harsh-d927@gregkh>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 10 May 2024 12:37:04 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Fri, May 10, 2024 at 01:31:58PM +0200, Marek Beh=C3=BAn wrote:
> > On Fri, 10 May 2024 11:52:56 +0100
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >  =20
> > > On Fri, May 10, 2024 at 12:18:17PM +0200, Marek Beh=C3=BAn wrote: =20
> > > > Add support for digital message signing with private key stored in =
the
> > > > MCU. Boards with MKL MCUs have a NIST256p ECDSA private key created
> > > > when manufactured. The private key is not readable from the MCU, but
> > > > MCU allows for signing messages with it and retrieving the public k=
ey.
> > > >=20
> > > > As described in a similar commit 50524d787de3 ("firmware:
> > > > turris-mox-rwtm: support ECDSA signatures via debugfs"):
> > > >   The optimal solution would be to register an akcipher provider via
> > > >   kernel's crypto API, but crypto API does not yet support accessing
> > > >   akcipher API from userspace (and probably won't for some time, see
> > > >   https://www.spinics.net/lists/linux-crypto/msg38388.html).
> > > >=20
> > > > Therefore we add support for accessing this signature generation
> > > > mechanism via debugfs for now, so that userspace can access it.   =
=20
> > >=20
> > > Having a "real" user/kernel api in debugfs feels wrong here, why would
> > > you not do this properly?  On most, if not all, systems, debugfs is
> > > locked down so you do not have access to it, as it is only there for
> > > debugging.  So how is a user supposed to use this feature if they can=
't
> > > get access to it?
> > >=20
> > > And debugfs files can be changed at any time, so how can you ensure t=
hat
> > > your new api will always be there?
> > >=20
> > > In other words, please solve this properly, do not just add a hack in=
to
> > > debugfs that no one can use as that is not a good idea. =20
> >=20
> > Hi Greg,
> >=20
> > this is the same thing we discussed 5 years ago, I wanted to implement
> > it via crypto's akcipher, but was refused due to
> >   https://www.spinics.net/lists/linux-crypto/msg38388.html
> >=20
> > I've then exposed this via debugfs in the turris-mox-rwtm driver 4
> > years ago, and we have supported this in our utility scripts, with the
> > plan that to reimplement it in the kernel via the correct ABI once
> > akcipher (or other ABI) is available to userspace, but AFAIK after 5
> > years this is still not the case :-(
> >=20
> > If not debugfs and not akcipher, another option is to expose this via
> > sysfs, but that also doesn't seem right, and if I recall correctly you
> > also disapproved of this 5 years ago. =20
>=20
> Yeah, sysfs is not ok for this either.
>=20
> > The last option would be to create another device, something like
> > /dev/turris-crypto for this. I wanted to avoid that and wait for
> > akcipher to be exposed do crypto since another /dev device must be
> > supported forever, while debugfs implementation can be removed once
> > this is supported via standardized ABI.
> >=20
> > Do you have any suggestions? =20
>=20
> Not really, I can't see the link above (no internet connection right
> now) but this should just be fixed properly at the crypto subsystem
> instead of these horrible debugfs hacks.
>=20
> thanks,
>=20
> greg k-h

The mail is from Herbert Xu and it says the following:

  The akcipher kernel API is still in a state of flux.  See the
  recent work on ecrdsa for example which affected the RSA API.
 =20
  Until that settles down I will not allow akcipher to be exported
  through af_alg as that would commit us to that API forever.

Marek
