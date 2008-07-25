From: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: crypto stuff broken in -mm?
Date: Fri, 25 Jul 2008 03:28:35 +0200
Message-ID: <874p6eg3b0.fsf@saeurebad.de>
References: <87ljzwh3j3.fsf@saeurebad.de>
	<20080724074306.GA5071@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from saeurebad.de ([85.214.36.134]:47041 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbYGYB3A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Jul 2008 21:29:00 -0400
In-Reply-To: <20080724074306.GA5071@gondor.apana.org.au> (Herbert Xu's message
	of "Thu, 24 Jul 2008 15:43:06 +0800")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Sun, Jul 20, 2008 at 05:24:48PM +0000, Johannes Weiner wrote:
>> 
>> I can not access my encrypted partitions with -mm while they work with
>> mainline.
>> 
>> For both trees I have similar configs, I didn't change anything relative
>> to this subsystem:
>
> I can't reproduce this problem here.  I've created an encrypted
> volume with 2.6.23 and it still decrypts correctly with the latest
> upstream Linux kernel which has all the crypto updates.
>
> So it looks like one of the other patches in mm that's causing
> this.  Please try backing out any device mapper related changes
> and see if things improve.

It works with next-20080724.

	Hannes
