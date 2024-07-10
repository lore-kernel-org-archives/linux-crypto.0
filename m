Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0104E78281
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jul 2024 07:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720595391; cv=none; b=S1lLM7GtSlVWH2geovN0Do1EWcblTV0Y+NxdqLRt3uBnOi7DLLyI1HGwzvF3w1eXSyND1rpa/3/ta2OI4y2C740xvO3Qwfp8i0CjHOLe28uACFVD46J0kA45WbivV/B4kdCuM6CUjhYWAeDJNUwANTHwUqFkXSG8OGEchphGSL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720595391; c=relaxed/simple;
	bh=c3ZMsDMrBDsBNE7pwd9r6HkLUkDsTX5tVlsx7ZAcyWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGSAP28itcLcGcZ+Kl9KZxN2mMsux8G1rljDL4UydJurUhUqirY/ftUoM3XPl3WY1oN96Dl6r2TXgocq24V+TA+WLd0EDiMPG8buaRpvPzFDlWDlbs0o74fzeX1y5hGHbwfx+shSFkr3Cz85XroGBGyersw4FjDF215TkYBmWAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mfe@pengutronix.de>)
	id 1sRRAQ-0004e6-NZ; Wed, 10 Jul 2024 08:51:06 +0200
Received: from [2a0a:edc0:2:b01:1d::c5] (helo=pty.whiteo.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <mfe@pengutronix.de>)
	id 1sRRAO-008SMR-WE; Wed, 10 Jul 2024 08:51:05 +0200
Received: from mfe by pty.whiteo.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <mfe@pengutronix.de>)
	id 1sRRAO-008MRg-2u;
	Wed, 10 Jul 2024 08:51:04 +0200
Date: Wed, 10 Jul 2024 08:51:04 +0200
From: Marco Felsch <m.felsch@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - enable hash api only on ARM platforms per
 default
Message-ID: <20240710065104.q5qh2bmf3r7wi7bz@pengutronix.de>
References: <20240626155724.4045056-1-m.felsch@pengutronix.de>
 <258feb43-382d-4ea0-9164-357924350dec@nxp.com>
 <ZofSbH2Fu/xLnzif@gondor.apana.org.au>
 <20240709085454.you3b3ueb3xbtrv6@pengutronix.de>
 <Zo2ZcqP5zSLB0mf+@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zo2ZcqP5zSLB0mf+@gondor.apana.org.au>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org

On 24-07-10, Herbert Xu wrote:
> On Tue, Jul 09, 2024 at 10:54:54AM +0200, Marco Felsch wrote:
> >
> > We had an patch exactly doing this but depending on the SoC the default
> > prio may valid since the CAAM is used on ARMv7 and ARMv8 NXP SoCs. To
> > not cause any regression we went this way.
> 
> I don't understand.  Why not just set the priority depending on
> IS_ENABLED(CONFIG_ARM)? 

Argh.. you're right. I had something other in my mind, sry.

> That way it's strictly better than the Kconfig patch:
> 
> 1) If the driver is indeed slower then you'd have achieved the same
> result of preferring the non-driver algorithm.
> 
> 2) If the driver ends up being faster then at least the admin can
> adjust the priorities.
> 
> Or perhaps your Kconfig option should set the priority.

NACK since no admin knows the prios. I will go with the "IS_ENABLED"
solution, thank you!

Regards,
  Marco

> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
