Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD3143441C
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 16:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783613329; cv=none; b=DrjPbWXgX3ey4XlUXQbhFPF9HD9dMfMrf44DQFJUB3mdehTjWamGsIPbo5t3aIvA5IrB3yYSis9Y+QFh4hoh5BD2Oy/8pnC0drT7+wCbnQyQ/Q+25SSf5dNduxFS4Y8sXWvGbV9B/hVxnIaycgQikw+SOSZG8eJqc8/LDxch+xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783613329; c=relaxed/simple;
	bh=LdoEID+mftfieJuREjeHFGnl1pSH4i3KPMTl65rvBKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQo0k3Lp6uhvwJ9zQ9ZzSDsxFI31epXfYq4Cm6k7clDka3BCm97hsL1fpRWOhl5xvQf1i7hAMeFoC4vz2bZ2lQqwYTagJ2cMQxR88oJTnHd1y1zkhQg7wxZb7a1dSgIv1acOFn63Odty74pwkIpa90lpVm3Ns6HdRtXUfLDALqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=MIXNNbtc; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="MIXNNbtc"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4758bd3731bso23510f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2026 09:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1783613326; x=1784218126; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gov176wXURlzSR3dUDxqqJ+JUc69jBkAANSG0MToDuM=;
        b=MIXNNbtco0ot4EbgBCazIAcAgkmMGSlgBUkph/ZIj83xY7G7d+g0+5PdEK3X27kvuQ
         BCgcoilnMXnSkeyGhqzYX5wvmvQrWEqZLQO1azhpcTnqjQeke5xfEFEVISjPACdwyrnr
         RAKm0m8cPG95tV5BiD4eonZi5sCnbQR/1T2Rg0sVCfIJefpTAajuym6efVhpXRz2B5pe
         6L5Y37FwLzwZo/Jo2pQLiLPEgRDJYwHhcQbUxzsRLf0gwH0tfrrWgmjB0133vUYurZtW
         Sm4/ByBq6+56bVB0VucJb8u5SS/3UZ2YcOT9E6Jy3Y1H4XcPrkqCMRWvG0q/k/8Nm90J
         dbYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783613326; x=1784218126;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gov176wXURlzSR3dUDxqqJ+JUc69jBkAANSG0MToDuM=;
        b=lgPZH13p5NfPnIkZp5Lw1dJ+eXwe7YlBHqXMbKNn7rcpmRYKhmPYFTpxWRXLc2bGZH
         /fjN1lhd906smgxTaT9+gHrE/H0BlAk26lcJynyOvMiOF9Yns3K6UriFGDhWaukz4IZn
         ZvvmYQ3Q9ILPgS+IlQtdBxf3mEB59Zq2pwr3vwspJuIuII9CDSmYn7i29xO12Nv9Auvu
         v0i3uZEwKllq91O1+CSBa3gnBr3UldP/V4gkdbZ4KY0PryWyhjvKxagHIHHWSMw0n21h
         VMMBhVl5h0zhWArb7rmKAlHDLk/JrmTY2hrpPnevkwvFAMVKGdeQhCY3ZMSgigMtm8Ey
         v5Kg==
X-Forwarded-Encrypted: i=1; AHgh+Rql3RIXl/kICg3WsjsDWLaksh2DaIDAS77S/nFIC9KQdOl9BzigAgqu3yGvuYDgDN7kBbX9vVJszpvYiwA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPkp7IZkDeAEQPDMcLhsBZ/ygehC2x2iKL0fXmcrkLGHO5Dd4t
	BhzxFhAMXC9OTYp8S7sigxRnr4hBh8Ho2sQWk7fK/Nnh5rwSRtwxoF4Ffo4CG6Jw4mA=
X-Gm-Gg: AfdE7ckXq1jJ5qWPMTnmg5QzFO9dcriyAr5tQLIPVLAlf+yDZdiovrpzm8t/306yDj8
	o0R/yVGDl78b/L4FNDpuO1JdB94pGUTtF49cdEyQS/TYvpSPiKuovLAyp9DuRItxJqfZCNwGzDX
	HQZiHHIrX48kbV+WFbgjbA+cVq6hZp3/OqhVRzjXax8X3uclGe2+fcKoAonGFB5nTiaUtmI200j
	qumcoqaILftMyPIRqZdhUCvkyfUECoowunC7XqEeiTDQDzFnxy2qFb083+WP5Dywc5ibE1k7fGB
	3XYAwDNdN+jYayoiB4lCgGA2rG0Mbh6KBWuzed1boO22H2FOYczLJ5gYIoHX/IsqUAt0S1DMURw
	0Cr+9UBbO07uk+C64rGpse/FMpUX44E7OV+PtNAHsiTemq6GvkOtX2UW6NTgAKUua6YRmoe8mN2
	ihnBGya86Mb5Ejp73Xn84jm1bmhXLkN2HshcqsDGgG5KsygNP9/gvCBhOCap0nkWsntZSoIHqm8
	ZT2
