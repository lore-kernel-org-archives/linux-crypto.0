Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA0130ACF0;
	Fri,  3 Jul 2026 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783100660; cv=none; b=MzQq/71zGE09RZsnHp8qIrlkV/C/Rei2kUlL5ErUQfusW/0dn9lztjZ4ZQN2Sm7h2ziI3cSMk7peSCEFtI0KJNbora4yNZZA6FoHlrupwwk/SJVylnQgQ6pSqZYeZWfegIZAKwUkcnV5YwZzy+0zgYybso6SLReSsRbz3YBT/Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783100660; c=relaxed/simple;
	bh=gFIukhiVqdc2oGHTdI29xB+FBZ50F4expIT8PIJDGpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RMzIOu5OR/si0bpXFcODjxNugWy3JYj+N/dZ0mzog0Zar25XEPUpiiPHv8B9GVDpL9aoIMTeMPmuZLsK2x0KWkuECSxIynoflcQeI5yYJirOJk4NVhiGs9yRand3KPBFvb/a7SixM1Ehjc+rPIc9yNZ56ErkFytMiP4ew1t5OvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=AER26POh reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="AER26POh"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 368BA40E016E;
	Fri,  3 Jul 2026 17:44:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id tYAsjIcOe3SX; Fri,  3 Jul 2026 17:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1783100642; bh=baoM9LmL+yNRwup1m9/MkDZrWOzJs0V9dZ8uysWghkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AER26POhMaJr0VZ5Lv/pbdWQwsLK0khO7YbzkL8vbhNv1flQ+g2spYFPR9L6Z8G+6
	 0c6yTd3HQmx6+NDDBuN3EDLWDFEaZsfqCGg9+LPvTJtcGM+zZy8FpdgO5ppmhNQtY5
	 bWY9c3Ed+3IA72RjU4cFNjb3U0n2HkOYhhh5XKIc1fNwTMgVfTQfwYj/ceDnU/S6Hx
	 DF2nes/JGeTTVZZNv+qkEzPNUcfl2SN6uNPHGda0ysyNFJfH+tdu59yKsPg/+aN8tn
	 Axpeozl1O2ZF8tz/JT2CKSOV3DREs+aCU8RYDXYHRmpY4N541nBwwHW49aB3bV11bJ
	 6xSho97WsFoHDtmOduM2Kjujl55SjFUxVb/LNSiRPkqSPGS64hrzO/CX7mMgWXw1pB
	 w9D6C9AWrkTC5G1Ro+RHS2NFPMIlR+q8/YBTxqA/k1RotlF4BWIGwOTAcHWiRRlwGG
	 Cq3S8t0ehZ1hp7GBoiDAUojoFAHDCLUj5cymjp8ZipCHPVq/GGiOR1LF++M2HEp6ym
	 EL1SgEk8r19k3RnOtaeEvpiHKh2orbgoH7gVLHiRpc9dSj8jeQFRkwgSIIwxmz6rVX
	 mX8FTredRh1ZuinpHgRaeYLADaEbwz88XzFvDKuv0gHTGEzKZb6jRK5rZo7hSFO1BT
	 zF1KndBi2XnjE+wjW9XpGPzQ=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 479CA40E01D8;
	Fri,  3 Jul 2026 17:43:49 +0000 (UTC)
Date: Fri, 3 Jul 2026 10:43:46 -0700
From: Borislav Petkov <bp@alien8.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mark Gross <markgross@kernel.org>,
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
	linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v3] MAINTAINERS: Drop Mark Gross
Message-ID: <20260703174346.GEakf00gE1PzqA7fwA@fat_crate.local>
References: <20260703173803.3589003-2-ukleinek@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260703173803.3589003-2-ukleinek@kernel.org>
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 03, 2026 at 07:38:03PM +0200, Uwe Kleine-K=C3=B6nig wrote:
> Sending mail to Mark's Intel address results in the intel mail
> server rejecting the mail. Dave Hansen confirmed he left Intel.
> The kernel.org address seems to work, but there was no reply from Mark
> on the discussion about broken email settings and his maintainer
> entries.
>=20
> So drop him from all maintainer entries.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <ukleinek@kernel.org>
> ---
> Hello,
>=20
> this patch was already send end of May (v1 @
> https://lore.kernel.org/all/20260526173806.3227828-2-ukleinek@kernel.or=
g).
> Konstantin then suggested to change the maintainer contacts to the
> kernel.org address as at least one of the forward-addresses for the
> kernel.org account didn't bounce. This v2
> (https://lore.kernel.org/all/20260526193238.3622176-2-ukleinek@kernel.o=
rg)
> wasn't picked up yet, but given the continued silence I think removing
> Mark completely is the saner choice now.
>=20
> If someone has a better contact, please make him react. If he returns
> later, the entries can easily get restored.
>=20
> Best regards
> Uwe
>=20
>  MAINTAINERS | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Applied, thanks.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
