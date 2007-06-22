From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [1/1 take 2] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 22 Jun 2007 14:29:48 +0200
Message-ID: <20070622122948.GA28000@Chamillionaire.breakpoint.cc>
References: <20070604134248.GA9645@2ka.mipt.ru> <20070622072844.GA27341@gondor.apana.org.au> <20070622115726.GA29425@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34417 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987AbXFVM3x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 08:29:53 -0400
Content-Disposition: inline
In-Reply-To: <20070622115726.GA29425@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Evgeniy Polyakov | 2007-06-22 15:57:26 [+0400]:

>On Fri, Jun 22, 2007 at 03:28:44PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
>> > +	 * Actually I need to think about how to handle the case, when queue is full.
>> > +	 * So far error (-EINVAL) is returned.
>> > +	 */
>> 
>> OK you need to provide a software queue here.  Since you already
>> have a hardware queue, you may choose to have a queue with a
>> (advisory) maximum length of zero.  However, a queue is still
>> necessary since requests with the MAY_BACKLOG flag must never
>> be discarded.
>> 
>> This is (or will be) used by users such as dm-crypt that must be
>> able to add at least one request but can throttle themselves
>> afterwards .
>
>What will prevent crypto user from filling that queue with crypto
>requests more and more when hardware is not capable to work with such
>rate?

Nothing, the hw signalizes with -EBUSY such a state and the crypto user
has to slow down.
If the crypto user continues such a behavior, the system will go OOM
(this is atleast my understanding).

>-- 
>	Evgeniy Polyakov
Sebastian
