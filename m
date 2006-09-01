From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: LRW implementation, please comment
Date: Fri, 1 Sep 2006 13:52:25 +1000
Message-ID: <20060901035225.GA9547@gondor.apana.org.au>
References: <11570279761772-git-send-email-rsnel@cube.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47110 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1751097AbWIADwY
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Aug 2006 23:52:24 -0400
To: Rik Snel <rsnel@cube.dyndns.org>
Content-Disposition: inline
In-Reply-To: <11570279761772-git-send-email-rsnel@cube.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Rik:

On Thu, Aug 31, 2006 at 02:39:30PM +0200, Rik Snel wrote:
> 
> This is an attempt at implementing LRW for the new blockcipher API.
> Please review, test and comment. 

Thanks a lot for doing this.  It looks good to me.

There are a few style (see Documentation/CodingStyle) issues.  It would
be good if you can fix them up before I apply the patches.

Could you also convert the test vectors to use tcrypt.h/tcrypt.c?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
