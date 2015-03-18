From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: core - allow perfect entropy from hardware devices
Date: Wed, 18 Mar 2015 21:02:12 +1100
Message-ID: <20150318100211.GA23154@gondor.apana.org.au>
References: <1426663020-10646-1-git-send-email-keithp@keithp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
To: Keith Packard <keithp@keithp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:49567 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbbCRKCU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 06:02:20 -0400
Content-Disposition: inline
In-Reply-To: <1426663020-10646-1-git-send-email-keithp@keithp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 18, 2015 at 12:17:00AM -0700, Keith Packard wrote:
> Hardware random number quality is measured from 0 (no entropy) to 1024
> (perfect entropy). Allow hardware devices to assert the full range by
> truncating the device-provided value at 1024 instead of 1023.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

Patch applied.  Thanks Keith!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
