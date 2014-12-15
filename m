From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: Mon, 15 Dec 2014 11:46:15 +0100
Message-ID: <3548771.c3zGADVhRW@tachyon.chronox.de>
References: <20141215102149.18731.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55066 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaLOKqY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2014 05:46:24 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SC565> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 15 Dec 2014 11:46:15 +0100
In-Reply-To: <20141215102149.18731.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 15. Dezember 2014, 05:21:49 schrieb George Spelvin:

Hi George,

> > Ah, now I see it. Yes, all AES 128 are covered.
> > 
> > What about AES 192 and 256?
> 
> The implementation doesn't support them, and I didn't add them.

Sorry, my bad.  :-)

Then, I think the updated implementation matches with the spec.
> 
> It would require either:
> * Trickery based on the supplied seed length, which would conflict
>   with the existing optional-DT support, or
> * A separate crypto_alg for the different key (and therefore seed) sizes.


-- 
Ciao
Stephan
