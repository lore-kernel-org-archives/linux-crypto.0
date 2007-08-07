From: Herbert Xu <herbert.xu@redhat.com>
Subject: Re: status of async crypto
Date: Tue, 7 Aug 2007 16:04:47 +0800
Message-ID: <20070807080447.GB27969@gondor.apana.org.au>
References: <B9FFC3F97441D04093A504CEA31B7C4101AA3B33@msilexch01.marvell.com> <E1IIJVg-0007RB-00@gondolin.me.apana.org.au> <20070807080110.GA12182@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ronen Shitrit <rshitrit@marvell.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1569 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754523AbXHGIEt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Aug 2007 04:04:49 -0400
Content-Disposition: inline
In-Reply-To: <20070807080110.GA12182@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 07, 2007 at 10:01:10AM +0200, Sebastian Siewior wrote:
> * Herbert Xu | 2007-08-07 15:29:44 [+0800]:
> 
> >Joy Latten is looking
> >at CTR, as well as converting IPsec over once the crypto
> >infrastructure is done.
> Can you estimate/guesstimate when the IPsec over async crypto will be
> available?
> I tried to test the dm-crypt user but the patches don't apply on top of
> current git.

Originally I was going to convert IPsec to use ablkcipher
which we can do right now.

This is certainly going to delay things a bit.  However,
it's certainly pretty close to the top of my todo list
right now.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
