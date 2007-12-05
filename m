From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] salsa20_i586: Salsa20 stream cipher algorithm (i586 version)
Date: Thu, 6 Dec 2007 10:51:58 +1100
Message-ID: <20071205235158.GA26184@gondor.apana.org.au>
References: <fd3e431c0712051231h44c7bc6epa2f526116cf2c47@mail.gmail.com> <20071205214947.GA20246@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Tan Swee Heng <thesweeheng@gmail.com>,
	Linux Crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3665 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754211AbXLEXwB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Dec 2007 18:52:01 -0500
Content-Disposition: inline
In-Reply-To: <20071205214947.GA20246@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 05, 2007 at 10:49:47PM +0100, Sebastian Siewior wrote:
>
> Besides that, I saw the keysetup routine is also included in assembly.
> Is the computed key any different from the C version? *I* would prefer
> to share the keysetup code with the C version because it is not a
> performace critical part.

I agree.  But we can add the patch first and fix this up later :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
