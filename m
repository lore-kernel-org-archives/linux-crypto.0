From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Bogus sha1 implementation in crypto4xx
Date: Tue, 14 Jul 2009 22:43:44 +0800
Message-ID: <20090714144344.GB12160@gondor.apana.org.au>
References: <20090714130600.GA11081@gondor.apana.org.au> <20090714134629.GI20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Hsiao <jhsiao@amcc.com>, Shasi Pulijala <spulijala@amcc.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47111 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754817AbZGNOnt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2009 10:43:49 -0400
Content-Disposition: inline
In-Reply-To: <20090714134629.GI20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 14, 2009 at 03:46:29PM +0200, Steffen Klassert wrote:
>
> As I pointed out already, I'm working on converting IPsec to ahash too.
> So perhaps we can share the work to do not all the work twice.
> I have ahash versions of authenc and ah4/ah6. The authenc ahash version
> needs a hack in esp to be able to chain all scatterlist in authenc and I
> wanted to look over it again before I post. 
> 
> Today I finished with ah4/ah6. This needs still some tests but I could post
> these two in the next days if you have not converted them it yet.

Sure, go ahead.  I'm still redoing the ahash infrastructure to
properly support finup and export/import.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
