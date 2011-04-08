From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: aead: driver side documentation
Date: Fri, 8 Apr 2011 08:55:33 +0800
Message-ID: <20110408005533.GA14581@gondor.apana.org.au>
References: <20110405192129.d2778dec.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: phil@nwl.cc, linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:52366 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab1DHCAT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Apr 2011 22:00:19 -0400
Content-Disposition: inline
In-Reply-To: <20110405192129.d2778dec.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kim Phillips <kim.phillips@freescale.com> wrote:
>
> I started to add test vectors from [1] to crypto/testmgr.c, but it
> required that drivers not assume associated data, iv, and cipher data
> were contiguous in memory, and since some of them do, I don't know if
> such a contribution would be acceptable upstream.

Such drivers are broken and should be fixed.

> then there's the rtnetlink dependencies I mention in [2] that
> also make drivers fail AEAD testmgr tests in their setkey()
> implementations, IIRC, because testmgr keys aren't RTA_OK.

Can you elaborate on this problem?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
