From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 2] HIFN 795x driver.
Date: Wed, 3 Oct 2007 19:54:05 +0800
Message-ID: <20071003115405.GA8920@gondor.apana.org.au>
References: <20071002150013.GA6023@2ka.mipt.ru> <20071002190512.GA8761@Chamillionaire.breakpoint.cc> <20071003084118.GA19117@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1341 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755482AbXJCLyI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Oct 2007 07:54:08 -0400
Content-Disposition: inline
In-Reply-To: <20071003084118.GA19117@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Evgeniy:

On Wed, Oct 03, 2007 at 12:41:19PM +0400, Evgeniy Polyakov wrote:
>
> It has to be multiple of blocksize. I.e. it is impossible to 
> crypt one byte - hardware will stall, DES test provides two bytes as
> input - this will not work. If that is going to be handled in driver,
> then it will relocate. I'm not sure it is the right decision.

Right.  However you can't force the user to give you data that's
always layed out in blocks.  For example, an IP fragment might give
you an sg element that's only half an AES block.

You should either use the blkcipher walking helpers to avoid
this or do your own copying when you detect that you have a
partial block in an sg element.

Also, the MAY_BACKLOG option must be implemented or dm-crypt
won't work properly.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
