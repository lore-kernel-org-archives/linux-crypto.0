From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 2] HIFN 795x driver.
Date: Thu, 4 Oct 2007 18:04:14 +0800
Message-ID: <20071004100414.GA24602@gondor.apana.org.au>
References: <20071002150013.GA6023@2ka.mipt.ru> <20071002190512.GA8761@Chamillionaire.breakpoint.cc> <20071003084118.GA19117@2ka.mipt.ru> <20071003115405.GA8920@gondor.apana.org.au> <20071003120518.GA20250@2ka.mipt.ru> <20071004054923.GA16226@gondor.apana.org.au> <20071004092218.GA23613@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2840 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756129AbXJDKEQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 06:04:16 -0400
Content-Disposition: inline
In-Reply-To: <20071004092218.GA23613@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 04, 2007 at 01:22:20PM +0400, Evgeniy Polyakov wrote:
>
> I use ablkcipher_enqueue_request() when hardware can not handle new
> request, so this should be ok.

Good point.  I missed that.  So there is no problem with the
backlog case.

But we still need to fix the partial block case.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
