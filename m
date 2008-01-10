From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [CRYPTO] cast6: inline bloat--
Date: Thu, 10 Jan 2008 10:25:55 +0100
Message-ID: <20080110092555.GB25076@one.firstfloor.org>
References: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi> <p73ve62nzzk.fsf@bingen.suse.de> <Pine.LNX.4.64.0801101114070.1408@kivilampi-30.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andi Kleen <andi@firstfloor.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:39612 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbYAJJXU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2008 04:23:20 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801101114070.1408@kivilampi-30.cs.helsinki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 10, 2008 at 11:17:10AM +0200, Ilpo J=E4rvinen wrote:
> On Thu, 10 Jan 2008, Andi Kleen wrote:
>=20
> > "Ilpo J=E4rvinen" <ilpo.jarvinen@helsinki.fi> writes:
> >=20
> > > Bloat-o-meter shows rather high readings for cast6...
> >=20
> > Have you measured if the performance doesn't suffer from that
> > change? Inner loops of ciphers tend to be quite performance
> > sensitive and the inlines might actually help a lot.=20
>=20
> No, I haven't measured.

Then I don't think the patch should have been applied.

-Andi
