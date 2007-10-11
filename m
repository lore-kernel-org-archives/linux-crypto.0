From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] consider keysize in algorithm selection
Date: Thu, 11 Oct 2007 21:44:26 +0800
Message-ID: <20071011134426.GA21587@gondor.apana.org.au>
References: <20071010164400.GA19471@Chamillionaire.breakpoint.cc> <20071011114700.GA17801@gondor.apana.org.au> <20071011124314.GA28993@Chamillionaire.breakpoint.cc> <20071011130140.GA20363@gondor.apana.org.au> <20071011132848.GB28993@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org, Jan Glauber <jan.glauber@de.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1157 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751820AbXJKNoh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Oct 2007 09:44:37 -0400
Content-Disposition: inline
In-Reply-To: <20071011132848.GB28993@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 11, 2007 at 03:28:48PM +0200, Sebastian Siewior wrote:
>
> It is possible that future machines will support 192 and 256 key sizes
> as well but what do I know, I don't work there :) Anyway even if they
> support all key sizes at later time you have still those who don't. On
> the other hand the customers maybe don't even care / use it :)

OK they'll get the fallback treatment then :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
