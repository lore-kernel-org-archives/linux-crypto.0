Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012751649A7
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 11:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340724; cv=none; b=tXa49VccLtGiyq1Lx+u/YpxP4wJnWy9+QQfno4ysXQriUsL4q3QJilwMkKne3lFhvn6n/nMR+qz8BatVrQ+w7YC+7BjCuU36NoYWYC1vQluGmS3+mRRPMiHN8lffsgei/YFbPlqjl1+IhkEmcRi4D+GYmrfaMdUVoGA0UlLKlTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340724; c=relaxed/simple;
	bh=drMv/g0jecfbRSv2iSr91jjAR6eQhsu1iQZBbSuv4DU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vn+pyWZuC8uOYgpU2vIc0egvJ1OWltMzIC6LeD90zuRLySQTBrdQikQsD3sVxoLrfO9cbDvbPpy9TWrH187mLsAo6tUQ9SGEsIgokBGNB+3z5WmClfmDmyb9JthqmvaFi47quIB9q317urIgBaxIUz9dzHKShGkAw4Z0aFl01cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpOL9w+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpOL9w+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2C4C113CC;
	Fri, 10 May 2024 11:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715340723;
	bh=drMv/g0jecfbRSv2iSr91jjAR6eQhsu1iQZBbSuv4DU=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=dpOL9w+HELHrktG70FTlpNI9KpzRHbkLPRih1bqkshGUu7VX1Xz017/ZShN9qAvzZ
	 mpYbQFskyWuI9pdL28E0q/0VgpqtmeI5xqq7jr5LeZnMp1f9b0NMQUIED00qmY7Fhx
	 k6mLLdd6uJu9U8OydY+5c5mDtwWeI+BIdNDUNfGLn9Tkd8u+qrQYewV4gNW6hTHfn4
	 msOVqzOzcUxRNwRsdyqcBGZlmZEHdiB9Bj90/HvAoDz1iSkODhS1p3CSnY+NZgW7yL
	 oTa95jgYfP3Yo6k84gnIY8bWv2mptrU2HHQ7xc7svD8GU71mVi7x0REvXRlcVWIQzb
	 PrE52rtmg1p3w==
Date: Fri, 10 May 2024 13:31:58 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann
 <arnd@arndb.de>, soc@kernel.org, arm@kernel.org, Andy Shevchenko
 <andy@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Ilpo
 =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
 linux-crypto@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH v10 7/9] platform: cznic: turris-omnia-mcu: Add support
 for digital message signing via debugfs
Message-ID: <20240510133158.2f40ee55@dellmb>
In-Reply-To: <2024051007-rendering-borrowing-ffc5@gregkh>
References: <20240510101819.13551-1-kabel@kernel.org>
	<20240510101819.13551-8-kabel@kernel.org>
	<2024051007-rendering-borrowing-ffc5@gregkh>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 10 May 2024 11:52:56 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Fri, May 10, 2024 at 12:18:17PM +0200, Marek Beh=C3=BAn wrote:
> > Add support for digital message signing with private key stored in the
> > MCU. Boards with MKL MCUs have a NIST256p ECDSA private key created
> > when manufactured. The private key is not readable from the MCU, but
> > MCU allows for signing messages with it and retrieving the public key.
> >=20
> > As described in a similar commit 50524d787de3 ("firmware:
> > turris-mox-rwtm: support ECDSA signatures via debugfs"):
> >   The optimal solution would be to register an akcipher provider via
> >   kernel's crypto API, but crypto API does not yet support accessing
> >   akcipher API from userspace (and probably won't for some time, see
> >   https://www.spinics.net/lists/linux-crypto/msg38388.html).
> >=20
> > Therefore we add support for accessing this signature generation
> > mechanism via debugfs for now, so that userspace can access it. =20
>=20
> Having a "real" user/kernel api in debugfs feels wrong here, why would
> you not do this properly?  On most, if not all, systems, debugfs is
> locked down so you do not have access to it, as it is only there for
> debugging.  So how is a user supposed to use this feature if they can't
> get access to it?
>=20
> And debugfs files can be changed at any time, so how can you ensure that
> your new api will always be there?
>=20
> In other words, please solve this properly, do not just add a hack into
> debugfs that no one can use as that is not a good idea.

Hi Greg,

this is the same thing we discussed 5 years ago, I wanted to implement
it via crypto's akcipher, but was refused due to
  https://www.spinics.net/lists/linux-crypto/msg38388.html

I've then exposed this via debugfs in the turris-mox-rwtm driver 4
years ago, and we have supported this in our utility scripts, with the
plan that to reimplement it in the kernel via the correct ABI once
akcipher (or other ABI) is available to userspace, but AFAIK after 5
years this is still not the case :-(

If not debugfs and not akcipher, another option is to expose this via
sysfs, but that also doesn't seem right, and if I recall correctly you
also disapproved of this 5 years ago.

The last option would be to create another device, something like
/dev/turris-crypto for this. I wanted to avoid that and wait for
akcipher to be exposed do crypto since another /dev device must be
supported forever, while debugfs implementation can be removed once
this is supported via standardized ABI.

Do you have any suggestions?

Marek
