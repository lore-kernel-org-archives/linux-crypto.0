From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 2] HIFN 795x driver.
Date: Fri, 5 Oct 2007 16:18:56 +0800
Message-ID: <20071005081856.GA10799@gondor.apana.org.au>
References: <20071002150013.GA6023@2ka.mipt.ru> <20071002190512.GA8761@Chamillionaire.breakpoint.cc> <20071003084118.GA19117@2ka.mipt.ru> <20071003115405.GA8920@gondor.apana.org.au> <20071003120518.GA20250@2ka.mipt.ru> <20071004054923.GA16226@gondor.apana.org.au> <20071004092218.GA23613@2ka.mipt.ru> <20071004100414.GA24602@gondor.apana.org.au> <20071004150453.GA16027@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1476 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751765AbXJEITB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Oct 2007 04:19:01 -0400
Content-Disposition: inline
In-Reply-To: <20071004150453.GA16027@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 04, 2007 at 07:04:53PM +0400, Evgeniy Polyakov wrote:
>
> It just can not be used in asynchronous hardware, so I will create
> soemthing new for HIFN driver specially.

That sounds good.  We can put it into ablkcipher.c and then get
rid of the phys stuff from blkcipher.c.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
