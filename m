From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] an XTS blockcipher mode implementation without partial blocks
Date: Fri, 7 Sep 2007 14:19:05 +0800
Message-ID: <20070907061905.GA31811@gondor.apana.org.au>
References: <11888559161619-git-send-email-rsnel@cube.dyndns.org> <20070905002906.GA6930@Chamillionaire.breakpoint.cc> <20070906145726.GA30421@cube.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, christoph.sievers@gmail.com
To: rsnel@cube.dyndns.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1523 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751227AbXIGGTT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Sep 2007 02:19:19 -0400
Content-Disposition: inline
In-Reply-To: <20070906145726.GA30421@cube.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 06, 2007 at 04:57:26PM +0200, rsnel@cube.dyndns.org wrote:
>
> I'd rather tell the compiler what I want than to introduce a new local
> variable and a conditional branch in the hope that the compiler will
> optimize it away, just to avoid a goto.

Yes this code looks OK to me.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