X-Received: by 2002:a05:6000:230b:b0:46d:f979:1827 with SMTP id ffacd0b85a97d-47df757026bmr3824909f8f.23.1783613325532;
        Thu, 09 Jul 2026 09:08:45 -0700 (PDT)
Received: from localhost (p200300f65f47db043de98c19b374aa68.dip0.t-ipconnect.de. [2003:f6:5f47:db04:3de9:8c19:b374:aa68])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-47aa0960816sm50486350f8f.29.2026.07.09.09.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 09:08:43 -0700 (PDT)
Date: Thu, 9 Jul 2026 18:08:42 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Lee Jones <lee@kernel.org>, 
	Florian Fainelli <florian.fainelli@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Ray Jui <rjui@broadcom.com>, 
	Scott Branden <sbranden@broadcom.com>, mfd@lists.linux.dev, linux-rpi-kernel@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, linux-mediatek@lists.infradead.org, 
	Qunqin Zhao <zhaoqunqin@loongson.cn>, linux-crypto@vger.kernel.org, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, chrome-platform@lists.linux.dev, 
	Colin Foster <colin.foster@in-advantage.com>, David Rhodes <david.rhodes@cirrus.com>, 
	Richard Fitzgerald <rf@opensource.cirrus.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, 
	Zha Qipeng <qipeng.zha@intel.com>, Thomas Richard <thomas.richard@bootlin.com>, 
	linux-sound@vger.kernel.org, patches@opensource.cirrus.com, Xu Yilun <yilun.xu@intel.com>, 
	Tom Rix <trix@redhat.com>, Michael Hennerich <michael.hennerich@analog.com>, 
	Chen-Yu Tsai <wens@kernel.org>, Marek Vasut <marek.vasut+renesas@gmail.com>, 
	James Ogletree <jogletre@opensource.cirrus.com>, Fred Treven <fred.treven@cirrus.com>, 
	Ben Bright <ben.bright@cirrus.com>, Support Opensource <support.opensource@diasemi.com>, 
	Andy Shevchenko <andy@kernel.org>, Charles Keepax <ckeepax@opensource.cirrus.com>, 
	Chanwoo Choi <cw00.choi@samsung.com>, Krzysztof Kozlowski <krzk@kernel.org>, 
	=?utf-8?B?QW5kcsOp?= Draszik <andre.draszik@linaro.org>, Aaro Koskinen <aaro.koskinen@iki.fi>, 
	Andreas Kemnade <andreas@kemnade.info>, Kevin Hilman <khilman@baylibre.com>, 
	Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, 
	Samuel Kayode <samkay014@gmail.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, linux-renesas-soc@vger.kernel.org, linux-omap@vger.kernel.org, 
	imx@lists.linux.dev, linux-stm32@st-md-mailman.stormreply.com, 
	Linus Walleij <linusw@kernel.org>, linux@ew.tq-group.com, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Claudiu Beznea <claudiu.beznea@tuxon.dev>, Peter Griffin <peter.griffin@linaro.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Tim Harvey <tharvey@gateworks.com>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Sven Peter <sven@kernel.org>, Janne Grunau <j@jannau.net>, 
	Neal Gompa <neal@gompa.dev>, Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>, 
	Luca Ceresoli <luca.ceresoli@bootlin.com>, Saravanan Sekar <sravanhome@gmail.com>, 
	Frank Li <Frank.Li@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>, 
	Pengutronix Kernel Team <kernel@pengutronix.de>, Fabio Estevam <festevam@gmail.com>, 
	Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>, Matti Vaittinen <mazziesaccount@gmail.com>, 
	Orson Zhai <orsonzhai@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Chunyan Zhang <zhang.lyra@gmail.com>, Fabrice Gasnier <fabrice.gasnier@foss.st.com>, 
	Jernej Skrabec <jernej.skrabec@gmail.com>, Samuel Holland <samuel@sholland.org>, 
	Liviu Dudau <liviu.dudau@arm.com>, Sudeep Holla <sudeep.holla@kernel.org>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Geert Uytterhoeven <geert+renesas@glider.be>, 
	Magnus Damm <magnus.damm@gmail.com>, linux-samsung-soc@vger.kernel.org, 
	linux-amlogic@lists.infradead.org, asahi@lists.linux.dev, linux-arm-msm@vger.kernel.org, 
	linux-sunxi@lists.linux.dev, Peter Tyser <ptyser@xes-inc.com>
