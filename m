Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABE47EEF3
	for <linux-crypto@vger.kernel.org>; Thu,  9 May 2024 18:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715281060; cv=none; b=FnqwO8E6RLIAy3LULaNzL1Kl5pSA8ncl66mKlJH5i+2VuqwQ8UDIF5/E/37EVxaB35GaLfFUcm80WYxtcyPxxa56/kO4TfgZ/3EBRCYJti9tRdk1ir/5Sd8VAIBOY3GXQtDXir7kDIY0goPM1AcXbiDxu7CUf5InjmqKwiaL+wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715281060; c=relaxed/simple;
	bh=Pm5Msa1YUJp/7t63OKazwtwIkFsr6oJkT3uasv+Aze4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tSJghUnmOZq3EUptXrlNergo9v3RY/Z+ZYY7L79OEKG3rWww5TpR11ly2SgnrRyWWgLoQpTC/rztqBOnHrVIt9gCzqo4/i6bCr77UeVjp0NxomIzXGgOngm2mUQqwBuM/C43rf9/5pl5+eVPlNLJ1/pkmr75IrNBVj69qlJ7vxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KUws44+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUws44+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE28DC116B1;
	Thu,  9 May 2024 18:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715281060;
	bh=Pm5Msa1YUJp/7t63OKazwtwIkFsr6oJkT3uasv+Aze4=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=KUws44+RV2+YJPUvzrpldb3w3trTQcCxqBDoUV9IqrOe5m1h3rSGAIxKdKFtJU3VC
	 SKdQncqBdhxjc6/C8CBI1MbD+EAuO6qOzqgTnuuHHDyNpVS/CdejZRe8Ffpix2hS7R
	 N4JQhpjz/Yq+eVKk5z/nrFKp/eDde8BtvCc0n+ZzdVwoczW8JyoOXyjGn0VU/lhmlO
	 lOwB9ctWBFM9m+mRP2RuRLFba2ppAxSiqydJMM4O8KQgaV41QfuaRLh+aWiRzfA5Iv
	 qzwVZV7Pj3EbzePh02JxE7f++CyGIF4UatCmyG2lHrCiGxlvWjr7/tCeVwgymG4cXg
	 c1PECJwBiI4Mg==
Date: Thu, 9 May 2024 20:57:29 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann
 <arnd@arndb.de>, soc@kernel.org, arm@kernel.org, Hans de Goede
 <hdegoede@redhat.com>, Ilpo =?UTF-8?B?SsOkcnZpbmVu?=
 <ilpo.jarvinen@linux.intel.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, Dan Carpenter
 <dan.carpenter@linaro.org>
Subject: Re: [PATCH v9 7/9] platform: cznic: turris-omnia-mcu: Add support
 for digital message signing via debugfs
Message-ID: <20240509205729.09728cbb@thinkpad>
In-Reply-To: <Zjti-FkUCAQzMmrQ@smile.fi.intel.com>
References: <20240508103118.23345-1-kabel@kernel.org>
	<20240508103118.23345-8-kabel@kernel.org>
	<Zjti-FkUCAQzMmrQ@smile.fi.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 8 May 2024 14:33:12 +0300
Andy Shevchenko <andy@kernel.org> wrote:

> On Wed, May 08, 2024 at 12:31:16PM +0200, Marek Beh=C3=BAn wrote:

...

> > +static irqreturn_t omnia_msg_signed_irq_handler(int irq, void *dev_id)
> > +{
> > +	u8 reply[1 + OMNIA_MCU_CRYPTO_SIGNATURE_LEN];
> > +	struct omnia_mcu *mcu =3D dev_id;
> > +	int err;
> > +
> > +	err =3D omnia_cmd_read(mcu->client, OMNIA_CMD_CRYPTO_COLLECT_SIGNATUR=
E,
> > +			     reply, sizeof(reply));
> > +	if (!err && reply[0] !=3D OMNIA_MCU_CRYPTO_SIGNATURE_LEN)
> > +		err =3D -EIO;
> > +
> > +	guard(mutex)(&mcu->sign_lock);
> > +
> > +	if (mcu->sign_state =3D=3D SIGN_STATE_REQUESTED) {
> > +		mcu->sign_err =3D err;
> > +		if (!err)
> > +			memcpy(mcu->signature, &reply[1],
> > +			       OMNIA_MCU_CRYPTO_SIGNATURE_LEN); =20
>=20
> > +		mcu->sign_state =3D SIGN_STATE_COLLECTED; =20
>=20
> Even for an error case?

Yes, the pair (errno, signature) is collected.

> > +		complete(&mcu->msg_signed_completion);
> > +	}
> > +
> > +	return IRQ_HANDLED;
> > +} =20
>=20
> ...
>=20
> > +	scoped_guard(mutex, &mcu->sign_lock)
> > +		if (mcu->sign_state !=3D SIGN_STATE_REQUESTED &&
> > +		    mcu->sign_state !=3D SIGN_STATE_COLLECTED)
> > +			return -ENODATA; =20
>=20
> {}
>=20
> Don't you want interruptible mutex? In such case you might need to return
> -ERESTARTSYS. OTOH, this is debugfs, we don't much care.

Indeed I shall use
  scoped_cond_guard(mutex_intr, return -ERESTARTSYS, &mcu->sign_lock) {
    ...
  }

And -ERESTARTSYS instead of -EINTR also for the subsequent
wait_for_completion_interruptible(), and also in trng from patch 6/9.

> ...
>=20
> > +#define OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN	33 =20
>=20
> 33? Hmm... does it mean (32 + 1)?

Rather (1 + 32), the first byte is 0x02 or 0x03, determining whether
the y coordinate of the public key elliptic curve point is positive or
negative, and the rest 32 bytes are the x coordinate.

Marek

