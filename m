From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [CRYPTO] cast6: inline bloat--
Date: Thu, 10 Jan 2008 04:03:43 +0100
Message-ID: <p73ve62nzzk.fsf@bingen.suse.de>
References: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:43895 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbYAJDDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Jan 2008 22:03:45 -0500
In-Reply-To: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi>
 ("Ilpo =?iso-8859-1?Q?J=E4rvinen=22's?= message of "Mon\, 7 Jan 2008
 15\:40\:58 +0200 \(EET\)")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

"Ilpo J=E4rvinen" <ilpo.jarvinen@helsinki.fi> writes:

> Bloat-o-meter shows rather high readings for cast6...

Have you measured if the performance doesn't suffer from that
change? Inner loops of ciphers tend to be quite performance
sensitive and the inlines might actually help a lot.=20

On the other hand setkey is probably not as sensitive.

-Andi