Subject: Re: [PATCH v2 00/23] mfd: Use named initializers for arrays of
 *_device_data
Message-ID: <ak_DIUQI9MX5aB8e@monoceros>
References: <cover.1783507945.git.u.kleine-koenig@baylibre.com>
 <ak41yQp3x78s4Fmx@ashevche-desk.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ka4fpqo6ejmxfupn"
Content-Disposition: inline
In-Reply-To: <ak41yQp3x78s4Fmx@ashevche-desk.local>


--ka4fpqo6ejmxfupn
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 00/23] mfd: Use named initializers for arrays of
 *_device_data
MIME-Version: 1.0

Hello,

On Wed, Jul 08, 2026 at 02:34:33PM +0300, Andy Shevchenko wrote:
> On Wed, Jul 08, 2026 at 01:15:07PM +0200, Uwe Kleine-K=F6nig (The Capable=
 Hub) wrote:
> > Hello,
> >=20
> > this series superseeds my previous patch "[PATCH v1] mfd: Use named
> > initializers for arrays of i2c_device_data"
> > (https://lore.kernel.org/lkml/20260515095839.4005460-2-u.kleine-koenig@=
baylibre.com)
> > that Lee asked me to rebase and also the series "[PATCH v1 0/3] mfd:
> > Initialize spi_device_id arrays using member names"
> > (https://lore.kernel.org/lkml/cover.1783003256.git.u.kleine-koenig@bayl=
ibre.com).
> >=20
> > The objective for this series is to prepare mfd for changing
> > of_device_id etc to make driver_data a union, see
> > https://lore.kernel.org/all/cover.1780048925.git.u.kleine-koenig@baylib=
re.com/
> > for the idea behind it.
> >=20
> > This series is based on yesterday's next/master and it does the
> > restructuring not only for i2c and spi (as the two series mentioned
> > above), but for all *_device_id structures that I intend to modify with
> > a union that affect mfd. So (I hope) this is the only patch series
> > affecting mfd for this quest.
> >=20
> > I don't care much about the last few patches unifying the coding style.
> > I think it's a good opportunity to do that, but if you don't like them,
> > just don't apply these.
>=20
> The patches bring inconsistency (or still leave it) with the terminator s=
tyle
> in both I=B2C and ACPI ID tables. Can you revisit that?

I found a few inconstencies for of_device_id, but not for acpi and i2c.
I have a script for the acpi and i2c (and now also for the of) changes
and don't spot inconsistencys in the terminator style for acpi and i2c
devices apart from comments.

(I looked at the output of:

	git grep -lE '(i2c|acpi)_device_id [a-z0-9_]*\[\]' drivers/mfd | xargs -r =
sed -rn '/(i2c|acpi)_device_id [a-zA-Z0-9_]*\[/,/^};/p' | grep -B1 ^\} | so=
rt | uniq -c

)

Do you mean to unify the comments, too?

Best regards
Uwe

--ka4fpqo6ejmxfupn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmpPx4cACgkQj4D7WH0S
/k624gf/dzy2q/+UDcko+3qRC/vjduntKV5JaImo1jv66pbGa0vVyVdYDHS/QwvV
X+Jr6jTMyEZcw6O1onRP1ZIcKU6MTkl/wvtqeLkFJ4PXv/hKftTSkP/IHkLuekNm
Cn37LNIalY7gpr1gfPvcL5Q/BN1qqXCUggmW0xXf+Gi9W5bwWuTaRsJ9ehVptA3+
rMp5HAYJ1isaiiqfMZJ/TqtNWHN6aVh8ZS6YU5b2iDitwtnRCQD1pOcYCYaXgfrt
fbXqb+xpQvMfRgK+MLErhmJUfHf2tKi1s5OKoG1T9fiLCmp0VzTkB4+o4AgpQgeE
pUTRSN5jhrCLDAt7v6B6b4XHPcYmTQ==
=tSBk
-----END PGP SIGNATURE-----

--ka4fpqo6ejmxfupn--
