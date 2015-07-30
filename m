From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix rfc4106 encap shared descriptor
Date: Thu, 30 Jul 2015 21:46:18 +0800
Message-ID: <20150730134618.GA17539@gondor.apana.org.au>
References: <1438263566-22222-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Tudor Ambarus <tudor.ambarus@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39533 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbbG3NqX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 09:46:23 -0400
Content-Disposition: inline
In-Reply-To: <1438263566-22222-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 30, 2015 at 04:39:26PM +0300, Horia Geant=C4=83 wrote:
> The encap shared descriptor was changed to use the new IV convention.
> In the process some commands were shifted, making the output length
> zero, caam effectively writing garbage in dst.

Thanks.

> While here, update the decap descriptor to execute the "write" comman=
ds
> before the "read"s (as it previously was).
> This makes sure the input fifo is drained before becoming full.

Actually, I deliberately did it that way because there was an errata
which said that doing a skipping load concurrently with a skipping
store may cause a hang.  Is this not the case?

Cheers,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
