From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: 15 Dec 2014 05:21:49 -0500
Message-ID: <20141215102149.18731.qmail@ns.horizon.com>
References: <59132781.BjOB5k2teW@tauon>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:53434 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751136AbaLOKVu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2014 05:21:50 -0500
In-Reply-To: <59132781.BjOB5k2teW@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Ah, now I see it. Yes, all AES 128 are covered.
> 
> What about AES 192 and 256?

The implementation doesn't support them, and I didn't add them.

It would require either:
* Trickery based on the supplied seed length, which would conflict
  with the existing optional-DT support, or
* A separate crypto_alg for the different key (and therefore seed) sizes.
