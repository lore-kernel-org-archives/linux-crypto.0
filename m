From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: RSA support into kernel?
Date: Sat, 7 Jul 2007 00:01:09 +0800
Message-ID: <20070706160109.GA31203@gondor.apana.org.au>
References: <20070706.040533.30182871.davem@davemloft.net> <E1I6ncC-0007e3-00@gondolin.me.apana.org.au> <20070706133636.GH23191@halcrow.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, johnpol@2ka.mipt.ru,
	gautam.singaraju@gmail.com, linux-crypto@vger.kernel.org
To: Michael Halcrow <mike@halcrow.us>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4567 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752787AbXGFQBV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jul 2007 12:01:21 -0400
Content-Disposition: inline
In-Reply-To: <20070706133636.GH23191@halcrow.us>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 06, 2007 at 08:36:37AM -0500, Michael Halcrow wrote:
>
> eCryptfs uses RSA.
> 
> Right now it has to defer to a userspace daemon to perform the
> operation.

OK that'd be the most convincing case for me then.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
