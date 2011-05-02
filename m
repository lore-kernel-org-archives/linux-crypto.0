From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: caam - handle interrupt lines shared
	across rings
Date: Tue, 3 May 2011 09:56:02 +1000
Message-ID: <20110502235602.GA26670@gondor.apana.org.au>
References: <20110411191516.bae0454e.kim.phillips@freescale.com> <20110415095049.GA2129@gondor.apana.org.au> <20110502182727.366857bd.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	Steve Cornelius <sec@pobox.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56631 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1EBX4R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2011 19:56:17 -0400
Content-Disposition: inline
In-Reply-To: <20110502182727.366857bd.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 02, 2011 at 06:27:27PM -0500, Kim Phillips wrote:
>
> I don't see them in cryptodev-2.6 - did you forget to push them?

Indeed, they were stuck on my other machine.  They should be on
master now and should show up on the public mirror soon.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
