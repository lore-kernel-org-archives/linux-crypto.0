From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1 take 2] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 22 Jun 2007 15:57:26 +0400
Message-ID: <20070622115726.GA29425@2ka.mipt.ru>
References: <20070604134248.GA9645@2ka.mipt.ru> <20070622072844.GA27341@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43042 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbXFVL6M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 07:58:12 -0400
Content-Disposition: inline
In-Reply-To: <20070622072844.GA27341@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert.

On Fri, Jun 22, 2007 at 03:28:44PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > +	 * Actually I need to think about how to handle the case, when queue is full.
> > +	 * So far error (-EINVAL) is returned.
> > +	 */
> 
> OK you need to provide a software queue here.  Since you already
> have a hardware queue, you may choose to have a queue with a
> (advisory) maximum length of zero.  However, a queue is still
> necessary since requests with the MAY_BACKLOG flag must never
> be discarded.
> 
> This is (or will be) used by users such as dm-crypt that must be
> able to add at least one request but can throttle themselves
> afterwards .

What will prevent crypto user from filling that queue with crypto
requests more and more when hardware is not capable to work with such
rate?

-- 
	Evgeniy Polyakov
