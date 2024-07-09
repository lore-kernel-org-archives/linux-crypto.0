Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F235715358A
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jul 2024 08:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720515307; cv=none; b=aluTJjLNGUJv92nWAydyjOOZH7MJxoglFRnXaVEy/+5bbJzwN62iowTSszSQmHrk4zzi8vrUXnZG+DocGGbNZej23z04Gr0Mk/UHJwINosysRxBvFuZ/oUZVn8qoDVGY1etDHSsj6SzpcYfqtSPSaTe2tBAX5vjYK5ZyeDzZzkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720515307; c=relaxed/simple;
	bh=2FYVMtmDzIZUKIJ+dabrFKImBJRSm71ljP7ZDyoecE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LiMtfe9SDy2xrKzfdI8aYFx5octx2DWRFiDsdUG1eWTxvLTkL72f00O9XaKtRUqf+1kAMPjzgfhqON68bYwTIDPbtyEVm/w3chilvOrozCmWf8pT+YeQybsOii1UUEW40EkWw7jRU+UmQihfr23oHxnBOsBP6Y+krArZNV1BXeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mfe@pengutronix.de>)
	id 1sR6cj-0001sa-Fu; Tue, 09 Jul 2024 10:54:57 +0200
Received: from [2a0a:edc0:2:b01:1d::c5] (helo=pty.whiteo.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <mfe@pengutronix.de>)
	id 1sR6cg-008F2O-FK; Tue, 09 Jul 2024 10:54:54 +0200
Received: from mfe by pty.whiteo.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <mfe@pengutronix.de>)
	id 1sR6cg-006TZB-1F;
	Tue, 09 Jul 2024 10:54:54 +0200
Date: Tue, 9 Jul 2024 10:54:54 +0200
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
Message-ID: <20240709085454.you3b3ueb3xbtrv6@pengutronix.de>
References: <20240626155724.4045056-1-m.felsch@pengutronix.de>
 <258feb43-382d-4ea0-9164-357924350dec@nxp.com>
 <ZofSbH2Fu/xLnzif@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZofSbH2Fu/xLnzif@gondor.apana.org.au>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org

On 24-07-05, Herbert Xu wrote:
> On Fri, Jul 05, 2024 at 09:39:19AM +0000, Horia Geanta wrote:
> >
> > I disagree with compiling out the hash support.

We don't compile it out, we just don't set the default=y since on ARMv8
it's not required.

> > If needed, algorithm priority could be changed - even at runtime,
> > using NETLINK_CRYPTO messages (needs CONFIG_CRYPTO_USER=y/m).
> 
> We should change the default priority.

We had an patch exactly doing this but depending on the SoC the default
prio may valid since the CAAM is used on ARMv7 and ARMv8 NXP SoCs. To
not cause any regression we went this way.

Regards,
  Marco

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
